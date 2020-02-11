//----------------------------------------------------------------------
//-- - Author       : SANA BADJI
//-- - Date         : 15/07/2019
//-- - Description  : Handle GUA_UltimeChiamataCntTest
//----------------------------------------------------------------------
@isTest
public with sharing class GUA_UltimeChiamataCntTest {
   
    @TestSetup
    static void makeData(){
        String RecTypeId = [select Id from RecordType where (Name='Dealer') and (SobjectType='Account')].Id;
        Account accoObj = new Account(RecordTypeID=RecTypeId,Name='Acc test',
                                       DEM_Da_Inviare__c = false,  BillingCity = 'San Francisco', OCS_External_Id__c = 'C11911134');
        insert accoObj;
        
         // Create a case a object
            Case caseObj = new Case();
            caseObj.Status = 'Open';
            caseObj.Subject = 'TestSubject';
            caseObj.Description = 'TestDescription';
            caseObj.Tentativo__c = 2;
            caseObj.RO_Vecchio_Cellulare__c ='1234567890';
            caseObj.RO_Link_Bozza__c  = '111111';
            caseObj.AccountId = accoObj.Id;
            insert caseObj;
        
            List<Task> t = new List<Task>{ new Task(
            WhatID = caseObj.Id,
            CallObject='H3G TEST',
            Status='Completed',
            Priority='Normal'
            )};
            insert t;  
            System.debug(' task '+ t );
    }
    
    
       
    @IsTest
    static void getTaskByIDTest(){
        Test.startTest();
        Account accountObject = [SELECT Id  FROM Account limit 1];
        Map<String,Object> listTask= GUA_UltimeChiamataCnt.getTaskByID(accountObject.Id); 
        System.debug('############### errorlistTask '+listTask.get('error'));
        System.assert(listTask.get('error')==false,'');
        Test.stopTest();
    }
    
    @IsTest
    static void getTaskByIDTestKO(){
        Test.startTest();
        Account accountObject = [SELECT Id  FROM Account limit 1];
        Map<String,Object> listTask2= GUA_UltimeChiamataCnt.getTaskByID('xx');
        //System.assertEquals(0, listTask2.size());
        System.assert(listTask2.get('error')==false,'');
        Test.stopTest();
    }


    @IsTest
    static void getTaskByIDTestException(){
        Test.startTest();
        Task  taskObject = [SELECT Id  FROM Task     limit 1];
        String accountId='1@@@@@@@@@@&amp;amp;amp;amp;nbsp;';
        Map<String,Object> response= GUA_UltimeChiamataCnt.getTaskByID(null);
        System.debug('############### error '+response.get('error'));
        System.assert(taskObject!=null,'');
        Test.stopTest();
    }
}