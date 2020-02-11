/**
 * @File Name          : Gua_QueueAssigmentTriggerTest.cls
 * @Description        : Gua_QueueAssigmentTriggerTest 
 * @Author             : Dieynaba Diallo
 * @CreatedDate        : 26/11/2019
 */
@isTest
public class Gua_QueueAssigmentTriggerTest {
    
    @testSetup
    static void makeData(){
        
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
        cases.add(c1);
        cases.add(c2);
        cases.add(c3);
        cases.add(c4);
        cases.add(c5);
        cases.add(c6);
        Case c11 = new Case(Status='New', AccountId= accounts[0].Id, RecordTypeId=recTypeIdCase1);
        Case c7 = new Case(Status='New', AccountId= accounts[1].Id, RecordTypeId=recTypeIdCase1);
        Case c8 = new Case(Status='New', AccountId= accounts[2].Id, RecordTypeId=recTypeIdCase1);
        Case c9 = new Case(Status='New', AccountId= accounts[3].Id, RecordTypeId=recTypeIdCase1);
        Case c10 = new Case(Status='New', AccountId= accounts[4].Id, RecordTypeId=recTypeIdCase1);
        Case c12 = new Case(Status='New', AccountId= accounts[5].Id, RecordTypeId=recTypeIdCase1);
        cases1.add(c11);
        cases1.add(c7);
        cases1.add(c8);
        cases1.add(c9);
        cases1.add(c10);
        cases1.add(c12);
        insert cases;
        insert cases1;

        
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
    public static void insertTest1() {
        GUA_Queue_Assigment__c qa1 = new GUA_Queue_Assigment__c();
        GUA_Queue_Assigment__c qa2 = new GUA_Queue_Assigment__c();
        List<GUA_Queue_Assigment__c> qas = new List<GUA_Queue_Assigment__c>();

        qa1.Q285__c = '6;7;10;8;9';
        qa1.Q281__c = '12;16;13;14;15';
        qa1.Q286__c = '21;22;23;24;25;26';
        qa1.Q287__c = '26;27;28;29;30';
        qa1.IsActive__c =false;

        qa2.Q285__c = '6;7;8;9;10';
        qa2.Q281__c = '16;8;15;16';
        qa2.Q286__c = '5;6;7;24;25;26';
        qa2.Q287__c = '10;30;14;16;29';
        qa2.IsActive__c =true;
        
        GUA_Queue_Assigment__c qa3 = new GUA_Queue_Assigment__c();
        qa3.Q285__c = '6;7;8;9';
        qa3.Q281__c = '12;13;14;15';
        qa3.Q286__c = '21;25;22;23;24';
        qa3.Q287__c = '26;27;28;29';
        qa3.IsActive__c =false;

        qas.add(qa1);
        qas.add(qa2);
        qas.add(qa3);
        test.startTest();
            insert qas;
        test.stopTest();
            
        //System.assertEquals(qas[0].Id, null);
        //System.assertEquals(qas[1].Id, null);
    }
    
    @isTest
    public static void updateTest1() {
        
        GUA_Queue_Assigment__c qa4 = [SELECT Id, Q281__c, Q285__c, Q286__c, Q287__c, IsActive__c 
                    FROM GUA_Queue_Assigment__c WHERE IsActive__c = false limit 1];
        

        qa4.IsActive__c = true; //true
        List<GUA_Queue_Assigment__c> qas1 = new List<GUA_Queue_Assigment__c>();
        qas1.add(qa4);
        Test.startTest();
        update qas1;
        Test.stopTest();
        
        List<GUA_Queue_Assigment__c> existedQueueAssignements  = [SELECT Id, IsActive__c 
                    FROM GUA_Queue_Assigment__c WHERE IsActive__c = true];
        System.assertEquals(existedQueueAssignements.size(), 1);
    }
    
    @isTest
    public static void insertTest7() {
        
        
        GUA_Queue_Assigment__c qa1 = new GUA_Queue_Assigment__c();
        List<GUA_Queue_Assigment__c> qas = new List<GUA_Queue_Assigment__c>();
        qa1.Q285__c = '6;7;10;8;9';
        qa1.Q281__c = '12;16;13;14;15';
        qa1.Q286__c = '21;22;23;24;25;26';
        qa1.Q287__c = '26;27;28;29;30';
        qa1.IsActive__c =true;
        qas.add(qa1);
        
        GUA_Queue_Assigment__c qa2 = new GUA_Queue_Assigment__c();
        List<GUA_Queue_Assigment__c> qas1 = new List<GUA_Queue_Assigment__c>();
       	qa2.Q285__c = '6;7;8;9;10';
        qa2.Q281__c = '16;8;15;16';
        qa2.Q286__c = '5;6;7;24;25;26';
        qa2.Q287__c = '10;30;14;16;29';
        qa2.IsActive__c =true;
        qas1.add(qa2);
        
        insert qas;
        
        Test.startTest();
        insert qas1;
        Test.stopTest();
        
        List<GUA_Queue_Assigment__c> existedQueueAssignements  = [SELECT Id, IsActive__c 
                    FROM GUA_Queue_Assigment__c WHERE IsActive__c = true];
        System.assertEquals(existedQueueAssignements.size(), 1);
    }
    
    @isTest
    public static void insertTest6() {
        
        
        GUA_Queue_Assigment__c qa1 = new GUA_Queue_Assigment__c();
        List<GUA_Queue_Assigment__c> qas = new List<GUA_Queue_Assigment__c>();
        qa1.Q285__c = '6;7;10;8;9';
        qa1.Q281__c = '12;16;13;14;15';
        qa1.Q286__c = '21;22;23;24;25;26';
        qa1.Q287__c = '26;27;28;29;30';
        qa1.IsActive__c =true;
        qas.add(qa1);
        
        GUA_Queue_Assigment__c qa2 = new GUA_Queue_Assigment__c();
        GUA_Queue_Assigment__c qa3 = new GUA_Queue_Assigment__c();
        List<GUA_Queue_Assigment__c> qas1 = new List<GUA_Queue_Assigment__c>();
       	qa2.Q285__c = '6;7;8;9;10';
        qa2.Q281__c = '16;8;15;16';
        qa2.Q286__c = '5;6;7;24;25;26';
        qa2.Q287__c = '10;30;14;16;29';
        qa2.IsActive__c =true;
        
        qa3.Q285__c = '6;7;8;9';
        qa3.Q281__c = '12;13;14;15';
        qa3.Q286__c = '21;25;22;23;24';
        qa3.Q287__c = '26;27;28;29';
        qa3.IsActive__c =true;
        
        qas1.add(qa2);
        qas1.add(qa3);
        insert qas;
        
        try {
            Test.startTest();
        	insert qas1;
        	Test.stopTest();
        } catch (Exception e) {
            
        }
        
        List<GUA_Queue_Assigment__c> existedQueueAssignements  = [SELECT Id, IsActive__c 
                    FROM GUA_Queue_Assigment__c WHERE IsActive__c = true];
        System.assertEquals(existedQueueAssignements.size(), 1);
    }
    @isTest
    public static void updateTest7() {
        
        GUA_Queue_Assigment__c qa4 = [SELECT Id, Q281__c, Q285__c, Q286__c, Q287__c, IsActive__c 
                    FROM GUA_Queue_Assigment__c WHERE IsActive__c = false limit 1];
        

        qa4.IsActive__c = true; //true
        List<GUA_Queue_Assigment__c> qas1 = new List<GUA_Queue_Assigment__c>();
        qas1.add(qa4);
        
        
        GUA_Queue_Assigment__c qa1 = new GUA_Queue_Assigment__c();
        List<GUA_Queue_Assigment__c> qas = new List<GUA_Queue_Assigment__c>();
        qa1.Q285__c = '6;7;10;8;9';
        qa1.Q281__c = '12;16;13;14;15';
        qa1.Q286__c = '21;22;23;24;25;26';
        qa1.Q287__c = '26;27;28;29;30';
        qa1.IsActive__c =true;
        
        qas.add(qa1);
        insert qas;
        
        Test.startTest();
        update qas1;
        Test.stopTest();
        
        List<GUA_Queue_Assigment__c> existedQueueAssignements  = [SELECT Id, IsActive__c 
                    FROM GUA_Queue_Assigment__c WHERE IsActive__c = true];
        System.assertEquals(existedQueueAssignements.size(), 1);
    }
    
    @isTest
    public static void updateTest8() {
        
        List<GUA_Queue_Assigment__c> qas1 = [SELECT Id, Q281__c, Q285__c, Q286__c, Q287__c, IsActive__c 
                    FROM GUA_Queue_Assigment__c WHERE IsActive__c = false limit 2];
        

        qas1[0].IsActive__c = true; //true
        qas1[1].IsActive__c = true; //true
              
        GUA_Queue_Assigment__c qa1 = new GUA_Queue_Assigment__c();
        List<GUA_Queue_Assigment__c> qas = new List<GUA_Queue_Assigment__c>();
        qa1.Q285__c = '6;7;10;8;9';
        qa1.Q281__c = '12;16;13;14;15';
        qa1.Q286__c = '21;22;23;24;25;26';
        qa1.Q287__c = '26;27;28;29;30';
        qa1.IsActive__c =true;
        
        qas.add(qa1);
        insert qas;
        
        try {
            Test.startTest();
        	update qas1;
        	Test.stopTest();
        } catch (Exception e) {
            
        }
        

    }
}