public with sharing class PV2790EstinzioneChiusuraContoGestione extends PVActionGestione {
  
    public class PV2790EstinzioneChiusuraContoGestioneForm extends PVForm {
		//@AuraEnabled public Date dataEstinzione { get; set; }
	}

    @AuraEnabled
    public static String retrieveDataEstinzione(ID caseId){
        return [SELECT F_Data_Estinzione__c FROM Case WHERE id=:caseId].F_Data_Estinzione__c.format();
    }


	/***************************/
	/*   metodi Aura enabled   */
	/***************************/

	@AuraEnabled
	public static void saveCase(PV2790EstinzioneChiusuraContoGestioneForm form, Case theCase) {
		String messaggio_errore = '';

		try{
			system.debug('form: ' + form);
			system.debug('theCase: ' + theCase);

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


	private static String creaNote(PVForm myform, Case theCase) {
		return myform.note;
	}
}