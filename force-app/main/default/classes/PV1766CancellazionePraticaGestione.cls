/**
 * @File Name          : PV1766CancellazionePraticaGestione.cls
 * @Description        : 
 * @Author             : sabrina vitali
 * @Group              : 
 * @Last Modified By   : sabrina vitali
 * @Last Modified On   : 6/12/2019, 12:01:20
 * @Modification Log   : 
 * Ver       Date            Author      		    Modification
 * 1.0    25/9/2019   sabrina vitali     Initial Version
**/
public class PV1766CancellazionePraticaGestione extends PVActionGestione {

	public class PV1766CancellazionePraticaGestioneForm extends PVForm {
       	@AuraEnabled
        public String esito{get;set;}
		@AuraEnabled
		public String msgCancellazione{get;set;}
	}


	@AuraEnabled
	public static void saveCase(PV1766CancellazionePraticaGestioneForm form, Case theCase){
		String messaggio_errore = '';
		//Boolean inserisciRegistro = false;
		try{
			system.debug('theCase : ' + theCase);	//verificare quando scaarto da batch per filiale
			// modifico il case
			// se voglio forzare lo stato devo modificare form.newStatus
			String note = creaNote(form, theCase);
			System.debug('********** Branch_Or_Office__c : ' + form.userData.user.Branch_Or_Office__c + ' - esito : ' + form.esito + ' - stato : ' + form.newStatus);

			//Gestione DCRAV : esito KO --> chiusura
			//Gestione DCRAV : esito OK --> torna sospeso ad ufficio inserimento in step 998 per richiesta cancellazione
			//Gestione BACK step 2 --> torna sospeso ad ufficio inserimento in step 998 per richiesta cancellazione
			//Gestione BACK step 4 --> sospeso in step 998 per nuova richiesta cancellazione, coda invariata
			//Gestione FIL step 4 --> sospeso in step 998 per nuova richiesta cancellazione, coda invariata
			//Gestione RLCM step 4 --> chiusura

			//aggiungere gestione filiale se si tratta di un ritorno da batch
			//manca gestito da filiale con esito OCS KO
			/*if(form.newStatus.equalsIgnoreCase(CaseUtils.CHIUSO) && (form.userData.user.Branch_Or_Office__c.equalsIgnoreCase('BACK')
				|| (form.userData.user.Branch_Or_Office__c.equalsIgnoreCase('DCRAV') && form.esito.equalsIgnoreCase('OK')))){
			}*/
			
			if(String.isNotBlank(form.esito)){
				theCase.pv_ctr_no_sign__c = form.esito;		
			}

			//System.debug('*** form.newStatus : ' + form.newStatus);	//	form.newStatus : Annullato
			if(form.newStatus.equalsIgnoreCase('Annullato')){
				theCase.Step_PV__c = '999';
				//tento di annullare la pratica dal registro di cancellazione se non è già stata elaborata da OCS
				System.debug('@@@@@@	pv_esito_sbf__c : ' + theCase.pv_esito_sbf__c + ' - pv_esito_poste__c: ' + theCase.pv_esito_poste__c);	
				if(String.isBlank(theCase.pv_esito_sbf__c) && String.isNotBlank(theCase.pv_esito_poste__c))
				{	
					System.debug('@@@@@@	cancello dal registro: ');
					OCSAnnullaCancellazionePraticaInvoker.Response data;
					try {
						data = OCSAnnullaCancellazionePraticaInvoker.invoke(theCase.Tipo_Pratica__c,theCase.NumeroPratica__c,'');
					} catch (exception e) {
						messaggio_errore = e.getMessage();
					}
					System.debug('@@ data: ' + data);
					System.debug('@@ messaggio_errore: ' + messaggio_errore);
					if(data.annullaCancellazionePraticaResponse.esito.equalsIgnoreCase('KO')){
						//messaggio_errore = 'Pratica già elaborata da OCS';	
						form.msgCancellazione =  'Pratica già elaborata da OCS';
					}
				}else if(String.isNotBlank(theCase.pv_esito_sbf__c) /*&& theCase.pv_esito_sbf__c.equalsIgnoreCase('S')*/){
					//la pratica è già stata elaborata, come cancellata o no
					form.msgCancellazione =  'Pratica già elaborata da OCS';
				}	
				System.debug('@@@@@@	form.msgCancellazione : ' + form.msgCancellazione);
			}
			//saveUtil(form, theCase, note);

		}catch(Exception e) {                    
			messaggio_errore = loggaException(e);          
		}finally{                       
			if(messaggio_errore != '') {                                                    
				gestisciException(messaggio_errore);                    
			}
		}
	}

	/* metodi NON aura enabled */

	private static String creaNote(PV1766CancellazionePraticaGestioneForm myform, Case theCase) {
		String nota = '';
		if(String.isNotBlank(myform.esito)){
			nota += 'Esito: ' + myform.esito + '\n';
		}
		if(String.isNotBlank(myform.note)){
			nota += 'Note: ' + myform.note;
		}
		if(String.isNotBlank(myform.msgCancellazione)){
			nota += '\n\n' + myform.msgCancellazione;
		}
		
		return nota; 
	}


}