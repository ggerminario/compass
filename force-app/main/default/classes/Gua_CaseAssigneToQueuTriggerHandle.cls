/**
* @File Name          : Gua_CaseAssigneToQueuTriggerHandle
* @Description        : 
* @Author             : Dieynaba Diallo
* @CreatedDate        : 17/12/2019
**/
public with sharing  class Gua_CaseAssigneToQueuTriggerHandle {
    
    private boolean m_isExecuting = false;
    private integer BatchSize = 0;
    /*public static boolean IsFromBachJob ;
     public static boolean isFromUploadAPI=false;*/
    
    public Gua_CaseAssigneToQueuTriggerHandle(boolean isExecuting, integer size)
    {
        m_isExecuting = isExecuting;
        BatchSize = size;
    }
    
    
    public void OnAfterHandle(Set<Id> newSet)
    {
        system.debug('Gua_QueueAssigment Trigger On after Insert');
        List<Case> casesToUpDate = new List<Case>();
        List<Case> caseToQ281 = new List<Case>();
        List<Case> caseToQ285 = new List<Case>();
        List<Case> caseToQ286 = new List<Case>();
        List<Case> caseToQ287 = new List<Case>();
        Id recordtypeOutbound = Gua_Service.getRecordTypeId('GUA_Contact', 'Case');
        //Id recordtypeInbound = Gua_Service.getRecordTypeId('GUA_Inbound', 'Case');

        
        try {
            update casesToUpDate;
            System.debug('#l cases '+ JSON.serialize(casesToUpDate));
        } catch (Exception e) {
            System.debug('#l error '+ e.getCause() + ' '+ e.getMessage());
        }
        
        List<Case> cases = [SELECT Id, OwnerId, Account.OCSAreaId__c, RecordtypeId FROM Case WHERE (RecordtypeId =: recordtypeOutbound /*OR RecordtypeId =: recordtypeInbound*/) AND (Id IN :newSet)];
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
                            /*else if(c.RecordtypeId == recordtypeInbound){
                                c.UA_InboundOwnerName__c = groupeMap1.get('Q281');
                            }*/
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
                            /*else if(c.RecordtypeId == recordtypeInbound){
                                c.UA_InboundOwnerName__c = groupeMap1.get('Q285');
                            }*/
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
                            /*else if(c.RecordtypeId == recordtypeInbound){
                                c.UA_InboundOwnerName__c = groupeMap1.get('Q286');
                            }*/
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
                            /*else if(c.RecordtypeId == recordtypeInbound){
                                c.UA_InboundOwnerName__c = groupeMap1.get('Q287');
                            }*/
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
    
    
}