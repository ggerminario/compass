/**
 * @File Name          : PV2564AzzeramentoSpeseLista.cls
 * @Description        : 
 * @Author             : Andrea Vanelli
 * @Group              : 
 * @Last Modified By   : Federico Negro
 * @Last Modified On   : 17/1/2020, 16:58:30
 * @Modification Log   : 
 *==============================================================================
 * Ver         Date                     Author      		      Modification
 *==============================================================================
 * 1.0    3/8/2019, 23:01:55   Andrea Vanelli     Initial Version
**/

public class PV2564AzzeramentoSpeseLista {

    @AuraEnabled
    public static OCSRecuperaSpeseAzzeraRecInvoker.Response recuperaSpeseAzzeramentoRecupero(String numPratica, String tipoPratica, Id caseId){
		OCSRecuperaSpeseAzzeraRecInvoker.Response res = OCSRecuperaSpeseAzzeraRecInvoker.invoke(numPratica, tipoPratica);
        System.debug('RES : ' + res);
        System.debug('***chiamata effettuate');
        if (caseId != null) {
        	// AV TODO leggere la tabella PostVendita_psv_azzer_sel (sarà da fare in gestione)
            List<OCSRecuperaSpeseAzzeraRecInvoker.SpesaRecuperoDTO> elencoSpese = res.elencoSpese;

            List<psv_azzer_sel__c> speseSelezionate = [SELECT sel_id__c, cod_orig_sel__c FROM psv_azzer_sel__c WHERE codice_case__c =: caseId];
            System.debug('### lunghezza elenco spese: '+elencoSpese.size());   
            System.debug('### lunghezza elenco spese SELEZIONATE: '+speseSelezionate.size()); 
            for (psv_azzer_sel__c spesaSelezionata : speseSelezionate) {
                
                System.debug('***ciclo');
                // converto vecchio id con nuovo id
                // chiamata B2bsoap per sostituire l'id
                //spesaSelezionata.sel_id__c = nuovoID

                String prg = null;
                String tip = '';
                String loanType = '';
                String pratica = null;
                System.debug('### id: ' + spesaSelezionata.sel_id__c);
                loanType = spesaSelezionata.sel_id__c.substring(0,2);
                pratica = (spesaSelezionata.sel_id__c.substring(2,14).trim()); 
                tip = spesaSelezionata.sel_id__c.substring(14,15);
                prg = (spesaSelezionata.sel_id__c.substring(15,24).trim());

                //dati di chiamata
                //OCSRecuperaConvSpeseAzzeraRecInvoker.Request req = new OCSRecuperaConvSpeseAzzeraRecInvoker.Request();
                OCSRecuperaConvSpeseAzzeraRecInvoker.Response risposta = OCSRecuperaConvSpeseAzzeraRecInvoker.invoke(pratica, loanType, tip, prg);
                System.debug('RISPOSTA : ' + risposta);

                if(risposta != null){
                    
                    String prgNew = risposta.getNuovoProgressivo();
                    System.debug('### NUOVO PROG: '+prgNew);
                    
                    if(prgNew != null && prgNew != ''){
                         System.debug('### SONO DENTROOOO');
                        String newID = loanType + pratica.leftPad(12, ' ') + tip + prgNew.leftPad(9, ' ');
                        spesaSelezionata.sel_id__c = newID;
                        System.debug('### NUOVO ID: '+newID);
                    }else{
                        System.debug('### PROGRESSIVO INVARIATO');
                    }
                    
                    for (OCSRecuperaSpeseAzzeraRecInvoker.SpesaRecuperoDTO spesaOrigine : elencoSpese) {
                        if(spesaOrigine.customID.equals(spesaSelezionata.sel_id__c)) {
                            spesaOrigine.selezioneOriginale = 'S';
                            System.debug('### spesa origine custom id: '+spesaOrigine.customID);
                            System.debug('### spesa selezionata sel id: '+spesaSelezionata.sel_id__c);
                        }
                    }

                }
                    
            }

            res.elencoSpese = elencoSpese;

        }

        return res;
    
    }

}