/**
 * @File Name          : PV5865CancellazioneAnagraficaTest.cls
 * @Description        : 
 * @Author             : Adriana Lattanzi
 * @Group              : 
 * @Last Modified By   : Adriana Lattanzi
 * @Last Modified On   : 16/1/2020, 11:51:37
 * @Modification Log   : 
 * Ver       Date            Author      		    Modification
 * 1.0    16/1/2020   Adriana Lattanzi     Initial Version
**/
@isTest(SeeAllData = true)
public with sharing class PV5865CancellazioneAnagraficaTest {
    
    static String Categoria = '5865';

	@isTest static void testConfermaOK() {

		String respJson = '{   "resultCode": 0,   "resultMessage": "Ok",   "cancellazioneAnagraficaResponse":    {      "as400Status": "KO",      "as400Errore": "CONTROPARTE PRESENTE IN PROCEDURA CO"   }}';

		PV5865CancellazioneAnagraficaController.PV5865CancellazioneAnagraficaForm form = creaForm();
        form.codiceCliente = '2489475';
		form.esito = 'KO';
		form.errore = 'CONTROPARTE PRESENTE IN PROCEDURA CO';

		MyUtilityMockResponse UMR = new MyUtilityMockResponse();
		UMR.apiname = 'ocs.cancellazioneAnagrafica';
		UMR.response = respJSON;
		Test.setMock(HttpCalloutMock.class, UMR);

		PV5865CancellazioneAnagraficaController.conferma(form);
        
	}



	public static PV5865CancellazioneAnagraficaController.PV5865CancellazioneAnagraficaForm creaForm() {
		PVtestFactory pVtestFactory = new PVtestFactory();

		PV5865CancellazioneAnagraficaController.PV5865CancellazioneAnagraficaForm form = new PV5865CancellazioneAnagraficaController.PV5865CancellazioneAnagraficaForm();

		form = (PV5865CancellazioneAnagraficaController.PV5865CancellazioneAnagraficaForm) pVtestFactory.initForm(Categoria, form);

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