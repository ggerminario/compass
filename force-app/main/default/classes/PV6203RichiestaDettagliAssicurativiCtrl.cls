/**
 * @File Name          : PV6203RichiestaDettagliAssicurativiCtrl.cls
 * @Description        :
 * @Author             : Adriana Lattanzi
 * @Group              :
 * @Last Modified By   : Adriana Lattanzi
 * @Last Modified On   : 7/1/2020, 17:28:42
 * @Modification Log   :
 * Ver       Date            Author                  Modification
 * 1.0    17/12/2019    Adriana Lattanzi           Initial Version
 **/
public with sharing class PV6203RichiestaDettagliAssicurativiCtrl extends PVAction {

	public class PV6203RichiestaDettagliAssicurativiForm extends PVForm {
		@AuraEnabled public String noteAggiornamentoCA { get; set; }

		@AuraEnabled public List<String> response {get; set;}
		@AuraEnabled public String codicePacchetto {get; set;}

	}



	/*@AuraEnabled
	 public static OCSCartaDatiFinanziariResponse.DatiCartaDatiFinanziariResponseDTO getDatiFinanziariCarta(String numeroCarta) {
	 OCSCartaDatiFinanziariResponse response = OCSCartaDatiFinanziariInvoker.cartaDatiFinanziari(numeroCarta);
	 return response.datiCartaDatiFinanziariResponse;
	 }*/

	//chiamata al servizio recuperaDatiRimborsoPostEA -> caricamento dati per tabella pacchetti associati
	@AuraEnabled
	public static List<OCSRecuperaDatiRimborsoPostEAInvoker.PacchettoServizioDTO> recuperaDatiRimborsoPostEA(String numeroCarta) {
		OCSRecuperaDatiRimborsoPostEAInvoker.OCSRecuperaDatiRimborsoPostEARequestDTO req = new OCSRecuperaDatiRimborsoPostEAInvoker.OCSRecuperaDatiRimborsoPostEARequestDTO();
		req.numPratica = numeroCarta;
		OCSRecuperaDatiRimborsoPostEAInvoker.Response response = OCSRecuperaDatiRimborsoPostEAInvoker.invoke(req);
		return response.recuperaDatiRimborsoPostEAResponse.elencoPacchettiServizi;
	}


	//classe pubblica per la definizione delle domande da mostrare a video
	public class Question {
		@AuraEnabled public String idDomanda;
		@AuraEnabled public String nomeDomanda;

		public Question(String idDomanda, String nomeDomanda) {
			this.idDomanda = idDomanda;
			this.nomeDomanda = nomeDomanda;
		}
	}

	
	//metodo per l'inserimento delle domande in una lista da visualizzare
	@AuraEnabled
	public static List<Question> callQuestionToShow(String pacchetto) {

		List<Question> myList = new List<Question>();
		Integer i = 0;

		myList.add(new Question(String.valueOf(++ i), 'Codice Servizio'));
		myList.add(new Question(String.valueOf(++ i), 'Tipo Polizza'));
		myList.add(new Question(String.valueOf(++ i), 'Chi è Protetto dalla polizza?'));
		myList.add(new Question(String.valueOf(++ i), 'Chi è il beneficiario delle garanzie assicurative?'));
		myList.add(new Question(String.valueOf(++ i), 'Quali sono le garanzie della polizza?'));
		myList.add(new Question(String.valueOf(++ i), 'Cosa fare per denunciare un sinistro o verificarne l\'avanzamento'));
		myList.add(new Question(String.valueOf(++ i), 'Cosa succede in caso di EAT o EAP'));
		myList.add(new Question(String.valueOf(++ i), 'Come Segnalare una insoddisfazione'));
		myList.add(new Question(String.valueOf(++ i), 'Cosa fare in caso di smarrimento delle condizioni assicurative'));
		myList.add(new Question(String.valueOf(++ i), 'Termini Recesso (SOLO SE NECESSARIO)'));
		myList.add(new Question(String.valueOf(++ i), 'Cambio Status Lavorativo (SOLO SE RICHIESTO DAL CLIENTE)'));
		myList.add(new Question(String.valueOf(++ i), 'Servizio Clienti'));

		return myList;
	}


	//chiamata per mostrare le risposte relative alla domanda selezionata
	@AuraEnabled
	public static string callResponseToShow(String idQuestion, String pacchetto){
		String response = '';
		//String field = '';

		if(idQuestion == '1'){
			response = [select Name from COM_CRMComodity_Check_Asc_Desc__c WHERE Name=:pacchetto LIMIT 1].Name;
			//field='Name';
		}
		else if(idQuestion == '2'){
			response = [select COM_CRMTipo__c from COM_CRMComodity_Check_Asc_Desc__c WHERE Name=:pacchetto LIMIT 1].COM_CRMTipo__c;
			//field='COM_CRMTipo__c';
		}
		else if(idQuestion == '3'){
			response = [select COM_CRMprotetto_da_polizza__c from COM_CRMComodity_Check_Asc_Desc__c WHERE Name=:pacchetto LIMIT 1].COM_CRMprotetto_da_polizza__c;
			//field='COM_CRMprotetto_da_polizza__c';
		}
		else if(idQuestion == '4'){
			response = [select COM_CRMBeneficiario_Polizza__c from COM_CRMComodity_Check_Asc_Desc__c WHERE Name=:pacchetto LIMIT 1].COM_CRMBeneficiario_Polizza__c;
			//field='COM_CRMBeneficiario_Polizza__c';
		}
		else if(idQuestion == '5'){
			response = [select COM_CRMGaranzia_polizza__c from COM_CRMComodity_Check_Asc_Desc__c WHERE Name=:pacchetto LIMIT 1].COM_CRMGaranzia_polizza__c;
			//field='COM_CRMGaranzia_polizza__c';
		}
		else if(idQuestion == '6'){
			response = [select COM_CRMDenuncia_Sinistro__c from COM_CRMComodity_Check_Asc_Desc__c WHERE Name=:pacchetto LIMIT 1].COM_CRMDenuncia_Sinistro__c;
			//field='COM_CRMDenuncia_Sinistro__c';
		}
		else if(idQuestion == '7'){
			response = [select COM_CRMEAT_EAP__c from COM_CRMComodity_Check_Asc_Desc__c WHERE Name=:pacchetto LIMIT 1].COM_CRMEAT_EAP__c;
			//field='COM_CRMEAT_EAP__c';
		}
		else if(idQuestion == '8'){
			response = [select COM_CRMInsoddisfazione__c from COM_CRMComodity_Check_Asc_Desc__c WHERE Name=:pacchetto LIMIT 1].COM_CRMInsoddisfazione__c;
			//field='COM_CRMInsoddisfazione__c';
		}
		else if(idQuestion == '9'){
			response = [select COM_CRMSmarrimento_Condizioni__c from COM_CRMComodity_Check_Asc_Desc__c WHERE Name=:pacchetto LIMIT 1].COM_CRMSmarrimento_Condizioni__c;
			//field='COM_CRMSmarrimento_Condizioni__c';
		}
		else if(idQuestion == '10'){
			response = [select COM_CRMTermini_Recesso__c from COM_CRMComodity_Check_Asc_Desc__c WHERE Name=:pacchetto LIMIT 1].COM_CRMTermini_Recesso__c;
			//field='COM_CRMTermini_Recesso__c';
		}
		else if(idQuestion == '11'){
			response = [select COM_CRMCambio_status_lavorativo__c from COM_CRMComodity_Check_Asc_Desc__c WHERE Name=:pacchetto LIMIT 1].COM_CRMCambio_status_lavorativo__c;
			//field='COM_CRMCambio_status_lavorativo__c';
		}
		else if(idQuestion == '12'){
			response = [select COM_CRMServizio_Clienti__c from COM_CRMComodity_Check_Asc_Desc__c WHERE Name=:pacchetto LIMIT 1].COM_CRMServizio_Clienti__c;
			//field='COM_CRMServizio_Clienti__c';
		}

		/*String query = 'select '+ field + ' from COM_CRMComodity_Check_Asc_Desc__c WHERE Name=:pacchetto LIMIT 1';
		System.debug('query: ' + query);
		List<SObject> record = Database.query(query);
		response = String.valueOf(record[0]);
		System.debug('risultato query: ' + record);*/
		System.debug('risultato query in response: ' + response);

		return response;
	}

	
	//chiamata per il salvataggio dello storico delle domande
	@AuraEnabled
	public static List<String> saveHistory(String question, List<String> storico){
		storico.add(question);
		return storico;
	}





	/*----------------------------------------------------------
	 			METODI COMUNI A TUTTI I CONTROLLER PV
	 ------------------------------------------------------------*/


	@AuraEnabled
	public static PVResponse conferma(PV6203RichiestaDettagliAssicurativiForm datiForm) {
		System.debug('PV6203RichiestaDettagliAssicurativiForm :   ' + datiForm);
		PVResponse resp = new PV6203RichiestaDettagliAssicurativiCtrl().execute(datiForm);
		return resp;
	}


	public PVResponse execute(PVForm form) {
		String messaggio_errore = '';
		try{
			PV6203RichiestaDettagliAssicurativiForm myForm = (PV6203RichiestaDettagliAssicurativiForm) form;

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

	/*public override void alertMessaggi(PVForm form, Case casoPV) {

	 PV6203RichiestaDettagliAssicurativiForm myForm = (PV6203RichiestaDettagliAssicurativiForm) form;

	 System.debug('*#* numero case : ' + CaseUtils.getCaseNumber(casoPV.Id));
	 if(myForm.isCheckFax == true && myForm.attachmentList.size() == 0) {
	 risposta.insMessage('info', 'Invia quanto richiesto al fax 02.721325337 riportando sui documenti il numero di richiesta CRM ' + CaseUtils.getCaseNumber(casoPV.Id), '20000');
	 }

	 }*/


	public override Case completaCasePostVendita(Case casoPV, PVForm form) {
		PV6203RichiestaDettagliAssicurativiForm myForm = (PV6203RichiestaDettagliAssicurativiForm) form;
		String risposta = '';
		for(String s : myForm.response){
			risposta += '[';
			risposta += s;
			risposta += ']';
		}
		casoPV.Risposte__c = risposta;
		casoPV.Codice_Pacchetto__c = myForm.codicePacchetto;
				
		return casoPV;
	}

	public override String recuperaNotaSpecificaPV(PVForm form, Case casoPV) {
		//preparazione nota
		PV6203RichiestaDettagliAssicurativiForm myForm = (PV6203RichiestaDettagliAssicurativiForm) form;

		//Note specifiche PV
		String notaSpecificaPV = '';
		notaSpecificaPV += myForm.noteAggiornamentoCA + '<br>';
		return notaSpecificaPV;

	}

	public override XCS_Messaggio__c preparaMessaggioOCS(PVForm form, XCS_Messaggio__c xcs_messaggio) {
		PV6203RichiestaDettagliAssicurativiForm myForm = (PV6203RichiestaDettagliAssicurativiForm) form;
		//xcs_messaggio.CodCliente__c = myForm.pratica.codCliente;
		return xcs_messaggio;
	}
}