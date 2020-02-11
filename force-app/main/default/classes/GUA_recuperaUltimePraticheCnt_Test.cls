@IsTest
public with sharing class GUA_recuperaUltimePraticheCnt_Test {

    @TestSetup
    static void makeData(){
        Account acc = new Account();
        acc.Lastname= 'Test';
        acc.Firstname= 'Test';
        insert acc;

        Case caseObj = new Case();
        caseObj.Status = 'Open';
        caseObj.Subject = 'TestSubject';
        caseObj.Tentativo__c = 2;
        caseObj.RO_Vecchio_Cellulare__c ='1234567890';
        caseObj.RO_Link_Bozza__c  = '111111';
        caseObj.AccountId= acc.Id;
        insert caseObj;
    }
    
    @IsTest
    static void retrieveAllPraticheTest(){
        
        ID caseId = [SELECT ID FROM CASE].ID;
        String tipo ='CA';
        String codiceCliente='123';
        String tipoConv='124';
        
        StaticResourceCalloutMock mock = new StaticResourceCalloutMock();
        mock.setStaticResource('ocs.recuperaDatiPostvendita');
        mock.setStatusCode(200);
        mock.setHeader('Content-Type', 'application/json');
        
        Test.startTest();
            Test.setMock(HttpCalloutMock.class, mock);
            Map<String,Object> response = GUA_recuperaUltimePraticheCnt.retrieveAllPraticheCarta(caseId+'',tipo,codiceCliente,tipoConv);
        Test.stopTest();
        
    }
    
}