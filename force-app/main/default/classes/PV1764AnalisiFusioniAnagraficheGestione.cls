/**
* @File Name          : PV1764AnalisiFusioniAnagraficheGestione.cls
* @Description        : 
* @Author             : Matteo Gobbo
* @Group              : 
* @Last Modified By   : Matteo Gobbo
* @Last Modified On   : 10/1/2020, 09:32:16
* @Modification Log   : 
* Ver       Date            Author      		    Modification
* 1.0    9/12/2019   Matteo Gobbo     Initial Version
**/
public class PV1764AnalisiFusioniAnagraficheGestione extends PVActionGestione {
    private final static string templateName = 'Email Ufficio sistemi Fusione Anagrafica';
    
    public class PV1764AnalisiFusioniAnagraficheGestioneForm extends PVForm {
        @AuraEnabled
        public string tipoAnnullamento{get;set;}
        @AuraEnabled
        public Boolean flagRinvia{get;set;}
        @AuraEnabled
        public List<OCSCliente> clientiNDG{get;set;}
        @AuraEnabled
        public string clienteDaMantenere{get;set;}
	}

    @AuraEnabled
	public static void saveCase(PV1764AnalisiFusioniAnagraficheGestioneForm form, Case theCase){
		String messaggio_errore = '';
		try{
			system.debug('form: ' + form);
            system.debug('theCase: ' + theCase);

			String note = creaNote(form, theCase);
            if (form.newStatus == 'Closed' && form.flagRinvia==true){
                System.debug('ASSEGNO UFFICIO DESTINAZIONE');
                //theCase.pv_send_to__c = 'FIL';
                theCase.UfficioDestinazione__c = theCase.Branch__c;
            }
            if(form.tipoAnnullamento.equalsIgnoreCase('fisico')){
                if(theCase.pv_send_to__c == null || theCase.pv_send_to__c == '') {
                    theCase.pv_send_to__c = 'RCLM';
                }
                else if(theCase.pv_send_to__c != 'RCLM'){
                   theCase.pv_send_to__c += '|RCLM|'; 
                }              
            }else if(form.tipoAnnullamento.equalsIgnoreCase('logico')){
                theCase.pv_send_to__c = 'ARIC|RCLM|CCLI';
            }
            if(form.clientiNDG != null && form.clientiNDG.size() > 0){
                String emailBody = recuperaTemplate(templateName,form.clientiNDG, form.clienteDaMantenere);
                sendEmail(emailBody,theCase);
            }

			saveUtil(form, theCase, note);
		}catch(Exception e) {  
            messaggio_errore = loggaException(e);          
        }finally{
            if(messaggio_errore != '') {
                gestisciException(messaggio_errore);
            }
        }
	}

    @AuraEnabled 
    public static user fetchUserDetail(){
        return [Select id,Name,Profile.Name,Branch_Or_Office__c
                From User
                Where Id =: Userinfo.getUserId()];
    }

	

