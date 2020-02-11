@isTest
public class OCSRecuperaLivelloFirmaInvokerTest {
    
    @isTest
    static void test(){

        String responseTest ='{"resultMessage":"Ok","resultCode":0,"genericRecuperadatiResponseDTO":[{"out_1":"CO","out_2":"17209306","out_3":"30","out_4":"","out_5":"","out_6":"","out_7":"","out_8":"","out_9":"","out_10":""}]}'; 
        ApiRest__c test1 = new ApiRest__c(Method__c = 'POST' ,Test_Response__c=responseTest,Test_Request__c = '',Mock__c = false,User__c = 'CDSLF00',Password__c = 'P00FLSDC' ,Name ='ocs.genericRecuperaDati',EndPoint__c = 'https://richiestaonlinesvi.compassonline.it/B2BSOAP/rest/B2BREST/execute', Ref__c='CompassInternal');      
        insert test1;
        ApiUtil__c uti = new ApiUtil__c(Name = 'CompassInternal' ,EndPoint__c ='https://richiestaonlinesvi.compassonline.it/B2BSOAP/rest/B2BREST/execute' ,Password__c = 'P00FLSDC',User__c = 'CDSLF00');      
        insert uti;        
        test.startTest();
        UtilityMockResponse UMR = new UtilityMockResponse();
        UMR.apiname='ocs.genericRecuperaDati';
        Test.setMock(HttpCalloutMock.class,UMR);
        OCSRecuperaLivelloFirmaInvoker.GenericRecuperaDatiRequestDTO rdto = new OCSRecuperaLivelloFirmaInvoker.GenericRecuperaDatiRequestDTO();
        rdto.input_1 = 'CO';
        rdto.input_2 = '17209306';
        rdto.input_3 = '';
        rdto.input_4 = '';
        rdto.input_5 = '';
        
        OCSRecuperaLivelloFirmaInvoker.GenericRecuperaDatiResponseDTO respo = new OCSRecuperaLivelloFirmaInvoker.GenericRecuperaDatiResponseDTO();
        respo.out_1 = ''; 
        respo.out_2 = ''; 
        respo.out_3 = ''; 
        respo.out_4 = ''; 
        respo.out_5 = ''; 
        respo.out_6 = ''; 
        respo.out_7 = ''; 
        respo.out_8 = ''; 
        respo.out_9 = ''; 
        respo.out_10 = ''; 


        //req.add(rdto);    
        OCSRecuperaLivelloFirmaInvoker.Response res = OCSRecuperaLivelloFirmaInvoker.invoke(rdto);
        test.stopTest();
    }   
}