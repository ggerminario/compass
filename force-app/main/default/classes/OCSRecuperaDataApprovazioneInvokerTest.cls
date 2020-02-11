@isTest
public class OCSRecuperaDataApprovazioneInvokerTest {
    
    @isTest
    static void test(){

        String responseTest ='{"resultMessage":"Ok","resultCode":0,"recuperaDataApprovazioneResponse":{"dataApprovazione":"20061116"}}'; 
        ApiRest__c test1 = new ApiRest__c(Method__c = 'POST' ,Test_Response__c=responseTest,Test_Request__c = '',Mock__c = false,User__c = 'CDSLF00',Password__c = 'P00FLSDC' ,Name ='ocs.recuperaDataApprovazione',EndPoint__c = 'https://richiestaonlinesvi.compassonline.it/B2BSOAP/rest/B2BREST/execute', Ref__c='CompassInternal');      
        insert test1;
        ApiUtil__c uti = new ApiUtil__c(Name = 'CompassInternal' ,EndPoint__c ='https://richiestaonlinesvi.compassonline.it/B2BSOAP/rest/B2BREST/execute' ,Password__c = 'P00FLSDC',User__c = 'CDSLF00');      
        insert uti;        
        test.startTest();
        UtilityMockResponse UMR = new UtilityMockResponse();
        UMR.apiname='ocs.recuperaDataApprovazione';
        Test.setMock(HttpCalloutMock.class,UMR);

        OCSRecuperaDataApprovazioneRequest.RecuperaDataApprovazioneRequest rda = new OCSRecuperaDataApprovazioneRequest.RecuperaDataApprovazioneRequest();

        rda.tipoPratica = 'CA';
        rda.numPratica = '33190097388';

        OCSRecuperaDataApprovazioneResponse.RecuperaDataApprovazioneResponse res = new OCSRecuperaDataApprovazioneResponse.RecuperaDataApprovazioneResponse();

        res.dataApprovazione = '20061116';

        OCSRecuperaDataApprovazioneInvoker.invoke('CA', '33190097388');

        test.stopTest();
    }   
}