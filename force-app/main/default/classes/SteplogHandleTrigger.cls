public with sharing class SteplogHandleTrigger {
    
     public static String cronAfterThreeHours;
     public static String cronAfterThirtyMinutes;
     public static String cronAfterTwoHours;
     public static String cronAfterFiveDays;
     public static final String AFTER_THIRTY_MINUTES = 'afterThirtyMinutes';
     public static final String AFTER_THREE_THREE_HOURS = 'afterThreeHours';
     public static final String AFTER_TWO_TWO_HOURS = 'afterTwoHours';
     public static List<Case> caseProductDS = new List<Case>();
     public static List<Case> caseProductDSP = new List<Case>();
     public static List<Case> caseProductEcommerce = new List<Case>();


/*  
* Autheur : Sana Badji 
* @param stepList
* @param idsToProcess
* @date  27/11/2019
*/
     public static void  stepLogHandlerDispatcher(List<RO_CRMRich_online_steplog__c> stepList, Set<Id> idsToProcess){
          Id idCase;
          for(RO_CRMRich_online_steplog__c step : stepList)
          {
               idCase=step.RO_CRMRichiesta_Online__c;
          }
          //Case c = [SELECT Id, (SELECT Id, Descrizione_Anomalia_Op__c FROM Anomalie_Doc__r), Is_Discordanza_Cellulare__c, Product__r.Family,stato_ocs__c FROM Case WHERE Id =: anoList[0].CaseId__c]
          caseProductEcommerce= CaseSelector.getPropuitFamily(idsToProcess,'PF_ECOMMERCE_STANDARD');
          System.debug('stepList handle' +stepList);
           System.debug('caseProductEcommerce' +caseProductEcommerce.size());
          List<RO_CRMRich_online_steplog__c> steplogByCase = CaseSelector.SelectorRichOnlineStepLog(idsToProcess);
          if(caseProductEcommerce.size() > 0  ){
            AnomalieDocProductEcommerce.checkAbbandonoPostCaricoOCS(steplogByCase);
           }
     }

}