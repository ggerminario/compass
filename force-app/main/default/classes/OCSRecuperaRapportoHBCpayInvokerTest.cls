@ isTest
(SeeAllData = true) 
public with sharing class OCSRecuperaRapportoHBCpayInvokerTest {

	@isTest static void multipleInvokingTest() {

		String respJSON = '{"resultCode":0,"resultMessage":"Ok","recuperaRapportoHBCpayResponse":{"rapportoHB":"19070477481","isDipendente":"N"}}';

		String codiceCliente = '15465134';
		String company = 'C';
		List<String> data = new List<String>{ codiceCliente, codiceCliente + 1 };

		Test.startTest();
		MyUtilityMockResponse UMR = new MyUtilityMockResponse();
		UMR.apiname = 'ocs.recuperaRapportoHBCpay';
		UMR.response = respJSON;
		Test.setMock(HttpCalloutMock.class, UMR);
		OCSRecuperaRapportoHBCpayResponse.RecuperaRapportoHBCpayResponseDTO r1 = OCSRecuperaRapportoHBCpayInvoker.callRecRapportoHB(codiceCliente).recuperaRapportoHBCpayResponse;
		OCSRecuperaRapportoHBCpayResponse.RecuperaRapportoHBCpayResponseDTO r2 = OCSRecuperaRapportoHBCpayInvoker.callRecRapportoHB(codiceCliente, company).recuperaRapportoHBCpayResponse;

		OCSRecuperaRapportoHBCpayResponse.RecuperaRapportoHBCpayResponseDTO r3 = OCSRecuperaRapportoHBCpayInvoker.callRecRapportoHB(data)[0].recuperaRapportoHBCpayResponse;
        OCSRecuperaRapportoHBCpayResponse.RecuperaRapportoHBCpayResponseDTO r4 = OCSRecuperaRapportoHBCpayInvoker.callRecRapportoHB(data, company)[0].recuperaRapportoHBCpayResponse;
        Test.stopTest();

		System.assertEquals('19070477481', r1.rapportoHB);
		System.assertEquals('N', r1.isDipendente);

        System.assertEquals('19070477481', r2.rapportoHB);
		System.assertEquals('N', r2.isDipendente);
        
        System.assertEquals('19070477481', r3.rapportoHB);
		System.assertEquals('N', r3.isDipendente);

        System.assertEquals('19070477481', r4.rapportoHB);
		System.assertEquals('N', r4.isDipendente);
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