//----------------------------------------------------------------------
    //-- - Author       : Aminata GUEYE
    //-- - Date         : 30/09/2019
    //-- - Class  : GUA_GestionCampagnaCnt
    //--------------------------------------------------------------------
public with sharing class GUA_AnnullaChiamateOutboundCnt {
     
     
     @AuraEnabled      
     /**
     * @author Aminata GUEYE
     * @date  30/09/2019
     * @description Method used to get the Campagne Name
     **/
    //get Campaign Name Values
        public static Map<String, Object> getCampName(){
        List<Campaign> names;
        Id recordType=CGMWSUtils_1_0.getRecordTypeId('Campaign','GUA_Unita_Affari_Campagna');
        Map<String,Object> response=new Map<String, Object>();
        response.put('error',false);
        try {
        names = [SELECT Name FROM Campaign where RecordTypeId =:recordType];
        response.put('data',names);

        } catch(Exception e){
        response.put('error',true);
        response.put('message',e.getMessage());
        response.put('cause',e.getCause());
        response.put('stackTrace',e.getStackTraceString());
        }
        system.debug(response);
        return response; 
    }
     /**
     * @author Aminata GUEYE
     * @date  01/10/2019
     * @description Method used to search Case
     **/
     @AuraEnabled
        public static List <Case> fetchCase(String codi, String campagna) {
        list<sobject> records;
        string condition = ''; 
        if(campagna!=null &&  String.isEmpty(codi))  {
        Id recordType=CGMWSUtils_1_0.getRecordTypeId('Case','GUA_Contact');
        String status='New';
        condition= ' And Status=\''+status+'\'';
        condition+= ' And RecordTypeId=\''+recordType+'\'';
        condition+= ' And CampaignId__r.Name =\''+campagna+'\'';
        string query = 'select Id, CodiceDealer__c,CampaignId__r.Name,NumeroPratica__c,CaseNumber from Case where id!=null' + condition;
        system.debug(query);
        records = Database.query(query);
        }   
        if(campagna=='Selezionatutte')  {
            Id recordType=CGMWSUtils_1_0.getRecordTypeId('Case','GUA_Contact');
            String status='New';
            condition= ' And Status=\''+status+'\'';
            condition= ' And RecordTypeId=\''+recordType+'\'';
            string query = 'select Id, CodiceDealer__c,CampaignId__r.Name,NumeroPratica__c,CaseNumber from Case where id!=null' + condition;
            system.debug(query);
            records = Database.query(query);
        }     
        if(campagna !='Selezionatutte' && String.isNotEmpty(codi)){
            Id recordType=CGMWSUtils_1_0.getRecordTypeId('Case','GUA_Contact');
            condition= ' And RecordTypeId=\''+recordType+'\'';
            condition+= ' And CampaignId__r.Name =\''+campagna+'\'';
            condition+= ' And CodiceDealer__c LIKE \'%'+codi+'%\'';
            String status='New';
            condition+= 'And Status=\''+status+'\'';
            string query = 'select Id, CodiceDealer__c,CampaignId__r.Name,NumeroPratica__c,CaseNumber from Case where id!=null ' + condition;
            system.debug(query);
        records = Database.query(query);
        }
       
        return records;
 }


/**
     * @author Sana
     * @date  25/11/2019
     * @description Method used to update  Case selected
     **/
 @AuraEnabled
        public static List<Case> updateCase(List<String> listIdcase ){
            System.debug('--listIdcasqe --'+listIdcase);
             List<Case> listToadd = new List<Case>();
                List<Case> upRec = [SELECT Id,Status,CodiceDealer__c,CampaignId__r.Name,NumeroPratica__c,CaseNumber FROM Case WHERE Id IN: listIdcase ];
            try{
               
                for(Case c: upRec){
                    c.Status='Closed';
                    //listToadd.add(c);
                }
                update upRec;
            }catch(DmlException e){
                //throw exception message
                 System.debug('camp  fail'+upRec); 
                  //System.debug('error update campaign'+ids);
                //throw new AuraHandledException(e.getMessage());
            } 
           return upRec;  
        }
	public class CustomException extends Exception {}
 
}