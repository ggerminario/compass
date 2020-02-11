/**
 * @File Name          : PV3707EstinzioneAnticipataInserimento.cls
 * @Description        : 
 * @Author             : Federico Negro
 * @Group              : 
 * @Last Modified By   : Federico Negro
 * @Last Modified On   : 18/11/2019, 17:59:54
 * @Modification Log   : 
 * Ver       Date            Author      		    Modification
 * 1.0    14/11/2019   Federico Negro     Initial Version
**/
public class PV3707EstinzioneAnticipataInserimento extends PVAction {

    public class PV3707EstinzioneAnticipataInserimentoForm extends PVForm {
        @AuraEnabled public String progressivo {get; set;}
        @AuraEnabled public String stato {get; set;}
        @AuraEnabled public String blocco {get; set;}
	}

	/***************************/
	/*   metodi Aura enabled   */
	/***************************/
	
    //recupera elenco stati richieste
    @AuraEnabled
	public static List<OCSRecuperaStatoRichiestePSVResponse.ResponseClass> getPSVService(String numPratica,String tipoPratica, String codAzione)
    {
    	OCSRecuperaStatoRichiestePSVResponse res = OCSRecuperaStatoRichiestePSVInvoker.Invoke(tipoPratica, numPratica, codAzione, dateTime.now().format('yyyyMMdd'));
        List<OCSRecuperaStatoRichiestePSVResponse.ResponseClass> listEsiti = new List<OCSRecuperaStatoRichiestePSVResponse.ResponseClass>();
        if(res.recuperaStatoRichiestePSVResponse.elencoStatiRichieste.size() > 0){
            Integer i;
            for(i=0; i<res.recuperaStatoRichiestePSVResponse.elencoStatiRichieste.size(); i++){
                listEsiti.add(res.recuperaStatoRichiestePSVResponse.elencoStatiRichieste.get(i));
            }

			return listEsiti;

        }else{
			return null;
		}
        
        
    }
    
	@AuraEnabled
	public static void conferma(PV3707EstinzioneAnticipataInserimentoForm datiForm){
		new PV3707EstinzioneAnticipataInserimento().execute(datiForm);
	}

	/***************************/
	/* metodi NON Aura enabled */
	/***************************/

	public void execute(PVForm form){
		
		String messaggio_errore = '';
		
		try{
		PV3707EstinzioneAnticipataInserimentoForm myForm = (PV3707EstinzioneAnticipataInserimentoForm) form;

            //Common di PVAction
            commonExecute(myForm);
			
		}catch(Exception e) {
			//messaggio_errore = e.getMessage();
			messaggio_errore = loggaException(e);
		}finally{
			if(messaggio_errore != '') {
				gestisciException(messaggio_errore);
			}
		}
	}

	public override Case completaCasePostVendita(Case casoPV,PVForm form){
		//continuare a valorizzare l'oggetto casoPV integrando i dati di questo post vendita
		return casoPV;
	}

	public override String recuperaNotaSpecificaPV(PVForm form, Case casoPV){
		//preparazione nota
		PV3707EstinzioneAnticipataInserimentoForm myForm = (PV3707EstinzioneAnticipataInserimentoForm) form;
		/// : Note specifiche PV
		String notaSpecificaPV;
		notaSpecificaPV =  'Azione OCS inserita: Progressivo: ' + myForm.progressivo + ' - Stato: ' + myForm.stato + ' ' + myForm.blocco + '\n';
		return notaSpecificaPV;
	}
		
	public override XCS_Messaggio__c preparaMessaggioOCS(PVForm form, XCS_Messaggio__c xcs_messaggio){
		//preparazione XCS_Messaggio
		PV3707EstinzioneAnticipataInserimentoForm myForm = (PV3707EstinzioneAnticipataInserimentoForm) form;
		//xcs_messaggio.CodCliente__c = myForm.cliente.codCliente;
		xcs_messaggio.NumPratica__c = myForm.pratica.numPratica;
		xcs_messaggio.TipoPratica__c = myForm.pratica.tipoPratica;
		return xcs_messaggio;
	}

}