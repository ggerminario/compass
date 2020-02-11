/**
 * @File Name          : PV2380RintraccioBollettiniPosteItalianeIns.cls
 * @Description        : 
 * @Author             : Marco Cutolo
 * @Group              : 
 * @Last Modified By   : Cristiano
 * @Last Modified On   : 21/1/2020, 10:18:03
 * @Modification Log   : 
 * Ver       Date            Author      		    Modification
 * 1.0    20/12/2019   Marco Cutolo     Initial Version
**/

public class PV2380RintraccioBollPosteItalianeIns extends PVAction {

    public class PV2380RintraccioBollPosteItalianeInsForm extends PVForm{
        //Tutti i campi specifici del componente che stiamo implementando
        @AuraEnabled
		public String importo {get;set;}

		@AuraEnabled
		public String contoCorrente {get;set;}

		@AuraEnabled
		public String bollettino {get;set;}	

		@AuraEnabled
		public Date dataValuta {get;set;}

		@AuraEnabled
		public String provincia {get;set;}

		@AuraEnabled
		public String ufficio {get;set;}

		@AuraEnabled
		public String sportello {get;set;}

    }

    @AuraEnabled
	public static void conferma(PV2380RintraccioBollPosteItalianeInsForm datiForm){
		new PV2380RintraccioBollPosteItalianeIns().execute(datiForm);
	}

    public void execute(PVForm form){
		// TO DO EXECUTE con chiamata a VariazioneModalCalcoloRata
        PV2380RintraccioBollPosteItalianeInsForm myForm = (PV2380RintraccioBollPosteItalianeInsForm) form;
		String errorMessage = '';
		String codiceBollettino = myForm.bollettino;
		String messaggio_errore = '';
		try{
            //Common di PVAction

			if(String.isNotBlank(codiceBollettino)){
				List<Case> caseList = [SELECT ID,pv_importo_boll__c,pv_bollettino__c,pv_uffpost_boll__c,pv_datavaluta_boll__c,pv_prov_uffpost_boll__c,pv_sport_uff_boll__c,pv_cc_boll__c FROM CASE WHERE pv_bollettino__c =: codiceBollettino LIMIT 1];
				if(caseList != null && !caseList.isEmpty()){
					errorMessage = 'E\' già presente una richiesta per il codice bollettino '+caseList[0].pv_bollettino__c+'\n';
					errorMessage += 'Importo: '+caseList[0].pv_importo_boll__c +'\n';
					errorMessage += 'Conto Corrente: '+caseList[0].pv_cc_boll__c +'\n';
					errorMessage += 'Data Valuta: '+caseList[0].pv_datavaluta_boll__c +'\n';
					errorMessage += 'Provincia: '+caseList[0].pv_prov_uffpost_boll__c +'\n';
					errorMessage += 'Ufficio: '+caseList[0].pv_uffpost_boll__c +'\n';
					errorMessage += 'Sportello: '+caseList[0].pv_sport_uff_boll__c +'\n';
				}
				if(String.isNotBlank(errorMessage)){
					throw new AuraHandledException(errorMessage);
				}
			}
			commonExecute(myForm);
		}catch(Exception e) {
			messaggio_errore = errorMessage;
			//System.debug('TEST EMAIL EXCEPTION ERRORE:' + messaggio_errore);
		}finally{
			if(messaggio_errore != '') {
				gestisciException(messaggio_errore);
			}
		}
	}


    public override Case completaCasePostVendita(Case casoPV,PVForm form){
		//continuare a valorizzare l'oggetto casoPV integrando i dati di questo post vendita
		PV2380RintraccioBollPosteItalianeInsForm myForm = (PV2380RintraccioBollPosteItalianeInsForm) form;

		casoPV.pv_importo_boll__c = Decimal.valueOf(myForm.importo);
		casoPV.pv_bollettino__c = myForm.bollettino;
		casoPV.pv_datavaluta_boll__c = myForm.dataValuta;
		casoPV.pv_prov_uffpost_boll__c = myForm.provincia;
		casoPV.pv_uffpost_boll__c = myForm.ufficio;
		casoPV.pv_sport_uff_boll__c = myForm.sportello;
		casoPV.pv_cc_boll__c = myForm.contoCorrente;
		casoPV.pv_subtype__c = myForm.sottotipologiaMdt.Descrizione__c;
		//casoPV.pv_send_to__c = UserInfo.getUserId();
		casoPV.UfficioDestinazione__c = form.userData.accountOffice.Id;
		return casoPV;
	}

