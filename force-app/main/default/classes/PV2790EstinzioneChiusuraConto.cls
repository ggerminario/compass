/**
 * @File Name          : PV2790EstinzioneChiusuraConto.cls
 * @Description        :
 * @Author             : GdL Exprivia
 * @Group              :
 * @Last Modified By   : GdL Exprivia
 * @Last Modified On   : 6/2/2020, 16:26:33
 * @Modification Log   :
 * Ver       Date            Author                  Modification
 * 1.0    19/11/2019   GdL Exprivia     Initial Version
 **/

public with sharing class PV2790EstinzioneChiusuraConto extends PVAction {
	public PV2790EstinzioneChiusuraConto() {

	}

	public class PV2790EstinzioneChiusuraContoForm extends PVForm {
		@AuraEnabled public String dataOperazione { get; set; }
		@AuraEnabled public Date dataEstinzione { get; set; }
		@AuraEnabled public String saldo { get; set; }
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
	public static PVResponse conferma(PV2790EstinzioneChiusuraContoForm datiForm) {
		System.debug('PV2790EstinzioneChiusuraConto : conferma ' + datiForm);

		PVResponse resp = new PV2790EstinzioneChiusuraConto().execute(datiForm);
		return resp;

	}

	public PVResponse execute(PVForm form) {
		String messaggio_errore = '';
		try{
			PV2790EstinzioneChiusuraContoForm myForm = (PV2790EstinzioneChiusuraContoForm) form;

			// Calcolo data estinzione
			myForm.dataEstinzione = PV2790_2794ImportoDataOperazioneForm.add29days(myForm.dataOperazione);

			// Recupero il saldo
			myForm.saldo = CSEInterrogazioneSaldoLightInvoker.invoke(myForm.pratica.numPratica).cseInterrogazioneSaldoLightResponse.saldo;

			// Invio SMS - prendo il tel da datiForm.cliente.telCellulare
			String phone = myForm.cliente.telCellulare;
			if(phone != null && phone != '') {
				String testoSMS = 'Gentile cliente la sua richiesta di estinzione e chiusura conto CPAY è stata presa in carico.';
				OCSInviaSMSInvoker.inviaSMS('', phone, testoSMS, myForm.cliente.codCliente);
			}

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

		PV2790EstinzioneChiusuraContoForm myForm = (PV2790EstinzioneChiusuraContoForm) form;

		System.debug('*#* numero case : ' + CaseUtils.getCaseNumber(casoPV.Id));
		if(myForm.isCheckFax == true && myForm.attachmentList.size() == 0) {
			risposta.insMessage('info', 'Invia quanto richiesto al fax 02.721325337 riportando sui documenti il numero di richiesta CRM ' + CaseUtils.getCaseNumber(casoPV.Id), '20000');
		}

	}

	public override Case completaCasePostVendita(Case casoPV, PVForm form) {
		PV2790EstinzioneChiusuraContoForm myForm = (PV2790EstinzioneChiusuraContoForm) form;
		casoPV.F_Data_Estinzione__c = myForm.dataEstinzione;
		return casoPV;
	}

	public override String recuperaNotaSpecificaPV(PVForm form, Case casoPV) {
		PV2790EstinzioneChiusuraContoForm myForm = (PV2790EstinzioneChiusuraContoForm) form;

		String notaSpecificaPV;
		notaSpecificaPV = 'Pratica: ' + myForm.pratica.numPratica + '<br>';
		notaSpecificaPV += 'Tipo pratica: ' + myForm.pratica.tipoPratica + '<br>';
		notaSpecificaPV += 'Importo: ' + myForm.saldo + '<br>';
		notaspecificaPV += 'Data operazione: ' + myForm.dataOperazione + '<br>';

		return notaSpecificaPV;

	}

	public override XCS_Messaggio__c preparaMessaggioOCS(PVForm form, XCS_Messaggio__c xcs_messaggio) {
		PV2790EstinzioneChiusuraContoForm myForm = (PV2790EstinzioneChiusuraContoForm) form;
		xcs_messaggio.CodCliente__c = myForm.cliente.codCliente;
		return xcs_messaggio;
	}
}