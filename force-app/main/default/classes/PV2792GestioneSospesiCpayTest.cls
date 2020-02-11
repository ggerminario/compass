/**
 * @File Name          : PV2792GestioneSospesiCpayTest.cls
 * @Description        :
 * @Author             : Raffaele Prudenzano
 * @Group              :
 * @Last Modified By   : Raffaele Prudenzano
 * @Last Modified On   : 17/1/2020, 16:30:14
 * @Modification Log   :
 * Ver       Date            Author                  Modification
 * 1.0    17/1/2020   Raffaele Prudenzano     Initial Version
 **/
@isTest(SeeAllData = true) public with sharing class PV2792GestioneSospesiCpayTest {
	public static final String SOTTOTIPOLOGIA_ALTRO_APINAME = 'PV_SUB_71';
	public static final String Categoria = '2792';


	public PV2792GestioneSospesiCpayTest() {

	}

	@isTest
	public static void confermaOK() {
		PV2792GestioneSospesiCpay.PV2792GestioneSospesiCpayForm myForm = creaForm(SOTTOTIPOLOGIA_ALTRO_APINAME);
		myForm.pratica = null;
		PV2792GestioneSospesiCpay.conferma(myForm);
	}

	@isTest
	public static void confermaOK2() {
		PV2792GestioneSospesiCpay.PV2792GestioneSospesiCpayForm myForm = creaForm(SOTTOTIPOLOGIA_ALTRO_APINAME);
		myForm.pratica = null;
		myForm.sottotipologiaManuale = 'sottotipologiaManuale';
		PV2792GestioneSospesiCpay.conferma(myForm);
	}

	@isTest
	public static void confermaOK3() {
		PV2792GestioneSospesiCpay.PV2792GestioneSospesiCpayForm myForm = creaForm('SOME_OTHER_TIPOLOGIA');
		myForm.pratica.numPratica = '123';
		myForm.pratica.tipoPratica = 'CP';
		myForm.data = '17/01/2020';
		myForm.importo = '123';
		PV2792GestioneSospesiCpay.conferma(myForm);
	}

	@isTest
	public static void confermaKO() {
		PV2792GestioneSospesiCpay.PV2792GestioneSospesiCpayForm myForm = creaForm(SOTTOTIPOLOGIA_ALTRO_APINAME);
		myForm.pratica.numPratica = '12345678901234567890123456789';

		Exception myException;
		try{
			PV2792GestioneSospesiCpay.conferma(myForm);
		} catch(Exception e) {
			myException= e;
		}

		System.assertNotEquals(null, myException);
	}

	/*
	 Costruttori form
	 */

	public static PV2792GestioneSospesiCpay.PV2792GestioneSospesiCpayForm creaForm() {
		PVtestFactory pVtestFactory = new PVtestFactory();

		PV2792GestioneSospesiCpay.PV2792GestioneSospesiCpayForm myForm = new PV2792GestioneSospesiCpay.PV2792GestioneSospesiCpayForm();
		myForm = (PV2792GestioneSospesiCpay.PV2792GestioneSospesiCpayForm) pVtestFactory.initForm(Categoria, myForm);
		// myForm.pratica = null;
		return myForm;
	}

	public static PV2792GestioneSospesiCpay.PV2792GestioneSospesiCpayForm creaForm(String sottotipologia) {
		PV2792GestioneSospesiCpay.PV2792GestioneSospesiCpayForm myForm = creaForm();

		if(sottotipologia != null && sottotipologia.trim() != '') {
			PostvenditaConfig_subtype__mdt sottotipologiaMdt = new PostvenditaConfig_subtype__mdt();
			sottotipologiaMdt.QualifiedApiName = sottotipologia;
			myForm.sottotipologiaMdt = sottotipologiaMdt;
		}

		return myForm;
	}

	public static PV2792GestioneSospesiCpay.PV2792GestioneSospesiCpayForm creaForm(String sottotipologia, String codCliente) {
		PV2792GestioneSospesiCpay.PV2792GestioneSospesiCpayForm myForm = creaForm(sottotipologia);
		myForm.cliente.codCliente = codCliente;
		return myForm;
	}

}