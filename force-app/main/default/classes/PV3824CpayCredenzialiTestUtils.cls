/**
 * @File Name          : PV3824CpayCredenzialiTestUtils.cls
 * @Description        :
 * @Author             : Raffaele Prudenzano
 * @Group              :
 * @Last Modified By   : Raffaele Prudenzano
 * @Last Modified On   : 15/1/2020, 12:20:54
 * @Modification Log   :
 * Ver       Date            Author                  Modification
 * 1.0    14/1/2020   Raffaele Prudenzano     Initial Version
 **/
@isTest
public with sharing class PV3824CpayCredenzialiTestUtils {

	/*
	 Variabili prese in prestito da PV3824CpayCredenzialiContext per alleggerire il codice
	 */

	public static final String userTipoBusta = PV3824CpayCredenzialiContext.userTipoBusta;
	public static final String pinTipoBusta = PV3824CpayCredenzialiContext.pinTipoBusta;
	public static final String azioneAnnulloBusta = PV3824CpayCredenzialiContext.azioneAnnulloBusta;
	public static final String azioneRiemissione = PV3824CpayCredenzialiContext.azioneRiemissione;

	/**
	// * Riporto per velocità tutti i codici dati alle tipologie e il loro significato, per coprirle nei test

	 myForm.sottotipologiaMdt.QualifiedApiName;
	 'PV_SUB_127' // Blocco credenziali;
	 'PV_SUB_129' // Riemissione completa (User via email e PIN via posta);
	 'PV_SUB_130' // Riemissione completa (User e PIN via posta);
	 'PV_SUB_131' // Riemissione PIN via posta;
	 'PV_SUB_132' // Riemissione User via posta;
	 'PV_SUB_133' // Riemissione User via mail;
	 'PV_SUB_134' // Riemissione PIN via sms;
	 'PV_SUB_135' // Riemissione completa (User via email e PIN via sms);
	 'PV_SUB_136' // Riemissione completa (User via posta e PIN via sms);
	 * non riconosciuti // PV_SUB_128 Azzeramento Credenziali non supportato da specifiche;
	 */

	static String Categoria = '3824';

	// MOCK delle risposte per ogni servizio
	public final String recuperaDatiPostvenditaResponseOK = '{"resultCode":0,"resultMessage":"Ok","pratiche":[{"numPratica":"800000329783","codCliente":"9529124","abi":"0","cab":"0","numConto":"","iban":"","statoPratica":"90","tipoPagamento":"BP","prodotto":"4D","filiale":"223","dataEstinzione":"","tipoPratica":"CO","dataCaricamento":833925626454,"pan":"","convenzionato":"212217","puntoVendita":"0","venditore":"0","agente":"7085406","subAgente":"272166","flagRecupero":"N","classifRecupero":null,"societa":"Linea","elencoCoobbligati":null,"codStatoPratica":"90","codAttributoPratica":"","desStatoPratica":"Estinta","desAttributoPratica":"","codRecuperatore":"","desRecuperatore":"","canale":""}],"cliente":[{"cognome":"UTMOBZE","codCliente":"9529151","nome":"LERRIO","dataNascita":"0","luogoNascita":"","provNascita":"","sesso":"M","codFiscale":"","piva":"","indirizzo":"VIAROMA4","cap":"16149","localita":"GENOVA","provincia":"GE","paeseEstero":"086","email":"","tipoDocumento":"","numDocumento":"","ufficioRilascio":"","luogoRilascio":"","provRilascio":"","dataRilascio":"0","denominazioneAzienda":"UTMOBZELERRIO","formaGiuridica":"","tipoAnagrafica":"P","dataScadenza":"0","telefonoCasa":"010475464","telCellulare":"","tipoRapporto":"","dataDepennamento":"0","ndg":"0"}]}';

	public final String recuperaRapportoHBCpayResponseOK = '{"resultCode":0,"resultMessage":"Ok","recuperaRapportoHBCpayResponse":{"rapportoHB":"19070180927","isDipendente":"N"}}';

	public final String riemissioneCredenzialiResponseOK = '{"resultCode":0,"resultMessage":"Ok","cseRiemissioneCredenzialiResponse":{"esito":"OK","messaggio":"RichiestariemissionePinpermezzodiSMSalrecapito3498307332Esito:PositivoOK"}}';
	public final String riemissioneCredenzialiResponseKO = '{"resultCode":0,"resultMessage":"Ok","cseRiemissioneCredenzialiResponse":{"esito":"KO","messaggio":"RichiestariemissionePinpermezzodiSMSalrecapito3498307332Esito:NegativoBustaIB101NessunaBustadaannullareditipo"}}';

	public final String annulloBustaResponseOK = '{"resultCode":0,"resultMessage":"Ok","cseAnnulloBustaResponse":{"esito":"OK","messaggio":"RichiestaannullocredenzialiEsito:PositivoNessunaBustadaannullareditipoUserNessunaBustadaannullareditipoPin"}}';
	public final String annulloBustaResponseKO = '{"resultCode":0,"resultMessage":"Ok","cseAnnulloBustaResponse":{"esito":"KO","messaggio":"RichiestaannullocredenzialiEsito:NegativoNessunaBustadaannullareditipoUserNessunaBustadaannullareditipoPin"}}';

	public PV3824CpayCredenzialiTestUtils() {
	}

	/*
	 Metodi utils
	 */

	public Case recuperaUltimoCase(String codCliente) {
		Case c = [Select id, caseNumber, Cip_Cliente__c, Esito__c from Case where Cip_Cliente__c = :codCliente and CategoriaExternalId__c = :categoria order by caseNumber desc limit 1] [0];
		System.debug('recuperaUltimoCase: ' + c);
		return c;
	}

	public void assertAllNumTEqualsTo(Case theCase, Integer expectedNumT) {
		if(theCase.Esito__c == null) {
			theCase = [Select Esito__c from Case where Id = :theCase.Id];
		}
		List<PV3824CpayCredenzialiContext> myList = PV3824CpayCredenzialiContext.deserializeString(theCase.Esito__c);
		for(PV3824CpayCredenzialiContext ctx :myList) {
			System.assertEquals(expectedNumT, ctx.numT);
		}
	}

	/**
	 * @description Asserisce che numT sia uguale al numero passato. Idx DEVE essere o 0 o 1
	 * @author Raffaele Prudenzano | 14/1/2020
	 * @param theCase
	 * @param idx
	 * @param expectedNumT
	 * @return void
	 **/
	public void assertNumTEqualsTo(Case theCase, Integer idx, Integer expectedNumT) {
		if(idx != 0 && idx != 1) {
			System.debug('idx può essere 0 o 1! actual idx: ' + idx);
			return;
		}

		if(theCase.Esito__c == null) {
			theCase = [Select Esito__c from Case where Id = :theCase.Id];
		}
		List<PV3824CpayCredenzialiContext> myList = PV3824CpayCredenzialiContext.deserializeString(theCase.Esito__c);
		Integer i = 0;
		for(PV3824CpayCredenzialiContext ctx :myList) {
			if(i == idx) {
				System.assertEquals(expectedNumT, ctx.numT);
			}
		}
	}

	/*
	 Costruttori case
	 */

	public void creaNCases(PV3824CpayCredenziali.PV3824CpayCredenzialiForm myForm, Integer nCases) {
		// Il primo case lo aggiungo confermando, così che parta la routine per l aggiornamento degli account
		PV3824CpayCredenziali.conferma(myForm);

		Case ultimoCaseInserito = [select CategoriaExternalId__c, AccountId, Cip_Cliente__c, status from case where Cip_Cliente__c = :myForm.cliente.codCliente order by caseNumber desc limit 1] [0];

		// I restanti nCases-1 li inserisco in maniera bulk, così da evitare di raggiungere i governor limits
		List<Case> caseList = new List<Case>();
		for(Integer i = 0; i < nCases - 1; i ++) {
			caseList.add(createSampleCase(myForm, ultimoCaseInserito));
		}
		if(caseList.size() > 0) {
			insert caseList;
		}
	}

	private Case createSampleCase(PV3824CpayCredenziali.PV3824CpayCredenzialiForm myForm, Case ca) {
		Case c = new PV3824CpayCredenziali().preparaCasePostVenditaCommon((PVForm) myForm, AccountUtils.makeAccount(myForm.cliente, 'Compass'));
		c.AccountId = ca.AccountId;
		return c;
	}

	/*
	 Costruttori mock
	 */

	public Map<String, List<String>> createAllOKResponses() {
		Map<String, List<String>> serviceIdResponseMap = new Map<String, List<String>>();
		serviceIdResponseMap.put('recuperaRapportoHBCpay', new List<String>{ recuperaRapportoHBCpayResponseOK });
		serviceIdResponseMap.put('cseRiemissioneCredenziali', new List<String>{ riemissioneCredenzialiResponseOK });
		serviceIdResponseMap.put('cseAnnulloBusta', new List<String>{ annulloBustaResponseOK });
		return serviceIdResponseMap;
	}

	public Map<String, List<String>> createAllOKDoubleResponses() {
		Map<String, List<String>> serviceIdResponseMap = new Map<String, List<String>>();
		serviceIdResponseMap.put('recuperaRapportoHBCpay', new List<String>{ recuperaRapportoHBCpayResponseOK, recuperaRapportoHBCpayResponseOK });
		serviceIdResponseMap.put('cseRiemissioneCredenziali', new List<String>{ riemissioneCredenzialiResponseOK, riemissioneCredenzialiResponseOK });
		serviceIdResponseMap.put('cseAnnulloBusta', new List<String>{ annulloBustaResponseOK, annulloBustaResponseOK });
		return serviceIdResponseMap;
	}

	/*
	 Costruttori form
	 */

	public PV3824CpayCredenziali.PV3824CpayCredenzialiForm creaForm() {
		PVtestFactory pVtestFactory = new PVtestFactory();

		PV3824CpayCredenziali.PV3824CpayCredenzialiForm myForm = new PV3824CpayCredenziali.PV3824CpayCredenzialiForm();
		myForm = (PV3824CpayCredenziali.PV3824CpayCredenzialiForm) pVtestFactory.initForm(Categoria, myForm);
		return myForm;
	}

	public PV3824CpayCredenziali.PV3824CpayCredenzialiForm creaForm(String sottotipologia) {
		PV3824CpayCredenziali.PV3824CpayCredenzialiForm myForm = creaForm();

		if(sottotipologia != null && sottotipologia.trim() != '') {
			PostvenditaConfig_subtype__mdt sottotipologiaMdt = new PostvenditaConfig_subtype__mdt();
			sottotipologiaMdt.QualifiedApiName = sottotipologia;
			myForm.sottotipologiaMdt = sottotipologiaMdt;
		}

		return myForm;
	}

	public PV3824CpayCredenziali.PV3824CpayCredenzialiForm creaForm(String sottotipologia, String codCliente) {
		PV3824CpayCredenziali.PV3824CpayCredenzialiForm myForm = creaForm(sottotipologia);
		myForm.cliente.codCliente = codCliente;
		return myForm;
	}

	
	/**
	* @description Costruttore List<PV3824CpayCredenzialiContext>
	* @author Raffaele Prudenzano | 15/1/2020 
	* @param codSottotipologia 
	* @param numTs 
	* @return List<PV3824CpayCredenzialiContext> 
	**/
	public List<PV3824CpayCredenzialiContext> creaTestContext(String codSottotipologia, List<Integer> numTs) {
		List<PV3824CpayCredenzialiContext> myList = new List<PV3824CpayCredenzialiContext>();

		switch on codSottotipologia {
			when 'PV_SUB_127' {
				// Blocco credenziali
				myList.add(new PV3824CpayCredenzialiContext(azioneAnnulloBusta, 2));
			}

			when 'PV_SUB_129' {
				// Riemissione completa (User via email e PIN via posta)
				myList.add(new PV3824CpayCredenzialiContext(azioneRiemissione, 'E', userTipoBusta, '', 5));
				myList.add(new PV3824CpayCredenzialiContext(azioneRiemissione, 'P', pinTipoBusta, 5));
			}

			when 'PV_SUB_130' {
				// Riemissione completa (User e PIN via posta)
				myList.add(new PV3824CpayCredenzialiContext(azioneRiemissione, 'P', userTipoBusta, 5));
				myList.add(new PV3824CpayCredenzialiContext(azioneRiemissione, 'P', pinTipoBusta, 5));
			}

			when 'PV_SUB_131' {
				// Riemissione PIN via posta
				myList.add(new PV3824CpayCredenzialiContext(azioneRiemissione, 'P', userTipoBusta, 5));
			}

			when 'PV_SUB_132' {
				// Riemissione User via posta
				myList.add(new PV3824CpayCredenzialiContext(azioneRiemissione, 'P', userTipoBusta, 5));
			}

			when 'PV_SUB_133' {
				// Riemissione User via mail
				myList.add(new PV3824CpayCredenzialiContext(azioneRiemissione, 'E', userTipoBusta, '', 5));
			}

			when 'PV_SUB_134' {
				// Riemissione PIN via sms
				myList.add(new PV3824CpayCredenzialiContext(azioneRiemissione, 'S', pinTipoBusta, '', 5));
			}

			when 'PV_SUB_135' {
				// Riemissione completa (User via email e PIN via sms)
				myList.add(new PV3824CpayCredenzialiContext(azioneRiemissione, 'E', userTipoBusta, '', 3));
				myList.add(new PV3824CpayCredenzialiContext(azioneRiemissione, 'S', pinTipoBusta, '', 3));
			}

			when 'PV_SUB_136' {
				// Riemissione completa (User via posta e PIN via sms)
				myList.add(new PV3824CpayCredenzialiContext(azioneRiemissione, 'P', userTipoBusta, 5));
				myList.add(new PV3824CpayCredenzialiContext(azioneRiemissione, 'S', pinTipoBusta, '', 5));
			}
		}
		try{
			// Assegno manualmente il numT in base alla lista che passo come parametro, in modo da poter fare agilmente i test nelle varie situazioni
			for(Integer i = 0; i < myList.size(); i ++) {
				myList[i].numT = numTs [i];
			}
			return myList;
		} catch(Exception e) {
			return new List<PV3824CpayCredenzialiContext>();
		}
	}

	/*
	 Wrapper serializzatore/deserializzatore esito
	 */

	public String serialize(List<PV3824CpayCredenzialiContext> myList) {
		return PV3824CpayCredenzialiContext.serializeWithoutFields(myList);
	}

	public List<PV3824CpayCredenzialiContext> deserialize(String s){
		return PV3824CpayCredenzialiContext.deserializeString(s);
	}



}