/**
 * @File Name          : PV5865CancellazioneAnagraficaGesCtrl.cls
 * @Description        : 
 * @Author             : Adriana Lattanzi
 * @Group              : 
 * @Last Modified By   : Adriana Lattanzi
 * @Last Modified On   : 21/1/2020, 14:38:56
 * @Modification Log   : 
 * Ver       Date            Author      		    Modification
 * 1.0    15/1/2020   Adriana Lattanzi     Initial Version
**/
public with sharing class PV5865CancellazioneAnagraficaGesCtrl extends PVActionGestione{

	public class PV5865CancellazioneAnagraficaGestioneForm extends PVForm {
		@AuraEnabled
		public Boolean rinvia { get; set; }
		@AuraEnabled public String esito {get; set;}
        @AuraEnabled public String errore {get; set;}
	}


    // ##########################
    //      METODI DA PARENT
    // ##########################

    @AuraEnabled
	public static void saveCase(PV5865CancellazioneAnagraficaGestioneForm form, Case theCase){
		String messaggio_errore = '';

		try{
			system.debug('form: ' + form);
            system.debug('theCase: ' + theCase);

            if (form.rinvia == true){
                theCase.pv_send_to__c = 'UFF_INSERIMENTO';
				theCase.Esito__c = '';
            }
			else if (form.newStatus == 'Closed'){
				OCSCancellazioneAnagraficaInvoker.Response resp = PV5865CancellazioneAnagraficaController.cancellaAnagrafica(theCase.Codice_Cliente__c, 'C');
				
				// OCSCancellazioneAnagraficaInvoker.Response resp = PV5865CancellazioneAnagraficaController.cancellaAnagrafica(theCase.Codice_Cliente__c, 'V');
				theCase.Esito__c = resp.cancellazioneAnagraficaResponse.as400Status;
				form.errore = resp.cancellazioneAnagraficaResponse.as400Errore;
				form.esito = resp.cancellazioneAnagraficaResponse.as400Status;
			}

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


	private static String creaNote(PV5865CancellazioneAnagraficaGestioneForm myform, Case theCase) {
		String notaSpecifica = 'Note: ' + myform.note;
		notaSpecifica += '<br>Esito: ' + theCase.Esito__c;
		if(theCase.Esito__c == 'KO'){
			notaSpecifica += '<br>Motivazione: ' + myform.errore;
		}
		return notaSpecifica;
	}



	@AuraEnabled
    public static OCSCancellazioneAnagraficaInvoker.Response cancellaAnagrafica(String cliente, String esecuzione){
        OCSCancellazioneAnagraficaInvoker.CancellazioneAnagraficaRequestDTO req = new OCSCancellazioneAnagraficaInvoker.CancellazioneAnagraficaRequestDTO();
		req.codCliente = cliente;
        req.tipoEsecuzione = esecuzione;
		OCSCancellazioneAnagraficaInvoker.Response response = OCSCancellazioneAnagraficaInvoker.invoke(req);
        return response;
    }

}