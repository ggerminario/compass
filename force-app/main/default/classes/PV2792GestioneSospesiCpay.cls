/**
 * @File Name          : PV2792GestioneSospesiCpay.cls
 * @Description        :
 * @Author             : Raffaele Prudenzano
 * @Group              :
 * @Last Modified By   : Raffaele Prudenzano
 * @Last Modified On   : 17/1/2020, 12:33:16
 * @Modification Log   :
 * Ver       Date            Author                  Modification
 * 1.0    16/1/2020   Raffaele Prudenzano     Initial Version
 **/
public with sharing class PV2792GestioneSospesiCpay extends PVAction {
	public static final String SOTTOTIPOLOGIA_ALTRO_APINAME = 'PV_SUB_71';

	public class PV2792GestioneSospesiCpayForm extends PVForm {
		@AuraEnabled public String data { get; set; }
		@AuraEnabled public String importo { get; set; }
		@AuraEnabled public String sottotipologiaManuale { get; set; }
	}

	@AuraEnabled
	public static void conferma(PV2792GestioneSospesiCpayForm datiForm) {
		new PV2792GestioneSospesiCpay().execute(datiForm);
	}

	public void execute(PVForm form) {
		PV2792GestioneSospesiCpayForm myForm = (PV2792GestioneSospesiCpayForm) form;
		String messaggio_errore = '';
		try{
			commonExecute(myForm);
		} catch(Exception e) {
			messaggio_errore = loggaException(e);
		}finally {
			if(messaggio_errore != '') {
				gestisciException(messaggio_errore);
			}
		}
	}

	public override Case completaCasePostVendita(Case casoPV, PVForm form) {
		return casoPV;
	}

	public override String recuperaNotaSpecificaPV(PVForm form, Case casoPV) {
		//preparazione nota
		PV2792GestioneSospesiCpayForm myForm = (PV2792GestioneSospesiCpayForm) form;

		// Selezionando Altro dovrà apparire un campo testo per inserire la descrizione della reale sottotipologia
		// sempre facoltativo. In mancanza la sottotipologia sarà semplicemente Altro
		if(myForm.sottotipologiaMdt.QualifiedApiName == SOTTOTIPOLOGIA_ALTRO_APINAME) {
			if(myForm.sottotipologiaManuale != null && myForm.sottotipologiaManuale.trim() != '') {
				myForm.sottotipologiaMdt.Descrizione__c = myForm.sottotipologiaManuale;
			}
		}

		String notaSpecificaPV = '';

		// Scrivo il numero pratica
		if(myForm.pratica == null) {
			notaSpecificaPV = 'Numero pratica: - ' + '<br>';
		} else {
			notaSpecificaPV = 'Numero pratica: ' + myForm.pratica.tipoPratica + ' - ' + myForm.pratica.numPratica + '<br>';
		}

		// Scrivo la data
		if(myForm.data == null) {
			notaSpecificaPV += 'Data: //' + '<br>';
		} else {
			notaSpecificaPV += 'Data: ' + myForm.data + '<br>';
		}

		// Scrivo l importo
		if(myForm.importo == null || myForm.importo == '') {
			notaSpecificaPV += 'Importo: ' + '<br>';
		} else {
			notaSpecificaPV += 'Importo: ' + myForm.importo + '<br>';
		}

		return notaSpecificaPV;

	}

	public override XCS_Messaggio__c preparaMessaggioOCS(PVForm form, XCS_Messaggio__c xcs_messaggio) {
		PV2792GestioneSospesiCpayForm myForm = (PV2792GestioneSospesiCpayForm) form;
		xcs_messaggio.CodCliente__c = myForm.cliente.codCliente;
		if(myForm.pratica != null) {
			xcs_messaggio.NumPratica__c = myForm.pratica.numPratica;
		}
		return xcs_messaggio;
	}
}