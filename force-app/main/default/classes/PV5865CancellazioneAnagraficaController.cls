/**
 * @File Name          : PV5865CancellazioneAnagraficaController.cls
 * @Description        : 
 * @Author             : Adriana Lattanzi
 * @Group              : 
 * @Last Modified By   : Adriana Lattanzi
 * @Last Modified On   : 21/1/2020, 14:39:09
 * @Modification Log   : 
 * Ver       Date            Author      		    Modification
 * 1.0    10/1/2020   Adriana Lattanzi     Initial Version
**/
public with sharing class PV5865CancellazioneAnagraficaController extends PVAction {

    public class PV5865CancellazioneAnagraficaForm extends PVForm {
        @AuraEnabled public String noteAggiornamentoCA { get; set; }

        @AuraEnabled public String codiceCliente {get; set;}
        @AuraEnabled public String esito {get; set;}
        @AuraEnabled public String errore {get; set;}
    }


    @AuraEnabled
    public static OCSCancellazioneAnagraficaInvoker.Response cancellaAnagrafica(String cliente, String esecuzione){
        OCSCancellazioneAnagraficaInvoker.CancellazioneAnagraficaRequestDTO req = new OCSCancellazioneAnagraficaInvoker.CancellazioneAnagraficaRequestDTO();
		req.codCliente = cliente;
        req.tipoEsecuzione = esecuzione;
		OCSCancellazioneAnagraficaInvoker.Response response = OCSCancellazioneAnagraficaInvoker.invoke(req);
        return response;
    }

    

    /*----------------------------------------------------------
	 			METODI COMUNI A TUTTI I CONTROLLER PV
	 ------------------------------------------------------------*/


	@AuraEnabled
	public static PVResponse conferma(PV5865CancellazioneAnagraficaForm datiForm) {
		System.debug('PV5865CancellazioneAnagraficaForm :   ' + datiForm);
		PVResponse resp = new PV5865CancellazioneAnagraficaController().execute(datiForm);
		return resp;
	}


	public PVResponse execute(PVForm form) {
		String messaggio_errore = '';
		try{
			PV5865CancellazioneAnagraficaForm myForm = (PV5865CancellazioneAnagraficaForm) form;

			// System.debug('-----------------CHIAMATA CANCELLAZIONE ANAGRAFICA - INIZIO - Cliente: ' + myForm.codiceCliente);
			
			OCSCancellazioneAnagraficaInvoker.Response resp = PV5865CancellazioneAnagraficaController.cancellaAnagrafica(myForm.codiceCliente, 'C');
			
			myForm.esito = resp.cancellazioneAnagraficaResponse.as400Status;
			myForm.errore = resp.cancellazioneAnagraficaResponse.as400Errore;

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

	public override Case completaCasePostVendita(Case casoPV, PVForm form) {
		PV5865CancellazioneAnagraficaForm myForm = (PV5865CancellazioneAnagraficaForm) form;

        casoPV.Esito__c = myForm.esito;
		casoPV.PV_Info_Variazione_Anagrafica__c = form.cliente.tipoAnagrafica;

		return casoPV;
	}

	public override String recuperaNotaSpecificaPV(PVForm form, Case casoPV) {
		//preparazione nota
		PV5865CancellazioneAnagraficaForm myForm = (PV5865CancellazioneAnagraficaForm) form;

		//Note specifiche PV
		String notaSpecificaPV = '';
		notaSpecificaPV += 'Esito: ' + myForm.esito + '<br>';
		if(myForm.esito == 'KO'){
			notaSpecificaPV += 'Motivazione: ' + myForm.errore + '<br>';
		}
		return notaSpecificaPV;

	}

	public override XCS_Messaggio__c preparaMessaggioOCS(PVForm form, XCS_Messaggio__c xcs_messaggio) {
		PV5865CancellazioneAnagraficaForm myForm = (PV5865CancellazioneAnagraficaForm) form;
		//xcs_messaggio.CodCliente__c = myForm.pratica.codCliente;
		return xcs_messaggio;
	}

}