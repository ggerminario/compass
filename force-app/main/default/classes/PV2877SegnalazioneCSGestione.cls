public without sharing class PV2877SegnalazioneCSGestione extends PVActionGestione  {
    public class PV2877SegnalazioneCSGestioneForm extends PVForm {

    }

    public class ComunicazioniOCSListDTO {
		@AuraEnabled public String Tipologia {get; set;}
		@AuraEnabled public String Codice {get; set;}
	}

	@AuraEnabled
	public static void saveCase(PV2877SegnalazioneCSGestioneForm form, Case theCase){
		String messaggio_errore = '';

    try{
        system.debug(form);
        String note = creaNote(form, theCase);
        saveUtil(form, theCase, note);
    }catch(Exception e) {                    
        messaggio_errore = loggaException(e);         
            }finally{
                    if(messaggio_errore != '') { 
                gestisciException(messaggio_errore);
                    }
        }
	}

	private static String creaNote(PVForm myform, Case theCase) {
		return '';
	}
}