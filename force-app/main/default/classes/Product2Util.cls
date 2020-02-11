public class Product2Util 
{

    public static FINAL String RETENTIONPRODUCTCODE = '2112';
    public static FINAL String AUTONOMI_PLUS = '6297';
    
    public static Product2 getProductForExternalId(String externalId)
    {
        return new Product2(RSS_External_Id__c = externalId);
    }
    public static Product2 prodForCampaign(Id prodId){
        List<Product2> results =  [SELECT Name,RSS_External_Id__c, Parent__r.RSS_External_Id__c FROM Product2 where id =: prodId];
        if (results == null || results.size() == 0) return null;
        return results[0];
    }
    public static List<Product2> prodForCampaign(Set<Id> prodId){
      return [SELECT RSS_External_Id__c, Parent__r.RSS_External_Id__c FROM Product2 where id 
      in: prodId and (Parent__r.RSS_External_Id__c != null or Parent__r.RSS_External_Id__c = null)];
      
    }
    public static List<Product2> prodottiInCampagneDaAgg(List<String> codiceProdottoFiglio, List<String> codiceProdottoPadre){
        return [SELECT Id, RSS_External_Id__c, Parent__r.RSS_External_Id__c 
                        FROM Product2 where RSS_External_Id__c in:codiceProdottoFiglio 
                        and (Parent__r.RSS_External_Id__c in: codiceProdottoPadre or Parent__r.RSS_External_Id__c = null) ];
    }
    public static Product2 getProductFromExternalId(String externalCode)
    {
        return [select id from Product2 Where RSS_External_Id__c =:externalCode ];
    }

}