/**
 * @File Name          : PV2794EstinzioneChiusuraContoGestione.cls
 * @Description        : 
 * @Author             : GdL Exprivia
 * @Group              : 
 * @Last Modified By   : GdL Exprivia
 * @Last Modified On   : 6/2/2020, 15:52:22
 * @Modification Log   : 
 * Ver       Date            Author      		    Modification
 * 1.0    6/2/2020   GdL Exprivia     Initial Version
**/

public with sharing class PV2794EstinzioneChiusuraContoGestione extends PVActionGestione {

	public class PV2794EstinzioneChiusuraContoGestioneForm extends PVForm {
		@AuraEnabled public String dataOperazione { get; set; }
		@AuraEnabled public Date dataEstinzione { get; set; }
		@AuraEnabled public String saldo { get; set; }
	}


	/***************************/
	/*   metodi Aura enabled   */
	/***************************/

	@AuraEnabled
	public static void saveCase(PV2794EstinzioneChiusuraContoGestioneForm form, Case theCase) {
		String messaggio_errore = '';
		System.debug('Form: ' + form);

		try{
			system.debug('form: ' + form);
			system.debug('theCase: ' + theCase);

			// Aggiornamento data estinzione
			form.dataEstinzione = PV2790_2794ImportoDataOperazioneForm.add29days(form.dataOperazione);
			theCase.F_Data_Estinzione__c = form.dataEstinzione;

			// Recupero il saldo
			form.saldo = CSEInterrogazioneSaldoLightInvoker.invoke(theCase.NumeroPratica__c).cseInterrogazioneSaldoLightResponse.saldo;

			// Recupera tel cellulare
			String phone = [SELECT SuppliedPhone FROM Case WHERE ID = :theCase.id].suppliedPhone;

			if(phone != null && phone != '') {
				String testoSMS = 'Gentile cliente la sua richiesta di estinzione e chiusura conto CPAY è stata presa in carico.';
				OCSInviaSMSInvoker.inviaSMS('', phone, testoSMS, theCase.Account.getCodice_Cliente__c);
			}

			String note = creaNote(form, theCase);
			saveUtil(form, theCase, note);
		} catch(Exception e) {
			messaggio_errore = loggaException(e);
		}finally {
			if(messaggio_errore != '') {
				gestisciException(messaggio_errore);
			}
		}
	}


	private static String creaNote(PV2794EstinzioneChiusuraContoGestioneForm myform, Case theCase) {
		String notaSpecificaPV ='';
		notaSpecificaPV += 'Importo: ' + myForm.saldo + '<br>';
		notaspecificaPV += 'Data operazione: ' + myForm.dataOperazione + '<br>';
		return notaspecificaPV + myform.note;
	}
}