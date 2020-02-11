public without sharing class CRMReclamiInvioRichiestaFeTCtrl {        
    
    @AuraEnabled
    public static Case getReclamo(String reclamoId){
        return [SELECT id, subject, caseNumber, Numero_Reclamo__c, NumeroPratica__c, Referenced_Company__c,
                CreatedDate, LastModifiedDate, Status, Codice_Cliente__c, AccountId, Categoria_Riferimento__c 
                FROM CASE WHERE id =: reclamoId];       
    } 
   

     @AuraEnabled
    public static String  loadMessaggioCTRL(String token){
        return [SELECT messaggio__c FROM XCS_Sites_Token__c where  token__c = :token].messaggio__c;     
    } 
    
    @AuraEnabled
    public static Account getCliente(String accountId){
        Account acc =  [SELECT id, FirstName, LastName,  
                getCodice_Cliente__c , OCS_External_Id__c
                FROM Account WHERE id =: accountId];       
         acc.OCS_External_Id__c = acc.OCS_External_Id__c.replace('C','');
        return acc;
    }     
    
    @AuraEnabled
    public static XCS_Categoria__c getCategoria(String categoriaId){
        XCS_Categoria__c categoria = [select Name, External_Id__c from XCS_Categoria__c where id =: categoriaId];
        return categoria;
    }
    
    //Non serve
    public static List<Attachment> getFiles(String recordId){        
        List<Attachment> allegati = XCSReclamiUtils.documentToAttachment(recordId);
        String sfdcURL = URL.getSalesforceBaseUrl().toExternalForm();
        return allegati;
    }
    
    @AuraEnabled
    public static String makeMessage(String frode, String testoStandard, String testoStandardValue, String firma){
        String underscores = '--------------------------------------------';
        String intestazione = 'Risposta tramite Forward and Track da: ' + firma + '\n';
        //String res = 'Frode: ' + frode + '\n' + 'Testo standard: ' + testoStandard + '\n' + 'Testo selezionato: ' + testoStandardValue;
        String totale = intestazione + '\n' + underscores + '\n';
        System.debug('feed item body: '+totale);
        return totale;
    }
    

    @AuraEnabled
    public static List<CRMReclamiGestioneRispostaLetteraCtrl.ComboBox> loadTesti(XCS_Categoria__c categoria, String societa){
        List<CRMReclamiGestioneRispostaLetteraCtrl.ComboBox> cmbx = CRMReclamiGestioneRispostaLetteraCtrl.loadStdtexts(categoria.External_Id__c,societa);
        return cmbx;      
    } 
    
    @AuraEnabled
    public static String getMessageStandard(String idTesto, Id caseId){
        return CRMReclamiGestioneRispostaLetteraCtrl.getMessageStandard(idTesto, caseId);
    }
    
    
    
    @AuraEnabled
    public static void fileUpload(Case myCase, List<Attachment> allegati){
        XCSReclamiUtils.createFile(allegati, myCase.Id);
    }
    
    @AuraEnabled
    public static String  finalConfirm(Case myCase, String frode, String testoStandard, String testoStandardValue, String firma, 
                                    List<Attachment> allegati, Integer allegatiOriginali, String messaggio)
    {   
        List<Id> listaDocumentId = new List<Id>();
        if(allegati.size() > 0){ 
            system.debug('@@@finalConfirm');
            listaDocumentId = XCSReclamiUtils.createFile(allegati, myCase.Id);
        }
        List<String> documentIdList = new List<String>();
        System.debug('@@@@@@@' + allegati);
       	 for(Attachment attach : allegati){ 
                if(attach.Description != null){
                    String documentId = attach.Description.split('=').get(0);
                    if(!documentIdList.contains(documentId)){
                        documentIdList.add(documentId);             
                    }
                }
            }
        System.debug('');
        String concatDocumentId = String.join(listaDocumentId,',');
        String testo = makeMessage(frode,testoStandard,testoStandardValue, firma);   
        myCase.status='F&T Updated';
       XCSReclamiUtils.Corrispondenza corr = new XCSReclamiUtils.Corrispondenza(myCase, testo, listaDocumentId);
      
        Create_Feed_Item__e myEvent = new Create_Feed_Item__e(
            UtenteId__c = UserInfo.getUserId(),
            Messaggio__c = testo+'\n'+messaggio,
            Title__c = 'Corrispondenza',
        	recordId__c = myCase.id,
            Lista_File__c = concatDocumentId
        	);

        Database.SaveResult sr = EventBus.publish(myEvent);
        
        System.debug('feed item publish result: '+sr.isSuccess());
      

        if (sr.isSuccess()) {
            System.debug('Successfully published event.');
            update myCase; 
            
            //TODO: bruciare token
             SitesTokenUtil.burnToken(myCase.Id);
         
      
        } else {
            for(Database.Error err : sr.getErrors()) {
                System.debug('Error returned: ' +
                             err.getStatusCode() +
                             ' - ' +
                             err.getMessage());
            }
           
        }
      
      
      

                    
        //TODO: bruciare token
       // SitesTokenUtil.burnToken(myCase.Id);
          //String testo = makeMessage(frode,testoStandard,testoStandardValue, firma);   
          //XCSReclamiUtils.creaCorrispondenzaBySite(myCase,testo,allegati, ); 
       return JSON.serialize(corr)+' '+sr.isSuccess();
    } 
    
    public class ErrorException extends Exception{}
    
    @AuraEnabled
    public static string getUserName(){
        return Userinfo.getName();
    }  
    
 
}