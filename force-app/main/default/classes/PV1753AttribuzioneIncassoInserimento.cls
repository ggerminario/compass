public class PV1753AttribuzioneIncassoInserimento extends PVAction{

    public class PV1753AttribuzioneIncassoInserimentoForm extends PVForm{
        //Tutti i campi specifici del componente che stiamo implementando
        @AuraEnabled
		public String importoIncasso {get;set;}

		@AuraEnabled
		public Date dataIncasso {get;set;}

    }

    @AuraEnabled
	public static void conferma(PV1753AttribuzioneIncassoInserimentoForm datiForm){
		new PV1753AttribuzioneIncassoInserimento().execute(datiForm);
	}

    public void execute(PVForm form){
		// TO DO EXECUTE con chiamata a VariazioneModalCalcoloRata
        PV1753AttribuzioneIncassoInserimentoForm myForm = (PV1753AttribuzioneIncassoInserimentoForm) form;
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
		PV1753AttribuzioneIncassoInserimentoForm myForm = (PV1753AttribuzioneIncassoInserimentoForm) form;

		casoPV.pv_subtype__c = myForm.sottotipologiaMdt.Descrizione__c;
		//casoPV.pv_send_to__c = UserInfo.getUserId();
		casoPV.UfficioDestinazione__c = form.userData.accountOffice.Id;
		return casoPV;
	}

    public override String recuperaNotaSpecificaPV(PVForm form, Case casoPV){
		//preparazione nota
		PV1753AttribuzioneIncassoInserimentoForm myForm = (PV1753AttribuzioneIncassoInserimentoForm) form;
		String notaSpecificaPV;
		date d = myForm.dataIncasso;
		notaSpecificaPV = 'Filiale di: ' + myForm.pratica.filiale + '\n'
						+ 'Stato: ' + myForm.pratica.desStatoPratica + '\n'
                        + 'Numero pratica: ' + myForm.pratica.numPratica + '\n'
                        + 'Codice cliente: ' + myForm.cliente.codCliente + '\n'
                        + 'Nome cliente: ' + myForm.cliente.nome + '\n'
                        + 'Data incasso: ' + d.day() + '/' + d.month() + '/' + d.year() + '\n'
						+ 'Importo: ' + myForm.importoIncasso + '€ \n'
						+ 'Stato pratica: '+ myForm.pratica.statoPratica;
        return notaSpecificaPV;
	}

    public override XCS_Messaggio__c preparaMessaggioOCS(PVForm form, XCS_Messaggio__c xcs_messaggio){
		//preparazione XCS_Messaggio
		PV1753AttribuzioneIncassoInserimentoForm myForm = (PV1753AttribuzioneIncassoInserimentoForm) form;
		//xcs_messaggio.CodCliente__c = myForm.cliente.codCliente;
		xcs_messaggio.NumPratica__c = myForm.pratica.numPratica;
		xcs_messaggio.TipoPratica__c = myForm.pratica.tipoPratica;
		return xcs_messaggio;
	}
}