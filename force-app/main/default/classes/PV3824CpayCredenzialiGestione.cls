/**
 * @File Name          : PV3824CpayCredenzialiGestione.cls
 * @Description        :
 * @Author             : Raffaele Prudenzano
 * @Group              :
 * @Last Modified By   : Raffaele Prudenzano
 * @Last Modified On   : 10/1/2020, 10:27:23
 * @Modification Log   :
 * Ver       Date            Author                  Modification
 * 1.0    8/1/2020   Raffaele Prudenzano     Initial Version
 **/
public with sharing class PV3824CpayCredenzialiGestione extends PVActionGestione {
	public static final String STEP_GESTIONE_UFF_INSERIMENTO = '5';

	public class PV3824CpayCredenzialiGestioneForm extends PVForm {
		@AuraEnabled
		public Boolean rinvia { get; set; }
	}

	@AuraEnabled
	public static void saveCase(PV3824CpayCredenzialiGestioneForm form, Case theCase) {
		String messaggio_errore = '';
		system.debug('theCase : ' + theCase);
		// modifico il case
		// se voglio forzare lo stato devo modificare form.newStatus
		system.debug('form' + form);

		if(theCase.Step_PV__c == STEP_GESTIONE_UFF_INSERIMENTO && form.newStatus == 'Closed') {
			// Se siamo nella gestione di UFF_INSERIMENTO e questo gestisce, incremento maxT di 1 in modo che il batch faccia un altro tentativo

			theCase = PV3824CpayCredenzialiContext.increaseMaxTForKOCallouts(theCase);
			theCase.param_step__c = 'SYS';
			theCase.Step_PV__c = '1';

		} else if(form.newStatus == 'Closed' && form.rinvia == true) {
			theCase.pv_send_to__c = 'UFF_INSERIMENTO';
		}

		try{
			saveUtil(form, theCase, creaNote(form, theCase));
		} catch(Exception e) {
			messaggio_errore = e.getMessage(); } finally {
			if(messaggio_errore != '') {
				gestisciException(messaggio_errore); } }
	}

	private static String creaNote(PV3824CpayCredenzialiGestioneForm form, Case theCase) {
		return form.note == null ? '' : form.note;
	}
}