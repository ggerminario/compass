/**
 * @File Name          : BatchPV3824CpayCredenzialiTest.cls
 * @Description        :
 * @Author             : Raffaele Prudenzano
 * @Group              :
 * @Last Modified By   : Raffaele Prudenzano
 * @Last Modified On   : 15/1/2020, 13:02:59
 * @Modification Log   :
 * Ver       Date            Author                  Modification
 * 1.0    14/1/2020   Raffaele Prudenzano     Initial Version
 **/
@ isTest(SeeAllData = true) public with sharing class BatchPV3824CpayCredenzialiTest {

	static String Categoria = '3824';
	static PV3824CpayCredenzialiTestUtils utils = new PV3824CpayCredenzialiTestUtils();
	static String codCliente = 'NonExistingCod';

	/*
	 Map<String, List<String>> serviceIdResponseMap = new Map<String, List<String>>();
	 serviceIdResponseMap.put('recuperaRapportoHBCpay', new List<String>{ utils.recuperaRapportoHBCpayResponseOK });
	 serviceIdResponseMap.put('cseRiemissioneCredenziali', new List<String>{ utils.riemissioneCredenzialiResponseOK });
	 serviceIdResponseMap.put('cseAnnulloBusta', new List<String>{ utils.annulloBustaResponseOK });
	 */

	@isTest
	public static void testBatchNothingHappens2H() {
		Map<String, List<String>> serviceIdResponseMap = new Map<String, List<String>>();
		serviceIdResponseMap.put('recuperaRapportoHBCpay', new List<String>{ utils.recuperaRapportoHBCpayResponseOK });
		serviceIdResponseMap.put('cseAnnulloBusta', new List<String>{ utils.annulloBustaResponseKO });
		Test.setMock(HttpCalloutMock.class, new UtilityMockResponseMultipleService(serviceIdResponseMap));

		// Inserisco un case facendolo restituire KO. Andrà in stato sospeso così da poter far girare il batch
		PV3824CpayCredenziali.conferma(utils.creaForm('PV_SUB_127', codCliente));

		Case theCase = utils.recuperaUltimoCase(codCliente);
		utils.assertAllNumTEqualsTo(theCase, 1); // Avrà fatto un tentativo all inserimento, quindi tutti i numT saranno 1 per la categoria PV_SUB_127

		BatchPV3824CpayCredenziali myBatch = new BatchPV3824CpayCredenziali();
		myBatch.codCliente = codCliente;

		Database.executeBatch(myBatch, 1);
		theCase = utils.recuperaUltimoCase(codCliente);
		utils.assertAllNumTEqualsTo(theCase, 1); // Non avrà fatto più tentativi, perchè non sono ancora passate 2h
	}

	@isTest
	public static void testBatchRuns() {
		Map<String, List<String>> serviceIdResponseMap = new Map<String, List<String>>();
		serviceIdResponseMap.put('recuperaRapportoHBCpay', new List<String>{ utils.recuperaRapportoHBCpayResponseOK, utils.recuperaRapportoHBCpayResponseOK });
		serviceIdResponseMap.put('cseAnnulloBusta', new List<String>{ utils.annulloBustaResponseKO, utils.annulloBustaResponseOK });
		Test.setMock(HttpCalloutMock.class, new UtilityMockResponseMultipleService(serviceIdResponseMap));

		// Inserisco un case facendolo restituire KO. Andrà in stato sospeso così da poter far girare il batch
		PV3824CpayCredenziali.conferma(utils.creaForm('PV_SUB_127', codCliente));

		Case theCase = utils.recuperaUltimoCase(codCliente);
		utils.assertAllNumTEqualsTo(theCase, 1); // Avrà fatto un tentativo all inserimento, quindi tutti i numT saranno 1 per la categoria PV_SUB_127

		BatchPV3824CpayCredenziali myBatch = new BatchPV3824CpayCredenziali();
		myBatch.now = DateTime.now().addHours(2).addMinutes(1);
		myBatch.codCliente = codCliente;

		Exception myException;
		try{
			Test.startTest();
			Database.executeBatch(myBatch, 1);
			Test.stopTest();

			theCase = utils.recuperaUltimoCase(codCliente);
			utils.assertAllNumTEqualsTo(theCase, 2); // Avrà fatto il nuovo tentativo, perchè sono passate 2h
		} catch(Exception e) {
			myException = e;
		}
		// Questo accade perchè avrò una eccezione di "uncomitted work pending" visto che ho prima inserito il case e poi tentato di fare callout col batch
		// Sto testando però il fatto che il batch parta davvero se sono passate più di 2 ore
		System.assertNotEquals(null, myException);
	}

	@isTest
	public static void testRiemissioneRunningOK() {
		Map<String, List<String>> serviceIdResponseMap = new Map<String, List<String>>();
		serviceIdResponseMap.put('recuperaDatiPostvendita', new List<String>{ utils.recuperaDatiPostvenditaResponseOK });
		serviceIdResponseMap.put('recuperaRapportoHBCpay', new List<String>{ utils.recuperaRapportoHBCpayResponseOK, utils.recuperaRapportoHBCpayResponseOK });
		serviceIdResponseMap.put('cseRiemissioneCredenziali', new List<String>{ utils.riemissioneCredenzialiResponseOK, utils.riemissioneCredenzialiResponseOK });
		Test.setMock(HttpCalloutMock.class, new UtilityMockResponseMultipleService(serviceIdResponseMap));

		// Riemissione completa (User via email e PIN via sms))
		List<PV3824CpayCredenzialiContext> ctxList = utils.creaTestContext('PV_SUB_135', new List<Integer>{ 1, 1 });
		System.debug('batch @ctxList: ' + ctxList);
		Case theCase = new Case(Status = 'Sospeso', Esito__c = utils.serialize(ctxList));
		System.debug('batch @theCase: ' + theCase);

		Test.startTest();
		BatchPV3824CpayCredenziali myBatch = new BatchPV3824CpayCredenziali();
		myBatch.now = DateTime.now().addHours(2).addMinutes(1);
		myBatch.codCliente = codCliente;
		myBatch.createdDate = Date.today();
		myBatch.execute(null, new List<Case>{ theCase });

		Test.stopTest();

		utils.assertAllNumTEqualsTo(theCase, 2); // Avrà fatto il nuovo tentativo, perchè sono passate 2h

	}

	@isTest
	public static void testRiemissioneRunningKO() {
		Map<String, List<String>> serviceIdResponseMap = new Map<String, List<String>>();
		serviceIdResponseMap.put('recuperaDatiPostvendita', new List<String>{ utils.recuperaDatiPostvenditaResponseOK });
		serviceIdResponseMap.put('recuperaRapportoHBCpay', new List<String>{ utils.recuperaRapportoHBCpayResponseOK, utils.recuperaRapportoHBCpayResponseOK });
		serviceIdResponseMap.put('cseRiemissioneCredenziali', new List<String>{ utils.riemissioneCredenzialiResponseKO, utils.riemissioneCredenzialiResponseKO });
		Test.setMock(HttpCalloutMock.class, new UtilityMockResponseMultipleService(serviceIdResponseMap));

		// Riemissione completa (User via email e PIN via sms))
		List<PV3824CpayCredenzialiContext> ctxList = utils.creaTestContext('PV_SUB_135', new List<Integer>{ 1, 1 });
		System.debug('batch @ctxList: ' + ctxList);
		Case theCase = new Case(Status = 'Sospeso', Esito__c = utils.serialize(ctxList));
		System.debug('batch @theCase: ' + theCase);

		Test.startTest();
		BatchPV3824CpayCredenziali myBatch = new BatchPV3824CpayCredenziali();
		myBatch.now = DateTime.now().addHours(2).addMinutes(1);
		myBatch.codCliente = codCliente;
		myBatch.createdDate = Date.today();
		myBatch.execute(null, new List<Case>{ theCase });

		Test.stopTest();

		utils.assertAllNumTEqualsTo(theCase, 2); // Avrà fatto il nuovo tentativo, perchè sono passate 2h

	}

	@isTest
	public static void testRiemissionePostaNotRunningToday() {
		Map<String, List<String>> serviceIdResponseMap = new Map<String, List<String>>();
		serviceIdResponseMap.put('recuperaDatiPostvendita', new List<String>{ utils.recuperaDatiPostvenditaResponseOK });
		serviceIdResponseMap.put('recuperaRapportoHBCpay', new List<String>{ utils.recuperaRapportoHBCpayResponseOK, utils.recuperaRapportoHBCpayResponseOK });
		serviceIdResponseMap.put('cseRiemissioneCredenziali', new List<String>{ utils.riemissioneCredenzialiResponseOK, utils.riemissioneCredenzialiResponseOK });
		Test.setMock(HttpCalloutMock.class, new UtilityMockResponseMultipleService(serviceIdResponseMap));

		// Riemissione User via posta
		List<PV3824CpayCredenzialiContext> ctxList = utils.creaTestContext('PV_SUB_132', new List<Integer>{ 0 });
		System.debug('batch @ctxList: ' + ctxList);
		Case theCase = new Case(Status = 'Sospeso', Esito__c = utils.serialize(ctxList));
		System.debug('batch @theCase: ' + theCase);

		Test.startTest();
		BatchPV3824CpayCredenziali myBatch = new BatchPV3824CpayCredenziali();
		myBatch.now = DateTime.now().addHours(2).addMinutes(1);
		myBatch.codCliente = codCliente;
		myBatch.createdDate = Date.today();
		myBatch.execute(null, new List<Case>{ theCase });

		Test.stopTest();

		utils.assertAllNumTEqualsTo(theCase, 0); // Nonostante siano passate 2h, non fa il nuovo tentativo perchè è via posta

	}

	@isTest
	public static void testRiemissionePostaRunningTomorrow() {
		Map<String, List<String>> serviceIdResponseMap = new Map<String, List<String>>();
		serviceIdResponseMap.put('recuperaDatiPostvendita', new List<String>{ utils.recuperaDatiPostvenditaResponseOK });
		serviceIdResponseMap.put('recuperaRapportoHBCpay', new List<String>{ utils.recuperaRapportoHBCpayResponseOK, utils.recuperaRapportoHBCpayResponseOK });
		serviceIdResponseMap.put('cseRiemissioneCredenziali', new List<String>{ utils.riemissioneCredenzialiResponseOK, utils.riemissioneCredenzialiResponseOK });
		Test.setMock(HttpCalloutMock.class, new UtilityMockResponseMultipleService(serviceIdResponseMap));

		// Riemissione User via posta
		List<PV3824CpayCredenzialiContext> ctxList = utils.creaTestContext('PV_SUB_132', new List<Integer>{ 0 });
		System.debug('batch @ctxList: ' + ctxList);
		Case theCase = new Case(Status = 'Sospeso', Esito__c = utils.serialize(ctxList));
		System.debug('batch @theCase: ' + theCase);

		Test.startTest();
		BatchPV3824CpayCredenziali myBatch = new BatchPV3824CpayCredenziali();
		myBatch.now = DateTime.now().addHours(2).addMinutes(1);
		myBatch.codCliente = codCliente;
		myBatch.createdDate = Date.today();

		// PV3824CpayCredenzialiContext si occupa di fare la chiamata e fa di nuovo un Date.today() che gli sto settando artificialmente
		PV3824CpayCredenzialiContext.today = Date.today().addDays(1);

		myBatch.execute(null, new List<Case>{ theCase });

		Test.stopTest();

		utils.assertAllNumTEqualsTo(theCase, 1); // Fa il nuovo tentativo perchè è passato 1gg

	}


	@isTest
	public static void testRiemissioneRunningUltimoGiro() {
		Map<String, List<String>> serviceIdResponseMap = new Map<String, List<String>>();
		serviceIdResponseMap.put('recuperaDatiPostvendita', new List<String>{ utils.recuperaDatiPostvenditaResponseOK });
		serviceIdResponseMap.put('recuperaRapportoHBCpay', new List<String>{ utils.recuperaRapportoHBCpayResponseOK, utils.recuperaRapportoHBCpayResponseOK });
		serviceIdResponseMap.put('cseRiemissioneCredenziali', new List<String>{ utils.riemissioneCredenzialiResponseKO, utils.riemissioneCredenzialiResponseKO });
		Test.setMock(HttpCalloutMock.class, new UtilityMockResponseMultipleService(serviceIdResponseMap));

		// Riemissione completa (User via email e PIN via sms)) - 3 tentativi
		List<PV3824CpayCredenzialiContext> ctxList = utils.creaTestContext('PV_SUB_135', new List<Integer>{ 2, 2 });
		System.debug('batch @ctxList: ' + ctxList);
		Case theCase = new Case(Status = 'Sospeso', Esito__c = utils.serialize(ctxList));
		System.debug('batch @theCase: ' + theCase);

		Test.startTest();
		BatchPV3824CpayCredenziali myBatch = new BatchPV3824CpayCredenziali();
		myBatch.now = DateTime.now().addHours(2).addMinutes(1);
		myBatch.codCliente = codCliente;
		myBatch.createdDate = Date.today();
		myBatch.execute(null, new List<Case>{ theCase });
		Test.stopTest();

		utils.assertAllNumTEqualsTo(theCase, 3); // Avrà fatto il nuovo tentativo
	}

	@isTest
	public static void testRiemissioneRunningUltimoGiro2() {
		Map<String, List<String>> serviceIdResponseMap = new Map<String, List<String>>();
		serviceIdResponseMap.put('recuperaDatiPostvendita', new List<String>{ utils.recuperaDatiPostvenditaResponseOK });
		serviceIdResponseMap.put('recuperaRapportoHBCpay', new List<String>{ utils.recuperaRapportoHBCpayResponseOK, utils.recuperaRapportoHBCpayResponseOK });
		serviceIdResponseMap.put('cseRiemissioneCredenziali', new List<String>{ utils.riemissioneCredenzialiResponseKO, utils.riemissioneCredenzialiResponseKO });
		Test.setMock(HttpCalloutMock.class, new UtilityMockResponseMultipleService(serviceIdResponseMap));

		// Riemissione completa (User via email e PIN via sms)) - 3 tentativi
		List<PV3824CpayCredenzialiContext> ctxList = utils.creaTestContext('PV_SUB_135', new List<Integer>{ 3, 3 });
		System.debug('batch @ctxList: ' + ctxList);
		Case theCase = new Case(Status = 'Sospeso', Esito__c = utils.serialize(ctxList));
		System.debug('batch @theCase: ' + theCase);

		Test.startTest();
		BatchPV3824CpayCredenziali myBatch = new BatchPV3824CpayCredenziali();
		myBatch.now = DateTime.now().addHours(2).addMinutes(1);
		myBatch.codCliente = codCliente;
		myBatch.createdDate = Date.today();
		myBatch.execute(null, new List<Case>{ theCase });
		Test.stopTest();

		utils.assertAllNumTEqualsTo(theCase, 3); // Non avrà fatto il nuovo tentativo perchè era arrivato alla fine
	}

	@isTest
	public static void testIncreaseMaxT() {
		// Riemissione User via mail - 5 tentativi
		Integer maxT = 5;
		List<PV3824CpayCredenzialiContext> ctxList = utils.creaTestContext('PV_SUB_133', new List<Integer>{ maxT });
		System.debug('batch @ctxList: ' + ctxList);
		Case theCase = new Case(Status = 'Sospeso', Esito__c = utils.serialize(ctxList));
		System.debug('batch @theCase: ' + theCase);

		Test.startTest();
		PV3824CpayCredenzialiContext.increaseMaxTForKOCallouts(theCase);
		Test.stopTest();

		PV3824CpayCredenzialiContext ctx = utils.deserialize(theCase.Esito__c) [0];
		System.assertEquals(maxT + 1, ctx.maxT);

	}



}