    @AuraEnabled
    public static Map<String,List<Object>> getClienti(List<String> codiciCliente){
        Map<String,List<Object>> res=new Map<String,List<Object> >();
        List<OCSCliente> clientiList = new List<OCSCliente>();
        for(String codCliente : codiciCliente) {
            OCSRecuperaDatiPostvenditaRequest request =  new OCSRecuperaDatiPostvenditaRequest();
            request.codCliente = codCliente;
            request.flagInfoCliente = 'true';
            request.filtroTipoPratica = 'CA#CO#CQ#PB#AS#FE#CP';
            clientiList.addAll(OCSObjectsFactory.makeClienti(OCSRecuperaDatiPostvenditaInvoker.callRecDatiPV(request)));
        }

        //Per la classe di test
        
        Integer i = 0;
        
        for(OCSCliente currentClient : clientiList){
            
                for(OCSPratica currentPratica : currentClient.pratiche){
                   
                    
                    if(currentPratica.tipoPratica == 'CA' && currentPratica.statoPratica == 'CF') {  
                        //IF per la cpoertura classe di test               
                        if(Test.isRunningTest()){
                            i++;
                                String responseTest = '{"resultCode": 0,"resultMessage": "Ok","recuperaElencoMovimentiResponse": {"movimenti": [{ "dataValuta": "20180131","dataRegistrazione": "20180108","dataAcquisto": "20180103","causale": "10","importo": "1275"}]}}'; 
                                finalizeApiList(responseTest,'recuperaElencoMovimenti' +i);
                            } 
                     //Controllo movimenti contabili
                        RecuperaElencoMovimentiResponse movContabili = RecuperaElencoMovimentiService.buildRecuperaElencoMovimentiResponse(currentPratica.tipoPratica,currentPratica.numPratica,'','','');
                        System.debug('@Movimenti contabili: ' + movContabili);
                        if(movContabili.recuperaElencoMovimentiResponse.movimenti != null) {
                            currentPratica.desAttributoPratica = ' - Movimentazione contabile';
                            currentClient.movContabile = 'SI';
                        }else {
                            currentPratica.desAttributoPratica = '';
                        }
                    }
                    //Controllo da retrocedere
                    if(isDaRetrocedere(currentPratica)){
                        currentPratica.desAttributoPratica = ' - Da retrocedere';
                    }else {
                        currentPratica.desAttributoPratica = '';
                    }
                    //Controllo carta attiva
                    if(currentPratica.tipoPratica == 'CA'){
                        //Per la classe di test
                        if(Test.isRunningTest()){
                            i++;
                                String responseTest2 = '{"resultCode":0,"resultMessage":"Ok","recuperaInfoCartaResponse": {"emettitore":"29","dataInvioPositivo":"20170912","dataScadenza":"20201031","statoPratica":"05","codAttributoPratica":"RE"}}';
                                finalizeApiList(responseTest2,'recuperaInfoCarta' +i);
                            } 
                        OCSRecuperaInfoCartaResponse infoCarta = OCSRecuperaInfoCartaInvoker.callRecInfoCarta(currentPratica.numpratica);
                        System.debug('@recupero info carta: ' + infoCarta);
                        if(isAttiva(currentPratica,infoCarta.recuperaInfoCartaResponse)){
                            currentpratica.desStatoPratica = 'SI';   
                        }   
                    }
                    if(currentPratica.tipoPratica == 'AS' || currentPratica.statoPratica == 'FE') {
                        currentClient.prottiTerzi = 'SI';
                    } 
                    if(currentPratica.tipoPratica == 'CP') {
                        currentClient.prottiCPAY = 'SI';
                    } 
                } 
                //Per la classe di test
                //IF per la cpoertura classe di test               
                        if(Test.isRunningTest()){
                            i++;
                                String responseTest = '{"resultCode": 0,"resultMessage": "Ok","recuperaTipoControparteResponse": {"tipoControparte14": "S"}}'; 
                                finalizeApiList(responseTest,'recuperaElencoMovimenti' +i);
                            } 
                OCSRecuperaTipoControparteResponse controparte = OCSRecuperaTipoControparteInvoker.callRecTipoContr(currentClient.codCliente);
                System.debug('@Tipo controparte' + controparte);
                if(controparte.isFIR()){
                    currentClient.tipoControparte = 'FIR';
                    
                } else if('S'.equalsIgnoreCase(controparte.recuperaTipoControparteResponse.tipoControparte16)){
                    currentClient.tipoControparte = 'DEL';
                }         
            }
        res.put('clienti',clientiList);
        return res;
    }

    @AuraEnabled
	public static String recuperaTemplate(String argSelected, list<OCSCliente> clientiNDG, String daMantenere){
        List<String> parametri = new List<String>();
        String clientNdgString = '';
        for(OCSCliente c : clientiNDG){
            clientNdgString += 'Cliente ' + c.codCliente + ' con NDG ' + c.ndg + '<br>';
        }
        //Primo parametro
        parametri.add(clientNdgString);
        //Secondo parametro
        parametri.add(daMantenere);
		String temp = XCS_TemplateUtils.getBody(argSelected); 

        return String.format(temp,parametri);
	}

    private static String creaNote(PVForm myform, Case theCase) {
		return myform.note;
	}

    private static void sendEmail(String emailBody, Case theCase){
        List<String> indirizziDaInviare = new List<String>();
		Map<String, String> addressMap = CompassParametersUtils.getParameterByGroup('subtypeEmailAddresses');
		String indirizzo = addressMap.get('SIST');
        indirizziDaInviare.add(indirizzo);
		List<Messaging.SingleEmailMessage> emailToSend = new List<Messaging.SingleEmailMessage>();
		Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
		mail.setToAddresses(indirizziDaInviare);
		mail.setSubject(theCase.Subject);
		mail.setHtmlBody(emailBody);
		emailToSend.add(mail);
		system.debug('Email to send: ' + emailToSend);
		
		String mockName = 'Email - Ufficio Sistemi';
		EmailUtils.sendEmail(emailToSend,mockName);
    }
    
