public class ovverideEventEditController {

    @AuraEnabled
    public static event getEvent(String recordId) {
        
        List<event> ev = new List<event>();
        /*ev = [SELECT id, Esito__c, Type, Prodotto__c, Product__r.Name, Customer__r.FirstName, Customer__r.LastName,
                     Customer__r.PersonEmail, Stato_Azione__c, Note__c, Desk__c, Telefono_Cellulare__c, ActivityDateTime,
              		 Desk__r.Branch__c, DurationInMinutes
              FROM Event WHERE id =: recordId];*/
        ev  = [Select Id,Esito__c,Disposition__c, Disposition__r.Name ,Desk__r.Branch__c, Stato_Azione__c, Prodotto__c, Product__r.Name,Product__r.RSS_External_Id__c,Product__r.Parent__c, 
                            Product__r.Parent__r.RSS_External_Id__c, Tipo_Occupazione__c,Customer__c,Customer__r.PersonMobilePhone ,Product__r.Parent__r.Name,
                     		Customer__r.LastName, Note__c, Telefono_Cellulare__c, Customer__r.Provincia_Nascita__pc, Type, Desk__c,
                     		Customer__r.Sesso__pc,Customer__r.Type,ActivityDate,ActivityDateTime,Customer__r.FirstName,
                     		Customer__r.PersonEmail,Customer__r.Phone,DurationInMinutes,Customer__r.Codice_Fiscale__pc
                             FROM Event WHERE id =: recordId];
        
        return ev[0];
    }
    
    @AuraEnabled
    public static Map<String ,Object> getAccountById(String idAccount){
       Map<String ,Object> returnValue = new  Map<String ,Object>();
       returnValue.put('erreur', false);
       try {
       		Account account = AccountService.getFilialeById(idAccount) ;
            returnValue.put('account', account);
        } catch (Exception e) {
            System.debug('errorMessage CreaAppuntamentoController getProvinceCommune '+e.getMessage());
            returnValue.put('erreur', true);
        }
     
        return returnValue;
        
    }
    
    @AuraEnabled
    public static Map<String ,Object> getProduct(String IdProdotto){
        Map<String ,Object> returnValue = new  Map<String ,Object>();
        returnValue.put('erreur', false);
        try {
        	Product2 product= ProdottoService.getProdottoById(IdProdotto);
            returnValue.put('product', product);
            system.debug('DP product: '+product);
        } catch (Exception e) {
            System.debug('errorMessage CreaAppuntamentoController getProduct '+e.getMessage());
            returnValue.put('erreur', true);
        }
        return returnValue;
    }
}