@isTest
public with sharing class PV2790_2794ImportoDataOpFormTest {
    @isTest
    public static void testInvokeOk() {
        
        String response = '{"resultCode":0,"resultMessage":"Ok","cseInterrogazioneSaldoLightResponse":{"saldo":0,"disponibilita":0}}';
        ApiRest__c rest = new ApiRest__c(Method__c = 'POST', Test_Response__c = response, Test_Request__c = 'testRequest', Mock__c = false, User__c = 'CDSLF00', Password__c = 'P00FLSDC', ref__c = 'CompassInternal', Name = 'cse.interrogazioneSaldoLight', EndPoint__c = 'https://richiestaonlinesvi.compassonline.it/B2BSOAP/rest/B2BREST/execute');
        insert rest;
        ApiUtil__c uti = new ApiUtil__c(Name = 'CompassInternal', EndPoint__c = 'https://richiestaonlinesvi.compassonline.it/B2BSOAP/rest/B2BREST/execute' ,Password__c = 'P00FLSDC',User__c = 'CDSLF00');
        insert uti;
        
        UtilityMockResponse UMR = new UtilityMockResponse();
        UMR.apiname = 'cse.interrogazioneSaldoLight';
        Test.setMock(HttpCalloutMock.class, UMR);
        
        Test.startTest();
        CSEInterrogazioneSaldoLightInvoker.Response resp = PV2790_2794ImportoDataOperazioneForm.doCalcolaSaldo('12345');
        Test.stopTest();
        
        System.assertEquals('0', resp.cseInterrogazioneSaldoLightResponse.saldo);
        System.assertEquals('0', resp.cseInterrogazioneSaldoLightResponse.disponibilita);
        
        
    }
}