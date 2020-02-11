/**
 * @File Name          : OCSRecuperaDatiRimborsoPostEAInvokerTest.cls
 * @Description        : 
 * @Author             : Adriana Lattanzi
 * @Group              : 
 * @Last Modified By   : Adriana Lattanzi
 * @Last Modified On   : 7/1/2020, 17:25:03
 * @Modification Log   : 
 * Ver       Date            Author      		    Modification
 * 1.0    7/1/2020   Adriana Lattanzi     Initial Version
**/
@isTest(SeeAllData = true)
public with sharing class OCSRecuperaDatiRimborsoPostEAInvokerTest {
    
    @isTest
    public static void test() {
        
        String respJSON = '{"resultCode": 0,"resultMessage": "Ok","recuperaDatiRimborsoPostEAResponse":    {"datiRimborsoPostEADTO":       {         "tipoPratica": "CO",         "codCliente": "16366337",         "numPratica": "17801361",         "statoPratica": "40",         "attributoPratica": "",         "dataDecorrenza": "20170629",         "dataCaricamento": "20170626",         "dataPrimaScadenza": "20170730",         "dataUltimaScadenza": "20200630",         "dataEstinzione": null,         "dataChiusura": null,         "dataAccettazione": "20170629",         "numRate": "36"      },      "elencoPacchettiServizi": [      {         "codServizio": "AIG3A",         "codPacchetto": "AIG3A",         "codFornitore": "5797010",         "dataInizioCopertura": "20170629",         "dataFineCopertura": "20200630",         "assicurazioneAttivaFinanziata": "33408",         "durata": "36",         "desFornitore": "METLIFE"      }],      "elencoPianoAmmortamento":       [                  {            "ratePreammortamento": "0",            "numRata": "1",            "dataScadenzaRata": "20170730"         },                  {            "ratePreammortamento": "0",            "numRata": "2",            "dataScadenzaRata": "20170830"         },                  {            "ratePreammortamento": "0",            "numRata": "3",            "dataScadenzaRata": "20170930"         },                  {            "ratePreammortamento": "0",            "numRata": "4",            "dataScadenzaRata": "20171030"         },                  {            "ratePreammortamento": "0",            "numRata": "5",            "dataScadenzaRata": "20171130"         },                  {            "ratePreammortamento": "0",            "numRata": "6",            "dataScadenzaRata": "20171230"         },                  {            "ratePreammortamento": "0",            "numRata": "7",            "dataScadenzaRata": "20180130"         },                  {            "ratePreammortamento": "0",            "numRata": "8",            "dataScadenzaRata": "20180228"         },                  {            "ratePreammortamento": "0",            "numRata": "9",            "dataScadenzaRata": "20180330"         },                  {            "ratePreammortamento": "0",            "numRata": "10",            "dataScadenzaRata": "20180430"         },                  {            "ratePreammortamento": "0",            "numRata": "11",            "dataScadenzaRata": "20180530"         },                  {            "ratePreammortamento": "0",            "numRata": "12",            "dataScadenzaRata": "20180630"         },                  {            "ratePreammortamento": "0",            "numRata": "13",            "dataScadenzaRata": "20180730"         },                  {            "ratePreammortamento": "0",            "numRata": "14",            "dataScadenzaRata": "20180830"         },                  {            "ratePreammortamento": "0",            "numRata": "15",            "dataScadenzaRata": "20180930"         },                  {            "ratePreammortamento": "0",            "numRata": "16",            "dataScadenzaRata": "20181030"         },                  {            "ratePreammortamento": "0",            "numRata": "17",            "dataScadenzaRata": "20181130"         },                  {            "ratePreammortamento": "0",            "numRata": "18",            "dataScadenzaRata": "20181230"         },                  {            "ratePreammortamento": "0",            "numRata": "19",            "dataScadenzaRata": "20190130"         },                  {            "ratePreammortamento": "0",            "numRata": "20",            "dataScadenzaRata": "20190228"         },                  {            "ratePreammortamento": "0",            "numRata": "21",            "dataScadenzaRata": "20190330"         },                  {            "ratePreammortamento": "0",            "numRata": "22",            "dataScadenzaRata": "20190430"         },                  {            "ratePreammortamento": "0",            "numRata": "23",            "dataScadenzaRata": "20190530"         },                  {            "ratePreammortamento": "0",            "numRata": "24",            "dataScadenzaRata": "20190630"         },                  {            "ratePreammortamento": "0",            "numRata": "25",            "dataScadenzaRata": "20190730"         },                  {            "ratePreammortamento": "0",            "numRata": "26",            "dataScadenzaRata": "20190830"         },                  {            "ratePreammortamento": "0",            "numRata": "27",            "dataScadenzaRata": "20190930"         },                  {            "ratePreammortamento": "0",            "numRata": "28",            "dataScadenzaRata": "20191030"         },                  {            "ratePreammortamento": "0",            "numRata": "29",            "dataScadenzaRata": "20191130"         },                  {            "ratePreammortamento": "0",            "numRata": "30",            "dataScadenzaRata": "20191230"         },                  {            "ratePreammortamento": "0",            "numRata": "31",            "dataScadenzaRata": "20200130"         },                  {            "ratePreammortamento": "0",            "numRata": "32",            "dataScadenzaRata": "20200229"         },                  {            "ratePreammortamento": "0",            "numRata": "33",            "dataScadenzaRata": "20200330"         },                  {            "ratePreammortamento": "0",            "numRata": "34",            "dataScadenzaRata": "20200430"         },                  {            "ratePreammortamento": "0",            "numRata": "35",            "dataScadenzaRata": "20200530"         },                  {            "ratePreammortamento": "0",            "numRata": "36",            "dataScadenzaRata": "20200630"         }      ]   }}';
        
        test.startTest();
        OCSRecuperaDatiRimborsoPostEAInvoker.OCSRecuperaDatiRimborsoPostEARequestDTO req = new OCSRecuperaDatiRimborsoPostEAInvoker.OCSRecuperaDatiRimborsoPostEARequestDTO();
		req.numPratica = '17801361';
        MyUtilityMockResponse UMR = new MyUtilityMockResponse();
        UMR.apiname='ocs.recuperaDatiRimborsoPostEA';
        UMR.response = respJSON;
        Test.setMock(HttpCalloutMock.class,UMR);        

        OCSRecuperaDatiRimborsoPostEAInvoker.Response resp = OCSRecuperaDatiRimborsoPostEAInvoker.invoke(req);
        test.stopTest();

        System.assertEquals('CO', resp.recuperaDatiRimborsoPostEAResponse.datiRimborsoPostEADTO.tipoPratica);
        System.assertEquals('16366337', resp.recuperaDatiRimborsoPostEAResponse.datiRimborsoPostEADTO.codCliente);
        System.assertEquals('17801361', resp.recuperaDatiRimborsoPostEAResponse.datiRimborsoPostEADTO.numPratica);
        System.assertEquals('40', resp.recuperaDatiRimborsoPostEAResponse.datiRimborsoPostEADTO.statoPratica);
        System.assertEquals('', resp.recuperaDatiRimborsoPostEAResponse.datiRimborsoPostEADTO.attributoPratica);
        System.assertEquals('20170629', resp.recuperaDatiRimborsoPostEAResponse.datiRimborsoPostEADTO.dataDecorrenza);
        System.assertEquals('20170626', resp.recuperaDatiRimborsoPostEAResponse.datiRimborsoPostEADTO.dataCaricamento);
        System.assertEquals('20170730', resp.recuperaDatiRimborsoPostEAResponse.datiRimborsoPostEADTO.dataPrimaScadenza);
        System.assertEquals('20200630', resp.recuperaDatiRimborsoPostEAResponse.datiRimborsoPostEADTO.dataUltimaScadenza);
        System.assertEquals(null, resp.recuperaDatiRimborsoPostEAResponse.datiRimborsoPostEADTO.dataEstinzione);
        System.assertEquals(null, resp.recuperaDatiRimborsoPostEAResponse.datiRimborsoPostEADTO.dataChiusura);
        System.assertEquals('20170629', resp.recuperaDatiRimborsoPostEAResponse.datiRimborsoPostEADTO.dataAccettazione);
        System.assertEquals('36', resp.recuperaDatiRimborsoPostEAResponse.datiRimborsoPostEADTO.numRate);

        System.assertEquals('AIG3A', resp.recuperaDatiRimborsoPostEAResponse.elencoPacchettiServizi[0].codPacchetto);
        System.assertEquals('5797010', resp.recuperaDatiRimborsoPostEAResponse.elencoPacchettiServizi[0].codFornitore);
        System.assertEquals('20170629', resp.recuperaDatiRimborsoPostEAResponse.elencoPacchettiServizi[0].dataInizioCopertura);
        System.assertEquals('20200630', resp.recuperaDatiRimborsoPostEAResponse.elencoPacchettiServizi[0].dataFineCopertura);
        System.assertEquals('33408', resp.recuperaDatiRimborsoPostEAResponse.elencoPacchettiServizi[0].assicurazioneAttivaFinanziata);
        System.assertEquals('36', resp.recuperaDatiRimborsoPostEAResponse.elencoPacchettiServizi[0].durata);
        System.assertEquals('30/06/2020', resp.recuperaDatiRimborsoPostEAResponse.elencoPacchettiServizi[0].dataFineCoperturaSlashed);
        System.assertEquals('29/06/2017', resp.recuperaDatiRimborsoPostEAResponse.elencoPacchettiServizi[0].dataInizioCoperturaSlashed);

        System.assertEquals('0', resp.recuperaDatiRimborsoPostEAResponse.elencoPianoAmmortamento[0].ratePreammortamento);
        System.assertEquals('1', resp.recuperaDatiRimborsoPostEAResponse.elencoPianoAmmortamento[0].numRata);
        System.assertEquals('20170730', resp.recuperaDatiRimborsoPostEAResponse.elencoPianoAmmortamento[0].dataScadenzaRata);
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