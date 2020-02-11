@isTest (SeeAllData = true)
public with sharing class PV2794EstinzioneChiusuraContoTest {
	static String Categoria = '2794';

	@isTest static void testConferma() {

		PV2794EstinzioneChiusuraConto.PV2794EstinzioneChiusuraContoForm form = creaForm();


		Test.startTest();
		PV2794EstinzioneChiusuraConto.conferma(form);

		Test.stopTest();
	}

	public static PV2794EstinzioneChiusuraConto.PV2794EstinzioneChiusuraContoForm creaForm() {
		PVtestFactory pVtestFactory = new PVtestFactory();

		PV2794EstinzioneChiusuraConto.PV2794EstinzioneChiusuraContoForm form = new PV2794EstinzioneChiusuraConto.PV2794EstinzioneChiusuraContoForm();

		return (PV2794EstinzioneChiusuraConto.PV2794EstinzioneChiusuraContoForm) pVtestFactory.initForm(Categoria, form);
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
		Boolean showUrl = PV2794EstinzioneChiusuraConto.ControllButton(res, office, username);
		System.assertEquals(true, showUrl);
		Test.stopTest();
	}

	@isTest static void testControllButton2(){
		String response = '{"resultCode":0,"resultMessage":"Ok","recuperaRapportoHBCpayResponse":{"rapportoHB":"19070180927","isDipendente":"N"}}';
		String office = 'test';
		String username = 'CU2837';

		OCSRecuperaRapportoHBCpayResponse.RecuperaRapportoHBCpayResponseDTO res = makeTestCalloutRapportoHB(response);
		Boolean showUrl = PV2794EstinzioneChiusuraConto.ControllButton(res, office, username);
		System.assertEquals(true, showUrl);
		Test.stopTest();
	}

	@isTest static void testControllButton3(){
		String response = '{"resultCode":0,"resultMessage":"Ok","recuperaRapportoHBCpayResponse":{"rapportoHB":"19070180927","isDipendente":"S"}}';
		String office = 'test';
		String username = 'CU2873';

		OCSRecuperaRapportoHBCpayResponse.RecuperaRapportoHBCpayResponseDTO res = makeTestCalloutRapportoHB(response);
		Boolean showUrl = PV2794EstinzioneChiusuraConto.ControllButton(res, office, username);
		System.assertEquals(true, showUrl);
		Test.stopTest();
	}

	@isTest static void testControllButton4(){
		String response = '{"resultCode":0,"resultMessage":"Ok","recuperaRapportoHBCpayResponse":{"rapportoHB":"19070180927","isDipendente":"S"}}';
		String office = 'test';
		String username = 'test';

		OCSRecuperaRapportoHBCpayResponse.RecuperaRapportoHBCpayResponseDTO res = makeTestCalloutRapportoHB(response);
		Boolean showUrl = PV2794EstinzioneChiusuraConto.ControllButton(res, office, username);
		System.assertEquals(false, showUrl);
		Test.stopTest();
	}

	@isTest static void testCostruisciLink(){
		String response = '{"resultCode":0,"resultMessage":"Ok","recuperaRapportoHBCpayResponse":{"rapportoHB":"19070180927","isDipendente":"S"}}';

		OCSRecuperaRapportoHBCpayResponse.RecuperaRapportoHBCpayResponseDTO res = makeTestCalloutRapportoHB(response);
		PV2794EstinzioneChiusuraConto.CostruisciLink(res);
		Test.stopTest();
	}

	private static OCSRecuperaRapportoHBCpayResponse.RecuperaRapportoHBCpayResponseDTO makeTestCalloutRapportoHB(String response){
		ApiRest__c rest = new ApiRest__c(Method__c = 'POST', Test_Response__c = response, Test_Request__c = 'testRequest', Mock__c = false, User__c = 'CDSLF00', Password__c = 'P00FLSDC', ref__c = 'CompassInternal', Name = 'ocs.recuperaRapportoHBCpayTEST', EndPoint__c = 'https://richiestaonlinesvi.compassonline.it/B2BSOAP/rest/B2BREST/execute');
		insert rest;

		Test.startTest();
		UtilityMockResponse UMR = new UtilityMockResponse();
		UMR.apiname = 'ocs.recuperaRapportoHBCpayTEST';
		Test.setMock(HttpCalloutMock.class, UMR);
		return PV2794EstinzioneChiusuraConto.RapportoHB('123456');
	}
}