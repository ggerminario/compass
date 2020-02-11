@ isTest(SeeAllData = true) public with sharing class PV2790EstinzioneChiusuraContoGesTest {

	public static String Categoria = '2790';

	@isTest static void testOK() {

		PVtestFactory pVtestFactory = new PVtestFactory();

		PV2790EstinzioneChiusuraContoGestione.PV2790EstinzioneChiusuraContoGestioneForm form = new PV2790EstinzioneChiusuraContoGestione.PV2790EstinzioneChiusuraContoGestioneForm();

		form = (PV2790EstinzioneChiusuraContoGestione.PV2790EstinzioneChiusuraContoGestioneForm) pVtestFactory.initForm(Categoria, form);

		form.note = 'test';
		// preparo un case
		Case caseObj = new Case(Categoria_Riferimento__c = form.categoriaPV.Id, 
							    Step_PV__c = '2', 
							    Status = CaseUtils.APERTO);

		Test.startTest();
		PV2790EstinzioneChiusuraContoGestione.saveCase(form, caseObj);
		Test.stopTest();
	}

	@isTest static void testKO() {
		PVtestFactory pVtestFactory = new PVtestFactory();

		PV2790EstinzioneChiusuraContoGestione.PV2790EstinzioneChiusuraContoGestioneForm form = new PV2790EstinzioneChiusuraContoGestione.PV2790EstinzioneChiusuraContoGestioneForm();

		form = (PV2790EstinzioneChiusuraContoGestione.PV2790EstinzioneChiusuraContoGestioneForm) pVtestFactory.initForm(Categoria, form);

		form.note = 'test';
		// preparo un case
		Case caseObj = new Case(Status = 'non_existing_status');
		insert caseObj;

		Exception expectedException;
		Test.startTest();
		try{
			caseObj.Anno__c = '123456789';
			PV2790EstinzioneChiusuraContoGestione.saveCase(form, caseObj);
		} catch(Exception e) {
			expectedException = e;
		}
		Test.stopTest();
		System.assertNotEquals(null, expectedException, '<message>');

	}

	@isTest static void retrieveDataEstinzioneTest() {

		PVtestFactory pVtestFactory = new PVtestFactory();

		PV2790EstinzioneChiusuraContoGestione.PV2790EstinzioneChiusuraContoGestioneForm form = new PV2790EstinzioneChiusuraContoGestione.PV2790EstinzioneChiusuraContoGestioneForm();

		form = (PV2790EstinzioneChiusuraContoGestione.PV2790EstinzioneChiusuraContoGestioneForm) pVtestFactory.initForm(Categoria, form);

		// preparo un case
		Case caseObj = new Case(Categoria_Riferimento__c = form.categoriaPV.Id, 
							    Step_PV__c = '2', 
							    Status = CaseUtils.APERTO, 
							    F_Data_Estinzione__c= Date.newInstance(2019, 11, 01));
		insert caseObj;

		Test.startTest();
		PV2790EstinzioneChiusuraContoGestione.retrieveDataEstinzione(caseObj.Id);
		Test.stopTest();

	}
}