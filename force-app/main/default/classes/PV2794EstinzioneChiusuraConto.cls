/**
 * @File Name          : PV2794EstinzioneChiusuraConto.cls
 * @Description        :
 * @Author             : Raffaele Prudenzano
 * @Group              :
 * @Last Modified By   : Adriana Lattanzi
 * @Last Modified On   : 27/11/2019, 12:35:02
 * @Modification Log   :
 * Ver       Date            Author                  Modification
 * 1.0    19/11/2019   Raffaele Prudenzano     Initial Version
 **/

public with sharing class PV2794EstinzioneChiusuraConto extends PVAction {
	public PV2794EstinzioneChiusuraConto() {

	}


	public class PV2794EstinzioneChiusuraContoForm extends PVForm {
	}


	public class IndirizziUrl {
		@AuraEnabled public String linkOTP { get; set; }
		@AuraEnabled public String linkNoOTP { get; set; }
	}

	//invocazione del servizio per la creazione dei link home bancking
	@AuraEnabled
	public static OCSRecuperaRapportoHBCpayResponse.RecuperaRapportoHBCpayResponseDTO RapportoHB(String cliente) {
		System.debug('cliente passato a chiamata servizio: ' + cliente);
		OCSRecuperaRapportoHBCpayResponse response = new OCSRecuperaRapportoHBCpayResponse();
		response = OCSRecuperaRapportoHBCpayInvoker.callRecRapportoHB(cliente);
		System.debug('response in Rapporto HB: ' + response.recuperaRapportoHBCpayResponse);
		return response.recuperaRapportoHBCpayResponse;
	}

	//controlli sulla visibilità dei button per home bancking
	@AuraEnabled
	public static Boolean ControllButton(OCSRecuperaRapportoHBCpayResponse.RecuperaRapportoHBCpayResponseDTO rapportoHB, String office, String username) {
		Boolean showUrl = false;
		System.debug('in controllbutton per showURL');
		if(rapportoHB.isDipendente == 'N') {
			if((office == 'NumeroBlu') || (office == 'NET') || (office == 'NBluBO') || (office == 'CCInterno') || (office == 'Visiant') || (office == 'BACK') || (office == 'SCDWM')) {
				showUrl = true;
			} 
			else if((username == 'CU2837') || (username == 'CU2319')) {
				showUrl = true;
			}
		} else {
			if((username == 'CU2873') || (username == '2319') || (office == 'SCDWM')) {
				showUrl = true;
			}
		}

		System.debug('in controll button: showURL = ' + showUrl);
		return showUrl;
	}

	//valorizzazione dei link di reindirizzamento
	@AuraEnabled
	public static IndirizziUrl CostruisciLink(OCSRecuperaRapportoHBCpayResponse.RecuperaRapportoHBCpayResponseDTO rapportoHB) {

		IndirizziUrl links = new IndirizziUrl();

		String linkOTP = '';
		linkOTP += 'https://compassweb-col.int.compassonline.it/puc2/compass/sso/login/enterCallCenter?abi=19275&#38;rapportoHB=';
		linkOTP += rapportoHB.rapportoHB;
		linkOTP += '&FlagSMS=S';

		String linkNoOTP = '';
		linkNoOTP += 'https://compassweb-col.int.compassonline.it/puc2/compass/sso/login/enterCallCenter?abi=19275&#38;rapportoHB=';
		linkNoOTP += rapportoHB.rapportoHB;
		linkNoOTP += '&FlagSMS=N';

		links.linkOTP = linkOTP;
		links.linkNoOTP = linkNoOTP;

		System.debug('link inseriti in lista: ' + links);
		return links;
	}

	@AuraEnabled
	public static PVResponse conferma(PV2794EstinzioneChiusuraContoForm datiForm) {
		System.debug('PV2794EstinzioneChiusuraConto : conferma ' + datiForm);

		PVResponse resp = new PV2794EstinzioneChiusuraConto().execute(datiForm);
		return resp;
	}

	public PVResponse execute(PVForm form) {
		String messaggio_errore = '';
		try{
			PV2794EstinzioneChiusuraContoForm myForm = (PV2794EstinzioneChiusuraContoForm) form;
			//Common di PVAction
			commonExecute(myForm);
		} catch(Exception e) {
			messaggio_errore = loggaException(e);
		}finally {
			if(messaggio_errore != '') {
				gestisciException(messaggio_errore);
			}
		}
		return risposta;
	}

	public override void alertMessaggi(PVForm form, Case casoPV) {

		PV2794EstinzioneChiusuraContoForm myForm = (PV2794EstinzioneChiusuraContoForm) form;

		System.debug('*#* numero case : ' + CaseUtils.getCaseNumber(casoPV.Id));
		if(myForm.isCheckFax == true && myForm.attachmentList.size() == 0) {
			risposta.insMessage('info', 'Invia quanto richiesto al fax 02.721325337 riportando sui documenti il numero di richiesta CRM ' + CaseUtils.getCaseNumber(casoPV.Id), '20000');
		}

	}

	public override Case completaCasePostVendita(Case casoPV, PVForm form) {
		PV2794EstinzioneChiusuraContoForm myForm = (PV2794EstinzioneChiusuraContoForm) form;

		// Salvo il n.telefono per successivo invio SMS da PV2794EstinzioneChiusuraContoGestione.cls
		casoPV.SuppliedPhone = myForm.cliente.telCellulare;

		return casoPV;
	}

	public override String recuperaNotaSpecificaPV(PVForm form, Case casoPV) {
		PV2794EstinzioneChiusuraContoForm myForm = (PV2794EstinzioneChiusuraContoForm) form;

		String notaSpecificaPV;
		notaSpecificaPV = 'Pratica: ' + myForm.pratica.numPratica + '<br>';
		notaSpecificaPV += 'Tipo pratica: ' + myForm.pratica.tipoPratica + '<br>';
		return notaSpecificaPV;
	}

	public override XCS_Messaggio__c preparaMessaggioOCS(PVForm form, XCS_Messaggio__c xcs_messaggio) {
		PV2794EstinzioneChiusuraContoForm myForm = (PV2794EstinzioneChiusuraContoForm) form;
		xcs_messaggio.CodCliente__c = myForm.cliente.codCliente;
		return xcs_messaggio;
	}
}