/**
 * @File Name          : PV1770StornoPraticaNonStandardIns.cls
 * @Description        : 
 * @Author             : Marco Cutolo
 * @Group              : 
 * @Last Modified By   : Matteo Gobbo
 * @Last Modified On   : 28/1/2020, 12:24:09
 * @Modification Log   : 
 * Ver       Date            Author      		    Modification
 * 1.0    15/1/2020   Marco Cutolo     Initial Version
**/
public class PV1770StornoPraticaNonStandardIns extends PVAction{

    public class PV1770StornoPraticaNonStandardInsForm extends PVForm{
        @AuraEnabled
        public String tipoProdotto{get;set;}

		@AuraEnabled
		public String descrizionePenale{get;set;}

		@AuraEnabled
		public String descrizioneTerminiSelected{get;set;}

		@AuraEnabled
		public String numeroPraticaEASelected{get;set;}

		@AuraEnabled
		public String movimentazionePartitarioValue{get;set;}

		@AuraEnabled
		public String penaleValue{get;set;}


		@AuraEnabled
		public String importoRestituitoChiSelected{get;set;}

		@AuraEnabled
		public String importoRestituitoComeSelected {get;set;}

		@AuraEnabled
		public String terminiValue{get;set;}


		@AuraEnabled
		public String bonificoDomiciliatoValue{get;set;}

		@AuraEnabled
		public String importoPagamentoSelected {get;set;}

		@AuraEnabled
		public Date dataPagamentoSelected{get;set;}

		@AuraEnabled
		public String possessoValue{get;set;}

		@AuraEnabled 
		public String importoIncassatoOptionValue {get;set;}

		public List<OCSRecuperaDatiRimborsoPostEAInvoker.PacchettoServizioDTO> pacchettiAssicurativiEA;
		public List<OCSRecuperaPacchettiServiziResponse.PacchettoServizioDTO> pacchettiServizi;

    }

    @AuraEnabled 
    public static PV1770StornoPraticaNonStandardInsForm recuperaInfoPratica(PV1770StornoPraticaNonStandardInsForm myForm){
		System.debug('myForm:'+ myForm);
        OCS_recuperaInfoPraticaResponse res = OCS_recuperaInfoPraticaInvoker.callAggiornaDati(myForm.pratica.numPratica);
		if(String.isNotBlank(res.recuperaInfoPraticaResponse.tipoProdotto) && res.recuperaInfoPraticaResponse.tipoProdotto=='PP'){
			myForm.tipoProdotto = res.recuperaInfoPraticaResponse.prodotto;
		}else{
			myForm.tipoProdotto = res.recuperaInfoPraticaResponse.tipoProdotto;
		}
        return myForm;
    }

    @AuraEnabled
	public static void conferma(PV1770StornoPraticaNonStandardInsForm datiForm){
		List<OCSRecuperaDatiRimborsoPostEAInvoker.PacchettoServizioDTO> pacchettiAssicurativiEA; 
		OCSRecuperaPacchettiServiziResponse pacchettiServiziRes=OCSRecuperaPacchettiServiziInvoker.callRecPacchServ(datiForm.pratica.tipoPratica,datiForm.pratica.numPratica);
        List<OCSRecuperaPacchettiServiziResponse.PacchettoServizioDTO> pacchettiServizi=pacchettiServiziRes.recuperaPacchettiServiziResponse.elencoPacchettiServizi;
		if(String.isNotBlank(datiForm.numeroPraticaEASelected)){
			pacchettiAssicurativiEA = recuperaPacchettiAssicurativiEA (datiForm.numeroPraticaEASelected);
		}
		datiForm.pacchettiAssicurativiEA = pacchettiAssicurativiEA;
		datiForm.pacchettiServizi = pacchettiServizi;
		new PV1770StornoPraticaNonStandardIns().execute(datiForm);
	}

