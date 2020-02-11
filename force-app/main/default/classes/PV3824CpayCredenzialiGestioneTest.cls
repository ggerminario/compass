/**
 * @File Name          : PV3824CpayCredenzialiGestioneTest.cls
 * @Description        :
 * @Author             : Raffaele Prudenzano
 * @Group              :
 * @Last Modified By   : Raffaele Prudenzano
 * @Last Modified On   : 15/1/2020, 15:59:01
 * @Modification Log   :
 * Ver       Date            Author                  Modification
 * 1.0    15/1/2020   Raffaele Prudenzano     Initial Version
 **/
@isTest(SeeAllData = true) public with sharing class PV3824CpayCredenzialiGestioneTest {

	static String Categoria = '3824';
	static PV3824CpayCredenzialiTestUtils utils = new PV3824CpayCredenzialiTestUtils();
	static String codCliente = 'NonExistingCod';
	static String STEP_GESTIONE_UFF_INSERIMENTO = PV3824CpayCredenzialiGestione.STEP_GESTIONE_UFF_INSERIMENTO;

	@isTest
	public static void testSaveOK() {
		// Riemissione User via mail - 5 tentativi
		List<PV3824CpayCredenzialiContext> ctxList = utils.creaTestContext('PV_SUB_133', new List<Integer>{ 5 });
		System.debug('batch @ctxList: ' + ctxList);

		Case theCase = new Case(Status = 'New', Esito__c = utils.serialize(ctxList));
		insert theCase;

		PV3824CpayCredenzialiGestione.saveCase(creaForm(false), theCase);

	}

	@isTest
	public static void testSaveKO() {
		// Riemissione User via mail - 5 tentativi
		List<PV3824CpayCredenzialiContext> ctxList = utils.creaTestContext('PV_SUB_133', new List<Integer>{ 5 });
		System.debug('batch @ctxList: ' + ctxList);

		Case theCase = new Case(Status = 'New', Esito__c = utils.serialize(ctxList));
		insert theCase;

		Integer fakeStringLength = 300;
		String s = '';
		for(Integer i = 0; i < fakeStringLength; i ++) {
			s+= 'a';
		}
		theCase.Esito__c = s;

		Exception myException;
		try{
			PV3824CpayCredenzialiGestione.saveCase(creaForm(false), theCase);
		} catch(Exception e) {
			myException = e;
		}
		System.assertNotEquals(null, myException);

	}


	@isTest
	public static void testSaveOKGestioneUfficioInserimento() {
		// Riemissione User via mail - 5 tentativi
		List<PV3824CpayCredenzialiContext> ctxList = utils.creaTestContext('PV_SUB_133', new List<Integer>{ 5 });
		System.debug('batch @ctxList: ' + ctxList);
		PV3824CpayCredenzialiGestione.PV3824CpayCredenzialiGestioneForm myForm = creaForm(false);

		myForm.newStatus = 'Closed';
		Case theCase = new Case(Status = 'New', Esito__c = utils.serialize(ctxList), Step_PV__c = STEP_GESTIONE_UFF_INSERIMENTO);
		insert theCase;
		PV3824CpayCredenzialiGestione.saveCase(myForm, theCase);

	}

	@isTest
	public static void testSaveOKGestioneCariceseRinvia() {
		// Riemissione User via mail - 5 tentativi
		List<PV3824CpayCredenzialiContext> ctxList = utils.creaTestContext('PV_SUB_133', new List<Integer>{ 5 });
		System.debug('batch @ctxList: ' + ctxList);

		PV3824CpayCredenzialiGestione.PV3824CpayCredenzialiGestioneForm myForm = creaForm(true);
		myForm.newStatus = 'Closed';
		Case theCase = new Case(Status = 'New', Esito__c = utils.serialize(ctxList));
		insert theCase;

		PV3824CpayCredenzialiGestione.saveCase(myForm, theCase);

	}

	public static PV3824CpayCredenzialiGestione.PV3824CpayCredenzialiGestioneForm creaForm(Boolean rinvia) {
		PV3824CpayCredenzialiGestione.PV3824CpayCredenzialiGestioneForm myForm = new PV3824CpayCredenzialiGestione.PV3824CpayCredenzialiGestioneForm();
		myForm.rinvia = rinvia;
		return myForm;
	}



}