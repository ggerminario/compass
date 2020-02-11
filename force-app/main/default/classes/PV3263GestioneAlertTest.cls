/**
 * @File Name          : PV3263GestioneAlertTest.cls
 * @Description        :
 * @Author             : Raffaele Prudenzano
 * @Group              :
 * @Last Modified By   : Raffaele Prudenzano
 * @Last Modified On   : 9/12/2019, 17:55:48
 * @Modification Log   :
 * Ver       Date            Author                  Modification
 * 1.0    9/12/2019   Raffaele Prudenzano     Initial Version
 **/
@isTest(SeeAllData = true) public with sharing class PV3263GestioneAlertTest {
	static String Categoria = '3263';




	@isTest static void testRecuperaDatiFinanziari() {
		String respJSON = '{"resultCode":0,"resultMessage":"Ok","datiCartaDatiFinanziariResponse":{"numeroPratica":"8180824247","filiale":"212","emettitore":"8","pagamentoMinimo":"0","pagamentoMinimoPerc":"0.00","commissioneEntrata":"0","modCalcoloRata":"T","intestazione1":"GAMBADOROANDREA","intestazione2":"","dataValidita":"20130426","dataScadenza":"201905","checkIntermediario":"12","pagamento":"RI","bancaCliAbi":"3058","bancaCliCab":"1604","contoCorrente":"100571605864","iban":"IT04P0305801604100571605864","comRinnovo":"0","comRinnovo1":"0","comRinnovoDurata1":"0","comRinnovo2":"0","comRinnovoDurata2":"0","comRinnovo3":"0","comRinnovoDurata3":"0","stato":"60","blocco":"IV","tassoTan":"0.000","tassoTaeg":"5.160","pan":"4134280846406477","fidoTotale":"350000","dispTotale":"350000","fidoRiserva1":"200000","dispRiserva1":"200000","fidoRiserva2":"150000","dispRiserva2":"150000","fidoRiserva3":"0","dispRiserva3":"0","flagAttivazioneCarta":"N","codProdotto":"NI","desProdotto":"CARTADIPENDENTIFIDO3500","flagAlertSms":"N","riservaPrincipaleFido":"200000","riservaPrincipaleFidoSegno":"","riservaPrincipaleSaldo":"0","riservaPrincipaleSaldoSegno":"","riservaPrincipaleDisp":"200000","riservaPrincipaleDispSegno":"","riservaPrincipaleSconfino":"0","riservaPrincipaleSconfinoSegno":"","riservaPrincipaleOverlimit":"5000","riservaPrincipaleOverlimitSegno":"","riservaPrincipaleDispTeorMax":"355000","riservaPrincipaleDispTeorMaxSegno":"","riservaSalvadanaioFido":"150000","riservaSalvadanaioFidoSegno":"","riservaSalvadanaioSaldo":"0","riservaSalvadanaioSaldoSegno":"","riservaSalvadanaioDisp":"150000","riservaSalvadanaioDispSegno":"","riservaSalvadanaioSconfino":"0","riservaSalvadanaioSconfinoSegno":"","riservaSalvadanaioOverlimit":"0","riservaSalvadanaioOverlimitSegno":"","riservaSalvadanaioDispTeorMax":"355000","riservaSalvadanaioDispTeorMaxSegno":"","riservaInternetFido":"0","riservaInternetFidoSegno":"","riservaInternetSaldo":"0","riservaInternetSaldoSegno":"","riservaInternetDisp":"0","riservaInternetDispSegno":"","riservaInternetSconfino":"0","riservaInternetSconfinoSegno":"","riservaInternetOverlimit":"0","riservaInternetOverlimitSegno":"","riservaInternetDispTeorMax":"0","riservaInternetDispTeorMaxSegno":"","riservaMulticontoFido":"0","riservaMulticontoFidoSegno":"","riservaMulticontoSaldo":"0","riservaMulticontoSaldoSegno":"","riservaMulticontoDisp":"0","riservaMulticontoDispSegno":"","riservaMulticontoSconfino":"0","riservaMulticontoSconfinoSegno":"","riservaMulticontoOverlimit":"0","riservaMulticontoOverlimitSegno":"","riservaMulticontoDispTeorMax":"0","riservaMulticontoDispTeorMaxSegno":"","as400Status":"OK","as400Errore":""}}';
		String numeroCarta = '123456';

		MyUtilityMockResponse UMR = new MyUtilityMockResponse();
		UMR.apiname = 'ocs.cartaDatiFinanziari';
		UMR.response = respJSON;
		Test.setMock(HttpCalloutMock.class, UMR);

		OCSCartaDatiFinanziariResponse.DatiCartaDatiFinanziariResponseDTO resp = PV3263GestioneAlert.recuperaDatiFinanziari(numeroCarta);
		System.assertNotEquals(null, resp);
	}

	@isTest static void testRecuperaInfoSIDcmp() {
		String respJson = '{"resultCode":0,"resultMessage":"Ok","recuperaInfoSIDResponse":{"keyN":"1100000477","pind":"","cellulare":"3341055291","email":"","modalitaInoltro":"","operTelef":"","attesaAttivazione":"","servizioSoglia":"","dataAttSoglia":"0","dataVarSoglia":"0","dataDisSoglia":"0","importoSoglia":"0","servizioAggEc":"","dataAttAggEc":"0","dataVarAggEc":"0","dataDisAggEc":"0","servizioSaldo":"","dataAttSaldo":"0","dataVarSaldo":"0","dataDisSaldo":"0","frequenzaSaldo":"","costoSaldo":"0","servAcqSaldoCm":"","dataAttAcqSaldo":"0","dataVarAcqSaldo":"0","dataDisAcqSaldo":"0","servizioDisp":"","dataAttDisp":"0","dataVarDisp":"0","dataDisDisp":"0","dataTrasmServDisp":"0","avvisoAut":"","dataAttAut":"0","dataVarAut":"0","dataDisAut":"0","impSogliaAut":"0","presSogliaAut":"","avvisoAutTot":"","dataAttAutTot":"0","dataVarAutTot":"0","dataDisAutTot":"0","impSogliaAutTot":"0","vprVariazProxRata":"","dataAttVpr":"0","dataVarVpr":"0","dataDisVpr":"0","protCampServizio":"","protCampDataAtt":"0","protCampDataVar":"0","protCampDataDis":"0","risPrincServizio":"","risPrincDataAtt":"0","risPrincDataVar":"0","risPrincDataDis":"0","bloccoServizio":"","bloccoDataAtt":"0","bloccoDataVar":"0","bloccoDataDis":"0","catbopteDescrizione":""}}';
		String numeroPratica = '123456';

		MyUtilityMockResponse UMR = new MyUtilityMockResponse();
		UMR.apiname = 'ocs.recuperaInfoSid';
		UMR.response = respJSON;
		Test.setMock(HttpCalloutMock.class, UMR);

		OCSRecuperaInfoSIDResponse.RecuperaInfoSIDResponseDTO resp = PV3263GestioneAlert.recuperaInfoSIDcmp(numeroPratica);
		System.assertNotEquals(null, resp);

	}

	@isTest static void testRimAttesaAttivazione() {

		String respJson = '{"resultCode":0,"resultMessage":"Ok","rimozioneAttesaAttivazioneResponse":{"as400Status":"KO","as400Errore":"6726Servizioattivo"}}';

		PV3263GestioneAlert.PV3263GestioneAlertForm form = creaForm();

		MyUtilityMockResponse UMR = new MyUtilityMockResponse();
		UMR.apiname = 'ocs.rimozioneAttesaAttivazione';
		UMR.response = respJSON;
		Test.setMock(HttpCalloutMock.class, UMR);


		OCSRimozioneAttesaAttivazioneInvoker.Response resp = PV3263GestioneAlert.rimAttesaAttivazione(form);
		System.assertNotEquals(null, resp);

	}

	@isTest static void testConfermaOK() {

		String respJson = '{"resultCode":0,"resultMessage":"Ok","rimozioneAttesaAttivazioneResponse":{"as400Status":"OK","as400Errore":"null"},"variazioneServiziInformativiResponse":{"as400Status":"OK","as400Errore":"1890Nessunavariazioneeffettuata"}}';

		PV3263GestioneAlert.PV3263GestioneAlertForm form = creaForm();
		form.emettitore = '3';
		form.attesaAtt = 'S';

		MyUtilityMockResponse UMR = new MyUtilityMockResponse();
		UMR.apiname = 'ocs.rimozioneAttesaAttivazione';
		UMR.response = respJSON;
		Test.setMock(HttpCalloutMock.class, UMR);

		PV3263GestioneAlert.conferma(form);
	}

	@isTest static void testConfermaKO1() {

		String respJson = '{"resultCode":0,"resultMessage":"Ok","rimozioneAttesaAttivazioneResponse":{"as400Status":"KO","as400Errore":"6726Servizioattivo"}}';

		PV3263GestioneAlert.PV3263GestioneAlertForm form = creaForm();
		form.emettitore = '3';
		form.attesaAtt = 'S';

		MyUtilityMockResponse UMR = new MyUtilityMockResponse();
		UMR.apiname = 'ocs.rimozioneAttesaAttivazione';
		UMR.response = respJSON;
		Test.setMock(HttpCalloutMock.class, UMR);

		Exception myException;
		try{
			PV3263GestioneAlert.conferma(form);
		} catch(EXception e) {
			myException= e;
		}
		System.assertNotEquals(null, myException);
	}

    @isTest static void testConfermaKO2() {

		String respJson = '{"resultCode":0,"resultMessage":"Ok","rimozioneAttesaAttivazioneResponse":{"as400Status":"OK","as400Errore":"null"},"variazioneServiziInformativiResponse":{"as400Status":"KO","as400Errore":"1890Nessunavariazioneeffettuata"}}';

		PV3263GestioneAlert.PV3263GestioneAlertForm form = creaForm();
		form.emettitore = '3';
		form.attesaAtt = 'S';

		MyUtilityMockResponse UMR = new MyUtilityMockResponse();
		UMR.apiname = 'ocs.rimozioneAttesaAttivazione';
		UMR.response = respJSON;
		Test.setMock(HttpCalloutMock.class, UMR);

		Exception myException;
		try{
			PV3263GestioneAlert.conferma(form);
		} catch(EXception e) {
			myException= e;
		}
		System.assertNotEquals(null, myException);
	}

	@isTest static void testVarServiziInformativi() {
		String respJson = '{"resultCode":0,"resultMessage":"Ok","variazioneServiziInformativiResponse":{"as400Status":"KO","as400Errore":"1890Nessunavariazioneeffettuata"}}';

		PV3263GestioneAlert.PV3263GestioneAlertForm form = creaForm();

		MyUtilityMockResponse UMR = new MyUtilityMockResponse();
		UMR.apiname = 'ocs.variazioneServiziInformativi';
		UMR.response = respJSON;
		Test.setMock(HttpCalloutMock.class, UMR);

		OCSVariazioneServiziInformativiInvoker.Response resp = PV3263GestioneAlert.varServiziInformativi(form);

		System.assertNotEquals(null, resp);

	}

	public static PV3263GestioneAlert.PV3263GestioneAlertForm creaForm() {
		PVtestFactory pVtestFactory = new PVtestFactory();

		PV3263GestioneAlert.PV3263GestioneAlertForm form = new PV3263GestioneAlert.PV3263GestioneAlertForm();



		form = (PV3263GestioneAlert.PV3263GestioneAlertForm) pVtestFactory.initForm(Categoria, form);

		OCSRecuperaInfoSIDResponse.RecuperaInfoSIDResponseDTO info = new OCSRecuperaInfoSIDResponse.RecuperaInfoSIDResponseDTO();
		form.info = info;

		form.pratica.numPratica = '12345';
		form.pratica.pan = '123';
		form.ot = '12345';
		form.cliente.dataNascita = '12/12/2001';


		form.info.cellulare = '123';
		form.info.email = '123';
		form.attesaAtt = '123';
		form.info.pind = '123';
		form.info.servAcqSaldoCm = '123';
		form.info.vprVariazProxRata = '123';
		form.info.servizioSoglia = '123';
		form.info.importoSoglia = '123';
		form.cliente.codCliente = '123';
		form.info.operTelef = '123';
		form.info.servizioAggEc = '123';
		form.info.protCampServizio = '123';
		form.info.bloccoServizio = '123';
		form.info.servizioSaldo = '123';
		form.info.frequenzaSaldo = '123';
		form.info.avvisoAut = '123';
		form.info.avvisoAutTot = '123';
		form.info.impSogliaAut = '123';
        form.info.impSogliaAutTot = '123';
		form.info.avvisoAutTot = 'S';
		form.info.presSogliaAut = '123';
		form.info.risPrincServizio = '123';

		return form;
	}


	public class MyUtilityMockResponse implements HttpCalloutMock {
		public String apiname;
		public String response;
		public HTTPResponse respond(HTTPRequest req) {
			HttpResponse res = new HttpResponse();
			String urlId = req.getEndpoint();
			//System.assert(urlId != null, 'API endpoint missing.');
			res.setHeader('Content-Type', 'application/json');
			System.debug('APINAME:::::::::::::> ' + apiname);
			ApiRest__c ar = [select Test_Request__c from Apirest__c where endpoint__c = :urlId and name = :apiname LIMIT 1];
			system.debug(ar);
			System.assert(ar != null, 'No rows for endpoint ' + urlId);
			System.assert(response != null, 'Missing response on test static resource.');
			// System.assertEquals(ar.Test_Request__c, req.getBody());
			res.setStatusCode(200);
			res.setBody(response);

			return res;
		}
	}
}