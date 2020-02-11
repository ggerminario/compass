@ isTest(SeeAllData = true) public with sharing class PV2794EstinzioneChiusuraContoGesTest {
	static String Categoria = '2794';

	@isTest static void testKODate() {

		PVtestFactory pVtestFactory = new PVtestFactory();

		PV2794EstinzioneChiusuraContoGestione.PV2794EstinzioneChiusuraContoGestioneForm form = new PV2794EstinzioneChiusuraContoGestione.PV2794EstinzioneChiusuraContoGestioneForm();

		form = (PV2794EstinzioneChiusuraContoGestione.PV2794EstinzioneChiusuraContoGestioneForm) pVtestFactory.initForm(Categoria, form);

		form.note = 'test';

		// preparo un case
		Case caseObj = new Case(Categoria_Riferimento__c = form.categoriaPV.Id, 
							    Step_PV__c = '2', 
							    Status = CaseUtils.APERTO);


		Test.startTest();
		Exception expectedException;
		try{
			PV2794EstinzioneChiusuraContoGestione.saveCase(form, caseObj);
		} catch(Exception e) {
			expectedException = e;
		}
		System.assertNotEquals(null, expectedException);

		Test.stopTest();

	}

	@isTest static void testOK() {

		PVtestFactory pVtestFactory = new PVtestFactory();

		PV2794EstinzioneChiusuraContoGestione.PV2794EstinzioneChiusuraContoGestioneForm form = new PV2794EstinzioneChiusuraContoGestione.PV2794EstinzioneChiusuraContoGestioneForm();

		form = (PV2794EstinzioneChiusuraContoGestione.PV2794EstinzioneChiusuraContoGestioneForm) pVtestFactory.initForm(Categoria, form);

		form.note = 'test';
		form.dataOperazione = '2019-11-01';

		// preparo un case
		Case caseObj = new Case(Categoria_Riferimento__c = form.categoriaPV.Id, 
							    Step_PV__c = '2', 
							    Status = CaseUtils.APERTO,
                                SuppliedPhone = '333 3333333');
        insert caseObj;

		String response = '{"resultCode":0,"resultMessage":"Ok","cseInterrogazioneSaldoLightResponse":{"saldo":0,"disponibilita":0}}';
		ApiRest__c rest = new ApiRest__c(Method__c = 'POST', Test_Response__c = response, Test_Request__c = 'testRequest', Mock__c = false, User__c = 'CDSLF00', Password__c = 'P00FLSDC', ref__c = 'CompassInternal', Name = 'cse.interrogazioneSaldoLightTEST', EndPoint__c = 'https://richiestaonlinesvi.compassonline.it/B2BSOAP/rest/B2BREST/execute');
		insert rest;

		UtilityMockResponse UMR = new UtilityMockResponse();
		UMR.apiname = 'cse.interrogazioneSaldoLightTEST';
		Test.setMock(HttpCalloutMock.class, UMR);

		Test.startTest();
		PV2794EstinzioneChiusuraContoGestione.saveCase(form, caseObj);

		Test.stopTest();

	}

}