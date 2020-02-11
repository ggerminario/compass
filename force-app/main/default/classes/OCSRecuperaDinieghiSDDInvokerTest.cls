@isTest
public with sharing class OCSRecuperaDinieghiSDDInvokerTest {
    
    @isTest
    static void  test() {
      	String response = '{       "resultCode": 0,     "resultMessage": "Ok",     "recuperaDinieghiSDDResponse": {         "elenco": []     }  }';                
        
        ApiRest__c test1 = new ApiRest__c(Method__c = 'POST' ,Test_Response__c= response,Test_Request__c = 'testRequest',Mock__c = false,User__c = 'CDSLF00',Password__c = 'P00FLSDC' ,ref__c = 'CompassInternal', Name ='ocs.recuperaDinieghiSDD',EndPoint__c = 'https://richiestaonlinesvi.compassonline.it/B2BSOAP/rest/B2BREST/execute');      
        ApiUtil__c test2 = new ApiUtil__c(Name = 'CompassInternal' ,EndPoint__c ='https://richiestaonlinesvi.compassonline.it/B2BSOAP/rest/B2BREST/execute' ,Password__c = 'P00FLSDC',User__c = 'CDSLF00');      
        insert test1;
        insert test2;
        Test.startTest();
        UtilityMockResponse UMR = new UtilityMockResponse();
        UMR.apiname='ocs.recuperaDinieghiSDD';
        Test.setMock(HttpCalloutMock.class,UMR);
      
        OCSRecuperaDinieghiSDDResponse  res = OCSrecuperaDinieghiSDDInvoker.callRecuperaDinieghiSDD();
        Test.stopTest();
    
        
         
    } 
}