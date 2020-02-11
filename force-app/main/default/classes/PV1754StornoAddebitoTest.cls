@IsTest
public with sharing class  PV1754StornoAddebitoTest {

    @TestSetup
    public static void setup() {
        insert new List<ApiRest__c>{
                new ApiRest__c(Name = 'ocs.cartaDatiFinanziari', Ref__c = 'CompassInternal', EndPoint__c = 'Test', Method__c = 'POST', User__c = 'Test', Password__c = 'Test')
        };

        insert new ApiUtil__c(Name = 'CompassInternal', Ref__c = 'CompassInternal', EndPoint__c = 'Test', User__c = 'Test', Password__c = 'Test');
        insert new Account(Name = 'Test Account', Codice_Ufficio__c = 'CCInterno', RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Uffici_e_Altro').getRecordTypeId());

        XCS_Template__c xcsTemplate = new XCS_Template__c(ExternalCode__c = '000001', Body__c = 'Body Test');
        insert xcsTemplate;

        insert new XCS_Categoria__c(Name = 'Inserimento blocco', XCS_Template__c = xcsTemplate.Id, External_Id__c = '3555');
        insert new XCS_Categoria__c(Name = 'Inserimento blocco', XCS_Template__c = xcsTemplate.Id, External_Id__c = '5299');
    }

    @IsTest
    public static void test1() {
        Test.startTest();
        OCSCartaDatiFinanziariResponse response = new OCSCartaDatiFinanziariResponse();
        Test.setMock(HttpCalloutMock.class, new DatiFinanziariCartaMock(JSON.serialize(response)));
        OCSCartaDatiFinanziariResponse.DatiCartaDatiFinanziariResponseDTO  responseDTO = PV1754StornoAddebito.getDatiFinanziariCarta('0123456789');
        Test.stopTest();
    }

    @IsTest
    public static void test2() {
        Test.startTest();
        PV1754StornoAddebito.PV1754StornoAddebitoForm form = initForm();

        try {
            form.modalitaRimborso.put('modalitaPagamento', 'Assegno');
            PV1754StornoAddebito.conferma(form);
        }
        catch (Exception e) {
            System.debug('[PV1754StornoAddebitoTest - test7] : ' + e.getMessage());
        }
        Test.stopTest();
    }

    @IsTest
    public static void test3() {
        Test.startTest();
        PV1754StornoAddebito.PV1754StornoAddebitoForm form = initForm();

        try {
            form.modalitaRimborso.put('modalitaPagamento', 'Bonifico');
            PV1754StornoAddebito.conferma(form);
        }
        catch (Exception e) {
            System.debug('[PV1754StornoAddebitoTest - test7] : ' + e.getMessage());
        }
        Test.stopTest();
    }

    @IsTest
    public static void test4() {
        Test.startTest();
        PV1754StornoAddebito pv1754 = new PV1754StornoAddebito();
        PV1754StornoAddebito.PV1754StornoAddebitoForm form = initForm();
        XCS_Messaggio__c xcsMessaggio = pv1754.preparaMessaggioOCS(form, new XCS_Messaggio__c());
        Test.stopTest();
    }

    @IsTest
    public static void test5() {
        Test.startTest();
        PV1754StornoAddebito pv1754 = new PV1754StornoAddebito();
        PV1754StornoAddebito.PV1754StornoAddebitoForm form = initForm();
        pv1754.recuperaNotaSpecificaPV(form, new Case());
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

    private static PV1754StornoAddebito.PV1754StornoAddebitoForm initForm() {
        PV1754StornoAddebito.PV1754StornoAddebitoForm form = new  PV1754StornoAddebito.PV1754StornoAddebitoForm();
        form = (PV1754StornoAddebito.PV1754StornoAddebitoForm) new PVTestFactory().initForm('3555', form);

        PV1754StornoAddebito.Rimborso rimborso = new PV1754StornoAddebito.Rimborso();
        rimborso.id = '000';
        rimborso.descrizione = 'Rimborso test';
        rimborso.value = 100;
        form.numeroPratica = 'xxxxxxxxxxxx';
        form.elencoRimborsi = new List<PV1754StornoAddebito.Rimborso>{rimborso};
        form.richiestaRimborso = 'Si';
        form.modalitaRimborso = new Map<String, String>{
                'modalitaPagamento' => '',
                'denominazioneAzienda' => '',
                'indirizzoSpedizione' => '',
                'cap' => '',
                'provincia' => '',
                'citta' => ''
        };
        return form;
    }
}