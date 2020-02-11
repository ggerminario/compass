@IsTest
public with sharing class PV2871DuplicatoCartaTest {
    @TestSetup
    public static void setup() {
        insert new List<ApiRest__c>{
                new ApiRest__c(Name = 'ocs.recuperaBlocchiCarta', Ref__c = 'CompassInternal', EndPoint__c = 'recuperaBlocchiCarta', Method__c = 'POST', User__c = 'Test', Password__c = 'Test'),
                new ApiRest__c(Name = 'ocs.bloccoSbloccoCarta', Ref__c = 'CompassInternal', EndPoint__c = 'bloccoSbloccoCarta', Method__c = 'POST', User__c = 'Test', Password__c = 'Test'),
                new ApiRest__c(Name = 'ocs.cartaDatiFinanziari', Ref__c = 'CompassInternal', EndPoint__c = 'cartaDatiFinanziari', Method__c = 'POST', User__c = 'Test', Password__c = 'Test'),
                new ApiRest__c(Name = 'ocs.azionePreFurtoFurto', Ref__c = 'CompassInternal', EndPoint__c = 'azionePreFurtoFurto', Method__c = 'POST', User__c = 'Test', Password__c = 'Test'),
                new ApiRest__c(Name = 'ocs.recuperaInfoCarta', Ref__c = 'CompassInternal', EndPoint__c = 'recuperaInfoCarta', Method__c = 'POST', User__c = 'Test', Password__c = 'Test'),
                new ApiRest__c(Name = 'ocs.recuperaIndirizziCliente', Ref__c = 'CompassInternal', EndPoint__c = 'recuperaIndirizziCliente', Method__c = 'POST', User__c = 'Test', Password__c = 'Test')
        };

        insert new ApiUtil__c(Name = 'CompassInternal', Ref__c = 'CompassInternal', EndPoint__c = 'Test', User__c = 'Test', Password__c = 'Test');
        insert new Account(Name = 'Test Account', Codice_Ufficio__c = 'CCInterno', RecordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName().get('Uffici_e_Altro').getRecordTypeId());

        XCS_Template__c xcsTemplate = new XCS_Template__c();
        xcsTemplate.ExternalCode__c = '000001';
        insert xcsTemplate;

        insert new XCS_Categoria__c(Name = 'Inserimento blocco', XCS_Template__c = xcsTemplate.Id, External_Id__c = '3255');

        insert new XCS_CompassParameters__c(Name = 'WS.CDF.SC.55', Group__c = 'WS.carteDatiFinanziari.StatoCarta', Label__c = 'UTILIZZATA', Value__c = '55');
        insert new XCS_CompassParameters__c(Name = 'WS.CDF.SR.S', Group__c = 'WS.carteDatiFinanziari.StatoRinnovo', Label__c = 'RINNOVO DA ATTIVARE', Value__c = 'S');
    }

    @IsTest
    public static void test1() {
        Test.startTest();
        OCSBloccoSbloccoCartaInvoker.Response response = getOCSBloccoSbloccoCartaInvokerResponse();
        Test.setMock(HttpCalloutMock.class, new BloccoSbloccoCartaInvokerMock(JSON.serialize(response)));
        PV2871DuplicatoCarta.BloccoSbloccoCartaResult result = PV2871DuplicatoCarta.bloccoSbloccoCarta('0123456789', 'I', 'IV', null);
        Test.stopTest();

        System.assertEquals(true, result != null);
    }

    @IsTest
    public static void test2() {
        Test.startTest();
        OCSBloccoSbloccoCartaInvoker.Response response = getOCSBloccoSbloccoCartaInvokerResponse();
        response.datiBloccoSbloccoCartaResponse = null;
        Test.setMock(HttpCalloutMock.class, new BloccoSbloccoCartaInvokerMock(JSON.serialize(response)));
        PV2871DuplicatoCarta.BloccoSbloccoCartaResult result = PV2871DuplicatoCarta.bloccoSbloccoCarta('0123456789', 'I', 'IV', null);
        Test.stopTest();

        System.assertEquals(true, result == null);
    }

    @IsTest
    public static void test3() {
        Test.startTest();
        PV2871DuplicatoCarta.PV2871DuplicatoCartaForm form = initForm();

        try {
            PV2871DuplicatoCarta.conferma(form);
        }
        catch (Exception e) {
            System.debug('[PV2871DuplicatoCartaTest - test7] : ' + e.getMessage());
        }
        Test.stopTest();
    }

    @IsTest
    public static void test4() {
        Test.startTest();
        PV2871DuplicatoCarta pv2871 = new PV2871DuplicatoCarta();
        PV2871DuplicatoCarta.PV2871DuplicatoCartaForm form = initForm();
        Case pvCase = pv2871.completaCasePostVendita(new Case(), form);
        XCS_Messaggio__c xcsMessaggio = pv2871.preparaMessaggioOCS(form, new XCS_Messaggio__c());
        String notaSpecificaPV = pv2871.recuperaNotaSpecificaPV(form, pvCase);
        Test.stopTest();

        System.assertEquals(true, pvCase != null);
        System.assertEquals(true, xcsMessaggio != null);
        System.assertEquals(true, notaSpecificaPV != null);
    }

    @IsTest
    public static void test5() {
        Test.startTest();
        OCSRecuperaIndirizziClienteResponse response = new OCSRecuperaIndirizziClienteResponse();
        response.resultCode = 0;
        OCSRecuperaIndirizziClienteResponse.IndirizzoDTO indirizzoDTO = new OCSRecuperaIndirizziClienteResponse.IndirizzoDTO();
        indirizzoDTO.tipoIndirizzo = '';
        indirizzoDTO.indirizzo = '';
        indirizzoDTO.civico = '';
        indirizzoDTO.cap = '';
        indirizzoDTO.localita = '';
        indirizzoDTO.provincia = '';
        indirizzoDTO.nazione = '';
        indirizzoDTO.capRischio = '';
        response.recuperaIndirizziClienteResponse.elencoIndirizzi.add(indirizzoDTO);
        Test.setMock(HttpCalloutMock.class, new RecuperaIndirizziClienteMock(JSON.serialize(response)));
        List<PV2871DuplicatoCarta.Indirizzo> indirizzi = PV2871DuplicatoCarta.getIndirizziCliente('000000000');
        Test.stopTest();

        System.assertEquals(1, indirizzi.size());
    }

    private class RecuperaIndirizziClienteMock implements HttpCalloutMock {

        public String body { get; set;}

        public RecuperaIndirizziClienteMock(String body) {
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

    private class BloccoSbloccoCartaInvokerMock implements HttpCalloutMock {

        public String body { get; set;}

        public BloccoSbloccoCartaInvokerMock(String body) {
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

    private static OCSBloccoSbloccoCartaInvoker.Response getOCSBloccoSbloccoCartaInvokerResponse() {
        OCSBloccoSbloccoCartaInvoker.Response response = new OCSBloccoSbloccoCartaInvoker.Response();
        response.resultCode = 0;
        response.resultMessage = 'OK';
        response.datiBloccoSbloccoCartaResponse = new OCSBloccoSbloccoCartaInvoker.BloccoSbloccoCartaResponseDTO();
        response.datiBloccoSbloccoCartaResponse.bloccoCarta = 'IV';
        response.datiBloccoSbloccoCartaResponse.as400Status = 'KO';
        response.datiBloccoSbloccoCartaResponse.as400Errore = '7786 Blocco già presente sulla carta';
        return response;
    }

    private static PV2871DuplicatoCarta.PV2871DuplicatoCartaForm initForm() {
        PV2871DuplicatoCarta.PV2871DuplicatoCartaForm form = new  PV2871DuplicatoCarta.PV2871DuplicatoCartaForm();
        form = (PV2871DuplicatoCarta.PV2871DuplicatoCartaForm) new PVTestFactory().initForm('3255', form);
         form.bloccoCarta = new PV2871DuplicatoCarta.BloccoCarta();
        form.bloccoCarta.keyCode = 'CF';
        form.bloccoCarta.descrizione = 'Conferma Firma';
        return form;
    }

    public static PV2871DuplicatoCarta.PV2871DuplicatoCartaForm creaForm(){
        PVTestFactory pvTestFactory = new PVTestFactory();

		PV2871DuplicatoCarta.PV2871DuplicatoCartaForm form = new PV2871DuplicatoCarta.PV2871DuplicatoCartaForm();

		return (PV2871DuplicatoCarta.PV2871DuplicatoCartaForm) pvTestFactory.initForm('2871', form);
    }

    private static OCSAzionePreFurtoInvoker.Response getOCSAzionePreFurtoInvoker() {
        OCSAzionePreFurtoInvoker.Response response = new OCSAzionePreFurtoInvoker.Response();
        response.resultCode = 0;
        response.resultMessage = 'OK';
        response.azionePreFurtoFurtoResponse = new OCSAzionePreFurtoInvoker.AzionePreFurtoFurtoResponseDTO();
        response.azionePreFurtoFurtoResponse.panNuovo = '56574839';
        response.azionePreFurtoFurtoResponse.AS400Status = 'OK';
        response.azionePreFurtoFurtoResponse.AS400Errore = '';
        return response;
    }
    @IsTest
    public static void testPreFurto() {
        Test.startTest();
        OCSAzionePreFurtoInvoker.Response response = getOCSAzionePreFurtoInvoker();
        Test.setMock(HttpCalloutMock.class, new AzionePreFurtoInvokerMock(JSON.serialize(response)));
        PV2871DuplicatoCarta.AzionePreFurtoFurtoResult result = PV2871DuplicatoCarta.azionePreFurtoFurto('CA', 'AG', '12', '3109269996','F', 'S', '0', '', 'S', '', '');
        Test.stopTest();

        System.assertEquals(true, result != null);
    }

     private class AzionePreFurtoInvokerMock implements HttpCalloutMock {

        public String body { get; set;}

        public AzionePreFurtoInvokerMock(String body) {
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

    private static OCSCartaDatiFinanziariResponse getOCSCartaDatiFinanziariInvoker() {
     
        OCSCartaDatiFinanziariResponse response = new OCSCartaDatiFinanziariResponse();
        response.resultCode = 0;
        response.resultMessage = 'OK';
        response.datiCartaDatiFinanziariResponse = new OCSCartaDatiFinanziariResponse.DatiCartaDatiFinanziariResponseDTO();
        response.datiCartaDatiFinanziariResponse.numeroPratica = '8180824247';
        response.datiCartaDatiFinanziariResponse.filiale = '212';
        response.datiCartaDatiFinanziariResponse.emettitore = '8';
        response.datiCartaDatiFinanziariResponse.pagamentoMinimo = 0;
        response.datiCartaDatiFinanziariResponse.pagamentoMinimoPerc = '';
        response.datiCartaDatiFinanziariResponse.commissioneEntrata = '';
        response.datiCartaDatiFinanziariResponse.modCalcoloRata = '';
        response.datiCartaDatiFinanziariResponse.intestazione1 = '';
        response.datiCartaDatiFinanziariResponse.intestazione2 = '';
        response.datiCartaDatiFinanziariResponse.dataValidita = '20180522';
        response.datiCartaDatiFinanziariResponse.dataScadenza = '201902';
        response.datiCartaDatiFinanziariResponse.checkIntermediario = '';
        response.datiCartaDatiFinanziariResponse.pagamento = '';
        response.datiCartaDatiFinanziariResponse.bancaCliAbi = '';
        response.datiCartaDatiFinanziariResponse.bancaCliCab = '';
        response.datiCartaDatiFinanziariResponse.contoCorrente = '';
        response.datiCartaDatiFinanziariResponse.iban = 'IT04P0305801604100571605864';
        response.datiCartaDatiFinanziariResponse.comRinnovo = '';
        response.datiCartaDatiFinanziariResponse.comRinnovo1 = '';
        response.datiCartaDatiFinanziariResponse.comRinnovoDurata1 = '';
        response.datiCartaDatiFinanziariResponse.comRinnovo2 = '';
        response.datiCartaDatiFinanziariResponse.comRinnovoDurata2 = '';
        response.datiCartaDatiFinanziariResponse.comRinnovo3 = '';
        response.datiCartaDatiFinanziariResponse.comRinnovoDurata3 = '';
        response.datiCartaDatiFinanziariResponse.stato = '55';
        response.datiCartaDatiFinanziariResponse.blocco = '';
        response.datiCartaDatiFinanziariResponse.tassoTan = '';
        response.datiCartaDatiFinanziariResponse.tassoTaeg = '';
        response.datiCartaDatiFinanziariResponse.pan = '4134280846406477';
        response.datiCartaDatiFinanziariResponse.fidoTotale = 0;
        response.datiCartaDatiFinanziariResponse.dispTotale = 0;
        response.datiCartaDatiFinanziariResponse.fidoRiserva1 = '';
        response.datiCartaDatiFinanziariResponse.dispRiserva1 = '';
        response.datiCartaDatiFinanziariResponse.fidoRiserva2 = '';
        response.datiCartaDatiFinanziariResponse.dispRiserva2 = '';
        response.datiCartaDatiFinanziariResponse.fidoRiserva3 = '';
        response.datiCartaDatiFinanziariResponse.dispRiserva3 = '';
        response.datiCartaDatiFinanziariResponse.flagAttivazioneCarta = 'S';
        response.datiCartaDatiFinanziariResponse.codProdotto = '';
        response.datiCartaDatiFinanziariResponse.desProdotto = '';
        response.datiCartaDatiFinanziariResponse.flagAlertSms = '';

        response.datiCartaDatiFinanziariResponse.riservaPrincipaleFido = 0;
        response.datiCartaDatiFinanziariResponse.riservaPrincipaleFidoSegno = '';
        response.datiCartaDatiFinanziariResponse.riservaPrincipaleSaldo = 0;        
        response.datiCartaDatiFinanziariResponse.riservaPrincipaleSaldoSegno = '';       
        response.datiCartaDatiFinanziariResponse.riservaPrincipaleDisp =0;
        response.datiCartaDatiFinanziariResponse.riservaPrincipaleDispSegno = '';
        response.datiCartaDatiFinanziariResponse.riservaPrincipaleSconfino = 0;      
        response.datiCartaDatiFinanziariResponse.riservaPrincipaleSconfinoSegno = '';       
        response.datiCartaDatiFinanziariResponse.riservaPrincipaleOverlimit = 0;
        response.datiCartaDatiFinanziariResponse.riservaPrincipaleOverlimitSegno = '';
        response.datiCartaDatiFinanziariResponse.riservaPrincipaleDispTeorMax = 0;       
        response.datiCartaDatiFinanziariResponse.riservaPrincipaleDispTeorMaxSegno = '';       
        response.datiCartaDatiFinanziariResponse.riservaSalvadanaioFido = 0;
        response.datiCartaDatiFinanziariResponse.riservaSalvadanaioFidoSegno = '';
        response.datiCartaDatiFinanziariResponse.riservaSalvadanaioSaldo = 0;        
        response.datiCartaDatiFinanziariResponse.riservaSalvadanaioSaldoSegno = '';       
        response.datiCartaDatiFinanziariResponse.riservaSalvadanaioDisp = 0;
        response.datiCartaDatiFinanziariResponse.riservaSalvadanaioDispSegno = '';
        response.datiCartaDatiFinanziariResponse.riservaSalvadanaioSconfino = 0;        
        response.datiCartaDatiFinanziariResponse.riservaSalvadanaioSconfinoSegno = '';       
        response.datiCartaDatiFinanziariResponse.riservaSalvadanaioOverlimit = 0;
        response.datiCartaDatiFinanziariResponse.riservaSalvadanaioOverlimitSegno = '';
        response.datiCartaDatiFinanziariResponse.riservaSalvadanaioDispTeorMax = 0;        
        response.datiCartaDatiFinanziariResponse.riservaSalvadanaioDispTeorMaxSegno = '';       
        response.datiCartaDatiFinanziariResponse.riservaInternetFido = 0;
        response.datiCartaDatiFinanziariResponse.riservaInternetFidoSegno = '';
        response.datiCartaDatiFinanziariResponse.riservaInternetSaldo = 0;        
        response.datiCartaDatiFinanziariResponse.riservaInternetSaldoSegno = '';       
        response.datiCartaDatiFinanziariResponse.riservaInternetDisp = 0;
        response.datiCartaDatiFinanziariResponse.riservaInternetDispSegno = '';
        response.datiCartaDatiFinanziariResponse.riservaInternetSconfino = 0;        
        response.datiCartaDatiFinanziariResponse.riservaInternetSconfinoSegno = '';       
        response.datiCartaDatiFinanziariResponse.riservaInternetOverlimit = 0;
        response.datiCartaDatiFinanziariResponse.riservaInternetOverlimitSegno = '';
        response.datiCartaDatiFinanziariResponse.riservaInternetDispTeorMax = 0;
        response.datiCartaDatiFinanziariResponse.riservaInternetDispTeorMaxSegno = '';       
        response.datiCartaDatiFinanziariResponse.riservaMulticontoFido = 0;
        response.datiCartaDatiFinanziariResponse.riservaMulticontoSaldo = 0;
        response.datiCartaDatiFinanziariResponse.riservaMulticontoSaldoSegno = '';        
        response.datiCartaDatiFinanziariResponse.riservaMulticontoDisp = 0;       
        response.datiCartaDatiFinanziariResponse.riservaMulticontoDispSegno = '';
        response.datiCartaDatiFinanziariResponse.riservaMulticontoSconfino = 0;
        response.datiCartaDatiFinanziariResponse.riservaMulticontoSconfinoSegno = '';       
        response.datiCartaDatiFinanziariResponse.riservaMulticontoOverlimit = 0;       
        response.datiCartaDatiFinanziariResponse.riservaMulticontoOverlimitSegno = '';
        response.datiCartaDatiFinanziariResponse.riservaMulticontoDispTeorMax = 0;
        response.datiCartaDatiFinanziariResponse.riservaMulticontoDispTeorMaxSegno = ''; 
        response.datiCartaDatiFinanziariResponse.riservaMulticontoDispTeorMaxSegno = '';
        response.datiCartaDatiFinanziariResponse.as400Status   = 'OK';
        response.datiCartaDatiFinanziariResponse.as400Errore = '';
        response.datiCartaDatiFinanziariResponse.dataValiditaSlashed ='';
        response.datiCartaDatiFinanziariResponse.dataScadenzaSlashed=''; 
        response.datiCartaDatiFinanziariResponse.fidoCustom='';
        response.datiCartaDatiFinanziariResponse.disponibilitaCustom='';
        response.datiCartaDatiFinanziariResponse.modCalcoloRataCustom='';
        response.datiCartaDatiFinanziariResponse.statoCustom='S';
        response.datiCartaDatiFinanziariResponse.statoRinnovoCustom='';

        return response;
    }
    @IsTest
    public static void testcartaDatiFinanziari() {
        Test.startTest();
        
        //OCSCartaDatiFinanziariResponse response = getOCSCartaDatiFinanziariInvoker();
        //Test.setMock(HttpCalloutMock.class, new CartaDatiFinanziariInvokerMock(JSON.serialize(response)));
        Test.setMock(HttpCalloutMock.class, new TestCartaDatiFinanziariMock());
        PV2871DuplicatoCarta.DatiDuplicatoCarta result = PV2871DuplicatoCarta.getDatiDuplicatoCarta('8180824247');
        Test.stopTest();

        System.assertEquals(true, result != null);
    }

     private class CartaDatiFinanziariInvokerMock implements HttpCalloutMock {

        public String body { get; set;}

        public CartaDatiFinanziariInvokerMock(String body) {
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

    private class TestCartaDatiFinanziariMock implements HttpCalloutMock {

        public HttpResponse respond(HttpRequest request) {
            HttpResponse response = new HttpResponse();
            response.setHeader('Content-Type', 'application/json');
            response.setStatus('OK');
            response.setStatusCode(200);

            Map<String, Object> boyRequest = (Map<String, Object>) JSON.deserializeUntyped(request.getBody());

            if(boyRequest.get('serviceId') == 'cartaDatiFinanziari') {
                OCSCartaDatiFinanziariResponse cartaDatiFinanziariResponse = getOCSCartaDatiFinanziariInvoker();
                response.setBody(JSON.serialize(cartaDatiFinanziariResponse));
            }
            else if(boyRequest.get('serviceId') == 'recuperaInfoCarta') {
                OCSRecuperaInfoCartaResponse ocsRecuperaInfoCartaResponse = new OCSRecuperaInfoCartaResponse();
                ocsRecuperaInfoCartaResponse.recuperaInfoCartaResponse = new OCSRecuperaInfoCartaResponse.RecuperaInfoCartaResponse();
                ocsRecuperaInfoCartaResponse.recuperaInfoCartaResponse.importoCommAdesione = '100';
                response.setBody(JSON.serialize(ocsRecuperaInfoCartaResponse));
            }

            return response;
        }
    }

}