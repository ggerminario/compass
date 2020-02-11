/**
 * @File Name          : PV3262TrasfSaldoCampagna.cls
 * @Description        :
 * @Author             : Raffaele Prudenzano
 * @Group              :
 * @Last Modified By   : Raffaele Prudenzano
 * @Last Modified On   : 10/12/2019, 11:54:01
 * @Modification Log   :
 * Ver       Date            Author                  Modification
 * 1.0    02/12/2019   Raffaele Prudenzano     Initial Version
 **/

public with sharing class PV3262TrasfSaldoCampagna extends PVAction {

	public class PV3262TrasfSaldoCampagnaForm extends PVForm {
		@AuraEnabled public String importo { get; set; }
		@AuraEnabled public String codCampagna { get; set; }
		@AuraEnabled public String dataScadenza { get; set; }
		@AuraEnabled public String numRate { get; set; }
		@AuraEnabled public String checkIntermediario {get; set; }
	}


	@AuraEnabled
	public static void conferma(PV3262TrasfSaldoCampagnaForm datiForm) {
		new PV3262TrasfSaldoCampagna().execute(datiForm);
	}

	public void execute(PVForm form) {
		PV3262TrasfSaldoCampagnaForm myForm = (PV3262TrasfSaldoCampagnaForm) form;
		String messaggio_errore = '';
		try{


			// Invocazione chiamata "B2B_acquistiErogazioneDiretta"
			OCSAcquistiErogazioneDirettaInvoker.DatiAcquistiErogazioneDirettaRequestDTO obj = new OCSAcquistiErogazioneDirettaInvoker.DatiAcquistiErogazioneDirettaRequestDTO();

			if(myForm.checkIntermediario != null && myForm.checkIntermediario.trim() != ''){
				obj.intermediario = myForm.checkIntermediario;
			} else{
				obj.intermediario = '12';
			}
			
			obj.numeroCarta = myForm.pratica.numPratica;
			obj.importo = String.valueOf(Integer.valueOf((Double.valueOf(myForm.importo) *100)));
			obj.codiceCampagna = myForm.codCampagna;
			obj.destErogazione = 'TR';
			obj.modalitaErogazione = '';
			obj.flagCommissioniErogazione = 'S';
			obj.dataScadenza = myForm.dataScadenza;
			obj.dataNascita = myForm.cliente.dataNascita;
			obj.numRate = myForm.numRate;
			obj.iban = '';
			obj.canale = '';
			obj.utente = '';

			System.debug('+-+-+-+ obj.importo: ' +obj.importo);

			OCSAcquistiErogazioneDirettaInvoker.DatiAcquistiErogazioneDirettaResponseDTO resp = OCSAcquistiErogazioneDirettaInvoker.invoke(obj).datiAcquistiErogazioneDirettaResponse;
			if(resp.as400Status == 'KO') {
				messaggio_errore = resp.as400Status + ': ' + resp.as400Errore;
				gestisciException('');
			} else {
				commonExecute(myForm);
			}
		} catch(Exception e) {
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
	public static OCSCartaDatiFinanziariResponse.DatiCartaDatiFinanziariResponseDTO getDatiFinanziariCarta(String numeroCarta) {
		OCSCartaDatiFinanziariResponse response = OCSCartaDatiFinanziariInvoker.cartaDatiFinanziari(numeroCarta);
		return response.datiCartaDatiFinanziariResponse;
	}

	@AuraEnabled
	public static OCSRecuperaMovAutViaggiantiResponse.RecuperaAutViaggiantiResponseDTO doRecuperaElencoAutorizzazioni(String numPratica, String emettitore) {
		OCSRecuperaMovAutViaggiantiResponse.RecuperaAutViaggiantiResponseDTO res = OCSRecuperaMovAutViaggiantiInvoker.recuperaMovAutViaggianti(numPratica, emettitore, true, false).recuperaMovimentiAutorizzazioniViaggiantiResponse.recuperaAutViaggiantiResponse;

		List<OCSRecuperaMovAutViaggiantiResponse.AutorizzazioneViaggianteDTO> elencoAutorizzazioni = new List<OCSRecuperaMovAutViaggiantiResponse.AutorizzazioneViaggianteDTO>();

		// Controlli su elencoAutorizzazioni
		for(OCSRecuperaMovAutViaggiantiResponse.AutorizzazioneViaggianteDTO aut :res.elencoAutorizzazioni) {
			if(aut.autorizzazione != null && aut.autorizzazione != '0') {
				elencoAutorizzazioni.add(aut);
			}
		}

		res.elencoAutorizzazioni = elencoAutorizzazioni;
		return res;
	}

	@AuraEnabled
	public static OCSRecuperaMovAutViaggiantiResponse.RecuperaMovViaggiantiResponseDTO doRecuperaElencoMovimenti(String numPratica, String emettitore) {
		OCSRecuperaMovAutViaggiantiResponse.RecuperaMovViaggiantiResponseDTO res = OCSRecuperaMovAutViaggiantiInvoker.recuperaMovAutViaggianti(numPratica, emettitore, false, true).recuperaMovimentiAutorizzazioniViaggiantiResponse.recuperaMovViaggiantiResponse;

		List<OCSRecuperaMovAutViaggiantiResponse.MovimentoViaggianteDTO> elencoMovimenti = new List<OCSRecuperaMovAutViaggiantiResponse.MovimentoViaggianteDTO>();

		// Controlli su elencoMovimenti
		for(OCSRecuperaMovAutViaggiantiResponse.MovimentoViaggianteDTO mov :res.elencoMovimenti) {
			if(mov.tipoMov != '') {
				if(mov.importo != null) {
					try{
						mov.importo = (Double.valueOf(mov.importo) /100) + '';
					} catch(Exception e) {
					}
				} else {
					mov.importo = '';
				}
				elencoMovimenti.add(mov);
			}
		}
		res.elencoMovimenti = elencoMovimenti;
		return res;

	}

	@AuraEnabled
	public static OCSRecuperaCampAttiveAttivabInvoker.RecuperaCampagneAttivabiliResponseDTO doRecuperaCampagneAttivabili(String numPratica, String emettitore, String prodotto) {

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
		input.flagAttive = 'N';
		input.flagAttivabili = 'S';

		OCSRecuperaCampAttiveAttivabInvoker.RecuperaCampagneAttivabiliResponseDTO res = OCSRecuperaCampAttiveAttivabInvoker.invoke(input).recuperaCampagneAttiveAttivabiliResponse.recuperaCampagneAttivabiliResponse;
		List<OCSRecuperaCampAttiveAttivabInvoker.CampagnaAttivabileDTO> campList = new List<OCSRecuperaCampAttiveAttivabInvoker.CampagnaAttivabileDTO>();

		// Controlli validità su elencoCampagneAttivabli
		for(OCSRecuperaCampAttiveAttivabInvoker.CampagnaAttivabileDTO camp :res.elencoCampagneAttivabli) {

			if(!isEmptyOrZero(camp.codCampagna)) {
				if(isValidAndAfterToday(camp.dataFineAutorizzazione) && isValidAndAfterToday(camp.dataScadenza)) {

					if(isValidAndBeforeToday(camp.dataInizioAutorizzazione) && isValidAndBeforeToday(camp.dataValidita)) {
						campList.add(camp);
					}
				}
			}
		}
		res.elencoCampagneAttivabli = campList;
		return res;

	}

	private static Boolean isValidAndAfterToday(String s) {
		if(s == '99999999') {
			return true;
		}

		Date d = strToDate(s);
		if(d != null) {
			if(d > Date.today()) {
				return true;
			}
		}
		return false;
	}

	private static Boolean isValidAndBeforeToday(String s) {
		Date d = strToDate(s);
		if(d != null) {
			if(d <= Date.today()) {
				return true;
			}
		}
		return false;
	}

	private static Boolean isEmptyOrZero(String s) {
		return s == null || s.trim() == '' || s.trim() == '0';
	}

	// Accetta il formato yyyyMMdd. Su apex non c'è un parser che accetta formati custom
	private static Date strToDate(String s) {
	try{
	Integer anno = Integer.valueOf(s.substring(0, 4));
	Integer mese = Integer.valueOf(s.substring(4, 6));
	Integer giorno = Integer.valueOf(s.substring(6, 8));

	return Date.newInstance(anno, mese, giorno);
	} catch(Exception e) {
	return null;
	}
	}



	public override Case completaCasePostVendita(Case casoPV, PVForm form) {
	return casoPV;
	}

	public override String recuperaNotaSpecificaPV(PVForm form, Case casoPV) {
	//preparazione nota
	PV3262TrasfSaldoCampagnaForm myForm = (PV3262TrasfSaldoCampagnaForm) form;

	String notaSpecificaPV = ' ';
	notaSpecificaPV = 'Pratica: ' + myForm.pratica.tipoPratica + ' - ' + myForm.pratica.numPratica + '<br>';
	notaSpecificaPV += 'Importo: ' + myForm.importo + '<br>';
	notaSpecificaPV += 'Campagna: ' + myForm.codCampagna + '<br>';
	notaSpecificaPV += 'Numero rate: ' + myForm.numRate + '<br>';
	
	return notaSpecificaPV;

}

public override XCS_Messaggio__c preparaMessaggioOCS(PVForm form, XCS_Messaggio__c xcs_messaggio) {
	PV3262TrasfSaldoCampagnaForm myForm = (PV3262TrasfSaldoCampagnaForm) form;
	xcs_messaggio.CodCliente__c = myForm.pratica.codCliente;
	return xcs_messaggio;
}
}