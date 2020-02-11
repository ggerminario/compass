/**
 * @File Name          : Gua_QueueAssigmentCntTest
 * @Description        : Test the Gua_AccountAssigneToQueuTrigger trigger
 * @Author             : Moustapha Diouf
 * @CreatedDate        : 16/12/2019
**/

@istest
public class Gua_AccountAssigneToQueuTriggerTest {
	@testSetup 
    static void testSetup(){
       
        Id recTypeIdAcc = Gua_Service.getRecordTypeId('Dealer', 'Account');
		List<Account> accounts = new List<Account>();
        Account acc1 = new Account(RecordTypeID=recTypeIdAcc, Name='test', OCSAreaId__c =12);
        Account acc2 = new Account(RecordTypeID=recTypeIdAcc, Name='test', OCSAreaId__c =21);
        Account acc3 = new Account(RecordTypeID=recTypeIdAcc, Name='test', OCSAreaId__c =10);
        Account acc4 = new Account(RecordTypeID=recTypeIdAcc, Name='test', OCSAreaId__c =16);
        Account acc5 = new Account(RecordTypeID=recTypeIdAcc, Name='test', OCSAreaId__c =29);
        accounts.add(acc1);
        accounts.add(acc2);
        accounts.add(acc3);
        accounts.add(acc4);
        accounts.add(acc5);
        insert accounts;
        String recTypeIdCase = [select Id from RecordType where (Name='GUA Contact') and (SobjectType='Case')].Id;
		List<Case> cases = new List<Case>();
        String recTypeIdCase1 = [select Id from RecordType where (Name='GUA Inbound') and (SobjectType='Case')].Id;
		List<Case> cases1 = new List<Case>();
        Case c1 = new Case(Status='New', AccountId= accounts[0].Id, RecordTypeId=recTypeIdCase);
        Case c2 = new Case(Status='New', AccountId= accounts[1].Id, RecordTypeId=recTypeIdCase);
        Case c3 = new Case(Status='New', AccountId= accounts[2].Id, RecordTypeId=recTypeIdCase);
        Case c4 = new Case(Status='New', AccountId= accounts[3].Id, RecordTypeId=recTypeIdCase);
        Case c5 = new Case(Status='New', AccountId= accounts[4].Id, RecordTypeId=recTypeIdCase);
        cases.add(c1);
        cases.add(c2);
        cases.add(c3);
        cases.add(c4);
        cases.add(c5);
        
        Case c6 = new Case(Status='New', AccountId= accounts[0].Id, RecordTypeId=recTypeIdCase1);
        Case c7 = new Case(Status='New', AccountId= accounts[1].Id, RecordTypeId=recTypeIdCase1);
        Case c8 = new Case(Status='New', AccountId= accounts[2].Id, RecordTypeId=recTypeIdCase1);
        Case c9 = new Case(Status='New', AccountId= accounts[3].Id, RecordTypeId=recTypeIdCase1);
        Case c10 = new Case(Status='New', AccountId= accounts[4].Id, RecordTypeId=recTypeIdCase1);
        cases1.add(c6);
        cases1.add(c7);
        cases1.add(c8);
        cases1.add(c9);
        cases1.add(c10);
        insert cases;
        insert cases1;
        List<GUA_Queue_Assigment__c> qas = new List<GUA_Queue_Assigment__c>();
        GUA_Queue_Assigment__c qa1 = new GUA_Queue_Assigment__c();
        qa1.Q285__c = '6;7;8;9;10';
        qa1.Q281__c = '12;13;14;15;16';
        qa1.Q286__c = '21;22;23;24;25;26';
        qa1.Q287__c = '26;27;28;29;30';
        qa1.IsActive__c = true;
        qas.add(qa1);
        GUA_Queue_Assigment__c qa2 = new GUA_Queue_Assigment__c();
        qa2.Q285__c = '16;17;8;9;10';
        qa2.Q281__c = '16;8;15;16';
        qa2.Q286__c = '5;6;7;24;25;26';
        qa2.Q287__c = '10;14;16;29;30';
        qa2.IsActive__c =false;
        qas.add(qa2);
        GUA_Queue_Assigment__c qa3 = new GUA_Queue_Assigment__c();
        qa3.Q285__c = '6;7;8;9';
        qa3.Q281__c = '12;13;14;15';
        qa3.Q286__c = '21;22;23;24;25';
        qa3.Q287__c = '26;27;28;29';
        qa3.IsActive__c =false;
        qas.add(qa3);
        insert qas;
        
    }
    
     @isTest
    public static void testTrigger(){
      List<Account> accts =[SELECT Id, Name FROM Account];
        accts[0].Name = 'Test Trigger';
        accts[1].Name = 'Test Trigger';
        accts[2].Name = 'Test Trigger';
        accts[3].Name = 'Test Trigger';
        accts[4].Name = 'Test Trigger';
        update accts;    }
}