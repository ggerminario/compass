/**
 * @File Name          : Gua_QueueAssigmentTriggerHandler.cls
 * @Description        : 
 * @Author             : Dieynaba Diallo
 * @CreatedDate        : 25/11/2019
 */
public with sharing class Gua_QueueAssigmentTriggerHandler {
    private boolean m_isExecuting = false;
    private integer BatchSize = 0;
    /*public static boolean IsFromBachJob ;
    public static boolean isFromUploadAPI=false;*/
    
    public Gua_QueueAssigmentTriggerHandler(boolean isExecuting, integer size)
    {
        m_isExecuting = isExecuting;
        BatchSize = size;
    }
            

   public void OnBeforeInsert(List<GUA_Queue_Assigment__c> newQueueAssigments)
    {
        system.debug('Gua_QueueAssigment Trigger On Before Insert');
        List<GUA_Queue_Assigment__c> queueAssignementsToInserts = new List<GUA_Queue_Assigment__c>();

        try {

            Integer i = 0;
            
            for (GUA_Queue_Assigment__c cardQueueAssignement : newQueueAssigments) {
                
                if(cardQueueAssignement.IsActive__c == true) {
                    i++;
                }
            }
			if(i <= 1){

                List<GUA_Queue_Assigment__c> existedQueueAssignements  = [SELECT Id, IsActive__c 
                    FROM GUA_Queue_Assigment__c WHERE IsActive__c = true];

                if(existedQueueAssignements.size() > 0){
                    for (GUA_Queue_Assigment__c existedQueueAssignement : existedQueueAssignements) {
                        existedQueueAssignement.IsActive__c = false;
                        queueAssignementsToInserts.add(existedQueueAssignement);
                    }

                    update queueAssignementsToInserts;

                }
                system.debug('c est okay');
                
            }
            else {
                throw new applicationException('non più di due elementi possono essere aggiunti all\'elenco');
            }
        }
        catch(exception ex) {
            //display custom message
            System.debug('Meassage : '+ex.getMessage());
            System.debug('Cause : '+ex.getCause());
            newQueueAssigments[0].adderror('non più di due elementi possono essere aggiunti all\'elenco');
        }
    }

    public void OnAfterHandle()
    {
        system.debug('Gua_QueueAssigment Trigger On after Insert');
        
        List<Case> casesToUpDate = new List<Case>();
        List<Case> caseToQ281 = new List<Case>();
        List<Case> caseToQ285 = new List<Case>();
        List<Case> caseToQ286 = new List<Case>();
        List<Case> caseToQ287 = new List<Case>();
        Id recordtypeOutbound = Gua_Service.getRecordTypeId('GUA_Contact', 'Case');
        Id recordtypeInbound = Gua_Service.getRecordTypeId('GUA_Inbound', 'Case');
        
       
        Id recordtypeIdBranch = Gua_Service.getRecordTypeId('Branch', 'Account');
        Id recordtypeIdDealer = Gua_Service.getRecordTypeId('Dealer', 'Account');
        List<Case> cases = [SELECT Id, OwnerId, Account.OCSAreaId__c, AccountId, RecordtypeId FROM Case WHERE (RecordtypeId =: recordtypeOutbound OR RecordtypeId =: recordtypeInbound) 
                            AND (Account.RecordtypeId =: recordtypeIdBranch OR Account.RecordtypeId =: recordtypeIdDealer)];
        System.debug('#ad cases '+ JSON.serialize(cases));
  
        List<GUA_Queue_Assigment__c> queueAssignements = [SELECT Id, Q281__c, Q285__c, Q286__c, Q287__c, IsActive__c FROM GUA_Queue_Assigment__c WHERE IsActive__c = true];
        
        if (!queueAssignements.isEmpty()) {
            if (queueAssignements.size() == 1) {
                List<String> q281List = new List<String>();
                List<String> q285List = new List<String>();
                List<String> q286List = new List<String>();
                List<String> q287List = new List<String>();
                GUA_Queue_Assigment__c queueAssignement = queueAssignements[0];
                Map<String, Object> queueAssignementMap = (Map<String, Object>) JSON.deserializeUntyped(JSON.serialize(queueAssignement));
                Set<String> queueAssigkey = queueAssignementMap.keySet();
                if (queueAssigkey.contains('Q281__c')) {
                    q281List =  ((String) queueAssignementMap.get('Q281__c')).split(';');
                }
                if (queueAssigkey.contains('Q285__c')) {
                    q285List = ((String) queueAssignementMap.get('Q285__c')).split(';');
                }
                if (queueAssigkey.contains('Q286__c')) {
                    q286List = ((String) queueAssignementMap.get('Q286__c')).split(';');
                }
                if (queueAssigkey.contains('Q287__c')) {
                    q287List = ((String) queueAssignementMap.get('Q287__c')).split(';');
                }
                for (Case c : cases) {
                    Map<String, Object> caseMap = (Map<String, Object>) JSON.deserializeUntyped(JSON.serialize(c));
                    System.debug('#l caseMap '+ JSON.serialize(caseMap));
                    if (caseMap.keySet().contains('Account')) {
                        System.debug('#l Account '+ JSON.serialize(caseMap.get('Account')));
                        //Account acc = (Account) caseMap.get('Account');
                        Map<String, Object> accMap = (Map<String, Object>) JSON.deserializeUntyped(JSON.serialize(caseMap.get('Account')));
                        if (accMap.keySet().contains('OCSAreaId__c')) {
                            String OCSAreadId = String.valueOf(accMap.get('OCSAreaId__c'));
                            if (q281List.contains(OCSAreadId)) {
                                caseToQ281.add(c);
                            } else if(q285List.contains(OCSAreadId)) {
                                caseToQ285.add(c);
                            } else if(q286List.contains(OCSAreadId)) {
                                caseToQ286.add(c);
                            } else if(q287List.contains(OCSAreadId)) {
                                caseToQ287.add(c);
                            }
                        }
                    }
                }
                List<Group> groupes = [SELECT Id, DeveloperName, Name FROM Group WHERE DeveloperName IN ('Q281', 'Q285', 'Q286', 'Q287') Order BY DeveloperName];
                Map<String, Id> groupeMap = new Map<String, Id>();
                Map<String, String> groupeMap1 = new Map<String, String>();
                for (Group gr : groupes) {
                    groupeMap.put(gr.DeveloperName, gr.Id);
                    groupeMap1.put(gr.DeveloperName, gr.Name);
                }
                System.debug('#l groupeMap keySet '+ groupeMap.keySet());
                System.debug('#l groupeMap '+ JSON.serialize(groupeMap));
                
                if (!q281List.isEmpty()) {
                    if (groupeMap.keySet().contains('Q281')) {
                        for (Case c : caseToQ281) {
                            if(c.RecordtypeId == recordtypeOutbound){
                                c.OwnerId = groupeMap.get('Q281');
                            }
                            else if(c.RecordtypeId == recordtypeInbound){
                                c.UA_InboundOwnerName__c = groupeMap1.get('Q281');
                            }
                            casesToUpDate.add(c);
                        }
                    }                        
                }
                if (!q285List.isEmpty()) {
                    if (groupeMap.keySet().contains('Q285')) {
                        for (Case c : caseToQ285) {
                            if(c.RecordtypeId == recordtypeOutbound){
                                c.OwnerId = groupeMap.get('Q285');
                            }
                            else if(c.RecordtypeId == recordtypeInbound){
                                c.UA_InboundOwnerName__c = groupeMap1.get('Q285');
                            }
                            casesToUpDate.add(c);
                        }
                    }                        
                }
                if (!q286List.isEmpty()) {
                    if (groupeMap.keySet().contains('Q286')) {
                        for (Case c : caseToQ286) {
                            if(c.RecordtypeId == recordtypeOutbound){
                                c.OwnerId = groupeMap.get('Q286');
                            }
                            else if(c.RecordtypeId == recordtypeInbound){
                                c.UA_InboundOwnerName__c = groupeMap1.get('Q286');
                            }
                            casesToUpDate.add(c);
                        }
                    }
                }
                if (!q287List.isEmpty()) {
                    if (groupeMap.keySet().contains('Q287')) {
                        for (Case c : caseToQ287) {
                            if(c.RecordtypeId == recordtypeOutbound){
                                c.OwnerId = groupeMap.get('Q287');
                            }
                            else if(c.RecordtypeId == recordtypeInbound){
                                c.UA_InboundOwnerName__c = groupeMap1.get('Q287');
                            }
                            casesToUpDate.add(c);
                        }
                    }
                }
                if (casesToUpDate.size() >= 1) {
                    try {
                        update casesToUpDate;
                        System.debug('#l cases '+ JSON.serialize(casesToUpDate));
                    } catch (Exception e) {
                        System.debug('#l error '+ e.getCause() + ' '+ e.getMessage());
                    }
                } else {
                    System.debug('#l nothing to do');
                }
            }
        }           
            
    }
    /*public void OnAfterUpdate( List<Account> newAccount, List<Account> oldAccount, Map<ID, Account> newAccountMap , Map<ID, Account> oldAccountMap )
    {
        system.debug('Account Trigger On After Update ');
        AccountActions.updateContact (newAccount);
    }*/

   public void OnBeforeUpdate( List<GUA_Queue_Assigment__c> newQueueAssigments)
    {
        system.debug('Gua_QueueAssigment Trigger On Before Update ');
        List<GUA_Queue_Assigment__c> queueAssignementsToUpdates = new List<GUA_Queue_Assigment__c>();

        try {

        	Integer i = 0;
            
            for (GUA_Queue_Assigment__c cardQueueAssignement : newQueueAssigments) {
                
                if(cardQueueAssignement.IsActive__c == true) {
                    i++;
                }
            }

            if(i == 0){
                system.debug('pas besoins de traitement quand y a pas d element true');
            }

            else if(i == 1){

                system.debug('est entré dans le cas ou l élément est true');
                List<GUA_Queue_Assigment__c> existedQueueAssignements  = [SELECT Id, Q281__c, Q285__c, Q286__c, Q287__c, IsActive__c 
                    FROM GUA_Queue_Assigment__c WHERE IsActive__c = true];
                

                if ((existedQueueAssignements.size() == 1) && (newQueueAssigments[0].Id == existedQueueAssignements[0].Id) ) {
                    system.debug('pas besoins de traitement quand les id sont identiques');
                }

                else if(existedQueueAssignements.size() >= 1){
                    system.debug('************');
                    for (GUA_Queue_Assigment__c existedQueueAssignement : existedQueueAssignements) {
                        existedQueueAssignement.IsActive__c = false;
                        queueAssignementsToUpdates.add(existedQueueAssignement);
                    }

                    update queueAssignementsToUpdates;
                    system.debug('c est okay');
                }
            }
            else {
                throw new applicationException('non più di due elementi possono essere aggiunti all\'elenco');
            }
            

        }
        catch(exception ex) {
            //display custom message
            
            System.debug('Meassage : '+ex.getMessage());
            System.debug('Cause : '+ex.getCause());
            newQueueAssigments[0].adderror('non più di due elementi possono essere aggiunti all\'elenco');

    }     
}  
    
    public class applicationException extends Exception {}
}