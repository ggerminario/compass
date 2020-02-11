/**
 * @File Name          : PV3263GestioneAlert.cls
 * @Description        : 
 * @Author             : Adriana Lattanzi
 * @Group              : 
 * @Last Modified By   : Adriana Lattanzi
 * @Last Modified On   : 13/12/2019, 16:35:35
 * @Modification Log   : 
 * Ver       Date            Author      		    Modification
 * 1.0    6/12/2019   Adriana Lattanzi     Initial Version
**/
public with sharing class PV3263GestioneAlert extends PVAction {
    
    
    public class PV3263GestioneAlertForm extends PVForm {
		@AuraEnabled public String ot {get; set;} //operatore telefonico
		@AuraEnabled public String emettitore {get; set;}
		@AuraEnabled public String attesaAtt {get; set;}

		@AuraEnabled public OCSRecuperaInfoSIDResponse.RecuperaInfoSIDResponseDTO info {get; set;}

		@AuraEnabled public String noteAggiornamentoCA { get; set; }
	}

    //recupera dati finanziari
    @AuraEnabled
	public static OCSCartaDatiFinanziariResponse.DatiCartaDatiFinanziariResponseDTO recuperaDatiFinanziari(String numeroCarta){
		OCSCartaDatiFinanziariResponse cartaDatiFinanziariResponse = OCSCartaDatiFinanziariInvoker.cartaDatiFinanziari(numeroCarta);
		return cartaDatiFinanziariResponse.datiCartaDatiFinanziariResponse;
	}

    //recupera info SID
    @AuraEnabled
	public static OCSRecuperaInfoSIDResponse.RecuperaInfoSIDResponseDTO recuperaInfoSIDcmp(String numeroPratica){
		OCSRecuperaInfoSIDResponse infoSIDResponse = OCSRecuperaInfoSIDInvoker.recuperaInfoSID(numeroPratica);
		//System.debug('response in gestione alert controller: ' + infoSIDResponse);

		if(infoSIDResponse.recuperaInfoSIDResponse.impSogliaAut != null && 
		!infoSIDResponse.recuperaInfoSIDResponse.impSogliaAut.equals('') &&
		!infoSIDResponse.recuperaInfoSIDResponse.impSogliaAut.equals('0')){
			infoSIDResponse.recuperaInfoSIDResponse.impSogliaAut = ((Double.valueOf(infoSIDResponse.recuperaInfoSIDResponse.impSogliaAut)/100 + '').replace('.',','));
		}

		if(infoSIDResponse.recuperaInfoSIDResponse.impSogliaAutTot != null && 
		!infoSIDResponse.recuperaInfoSIDResponse.impSogliaAutTot.equals('') &&
		!infoSIDResponse.recuperaInfoSIDResponse.impSogliaAutTot.equals('0')){
			infoSIDResponse.recuperaInfoSIDResponse.impSogliaAutTot = ((Double.valueOf(infoSIDResponse.recuperaInfoSIDResponse.impSogliaAutTot)/100 + '').replace('.',','));
		}

		if(infoSIDResponse.recuperaInfoSIDResponse.risPrincServizio != null ||
		infoSIDResponse.recuperaInfoSIDResponse.risPrincServizio.trim().equals('')){
			infoSIDResponse.recuperaInfoSIDResponse.risPrincServizio = 'N';
		}
		if(infoSIDResponse.recuperaInfoSIDResponse.pind != null ||
		infoSIDResponse.recuperaInfoSIDResponse.pind.trim().equals('')){
			infoSIDResponse.recuperaInfoSIDResponse.pind = 'N';
		}
		if(infoSIDResponse.recuperaInfoSIDResponse.servAcqSaldoCm != null ||
		infoSIDResponse.recuperaInfoSIDResponse.servAcqSaldoCm.trim().equals('')){
			infoSIDResponse.recuperaInfoSIDResponse.servAcqSaldoCm = 'N';
		}
		if(infoSIDResponse.recuperaInfoSIDResponse.vprVariazProxRata != null ||
		infoSIDResponse.recuperaInfoSIDResponse.vprVariazProxRata.trim().equals('')){
			infoSIDResponse.recuperaInfoSIDResponse.vprVariazProxRata = 'N';
		}
		if(infoSIDResponse.recuperaInfoSIDResponse.servizioSoglia != null ||
		infoSIDResponse.recuperaInfoSIDResponse.servizioSoglia.trim().equals('')){
			infoSIDResponse.recuperaInfoSIDResponse.servizioSoglia = 'N';
		}
		
		return infoSIDResponse.recuperaInfoSIDResponse;
	}

	//chiamata rimozioneAttesaAttivazione
	@AuraEnabled
	public static OCSRimozioneAttesaAttivazioneInvoker.Response rimAttesaAttivazione(PV3263GestioneAlertForm myForm){
		OCSRimozioneAttesaAttivazioneInvoker.RimozioneAttesaAttivazioneRequestDTO input = new OCSRimozioneAttesaAttivazioneInvoker.RimozioneAttesaAttivazioneRequestDTO();
		input.provenienza='CA';
		input.tipoIntermediario='AG';
		input.intermediario='12';
		input.numCarta=myform.pratica.numPratica;
		input.pan=myform.pratica.pan;
		input.operatoreTel=myForm.info.operTelef;
		input.dataNascita=myForm.cliente.dataNascita;
		input.codiceRifExt2='';
		input.utente=myForm.cliente.codCliente;

		//System.debug('rimAttesaAttivazione input = ' + input);
		OCSRimozioneAttesaAttivazioneInvoker.Response resp = OCSRimozioneAttesaAttivazioneInvoker.invoke(input);
		return resp;
	}

	//chiamata variazioneServiziInformativi --> salvataggio dati aggiornati
	@AuraEnabled
	public static OCSVariazioneServiziInformativiInvoker.Response varServiziInformativi(PV3263GestioneAlertForm myForm){
		Boolean isValid = true;
		String impSogliaAutWS = '';
		String impSogliaAutTotWS = '';

		Decimal bd;
		if(myForm.info.impSogliaAut != null && !myForm.info.impSogliaAut.trim().equals('')){
			myForm.info.impSogliaAut = myForm.info.impSogliaAut.trim().replace(',', '.');
			System.debug('in if impsogliaAUt = ' + myForm.info.impSogliaAut);
			//try{
				//Decimal bd = Decimal.valueOf(myForm.info.impSogliaAut.substring(0,myForm.info.impSogliaAut.indexOf('.')+3));
				//bd = Decimal.valueOf(myForm.info.impSogliaAut.substring(0,myForm.info.impSogliaAut.indexOf('.')+3));
				bd = Decimal.valueOf(myForm.info.impSogliaAut);
				System.debug('in if bd = ' + bd);
				//if(bd.compareTo(Decimal.valueOf(0)) == -1){
				if(bd < 0.00){
					isValid = false;
				}
				else{
					//bd = bd.multiply(Decimal.valueOf(100));
					bd = bd*100;
		    		impSogliaAutWS = bd.setScale(0).toPlainString();
				}
			//}
			/*catch (NumberFormatException nfe){
				isValid = false;
			}*/
		}
		System.debug('impSogliaAutWS = ' + impSogliaAutWS + ' -bd- ' + bd + ' -imp- ' + myForm.info.impSogliaAut + ' -isvalid- ' + isValid);
		if(isValid){
			if(myForm.info.impSogliaAutTot != null && !myForm.info.impSogliaAutTot.trim().equals('')){
				myForm.info.impSogliaAutTot = myForm.info.impSogliaAutTot.trim().replace(',', '.');
				System.debug('in if impsogliaAUtTot = ' + myForm.info.impSogliaAutTot);
				//try{
					//Decimal bd = Decimal.valueOf(myForm.info.impSogliaAutTot);
					bd = Decimal.valueOf(myForm.info.impSogliaAutTot);
					System.debug('in if TOT bd = ' + bd);
					//if(bd.compareTo(Decimal.valueOf(0)) == -1){
					if(bd < 0.00){
						isValid = false;
					}
					else{
						//bd = bd.multiply(Decimal.valueOf(100));
						bd = bd*100;
						impSogliaAutTotWS = bd.setScale(0).toPlainString();
					}
				//}
				/*catch (NumberFormatException nfe){
					isValid = false;
				}*/
			}
		}
		System.debug('impSogliaAutTotWS = ' + impSogliaAutTotWS + ' -bd- ' + bd + ' -imp- ' + myForm.info.impSogliaAutTot + ' -isvalid- ' + isValid);
		OCSVariazioneServiziInformativiInvoker.VariazioneServiziInformativiRequestDTO request;
		if(isValid){
			request = new OCSVariazioneServiziInformativiInvoker.VariazioneServiziInformativiRequestDTO();
			request.intermediario='12';
			request.provenienza='CA';
			request.tipoIntermediario='AG';
			request.procedura='CA';
			request.numPratica=myform.pratica.numPratica;
			request.cellulare=myForm.info.cellulare;
			request.email=myForm.info.email;
			request.codiceRifExt='';
			request.codiceRifExt2='';
			request.attesaAttivaz=myForm.attesaAtt;
			request.pind=myForm.info.pind;
			request.servAcqSaldoCm=myForm.info.servAcqSaldoCm;
			request.servInfo='';
			request.variazProxRata=myForm.info.vprVariazProxRata;
			request.servSoglia=myForm.info.servizioSoglia;
			request.impServSoglia=myForm.info.importoSoglia;
			request.utente=myForm.cliente.codCliente;
			request.operatoreTel=myForm.info.operTelef;
			request.servAggEc=myForm.info.servizioAggEc;
			request.protCampServ=myForm.info.protCampServizio;
			request.bloccoServ=myForm.info.bloccoServizio;
			request.servSaldo=myForm.info.servizioSaldo;
			request.freqServSaldo=myForm.info.frequenzaSaldo;
			request.avvisoAut=myForm.info.avvisoAut;
			request.avvisoAutTot=myForm.info.avvisoAutTot;
			if(request.avvisoAut != null && request.avvisoAut.equals('S') && myForm.emettitore != '3'){
				request.impSogliaAut=impSogliaAutWS;
			}
			else if(request.avvisoAut != null && request.avvisoAut.equals('S') && myForm.emettitore == '3'){
				request.impSogliaAut='18000';
			}
			else{
				//System.debug('in assegnazione impSogliaAut in else');
				request.impSogliaAut='';
			}
			request.presSogliaAut=myForm.info.presSogliaAut;
			if(request.avvisoAutTot != null && request.avvisoAutTot.equals('S')){
				request.impSogliaAutTot=impSogliaAutTotWS;
			}
			else{
				request.impSogliaAutTot='';
			}
			request.risPrincServ=myForm.info.risPrincServizio;
		}

		System.debug('variazioneServizi request = ' + request);
		OCSVariazioneServiziInformativiInvoker.Response resp = OCSVariazioneServiziInformativiInvoker.invoke(request);
		return resp;
	}

	


    
    @AuraEnabled
	public static void conferma(PV3263GestioneAlertForm datiForm) {
        System.debug('---> [PV3255InserimentoAnnulloBlocco - conferma] datiForm: ' + datiForm);
		new PV3263GestioneAlert().execute(datiForm);
	}

	public void execute(PVForm form) {
		String messaggio_errore = '';

        try {
			PV3263GestioneAlertForm myForm = (PV3263GestioneAlertForm) form;
            System.debug('---> [PV3263GestioneAlert - execute] PVForm: ' + myForm);
			if(myForm.emettitore == '3'){
				if(myForm.attesaAtt == 'S'){
					//System.debug('in attesaAttivazione S');
					OCSRimozioneAttesaAttivazioneInvoker.Response response = rimAttesaAttivazione(myForm);
					if(response.rimozioneAttesaAttivazioneResponse.AS400Status == 'KO'){
						messaggio_errore = 'Errore da OCS: ';
						messaggio_errore += response.rimozioneAttesaAttivazioneResponse.AS400Status + ' - ';
						messaggio_errore += response.rimozioneAttesaAttivazioneResponse.AS400Errore;
					}
					else {
						myForm.info.attesaAttivazione = 'N';
					}
				}
			}
			if(messaggio_errore==''){
				OCSVariazioneServiziInformativiInvoker.Response respServizi = varServiziInformativi(myForm);
				System.debug('variazione servizi informativi response = ' + respServizi);
				if(respServizi.variazioneServiziInformativiResponse.AS400Status == 'KO'){
					messaggio_errore = 'Errore da OCS: ';
					messaggio_errore += respServizi.variazioneServiziInformativiResponse.AS400Status + ' - ';
					messaggio_errore += respServizi.variazioneServiziInformativiResponse.AS400Errore;
				}
			}
			
			
			commonExecute(myForm);
			
		} catch (Exception e) {
			messaggio_errore = e.getMessage();
		} finally {
			if (messaggio_errore != '') {
				gestisciException(messaggio_errore);
			}
		}
	}
    
	public override Case completaCasePostVendita(Case casoPV, PVForm form) {
		return casoPV;
	}

	public override String recuperaNotaSpecificaPV(PVForm form, Case casoPV) {
		PV3263GestioneAlertForm myform = (PV3263GestioneAlertForm) form;
		String notaSpecificaPV = '';
		notaSpecificaPV += myForm.noteAggiornamentoCA + '<br>';
		return notaSpecificaPV;
	}

	public override XCS_Messaggio__c preparaMessaggioOCS(PVForm form, XCS_Messaggio__c xcs_messaggio) {
		PV3263GestioneAlertForm myForm = (PV3263GestioneAlertForm) form;
		/*xcs_messaggio.NumPratica__c = myForm.pratica.numPratica;
		xcs_messaggio.TipoPratica__c = myForm.pratica.tipoPratica;
		xcs_messaggio.CodCliente__c = myForm.pratica.codCliente;*/
		return xcs_messaggio;
	}

}