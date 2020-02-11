public class Filter_Disposition_QueueCtrl{

    @AuraEnabled
    public static Map<String,String> getSelectedDisposition( String queue ){
        Map<String,String> mapDispQueue = new Map<String,String>();
        System.debug('----- Filter_Disposition_QueueCtrl.getSelectedDisposition ------ START');
        List<Filter_Disposition_Queue__mdt> filter = [select Id, DeveloperName, Root_ExternalId__c, Level1_ExternalId__c, Level2_ExternalId__c, Level3_ExternalId__c, Level4_ExternalId__c, Level5_ExternalId__c, Level6_ExternalId__c 
                                                            FROM Filter_Disposition_Queue__mdt 
                                                            WHERE DeveloperName=:queue];
        System.debug('queue-->'+queue);
        System.debug('filter-->'+filter);
        if(filter!=null && filter.size()==1){
            mapDispQueue.put('rootExternalId',''+filter[0].Root_ExternalId__c);
            mapDispQueue.put('disposition1Preselection',filter[0].Level1_ExternalId__c!=null?filter[0].Level1_ExternalId__c:'');
            mapDispQueue.put('disposition2Preselection',filter[0].Level2_ExternalId__c!=null?filter[0].Level2_ExternalId__c:'');
            mapDispQueue.put('disposition3Preselection',filter[0].Level3_ExternalId__c!=null?filter[0].Level3_ExternalId__c:'');
            mapDispQueue.put('disposition4Preselection',filter[0].Level4_ExternalId__c!=null?filter[0].Level4_ExternalId__c:'');
            mapDispQueue.put('disposition5Preselection',filter[0].Level5_ExternalId__c!=null?filter[0].Level5_ExternalId__c:'');
            mapDispQueue.put('disposition6Preselection',filter[0].Level6_ExternalId__c!=null?filter[0].Level6_ExternalId__c:'');
        } else {
            mapDispQueue.put('rootExternalId','');
            mapDispQueue.put('disposition1Preselection','');
            mapDispQueue.put('disposition2Preselection','');
            mapDispQueue.put('disposition3Preselection','');
            mapDispQueue.put('disposition4Preselection','');
            mapDispQueue.put('disposition5Preselection','');
            mapDispQueue.put('disposition6Preselection','');
        }
        System.debug('----- Filter_Disposition_QueueCtrl.getSelectedDisposition ------ DONE');
        return mapDispQueue;
    }
}