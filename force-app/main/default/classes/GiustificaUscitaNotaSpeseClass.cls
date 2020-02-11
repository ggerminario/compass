public with sharing class GiustificaUscitaNotaSpeseClass {

	@AuraEnabled
	public static InitWrapperService initApexService(SFA_NotaSpese__c theNotaSpese,Date dataTimbrature){
        
		User currentUser = getCurrentUser();
		//List<Account> dealerList = getDealers(theNotaSpese);
		//List<Map<String,String>> autoPicklist = getAutoPicklist();
		//List<String> indirizziList = new List<String>();
		/*****
		for(Account dealer : dealerList){
			if(String.isNotBlank(dealer.ShippingStreet) && String.isNotBlank(dealer.ShippingCity))
				indirizziList.add(dealer.ShippingStreet + ' ' + dealer.ShippingCity);
		}
		CalcolaDistanzeRequest request = new CalcolaDistanzeRequest();
		request.calcolaDistanzeRequest = new CalcolaDistanzeRequest.CalcolaDistanzeRequestInner();
		request.calcolaDistanzeRequest.indirizzoFiliale = theNotaSpese.Branch__r.ShippingStreet + theNotaSpese.Branch__r.ShippingCity;
		request.calcolaDistanzeRequest.elencoIndirizziIntermedi = indirizziList;
        
		CalcolaDistanzeResponse distanzaResponse = getKmPercorsi(request);
		*****/
		InitWrapperService iW = new InitWrapperService(null,null,dataTimbrature,null,currentUser);
		System.debug('timbratureList-->'+iw.timbratureList)	;
		return iW; 
	}
	
	@AuraEnabled
	public static InitWrapper initApex(SFA_NotaSpese__c theNotaSpese,Date dataTimbrature){
        
		User currentUser = getCurrentUser();
		List<Account> dealerList = getDealers(theNotaSpese);
		List<Map<String,String>> autoPicklist = getAutoPicklist();
		List<String> indirizziList = new List<String>();
		for(Account dealer : dealerList){
			if(String.isNotBlank(dealer.ShippingStreet) && String.isNotBlank(dealer.ShippingCity))
				indirizziList.add(dealer.ShippingStreet + ' ' + dealer.ShippingCity);
		}
		CalcolaDistanzeRequest request = new CalcolaDistanzeRequest();
		request.calcolaDistanzeRequest = new CalcolaDistanzeRequest.CalcolaDistanzeRequestInner();
		request.calcolaDistanzeRequest.indirizzoFiliale = theNotaSpese.Branch__r.ShippingStreet + theNotaSpese.Branch__r.ShippingCity;
		request.calcolaDistanzeRequest.elencoIndirizziIntermedi = indirizziList;
        
		CalcolaDistanzeResponse distanzaResponse = getKmPercorsi(request);
		
		InitWrapper iW = new InitWrapper(dealerList,distanzaResponse,dataTimbrature,autoPicklist,currentUser);
		System.debug('timbratureList-->'+iw.timbratureList)	;
		return iW; 
	}

	@AuraEnabled
	public static NotaSpeseZucchettiResponse sendNotaSpese(SFA_NotaSpese__c theNotaSpese,String theWrapperJson){
		System.debug('---sendNotaSpese');
		InitWrapper theWrapper = (InitWrapper)JSON.deserialize(theWrapperJson,InitWrapper.Class);
		System.debug(theWrapper);
		NotaSpeseZucchettiRequest requestNotaSpese = createNotaSpeseRequest(theNotaSpese,theWrapper);
		/*
		if (theNotaSpese.TipoAuto__c == 'F')
			theNotaSpese.Status__c = 'Da Approvare';
		else	
			theNotaSpese.Status__c = 'Chiusa';
        */
        theNotaSpese.Status__c = 'Da Approvare';
		
		System.debug('--sendNotaSpese invoco servizio');
		NotaSpeseZucchettiResponse response = NotaSpeseZucchettiInvoker.invoke(requestNotaSpese);
		//controllo del risultato del servizio
		if(response.resultCode>0) throw new AuraHandledException('Errore:  '+ response.resultMessage);
		else if(response.creaNotaSpeseZucchettiResponse!=null && response.creaNotaSpeseZucchettiResponse.esito=='KO') throw new AuraHandledException(response.creaNotaSpeseZucchettiResponse.descerr);						
		
		//procedo con il salvataggio della nota spese
		try{
			update theNotaSpese;
		}catch(DmlException e){
			throw new AuraHandledException(e.getDmlMessage(0));		
		}catch(Exception e){
			throw new AuraHandledException(e.getMessage());
		}

		return response;
	}

	private static NotaSpeseZucchettiRequest createNotaSpeseRequest(SFA_NotaSpese__c theNotaSpese,InitWrapper theWrapper){
		DateTime dtDate = theNotaSpese.Date__c;
		DateTime dtOraInizioUscita = DateTime.newInstance(2000, 01, 01, theNotaSpese.OraInizioUscita__c.hour(), theNotaSpese.OraInizioUscita__c.minute(), 00);
		DateTime dtOraFineUscita = DateTime.newInstance(2000, 01, 01, theNotaSpese.OraFineUscita__c.hour(), theNotaSpese.OraFineUscita__c.minute(), 00);

		NotaSpeseZucchettiRequest requestNotaSpese = new NotaSpeseZucchettiRequest();
		//requestNotaSpese.creaNotaSpeseZucchettiRequest.codiceUtente = theWrapper.currentUser.Alias;
		requestNotaSpese.creaNotaSpeseZucchettiRequest.idCompany = theWrapper.datiUtenteZucchetti.idCompany;
		requestNotaSpese.creaNotaSpeseZucchettiRequest.idEmploy = theWrapper.datiUtenteZucchetti.idEmploy;
		requestNotaSpese.creaNotaSpeseZucchettiRequest.pcodestrdl = '';
		requestNotaSpese.creaNotaSpeseZucchettiRequest.pcodestsub = '';
		requestNotaSpese.creaNotaSpeseZucchettiRequest.pcodfiscale = '';
		requestNotaSpese.creaNotaSpeseZucchettiRequest.panno = theNotaSpese.Date__c.year()+'.0';
		requestNotaSpese.creaNotaSpeseZucchettiRequest.pmese = theNotaSpese.Date__c.month()+'.0';
		requestNotaSpese.creaNotaSpeseZucchettiRequest.pidstateini = 'IT';
		requestNotaSpese.creaNotaSpeseZucchettiRequest.pidcityini = theNotaSpese.Branch__r.ShippingPostalCode;
		requestNotaSpese.creaNotaSpeseZucchettiRequest.pdataini = dtDate.format('yyyyMMdd');
		//requestNotaSpese.creaNotaSpeseZucchettiRequest.poraini = theNotaSpese.OraInizioUscita__c.hour().format() +':'+ theNotaSpese.OraInizioUscita__c.minute().format();
		requestNotaSpese.creaNotaSpeseZucchettiRequest.poraini = dtOraInizioUscita.format('HH:mm');
		requestNotaSpese.creaNotaSpeseZucchettiRequest.pidstatefin = 'IT';
		requestNotaSpese.creaNotaSpeseZucchettiRequest.pidcityfin = theNotaSpese.Branch__r.ShippingPostalCode;
		//requestNotaSpese.creaNotaSpeseZucchettiRequest.pdatafin = theNotaSpese.Date__c.year() + theNotaSpese.Date__c.month().format() + theNotaSpese.Date__c.day().format();
		requestNotaSpese.creaNotaSpeseZucchettiRequest.pdatafin = dtDate.format('yyyyMMdd');
		//requestNotaSpese.creaNotaSpeseZucchettiRequest.porafin = theNotaSpese.OraFineUscita__c.hour().format() +':'+ theNotaSpese.OraFineUscita__c.minute().format();
		requestNotaSpese.creaNotaSpeseZucchettiRequest.porafin =  dtOraFineUscita.format('HH:mm');
		requestNotaSpese.creaNotaSpeseZucchettiRequest.pmotitr = '08';
		requestNotaSpese.creaNotaSpeseZucchettiRequest.pdefore = theWrapper.currentUser.Profile.Name != 'Branch Manager' ? 'S' : 'N';
		requestNotaSpese.creaNotaSpeseZucchettiRequest.pannotazioni = '';
		if(theNotaSpese.TipoAuto__c == 'F' || theNotaSpese.TipoAuto__c == 'NA' || theNotaSpese.TipoAuto__c == 'NAA')
			requestNotaSpese.creaNotaSpeseZucchettiRequest.pitinerario = '';
		else
			requestNotaSpese.creaNotaSpeseZucchettiRequest.pitinerario = theNotaSpese.Tratta__c;
		requestNotaSpese.creaNotaSpeseZucchettiRequest.ptipoauto = tipoAutoTranscodingMap.get(theNotaSpese.TipoAuto__c);
		requestNotaSpese.creaNotaSpeseZucchettiRequest.pmodauto = getModAuto(theNotaSpese.TipoAuto__c,theWrapper.datiUtenteZucchetti);
		requestNotaSpese.creaNotaSpeseZucchettiRequest.ptiporimb = getTipoRimborso(theWrapper.dealerList,theNotaSpese.Branch__r);
		requestNotaSpese.creaNotaSpeseZucchettiRequest.pantarga = theNotaSpese.TargaVeicolo__c;
		requestNotaSpese.creaNotaSpeseZucchettiRequest.pdistanza = String.valueOf(theWrapper.kmPercorsi);
		if(theNotaSpese.TipoAuto__c == 'P')
			requestNotaSpese.creaNotaSpeseZucchettiRequest.pnotekm = theNotaSpese.TargaVeicolo__c;
		else
			requestNotaSpese.creaNotaSpeseZucchettiRequest.pnotekm = noteKmTranscodingMap.get(theNotaSpese.TipoAuto__c);

		return requestNotaSpese;

	}


	private static User getCurrentUser(){
        String utenteId = UserInfo.getUserId();
        return [SELECT FirstName, LastName,Id,Name, Alias,DefaultQueueId__c,Profile.Name FROM User WHERE Id =: utenteId];
    }

	private static String getTipoRimborso(List<Account> dealerList,Account branch){
		String tipoRimborso = '1';
		for(Account dealer : dealerList){

			if(dealer.ShippingCity != branch.ShippingCity){
				tipoRimborso = '2';
				break;
			}
		}

		return tipoRimborso;

	}

	private static String getModAuto(String tipoAuto,OCSrecuperaDatiUtenteZucchettiResponse.recuperaDatiUtenteZucchettiResponse datiUtenteZucchetti){
		Map<String,String> modAutoTranscodingMap = new Map<String,String>{
		'F' => '00',
		'P' => '00',
		'FA' => '00',
		'NAA' => '',
		'NA' => ''
		};

		if(tipoAuto == 'A')
			return datiUtenteZucchetti.modelloAuto;
		else
			return modAutoTranscodingMap.get(tipoAuto);

	}

	private static List<Account> getDealers(SFA_NotaSpese__c theNotaSpese){
		
		List<SFA_PianificaAttivita__c> attivitaPianificateList = [SELECT Id, Dealer__r.Name ,Dealer__r.OCS_External_Id__c,Dealer__r.ShippingStreet,Dealer__r.ShippingCity 
				FROM SFA_PianificaAttivita__c 
				WHERE SFA_Nota_Spese__c =: theNotaSpese.Id];

		List<Account> dealerList = new List<Account>();
		for(SFA_PianificaAttivita__c pa : attivitaPianificateList){
			dealerList.add(pa.Dealer__r);
		}

		return dealerList;

	}

	private static List<Map<String,String>> getAutoPicklist(){
        Schema.DescribeFieldResult fieldResult = SFA_NotaSpese__c.TipoAuto__c.getDescribe();
        return (List<Map<String,String>>) JSON.deserialize(JSON.serialize(fieldResult.getPicklistValues()),List<Map<String,String>>.Class);
    }

	private static CalcolaDistanzeResponse getKmPercorsi(CalcolaDistanzeRequest request){

        CalcolaDistanzeResponse response = CalcolaDistanzeInvoker.invoke(request);
        return response;
    }

	public class InitWrapper{
		@AuraEnabled
		public List<Account> dealerList;
		@AuraEnabled
		public Decimal kmPercorsi;
		@AuraEnabled
		public OCSrecuperaDatiUtenteZucchettiResponse.recuperaDatiUtenteZucchettiResponse datiUtenteZucchetti;
		@AuraEnabled
		public OCSrecuperaTimbratureZucchettiResponse.elencoTimbrature[] timbratureList;
		@AuraEnabled
		public List<Map<String,String>> autoPicklist;
		@AuraEnabled
		public User currentUser;

		public InitWrapper(List<Account> dealerList,CalcolaDistanzeResponse distanzaResponse,Date dataTimbrature,List<Map<String,String>> autoPicklist,User currentUser){
			this.dealerList= dealerList;
			
			this.kmPercorsi= distanzaResponse.calcolaDistanzeResponse.distanzaTotale != null ? Decimal.valueOf(Double.valueOf(distanzaResponse.calcolaDistanzeResponse.distanzaTotale)/1000).setscale(2) : 0;
			/**
			this.datiUtenteZucchetti = OCSrecuperaDatiUtenteZucchettiInvoker.callRecuperaDatiUtenteZucchetti(currentUser.Alias).recuperaDatiUtenteZucchettiResponse;
			if(datiUtenteZucchetti == null){
				AuraHandledException e= new AuraHandledException('utente non trovato');
				e.setMessage('utente non trovato');
				throw e;
        	}
			OCSrecuperaTimbratureZucchettiResponse responseTimbrature = OCSrecuperaTimbratureZucchettiInvoker.callrecuperaTimbratureZucchetti(this.datiUtenteZucchetti.idCompany, this.datiUtenteZucchetti.idEmploy, dataTimbrature);
			if(responseTimbrature == null || responseTimbrature.recuperaTimbratureZucchettiResponse == null || responseTimbrature.recuperaTimbratureZucchettiResponse.elencoTimbrature == null){
				AuraHandledException e= new AuraHandledException('Timbratura utente non trovato');
				e.setMessage('Timbratura non disponibile per la data '+dataTimbrature);
				throw e;
        	}
			this.timbratureList = responseTimbrature.recuperaTimbratureZucchettiResponse.elencoTimbrature;
			*******/
			this.autoPicklist = autoPicklist;
			this.currentUser = currentUser;
		}
	}


	public class InitWrapperService{
		
		@AuraEnabled
		public OCSrecuperaDatiUtenteZucchettiResponse.recuperaDatiUtenteZucchettiResponse datiUtenteZucchetti;
		@AuraEnabled
		public OCSrecuperaTimbratureZucchettiResponse.elencoTimbrature[] timbratureList;	
		@AuraEnabled
		public User currentUser;	
		@AuraEnabled
		public String errorMessage='';

		public InitWrapperService(List<Account> dealerList,CalcolaDistanzeResponse distanzaResponse,Date dataTimbrature,List<Map<String,String>> autoPicklist,User currentUser){
			//this.dealerList= dealerList;
			//this.kmPercorsi= distanzaResponse.calcolaDistanzeResponse.distanzaTotale != null ? Decimal.valueOf(Double.valueOf(distanzaResponse.calcolaDistanzeResponse.distanzaTotale)/1000).setscale(2) : 0;
			//currentUser.Alias = 'CU2912';
			//currentUser.Alias = 'CU1010';
			this.datiUtenteZucchetti = OCSrecuperaDatiUtenteZucchettiInvoker.callRecuperaDatiUtenteZucchetti(currentUser.Alias).recuperaDatiUtenteZucchettiResponse;
			if(datiUtenteZucchetti == null){
				AuraHandledException e= new AuraHandledException('utente non trovato');
				e.setMessage('utente non trovato');
				throw e;
        	}
			OCSrecuperaTimbratureZucchettiResponse responseTimbrature = OCSrecuperaTimbratureZucchettiInvoker.callrecuperaTimbratureZucchetti(this.datiUtenteZucchetti.idCompany, this.datiUtenteZucchetti.idEmploy, dataTimbrature);
			if(responseTimbrature == null || responseTimbrature.recuperaTimbratureZucchettiResponse == null || responseTimbrature.recuperaTimbratureZucchettiResponse.elencoTimbrature == null){
				/**MC 20200124 no eccezione ma solo messaggio ***
				AuraHandledException e= new AuraHandledException('Timbratura utente non trovato');
				e.setMessage('Timbratura non disponibile per la data '+dataTimbrature);
				throw e;
				**************/
				errorMessage='Timbratura non disponibile per la data '+dataTimbrature;
        	}
			else 
				this.timbratureList = responseTimbrature.recuperaTimbratureZucchettiResponse.elencoTimbrature;
			//this.autoPicklist = autoPicklist;
			this.currentUser = currentUser;
		}


	}

	private static Map<String,String> tipoAutoTranscodingMap = new Map<String,String>{
		'F' => '',
		'P' => 'P',
		'A' => 'A',
		'FA' => 'A',
		'NAA' => '',
		'NA' => ''
	};

	private static Map<String,String> noteKmTranscodingMap = new Map<String,String>{
		'F' => 'Utilizzo auto filiale senza nota spese',
		'A' => 'Utilizzo auto aziendale',
		'FA' => 'Utilizzo auto filiale con allegato',
		'NAA' => 'Uscita senza auto (con allegato)',
		'NA' => 'Uscita senza auto'
	};

}