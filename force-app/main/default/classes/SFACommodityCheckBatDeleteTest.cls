@isTest
public with sharing class SFACommodityCheckBatDeleteTest {

   
    @isTest
    public static void runBatchTest() {
      SFA_ComCheck__c comCheck = new SFA_ComCheck__c(Timestamp__c  = '1234',Index__c = 1,FileName__c='test');
      insert comCheck;
      Test.startTest();
      SFACommodityCheckBatDelete bat = new   SFACommodityCheckBatDelete();   
      Id batchJobId = Database.executeBatch(bat, 1);
      bat.execute(null);
      Test.stopTest();
      
      List<SFA_ComCheck__c> comChecks = [SELECT Id FROM SFA_ComCheck__c];

      System.assert(comChecks==null || comChecks.size()==0);
 
    }   
}