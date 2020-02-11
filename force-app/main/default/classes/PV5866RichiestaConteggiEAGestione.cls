/**
 * @File Name          : PV5866RichiestaConteggiEAGestione.cls
 * @Description        :
 * @Author             : Federica Forte
 * @Group              :
 * @Last Modified By   : Raffaele Prudenzano
 * @Last Modified On   : 24/1/2020, 12:56:09
 * @Modification Log   :
 * Ver       Date            Author                  Modification
 * 1.0    14/1/2020   Federica Forte     Initial Version
 **/
public with sharing class PV5866RichiestaConteggiEAGestione extends PVActionGestione {

	public class PV5866RichiestaConteggiEAGestioneForm extends PVForm {
		@AuraEnabled public Boolean rinvia { get; set; }
	}

	@AuraEnabled
	public static Date retrieveDataRicCont(ID caseId) {
		return [SELECT pv_data_poste__c FROM Case WHERE id = :caseId].pv_data_poste__c;
	}

	public static String retrieveNotificaFil(ID caseId) {
		return [SELECT pv_send_to__c FROM Case WHERE id = :caseId].pv_send_to__c;
	}

	@AuraEnabled
	public static void saveCase(PV5866RichiestaConteggiEAGestioneForm form, Case theCase) {
		String messaggio_errore = '';

		try{
			system.debug('form: ' + form);
			system.debug('theCase: ' + theCase);
			theCase.param_step__c = '';
			theCase.esito__c = '';

			if(form.newStatus == 'Closed' && form.rinvia == true && form.userData.user.UserRole.DeveloperName == 'GOPA') {
				theCase.param_step__c = 'UFF_INSERIMENTO';
			}

			if(form.newStatus == 'Closed' && theCase.pv_send_to__c == 'Filiale' && form.userData.user.UserRole.DeveloperName == 'GOPA') {
				theCase.param_step__c = 'UFF_INSERIMENTO';
				theCase.esito__c = 'OK';
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

	@AuraEnabled
	public static void saveData(Case theCase, Date dataCase) {
		String messaggio_errore = '';

		try{
			system.debug('saveData @theCase: ' + theCase);
			system.debug('saveData @dataCase: ' + dataCase);

			theCase.pv_data_poste__c = dataCase;
			String note = 'Variazione data richiesta: ' + dataCase.format();
			
			quickUpdateCase(theCase, note);
		} catch(Exception e) {
			messaggio_errore = loggaException(e);
		}finally {
			if(messaggio_errore != '') {
				gestisciException(messaggio_errore);
			}
		}
	}

	@AuraEnabled
	public static void saveMotivo(Case theCase, String descMotivoCase) {
		String messaggio_errore = '';

		try{
			System.debug('saveMotivo @theCase: ' + theCase);
			System.debug('saveMotivo @descMotivoCase: ' + descMotivoCase);

			theCase.descrizioneMotivo__c = descMotivoCase;
			String note = 'Risposta GOPA per filiale: \n' + descMotivoCase;

			quickUpdateCase(theCase, note);
		} catch(Exception e) {
			messaggio_errore = loggaException(e);
		}finally {
			if(messaggio_errore != '') {
				gestisciException(messaggio_errore);
			}
		}
	}


	/**
	 * @description Metodo che salva velocemente il case. NON cambia lo stato del case. Posta nel chatter le note personalizzate che gli vengono passate.
	 * @author Raffaele Prudenzano | 24/1/2020
	 * @param theCase
	 * @param nota
	 * @return void
	 **/
	private static void quickUpdateCase(Case theCase, String note) {
		if(theCase.Id != null) {
			system.debug('quickUpdateCase @theCase : ' + theCase.Id);
			system.debug('quickUpdateCase @note : ' + note);
			postANotePV(theCase.Id, 'Nota PostVendita', note);

			upsert theCase;
		}
	}

	private static String creaNote(PVForm myform, Case theCase) {
		return myform.note;
	}

	/*
	 private static String creaNote(PV3824CpayCredenzialiGestioneForm form, Case theCase) {
	 return form.note == null ? '' : form.note;
	 }
	 */

}