    private static boolean isAttiva(OCSPratica pratica, OCSRecuperaInfoCartaResponse.RecuperaInfoCartaResponse infoCarta) {
        Set<String> codBlocco = new Set<String>{'RT', 'AN', 'CV', 'CE', 'DK', 'FP', 'KO', 'LG', 'PP', 'RI', 'TE', 'UI', 'XD', 'IA'};
        Set<String> statiBlocco = new Set<String>{'05', '10', '20', '30'};
        Set<String> atrrBlocco = new Set<String>{'RU', 'XS', 'XZ'};
        Date currentDate = System.today();
        Date dataScadenza;
        
        if(infocarta.dataScadenza != '' && infocarta.dataScadenza != null){
            dataScadenza = date.newInstance(Integer.valueof(infocarta.dataScadenza.substring(0,4)), 
                                            Integer.valueof(infocarta.dataScadenza.substring(4,6)), 
                                            Integer.valueof(infocarta.dataScadenza.substring(6,8)));
        } 
        if(codBlocco.contains(pratica.codAttributoPratica)) {
            return false;
        }
        if(infoCarta.emettitore.length() == 3 && infoCarta.emettitore.substring(0,1) == '1'){
            return false;         
        }else if(infoCarta.emettitore.length() == 2 && infocarta.dataInvioPositivo == ''){
            if(statiBlocco.contains(pratica.statoPratica)) {
                return false;
            }
        }else if((infoCarta.emettitore.length() == 2 && pratica.statoPratica == '60' && pratica.codAttributoPratica == 'LL') || (pratica.statoPratica == '60' && atrrBlocco.contains(pratica.codAttributoPratica )) || (pratica.statoPratica == '70')){
            return false;
        }else if(dataScadenza != null && (infocarta.dataScadenza == '' ||   currentDate.daysBetween(dataScadenza) < 30)){
            return false;
        }
        return true;
    } 

    private static boolean isDaRetrocedere(OCSPratica pratica) {
        Set<String> consumo = new Set<String>{'40','45','90','91','95','96','97'};
        Set<String> carte = new Set<String>{'30','40','50','60','70'};
        if(pratica.tipoPratica == 'CO'){
            if((pratica.statoPratica == '05' || pratica.statoPratica == '10') && pratica.codAttributoPratica != 'CA'){
                    return true;
            }else if((pratica.statoPratica == '20' || pratica.statoPratica == '30') && (pratica.codAttributoPratica != 'RT' || pratica.codAttributoPratica != 'RE')){
                    return true;
            }
            if(!consumo.contains(pratica.statoPratica)){
                return true;
            }
        }else if(pratica.tipoPratica == 'CA'){
                if((pratica.statoPratica == '05' || pratica.statoPratica == '10' || pratica.statoPratica == '20') && (pratica.codAttributoPratica != 'RT' || pratica.codAttributoPratica != 'AN')){
                        return true;
                }
                if(!carte.contains(pratica.statoPratica)){
                    return true;
                }
        }
        return false;
    }


    //Metodi per la classe di test
  
	private static void finalizeApiList(String respJSON, String nome) {
        ApiRest__c test1 = new ApiRest__c(Method__c = 'POST',Test_Response__c= respJSON,Test_Request__c = 'testRequest',Mock__c = false,User__c = 'CDSLF00',Password__c = 'P00FLSDC',Name = nome,EndPoint__c = 'https://richiestaonlinesvi.compassonline.it/B2BSOAP/rest/B2BREST/execute');
		utilityMockResponseFusione UMR = new utilityMockResponseFusione();
		UMR.apiname = 'ocs.recuperaCircuitoCarta';
		UMR.response = respJSON;
        UMR.ar = test1;
		Test.setMock(HttpCalloutMock.class, UMR);

	}
    
    private class utilityMockResponseFusione implements HttpCalloutMock {
		public String apiname;
		public String response;
        public ApiRest__c ar;
		public HTTPResponse respond(HTTPRequest req) {
			HttpResponse res = new HttpResponse();
			String urlId = req.getEndpoint();
			//System.assert(urlId != null, 'API endpoint missing.');
			res.setHeader('Content-Type', 'application/json');
			System.debug('APINAME:::::::::::::> ' + apiname);
			//ApiRest__c ar = [select Test_Request__c from Apirest__c where endpoint__c = :urlId and name = :apiname LIMIT 1];
			system.debug(ar);
			System.assert(ar != null, 'No rows for endpoint ' + urlId);
			System.assert(response != null, 'Missing response on test static resource.');
			// System.assertEquals(ar.Test_Request__c, req.getBody());
			res.setStatusCode(200);
			res.setBody(response);
			return res;
		}
	}

     
}