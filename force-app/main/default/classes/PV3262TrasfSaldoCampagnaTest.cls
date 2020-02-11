/**
 * @File Name          : PV3262TrasfSaldoCampagnaTest.cls
 * @Description        :
 * @Author             : Raffaele Prudenzano
 * @Group              :
 * @Last Modified By   : Raffaele Prudenzano
 * @Last Modified On   : 9/12/2019, 12:10:53
 * @Modification Log   :
 * Ver       Date            Author                  Modification
 * 1.0    6/12/2019   Raffaele Prudenzano     Initial Version
 **/
@ isTest(SeeAllData = true) public with sharing class PV3262TrasfSaldoCampagnaTest {
	static String Categoria = '3262';

	@isTest static void testConfermaKO() {

		PV3262TrasfSaldoCampagna.PV3262TrasfSaldoCampagnaForm form = creaForm();

		String respJSON = '{"resultCode":0,"resultMessage":"Ok","datiAcquistiErogazioneDirettaResponse":{"emettitore":"0","protocollo":"0","autor":"0","as400Status":"KO","as400Errore":"5644Statocarta/Azioneincompatibili"}}';

		MyUtilityMockResponse UMR = new MyUtilityMockResponse();
		UMR.apiname = 'ocs.acquistiErogazioneDiretta';
		UMR.response = respJSON;
		Test.setMock(HttpCalloutMock.class, UMR);

		Test.startTest();
		Exception myException;
		try{
			PV3262TrasfSaldoCampagna.conferma(form);
		} catch(Exception e) {
			myException = e;
		}
		System.assertNotEquals(null, myException);
		Test.stopTest();
	}

	@isTest static void testConfermaOK() {

		PV3262TrasfSaldoCampagna.PV3262TrasfSaldoCampagnaForm form = creaForm();

		String respJSON = '{"resultCode":0,"resultMessage":"Ok","datiAcquistiErogazioneDirettaResponse":{"emettitore":"0","protocollo":"0","autor":"0","as400Status":"OK","as400Errore":""}}';

		MyUtilityMockResponse UMR = new MyUtilityMockResponse();
		UMR.apiname = 'ocs.acquistiErogazioneDiretta';
		UMR.response = respJSON;
		Test.setMock(HttpCalloutMock.class, UMR);

		Test.startTest();
		Exception myException;
		try{
			PV3262TrasfSaldoCampagna.conferma(form);
		} catch(Exception e) {
			myException = e;
		}
		System.assertEquals(null, myException);
		Test.stopTest();
	}

	@isTest static void testGetDatiFinanziariCarta() {
		String respJSON = '{"resultCode":0,"resultMessage":"Ok","datiCartaDatiFinanziariResponse":{"numeroPratica":"8180824247","filiale":"212","emettitore":"8","pagamentoMinimo":"0","pagamentoMinimoPerc":"0.00","commissioneEntrata":"0","modCalcoloRata":"T","intestazione1":"GAMBADOROANDREA","intestazione2":"","dataValidita":"20130426","dataScadenza":"201905","checkIntermediario":"12","pagamento":"RI","bancaCliAbi":"3058","bancaCliCab":"1604","contoCorrente":"100571605864","iban":"IT04P0305801604100571605864","comRinnovo":"0","comRinnovo1":"0","comRinnovoDurata1":"0","comRinnovo2":"0","comRinnovoDurata2":"0","comRinnovo3":"0","comRinnovoDurata3":"0","stato":"60","blocco":"IV","tassoTan":"0.000","tassoTaeg":"5.160","pan":"4134280846406477","fidoTotale":"350000","dispTotale":"350000","fidoRiserva1":"200000","dispRiserva1":"200000","fidoRiserva2":"150000","dispRiserva2":"150000","fidoRiserva3":"0","dispRiserva3":"0","flagAttivazioneCarta":"N","codProdotto":"NI","desProdotto":"CARTADIPENDENTIFIDO3500","flagAlertSms":"N","riservaPrincipaleFido":"200000","riservaPrincipaleFidoSegno":"","riservaPrincipaleSaldo":"0","riservaPrincipaleSaldoSegno":"","riservaPrincipaleDisp":"200000","riservaPrincipaleDispSegno":"","riservaPrincipaleSconfino":"0","riservaPrincipaleSconfinoSegno":"","riservaPrincipaleOverlimit":"5000","riservaPrincipaleOverlimitSegno":"","riservaPrincipaleDispTeorMax":"355000","riservaPrincipaleDispTeorMaxSegno":"","riservaSalvadanaioFido":"150000","riservaSalvadanaioFidoSegno":"","riservaSalvadanaioSaldo":"0","riservaSalvadanaioSaldoSegno":"","riservaSalvadanaioDisp":"150000","riservaSalvadanaioDispSegno":"","riservaSalvadanaioSconfino":"0","riservaSalvadanaioSconfinoSegno":"","riservaSalvadanaioOverlimit":"0","riservaSalvadanaioOverlimitSegno":"","riservaSalvadanaioDispTeorMax":"355000","riservaSalvadanaioDispTeorMaxSegno":"","riservaInternetFido":"0","riservaInternetFidoSegno":"","riservaInternetSaldo":"0","riservaInternetSaldoSegno":"","riservaInternetDisp":"0","riservaInternetDispSegno":"","riservaInternetSconfino":"0","riservaInternetSconfinoSegno":"","riservaInternetOverlimit":"0","riservaInternetOverlimitSegno":"","riservaInternetDispTeorMax":"0","riservaInternetDispTeorMaxSegno":"","riservaMulticontoFido":"0","riservaMulticontoFidoSegno":"","riservaMulticontoSaldo":"0","riservaMulticontoSaldoSegno":"","riservaMulticontoDisp":"0","riservaMulticontoDispSegno":"","riservaMulticontoSconfino":"0","riservaMulticontoSconfinoSegno":"","riservaMulticontoOverlimit":"0","riservaMulticontoOverlimitSegno":"","riservaMulticontoDispTeorMax":"0","riservaMulticontoDispTeorMaxSegno":"","as400Status":"OK","as400Errore":""}}';
		String numeroCarta = '123456';

		MyUtilityMockResponse UMR = new MyUtilityMockResponse();
		UMR.apiname = 'ocs.cartaDatiFinanziari';
		UMR.response = respJSON;
		Test.setMock(HttpCalloutMock.class, UMR);

		OCSCartaDatiFinanziariResponse.DatiCartaDatiFinanziariResponseDTO resp = PV3262TrasfSaldoCampagna.getDatiFinanziariCarta(numeroCarta);
		System.assertNotEquals(null, resp);
	}
	@isTest static void testDoRecuperaElencoAutorizzazioni() {
		String respJSON = '{"resultCode":0,"resultMessage":"Ok","recuperaMovimentiAutorizzazioniViaggiantiResponse":{"recuperaMovViaggiantiResponse":{"elencoMovimenti":[],"as400Status":null,"as400Errore":null},"recuperaAutViaggiantiResponse":{"elencoAutorizzazioni":[{"autorizzazione":"422874","data":"20160812","ora":"203001","intermediario":"2438468","codEsercente":"POPEMILIAPAGL","desEsercente":"","importo":"25000","importoSegno":"","importoDivisaEstera":"25000","divisa":"978","stato":"C","esito":"A","codAzione":"000","desAzione":"approved"},{"autorizzazione":"418385","data":"20160811","ora":"110912","intermediario":"2438468","codEsercente":"POPEMILIALANC","desEsercente":"","importo":"25000","importoSegno":"","importoDivisaEstera":"25000","divisa":"978","stato":"C","esito":"A","codAzione":"000","desAzione":"approved"},{"autorizzazione":"391000","data":"20160801","ora":"95713","intermediario":"2438468","codEsercente":"CRDELLAPROVI","desEsercente":"","importo":"25000","importoSegno":"","importoDivisaEstera":"25000","divisa":"978","stato":"C","esito":"A","codAzione":"000","desAzione":"approved"},{"autorizzazione":"263366","data":"20160609","ora":"170840","intermediario":"2438468","codEsercente":"CRDELLAPROVI","desEsercente":"","importo":"25000","importoSegno":"","importoDivisaEstera":"25000","divisa":"978","stato":"C","esito":"A","codAzione":"000","desAzione":"approved"},{"autorizzazione":"243665","data":"20160531","ora":"223205","intermediario":"2438468","codEsercente":"POPEMILIAPAGL","desEsercente":"","importo":"5000","importoSegno":"","importoDivisaEstera":"5000","divisa":"978","stato":"C","esito":"A","codAzione":"000","desAzione":"approved"},{"autorizzazione":"240872","data":"20160530","ora":"171323","intermediario":"2438468","codEsercente":"POPEMILIAPAGL","desEsercente":"","importo":"10000","importoSegno":"","importoDivisaEstera":"10000","divisa":"978","stato":"C","esito":"A","codAzione":"000","desAzione":"approved"},{"autorizzazione":"235374","data":"20160527","ora":"191010","intermediario":"2438468","codEsercente":"POPEMILIAPAGL","desEsercente":"","importo":"25000","importoSegno":"","importoDivisaEstera":"25000","divisa":"978","stato":"C","esito":"A","codAzione":"000","desAzione":"approved"},{"autorizzazione":"226152","data":"20160523","ora":"190459","intermediario":"2438468","codEsercente":"POPEMILIAPAGL","desEsercente":"","importo":"25000","importoSegno":"","importoDivisaEstera":"25000","divisa":"978","stato":"C","esito":"A","codAzione":"000","desAzione":"approved"},{"autorizzazione":"218493","data":"20160520","ora":"104030","intermediario":"12","codEsercente":"","desEsercente":"","importo":"50000","importoSegno":"","importoDivisaEstera":"0","divisa":"","stato":"C","esito":"A","codAzione":"","desAzione":""}],"progressivoAutorizazione":"004","as400Status":null,"as400Errore":""}}}';
		String numPratica = '123465';
		String emettitore = '3';

		MyUtilityMockResponse UMR = new MyUtilityMockResponse();
		UMR.apiname = 'ocs.recuperaMovAutViaggianti';
		UMR.response = respJSON;
		Test.setMock(HttpCalloutMock.class, UMR);

		OCSRecuperaMovAutViaggiantiResponse.RecuperaAutViaggiantiResponseDTO resp = PV3262TrasfSaldoCampagna.doRecuperaElencoAutorizzazioni(numPratica, emettitore);
		System.assertNotEquals(null, resp);

	}
	@isTest static void testDoRecuperaElencoMovimenti() {
		String respJSON = '{"resultCode":0,"resultMessage":"Ok","recuperaMovimentiAutorizzazioniViaggiantiResponse":{"recuperaMovViaggiantiResponse":{"elencoMovimenti":[{"catMerc":"5812","causale":"010","citta":"SCANDICCI","dareAvere":"D","dataOperazione":"20190925","dataValuta":"20190925","esercente":"714311-RISTORANTE PANDAVIA A","importo":"50.0","importoSegno":"","nazione":"ITA","tipoMov":"F"},{"catMerc":"5812","causale":"010","citta":"SCANDICCI","dareAvere":"D","dataOperazione":"20190925","dataValuta":"20190925","esercente":"714311-RISTORANTE PANDAVIA A","importo":"50.0","importoSegno":"","nazione":"ITA","tipoMov":"F"}],"as400Status":null,"as400Errore":null},"recuperaAutViaggiantiResponse":{"elencoAutorizzazioni":[],"progressivoAutorizazione":"004","as400Status":null,"as400Errore":""}}}';
		String numPratica = '123465';
		String emettitore = '3';

		MyUtilityMockResponse UMR = new MyUtilityMockResponse();
		UMR.apiname = 'ocs.recuperaMovAutViaggianti';
		UMR.response = respJSON;
		Test.setMock(HttpCalloutMock.class, UMR);

		OCSRecuperaMovAutViaggiantiResponse.RecuperaMovViaggiantiResponseDTO resp = PV3262TrasfSaldoCampagna.doRecuperaElencoMovimenti(numPratica, emettitore);
		System.assertNotEquals(null, resp);

	}
	@isTest static void testDoRecuperaCampagneAttivabili() {
		String respJSON = '{"resultCode":0,"resultMessage":"Ok","recuperaCampagneAttiveAttivabiliResponse":{"recuperaCampagneAttivabiliResponse":{"elencoCampagneAttivabli":[{"codCampagna":"12J","tipologia":"","mesiDilazione":"0","numRate":"12","tanCliente":"12.500","dataInizioAutorizzazione":"20080801","dataFineAutorizzazione":"99999999","dataValidita":"20080801","dataScadenza":"20301231","descrizione":"12J-12RATETAN12,50%"},{"codCampagna":"4GS","tipologia":"","mesiDilazione":"0","numRate":"12","tanCliente":"9.000","dataInizioAutorizzazione":"20080801","dataFineAutorizzazione":"99999999","dataValidita":"20080801","dataScadenza":"20301231","descrizione":"4GS-12RATETAN9,00%"},{"codCampagna":"12J","tipologia":"","mesiDilazione":"0","numRate":"12","tanCliente":"12.500","dataInizioAutorizzazione":"20080801","dataFineAutorizzazione":"99999999","dataValidita":"20080801","dataScadenza":"20301231","descrizione":"12J-12RATETAN12,50%"},{"codCampagna":"12U","tipologia":"","mesiDilazione":"0","numRate":"12","tanCliente":"10.500","dataInizioAutorizzazione":"20080801","dataFineAutorizzazione":"99999999","dataValidita":"20080801","dataScadenza":"20301231","descrizione":"12U-12RATETAN10,50%"},{"codCampagna":"4GA","tipologia":"","mesiDilazione":"0","numRate":"12","tanCliente":"8.210","dataInizioAutorizzazione":"0","dataFineAutorizzazione":"99999999","dataValidita":"20060301","dataScadenza":"20301231","descrizione":"12rate8,21%"},{"codCampagna":"4GS","tipologia":"","mesiDilazione":"0","numRate":"12","tanCliente":"9.000","dataInizioAutorizzazione":"20080801","dataFineAutorizzazione":"99999999","dataValidita":"20080801","dataScadenza":"20301231","descrizione":"4GS-12RATETAN9,00%"},{"codCampagna":"12J","tipologia":"","mesiDilazione":"0","numRate":"12","tanCliente":"12.500","dataInizioAutorizzazione":"20080801","dataFineAutorizzazione":"99999999","dataValidita":"20080801","dataScadenza":"20301231","descrizione":"12J-12RATETAN12,50%"},{"codCampagna":"12U","tipologia":"","mesiDilazione":"0","numRate":"12","tanCliente":"10.500","dataInizioAutorizzazione":"20080801","dataFineAutorizzazione":"99999999","dataValidita":"20080801","dataScadenza":"20301231","descrizione":"12U-12RATETAN10,50%"},{"codCampagna":"4GS","tipologia":"","mesiDilazione":"0","numRate":"12","tanCliente":"9.000","dataInizioAutorizzazione":"20080801","dataFineAutorizzazione":"99999999","dataValidita":"20080801","dataScadenza":"20301231","descrizione":"4GS-12RATETAN9,00%"},{"codCampagna":"12J","tipologia":"","mesiDilazione":"0","numRate":"12","tanCliente":"12.500","dataInizioAutorizzazione":"20080801","dataFineAutorizzazione":"99999999","dataValidita":"20080801","dataScadenza":"20301231","descrizione":"12J-12RATETAN12,50%"},{"codCampagna":"12U","tipologia":"","mesiDilazione":"0","numRate":"12","tanCliente":"10.500","dataInizioAutorizzazione":"20080801","dataFineAutorizzazione":"99999999","dataValidita":"20080801","dataScadenza":"20301231","descrizione":"12U-12RATETAN10,50%"},{"codCampagna":"4GS","tipologia":"","mesiDilazione":"0","numRate":"12","tanCliente":"9.000","dataInizioAutorizzazione":"20080801","dataFineAutorizzazione":"99999999","dataValidita":"20080801","dataScadenza":"20301231","descrizione":"4GS-12RATETAN9,00%"},{"codCampagna":"12J","tipologia":"","mesiDilazione":"0","numRate":"12","tanCliente":"12.500","dataInizioAutorizzazione":"20080801","dataFineAutorizzazione":"99999999","dataValidita":"20080801","dataScadenza":"20301231","descrizione":"12J-12RATETAN12,50%"},{"codCampagna":"12U","tipologia":"","mesiDilazione":"0","numRate":"12","tanCliente":"10.500","dataInizioAutorizzazione":"20080801","dataFineAutorizzazione":"99999999","dataValidita":"20080801","dataScadenza":"20301231","descrizione":"12U-12RATETAN10,50%"},{"codCampagna":"4GS","tipologia":"","mesiDilazione":"0","numRate":"12","tanCliente":"9.000","dataInizioAutorizzazione":"20080801","dataFineAutorizzazione":"99999999","dataValidita":"20080801","dataScadenza":"20301231","descrizione":"4GS-12RATETAN9,00%"},{"codCampagna":"12J","tipologia":"","mesiDilazione":"0","numRate":"12","tanCliente":"12.500","dataInizioAutorizzazione":"20080801","dataFineAutorizzazione":"99999999","dataValidita":"20080801","dataScadenza":"20301231","descrizione":"12J-12RATETAN12,50%"},{"codCampagna":"12U","tipologia":"","mesiDilazione":"0","numRate":"12","tanCliente":"10.500","dataInizioAutorizzazione":"20080801","dataFineAutorizzazione":"99999999","dataValidita":"20080801","dataScadenza":"20301231","descrizione":"12U-12RATETAN10,50%"},{"codCampagna":"4GS","tipologia":"","mesiDilazione":"0","numRate":"12","tanCliente":"9.000","dataInizioAutorizzazione":"20080801","dataFineAutorizzazione":"99999999","dataValidita":"20080801","dataScadenza":"20301231","descrizione":"4GS-12RATETAN9,00%"},{"codCampagna":"12J","tipologia":"","mesiDilazione":"0","numRate":"12","tanCliente":"12.500","dataInizioAutorizzazione":"20080801","dataFineAutorizzazione":"99999999","dataValidita":"20080801","dataScadenza":"20301231","descrizione":"12J-12RATETAN12,50%"},{"codCampagna":"12U","tipologia":"","mesiDilazione":"0","numRate":"12","tanCliente":"10.500","dataInizioAutorizzazione":"20080801","dataFineAutorizzazione":"99999999","dataValidita":"20080801","dataScadenza":"20301231","descrizione":"12U-12RATETAN10,50%"}],"statoRicercaCampagneAttivabili":"OK","as400Status":null,"as400Errore":""},"recuperaCampagneAttiveResponse":{"elencoCampagneAttive":[{"emettitore":"15","protocollo":"810615","riga":"10","dareAvere":"D","importoInizialeCampagna":"140000","numRate":"36","debitoResiduo":"24867","capitaleResiduo":"20667","numRateResidue":"6","dataScadenzaCampagna":"20190315"},{"emettitore":"15","protocollo":"972953","riga":"10","dareAvere":"D","importoInizialeCampagna":"22942","numRate":"36","debitoResiduo":"8547","capitaleResiduo":"7017","numRateResidue":"11","dataScadenzaCampagna":"20190815"},{"emettitore":"15","protocollo":"1127394","riga":"10","dareAvere":"D","importoInizialeCampagna":"27000","numRate":"36","debitoResiduo":"14592","capitaleResiduo":"12000","numRateResidue":"16","dataScadenzaCampagna":"20200115"},{"emettitore":"15","protocollo":"1246913","riga":"10","dareAvere":"D","importoInizialeCampagna":"100000","numRate":"36","debitoResiduo":"70945","capitaleResiduo":"58345","numRateResidue":"21","dataScadenzaCampagna":"20200615"},{"emettitore":"15","protocollo":"1331814","riga":"10","dareAvere":"D","importoInizialeCampagna":"22000","numRate":"36","debitoResiduo":"18579","capitaleResiduo":"15279","numRateResidue":"25","dataScadenzaCampagna":"20201015"},{"emettitore":"15","protocollo":"1476485","riga":"10","dareAvere":"D","importoInizialeCampagna":"22000","numRate":"36","debitoResiduo":"24523","capitaleResiduo":"20167","numRateResidue":"33","dataScadenzaCampagna":"20210615"}],"as400Status":null,"as400Errore":""}}}';
		String numPratica = '123456';
		String emettitore = '3';
		String prodotto = '123';

		MyUtilityMockResponse UMR = new MyUtilityMockResponse();
		UMR.apiname = 'ocs.recuperaMovAutViaggianti';
		UMR.response = respJSON;
		Test.setMock(HttpCalloutMock.class, UMR);

		OCSRecuperaCampAttiveAttivabInvoker.RecuperaCampagneAttivabiliResponseDTO resp = PV3262TrasfSaldoCampagna.doRecuperaCampagneAttivabili(numPratica, emettitore, prodotto);
		System.assertNotEquals(null, resp);

	}

	public static PV3262TrasfSaldoCampagna.PV3262TrasfSaldoCampagnaForm creaForm() {
		PVtestFactory pVtestFactory = new PVtestFactory();

		PV3262TrasfSaldoCampagna.PV3262TrasfSaldoCampagnaForm form = new PV3262TrasfSaldoCampagna.PV3262TrasfSaldoCampagnaForm();

		form.importo = '2.00';
		form.codCampagna = 'BP5';
		form.dataScadenza = '201808';
		form.numRate = '6';

		return (PV3262TrasfSaldoCampagna.PV3262TrasfSaldoCampagnaForm) pVtestFactory.initForm(Categoria, form);

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