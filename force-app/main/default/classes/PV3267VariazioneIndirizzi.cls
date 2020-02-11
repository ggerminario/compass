/**
 * @File Name          : PV3267VariazioneIndirizzi.cls
 * @Description        :
 * @Author             : Raffaele Prudenzano
 * @Group              :
 * @Last Modified By   : Raffaele Prudenzano
 * @Last Modified On   : 11/11/2019, 10:01:02
 * @Modification Log   :
 * Ver       Date            Author                  Modification
 * 1.0    11/11/2019   Raffaele Prudenzano     Initial Version
 **/

public with sharing class PV3267VariazioneIndirizzi extends PVAction {

	public class PV3267VariazioneIndirizziForm extends PVForm {
		@AuraEnabled public OCSRecuperaDatiClienteResponse.recuperaDatiClienteResponse datiCliente { get; set; }

		@AuraEnabled public List<IndirizzoDTO> variazioneIndirizzi { get; set; }
		@AuraEnabled public String annulla { get; set; }

	}

	@AuraEnabled
	public static void conferma(PV3267VariazioneIndirizziForm datiForm) {
		System.debug('PV3267VariazioneIndirizzi : conferma ' + datiForm.variazioneIndirizzi);


		if(datiForm.annulla == 'N') {

			// Creo la richiesta parsando le variazioni di indirizzo
			OCSVariazioneIndirizziInvoker.OCSVariazioneIndirizziRequestDTO req = parseIndirizziToReqVariazioni(datiForm.variazioneIndirizzi, datiForm.cliente.codCliente);

			System.debug('variazioneIndirizziReq: ' + JSON.serialize(req));

			// Chiamata per effettiva variazione indirizzi
			OCSVariazioneIndirizziInvoker.VariazioneIndirizziResponseDTO resp = OCSVariazioneIndirizziInvoker.invoke(req).variazioneIndirizziResponse;

			System.debug('variazioneIndirizziResp: ' + JSON.serialize(resp));


			if(resp.esitoElaborazione != 'OK') {
				gestisciException('Errore durante la variazione dell\'indirizzo. Esito elaborazione: ' + resp.esitoElaborazione);
			} else {
				new PV3267VariazioneIndirizzi().execute(datiForm);
			}
		} else {
			new PV3267VariazioneIndirizzi().execute(datiForm);

		}
	}

	public void execute(PVForm form) {
		String messaggio_errore = '';
		try{
			PV3267VariazioneIndirizziForm myForm = (PV3267VariazioneIndirizziForm) form;
			//Common di PVAction
			commonExecute(myForm);
		} catch(Exception e) {
			messaggio_errore = loggaException(e);
		}finally {
			if(messaggio_errore != '') {
				gestisciException(messaggio_errore);
			}
		}
	}

	public override Case completaCasePostVendita(Case casoPV, PVForm form) {
		PV3267VariazioneIndirizziForm myForm = (PV3267VariazioneIndirizziForm) form;
		if(myForm.annulla.equalsIgnoreCase('S')) {
			casoPV.Step_PV__c = '999';
		}
		return casoPV;
	}

	public override String recuperaNotaSpecificaPV(PVForm form, Case casoPV) {
		return '';

	}

	public override XCS_Messaggio__c preparaMessaggioOCS(PVForm form, XCS_Messaggio__c xcs_messaggio) {
		PV3267VariazioneIndirizziForm myForm = (PV3267VariazioneIndirizziForm) form;
		xcs_messaggio.CodCliente__c = myForm.cliente.codCliente;
		return xcs_messaggio;
	}

	public static OCSVariazioneIndirizziInvoker.OCSVariazioneIndirizziRequestDTO parseIndirizziToReqVariazioni(List<IndirizzoDTO> indirizzi, String codCliente) {
		System.debug('PV3267VariazioneIndirizzi : indirizzi ' + indirizzi);

		OCSVariazioneIndirizziInvoker.OCSVariazioneIndirizziRequestDTO req = new OCSVariazioneIndirizziInvoker.OCSVariazioneIndirizziRequestDTO();

		req.codCliente = codCliente;
		for(IndirizzoDTO ind :indirizzi) {
			String sAction = '';

			if(ind.azione == 'Inserito' || ind.azione == 'Modificato') {
				sAction = 'M';
			} else if(ind.azione == 'Cancellato') {
				sAction = 'A';
			}

			if(ind.tipoIndirizzo == 'Domicilio') {
				req.flagDomicilio = sAction;
				if(sAction != 'A') {
					req.domicilioCap = ind.cap;
					req.domicilioLocalita = ind.localita;
					req.domicilioProvincia = ind.provincia;
					if(ind.indirizzo.length() > 30) {
						req.domicilioIndirizzo1 = ind.indirizzo.substring(0, 30);
						req.domicilioIndirizzo2 = ind.indirizzo.substring(30);
					} else {
						req.domicilioIndirizzo1 = ind.indirizzo;
					}
				}
			} else if(ind.tipoIndirizzo == 'Residenza') {
				//per la residenza i flag sono S o N
				if(sAction != '') {
					sAction = 'S';
				}
				req.flagResidenza = sAction;
				req.residenzaCap = ind.cap;
				req.residenzaLocalita = ind.localita;
				req.residenzaProvincia = ind.provincia;
				if(ind.indirizzo.length() > 30) {
					req.residenzaIndirizzo1 = ind.indirizzo.substring(0, 30);
					req.residenzaIndirizzo2 = ind.indirizzo.substring(30);
				} else {
					req.residenzaIndirizzo1 = ind.indirizzo;
				}
			} else if(ind.tipoIndirizzo == 'Precedente') {
				req.flagIndPrecedente = sAction;
				if(sAction != 'A') {
					req.precedenteCap = ind.cap;
					req.precedenteLocalita = ind.localita;
					req.precedenteProvincia = ind.provincia;
					if(ind.indirizzo.length() > 30) {
						req.precedenteIndirizzo1 = ind.indirizzo.substring(0, 30);
						req.precedenteIndirizzo2 = ind.indirizzo.substring(30);
					} else {
						req.precedenteIndirizzo1 = ind.indirizzo;
					}
				}
			}
		}

		return req;

	}

	public PV3267VariazioneIndirizzi() {
	}


	@AuraEnabled
	public static List<OCSRecuperaIndirizziClienteResponse.IndirizzoDTO> doRecuperaIndirizziCliente(String codCliente) {
		OCSRecuperaIndirizziClienteResponse res = OCSRecuperaIndirizziClienteInvoker.callRecIndirizzi(codCliente);
		return res.recuperaIndirizziClienteResponse.elencoIndirizzi;
	}

	@AuraEnabled
	public static OCSNormalizzaIndirizzoResponse doNormalizzaIndirizzo(String indirizzo, String cap, String localita, String provincia) {
		OCSNormalizzaIndirizzoResponse res = OCSNormalizzaIndirizzoInvoker.callNormalizzaIndirizzo('', indirizzo, '', cap, localita, provincia, '', '');
		System.debug('normal: ' + res);

		return res;
	}

	// non riesco a farlo funzionare
	//     @AuraEnabled
	//     public static OCSNormalizzaIndirizzoInvoker.DatiChiamataOCS doProcessaResponse(OCSNormalizzaIndirizzoResponse response) {
	//         System.debug('input: ' + response);
	//         return OCSNormalizzaIndirizzoInvoker.processaResponse(response);
	//     }

	@AuraEnabled
	public static OCSNormalizzaIndirizzoInvoker.DatiChiamataOCS doProcessaResponse(String res) {
		System.debug('doProcessaResponse input: ' + res);
		OCSNormalizzaIndirizzoResponse obj = (OCSNormalizzaIndirizzoResponse) JSON.deserialize(res, OCSNormalizzaIndirizzoResponse.class);
		OCSNormalizzaIndirizzoInvoker.DatiChiamataOCS result = OCSNormalizzaIndirizzoInvoker.processaResponse(obj);
		return result;
	}


	@AuraEnabled
	public static CheckResponse doGestisciAlertSuPratiche(List<OCSPratica> pratiche, String codCliente) {
		System.debug(pratiche);

		Boolean hasOnlyConsumo = true;
		Boolean printIstruttoria = false;
		Boolean isARecupero = false;
		Boolean cartaNonAttiva = false;
		Boolean isStatoFinoa30CF = false;

		for(OCSPratica p :pratiche) {
			if(p.tipoPratica == 'CA') {
				hasOnlyConsumo = false;

				if(p.flagRecupero == 'S') {
					isARecupero = true;
				}

				if(cartaNonAttiva == false) {

					if(p.statoPratica == '60' || p.codStatoPratica == '50' || p.codStatoPratica == '50XX') {
						OCSCartaDatiFinanziariResponse.DatiCartaDatiFinanziariResponseDTO cdfResp = OCSCartaDatiFinanziariInvoker.cartaDatiFinanziari(p.numPratica).datiCartaDatiFinanziariResponse;
						if(cdfResp.flagAttivazioneCarta == 'S') {
							cartaNonAttiva = true;
						}
					} else if(p.statoPratica != '40' && p.statoPratica != '70' && p.statoPratica != '30RT' && p.statoPratica != '30AN') {
						OCSCartaDatiFinanziariResponse.DatiCartaDatiFinanziariResponseDTO cdfResp = OCSCartaDatiFinanziariInvoker.cartaDatiFinanziari(p.numPratica).datiCartaDatiFinanziariResponse;
						if(cdfResp.as400Status == 'OK') {
							if(isFidoOrStoreCredit(cdfResp) == 'N') {
								cartaNonAttiva = true;
								if(p.statoPratica < '30' || p.statoPratica == '30CF') {
									isStatoFinoa30CF = true;
								}
							}
						}
					}
				}

			} else {
				if(p.tipoPratica == 'CO') {
					if(p.statoPratica <= '30' && p.codAttributoPratica != 'RE' && p.codAttributoPratica != 'RT') {
						printIstruttoria = true;
					}
				} else {
					hasOnlyConsumo = false;
				}
			}
		}

		// ############
		// # Caso 1 - Cliente titolare di solo prestito, in stato ≤ 30 senza attributo (RE/RT)
		// # Alert - “Non è possibile variare gli indirizzi in quanto una delle pratiche è in istruttoria.”
		// ############

		if(hasOnlyConsumo == true && printIstruttoria == true) {
			String errorMessage = 'Non è possibile variare gli indirizzi in quanto una delle pratiche è in istruttoria';
			return new PV3267VariazioneIndirizzi.CheckResponse(1, false, errorMessage);
		}


		// ############
		// # Caso 2/4 - Cliente la cui posizione, per la quale sta chiamando, è a recupero (carta o prestito)
		// # Alert - "E' richiesto l'invio di un fax in quanto uno dei prodotti è a recupero. Se il fax non è stato ricevuto, la richiesta sarà inserita in stato Annullata, ai fini del tracciamento, ma la modifica NON sarà eseguita."
		// ############


		if(isARecupero == true) {
			String errorMessage = 'E\' richiesto l\'invio di un fax in quanto uno dei prodotti è a recupero. Se il fax non è stato ricevuto, la richiesta sarà inserita in stato Annullata, ai fini del tracciamento, ma la modifica NON sarà eseguita.';
			return new PV3267VariazioneIndirizzi.CheckResponse(1, true, errorMessage);

		}

		List<OCSRecuperaSaldoClienteResponse.PraticheClass> rscElencoPratiche = OCSRecuperaSaldoClienteInvoker.callGetSaldoCliente(codCliente).recuperaSaldoClienteResponse.elencoPratiche;

		Integer sumScaduto = 0;
		for(OCSRecuperaSaldoClienteResponse.PraticheClass p :rscElencoPratiche) {
			sumScaduto = sumScaduto + Integer.valueOf(p.scaduto);
		}

		if(sumScaduto > 500) {
			String errorMessage = 'E\' richiesto l\'invio di un fax in quanto uno dei prodotti è a recupero.Se il fax non è stato ricevuto, la richiesta sarà inserita in stato Annullata, ai fini del tracciamento, ma la modifica NON sarà eseguita.';
			return new PV3267VariazioneIndirizzi.CheckResponse(1, true, errorMessage);

		}


		// ############
		// # Caso 3A/B - Cliente titolare di carta di credito non attiva (stato 30; stato 50/60 con tessera non attiva)
		// # Alert - "E' richiesto l'invio di un fax in quanto una delle carte non è attiva.Se il fax non è stato ricevuto, la richiesta sarà inserita in stato Annullata, ai fini del tracciamento, ma la modifica NON sarà eseguita."
		// ############


		if(cartaNonAttiva == true) {
			if(isStatoFinoa30CF == true) {
				String errorMessage = 'Carta in istruttoria, rimandare il cliente al canale di caricamento.';
				return new PV3267VariazioneIndirizzi.CheckResponse(1, false, errorMessage);

			} else {
				String errorMessage = 'E\' richiesto l\'invio di un fax in quanto una delle carte non è attiva. Se il fax non è stato ricevuto, la richiesta sarà inserita in stato Annullata, ai fini del tracciamento, ma la modifica NON sarà eseguita.';
				return new PV3267VariazioneIndirizzi.CheckResponse(1, true, errorMessage);

			}
		}

		return new PV3267VariazioneIndirizzi.CheckResponse(0, null, null);


	}

	private static String isFidoOrStoreCredit(OCSCartaDatiFinanziariResponse.DatiCartaDatiFinanziariResponseDTO cdfResp) {
		String isFidoOrStoreCredit = 'N';
		if(cdfResp.emettitore != null && !cdfResp.emettitore.trim().equals('')) {
			System.debug('cdfResp.emettitore: ' + cdfResp.emettitore);
			try{
				Integer iEmet = Integer.valueOf(cdfResp.emettitore.trim());
				if(iEmet != 524 && iEmet >= 100 && iEmet <= 999) {
					isFidoOrStoreCredit = 'S';
				}
			} 
			catch(Exception e) {
			}
		}
		return isFidoOrStoreCredit;
	}



	public class CheckResponse {
		@AuraEnabled public Integer resultCode { get; set; }
		@AuraEnabled public Boolean showFax { get; set; }
		@AuraEnabled public String errorMessage { get; set; }


		public CheckResponse(Integer resultCode, Boolean showFax, String errorMessage) {
			this.resultCode = resultCode;
			this.showFax = showFax;
			this.errorMessage = errorMessage;
		}

	}

	public class IndirizzoDTO {
		@AuraEnabled public String tipoIndirizzo { get; set; }
		@AuraEnabled public String indirizzo { get; set; }
		@AuraEnabled public String cap { get; set; }
		@AuraEnabled public String localita { get; set; }
		@AuraEnabled public String provincia { get; set; }
		@AuraEnabled public String azione { get; set; }

		public IndirizzoDTO() {
		}
	}


}