public class PV2786CpayStorni extends PVAction{

    public class PV2786CpayStorniForm extends PVForm{
        //Tutti i campi specifici del componente che stiamo implementando
        @AuraEnabled
		public String importo {get;set;}

		@AuraEnabled
		public Date dataOperazione {get;set;}

    }

    @AuraEnabled
	public static void conferma(PV2786CpayStorniForm datiForm){
		new PV2786CpayStorni().execute(datiForm);
	}

    public void execute(PVForm form){
		// TO DO EXECUTE con chiamata a VariazioneModalCalcoloRata
        PV2786CpayStorniForm myForm = (PV2786CpayStorniForm) form;
		String errorMessage = '';
		String messaggio_errore = '';
		try{
            //Common di PVAction
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
		PV2786CpayStorniForm myForm = (PV2786CpayStorniForm) form;

		casoPV.pv_subtype__c = myForm.sottotipologiaMdt.Descrizione__c;
		//casoPV.pv_send_to__c = UserInfo.getUserId();
		casoPV.UfficioDestinazione__c = form.userData.accountOffice.Id;
		return casoPV;
	}

    public override String recuperaNotaSpecificaPV(PVForm form, Case casoPV){
		//preparazione nota
		PV2786CpayStorniForm myForm = (PV2786CpayStorniForm) form;
		String notaSpecificaPV;
        String dataString = '';
		date d = myForm.dataOperazione;

		notaSpecificaPV = 'Numero pratica: ' + myForm.pratica.numPratica + '\n'
                        + 'Codice cliente: ' + myForm.cliente.codCliente + '\n'
                        + 'Nome cliente: ' + myForm.cliente.nome + '\n';
        if(d!=null){
            notaSpecificaPV += 'Data: ' + d.day() + '/' + d.month() + '/' + d.year() + '\n';
        }     
        if(myForm.importo!=null)                   {
            notaSpecificaPV += 'Importo: ' + myForm.importo + '€ \n';
        }
        return notaSpecificaPV;
	}

    public override XCS_Messaggio__c preparaMessaggioOCS(PVForm form, XCS_Messaggio__c xcs_messaggio){
		//preparazione XCS_Messaggio
		PV2786CpayStorniForm myForm = (PV2786CpayStorniForm) form;
		//xcs_messaggio.CodCliente__c = myForm.cliente.codCliente;
		xcs_messaggio.NumPratica__c = myForm.pratica.numPratica;
		xcs_messaggio.TipoPratica__c = myForm.pratica.tipoPratica;
		return xcs_messaggio;
	}
}