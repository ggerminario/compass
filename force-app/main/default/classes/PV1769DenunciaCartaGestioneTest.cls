@ isTest(SeeAllData = true) private class PV1769DenunciaCartaGestioneTest {

	static String Categoria = '1769';

	@isTest static void testOK() {

		PVtestFactory pVtestFactory = new PVtestFactory();

		PV1769DenunciaCartaGestione.PV1769DenunciaCartaGestioneForm form = new PV1769DenunciaCartaGestione.PV1769DenunciaCartaGestioneForm();

		form = (PV1769DenunciaCartaGestione.PV1769DenunciaCartaGestioneForm) pVtestFactory.initForm(Categoria, form);

		form.note = 'test';

		// preparo un case
		Case caseObj = new Case(Categoria_Riferimento__c = form.categoriaPV.Id, 
							    Step_PV__c = '2', 
							    Status = CaseUtils.APERTO);


		Test.startTest();
		PV1769DenunciaCartaGestione.saveCase(form, caseObj);

		Test.stopTest();
	}

	@isTest static void testResponse() {

		PVtestFactory pVtestFactory = new PVtestFactory();

		PV1769DenunciaCartaGestione.PV1769DenunciaCartaGestioneForm form = new PV1769DenunciaCartaGestione.PV1769DenunciaCartaGestioneForm();

		form = (PV1769DenunciaCartaGestione.PV1769DenunciaCartaGestioneForm) pVtestFactory.initForm(Categoria, form);
		form.pratica.numPratica = '32103314183';

		String respJSON = '{"resultCode":0,"resultMessage":"Ok","recuperaCircuitoCartaResponse":{"pan":"4163657291624528","circuito":"VIS","emettitore":"32"}}';

		Test.startTest();
		MyUtilityMockResponse UMR = new MyUtilityMockResponse();
		UMR.apiname = 'ocs.recuperaCircuitoCarta';
		UMR.response = respJSON;
		Test.setMock(HttpCalloutMock.class, UMR);
		OCSRecuperaCircuitoCartaResponse.CircuitoPanCartaDTO response = PV1769DenunciaCartaGestione.RecuperaCircuitoCartaOCS('32103314183');
		Test.stopTest();
		System.assertEquals('VIS', response.circuito);
		System.assertEquals('32', response.emettitore);
		System.assertEquals('4163657291624528', response.pan);
	}

	@isTest static void doComponiEmailTest() {
		// Test OK
		PV1769DenunciaCartaGestione.doComponiEmail('si', 'VIS', '4163657291624528', '', new Case());
		// Test stopList == 'no'
		PV1769DenunciaCartaGestione.doComponiEmail('no', 'VIS', '4163657291624528', '', new Case());
		// Test pan == 'null'
		PV1769DenunciaCartaGestione.doComponiEmail('si', 'VIS', 'null', '', new Case());
		// Test circuito sconosciuto
		PV1769DenunciaCartaGestione.doComponiEmail('si', 'TEST', '4163657291624528', '', new Case());
	}

	@isTest static void doImpostaIndirizziTest() {
		// Test circuito == 'VIS'
		PV1769DenunciaCartaGestione.doImpostaIndirizzi('VIS');
		// Test circuito == 'EMC'
		PV1769DenunciaCartaGestione.doImpostaIndirizzi('EMC');
	}   

	@isTest static void InvioEmailTest() {
		List<String> emailAddresses = new List<String>{'test.test@test.it', 'test2.test@test.it'};
		String body = 'Questo è un body di test';
		String circuito = 'VIS';
		PV1769DenunciaCartaGestione.InvioEmail(emailAddresses, body,circuito);
		
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