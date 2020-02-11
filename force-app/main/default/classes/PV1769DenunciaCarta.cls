public with sharing class PV1769DenunciaCarta extends PVAction {

	public class PV1769DenunciaCartaForm extends PVForm {
		@AuraEnabled public OCSRecuperaDatiClienteResponse.recuperaDatiClienteResponse datiCliente { get; set; }
		@AuraEnabled public List<OCSPratica> praticheCA { get; set; }

		@AuraEnabled public String noteAggiornamentoCA { get; set; }
	}


	@AuraEnabled
	public static PVResponse conferma(PV1769DenunciaCartaForm datiForm) {
		System.debug('PV1769DenunciaCartaForm : praticheCA    :   ' + datiForm.praticheCA);
		PVResponse resp = new PV1769DenunciaCarta().execute(datiForm);
		return resp;
	}


	@AuraEnabled
	public static OCSCartaDatiFinanziariResponse.DatiCartaDatiFinanziariResponseDTO getDatiFinanziariCarta(String numeroCarta) {
		OCSCartaDatiFinanziariResponse response = OCSCartaDatiFinanziariInvoker.cartaDatiFinanziari(numeroCarta);
		return response.datiCartaDatiFinanziariResponse;
	}


	public PVResponse execute(PVForm form) {
		String messaggio_errore = '';
		try{
			PV1769DenunciaCartaForm myForm = (PV1769DenunciaCartaForm) form;

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

		PV1769DenunciaCartaForm myForm = (PV1769DenunciaCartaForm) form;

		System.debug('*#* numero case : ' + CaseUtils.getCaseNumber(casoPV.Id));
		if(myForm.isCheckFax == true && myForm.attachmentList.size() == 0) {
			risposta.insMessage('info', 'Invia quanto richiesto al fax 02.721325337 riportando sui documenti il numero di richiesta CRM ' + CaseUtils.getCaseNumber(casoPV.Id), '20000');
		}

	}


	public override Case completaCasePostVendita(Case casoPV, PVForm form) {
		return casoPV;
	}

	public override String recuperaNotaSpecificaPV(PVForm form, Case casoPV) {
		//preparazione nota
		PV1769DenunciaCartaForm myForm = (PV1769DenunciaCartaForm) form;

		//7 : Note specifiche PV
		String notaSpecificaPV;
		notaSpecificaPV = 'Pratica: ' + myForm.pratica.numPratica + '<br>';
		notaSpecificaPV += 'Tipo pratica: ' + myForm.pratica.tipoPratica + '<br>';
		notaSpecificaPV += 'Carta sostitutiva: ' + myForm.noteAggiornamentoCA + '<br>';
		return notaSpecificaPV;

	}

	public override XCS_Messaggio__c preparaMessaggioOCS(PVForm form, XCS_Messaggio__c xcs_messaggio) {
		PV1769DenunciaCartaForm myForm = (PV1769DenunciaCartaForm) form;
		xcs_messaggio.CodCliente__c = myForm.pratica.codCliente;
		return xcs_messaggio;
	}



}