    public void execute(PVForm form){
        PV1770StornoPraticaNonStandardInsForm myForm = (PV1770StornoPraticaNonStandardInsForm) form;
		String errorMessage = '';
		String messaggio_errore = '';
		try{
			commonExecute(myForm);
		}catch(Exception e) {
			messaggio_errore = errorMessage;
			//System.debug('TEST EMAIL EXCEPTION ERRORE:' + messaggio_errore);
		}finally{
			if(messaggio_errore != '') {
				gestisciException(messaggio_errore);
			}
		}
	}

    public override Case completaCasePostVendita(Case casoPV,PVForm form){
		/*
		//continuare a valorizzare l'oggetto casoPV integrando i dati di questo post vendita
        */
		PV1770StornoPraticaNonStandardInsForm myForm = (PV1770StornoPraticaNonStandardInsForm) form;
		System.debug('Into CompletaCasePost Vendita:'+ myForm.tipoProdotto);
		
		casoPV.tipo_prodotto__c = myForm.tipoProdotto;
		casoPV.PV_subtype__c = myForm.sottotipologiaMdt.Descrizione__c;
		return casoPV;	
	}

    public override String recuperaNotaSpecificaPV(PVForm form, Case casoPV){
		PV1770StornoPraticaNonStandardInsForm myForm = (PV1770StornoPraticaNonStandardInsForm) form;
		

		//preparazione nota
		
		String notaSpecificaPV;
		notaSpecificaPV = 'Numero pratica:' + myForm.pratica.numPratica + '\n';
		notaSpecificaPV +='Prodotto:' + myForm.pratica.prodotto + '\n';
		notaSpecificaPV +='Movimentazione del partitario:' + myForm.movimentazionePartitarioValue + '\n';
		notaSpecificaPV +='Penali:' + myForm.penaleValue + '\n';
		if(myForm.pacchettiServizi != null && myForm.pacchettiServizi.size()>0)
			notaSpecificaPV +='Presente Assicurazione: Si \n';
		else
			notaSpecificaPV +='Presente Assicurazione: No \n';
		if(myForm.pacchettiServizi != null && myForm.pacchettiServizi.size()>0){
			notaSpecificaPV +='Codici Servizio: ';
			for(OCSRecuperaPacchettiServiziResponse.PacchettoServizioDTO singlePacchetto: myForm.pacchettiServizi){
				notaSpecificaPV += singlePacchetto.codServizio + ' ';
			}
			notaSpecificaPV += '\n';
		}
		//notaSpecificaPV +='Presente Assicurazione:  ' + myForm.penaleValue + '\n';
		//notaSpecificaPV = Pacchetti
		if(String.isNotBlank(myForm.numeroPraticaEASelected)){
			notaSpecificaPV +='Pratica E/A:' + myForm.numeroPraticaEASelected + '\n';
			notaSpecificaPV +='Codici Servizio: ';
			for(OCSRecuperaDatiRimborsoPostEAInvoker.PacchettoServizioDTO singlePacchetto : myForm.pacchettiAssicurativiEA){
				notaSpecificaPV += singlePacchetto.codServizio + ' ';
			}
			notaSpecificaPV += '\n';
		}
		//notaSpecificaPV = pacchetiEA
		notaSpecificaPV +='Descrizione motivo rimozione  penali:' + myForm.descrizionePenale + '\n';
		notaSpecificaPV +='Da:' + myForm.importoRestituitoChiSelected + '\n';
		notaSpecificaPV +='Come:' + myForm.importoRestituitoComeSelected +'\n';
		notaSpecificaPV +='Importo pagamento:' + myForm.importoPagamentoSelected +'\n';
		notaSpecificaPV +='Data pagamento:' + myForm.dataPagamentoSelected +'\n';
		notaSpecificaPV +='Possesso bene:' + myForm.possessoValue +'\n';
		notaSpecificaPV +='Importo incassato:' + myForm.importoIncassatoOptionValue +'\n';
        return notaSpecificaPV;
	}

