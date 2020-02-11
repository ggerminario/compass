/**
 * @File Name          : PV3488AnnulloRipristinoCampagnaTest.cls
 * @Description        : 
 * @Author             : Nicola Musicco
 * @Group              : 
 * @Last Modified By   : Nicola Musicco
 * @Last Modified On   : 14/1/2020, 12:30:25
 * @Modification Log   : 
 * Ver       Date            Author      		    Modification
 * 1.0    19/12/2019   Nicola Musicco     Initial Version
**/
@isTest(SeeAllData = true)
public class PV3488AnnulloRipristinoCampagnaTest {
    static String Categoria = '3488';

    @isTest static void testDoRecuperaAzioniCAN() {
		String respJSON = '{"resultCode":0,"resultMessage":"Ok","recuperaAzioniCANResponse":{"elencoAzioni":[{"codCampagna":"12J","stato":"30","dataAcquisto":"20190407","blocco":"","operazione":"Annullo","progressivo":"85633805"},{"codCampagna":"4GS","stato":"30","dataAcquisto":"20190518","blocco":"","operazione":"Ripristino","progressivo":"85633894"}]}, "as400Status":"OK","as400Errore":"" }';

        String numPratica = '123456';
        
		MyUtilityMockResponse UMR = new MyUtilityMockResponse();
		UMR.apiname = 'ocs.recuperaAzioniCAN';
		UMR.response = respJSON;
		Test.setMock(HttpCalloutMock.class, UMR);

		OCSRecuperaAzioniCANResponse.RecuperaAzioniCANResponseDTO resp = PV3488AnnulloRipristinoCampagna.doRecuperaAzioniCAN(numPratica);
		System.assertNotEquals(null, resp);

        PV3488AnnulloRipristinoCampagna.PV3488AnnulloRipristinoCampagnaForm form=
            new PV3488AnnulloRipristinoCampagna.PV3488AnnulloRipristinoCampagnaForm();
            
        PVtestFactory pVtestFactory = new PVtestFactory();
        pVtestFactory.initForm(Categoria, form);

        form.elencoAzioniCAN=resp.elencoAzioni;

        Test.startTest();
		Exception myException;
		try{
			PV3488AnnulloRipristinoCampagna.conferma(form);
		} catch(Exception e) {
			myException = e;
		}
		System.assertEquals(null, myException);
		Test.stopTest();

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