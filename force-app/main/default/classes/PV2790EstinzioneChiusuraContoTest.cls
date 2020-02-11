@ isTest(SeeAllData = true) public with sharing class PV2790EstinzioneChiusuraContoTest {

	static String Categoria = '2790';

	@isTest static void testOKNoCell() {

		PVtestFactory pVtestFactory = new PVtestFactory();

		PV2790EstinzioneChiusuraConto.PV2790EstinzioneChiusuraContoForm form = new PV2790EstinzioneChiusuraConto.PV2790EstinzioneChiusuraContoForm();

		form = (PV2790EstinzioneChiusuraConto.PV2790EstinzioneChiusuraContoForm) pVtestFactory.initForm(Categoria, form);
		form.dataOperazione = '2019-11-01';
		
		form.note = 'test';

        String response = '{"resultCode":0,"resultMessage":"Ok","cseInterrogazioneSaldoLightResponse":{"saldo":0,"disponibilita":0}}';
		ApiRest__c rest = new ApiRest__c(Method__c = 'POST', Test_Response__c = response, Test_Request__c = 'testRequest', Mock__c = false, User__c = 'CDSLF00', Password__c = 'P00FLSDC', ref__c = 'CompassInternal', Name = 'cse.interrogazioneSaldoLightTEST', EndPoint__c = 'https://richiestaonlinesvi.compassonline.it/B2BSOAP/rest/B2BREST/execute');
		insert rest;

		UtilityMockResponse UMR = new UtilityMockResponse();
		UMR.apiname = 'cse.interrogazioneSaldoLightTEST';
		Test.setMock(HttpCalloutMock.class, UMR);

		Test.startTest();
		PV2790EstinzioneChiusuraConto.conferma(form);
		Test.stopTest();
	}

	@isTest static void testOKCell() {

		PVtestFactory pVtestFactory = new PVtestFactory();

		PV2790EstinzioneChiusuraConto.PV2790EstinzioneChiusuraContoForm form = new PV2790EstinzioneChiusuraConto.PV2790EstinzioneChiusuraContoForm();

		form = (PV2790EstinzioneChiusuraConto.PV2790EstinzioneChiusuraContoForm) pVtestFactory.initForm(Categoria, form);
		form.dataOperazione = '2019-11-01';
		form.note = 'test';
		form.cliente.telCellulare = '333 3333333';
		form.cliente.codCliente = '12345';

        String response = '{"resultCode":0,"resultMessage":"Ok","cseInterrogazioneSaldoLightResponse":{"saldo":0,"disponibilita":0}}';
		ApiRest__c rest = new ApiRest__c(Method__c = 'POST', Test_Response__c = response, Test_Request__c = 'testRequest', Mock__c = false, User__c = 'CDSLF00', Password__c = 'P00FLSDC', ref__c = 'CompassInternal', Name = 'cse.interrogazioneSaldoLightTEST', EndPoint__c = 'https://richiestaonlinesvi.compassonline.it/B2BSOAP/rest/B2BREST/execute');
		insert rest;

		UtilityMockResponse UMR = new UtilityMockResponse();
		UMR.apiname = 'cse.interrogazioneSaldoLightTEST';
		Test.setMock(HttpCalloutMock.class, UMR);


		Test.startTest();
		PVResponse resp = PV2790EstinzioneChiusuraConto.conferma(form);
		Test.stopTest();
	}

	@isTest static void testDataKO() {

		PVtestFactory pVtestFactory = new PVtestFactory();

		PV2790EstinzioneChiusuraConto.PV2790EstinzioneChiusuraContoForm form = new PV2790EstinzioneChiusuraConto.PV2790EstinzioneChiusuraContoForm();

		form = (PV2790EstinzioneChiusuraConto.PV2790EstinzioneChiusuraContoForm) pVtestFactory.initForm(Categoria, form);
		form.dataOperazione = '01-11-2019';
		form.note = 'test';

		Test.startTest();
		try{
			PV2790EstinzioneChiusuraConto.conferma(form);
		} catch(Exception e) {

		}
		Test.stopTest();
	}

	@isTest static void testRapportoHB() {
		String response = '{"resultCode":0,"resultMessage":"Ok","recuperaRapportoHBCpayResponse":{"rapportoHB":"19070180927","isDipendente":"N"}}';

		OCSRecuperaRapportoHBCpayResponse.RecuperaRapportoHBCpayResponseDTO res = makeTestCalloutRapportoHB(response);
		System.assertEquals('19070180927', res.rapportoHB);
		System.assertEquals('N', res.isDipendente);
		Test.stopTest();

	}

	@isTest static void testControllButton1(){
		String response = '{"resultCode":0,"resultMessage":"Ok","recuperaRapportoHBCpayResponse":{"rapportoHB":"19070180927","isDipendente":"N"}}';
		String office = 'NumeroBlu';
		String username = 'test';

		OCSRecuperaRapportoHBCpayResponse.RecuperaRapportoHBCpayResponseDTO res = makeTestCalloutRapportoHB(response);
		Boolean showUrl = PV2790EstinzioneChiusuraConto.ControllButton(res, office, username);
		System.assertEquals(true, showUrl);
		Test.stopTest();
	}

	@isTest static void testControllButton2(){
		String response = '{"resultCode":0,"resultMessage":"Ok","recuperaRapportoHBCpayResponse":{"rapportoHB":"19070180927","isDipendente":"N"}}';
		String office = 'test';
		String username = 'CU2837';

		OCSRecuperaRapportoHBCpayResponse.RecuperaRapportoHBCpayResponseDTO res = makeTestCalloutRapportoHB(response);
		Boolean showUrl = PV2790EstinzioneChiusuraConto.ControllButton(res, office, username);
		System.assertEquals(true, showUrl);
		Test.stopTest();
	}

	@isTest static void testControllButton3(){
		String response = '{"resultCode":0,"resultMessage":"Ok","recuperaRapportoHBCpayResponse":{"rapportoHB":"19070180927","isDipendente":"S"}}';
		String office = 'test';
		String username = 'CU2873';

		OCSRecuperaRapportoHBCpayResponse.RecuperaRapportoHBCpayResponseDTO res = makeTestCalloutRapportoHB(response);
		Boolean showUrl = PV2790EstinzioneChiusuraConto.ControllButton(res, office, username);
		System.assertEquals(true, showUrl);
		Test.stopTest();
	}

	@isTest static void testControllButton4(){
		String response = '{"resultCode":0,"resultMessage":"Ok","recuperaRapportoHBCpayResponse":{"rapportoHB":"19070180927","isDipendente":"S"}}';
		String office = 'test';
		String username = 'test';

		OCSRecuperaRapportoHBCpayResponse.RecuperaRapportoHBCpayResponseDTO res = makeTestCalloutRapportoHB(response);
		Boolean showUrl = PV2790EstinzioneChiusuraConto.ControllButton(res, office, username);
		System.assertEquals(false, showUrl);
		Test.stopTest();
	}

	@isTest static void testCostruisciLink(){
		String response = '{"resultCode":0,"resultMessage":"Ok","recuperaRapportoHBCpayResponse":{"rapportoHB":"19070180927","isDipendente":"S"}}';

		OCSRecuperaRapportoHBCpayResponse.RecuperaRapportoHBCpayResponseDTO res = makeTestCalloutRapportoHB(response);
		PV2790EstinzioneChiusuraConto.CostruisciLink(res);
		Test.stopTest();
	}

	private static OCSRecuperaRapportoHBCpayResponse.RecuperaRapportoHBCpayResponseDTO makeTestCalloutRapportoHB(String response){
		ApiRest__c rest = new ApiRest__c(Method__c = 'POST', Test_Response__c = response, Test_Request__c = 'testRequest', Mock__c = false, User__c = 'CDSLF00', Password__c = 'P00FLSDC', ref__c = 'CompassInternal', Name = 'ocs.recuperaRapportoHBCpayTEST', EndPoint__c = 'https://richiestaonlinesvi.compassonline.it/B2BSOAP/rest/B2BREST/execute');
		insert rest;

		Test.startTest();
		UtilityMockResponse UMR = new UtilityMockResponse();
		UMR.apiname = 'ocs.recuperaRapportoHBCpayTEST';
		Test.setMock(HttpCalloutMock.class, UMR);
		return PV2790EstinzioneChiusuraConto.RapportoHB('123456');
	}
}