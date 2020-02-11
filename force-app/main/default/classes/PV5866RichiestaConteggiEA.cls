/**
 * @File Name          : PV5866RichiestaConteggiEA.cls
 * @Description        :
 * @Author             : Federica Forte
 * @Group              :
 * @Last Modified By   : Federica Forte
 * @Last Modified On   : 20/1/2020, 10:54:30
 * @Modification Log   :
 * Ver       Date            Author                  Modification
 * 1.0    23/12/2019   Federica Forte     Initial Version
 **/
public with sharing class PV5866RichiestaConteggiEA extends PVAction {

	public static final String categoria = '5866';

	public class PV5866RichiestaConteggiEAForm extends PVForm {
		@AuraEnabled public Date dataRicCont { get; set; }
		@AuraEnabled public List<String> modRicCont { get; set; }
		@AuraEnabled public String offProm { get; set; }
		@AuraEnabled public String notificaFil { get; set; }
	}

	@AuraEnabled
	public static PVResponse conferma(PV5866RichiestaConteggiEAForm datiForm) {
		System.debug('datiForm: ' + datiForm);
		PVResponse resp = new PV5866RichiestaConteggiEA().execute(datiForm);
        return resp;
	}

	public PVResponse execute(PVForm form) {
		PV5866RichiestaConteggiEAForm myForm = (PV5866RichiestaConteggiEAForm) form;
		String messaggio_errore = '';
		try{
            if(myForm.pratica.codStatoPratica == '05' || myForm.pratica.codStatoPratica == '10' ||
                    myForm.pratica.codStatoPratica == '15' || myForm.pratica.codStatoPratica == '20' ||
                    myForm.pratica.codStatoPratica == '30' || myForm.pratica.codStatoPratica == '50') {
                messaggio_errore = 'Attenzione: la pratica per la quale si vuole richiedere conteggio di e/a non è stata perfezionata.';
            } else if(myForm.pratica.codStatoPratica == '40' || myForm.pratica.codStatoPratica == '55') {
                messaggio_errore = 'Attenzione: la pratica per la quale si vuole richiedere conteggio di e/a risulta respinta/annullata.';
            } else if(myForm.pratica.codStatoPratica == '80') {
                messaggio_errore = 'Attenzione: la pratica per la quale si vuole richiedere conteggio di e/a risulta già chiusa';
            } else if(!haveRichieste(form)) {
				messaggio_errore = 'Attenzione: esiste già una richiesta aperta per la pratica selezionata';
			} else {
                commonExecute(myForm);
            }
		} catch(Exception e) {
		    messaggio_errore = loggaException(e);
		}finally {
		    if(messaggio_errore != '') {
		        gestisciException(messaggio_errore);
		    }
		}
        return risposta;
	}

	@AuraEnabled
    public static List<Case> retrieveRichieste(String numPratica){
        return [SELECT numeropratica__c FROM Case WHERE categoriaexternalid__c =:categoria AND numeropratica__c=:numPratica];
    }

	public static Boolean haveRichieste(PVForm form){
		if (retrieveRichieste(form.pratica.numPratica).isEmpty()) {
			return true;
		} else {
			return false;
		}
	}

	public override Case completaCasePostVendita(Case casoPV, PVForm form) {
		PV5866RichiestaConteggiEAForm myForm = (PV5866RichiestaConteggiEAForm) form;
		casoPV.pv_data_poste__c = myForm.dataRicCont;
		casoPV.pv_send_to__c = myForm.notificaFil;

		System.debug('dataRicCont' + casoPV.pv_data_poste__c);
		System.debug('notificaFil' + casoPV.pv_send_to__c);

		return casoPV;
	}

    //metodo override di alertMessaggi in PVAction - mostra alert per specifici messaggi
    public override void alertMessaggi(PVForm form, Case casoPV){

        PV5866RichiestaConteggiEAForm myForm = (PV5866RichiestaConteggiEAForm) form;

        System.debug('*#* numero case : '+CaseUtils.getCaseNumber(casoPV.Id));
        if(myForm.isCheckFax == true){
			risposta.insMessage('info', 'Vi ricordiamo che, ai sensi dell Art. 58 del DPR 895/50, abbiamo 10 giorni di tempo per evadere la richiesta di conteggio di e/a.', '20000');
            risposta.insMessage('info', 'Invia quanto richiesto al fax 02.48244795 riportando sui documenti il numero di richiesta CRM ' + CaseUtils.getCaseNumber(casoPV.Id) + '. ','20000');
        }
    }

	public override String recuperaNotaSpecificaPV(PVForm form, Case casoPV) {
		//preparazione nota
		PV5866RichiestaConteggiEAForm myForm = (PV5866RichiestaConteggiEAForm) form;

		String notaSpecificaPV = ' ';
		notaSpecificaPV = 'Pratica: ' + myForm.pratica.tipoPratica + ' - ' + myForm.pratica.numPratica + '<br>';
		notaSpecificaPV += 'Data richiesta conteggio: ' + myForm.dataRicCont.format() + '<br>';
        Boolean first = true;
        for(String s : myForm.modRicCont){
            if(first){
                notaSpecificaPV += 'Modalita ricezione conteggio: ' + s;
                first=false;
            } else{
                notaSpecificaPV += ', ' + s;
            }
        }
        notaSpecificaPV +='<br>';

		String notificaFilValue = '';
		if (myForm.notificaFil == 'Filiale') {
			notificaFilValue = 'Si';
		} else {
			notificaFilValue = 'No';
		}
		notaSpecificaPV += 'Filiale vuole notifica in filiale alla chiusura richiesta: ' + notificaFilValue + '<br>';
        notaSpecificaPV += 'Cliente ha richiesto depennamento dalle offerte promozionali: ' + myForm.offProm + '<br>';
        
        return notaSpecificaPV;

	}

	public override XCS_Messaggio__c preparaMessaggioOCS(PVForm form, XCS_Messaggio__c xcs_messaggio) {
		PV5866RichiestaConteggiEAForm myForm = (PV5866RichiestaConteggiEAForm) form;
		xcs_messaggio.CodCliente__c = myForm.pratica.codCliente;
		return xcs_messaggio;
	}
}