//----------------------------------------------------------------------
//-- - Author       : SANA BADJI
//-- - Date         : 11/06/2019
//-- - Description  : Handle Case Selector
//----------------------------------------------------------------------

public with sharing class CaseSelector {
  
  
  /*Author: Sana Badji
  Retrieve update cases belong to family
  */
      public static   List<Case>  getPropuitFamily (Set<Id> caseIds, String family ){
        List<Case> getPropuitFamily =
                        [SELECT Id,stato_ocs__c,Note__c, RO_Messaggio_Non_Contattare__c, Is_Discordanza_Cellulare__c,
                         OwnerId,Product__r.Family,AccountId,LastModifiedDate FROM 
                          Case WHERE  Id IN :caseIds AND Product__r.Family =:family];  
                 
        return getPropuitFamily;
    }


  /*
  Author: Sana Badji
  Retrieve List step  by Case ID
  */
      public static   RO_CRMRich_online_steplog__c  getStep (String step ){
          RO_CRMRich_online_steplog__c steplogByStep = [SELECT RO_CRMStep__c 
          FROM RO_CRMRich_online_steplog__c WHERE  RO_CRMStep__c =:step]; 
                 
        return steplogByStep;
    }

 /*
  Author: Sana Badji
  Retrieve List RO_CRMRich_online_steplog__c    by Case ID
  */
      public static  List<RO_CRMRich_online_steplog__c>  selectorRichOnlineStepLog (Set<Id> caseIds){
         List<RO_CRMRich_online_steplog__c> richOnlineStepLog=null;
          richOnlineStepLog = [SELECT RO_CRMStep__c,
          RO_CRMRichiesta_Online__r.NumeroPratica__c,RO_CRMRichiesta_Online__c,RO_CRMRichiesta_Online__r.Stato_Pratica__c,
          RO_CRMRichiesta_Online__r.Product__r.DEMAnomalie__c , RO_CRMRichiesta_Online__r.Product__r.Family,
          RO_CRMRichiesta_Online__r.AccountId,RO_CRMRichiesta_Online__r.Account.PersonEmail,RO_CRMRichiesta_Online__r.LastModifiedDate,LastModifiedDate,
          RO_CRMRichiesta_Online__r.RO_Link_Bozza__c, RO_CRMModalita_firma__c
          FROM RO_CRMRich_online_steplog__c WHERE RO_CRMRichiesta_Online__c IN :CaseIds  ORDER BY LastModifiedDate DESC LIMIT 1];
          if(richOnlineStepLog.size()==0){
            System.debug('************ richOnlineStepLog is empty '+ richOnlineStepLog  );
            return richOnlineStepLog;
          }
        return richOnlineStepLog;
    }

/*  
* Autheur : Sana Badji 
* @param caseIds
* @date  17/05/2019
*/
      public static   List<Case>  getCaseWebservice(Set<Id> caseIds ){
        List<Case> caseWebservice =
                        [SELECT Id,OwnerId,Status, Tipo_Pratica__c,stato_ocs__c,Note__c, RO_Messaggio_Non_Contattare__c,NumeroPratica__c,Stato_Pratica__c,Attributi_Pratica__c,CanaleContatto__c FROM 
                          Case WHERE  Id IN :caseIds ];  
                 
        return caseWebservice;
      }

/*  
* Autheur : Sana Badji 
* @param caseIds
* @date  14/11/2019
*/
  public static List<Case> getNumeroPratica(){
    return [SELECT Id, NumeroPratica__c FROM Case WHERE RecordType.DeveloperName = 'CRM_RichiestaOnline' AND isClosed = false];
  }

/*  
* Autheur : Sana Badji 
* @param caseIds
* @date  14/11/2019
*/
    public static  Map<String, String> getStatusjobIDEcom(String jobIDEcom){
          Map<String, String> status = new Map<String, String>();
          CronTrigger jobsName;
          String idJobDS;
          String idJobDSP;
          String idJobEcom;
          try {  
          jobsName = [Select Id, CronJobDetail.Name, CreatedDate, State, NextFireTime From CronTrigger WHERE  Id=:jobIDEcom AND State ='WAITING'];
          idJobDS = (jobsName.CronJobDetail.Name).substringBetween('solContrSchedul_DS-','-');
          idJobDSP = (jobsName.CronJobDetail.Name).substringBetween('anoSchedul_DSP-','-');
          idJobEcom = (jobsName.CronJobDetail.Name).substringBetween('anoSchedul_Ecom-','-');
          status.put('idJobDS',idJobDS);
          status.put('idJobDSP',idJobDSP);
          status.put('idJobEcom',idJobEcom);

          }catch (System.QueryException e) {
          System.debug('************* jobsName not exit   '+e.getMessage());
        }
        return status;
    }

          

}