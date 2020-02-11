/**
*@author 		Khadim R Ndeye
*created 		29/10/2019
*descripttion 	test of GUA_Dettaglio_FilialeCnt class
*/
@isTest
public class GUA_Dettaglio_FilialeCntTest {
    @TestSetup
    static void makeData(){
        Id recordType=CGMWSUtils_1_0.getRecordTypeId('Case','GUA_Contact');
        Id recordTypeBranch=CGMWSUtils_1_0.getRecordTypeId('Account','Branch');
        Account acc = new Account(NameRoleReference__c='Milano',OCSAreaId__c=2, Name='Account Test', NameParentRoleReference__c='Test', RecordTypeId=recordTypeBranch);
        insert acc;
        Case c = new Case(Status='New', AccountId= acc.Id, RecordTypeId=recordType, Branch__c=acc.Id);
        insert c;
    }
	@isTest
    static void testGetRecuperaUtenzeIntermediario(){
        String codiceIntermediario='60757';
        Test.startTest();
        Map<String ,Object> response = GUA_Dettaglio_FilialeCnt.getRecuperaUtenzeIntermediario(codiceIntermediario);
        //ko
        Map<String ,Object> response1 = GUA_Dettaglio_FilialeCnt.getRecuperaUtenzeIntermediario('.&dez');
   		Test.stopTest();
        //System.assertEquals(response.get('erreur'), false);      
    }
    
    @isTest
    public static void getCase(){
        Account acc = [SELECT id, Name FROM Account WHERE Name='Account Test' LIMIT 1];
        Case caseRecord = [SELECT Id FROM Case WHERE AccountId=:acc.Id LIMIT 1];
        Test.startTest();
        Map<String ,Object> response = GUA_Dettaglio_FilialeCnt.getCase(caseRecord.Id);
        Map<String ,Object> response2 = GUA_Dettaglio_FilialeCnt.getCase('xxxxx');
   		Test.stopTest();
        System.assertEquals(response.get('erreur'), false);
        //System.assertEquals(response2.get('erreur'), true);
    }
    
     @isTest
    public static void TestgetFilialeById(){
        Account acc = [SELECT id, Name FROM Account WHERE Name='Account Test' LIMIT 1];
        Test.startTest();
        Map<String ,Object> response = GUA_Dettaglio_FilialeCnt.getFilialeById(acc.Id);
        //ko
        Map<String ,Object> response2 = GUA_Dettaglio_FilialeCnt.getFilialeById('xx');
   		Test.stopTest();
    }
    
     @isTest
    public static void TestgetFilialeById_bis(){
        Test.startTest();
        Map<String ,Object> response = GUA_Dettaglio_FilialeCnt.getFilialeById('5005E0005500648JtQAI');
   		Test.stopTest();
    }
    
    @isTest
    public static void TestgetCapoFiliale(){
         Case cas = [SELECT id, AccountId FROM Case LIMIT 1];
        Test.startTest();
        Map<String ,Object> response = GUA_Dettaglio_FilialeCnt.getCapoFiliale(cas.AccountId);
        //ko
        Map<String ,Object> response2 = GUA_Dettaglio_FilialeCnt.getCapoFiliale('xxx');
   		Test.stopTest();
    }
    
     @isTest
    public static void TestgetCapoFiliale_bis(){
        Test.startTest();
        Map<String ,Object> response = GUA_Dettaglio_FilialeCnt.getCapoFiliale('5005E00000648JtQAI');
   		Test.stopTest();
    }
     
    @isTest
    public static void TestgetCoordinatore(){
         Case cas = [SELECT id, AccountId,Account.OCSAreaId__c FROM Case LIMIT 1];
        Test.startTest();
        Map<String ,Object> response = GUA_Dettaglio_FilialeCnt.getCoordinatore(cas.AccountId);
        //ko
        Map<String ,Object> response2 = GUA_Dettaglio_FilialeCnt.getCoordinatore('tr');
   		Test.stopTest();
    }
}