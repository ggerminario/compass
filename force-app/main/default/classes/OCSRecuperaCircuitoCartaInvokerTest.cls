@ isTest(SeeAllData = true) public with sharing class OCSRecuperaCircuitoCartaInvokerTest {

	@isTest static void multipleInvokingTest() {

		String respJSON = '{"resultCode":0,"resultMessage":"Ok","recuperaCircuitoCartaResponse":{"pan":"4163657291624528","circuito":"VIS","emettitore":"32"}}';

		String numCarta = '32103314183';
		String company = 'C';
		List<String> data = new List<String>{ numCarta, numCarta + 1 };

		Test.startTest();
		MyUtilityMockResponse UMR = new MyUtilityMockResponse();
		UMR.apiname = 'ocs.recuperaCircuitoCarta';
		UMR.response = respJSON;
		Test.setMock(HttpCalloutMock.class, UMR);
		OCSRecuperaCircuitoCartaResponse.CircuitoPanCartaDTO r1 = OCSRecuperaCircuitoCartaInvoker.callRecCircuitoCarta(numCarta).recuperaCircuitoCartaResponse;
		OCSRecuperaCircuitoCartaResponse.CircuitoPanCartaDTO r2 = OCSRecuperaCircuitoCartaInvoker.callRecCircuitoCarta(numCarta, company).recuperaCircuitoCartaResponse;

		OCSRecuperaCircuitoCartaResponse.CircuitoPanCartaDTO r3 = OCSRecuperaCircuitoCartaInvoker.callRecCircuitoCarta(data)[0].recuperaCircuitoCartaResponse;
        OCSRecuperaCircuitoCartaResponse.CircuitoPanCartaDTO r4 = OCSRecuperaCircuitoCartaInvoker.callRecCircuitoCarta(data, company)[0].recuperaCircuitoCartaResponse;
        Test.stopTest();

		System.assertEquals('VIS', r1.circuito);
		System.assertEquals('32', r1.emettitore);
		System.assertEquals('4163657291624528', r1.pan);

        System.assertEquals('VIS', r2.circuito);
		System.assertEquals('32', r2.emettitore);
		System.assertEquals('4163657291624528', r2.pan);
        
        System.assertEquals('VIS', r3.circuito);
		System.assertEquals('32', r3.emettitore);
		System.assertEquals('4163657291624528', r3.pan);

        System.assertEquals('VIS', r4.circuito);
		System.assertEquals('32', r4.emettitore);
		System.assertEquals('4163657291624528', r4.pan);
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