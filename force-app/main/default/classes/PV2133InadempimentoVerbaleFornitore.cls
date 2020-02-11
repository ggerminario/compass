public class PV2133InadempimentoVerbaleFornitore extends PVAction{

    public class PV2133InadempimentoVerbaleFornitoreForm extends PVForm{
        
        
    }
	
	@AuraEnabled
	public static void conferma(PV2133InadempimentoVerbaleFornitoreForm datiForm){
		new PV2133InadempimentoVerbaleFornitore().execute(datiForm);
	}

    public void execute(PV2133InadempimentoVerbaleFornitoreForm form){
		// TO DO EXECUTE con chiamata a VariazioneModalCalcoloRata
        PV2133InadempimentoVerbaleFornitoreForm myForm = (PV2133InadempimentoVerbaleFornitoreForm) form;
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
		PV2133InadempimentoVerbaleFornitoreForm myForm = (PV2133InadempimentoVerbaleFornitoreForm) form;

        casoPV.pv_send_to__c = myForm.pratica.filiale;
		casoPV.pv_subtype__c = myForm.sottotipologiaMdt.Descrizione__c;
		//casoPV.pv_send_to__c = UserInfo.getUserId();
		casoPV.UfficioDestinazione__c = form.userData.accountOffice.Id;
		return casoPV;
	}

    public override String recuperaNotaSpecificaPV(PVForm form, Case casoPV){
		//preparazione nota
		PV2133InadempimentoVerbaleFornitoreForm myForm = (PV2133InadempimentoVerbaleFornitoreForm) form;
		String notaSpecificaPV;
		notaSpecificaPV = 'Numero pratica: ' + myForm.pratica.numPratica + '\n'
                        + 'Stato pratica: '+ myForm.pratica.statoPratica + '\n'
                        + 'Codice dealer: ' + myForm.pratica.dealerCode + '\n';
        return notaSpecificaPV;
	}

    public override XCS_Messaggio__c preparaMessaggioOCS(PVForm form, XCS_Messaggio__c xcs_messaggio){
		//preparazione XCS_Messaggio
		PV2133InadempimentoVerbaleFornitoreForm myForm = (PV2133InadempimentoVerbaleFornitoreForm) form;
		//xcs_messaggio.CodCliente__c = myForm.cliente.codCliente;
		xcs_messaggio.NumPratica__c = myForm.pratica.numPratica;
		xcs_messaggio.TipoPratica__c = myForm.pratica.tipoPratica;
		return xcs_messaggio;
	}
}