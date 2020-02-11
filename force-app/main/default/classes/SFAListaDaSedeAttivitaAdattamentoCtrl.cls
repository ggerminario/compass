public with sharing class SFAListaDaSedeAttivitaAdattamentoCtrl {
    public static final String RECORD_TYPE_CASE = 'Liste_da_Sede';

    //Disposition level 1
    public static final String POSITIVO = 'Positivo';
    public static final String NEGATIVO = 'Negativo';
    public static final String SOSPESO = 'Sospeso';

    //case status
    public static final String CHIUSO = 'Chiuso';

    @AuraEnabled
    public static Case getCase(Id idCase){
        system.debug('----------------------------------------------------------------------------------');
        system.debug('-- Class Name: SFAListaDaSedeAttivitaAdattamentoCtrl  - Method Name : getCase'); 
        system.debug('-- Variable Name: idCase  - Value: ' + idCase); 

        return [SELECT Id,DealerName__c,CaseNumber,OwnerId,Priority,DueDate__c,ParentId,AccountId, 
        Account.Name,Account.ShippingStreet,Account.ShippingPostalCode,Account.ShippingCity, 
        Account.RecordType.Name,SFA_ListeCaricate__r.Tipo_Attivita__c, 
        Categoria_Riferimento__c,Data_Visibilita__c,Totale__c,Branch__r.Name, 
        Da_Esitare__c,Sospesi_Da_Esitare__c,Categoria_Riferimento__r.Name,Owner.Name, 
        SFA_ListeCaricate__r.Tipo_Attivita__r.Name,SFA_ListeCaricate__r.Tipo_Attivita__r.Descrizione__c,SFA_ListeCaricate__c,SFA_ListeCaricate__r.Nome_Lista__c, 
        SFA_ListeCaricate__r.Tipo_Attivita__r.RSS_External_Id_act_code__c , Status
        FROM Case 
        WHERE Id = :idCase];
    }

    @AuraEnabled
    public static List<Case> getCaseChildList(Id parentCaseId){
        system.debug('----------------------------------------------------------------------------------');
        system.debug('-- Class Name: SFAListadaSedeAttivitaAdattamentoCtrl  - Method Name : getCaseChildList'); 
        system.debug('-- Variable Name: parentCaseId  - Value: ' + parentCaseId); 

        String query = 'SELECT Id,DealerName__c,CaseNumber,OwnerId,Priority,DueDate__c,ParentId,AccountId, ';
        query += 'Account.Name,Account.ShippingStreet,Account.ShippingPostalCode,Account.ShippingCity, ';
        query += 'Account.RecordType.Name,SFA_ListeCaricate__r.Tipo_Attivita__c, ';
        query += 'Categoria_Riferimento__c,Data_Visibilita__c,Totale__c,Branch__r.Name, ';
        query += 'Da_Esitare__c,Sospesi_Da_Esitare__c,Categoria_Riferimento__r.Name,Owner.Name, ';
        //query += 'SFA_ListeCaricate__r.Tipo_Attivita__r.Name,SFA_ListeCaricate__c,SFA_ListeCaricate__r.Nome_Lista__c ';
        query += 'SFA_ListeCaricate__r.Tipo_Attivita__r.Name,SFA_ListeCaricate__r.Tipo_Attivita__r.Descrizione__c,SFA_ListeCaricate__c,SFA_ListeCaricate__r.Nome_Lista__c, ';
        query += 'SFA_ListeCaricate__r.Tipo_Attivita__r.RSS_External_Id_act_code__c ';
        query += 'FROM Case ';
        query += 'WHERE ParentId =: parentCaseId '; 
        query += 'AND Status !=: CHIUSO ';
        query += 'ORDER BY LastModifiedDate DESC NULLS FIRST ';
        return Database.query(query);
    }
    
    @AuraEnabled
    public static List<XCS_dealers_conv_activity_disp__c> getCaseEsitiList(Id caseActivity){
        system.debug('----------------------------------------------------------------------------------');
        system.debug('-- Class Name: SFAListadaSedeAttivitaAdattamentoCtrl  - Method Name : getCaseEsitiList'); 
        system.debug('-- Variable Name: caseActivity  - Value: ' + caseActivity); 
        String query = 'SELECT Id,Codice_Attivita_Lista_da_Sede__c,Esito_1__c,Esito_1__r.Name,Esito_2__c,Esito_2__r.Name,Esito_2__r.External_Id__c,FullDispositionName__c ';
        query += 'FROM XCS_dealers_conv_activity_disp__c ';
        query += 'WHERE Codice_Attivita_Lista_da_Sede__c =: caseActivity ';
        query += 'ORDER BY LastModifiedDate DESC NULLS FIRST ';
        return Database.query(query);
    }

    @AuraEnabled
    public static Boolean setEsitoCase(Case caseSelected, XCS_dealers_conv_activity_disp__c esito, String note){
        
        if(caseSelected!=null && esito!=null){
            //caseSelected.Disposition__c = esito.XCS_Disposition__c;
            caseSelected.Disposition__c = esito.Esito_2__c != null ? esito.Esito_2__c : esito.Esito_1__c;
            system.debug('@@@ LEVEL 2: '+esito.Esito_1__c);
            //if(esito.XCS_Disposition__r.Parent__r.Name != null){
            if(esito.Esito_1__r.Name != null){
                //String level = esito.XCS_Disposition__r.Parent__r.Name;
                String level = esito.Esito_1__r.Name;
                String level2 = (esito.Esito_2__c==null)?'':esito.Esito_2__r.External_Id__c;
               // system.debug('@@@ LEVEL 1: '+level);
                if(level.equalsIgnoreCase(POSITIVO) || level.equalsIgnoreCase(NEGATIVO)){
                    caseSelected.Status = CHIUSO;
                    if (level.equalsIgnoreCase(POSITIVO)) {
                        SFAListaDaSedeAttivitaFilialeController.creaAccolloXSottoscrizioneUtente(caseSelected);
                        if (level2.equalsIgnoreCase(SFAListaDaSedeAttivitaFilialeController.CONVENZION_RIATTIVAZ)) {
                            // Dotti 13-12-2019 : 
                            // Se viene selezionato questo esito, il processo dovra chiudere il case di Lista da Sede e aprire il case di Convenzionamento.
                            SFAListaDaSedeAttivitaFilialeController.creaCaseXConvenzionamento(caseSelected);
                        }
                    }
                }else if(level.equalsIgnoreCase(SOSPESO)){ 
                     caseSelected.Status = SOSPESO;
                }
            }

            if(String.isNotBlank(note)){
                caseSelected.Note__c = note;
            }

            update caseSelected;
            Case parent = getCaseChildInfo(caseSelected);
            system.debug('parent RET: '+parent);
            //update parent;
            return true;
        }

        return false;
    }

    @AuraEnabled
    public static Case getCaseChildInfo(Case parentCase){

        Integer childDaEsitare = 0;
        Integer childSospesiDaEsitare = 0;

        if(parentCase.ParentId!=null){
            //richiamo la funzione per il padre
            Case parent = [
                SELECT Id,Totale__c,Da_Esitare__c,Sospesi_Da_Esitare__c,ParentId,Disposition__c,Disposition__r.Parent__c,Disposition__r.Parent__r.Name
                FROM Case
                WHERE Id =: parentCase.ParentId
            ];
            getCaseChildInfo(parent);
        
        }else{

            List<Case> childCaseList = [
                SELECT Id,Totale__c,Da_Esitare__c,Sospesi_Da_Esitare__c,ParentId,Disposition__c,Disposition__r.Parent__c,Disposition__r.Parent__r.Name 
                FROM Case
                WHERE ParentId =: parentCase.Id
            ];
            if(childCaseList.size() > 0){
                parentCase.Totale__c = childCaseList.size();

                for(Case childCase : childCaseList){

                    if(childCase.Disposition__c == null){
                        childDaEsitare++;
                    }else{

                        if(childCase.Disposition__r.Parent__c != null && childCase.Disposition__r.Parent__r.Name.equalsIgnoreCase(SOSPESO)){
                            childSospesiDaEsitare++;
                        } 
                        
                    }
                    
                }

                parentCase.Da_Esitare__c = childDaEsitare;
                parentCase.Sospesi_Da_Esitare__c = childSospesiDaEsitare;
                if(System.isBatch()){
                    return parentCase;
                }else{

                    Integer childCaseChiusi = [
                        SELECT count() 
                        FROM Case
                        WHERE ParentId =: parentCase.Id AND Status != 'Chiuso'
                    ];

                    if(childCaseChiusi==0){
                        parentCase.Status='Chiuso';
                    }                    
                    update parentCase;
                }
                
            }

        }
        return parentCase;
  
    }

    @AuraEnabled
    public static String getfilialeFromOwnerId(Id ownerId){
        String filiale = [SELECT Name FROM Group WHERE Id =: ownerId].Name;
        return filiale;
    }

    @AuraEnabled
//    public static List<ListView> getListViews(String sName) {
    public static List<ListView> getListViews() {
        Id sId = UserInfo.getUserId();
		Id idProfile = UserInfo.getProfileId();
        
        String sNameProfile = [SELECT Name FROM Profile WHERE Id = :idProfile].Name;
        
        System.debug('sNameProfile -> ' + sNameProfile);
        if(sNameProfile=='System Administrator'){
//            String sFil = [SELECT DefaultQueueId__c FROM user WHERE Id = :sId LIMIT 1].DefaultQueueId__c;
//            String sName = [SELECT Name FROM Group WHERE developername = :sFil LIMIT 1].Name;
            List<ListView> listviews =
                [SELECT Id, Name FROM ListView WHERE SobjectType = 'Case' AND Name = 'All Cases'];
            return listviews;
        }else{
            String sFil = [SELECT DefaultQueueId__c FROM user WHERE Id = :sId LIMIT 1].DefaultQueueId__c;
            String sName = [SELECT Name FROM Group WHERE developername = :sFil LIMIT 1].Name;
            List<ListView> listviews =
                [SELECT Id, Name FROM ListView WHERE SobjectType = 'Case' AND Name = :sName];
            return listviews;
        }
    }
}