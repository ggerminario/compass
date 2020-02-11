/**
 * @File Name          : OCSRecuperaMovAutViaggiantiInvokerTest.cls
 * @Description        : 
 * @Author             : Raffaele Prudenzano
 * @Group              : 
 * @Last Modified By   : Raffaele Prudenzano
 * @Last Modified On   : 9/12/2019, 10:58:57
 * @Modification Log   : 
 * Ver       Date            Author      		    Modification
**/
@isTest
public class OCSRecuperaMovAutViaggiantiInvokerTest {
    
    @isTest
    static void test(){
        
        String response = '{"resultCode":0,"resultMessage":"Ok","recuperaMovimentiAutorizzazioniViaggiantiResponse":{"recuperaMovViaggiantiResponse":{"elencoMovimenti":[],"as400Errore":null},"recuperaAutViaggiantiResponse":{"elencoAutorizzazioni":[{"autorizzazione":"2"}]}}}';
        ApiRest__c test1 = new ApiRest__c(Method__c = 'POST' ,Test_Response__c= response,Test_Request__c = 'testRequest',Mock__c = false,User__c = 'CDSLF00',Password__c = 'P00FLSDC' ,ref__c = 'CompassInternal',Name ='ocs.recuperaMovAutViaggianti',EndPoint__c = 'https://richiestaonlinesvi.compassonline.it/B2BSOAP/rest/B2BREST/execute');        
        insert test1;
        ApiUtil__c uti = new ApiUtil__c(Name = 'CompassInternal' ,EndPoint__c ='https://richiestaonlinesvi.compassonline.it/B2BSOAP/rest/B2BREST/execute' ,Password__c = 'P00FLSDC',User__c = 'CDSLF00');      
        insert uti;
        test.startTest();
        UtilityMockResponse UMR = new UtilityMockResponse();
        UMR.apiname='ocs.recuperaMovAutViaggianti';
        Test.setMock(HttpCalloutMock.class,UMR);    
        
        OCSRecuperaMovAutViaggiantiInvoker.recuperaMovAutViaggianti('1348');
        OCSRecuperaMovAutViaggiantiInvoker.recuperaMovAutViaggianti('1348',true,true);
        
        
        test.stopTest();	

        
        
        
    }
    
}