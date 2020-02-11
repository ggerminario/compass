public class PV3700RispedizioneBollettiniPostaliCnt extends PVAction{
    public class PV3700RispedizioneBollettiniPostaliInsForm extends PVForm {
		@AuraEnabled
		public String dataUltimoInvio {get;set;}
	
	}

	@AuraEnabled
	public static void conferma(PV3700RispedizioneBollettiniPostaliInsForm datiForm){
		new PV3700RispedizioneBollettiniPostaliCnt().execute(datiForm);
	}

	public void execute(PVForm form){
		// TO DO EXECUTE con chiamata a VariazioneModalCalcoloRata
		PV3700RispedizioneBollettiniPostaliInsForm myForm = (PV3700RispedizioneBollettiniPostaliInsForm) form;
		String messaggio_errore = '';
		try{
            //Common di PVAction
            commonExecute(myForm);
		}catch(Exception e) {
			messaggio_errore = e.getMessage();
			System.debug('TEST EMAIL EXCEPTION ERRORE:' + messaggio_errore);
		}finally{
			if(messaggio_errore != '') {
				gestisciException(messaggio_errore);
			}
		}
	}
	/*
	@AuraEnabled
	public static OCSRistampaCarnetBollettiniInvoker.RistampaCarnetBollettiniResponseDTO recuperaInfoBollettini(String numeroPratica){
		RistampaCarnetBollettiniRequestDTO

		OCSRistampaCarnetBollettiniInvoker.Response res = OCSRistampaCarnetBollettiniInvoker.invoke(numeroPratica);
		return res.ristampaCarnetBollettiniResponse;
	}*/

	@AuraEnabled
	public static OCSRistampaCarnetBollettiniInvoker.RistampaCarnetBollettiniResponseDTO recuperaInfoBollettini(PV3700RispedizioneBollettiniPostaliInsForm myForm){
		String messaggio_errore = '';
		OCSRistampaCarnetBollettiniInvoker.Response res;
		try{
			//PV3700RispedizioneBollettiniPostaliInsForm myForm = (PV3700RispedizioneBollettiniPostaliInsForm) form;
			OCSRistampaCarnetBollettiniInvoker.Request req = new OCSRistampaCarnetBollettiniInvoker.Request();
			req.ristampaCarnetBollettiniRequest.DataScadenza = formatDate(System.today());    //Da chiedere             
			req.ristampaCarnetBollettiniRequest.NumPratica  = myForm.pratica.numPratica;                          
			req.ristampaCarnetBollettiniRequest.NumeroCCP = '001';                                 
			req.ristampaCarnetBollettiniRequest.StatoPrenotazione = 'T';                          
			req.ristampaCarnetBollettiniRequest.TipoGenerazione = 'RC';                         
			req.ristampaCarnetBollettiniRequest.FlagUltimoInvio = 'S'; //Da chiedere 
			res = OCSRistampaCarnetBollettiniInvoker.invoke(req.ristampaCarnetBollettiniRequest);
			if(!res.isOK()) {
					messaggio_errore = res.getMessage();
			}
		}
		catch(Exception e) {
			messaggio_errore = e.getMessage();
			System.debug('TEST EMAIL EXCEPTION ERRORE:' + messaggio_errore + e.getStackTraceString());
		}finally{
			if(messaggio_errore != '') {
				gestisciException(messaggio_errore);
			}
		}
		return res.ristampaCarnetBollettiniResponse;
	}


    //todo documento ultima pagina nota
	public override String recuperaNotaSpecificaPV(PVForm form, Case casoPV) {
		 // Il recupero della nota specifica è necessario per Segnalazioni CS, non viene selezionata alcuna pratica. 
		//preparazione nota
		PV3700RispedizioneBollettiniPostaliInsForm myForm = (PV3700RispedizioneBollettiniPostaliInsForm) form;
		//7 : Note specifiche PV
		String notaSpecificaPV = '';
        //To Add motivo
		     notaSpecificaPV = 	  'Numero pratica: ' + myForm.pratica.numPratica + '\n'
                            	+ 'Codice cliente: ' + myForm.cliente.codCliente + '\n'
                            	+ 'Nome cliente: ' + myForm.cliente.nome + ' ' + myForm.cliente.cognome +  '\n'
                            	+ 'Precedente invio: ' + myForm.dataUltimoInvio + '\n';
		
		return notaSpecificaPV;
	}

	public override Case completaCasePostVendita(Case casoPV,PVForm form){
		//continuare a valorizzare l'oggetto casoPV integrando i dati di questo post vendita
		return casoPV;
	}

	public override XCS_Messaggio__c preparaMessaggioOCS(PVForm form, XCS_Messaggio__c xcs_messaggio){
		return xcs_messaggio;
	}

	private static String formatDate(Date d){
		return String.valueof(d.year())+String.valueof(d.month())+String.valueof(d.day());
	}

	
}