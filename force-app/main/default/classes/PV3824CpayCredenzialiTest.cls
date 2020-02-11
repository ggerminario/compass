/**
 * @File Name          : PV3824CpayCredenzialiTest.cls
 * @Description        :
 * @Author             : Raffaele Prudenzano
 * @Group              :
 * @Last Modified By   : Raffaele Prudenzano
 * @Last Modified On   : 14/1/2020, 15:42:49
 * @Modification Log   :
 * Ver       Date            Author                  Modification
 * 1.0    13/1/2020   Raffaele Prudenzano     Initial Version
 **/
@ isTest(SeeAllData = true) public with sharing class PV3824CpayCredenzialiTest {
	static String Categoria = '3824';
	static Integer maxCases = 5;
	static PV3824CpayCredenzialiTestUtils utils = new PV3824CpayCredenzialiTestUtils();


	@isTest
	public static void confermaKOCategoriaNonRiconosciuta() {

		PV3824CpayCredenziali.PV3824CpayCredenzialiForm myForm = utils.creaForm(null);

		Exception myException;
		try{
			PV3824CpayCredenziali.conferma(myForm);
		} catch(Exception e) {
			myException = e;
		}
		System.assertNotEquals(null, myException);
	}

	@isTest
	public static void confermaKOMaxRequests() {
		Test.setMock(HttpCalloutMock.class, new UtilityMockResponseMultipleService(utils.createAllOKResponses()));
		String codCliente = 'NonExistingCod';
		// È una riemissione via posta quindi rimane sospeso
		PV3824CpayCredenziali.PV3824CpayCredenzialiForm myForm = utils.creaForm('PV_SUB_131', codCliente);

		utils.creaNCases(myForm, maxCases);

		Test.startTest();

		// Inserimento del maxCases+1 case, che restituirà errore
		Exception myException;
		try{
			PV3824CpayCredenziali.conferma(utils.creaForm('PV_SUB_131', codCliente));
		} catch(Exception e) {
			myException = e;
		}

		System.assertNotEquals(null, myException);
		Test.stopTest();
	}

	@isTest
	public static void confermaOKMaxReqLastMonth() {
		Test.setMock(HttpCalloutMock.class, new UtilityMockResponseMultipleService(utils.createAllOKResponses()));
		String codCliente = 'NonExistingCod';
		// È una riemissione via posta quindi rimane sospeso
		PV3824CpayCredenziali.PV3824CpayCredenzialiForm myForm = utils.creaForm('PV_SUB_131', codCliente);

		utils.creaNCases(myForm, maxCases);

		Test.startTest();

		// Inserimento del maxCases+1 case, che NON restituirà errore perchè sto modificando today a today+1mese+1gg
		Exception myException;
		try{
			PV3824CpayCredenziali.today = Date.today().addMonths(1).addDays(1);
			PV3824CpayCredenziali.conferma(utils.creaForm('PV_SUB_131', codCliente));
		} catch(Exception e) {
			myException = e;
		}

		System.assertEquals(null, myException);
		Test.stopTest();
	}

	@isTest
	public static void confermaOK1() {
		Test.setMock(HttpCalloutMock.class, new UtilityMockResponseMultipleService(utils.createAllOKResponses()));
		PV3824CpayCredenziali.conferma(utils.creaForm('PV_SUB_127'));
	}

	@isTest
	public static void confermaOK2() {
		Test.setMock(HttpCalloutMock.class, new UtilityMockResponseMultipleService(utils.createAllOKResponses()));
		PV3824CpayCredenziali.conferma(utils.creaForm('PV_SUB_129'));
	}

	@isTest
	public static void confermaOK3() {
		Test.setMock(HttpCalloutMock.class, new UtilityMockResponseMultipleService(utils.createAllOKResponses()));
		PV3824CpayCredenziali.conferma(utils.creaForm('PV_SUB_130'));
	}

	@isTest
	public static void confermaOK4() {
		Test.setMock(HttpCalloutMock.class, new UtilityMockResponseMultipleService(utils.createAllOKResponses()));
		PV3824CpayCredenziali.conferma(utils.creaForm('PV_SUB_131'));
	}

	@isTest
	public static void confermaOK5() {
		Test.setMock(HttpCalloutMock.class, new UtilityMockResponseMultipleService(utils.createAllOKResponses()));
		PV3824CpayCredenziali.conferma(utils.creaForm('PV_SUB_132'));
	}

	@isTest
	public static void confermaOK6() {
		Test.setMock(HttpCalloutMock.class, new UtilityMockResponseMultipleService(utils.createAllOKResponses()));
		PV3824CpayCredenziali.conferma(utils.creaForm('PV_SUB_133'));
	}

	@isTest
	public static void confermaOK7() {
		Test.setMock(HttpCalloutMock.class, new UtilityMockResponseMultipleService(utils.createAllOKResponses()));
		PV3824CpayCredenziali.conferma(utils.creaForm('PV_SUB_134'));
	}

	@isTest
	public static void confermaOK8() {
		Test.setMock(HttpCalloutMock.class, new UtilityMockResponseMultipleService(utils.createAllOKDoubleResponses()));
		PV3824CpayCredenziali.conferma(utils.creaForm('PV_SUB_135'));
	}

	@isTest
	public static void confermaOK9() {
		Test.setMock(HttpCalloutMock.class, new UtilityMockResponseMultipleService(utils.createAllOKResponses()));
		PV3824CpayCredenziali.conferma(utils.creaForm('PV_SUB_136'));
	}

	@isTest
	public static void confermaOKChiudiCaseSospeso() {
		Test.setMock(HttpCalloutMock.class, new UtilityMockResponseMultipleService(utils.createAllOKResponses()));
		String codCliente = 'NonExistingCod';
		// È una riemissione via posta quindi rimane sospeso
		PV3824CpayCredenziali.conferma(utils.creaForm('PV_SUB_131', codCliente));

		Test.startTest();
		PV3824CpayCredenziali.conferma(utils.creaForm('PV_SUB_131', codCliente));
		List<Case> casesSospesi = [Select id from Case where Cip_Cliente__c = :codCliente and CategoriaExternalId__c = :categoria and Status = 'Sospeso'];
		List<Case> casesChiusi = [Select id from Case where Cip_Cliente__c = :codCliente and CategoriaExternalId__c = :categoria and Status = 'Closed'];

		System.assert(casesSospesi.size() == 1);
		System.assert(casesChiusi.size() == 1);

		Test.stopTest();

	}



}