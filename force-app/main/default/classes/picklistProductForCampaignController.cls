public class picklistProductForCampaignController {
   	@auraEnabled 
    public static List<CRMTelemarketingProductCodes__c> prod(String idcamp){
        Campaign camp = [SELECT RecordType.Name from Campaign where Id =: idcamp];
        String campType = camp.RecordType.Name;
        return [SELECT CodProduct__c, Product__r.Id, Product__r.Name, Product__r.RSS_External_Id__c from CRMTelemarketingProductCodes__c where CampaignType__c =: campType ORDER BY Product__r.Name ASC];      
    }

    @auraEnabled
    public static void updates(String idcamp, String prod){
        system.debug('Update: ' + prod  + ' ' +  idcamp);
        Integer idx = prod.indexOf('|');
        String markProd = prod.substring(0, idx);
        System.debug('Codice prodotto Marketing: ' + markProd);
        String codProd = prod.substring(idx+1, prod.length());
        System.debug('Codice prodotto: ' + codProd);
        Campaign c = [SELECT Id, ProductCode__r.RSS_External_Id__c FROM Campaign where Id =: idcamp];
        c.ProductCode__c = codProd;
        c.TMKProductCode__c = markProd;
        update c;
    }

}