    public override String recuperaNotaSpecificaPV(PVForm form, Case casoPV){
		//preparazione nota
		PV2380RintraccioBollPosteItalianeInsForm myForm = (PV2380RintraccioBollPosteItalianeInsForm) form;
		String notaSpecificaPV;
		date d = myForm.dataValuta;
		notaSpecificaPV = 'Numero pratica: ' + myForm.pratica.numPratica + '\n'
						+ 'Data Valuta: ' + d.day() + '/' + d.month() + '/' + d.year() + '\n'
						+ 'Importo: ' + myForm.importo + '€ \n'
						+ 'Bollettino: VCY/VCYL ' + myForm.bollettino + '\n'
						+ 'Conto Corrente: C/C postale n.' + myForm.contoCorrente + '\n'
						+ 'Ufficio Postale: '+ myForm.provincia+'/'+ myForm.ufficio + ' Sezione: '+myForm.sportello;
						//invio email di notifica
						Account currentAccount =[SELECT BusinessEmail__c FROM Account WHERE Name LIKE '%Rintraccio Pagamenti%' Limit 1];
						list<string> indirizzirmail = new list<string>{currentAccount.BusinessEmail__c};
						Case caseObj = [SELECT CaseNumber FROM Case WHERE Id = :casoPV.Id];
						String body = ('E\' stata creata la richiesta numero '+ caseObj.caseNumber);
						sendEmail(body,casoPV,indirizzirmail);
        return notaSpecificaPV;
	}

    public override XCS_Messaggio__c preparaMessaggioOCS(PVForm form, XCS_Messaggio__c xcs_messaggio){
		//preparazione XCS_Messaggio
		PV2380RintraccioBollPosteItalianeInsForm myForm = (PV2380RintraccioBollPosteItalianeInsForm) form;
		//xcs_messaggio.CodCliente__c = myForm.cliente.codCliente;
		xcs_messaggio.NumPratica__c = myForm.pratica.numPratica;
		xcs_messaggio.TipoPratica__c = myForm.pratica.tipoPratica;
		return xcs_messaggio;
	}
	@AuraEnabled
	public static list<CCP_Postali__mdt> querycc(){
		//string descrizioneCC = '';
		system.debug('a');
		list<CCP_Postali__mdt> lista = [SELECT Descrizione__c, C_C__c FROM CCP_Postali__mdt];
		system.debug('lista cc'+ lista);
		/*for(CCP_Postali__mdt c : lista){
		descrizioneCC += c.Descrizione__c+',';
		}
		system.debug(descrizioneCC);
		*/
		return lista;

	}

	/*
	@AuraEnabled
	public static String checkRichiesteBollettino(String codiceBollettino){
		String errorMessage = '';
		if(String.isNotBlank(codiceBollettino)){
			List<Case> caseList = [SELECT ID,pv_importo_boll__c,pv_bollettino__c,pv_uffpost_boll__c,pv_datavaluta_boll__c,pv_prov_uffpost_boll__c,pv_sport_uff_boll__c,pv_cc_boll__c FROM CASE WHERE pv_bollettino__c =: codiceBollettino LIMIT 1];
			if(caseList != null && !caseList.isEmpty()){
				errorMessage = 'E\' già presente una richiesta per il codice bollettino '+caseList[0].pv_bollettino__c+'\n';
				errorMessage += 'Importo: '+caseList[0].pv_importo_boll__c +'\n';
				errorMessage += 'Conto Corrente: '+caseList[0].pv_cc_boll__c +'\n';
				errorMessage += 'Data Valuta: '+caseList[0].pv_datavaluta_boll__c +'\n';
				errorMessage += 'Provincia: '+caseList[0].pv_prov_uffpost_boll__c +'\n';
				errorMessage += 'Ufficio: '+caseList[0].pv_uffpost_boll__c +'\n';
				errorMessage += 'Sportello: '+caseList[0].pv_sport_uff_boll__c +'\n';
			}
		}
		return errorMessage;
	}
	*/

	private static void sendEmail(String emailBody, Case theCase, List<String> indirizzi){
		List<String> indirizziDaInviare = new List<String>();
		indirizziDaInviare.addAll(indirizzi);
		List<Messaging.SingleEmailMessage> emailToSend = new List<Messaging.SingleEmailMessage>();
		Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
		mail.setToAddresses(indirizziDaInviare);
		mail.setSubject(theCase.Subject);
		mail.setHtmlBody(emailBody);
		emailToSend.add(mail);
		system.debug('Email to send: ' + emailToSend);      
		String mockName = 'Email - Ufficio Sistemi';
		EmailUtils.sendEmail(emailToSend,mockName);
	}
}