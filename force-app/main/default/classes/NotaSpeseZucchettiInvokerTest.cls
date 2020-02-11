@isTest
public class NotaSpeseZucchettiInvokerTest {

    @TestSetup
    static void setup(){   
        if(([SELECT Id FROM User WHERE Username = 'test@compass.com.test']).size()==0){
            Profile p = [SELECT Id FROM Profile WHERE Name='System Administrator'];
            User utenteAdmin = new User(
                FirstName= 'TestAdmin',
                LastName= 'TestAdmin',
                Username= 'testadmin@compass.com.test',
                Email= 'testadmin@lynxspa.com',
                Alias= 'testad',
                TimeZoneSidKey= 'Europe/Rome',
                LocaleSidKey= 'it_IT',
                EmailEncodingKey= 'ISO-8859-1',
                ProfileId= p.Id,
                LanguageLocaleKey= 'en_US'
            );
            insert utenteAdmin;
        }
    }
    
    @isTest
    static void invokeTest() {
        User u = [SELECT Id FROM User WHERE LastName = 'TestAdmin']; 
        
        String response = '{"resultCode":20,"resultMessage":"Service creaNotaSpeseZucchetti is unavailable."}';
        ApiRest__c test1 = new ApiRest__c(Method__c = 'POST' ,Test_Response__c= response ,Test_Request__c = 'testRequest',Mock__c = false,User__c = 'CDSLF00',Password__c = 'P00FLSDC' ,Name ='ocs.creaNotaSpeseZucchetti',EndPoint__c = 'https://richiestaonlinesvi.compassonline.it/B2BSOAP/rest/B2BREST/execute');      
        insert test1;
        /*NotaSpeseZucchettiRequest request = new NotaSpeseZucchettiRequest();
        NotaSpeseZucchettiResponse myResponse;
        
        Test.startTest();
		System.runAs(u) {
            UtilityMockResponse UMR = new UtilityMockResponse();
            UMR.apiname='ocs.creaNotaSpeseZucchetti';
            Test.setMock(HttpCalloutMock.class,UMR);
           
            request.creaNotaSpeseZucchettiRequest.codiceUtente = 'CU6654';
			request.creaNotaSpeseZucchettiRequest.panno = '2018.0';
			request.creaNotaSpeseZucchettiRequest.pmese = '2.0';
			request.creaNotaSpeseZucchettiRequest.ptiporimb = '1.0';
			request.creaNotaSpeseZucchettiRequest.pdistanza = '50.0';
            request.creaNotaSpeseZucchettiRequest.pcodestrdl = '';
			request.creaNotaSpeseZucchettiRequest.pcodestsub = '';
			request.creaNotaSpeseZucchettiRequest.pcodfiscale = '';
			request.creaNotaSpeseZucchettiRequest.pidstateini = '';
			request.creaNotaSpeseZucchettiRequest.pidcityini = '';
			request.creaNotaSpeseZucchettiRequest.pdataini = '';
			request.creaNotaSpeseZucchettiRequest.poraini = '';
			request.creaNotaSpeseZucchettiRequest.pidstatefin = '';
			request.creaNotaSpeseZucchettiRequest.pidcityfin = '';
			request.creaNotaSpeseZucchettiRequest.pdatafin = '';
			request.creaNotaSpeseZucchettiRequest.porafin = '';
			request.creaNotaSpeseZucchettiRequest.pmotitr = '';
			request.creaNotaSpeseZucchettiRequest.pdefore = '';
			request.creaNotaSpeseZucchettiRequest.pannotazioni = '';
			request.creaNotaSpeseZucchettiRequest.pitinerario = '';
			request.creaNotaSpeseZucchettiRequest.ptipoauto = '';
			request.creaNotaSpeseZucchettiRequest.pmodauto = '';
			request.creaNotaSpeseZucchettiRequest.pantarga = '';
			request.creaNotaSpeseZucchettiRequest.pnotekm = '';
            
            myResponse = NotaSpeseZucchettiInvoker.invoke(request);
        }
		Test.stopTest();

        System.assertEquals('20',myResponse.resultCode);
        System.assertEquals('Service creaNotaSpeseZucchetti is unavailable.',myResponse.resultMessage);*/
    }
    
}