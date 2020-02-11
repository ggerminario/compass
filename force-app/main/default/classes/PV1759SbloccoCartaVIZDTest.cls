/**
 * @File Name          : PV1759SbloccoCartaVIZDTest.cls
 * @Description        : 
 * @Author             : ChangeMeIn@UserSettingsUnder.SFDoc
 * @Group              : 
 * @Last Modified By   : ChangeMeIn@UserSettingsUnder.SFDoc
 * @Last Modified On   : 8/1/2020, 17:09:22
 * @Modification Log   : 
 * Ver       Date            Author      		    Modification
 * 1.0    8/1/2020   ChangeMeIn@UserSettingsUnder.SFDoc     Initial Version
**/
@IsTest
public with sharing class PV1759SbloccoCartaVIZDTest {
    
    @TestSetup
    public static void setup() {
        
        insert new List<ApiRest__c>{
                new ApiRest__c(Name = 'ocs.cartaDatiFinanziari', Ref__c = 'CompassInternal', EndPoint__c = 'Test', Method__c = 'POST', User__c = 'Test', Password__c = 'Test')
        };
        insert new ApiUtil__c(Name = 'CompassInternal', Ref__c = 'CompassInternal', EndPoint__c = 'Test', User__c = 'Test', Password__c = 'Test');
        insert new Account(Name = 'Test Account', Codice_Ufficio__c = 'CCInterno', RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Uffici_e_Altro').getRecordTypeId());

        XCS_Template__c xcsTemplate = new XCS_Template__c();
        xcsTemplate.ExternalCode__c = '000001';
        insert xcsTemplate;

        insert new XCS_Categoria__c(Name = 'Sblocco carta VI - ZD', XCS_Template__c = xcsTemplate.Id, External_Id__c = '1759');
    }

    @IsTest
    public static void test1() {
        Test.startTest();
        PV1759SbloccoCartaVIZD.PV1759SbloccoCartaVIZDForm form = initForm();

        try {
            PV1759SbloccoCartaVIZD.conferma(form);
        }
        catch (Exception e) {
            System.debug('[PV1759SbloccoCartaVIZDTest - test1] : ' + e.getMessage());
        }
        Test.stopTest();
    }

    @IsTest
    public static void test2() {
        Test.startTest();
        PV1759SbloccoCartaVIZD pv1759 = new PV1759SbloccoCartaVIZD();
        PV1759SbloccoCartaVIZD.PV1759SbloccoCartaVIZDForm form = initForm();
        Case pvCase = pv1759.completaCasePostVendita(new Case(), form);
        XCS_Messaggio__c xcsMessaggio = pv1759.preparaMessaggioOCS(form, new XCS_Messaggio__c());
        String notaSpecificaPV = pv1759.recuperaNotaSpecificaPV(form, pvCase);
        Test.stopTest();

        System.assertEquals(true, pvCase != null);
        System.assertEquals(true, xcsMessaggio != null);
        System.assertEquals(true, notaSpecificaPV != null);
    }

     private static PV1759SbloccoCartaVIZD.PV1759SbloccoCartaVIZDForm initForm() {
        PV1759SbloccoCartaVIZD.PV1759SbloccoCartaVIZDForm form = new  PV1759SbloccoCartaVIZD.PV1759SbloccoCartaVIZDForm();
        form = (PV1759SbloccoCartaVIZD.PV1759SbloccoCartaVIZDForm) new PVTestFactory().initForm('1759', form);
        
        return form;
    }
    @IsTest
    public static void test3() {
        Test.startTest();
        OCSCartaDatiFinanziariResponse response = new OCSCartaDatiFinanziariResponse();
        Test.setMock(HttpCalloutMock.class, new DatiFinanziariCartaMock(JSON.serialize(response)));
        OCSCartaDatiFinanziariResponse.DatiCartaDatiFinanziariResponseDTO  responseDTO = PV1759SbloccoCartaVIZD.getDatiFinanziariCarta('0123456789');
        Test.stopTest();
    }
    private class DatiFinanziariCartaMock implements HttpCalloutMock {

        public String body { get; set;}

        public DatiFinanziariCartaMock(String body) {
            this.body = body;
        }

        public HttpResponse respond(HttpRequest request) {
            HttpResponse response = new HttpResponse();
            response.setHeader('Content-Type', 'application/json');
            response.setStatus('OK');
            response.setStatusCode(200);
            response.setBody(this.body);
            return response;
        }
    }
}