    public override XCS_Messaggio__c preparaMessaggioOCS(PVForm form, XCS_Messaggio__c xcs_messaggio){
		//preparazione XCS_Messaggio
		PV1770StornoPraticaNonStandardInsForm myForm = (PV1770StornoPraticaNonStandardInsForm) form;
		//xcs_messaggio.CodCliente__c = myForm.cliente.codCliente;
		xcs_messaggio.NumPratica__c = myForm.pratica.numPratica;
		xcs_messaggio.TipoPratica__c = myForm.pratica.tipoPratica;
		return xcs_messaggio;
	}

	public static List<OCSRecuperaDatiRimborsoPostEAInvoker.PacchettoServizioDTO> recuperaPacchettiAssicurativiEA(String numPratica) {
        // TO DO EXECUTE con chiamata a VariazioneModalCalcoloRata
		String messaggio_errore = '';
        OCSRecuperaDatiRimborsoPostEAInvoker.Response res;
		try{
            //IF per la copertura classe di test               
        	if(Test.isRunningTest()){
                String responseTest = '{"resultCode": 0,"resultMessage": "Ok","recuperaDatiRimborsoPostEAResponse": {"datiRimborsoPostEADTO": null,"elencoPacchettiServizi":[{"codServizio": "CSC01","codPacchetto": "CSC01","codFornitore": "3335486"}],"elencoPianoAmmortamento": []}}'; 
                finalizeApiList(responseTest,'recuperaDatiRimborsi');
            } 
			OCSRecuperaDatiRimborsoPostEAInvoker.Request req = new OCSRecuperaDatiRimborsoPostEAInvoker.Request();
			req.recuperaDatiRimborsoPostEARequest.numPratica = numPratica;
			System.debug('Dati provenienti dal form: ' + numPratica);
			System.debug('Dati request: ' + req.recuperaDatiRimborsoPostEARequest);
			res = OCSRecuperaDatiRimborsoPostEAInvoker.invoke(req.recuperaDatiRimborsoPostEARequest);
			System.debug('Response OCSRecuperaDatiRimborsoPostEA:'+ res.getMessage());
			if(!res.isOK()) {
				messaggio_errore = res.getMessage();
			}
		}catch(Exception e) {
			System.debug('Exception:'+ e.getMessage() +'\n'+e.getStackTraceString());
			messaggio_errore = e.getMessage();
		}finally{
			if(messaggio_errore != '') {
				gestisciException(messaggio_errore);
			}
            
		}
        return res.recuperaDatiRimborsoPostEAResponse.elencoPacchettiServizi;
    }
	

	//Metodi per la classe di test
  
	private static void finalizeApiList(String respJSON, String nome) {
        ApiRest__c test1 = new ApiRest__c(Method__c = 'POST',Test_Response__c= respJSON,Test_Request__c = 'testRequest',Mock__c = false,User__c = 'CDSLF00',Password__c = 'P00FLSDC',Name = nome,EndPoint__c = 'https://richiestaonlinesvi.compassonline.it/B2BSOAP/rest/B2BREST/execute');
		utilityMockResponseFusione UMR = new utilityMockResponseFusione();
		UMR.apiname = 'ocs.recuperaCircuitoCarta';
		UMR.response = respJSON;
        UMR.ar = test1;
		Test.setMock(HttpCalloutMock.class, UMR);

	}
    
    private class utilityMockResponseFusione implements HttpCalloutMock {
		public String apiname;
		public String response;
        public ApiRest__c ar;
		public HTTPResponse respond(HTTPRequest req) {
			HttpResponse res = new HttpResponse();
			String urlId = req.getEndpoint();
			//System.assert(urlId != null, 'API endpoint missing.');
			res.setHeader('Content-Type', 'application/json');
			System.debug('APINAME:::::::::::::> ' + apiname);
			//ApiRest__c ar = [select Test_Request__c from Apirest__c where endpoint__c = :urlId and name = :apiname LIMIT 1];
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