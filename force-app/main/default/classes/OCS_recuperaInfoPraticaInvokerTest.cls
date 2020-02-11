@isTest
public class OCS_recuperaInfoPraticaInvokerTest {
      @isTest
    public static void test() {
        
       
        String responseInfoPratica ='{"resultMessage":"Ok","resultCode":0,"recuperaInfoPraticaResponse":{"telaio":"","targa":"EP770GD ","prodotto":"1U","marcaModello":"AF A29","descrizioneBene":"GIULIETTA","annoMeseImmatricolazione":"20121001"}}'; 
        ApiRest__c test2 = new ApiRest__c(Method__c = 'POST' ,Test_Response__c=responseInfoPratica ,Test_Request__c = 'testRequest',Mock__c = false,User__c = 'CDSLF00',Password__c = 'P00FLSDC' ,Name ='ocs.recuperaInfoPratica',EndPoint__c = 'https://richiestaonlinesvi.compassonline.it/B2BSOAP/rest/B2BREST/execute');      
        insert test2;     
        
        
        OCS_recuperaInfoPraticaRequest re = new  OCS_recuperaInfoPraticaRequest();
        UtilityMockResponse UMR = new UtilityMockResponse();
        UMR.apiname='ocs.recuperaInfoPratica';
        Test.setMock(HttpCalloutMock.class,UMR);
        
    
        ApiRest__c test1 = new ApiRest__c(Method__c = 'POST' ,Ref__c = 'CompassInternal',Test_Response__c='{"resultCode":0,"resultMessage":"Ok",OCSGestioneNoteResponse":{"as400Status":"Ok","as400Errore":""}}',Test_Request__c = 'testRequest',Mock__c = false,User__c = 'CDSLF00',Password__c = 'P00FLSDC' ,Name ='ocs.recuperaInfoPratica',EndPoint__c = 'https://richiestaonlinesvi.compassonline.it/B2BSOAP/rest/B2BREST/execute');      
        ApiUtil__c test3 = new ApiUtil__c(Name = 'CompassInternal' ,EndPoint__c ='https://richiestaonlinesvi.compassonline.it/B2BSOAP/rest/B2BREST/execute' ,Password__c = 'P00FLSDC',User__c = 'CDSLF00');      

        insert test1;
        insert test3;
        Test.startTest();
         UMR.apiname='ocs.recuperaInfoPratica';
        Test.setMock(HttpCalloutMock.class,UMR);
        OCS_recuperaInfoPraticaInvoker.callAggiornaDati('800000329783');
        OCS_recuperaInfoPraticaInvoker.callAggiornaDati('800000329783','C');
        Test.stopTest();
       
        
    }
    

}