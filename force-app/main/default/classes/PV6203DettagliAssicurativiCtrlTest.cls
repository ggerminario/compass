/**
 * @File Name          : PV6203DettagliAssicurativiCtrlTest.cls
 * @Description        : 
 * @Author             : Adriana Lattanzi
 * @Group              : 
 * @Last Modified By   : Adriana Lattanzi
 * @Last Modified On   : 8/1/2020, 11:02:12
 * @Modification Log   : 
 * Ver       Date            Author      		    Modification
 * 1.0    7/1/2020   Adriana Lattanzi     Initial Version
**/
@isTest(SeeAllData = true)
public with sharing class PV6203DettagliAssicurativiCtrlTest {

	static String Categoria = '6203';


    @isTest static void testRecuperaDatiRimborsoPostEA() {
		String respJSON = '{"resultCode": 0,"resultMessage": "Ok","recuperaDatiRimborsoPostEAResponse":    {"datiRimborsoPostEADTO":       {         "tipoPratica": "CO",         "codCliente": "16366337",         "numPratica": "17801361",         "statoPratica": "40",         "attributoPratica": "",         "dataDecorrenza": "20170629",         "dataCaricamento": "20170626",         "dataPrimaScadenza": "20170730",         "dataUltimaScadenza": "20200630",         "dataEstinzione": null,         "dataChiusura": null,         "dataAccettazione": "20170629",         "numRate": "36"      },      "elencoPacchettiServizi": [      {         "codServizio": "AIG3A",         "codPacchetto": "AIG3A",         "codFornitore": "5797010",         "dataInizioCopertura": "20170629",         "dataFineCopertura": "20200630",         "assicurazioneAttivaFinanziata": "33408",         "durata": "36",         "desFornitore": "METLIFE"      }],      "elencoPianoAmmortamento":       [                  {            "ratePreammortamento": "0",            "numRata": "1",            "dataScadenzaRata": "20170730"         },                  {            "ratePreammortamento": "0",            "numRata": "2",            "dataScadenzaRata": "20170830"         },                  {            "ratePreammortamento": "0",            "numRata": "3",            "dataScadenzaRata": "20170930"         },                  {            "ratePreammortamento": "0",            "numRata": "4",            "dataScadenzaRata": "20171030"         },                  {            "ratePreammortamento": "0",            "numRata": "5",            "dataScadenzaRata": "20171130"         },                  {            "ratePreammortamento": "0",            "numRata": "6",            "dataScadenzaRata": "20171230"         },                  {            "ratePreammortamento": "0",            "numRata": "7",            "dataScadenzaRata": "20180130"         },                  {            "ratePreammortamento": "0",            "numRata": "8",            "dataScadenzaRata": "20180228"         },                  {            "ratePreammortamento": "0",            "numRata": "9",            "dataScadenzaRata": "20180330"         },                  {            "ratePreammortamento": "0",            "numRata": "10",            "dataScadenzaRata": "20180430"         },                  {            "ratePreammortamento": "0",            "numRata": "11",            "dataScadenzaRata": "20180530"         },                  {            "ratePreammortamento": "0",            "numRata": "12",            "dataScadenzaRata": "20180630"         },                  {            "ratePreammortamento": "0",            "numRata": "13",            "dataScadenzaRata": "20180730"         },                  {            "ratePreammortamento": "0",            "numRata": "14",            "dataScadenzaRata": "20180830"         },                  {            "ratePreammortamento": "0",            "numRata": "15",            "dataScadenzaRata": "20180930"         },                  {            "ratePreammortamento": "0",            "numRata": "16",            "dataScadenzaRata": "20181030"         },                  {            "ratePreammortamento": "0",            "numRata": "17",            "dataScadenzaRata": "20181130"         },                  {            "ratePreammortamento": "0",            "numRata": "18",            "dataScadenzaRata": "20181230"         },                  {            "ratePreammortamento": "0",            "numRata": "19",            "dataScadenzaRata": "20190130"         },                  {            "ratePreammortamento": "0",            "numRata": "20",            "dataScadenzaRata": "20190228"         },                  {            "ratePreammortamento": "0",            "numRata": "21",            "dataScadenzaRata": "20190330"         },                  {            "ratePreammortamento": "0",            "numRata": "22",            "dataScadenzaRata": "20190430"         },                  {            "ratePreammortamento": "0",            "numRata": "23",            "dataScadenzaRata": "20190530"         },                  {            "ratePreammortamento": "0",            "numRata": "24",            "dataScadenzaRata": "20190630"         },                  {            "ratePreammortamento": "0",            "numRata": "25",            "dataScadenzaRata": "20190730"         },                  {            "ratePreammortamento": "0",            "numRata": "26",            "dataScadenzaRata": "20190830"         },                  {            "ratePreammortamento": "0",            "numRata": "27",            "dataScadenzaRata": "20190930"         },                  {            "ratePreammortamento": "0",            "numRata": "28",            "dataScadenzaRata": "20191030"         },                  {            "ratePreammortamento": "0",            "numRata": "29",            "dataScadenzaRata": "20191130"         },                  {            "ratePreammortamento": "0",            "numRata": "30",            "dataScadenzaRata": "20191230"         },                  {            "ratePreammortamento": "0",            "numRata": "31",            "dataScadenzaRata": "20200130"         },                  {            "ratePreammortamento": "0",            "numRata": "32",            "dataScadenzaRata": "20200229"         },                  {            "ratePreammortamento": "0",            "numRata": "33",            "dataScadenzaRata": "20200330"         },                  {            "ratePreammortamento": "0",            "numRata": "34",            "dataScadenzaRata": "20200430"         },                  {            "ratePreammortamento": "0",            "numRata": "35",            "dataScadenzaRata": "20200530"         },                  {            "ratePreammortamento": "0",            "numRata": "36",            "dataScadenzaRata": "20200630"         }      ]   }}';
        String numeroPratica = '17801361';

		MyUtilityMockResponse UMR = new MyUtilityMockResponse();
		UMR.apiname = 'ocs.recuperaDatiRimborsoPostEA';
		UMR.response = respJSON;
		Test.setMock(HttpCalloutMock.class, UMR);

		List<OCSRecuperaDatiRimborsoPostEAInvoker.PacchettoServizioDTO> resp = PV6203RichiestaDettagliAssicurativiCtrl.recuperaDatiRimborsoPostEA(numeroPratica);
		System.assertNotEquals(null, resp);

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



	@isTest static void testConfermaOK() {
		PV6203RichiestaDettagliAssicurativiCtrl.PV6203RichiestaDettagliAssicurativiForm form = creaForm();
		PV6203RichiestaDettagliAssicurativiCtrl.conferma(form);
	}


	@isTest static void testCallQuestionToShow(){
		String pacchetto = 'AIG3A';
		List<PV6203RichiestaDettagliAssicurativiCtrl.Question> questions = PV6203RichiestaDettagliAssicurativiCtrl.callQuestionToShow(pacchetto);
	}


	@isTest static void testCallResponseToShow(){
		String pacchetto = 'AIG3A';
		String idQ = '1';
		String respToShow = PV6203RichiestaDettagliAssicurativiCtrl.callResponseToShow(idQ, pacchetto);
		idQ = '5';
		respToShow = PV6203RichiestaDettagliAssicurativiCtrl.callResponseToShow(idQ, pacchetto);
		idQ = '8';
		respToShow = PV6203RichiestaDettagliAssicurativiCtrl.callResponseToShow(idQ, pacchetto);
		idQ = '12';
		respToShow = PV6203RichiestaDettagliAssicurativiCtrl.callResponseToShow(idQ, pacchetto);
	}


	@isTest static void testSaveHistory(){
		String idQ = '12';
		List<String> storico = new List<String>();
		List<String> storage = PV6203RichiestaDettagliAssicurativiCtrl.saveHistory(idQ, storico);
	}


	public static PV6203RichiestaDettagliAssicurativiCtrl.PV6203RichiestaDettagliAssicurativiForm creaForm() {
		PVtestFactory pVtestFactory = new PVtestFactory();

		PV6203RichiestaDettagliAssicurativiCtrl.PV6203RichiestaDettagliAssicurativiForm form = new PV6203RichiestaDettagliAssicurativiCtrl.PV6203RichiestaDettagliAssicurativiForm();



		form = (PV6203RichiestaDettagliAssicurativiCtrl.PV6203RichiestaDettagliAssicurativiForm) pVtestFactory.initForm(Categoria, form);

		List<String> response = new List<String>();
		response.add('1');
		response.add('2');
		response.add('3');
		form.response = response;

		form.codicePacchetto = 'AIG3A';

		form.pratica.numPratica = '17801361';
		// form.pratica.pan = '123';
		// form.cliente.dataNascita = '12/12/2001';

		// form.attesaAtt = '123';
		// form.cliente.codCliente = '123';

		return form;
	}

	
}