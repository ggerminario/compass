public class PV3266ConversioneSaldoRevolvingIns extends PVAction{

	public class PV3266ConversioneSaldoRevolvingInsForm extends PVForm {
		@AuraEnabled
		public String modCalcRata {get;set;}

		@AuraEnabled
		public String pagMinImporto {get;set;}

		@AuraEnabled
		public String pagMinPerc{get;set;}

		@AuraEnabled
		public String modCalcRataOrig {get;set;}
	}

	@AuraEnabled
	public static void conferma(PV3266ConversioneSaldoRevolvingInsForm datiForm){
		new PV3266ConversioneSaldoRevolvingIns().execute(datiForm);
	}

	public void execute(PVForm form){
		// TO DO EXECUTE con chiamata a VariazioneModalCalcoloRata
		String messaggio_errore = '';
		try{
			PV3266ConversioneSaldoRevolvingInsForm myForm = (PV3266ConversioneSaldoRevolvingInsForm) form;
			OCSVariazioneModalCalcoloRataInvoker.Request req = new OCSVariazioneModalCalcoloRataInvoker.Request();
			req.variazioneModalCalcoloRataRequest.intermediario = '12';
			req.variazioneModalCalcoloRataRequest.provenienza = 'CA';
			req.variazioneModalCalcoloRataRequest.tipoIntermediario ='AG';
			req.variazioneModalCalcoloRataRequest.procedura ='CA';
			req.variazioneModalCalcoloRataRequest.codiceRifExt = '';
			req.variazioneModalCalcoloRataRequest.azione = 'SAR'; // Da chiedere cosa dobbiamo passare 
			req.variazioneModalCalcoloRataRequest.modCalcRata = myForm.modCalcRata.substring(0,1);
			req.variazioneModalCalcoloRataRequest.numPratica = myForm.pratica.numPratica;
			req.variazioneModalCalcoloRataRequest.utente = null; // Da chiedere cosa dobbiamo passare
			//req.variazioneModalCalcoloRataRequest.pagMinImporto = myForm.pagMinImporto;
			//req.variazioneModalCalcoloRataRequest.pagMinPerc = myForm.pagMinPerc;
			//Pag minimo importo 
			
			if(String.isNotBlank(myForm.pagMinImporto)){
				Double pagMinImportoDouble = Double.valueOf(myForm.pagMinImporto.replace(',','.'));
				pagMinImportoDouble = pagMinImportoDouble * 100;
				String rataMinima = (pagMinImportoDouble.intValue()+'').replaceAll('\\p{Punct}','');
				req.variazioneModalCalcoloRataRequest.pagMinImporto = rataMinima;
			}else{
				req.variazioneModalCalcoloRataRequest.pagMinImporto = '';
			}

			if(String.isNotBlank(myForm.pagMinPerc)){
				Double pagMinPercImportoDouble = Double.valueOf(myForm.pagMinPerc.replace(',','.'));
				pagMinPercImportoDouble = pagMinPercImportoDouble * 100;
				String rataMinimaPerc = (pagMinPercImportoDouble.intValue()+'').replaceAll('\\p{Punct}','');
				req.variazioneModalCalcoloRataRequest.pagMinPerc = rataMinimaPerc;
			}else{
				req.variazioneModalCalcoloRataRequest.pagMinPerc = '';
			}


			

			System.debug('Dati provenienti dal form: ' + myForm.modCalcRata + ' ' + myForm.pagMinImporto + ' ' + myForm.pagMinPerc);
			System.debug('Dati request: ' + req.variazioneModalCalcoloRataRequest);

			OCSVariazioneModalCalcoloRataInvoker.Response res = OCSVariazioneModalCalcoloRataInvoker.invoke(req.variazioneModalCalcoloRataRequest);

			if(!res.isOK()) {
				messaggio_errore = res.getMessage();
			}
            else if(res.variazioneModalCalcoloRataResponse.as400Status == 'KO') {
				messaggio_errore = 'Errore da OCS: ' + res.variazioneModalCalcoloRataResponse.as400Status + ' - ' + res.variazioneModalCalcoloRataResponse.as400Errore;
			}else{
				//Common di PVAction
				commonExecute(myForm);
			}

		}catch(Exception e) {
			messaggio_errore = e.getMessage();
			System.debug('TEST EMAIL EXCEPTION ERRORE:' + messaggio_errore);
		}finally{
			if(messaggio_errore != '') {
				gestisciException(messaggio_errore);
			}
		}
	}

	@AuraEnabled
	public static Map<String,String> getModalitaCalcoloRata(){
		return CompassParametersUtils.getParameterByGroup('WS.carteDatiFinanziari.ModCalcoloRata');
	}

    @AuraEnabled
	public static OCSCartaDatiFinanziariResponse.DatiCartaDatiFinanziariResponseDTO recuperaDatiFinanziari(String numeroCarta){
		OCSCartaDatiFinanziariResponse cartaDatiFinanziariResponse = OCSCartaDatiFinanziariInvoker.cartaDatiFinanziari(numeroCarta);
		return cartaDatiFinanziariResponse.datiCartaDatiFinanziariResponse;
	}

    @AuraEnabled
	public static OCSRecuperaInfoCartaResponse.RecuperaInfoCartaResponse recuperaInfoCarta(String numeroCarta){
		OCSRecuperaInfoCartaResponse recuperaInfoCartaResponse = OCSRecuperaInfoCartaInvoker.callRecInfoCarta(numeroCarta);
		return recuperaInfoCartaResponse.recuperaInfoCartaResponse;
	}

	public override Case completaCasePostVendita(Case casoPV,PVForm form){
		//continuare a valorizzare l'oggetto casoPV integrando i dati di questo post vendita
		PV3266ConversioneSaldoRevolvingInsForm myForm = (PV3266ConversioneSaldoRevolvingInsForm) form;
		return casoPV;
	}

	public override String recuperaNotaSpecificaPV(PVForm form, Case casoPV){
		//preparazione nota
		PV3266ConversioneSaldoRevolvingInsForm myForm = (PV3266ConversioneSaldoRevolvingInsForm) form;
		//7 : Note specifiche PV
		String notaSpecificaPV;
		notaSpecificaPV = 'Numero pratica: ' + myForm.pratica.numPratica + '\n' 
						 + 'Modalità calcolo rata da ' +myForm.modCalcRataOrig + ' a ' + myForm.modCalcRata.substring(0,1);
		return notaSpecificaPV;
	}

	public override XCS_Messaggio__c preparaMessaggioOCS(PVForm form, XCS_Messaggio__c xcs_messaggio){
		//preparazione XCS_Messaggio
		PV3266ConversioneSaldoRevolvingInsForm myForm = (PV3266ConversioneSaldoRevolvingInsForm) form;
		//xcs_messaggio.CodCliente__c = myForm.cliente.codCliente;
		xcs_messaggio.NumPratica__c = myForm.pratica.numPratica;
		xcs_messaggio.TipoPratica__c = myForm.pratica.tipoPratica;
		return xcs_messaggio;
	}
}