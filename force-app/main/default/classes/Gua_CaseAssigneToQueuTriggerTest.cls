/**
* @File Name          : Gua_CaseAssigneToQueuTriggerTest
* @Description        : test of the Assigne case to a queue after update or insert in unita affari
* @Author             : Dieynaba Diallo
* @CreatedDate        : 17/12/2019
**/
@Istest
public with sharing class Gua_CaseAssigneToQueuTriggerTest {
    
    @testSetup
    static void makeData(){
    	
        List<GUA_Queue_Assigment__c> qas = new List<GUA_Queue_Assigment__c>();
        
        GUA_Queue_Assigment__c qa1 = new GUA_Queue_Assigment__c();
        qa1.Q285__c = '6;7;8;9;10';
        qa1.Q281__c = '12;13;14;15;16';
        qa1.Q286__c = '21;22;23;24;25;26';
        qa1.Q287__c = '26;27;28;29;30';
        qa1.IsActive__c = false;
        qas.add(qa1);
        
        GUA_Queue_Assigment__c qa2 = new GUA_Queue_Assigment__c();
        qa2.Q285__c = '16;17;8;9;10';
        qa2.Q281__c = '16;8;15;16';
        qa2.Q286__c = '5;6;7;24;25;26';
        qa2.Q287__c = '10;14;16;29;30';
        qa2.IsActive__c =true;
        qas.add(qa2);
        
        GUA_Queue_Assigment__c qa3 = new GUA_Queue_Assigment__c();
        qa3.Q285__c = '6;7;8;9';
        qa3.Q281__c = '12;13;14;15';
        qa3.Q286__c = '21;22;23;24;25';
        qa3.Q287__c = '26;27;28;29';
        qa3.IsActive__c =false;
        qas.add(qa3);
        
        insert qas;
        
        String recTypeIdAcc = [select Id from RecordType where (Name='Dealer') and (SobjectType='Account')].Id;
        List<Account> accounts = new List<Account>();
        Account acc1 = new Account(RecordTypeID=recTypeIdAcc, Name='test', OCSAreaId__c =6);
        accounts.add(acc1);
        insert accounts;
    }
    
    @isTest
    public static void insertTest1(){
        
        String recTypeIdAcc = [select Id from RecordType where (Name='Dealer') and (SobjectType='Account')].Id;
        List<Account> accounts = new List<Account>();
        Account acc1 = new Account(RecordTypeID=recTypeIdAcc, Name='test', OCSAreaId__c =6);
        Account acc2 = new Account(RecordTypeID=recTypeIdAcc, Name='test', OCSAreaId__c =7);
        Account acc3 = new Account(RecordTypeID=recTypeIdAcc, Name='test', OCSAreaId__c =22);
        Account acc4 = new Account(RecordTypeID=recTypeIdAcc, Name='test', OCSAreaId__c =10);
        Account acc5 = new Account(RecordTypeID=recTypeIdAcc, Name='test', OCSAreaId__c =15);
        Account acc6 = new Account(RecordTypeID=recTypeIdAcc, Name='test', OCSAreaId__c =29);
        accounts.add(acc1);
        accounts.add(acc2);
        accounts.add(acc3);
        accounts.add(acc4);
        accounts.add(acc5);
        accounts.add(acc6);
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
        Case c6 = new Case(Status='New', AccountId= accounts[5].Id, RecordTypeId=recTypeIdCase);
        
        Case c11 = new Case(Status='New', AccountId= accounts[0].Id, RecordTypeId=recTypeIdCase1);
        Case c7 = new Case(Status='New', AccountId= accounts[1].Id, RecordTypeId=recTypeIdCase1);
        Case c8 = new Case(Status='New', AccountId= accounts[2].Id, RecordTypeId=recTypeIdCase1);
        Case c9 = new Case(Status='New', AccountId= accounts[3].Id, RecordTypeId=recTypeIdCase1);
        Case c10 = new Case(Status='New', AccountId= accounts[4].Id, RecordTypeId=recTypeIdCase1);
        Case c12 = new Case(Status='New', AccountId= accounts[5].Id, RecordTypeId=recTypeIdCase1);
        
        cases.add(c1);
        cases.add(c2);
        cases.add(c3);
        cases.add(c4);
        cases.add(c5);
        cases.add(c6);
        cases.add(c11);
        cases.add(c7);
        cases.add(c8);
        cases.add(c9);
        cases.add(c10);
        cases.add(c12);
        
        
        /*cases1.add(c11);
        cases1.add(c7);
        cases1.add(c8);
        cases1.add(c9);
        cases1.add(c10);
        cases1.add(c12);*/
        
        test.startTest();
        insert cases;
        test.stopTest();
    }
    
   //@isTest
   public static void updateTest1() {
        
      //String recordTypeDealer = [select Id from RecordType where (Name='Dealer') and (SobjectType='Account')].Id;
        //Id recordTypeDealer=CGMWSUtils_1_0.getRecordTypeId('Account' , 'Dealer');
        Account acc = [Select Id, OCSAreaId__c  from Account limit 1];
        
        /*String recTypeIdCase = [select Id from RecordType where (Name='GUA Contact') and (SobjectType='Case')].Id;
        Id recTypeIdCase = CGMWSUtils_1_0.getRecordTypeId('Case' , 'GUA Contact');
        Case caseObj = [Select Id, Status, AccountId  from Case Where (recordTypeId =: recTypeIdCase)
                                      AND (AccountId =: acc.Id) limit 1];
        caseObj.Status='Closed';
        
        
        Test.startTest();
        update caseObj;
        Test.stopTest();*/
       
       Id recTypeIdCase = CGMWSUtils_1_0.getRecordTypeId('Case' , 'GUA Contact');
       Case caseObj = new Case();
       caseObj.CTI_Entita__c='AffariHDFiliali';
       insert caseObj;
       caseObj.AccountId = acc.Id;
       caseObj.RecordTypeId = recTypeIdCase;
       Test.startTest();
       	update caseObj;
       Test.stopTest();
       
    }
}