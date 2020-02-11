/**
 * @File Name          : PV3824CpayCredenzialiContext.cls
 * @Description        :
 * @Author             : Raffaele Prudenzano
 * @Group              :
 * @Last Modified By   : Raffaele Prudenzano
 * @Last Modified On   : 16/1/2020, 15:26:51
 * @Modification Log   :
 * Ver       Date            Author                  Modification
 * 1.0    18/12/2019   Raffaele Prudenzano     Initial Version
 **/
public virtual with sharing class PV3824CpayCredenzialiContext {

	@TestVisible
	public static Date today;

	public static Date today() {
		return today == null ? Date.today() :today;
	}


	public static final String userTipoBusta = 'IC106';
	public static final String pinTipoBusta = 'IB101';
	public static final String azioneAnnulloBusta = 'A'; // Annullo Busta
	public static final String azioneRiemissione = 'R'; // Riemissione

	public String act; //azione
	public String mezzo; //mezzo
	public String busta; //tipoBusta

	// NON viene salvato, viene recuperato ogni volta per fare le chiamate
	public String rec; //recapito
	public Integer numT; //numero Tentativo
	public Integer maxT; //max Tentativi
	public String lRes; //last Esito

	// NON viene salvato, viene recuperato ogni volta quando si fanno le chiamate
	public String dRes; //descrizione Esito

	public PV3824CpayCredenzialiContext() {
	}

	public PV3824CpayCredenzialiContext(String act, String mezzo, String busta, Integer maxT) {
		this.act = act;
		this.mezzo = mezzo;
		this.busta = busta;
		this.rec = '';
		this.numT = 0;
		this.maxT = maxT;
		this.lRes = 'KO';
	}


	public PV3824CpayCredenzialiContext(String act, Integer maxT) {
		this.act = act;
		this.numT = 0;
		this.maxT = maxT;
		this.lRes = 'KO';
	}

	public PV3824CpayCredenzialiContext(String act, String mezzo, String busta, String rec, Integer maxT) {
		this.act = act;
		this.mezzo = mezzo;
		this.busta = busta;
		this.rec = rec;
		this.numT = 0;
		this.maxT = maxT;
		this.lRes = 'KO';
	}

	public static Boolean isRiemissione(List<PV3824CpayCredenzialiContext> myList) {
		return myList.get(0).act == azioneRiemissione;
	}

	public static Boolean isRiemissione(PV3824CpayCredenzialiContext ctx) {
		return ctx.act == azioneRiemissione;
	}

	public static Boolean isAnnulloBusta(List<PV3824CpayCredenzialiContext> myList) {
		return myList.get(0).act == azioneAnnulloBusta;
	}

	public static Boolean isAnnulloBusta(PV3824CpayCredenzialiContext ctx) {
		return ctx.act == azioneAnnulloBusta;
	}

	public static Boolean isUser(PV3824CpayCredenzialiContext ctx) {
		return ctx.busta == userTipoBusta;
	}

	public static Boolean isPin(PV3824CpayCredenzialiContext ctx) {
		return ctx.busta == pinTipoBusta;
	}


	/**
	 * @description Metodo per costruire tutte le note. Distingue se siamo in inserimento o no e regola la costruzione delle note
	 * @author Raffaele Prudenzano | 20/12/2019
	 * @param myList
	 * @param isInserimento
	 * @param caseNumberChiusi
	 * @return String
	 **/
	public static String buildNote(List<PV3824CpayCredenzialiContext> myList, Boolean isInserimento, List<Case> caseNumberChiusi) {
		String globalResult = getGlobalResult(myList);
		String thisNote = '\n';
		if(isInserimento) {
			if(globalResult == 'OK') {
				thisNote += 'La richiesta è stata completata con esito positivo:';
			} else {
				thisNote += 'La richiesta è stata inserita';
			}

			// ? verificare se serve agganciare quanto descritto al 2.2.2.1 per annullo busta
		} else {

			if(isUltimoGiroBatch(myList)) {
				// ultimo giro batch
				thisNote += 'Esito ';
				thisNote += getGlobalResult(myList) == 'OK' ? 'Positivo' :'Negativo';
			} else {
				if(isRiemissione(myList)) {
					thisNote += printContatori(myList);
				}
			}



		}

		thisNote += buildNoteChiamata(myList);

		if(isInserimento && caseNumberChiusi != null && caseNumberChiusi.size() > 0) {
			for(Case c :caseNumberChiusi) {
				thisNote+= '\nLa richiesta ' + c.caseNumber + ' aperta in precedenza e ancora in attesa, è stata chiusa.';
			}
		}

		return thisNote;
	}

	private static Boolean isUltimoGiroBatch(List<PV3824CpayCredenzialiContext> myList) {
		return findNextStep(myList) != 'SYS';
	}

	public static String printContatori(List<PV3824CpayCredenzialiContext> myList) {
		String prefix = 'Riepilogo tentativi:';

		String thisNote = '';
		for(PV3824CpayCredenzialiContext ctx :myList) {
			// se dRes è valorizzato vuol dire che ho fatto la chiamata, quindi posso stampare il contatore
			if(ctx.dRes != null && ctx.dRes.trim() != '') {
				if(isUser(ctx)) {
					thisNote += '\nUser: ';
				} else if(isPin(ctx)) {
					thisNote += '\nPassword: ';
				}
				thisNote += ctx.numT;
			}
		}

		return thisNote != '' ? prefix + thisNote :thisNote;
	}

	/**
	 * @description Metodo per recuperare le 3 righe di nota per ogni chiamata
	 * @author Raffaele Prudenzano | 20/12/2019
	 * @param myList
	 * @return String
	 **/
	public static String buildNoteChiamata(List<PV3824CpayCredenzialiContext> myList) {

		String thisNote = '';

		for(PV3824CpayCredenzialiContext c :myList) {

			// Scrivo le note per ogni chiamata fatta
			if(c.dRes != null && c.dRes.trim() != '') {
				thisNote += '\n' + c.dRes;
			}
		}

		thisNote += '\n';

		return thisNote;
	}


	/**
	 * @description Metodo per fare le chiamate, invocato SOLO da *** BATCH ****
	 * @author Raffaele Prudenzano | 19/12/2019
	 * @param ctxList
	 * @param codCliente
	 * @param caseCreationDate
	 * @return List<PV3824CpayCredenzialiContext>
	 **/
	public static List<PV3824CpayCredenzialiContext> makeCalloutsFromContext(List<PV3824CpayCredenzialiContext> ctxList, String codCliente, Date caseCreationDate) {
		System.debug('codCliente: ' + codCliente);

		List<OCSCliente> clienti = OCSObjectsFactory.makeClienti(OCSRecuperaDatiPostvenditaInvoker.callRecDatiPV(codCliente));
		if(clienti.size() > 0) {
			return makeCalloutsFromContext(ctxList, clienti.get(0), false, caseCreationDate);
		} else {
			// parag 3 il cliente non fosse stato trovato viene si skippa al record successivo
			return ctxList;
		}
	}

	/**
	 * @description Metodo per fare le chiamate, invocato direttamente da *** INSERIMENTO ***, o da *** BATCH *** dopo aver recuperato il cliente
	 * @author Raffaele Prudenzano | 19/12/2019
	 * @param ctxList
	 * @param cliente
	 * @param caseCreationDate
	 * @return List<PV3824CpayCredenzialiContext>
	 **/
	public static List<PV3824CpayCredenzialiContext> makeCalloutsFromContext(List<PV3824CpayCredenzialiContext> ctxList, OCSCliente cliente, Boolean isInserimento, Date caseCreationDate) {

		// Generalmente fa una sola iterazione (annullo busta o riemissione singola credenziale)
		// Ne fa due nel caso di Riemissione completa credenziali
		for(PV3824CpayCredenzialiContext ctx :ctxList) {

			// Check: se la chiamata ha avuto esito positivo, passo avanti
			if(ctx.lRes == 'KO') {

				// Recupero il recapito, se serve
				String recapito = '';

				// È falsa in caso di riemissione via posta se:
				// 1 - siamo in fase di inserimento
				// 2 - siamo nel batch ma la data è ancora oggi
				Boolean calloutToDo = true;

				if(isAnnulloBusta(ctx)) {
					// Se sono in annullo busta non ho interesse a recuperare il recapito e dovrò fare la callout, in qualunque caso
				} else if(isRiemissione(ctx)) {
					switch on ctx.mezzo {
						when 'E' {
							recapito = cliente.email;
						}

						when 'S' {
							recapito = cliente.telCellulare;
						}

						when 'P' {

							if(isInserimento) {
								// ctx.lRes = 'KO'; non serve perchè se sono arrivato qui era perchè lRes era già KO
								String bustaDescr;
								if(isUser(ctx)) {
									bustaDescr = 'User';
								} else if(isPin(ctx)) {
									bustaDescr = 'PIN';
								}

								ctx.dRes = '\n\nLa richiesta di Riemissione ' + bustaDescr + ' via posta verrà processata nella giornata di domani';
								calloutToDo = false;
							} else {
								// La chiamata per riemissione via posta viene fatta SOLO SE è passato almeno un giorno
								calloutToDo = caseCreationDate.daysBetween(today()) >= 1;

							}
						}

						when else {
							// should never be reached
							return ctxList;
						}
					}

				}
				if(calloutToDo) {
					// Nel metodo makeSingleCalloutFromContext aggiorno i contatori, quindi sono pronto per salvare di nuovo il contesto
					ctx = makeSingleCalloutFromContext(ctx, cliente.codCliente, recapito);
				}
			}
		}

		return ctxList;
	}


	/**
	 * @description Metodo per effettuare la singola chiamata. Recupera il recuperaRapportoHBCpay -> annulloBusta/riemissioneCredenziali
	 * @author Raffaele Prudenzano | 19/12/2019
	 * @param ctx
	 * @param codCliente
	 * @param recapito ('' in caso di annullo busta)
	 * @return PV3824CpayCredenzialiContext
	 **/
	public static PV3824CpayCredenzialiContext makeSingleCalloutFromContext(PV3824CpayCredenzialiContext ctx, String codCliente, String recapito) {
		// Se sono arrivato fin qui, sono sicuro di dover fare la chiamata, a meno che non sono arrivato al num max di tentativi

		// Faccio la chiamata solo se non ho ancora raggiunto il massimo numero di tentativi
		if(ctx.numT < ctx.maxT) {

			// Incremento il numero tentativo, e così da fare le chiamate da numT = 1 a maxT
			ctx.numT = ctx.numT + 1;

			// Recupero il contrattohb che serve per ogni chiamata che dovrò fare
			OCSRecuperaRapportoHBCpayResponse res = OCSRecuperaRapportoHBCpayInvoker.callRecRapportoHB(codCliente);

			if(res.isOK()) {
				String rapportoHB = res.recuperaRapportoHBCpayResponse.rapportoHB;

				if(rapportoHB != null && rapportoHB.trim() != '') {

					if(isAnnulloBusta(ctx)) {
						CSEAnnulloBustaInvoker.Response resp = CSEAnnulloBustaInvoker.invoke(rapportoHB);

						if(resp.isOK()) {
							if(resp.cseAnnulloBustaResponse.esito == 'OK') {
								ctx.lRes = 'OK';
							} else {
								ctx.lRes = 'KO';
							}
							ctx.dRes = resp.cseAnnulloBustaResponse.messaggio;
						} else {
							ctx.lRes = 'KO';
							ctx.dRes = resp.getMessage();
						}

					} else if(isRiemissione(ctx)) {

						CSERiemissioneCredenzialiInvoker.CSERiemissioneCredenzialiRequestDTO req = new CSERiemissioneCredenzialiInvoker.CSERiemissioneCredenzialiRequestDTO();
						req.contrattohb = rapportoHB;
						req.mezzo = ctx.mezzo;
						req.recapito = recapito;
						req.tipoBusta = ctx.busta;
						CSERiemissioneCredenzialiInvoker.Response resp = CSERiemissioneCredenzialiInvoker.invoke(req);

						if(resp.isOK()) {
							if(resp.cseRiemissioneCredenzialiResponse.esito == 'OK') {
								ctx.lRes = 'OK';
							} else {
								ctx.lRes = 'KO';
							}
							ctx.dRes = resp.cseRiemissioneCredenzialiResponse.messaggio;
						} else {
							ctx.lRes = 'KO';
							ctx.dRes = resp.getMessage();
						}

					}

				} else {
					ctx.lRes = 'KO';
					ctx.dRes = 'Non sono presenti rapporti HB';
				}


			} else {
				ctx.lRes = 'KO';
				ctx.dRes = res.getMessage();
			}
		}


		return ctx;

	}

	/**
	 * @description Incrementa di 1 il campo MaxT delle chiamate KO. Serve alla gestione di UFF_INSERIMENTO, quando il batch deve fare SOLO UN altro tentativo
	 * @author Raffaele Prudenzano | 8/1/2020
	 * @param myList
	 * @return void
	 **/
	public static Case increaseMaxTForKOCallouts(Case theCase) {

		if(theCase.Esito__c == null) {
			theCase = [Select Esito__c from Case where Id = :theCase.Id];
		}

		List<PV3824CpayCredenzialiContext> myList = deserializeString(theCase.Esito__c);
		for(PV3824CpayCredenzialiContext ctx :myList) {
			if(ctx.lRes == 'KO') {
				ctx.maxT = ctx.maxT + 1;
			}
		}
		theCase.Esito__c = serializeWithoutFields(myList);
		return theCase;
	}

	/**
	 * @description Metodo che ritorna KO se è presente almeno un KO, altrimenti ritorna OK
	 * @author Raffaele Prudenzano | 23/12/2019
	 * @param myList
	 * @return String
	 **/
	public static String getGlobalResult(List<PV3824CpayCredenzialiContext> myList) {
		for(PV3824CpayCredenzialiContext ctx :myList) {
			if(ctx.lRes == 'KO') {
				return 'KO';
			}
		}
		return 'OK';
	}

	/**
	 * @description Metodo usato al salvataggio del case per rimuovere campi non necessari
	 * @author Raffaele Prudenzano | 20/12/2019
	 * @param myList
	 * @return String
	 **/
	public static String serializeWithoutFields(List<PV3824CpayCredenzialiContext> myList) {

		List<Map<String, Object>> aMapList = new List<Map<String, Object>>();
		for(PV3824CpayCredenzialiContext c :myList) {
			Map<String, Object> aMap = (Map<String, Object>) JSON.deserializeUntyped(JSON.serialize(c));
			aMap.remove('dRes');
			aMap.remove('rec');

			aMapList.add(aMap);
		}

		return JSON.serialize(aMapList);
	}

	/**
	 * @description Metodo usato dal batch per recuperare il contesto delle chiamate salvato nel case
	 * @author Raffaele Prudenzano | 20/12/2019
	 * @param s
	 * @return List<PV3824CpayCredenzialiContext>
	 **/
	public static List<PV3824CpayCredenzialiContext> deserializeString(String s) {

		List<PV3824CpayCredenzialiContext> ctxList = (List<PV3824CpayCredenzialiContext>) JSON.deserialize(s, List<PV3824CpayCredenzialiContext>.class);
		return ctxList;

	}

	/**
	 * @description Metodo che serve a estrapolare SYS o CAR in base alla logica del routing PV. Se ho almeno un KO per il quale numT<maxT allora scrivo SYS, se ho tutti OK scrivo GES, altrimenti scrivo CAR
	 * @author Raffaele Prudenzano | 23/12/2019
	 * @param myList
	 * @return String
	 **/
	public static String findNextStep(List<PV3824CpayCredenzialiContext> myList) {
		if(getGlobalResult(myList) == 'OK') {
			return 'GES';
		} else {
			for(PV3824CpayCredenzialiContext ctx :myList) {
				if(ctx.lRes == 'KO' && ctx.numT < ctx.maxT) {
					return 'SYS';
				}
			}
			return 'CAR';
		}
	}

	/**
	 * @description Aggiorna il case con i campi che necessari a gestirlo in seguito
	 * @author Raffaele Prudenzano | 23/12/2019
	 * @param casoPV
	 * @param myList
	 * @return Case
	 **/
	public static Case aggiornaCasoPV(Case casoPV, List<PV3824CpayCredenzialiContext> myList) {
		// In Esito__c serializzo il mio contesto relativo a ogni chiamata
		casoPV.Esito__c = serializeWithoutFields(myList);

		// In Cod_Esito__c salvo il risultato globale, che servirà al PV Router
		casoPV.Cod_Esito__c = getGlobalResult(myList);

		// In param_step__c salvo SYS se il case deve essere ancora sospeso, CAR se deve passare a caricese. Servirà al PV Router e al batch
		// La logica è: se ho almeno un KO per il quale numT<maxT allora scrivo SYS, se ho tutti KO scrivo CAR, se ho tutti OK scrivo GES
		casoPV.param_step__c = findNextStep(myList);
		System.debug('casoPV.param_step__c: ' + casoPV.param_step__c);
		if(casoPV.param_step__c == 'CAR') {
			System.debug('casoPV.param_step__c== CAR: ' + casoPV.param_step__c == 'CAR');
			casoPV.Status = CaseUtils.DA_PROCESSARE;
		}
		return casoPV;
	}





}