global class SFACommodityCheckDealerUploadBatch extends SFACommodityCheckUploadBatch{
    

    global SFACommodityCheckDealerUploadBatch(String[] colsHeader,String fileName,String timestamp){
        super(colsHeader,fileName,timestamp);
        // setta il batch successivo : controllo case
        nextBatch = new SFACommodityCheckCaseUploadBatch(colsHeader,fileName,timestamp);
    }
 

    //Il dealer sul quale viene creata l'attivita' viene letto dal campo del file:
    //-	COD_CV (per carte e pratiche a consumo PP)
    //-	COD_AG (per pratiche a consumo PAPF)
    //-	COD_DEALER per le variazioni anagrafiche (carte o pratiche a consumo).


    /**
    *
    *  Controlla se esiste sul CRM il Dealer
    */
    global override String check(String[] cols,SFA_ComCheck__c sfacheck){
        Integer indexCOD_DEALER = getIndexHeader(colsHeader,'COD_DEALER'); 
        if (indexCOD_DEALER==-1) {
            // non esiste il dealer nel tracciato: 
            // provo con il codice convenzionato 
            indexCOD_DEALER = getIndexHeader(colsHeader,'COD_CV');
            if (indexCOD_DEALER==-1) {
                // non esiste neanche il convenzionato nel tracciato: 
                // provo con il codice agente
                indexCOD_DEALER = getIndexHeader(colsHeader,'COD_AG');
                if (indexCOD_DEALER==-1) {
                    // non esiste neanche l'agente nel tracciato: 
                    // ci sta un errore nel tracciato
                    return 'Dealer non individuabile';
                }
            }
        }
        String valueCOD_DEALER = cols.get(indexCOD_DEALER);
        valueCOD_DEALER=AccountUtils.getDealerExternalId(valueCOD_DEALER.trim());
        // controllo per COD_DEALER
        List<Account> dealers = [SELECT Id, OCS_External_Id__c FROM Account WHERE RecordType.Developername = 'Dealer' AND OCS_External_Id__c =:valueCOD_DEALER];
        if(dealers!=null && dealers.size()>0) {
            sfacheck.DealerId__c = dealers.get(0).id;
            return OK;
        }
        return 'Dealer ('+valueCOD_DEALER+') non presente';
    }

}