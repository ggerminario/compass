global with sharing class RichOnlineSteplogService {
    
  /*
    *@description create RO_CRMRich_online_steplog__c
    *@param Case
    *@param Product2
    *@return RO_CRMRich_online_steplog__c
  */
  public static  RO_CRMRich_online_steplog__c  createCrmOnlineStepLog (Case cas){

    RO_CRMRich_online_steplog__c log  = (RO_CRMRich_online_steplog__c) RequestOnlineApexClass.data.get('ros');      
    try {   
      System.debug('############# idCase '+cas.Id);
      Case caseObject = [SELECT Id, OwnerId FROM Case WHERE Id =: cas.Id ];
      Group gr = [SELECT Id, DeveloperName FROM Group WHERE Type = 'Queue' AND Id = :caseObject.OwnerId];
      log.Ro_DeveloperName__c = gr.DeveloperName;
      System.debug('#l log.Ro_DeveloperName__c'+ log.Ro_DeveloperName__c);
      log.RO_CRMRichiesta_Online__c = cas.Id;
      log.RecordTypeId = CGMWSUtils_1_0.getRecordTypeId('RO_CRMRich_online_steplog__c', 'RO_CRMRichiesta_Online');
      insert log;
      System.debug('****************** steplog inserted ***** '+log);
    } catch (Exception e) {
      System.debug('************* errorMessage createCrmOnlineStepLog '+ e.getMessage() );
      System.debug('************* errorMessage'+ e.getStackTraceString());
    }
    return log;
  }

  public static Boolean seracrModalitaRichesta(List<RO_CRMRich_online_steplog__c> richOnlineStep){
    Boolean response = false;
    if(richOnlineStep == null || richOnlineStep.size() == 0 ){
      return response;
    }
    else {
      for(RO_CRMRich_online_steplog__c steplog : richOnlineStep){
        if(steplog.RO_CRMModalita_richiesta__c !='TEL_IN'){
          response = true;
          break;
        }
      }
    }
    return response;
  }
}