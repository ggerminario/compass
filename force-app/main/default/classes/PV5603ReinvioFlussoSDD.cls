/**
 * @File Name          : PV5603ReinvioFlussoSDD.cls
 * @Description        : 
 * @Author             : Nicola Musicco
 * @Group              : 
 * @Last Modified By   : Nicola Musicco
 * @Last Modified On   : 22/1/2020, 08:37:14
 * @Modification Log   : 
 * Ver       Date            Author      		    Modification
 * 1.0    16/1/2020   Nicola Musicco     Initial Version
**/
public class PV5603ReinvioFlussoSDD extends PVAction{
     
	 public class PV5603ReinvioFlussoSDDForm extends PVForm {
		public String esito { get; set; }
		public String mandato { get; set; }
		public String desErrore { get; set; }
		
	}

    public override Case completaCasePostVendita(Case casoPV, PVForm form) {

		PV5603ReinvioFlussoSDDForm nForm=(PV5603ReinvioFlussoSDDForm)form;
		casoPV.pv_esito_poste__c=nForm.esito;
		return casoPV;
	}

    @AuraEnabled
	public static void conferma(PV5603ReinvioFlussoSDDForm datiForm) {
		new PV5603ReinvioFlussoSDD().execute(datiForm);
	}

	@AuraEnabled
	public static OCSResponse verificaPraticaSelezionata(PV5603ReinvioFlussoSDDForm form){

		OCSResponse response=recuperaBlocchiCarta(form.pratica.numPratica);
		if(response.resultCode==0)
			response=verificaMandatoSDDReinserimento(form);

		return response;
	}

	@TestVisible
    private static OCSResponse recuperaBlocchiCarta(String numPratica){
        
		OCSResponse response=new OCSResponse();
		response.resultCode=1;
		
        try {

			//verifica la presenza dei blocchi carta
			OCSrecuperaBlocchiCartaInvoker.RecuperaBlocchiCartaRequestDTO request =new OCSrecuperaBlocchiCartaInvoker.RecuperaBlocchiCartaRequestDTO();
			request.numCarta=numPratica;
			OCSrecuperaBlocchiCartaInvoker.RecuperaBlocchiCartaResponseDTO res=OCSrecuperaBlocchiCartaInvoker.invoke(request).recuperaBlocchiCartaResponse;
           
		    List<OCSrecuperaBlocchiCartaInvoker.BloccoCarta> elencoBlocchi=res.elencoBlocchi;

			if(elencoBlocchi!=null){

				for(OCSrecuperaBlocchiCartaInvoker.BloccoCarta bloccoCarta: elencoBlocchi){
					System.debug(bloccoCarta.keyCode);
					if(bloccoCarta.keyCode=='RV'){
						response.resultCode=0;
						return response;
					}
				}
			}
            
			response.resultMessage='Blocco RV non presente';
			
        } catch (Exception e) {
            
			System.debug(e);
			response.resultMessage='Si è verificato un errore durante il recupero dei blocchi';
        }
		return response;
		
    }


	@TestVisible
    private static OCSResponse verificaMandatoSDDReinserimento(PV5603ReinvioFlussoSDDForm form){

		OCSResponse response=new OCSResponse();
		response.resultCode=1;

		try {
			
			OCSGenericRecuperaDatiInvoker.Response res = OCSGenericRecuperaDatiInvoker.invoke('verificaMandatoSDDReinserimento', form.pratica.tipoPratica, form.pratica.numPratica, null, null, null);
			if(res.genericRecuperaDatiResponseDTO!=null && res.genericRecuperaDatiResponseDTO.size()>0){
				
				//recupera parametro dalla prima posizione
				OCSGenericRecuperaDatiInvoker.GenericRecuperaDatiResponseDTO r=res.genericRecuperaDatiResponseDTO.get(0);
				
				if(r.out_1=='OK'){
					response.resultCode=0;
					return response;
				}
			}
		
			response.resultMessage='Stato del mandato SDD non corretto';

		} catch (Exception e) {

			System.debug(e);
			response.resultMessage='Si è verificato un errore durante la verifica del mandato';
		}

		return response;
		
	}

	private OCSCreazioneNuovoMandatoSDDInvoker.Response creaMandatoSDD(String numPratica, String tipoPratica){

		OCSCreazioneNuovoMandatoSDDInvoker.Response response=new OCSCreazioneNuovoMandatoSDDInvoker.Response();
		response.creazioneNuovoMandatoSDDResponse=
			new OCSCreazioneNuovoMandatoSDDInvoker.CreazioneNuovoMandatoSDDResponseDTO();
		try {
			
			response = OCSCreazioneNuovoMandatoSDDInvoker.invoke(tipoPratica, numPratica);
			
		} catch (Exception e) {
			
			System.debug(e);
			response.creazioneNuovoMandatoSDDResponse.esito='KO';
			response.resultCode=1;
			response.creazioneNuovoMandatoSDDResponse.desErrore='Si è verificato un errore durante la creazione del mandato';
		}

		return response;
	}

	public void execute(PV5603ReinvioFlussoSDDForm form) {
		String messaggio_errore = '';
		try{	

			OCSCreazioneNuovoMandatoSDDInvoker.Response response = creaMandatoSDD(form.pratica.numPratica, form.pratica.tipoPratica);
			form.esito=response.creazioneNuovoMandatoSDDResponse.esito;
			form.mandato=response.creazioneNuovoMandatoSDDResponse.mandato;
			form.desErrore=response.creazioneNuovoMandatoSDDResponse.desErrore;
			
			commonExecute(form);
			
		}catch(Exception e) {
			if(messaggio_errore == '') {
				messaggio_errore = loggaException(e);
			}
		}finally {
			if(messaggio_errore != '') {
				gestisciException(messaggio_errore);
			}
		}

	}

    public override String recuperaNotaSpecificaPV(PVForm form, Case casoPV) {
		//preparazione nota
		
		String notaSpecificaPV='';
		PV5603ReinvioFlussoSDDForm nForm=(PV5603ReinvioFlussoSDDForm)form;
		
		if(nForm.esito=='KO'){
			notaSpecificaPV+=''+'<br>';
			notaSpecificaPV+='Esito: '+nForm.esito+'<br>';
			notaSpecificaPV+='Errore: '+nForm.desErrore+'<br>';
		}
		
		else {
			notaSpecificaPV+=''+'<br>';
			notaSpecificaPV+='Esito: '+nForm.esito+'<br>';
			notaSpecificaPV+='Nuovo Mandato: '+nForm.mandato+'<br>';
		}
		notaSpecificaPV+='Filiale di ' +nForm.userData.accountOffice.Name+'-'+nForm.userData.user.LastName+'<br>';
		notaSpecificaPV += 'Numero Carta: ' + nForm.pratica.tipoPratica+'-'+nForm.pratica.numPratica + '<br>';

		return notaSpecificaPV;

	}

	public override XCS_Messaggio__c preparaMessaggioOCS(PVForm form, XCS_Messaggio__c xcs_messaggio) {
		PV5603ReinvioFlussoSDDForm nForm=(PV5603ReinvioFlussoSDDForm)form;
		return xcs_messaggio;
	}
}