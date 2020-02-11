/**
 * @File Name          : PV3824CpayCredenziali.cls
 * @Description        :
 * @Author             : Raffaele Prudenzano
 * @Group              :
 * @Last Modified By   : Raffaele Prudenzano
 * @Last Modified On   : 24/1/2020, 11:50:17
 * @Modification Log   :
 * Ver       Date            Author                  Modification
 * 1.0    17/12/2019   Raffaele Prudenzano     Initial Version
 **/
public with sharing class PV3824CpayCredenziali extends PVAction {

	public static final Boolean isInserimento = true;
	public static final String numCategoria = '3824';

	@TestVisible
	public static Date today;

	public static Date today() {
		return today == null ? Date.today() :today;
	}

	public class PV3824CpayCredenzialiForm extends PVForm {

		public List<PV3824CpayCredenzialiContext> calloutsContext { get; set; }
		public List<Case> caseDaChiudere { get; set; }

	}


	@AuraEnabled
	public static PVResponse conferma(PV3824CpayCredenzialiForm datiForm) {
		System.debug('---> [PV3824CpayCredenziali - conferma] datiForm: ' + datiForm);
		return new PV3824CpayCredenziali().execute(datiForm);
	}

	public PVResponse execute(PVForm form) {
		String messaggio_errore = '';

		try {
			PV3824CpayCredenzialiForm myForm = (PV3824CpayCredenzialiForm) form;
			if(maxRichiesteReached(myForm.cliente.codCliente)) {
				messaggio_errore = 'Attenzione. Raggiunto il numero di 5 richieste di riemissione credenziali';
			} else {
				// se non si vuole chiudere i case in sospeso, commentare questa riga di codice
				myForm.caseDaChiudere = recuperaCaseInSospeso(myForm.cliente.codCliente);

				// Inizializzo la variabile che servirà a memorizzare l'attuale stato delle chiamate del case
				myForm.calloutsContext = new List<PV3824CpayCredenzialiContext>();

				// Creo l'attuale stato delle chiamate
				messaggio_errore = createCalloutsContext(myForm, messaggio_errore);
				System.debug('### Callouts Context :' + myForm.calloutsContext);

				if(messaggio_errore == '') {
					// Eseguo le chiamate dal contesto creato precedentemente
					// L ultimo parametro caseCreationDate non viene valorizzato perchè il case non è stato ancora creato e non serve ai fini della logica da inserimento.
					myForm.calloutsContext = PV3824CpayCredenzialiContext.makeCalloutsFromContext(myForm.calloutsContext, myForm.cliente, isInserimento, null);
					System.debug('myForm.caseDaChiudere @execute: ' + myForm.caseDaChiudere);
					update myForm.caseDaChiudere;

					commonExecute(myForm);
				}

			}
		} catch(Exception e) {
			messaggio_errore = e.getMessage();
		} finally {
			if(messaggio_errore != '') {
				gestisciException(messaggio_errore);
			}
		}
		return risposta;

	}

	//metodo override di alertMessaggi in PVAction - mostra alert per specifici messaggi
	public override void alertMessaggi(PVForm form, Case casoPV) {

		PV3824CpayCredenzialiForm myForm = (PV3824CpayCredenzialiForm) form;

		System.debug('*#* numero case : ' + CaseUtils.getCaseNumber(casoPV.Id));
		System.debug('myForm.isCheckFax: ' + myForm.isCheckFax);
		if(myForm.isCheckFax == true) {
			risposta.insMessage('info', 'Invia quanto richiesto al fax 02.721325337 riportando sui documenti il numero di richiesta CRM ' + CaseUtils.getCaseNumber(casoPV.Id) + '. ', '20000');
		}
	}


	private static List<Case> recuperaCaseInSospeso(String codCliente) {
		List<Case> openCases = [Select id, caseNumber from Case where CategoriaExternalId__c = '3824' and Cip_Cliente__c = :codCliente and Status = 'Sospeso'];
		for(Case c :openCases) {
			c.Step_PV__c = '999';
			c.Status = CaseUtils.DA_PROCESSARE;
		}
		return openCases;
	}

	public static String createCalloutsContext(PV3824CpayCredenzialiForm myForm, String messaggio_errore) {


		String userTipoBusta = PV3824CpayCredenzialiContext.userTipoBusta;
		String pinTipoBusta = PV3824CpayCredenzialiContext.pinTipoBusta;
		String azioneAnnulloBusta = PV3824CpayCredenzialiContext.azioneAnnulloBusta;
		String azioneRiemissione = PV3824CpayCredenzialiContext.azioneRiemissione;


		switch on myForm.sottotipologiaMdt.QualifiedApiName {
			when 'PV_SUB_127' {
				// Blocco credenziali
				myForm.calloutsContext.add(new PV3824CpayCredenzialiContext(azioneAnnulloBusta, 2));
			}

			when 'PV_SUB_129' {
				// Riemissione completa (User via email e PIN via posta)
				myForm.calloutsContext.add(new PV3824CpayCredenzialiContext(azioneRiemissione, 'E', userTipoBusta, myForm.cliente.email, 5));
				myForm.calloutsContext.add(new PV3824CpayCredenzialiContext(azioneRiemissione, 'P', pinTipoBusta, 5));
			}

			when 'PV_SUB_130' {
				// Riemissione completa (User e PIN via posta)
				myForm.calloutsContext.add(new PV3824CpayCredenzialiContext(azioneRiemissione, 'P', userTipoBusta, 5));
				myForm.calloutsContext.add(new PV3824CpayCredenzialiContext(azioneRiemissione, 'P', pinTipoBusta, 5));
			}

			when 'PV_SUB_131' {
				// Riemissione PIN via posta
				myForm.calloutsContext.add(new PV3824CpayCredenzialiContext(azioneRiemissione, 'P', userTipoBusta, 5));
			}

			when 'PV_SUB_132' {
				// Riemissione User via posta
				myForm.calloutsContext.add(new PV3824CpayCredenzialiContext(azioneRiemissione, 'P', userTipoBusta, 5));
			}

			when 'PV_SUB_133' {
				// Riemissione User via mail
				myForm.calloutsContext.add(new PV3824CpayCredenzialiContext(azioneRiemissione, 'E', userTipoBusta, myForm.cliente.email, 5));
			}

			when 'PV_SUB_134' {
				// Riemissione PIN via sms
				myForm.calloutsContext.add(new PV3824CpayCredenzialiContext(azioneRiemissione, 'S', pinTipoBusta, myForm.cliente.telCellulare, 5));
			}

			when 'PV_SUB_135' {
				// Riemissione completa (User via email e PIN via sms)
				myForm.calloutsContext.add(new PV3824CpayCredenzialiContext(azioneRiemissione, 'E', userTipoBusta, myForm.cliente.email, 3));
				myForm.calloutsContext.add(new PV3824CpayCredenzialiContext(azioneRiemissione, 'S', pinTipoBusta, myForm.cliente.telCellulare, 3));
			}

			when 'PV_SUB_136' {
				// Riemissione completa (User via posta e PIN via sms)
				myForm.calloutsContext.add(new PV3824CpayCredenzialiContext(azioneRiemissione, 'P', userTipoBusta, 5));
				myForm.calloutsContext.add(new PV3824CpayCredenzialiContext(azioneRiemissione, 'S', pinTipoBusta, myForm.cliente.telCellulare, 5));
			}
			when else {
				// PV_SUB_128 Azzeramento Credenziali non supportato da specifiche
				messaggio_errore = 'Sottotipologia non supportata.';
				return messaggio_errore;
			}
		}

		return '';

	}



	public static boolean maxRichiesteReached(String codCliente) {
		Datetime lastMonth = today().addMonths(-1);
		List<Case> myCases = [SELECT id FROM Case WHERE CategoriaExternalId__c = :numCategoria AND Cip_Cliente__c = :codcliente AND CreatedDate >= :lastMonth];

		// Per i test funzionali inverto i commenti in queste due righe, in modo da poter aprire più case sullo stesso utente
		return myCases.size() > 4;
		// return false;
	}


	public override Case completaCasePostVendita(Case casoPV, PVForm form) {
		PV3824CpayCredenzialiForm myForm = (PV3824CpayCredenzialiForm) form;
		casoPV = PV3824CpayCredenzialiContext.aggiornaCasoPV(casoPV, myForm.calloutsContext);
		return casoPV;
	}

	public override String recuperaNotaSpecificaPV(PVForm form, Case casoPV) {

		PV3824CpayCredenzialiForm myForm = (PV3824CpayCredenzialiForm) form;
		String notaSpecificaPV = '';

		notaSpecificaPV += PV3824CpayCredenzialiContext.buildNote(myForm.calloutsContext, isInserimento, myForm.caseDaChiudere);
		System.debug('notaSpecificaPV: ' + notaSpecificaPV);

		return notaSpecificaPV;
	}

	public override XCS_Messaggio__c preparaMessaggioOCS(PVForm form, XCS_Messaggio__c xcs_messaggio) {
		PV3824CpayCredenzialiForm myForm = (PV3824CpayCredenzialiForm) form;
		xcs_messaggio.CodCliente__c = myForm.cliente.codCliente;
		return xcs_messaggio;
	}
}