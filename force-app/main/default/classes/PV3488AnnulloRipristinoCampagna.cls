/**
 * @File Name          : PV3488AnnulloRipristinoCampagna.cls
 * @Description        : 
 * @Author             : Nicola Musicco
 * @Group              : 
 * @Last Modified By   : Nicola Musicco
 * @Last Modified On   : 8/1/2020, 14:37:08
 * @Modification Log   : 
 * Ver       Date            Author      		    Modification
 * 1.0    18/12/2019   Nicola Musicco     Initial Version
**/

public class PV3488AnnulloRipristinoCampagna extends PVAction {
    /*
    @AuraEnabled
	public static OCSRecuperaCampAttiveAttivabInvoker.RecuperaCampagneAttivabiliResponseDTO doRecuperaCampagneAttiveAttivabili(String numPratica, String emettitore, String prodotto) {

		// Costruisco la richiesta
		OCSRecuperaCampAttiveAttivabInvoker.OCSRecuperaCampAttiveAttivabRequestDTO input = new OCSRecuperaCampAttiveAttivabInvoker.OCSRecuperaCampAttiveAttivabRequestDTO();
		input.provenienza = 'CA';
		input.tipoIntermediario = 'AG';
		input.intermediario = '12';
		input.numPratica = numPratica;
		input.pan = '';
		input.emettitore = emettitore;
		input.protocollo = '';
		input.riga = '';
		input.prodotto = prodotto;
		input.flagAttive = 'S';
		input.flagAttivabili = 'S';

		OCSRecuperaCampAttiveAttivabInvoker.RecuperaCampagneAttivabiliResponseDTO res = OCSRecuperaCampAttiveAttivabInvoker.invoke(input).recuperaCampagneAttiveAttivabiliResponse.recuperaCampagneAttivabiliResponse;
		List<OCSRecuperaCampAttiveAttivabInvoker.CampagnaAttivabileDTO> campList = new List<OCSRecuperaCampAttiveAttivabInvoker.CampagnaAttivabileDTO>();

		return null;
    }
*/

    public class PV3488AnnulloRipristinoCampagnaForm extends PVForm {
		@AuraEnabled public List<OCSRecuperaAzioniCANResponse.AzioniCANDTO> elencoAzioniCAN { get; set; }
		
	}

	@AuraEnabled
	public static void conferma(PV3488AnnulloRipristinoCampagnaForm datiForm) {
		new PV3488AnnulloRipristinoCampagna().execute(datiForm);
	}


	public void execute(PV3488AnnulloRipristinoCampagnaForm form) {
		String messaggio_errore = '';
		try{

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

	@AuraEnabled
	public static OCSRecuperaAzioniCANResponse.RecuperaAzioniCANResponseDTO doRecuperaAzioniCAN(String numPratica){

		OCSRecuperaAzioniCANInvoker.OCSRecuperaAzioniCANRequestDTO request =new OCSRecuperaAzioniCANInvoker.OCSRecuperaAzioniCANRequestDTO();
		request.numPratica =numPratica;
		OCSRecuperaAzioniCANResponse.RecuperaAzioniCANResponseDTO response = OCSRecuperaAzioniCANInvoker.invoke(request).recuperaAzioniCANResponse;

		List<OCSRecuperaAzioniCANResponse.AzioniCANDTO> azioniCan=new List<OCSRecuperaAzioniCANResponse.AzioniCANDTO>();

		if(response.elencoAzioni!=null){
			
			for(OCSRecuperaAzioniCANResponse.AzioniCANDTO azioneCAN: response.elencoAzioni){
				
				if(azioneCAN.stato!=null && azioneCAN.stato.trim().equals('30') &&
					azioneCAN.blocco!=null && azioneCAN.blocco.trim().equals(''))
					
					azioniCan.add(azioneCAN);
			}
		}
		response.elencoAzioni=azioniCan;
		return response;
		
	}
	
    public override Case completaCasePostVendita(Case casoPV, PVForm form) {
		return casoPV;
	}

    public override String recuperaNotaSpecificaPV(PVForm form, Case casoPV) {
		//preparazione nota
		PV3488AnnulloRipristinoCampagnaForm nForm=(PV3488AnnulloRipristinoCampagnaForm)form;
		String notaSpecificaPV;
		notaSpecificaPV = 'Numero Pratica: ' +  nForm.pratica.numPratica + '<br>';
		notaSpecificaPV += 'Codice Cliente: ' + nForm.pratica.codCliente + '<br>';
		notaSpecificaPV += 'Nome Cliente: ' + nForm.cliente.ragioneSociale + '<br>';
		notaSpecificaPV += 'Azioni eseguite: <br>';
		
		for(OCSRecuperaAzioniCANResponse.AzioniCANDTO azione:nForm.elencoAzioniCAN){
			notaSpecificaPV += ' - '+azione.operazione +' ';
			notaSpecificaPV += 'Campagna ' + azione.codCampagna +' ';
			notaSpecificaPV += 'Acquisto ' + azione.dataAcquisto +' ';
			notaSpecificaPV += 'Progr. ' + azione.progressivo +' <br>';
		} 
		
		return notaSpecificaPV;

	}

	public override XCS_Messaggio__c preparaMessaggioOCS(PVForm form, XCS_Messaggio__c xcs_messaggio) {
		return xcs_messaggio;
	}
    
}