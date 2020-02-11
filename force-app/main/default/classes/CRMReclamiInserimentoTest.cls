@isTest
public class CRMReclamiInserimentoTest {

    @TestSetup
    static void makeData(){
         XCS_categoria__c categEmail = new XCS_categoria__c(external_id__c = CRM_GestioneEmail.GESTIONE_EMAIL_CATEGORY);
         insert categEmail;
       
    }

    /*
    @isTest
    public static void CRMReclamiInsSelezioneClienteController_Compass_Test(){
        String response = '{"resultCode":0,"resultMessage":"Ok","pratiche":null,"cliente":[{"cognome":"CASASSA","codCliente":"123","nome":"CESARE","dataNascita":"19360111","luogoNascita":"DELLO","provNascita":"BS","sesso":"M","codFiscale":"CSSCSR36A11D270T","piva":"00131140980","indirizzo":"VIA","cap":"25020","localita":"E","provincia":"BS","paeseEstero":"086","email":"","tipoDocumento":"","numDocumento":"","ufficioRilascio":""}]}';
        ApiRest__c apiRest = new ApiRest__c(Method__c = 'POST' ,
                                            Test_Response__c= '' ,
                                            Test_Request__c = 'testRequest',
                                            Mock__c = false, 
                                            User__c = 'CDSLF00',
                                            Password__c = 'P00FLSDC' ,
                                            Name ='recuperaDatiPostvendita',
                                            EndPoint__c = 'https://richiestaonlinesvi.compassonline.it/B2BSOAP/rest/B2BREST/execute');      
        insert apiRest;  
        ApiUtil__c apiutil = new ApiUtil__c(Name = 'CompassInternal' ,EndPoint__c ='https://richiestaonlinesvi.compassonline.it/B2BSOAP/rest/B2BREST/execute' ,Password__c = 'P00FLSDC',User__c = 'CDSLF00');      
        insert apiutil;
        
        OCSCliente cliente = new OCSCliente();
        cliente.codCliente='123';
        
        OCSRecuperaDatiPostvenditaRequest req = new OCSRecuperaDatiPostvenditaRequest();
        UtilityMockResponse UMR = new UtilityMockResponse();
        UMR.apiname='ocs.recuperaDatiPostvendita';
        
        Test.setMock(HttpCalloutMock.class,UMR);
        
        test.startTest();
        CRMReclamiInsSelezioneClienteController.makeAccount(cliente,'Compass');
        test.stopTest();
    }
    */
     
    @isTest
    public static void CRMReclamiInsDettagliAttribReclCtrl_Compass_Test(){
        CRMReclamiInsDettagliAttribReclCtrl.getAttribuz();
    }
     
    @isTest
    public static void  CRMReclamiInsDettagliCampiAggiuntiviCtrl_getInitValues(){
        CRMReclamiInsDettagliCampiAggiuntiviCtrl.getInitValues();
    }
    
    @isTest
    public static void  CRMReclamiInsDettagliCampiAggiuntiviCtrl_initGestione(){
        Case c = new Case();
        c.Tipo_Prodotto_Vita__c = '1.i';
        c.Trattabile__c = false;
        c.Tipo_Prodotto_Danni__c='2.o';
        c.Area_Aziendale__c='7';
        c.Tipo_Proponente__c='5';
        c.Area_Geo_Proponente__c='2';
        c.Tipo_Reclamante__c = '6';
        insert c;
        Case c2 = c.clone();
        c2.Trattabile__c = true;
        insert c2;
        CRMReclamiInsDettagliCampiAggiuntiviCtrl.initGestione(c.id);
        CRMReclamiInsDettagliCampiAggiuntiviCtrl.initGestione(c2.id);
        
    }
    
    @isTest
    public static void CRMReclamiInsDettagliCampiAggiuntiviCtrl_salvaReclamoCampiAggiuntiviApex(){
        CRMReclamiInsDettagliCampiAggiuntiviCtrl.salvaReclamoCampiAggiuntiviApex('','','','','','','');
    }
    
    
    @isTest
    public static void CRMReclamiInserimentoMittentiNuovoCtrl_buildIndirizzi(){
        CRMReclamiInserimentoMittentiNuovoCtrl.buildIndirizzi('Compass');
    }
    
    @isTest
    public static void CRMReclamiInserimentoMittentiNuovoCtrl_makeMittente(){
        CRMReclamiInserimentoMittentiNuovoCtrl.makeMittente(true,'test',false, 'test','test','test','test','test','test');
    }
    
    @isTest
    public static void CRMReclamiInserimentoMittentiNuovoCtrl_makeMittenteFromIndPred(){
       List<indirizzi_predefiniti__mdt> lista = CRMReclamiInserimentoMittentiNuovoCtrl.buildIndirizzi('Compass');
        CRMReclamiInserimentoMittentiNuovoCtrl.makeMittenteFromIndPred(lista[0],true);
    }
    
     @isTest
    public static void CRMReclamiInsDettagliContainerController_getContattiPrecedenti(){
      CRMReclamiInsDettagliContainerController.getContattiPrecedenti();
    }
    
    @isTest
    public static void CRMReclamiInsDettagliHeaderController_getInitValues(){
        CRMReclamiInsDettagliHeaderController.getInitValues('Compass');
    }
    
        @isTest
    public static void CRMReclamiInserimentoFeedItemController_getFeedItem(){
        Case c = new Case();
        insert c;
        Reclami_Timestamp__c ts = XCSReclamiUtils.createFeedItem(c.id,System.now(),'test','utente_test', false);
        insert ts;
        
        CRMReclamiInserimentoFeedItemController.getFeedItem(c.id);
    }
    
    
       @isTest
    public static void CRMReclamiInserimentoMittentiMainCtrl_makeMittenteFromClientePR(){
        OCSCliente ocscli = new OCSCliente();
        ocscli.cap='';
        ocscli.codCliente='';
        ocscli.codFiscale='';
        ocscli.cognome='';
        ocscli.dataDepennamento='';
        ocscli.dataNascita='';
        ocscli.dataRilascio='';
        ocscli.dataScadenza='';
        ocscli.denominazioneAzienda='';
        ocscli.denominazione='';
        ocscli.email='';
        ocscli.formaGiuridica='';
        ocscli.indirizzo='';
        ocscli.localita='';
        ocscli.luogoNascita='';
        ocscli.luogoRilascio='';
        ocscli.ndg='';
        ocscli.nome='';
        ocscli.numDocumento='';
        ocscli.paeseEstero='';
        ocscli.piva='';
        ocscli.pratiche= new List<OCSPratica>();
        ocscli.provincia='';
        ocscli.provNascita='';
        ocscli.provRilascio='';
        ocscli.ragioneSociale='';
        ocscli.sesso='';
        ocscli.SFId='';
        ocscli.telefonoCasa='';
        ocscli.telCellulare='';
        ocscli.tipoAnagrafica='';
        ocscli.tipoDocumento='';
        ocscli.tipoRapporto='';
        ocscli.ufficioRilascio='';
        CRMReclamiInserimentoMittentiMainCtrl.makeMittenteFromCliente(ocscli);
        CRMReclamiInserimentoMittentiMainCtrl.makeMittenteFromClientePR(ocscli);
        List<OCSCliente> lista = new List<OCSCliente>();
        lista.add(ocscli);
        CRMReclamiInserimentoMittentiMainCtrl.makeMittentiFromClienti(lista);
         CRMReclamiInserimentoMittentiMainCtrl.makeMittentiFromClientiPR(lista);
        
    }
    
     @isTest
    public static void XCS_MittentiUtils_makeMittente(){
        List<mittenti__mdt> lista = [SELECT Id, DeveloperName, MasterLabel, Label, Email__c, First_Name__c, Last_Name__c, Societa__c FROM mittenti__mdt limit 10];
        XCS_MittenteUtils.makeMittente(lista[0]);
        XCS_MittenteUtils.makeMittentePrincipale(lista[0]);
    }
    
    @isTest
    public static void CRMReclamiInserimentoMittentiFilUffCtrl_getMittenti(){
        List<mittenti__mdt> lista = CRMReclamiInserimentoMittentiFilUffCtrl.getMittenti('Compass');
        CRMReclamiInserimentoMittentiFilUffCtrl.makeMittente(lista[0]);
        CRMReclamiInserimentoMittentiFilUffCtrl.makeMittentePrincipale(lista[0]);
        
    }
    
     @isTest
    public static void CRMReclamiInsRiepPraticaCompMBCCtrl_getConvenzionato(){
		String dealerRecordTypeId  = RecordTypeUtil.getDealerRecordType();
         Account a = new Account(Name='Dealer',recordtypeId = dealerRecordTypeId, OCS_External_Id__c='123');
        insert a;
        CRMReclamiInsRiepPraticaCompMBCCtrl.getConvenzionato('123');
        Account b = new Account(Name='Dealer',recordtypeId = dealerRecordTypeId, OCS_External_Id__c='F123');
        insert b;
         CRMReclamiInsRiepPraticaCompMBCCtrl.GetNomeFiliale('123');
        
    }
    
    @isTest
    public static void CRMReclamiInserimentoAllegatiCtrl_getFiles(){
        Case c = new Case();
       	insert c;
       	CRMReclamiInserimentoAllegatiCtrl.getFiles(c.id);
    }
    
     @isTest
    public static void CRMReclamiInsReclamiPrecedentiCtrl_getReclami(){
        CRMReclamiInsReclamiPrecedentiCtrl.getReclami(null, null, null);
        CRMReclamiInsReclamiPrecedentiCtrl.getReclamiMB_Futuro(null, null, null);
        CRMReclamiInsReclamiPrecedentiCtrl.getReclamiMB_Credit(null, null, null);
    }
    
    @isTest
    public static void CRMReclamiInserimentoContainerController_creaReclamo(){
        XCS_Categoria__c categPostVendita = XCS_CategoriaUtil.getCategoryForExternalId('2154');
        insert categPostVendita;
        Account personalAccount = TestDataFactory.insertAccount();
        String societa = XCSCompassConstants.COMPASS;
        

        String json= '{"dettagliOutputObj":{"headerOutput":{"tipoDettagli":"4137","dataComunicazione":"2020-01-21","dataRicezione":"2020-01-21","dataRicezioneIDM":"2020-01-21","delegaPresente":"false","accessoDati":"false","categoriaDettagli":{"Id":"'+categPostVendita.id+'","Name":"Mancata variazione IBAN","External_Id__c":"3395"},"modalitaInvioDettagli":"Fax","isGrave":false},"radioOutput":{"rimborsoOutput":{"selection":"No","value":null},"standaloneOutput":{"selection":"No","value":null},"futuroOutput":null,"comuniOutput":{"abbuonoOutput":{"selection":"No","value":null},"risarcimentoOutput":{"selection":"No","value":null}}},"attribuzioneReclamo":["SOCIETA"],"codaSelezionata":{"Label":" - Selezionare Coda -","DeveloperName":"DN_53"},"contattoPrecedente":"Nessuno","aggiuntiviOutput":{"trattabile":"Trattabile","tipoProdottoVita":"","tipoProdottoDanni":"","areaAziendale":"","tipoProponente":"","areaGeograficaProponente":"","tipoReclamante":""}},"clienteSelezionatoContainer":{"cap":"88040","codCliente":"11016101","codFiscale":"MTRCTT27E48G734D","cognome":"MEATRMIRO","dataDepennamento":"20190821","dataNascita":"19270508","dataNascitaDate":"1927-05-08","dataNascitaItaliana":"08/05/1927","dataRilascio":"20130620","dataRilascioDate":"2013-06-20","dataScadenza":"20230109","dataScadenzaDate":"2023-01-09","dataScadenzaSlashed":"09/01/2023","denominazione":"CORETTA MEATRMIRO","denominazioneAzienda":"MEATRMIRO CORETTA","email":"MEATRMIRO.CORETTA§provider.com","formaGiuridica":"","indirizzo":"VIA ROSSI 1","localita":"PLATANIA","luogoNascita":"PLATANIA","luogoRilascio":"PLATANIA","ndg":"0","nome":"CORETTA","numDocumento":"544420AT4","paeseEstero":"086","piva":"","pratiche":[{"abi":"0","agente":"12","cab":"0","canale":"MAP","codAttributoPratica":"RE","codCliente":"11016101","codRecuperatore":"","codStatoPratica":"30","convenzionato":"13274476","dataCaricamento":"20/08/2019","dataEstinzione":"","dealerCode":"13274476","desAttributoPratica":"Respinta","desRecuperatore":"","desStatoPratica":"Deliberata","elencoCoobbligati":[{"cap":"88040","codCliente":"11016101","codFiscale":"MTRCTT27E48G734D","cognome":"MEATRMIRO","dataDepennamento":"20190821","dataNascita":"19270508","dataNascitaDate":"1927-05-08","dataNascitaItaliana":"08/05/1927","dataRilascio":"20130620","dataRilascioDate":"2013-06-20","dataScadenza":"20230109","dataScadenzaDate":"2023-01-09","dataScadenzaSlashed":"09/01/2023","denominazione":"CORETTA MEATRMIRO","denominazioneAzienda":"MEATRMIRO CORETTA","email":"MEATRMIRO.CORETTA§provider.com","formaGiuridica":"","indirizzo":"VIA ROSSI 1","localita":"PLATANIA","luogoNascita":"PLATANIA","luogoRilascio":"PLATANIA","ndg":"0","nome":"CORETTA","numDocumento":"544420AT4","paeseEstero":"086","piva":"","provincia":"CZ","provNascita":"CZ","provRilascio":"CZ","sesso":"F","telCellulare":"391 3791292","telefonoCasa":"0968 261651","tipoAnagrafica":"P","tipoDocumento":"CAR","tipoRapporto":"CL","ufficioRilascio":"COM","tipoCliente":"Coobbligato"},{"cap":"88040","codCliente":"19589892","codFiscale":"RCIMHI66H05G734W","cognome":"RIIOCI","dataDepennamento":"20190821","dataNascita":"19660605","dataNascitaDate":"1966-06-05","dataNascitaItaliana":"05/06/1966","dataRilascio":"20190328","dataRilascioDate":"2019-03-28","dataScadenza":"20290327","dataScadenzaDate":"2029-03-27","dataScadenzaSlashed":"27/03/2029","denominazione":"MI HAI RIIOCI","denominazioneAzienda":"RIIOCI MI HAI","email":"RIIOCI.MIHAI§provider.com","formaGiuridica":"","indirizzo":"VIA INDIPENDENZA 5","localita":"PLATANIA","luogoNascita":"PLATANIA","luogoRilascio":"PLATANIA","ndg":"0","nome":"MI HAI","numDocumento":"725546YB7","paeseEstero":"086","piva":"","provincia":"CZ","provNascita":"CZ","provRilascio":"CZ","sesso":"M","telCellulare":"391 3791292","telefonoCasa":"","tipoAnagrafica":"P","tipoDocumento":"PAS","tipoRapporto":"CO","ufficioRilascio":"QUE","tipoCliente":"Coobbligato"}],"filiale":"103","flagRecupero":"N","iban":"","numConto":"","numPratica":"21276003","pan":"","prodotto":"4D","puntoVendita":"0","societa":"Compass","statoPratica":"30RE","subAgente":"0","tipoPagamento":"BP","tipoPratica":"CO","venditore":"0"},{"abi":"0","agente":"12","cab":"0","canale":"CM1","codAttributoPratica":"","codCliente":"11012112","codRecuperatore":"","codStatoPratica":"90","convenzionato":"17889","dataCaricamento":"28/11/2009","dataEstinzione":"","dealerCode":"174825","desAttributoPratica":"","desRecuperatore":"","desStatoPratica":"Estinta","elencoCoobbligati":[],"filiale":"209","flagRecupero":"N","iban":"","numConto":"","numPratica":"7920714","pan":"","prodotto":"1N","puntoVendita":"174825","societa":"Compass","statoPratica":"90","subAgente":"0","tipoPagamento":"BP","tipoPratica":"CO","venditore":"6775977"},{"abi":"0","agente":"12","cab":"0","canale":"CM1","codAttributoPratica":"","codCliente":"11276428","codRecuperatore":"","codStatoPratica":"90","convenzionato":"17889","dataCaricamento":"30/03/2010","dataEstinzione":"","dealerCode":"174825","desAttributoPratica":"","desRecuperatore":"","desStatoPratica":"Estinta","elencoCoobbligati":[{"cap":"88040","codCliente":"11016101","codFiscale":"MTRCTT27E48G734D","cognome":"MEATRMIRO","dataDepennamento":"20190821","dataNascita":"19270508","dataNascitaDate":"1927-05-08","dataNascitaItaliana":"08/05/1927","dataRilascio":"20130620","dataRilascioDate":"2013-06-20","dataScadenza":"20230109","dataScadenzaDate":"2023-01-09","dataScadenzaSlashed":"09/01/2023","denominazione":"CORETTA MEATRMIRO","denominazioneAzienda":"MEATRMIRO CORETTA","email":"MEATRMIRO.CORETTA§provider.com","formaGiuridica":"","indirizzo":"VIA ROSSI 1","localita":"PLATANIA","luogoNascita":"PLATANIA","luogoRilascio":"PLATANIA","ndg":"0","nome":"CORETTA","numDocumento":"544420AT4","paeseEstero":"086","piva":"","provincia":"CZ","provNascita":"CZ","provRilascio":"CZ","sesso":"F","telCellulare":"391 3791292","telefonoCasa":"0968 261651","tipoAnagrafica":"P","tipoDocumento":"CAR","tipoRapporto":"CO","ufficioRilascio":"COM"},{"cap":"88040","codCliente":"11276428","codFiscale":"BHGGRD67S06G734T","cognome":"BIHGU","dataDepennamento":"20100330","dataNascita":"19671106","dataNascitaDate":"1967-11-06","dataNascitaItaliana":"06/11/1967","dataRilascio":"20151104","dataRilascioDate":"2015-11-04","dataScadenza":"20251215","dataScadenzaDate":"2025-12-15","dataScadenzaSlashed":"15/12/2025","denominazione":"GLORIDANO BIHGU","denominazioneAzienda":"BIHGU GLORIDANO","email":"","formaGiuridica":"","indirizzo":"VIA VERDI 52","localita":"PLATANIA","luogoNascita":"PLATANIA","luogoRilascio":"PLATANIA","ndg":"0","nome":"GLORIDANO","numDocumento":"267241AU5","paeseEstero":"086","piva":"","provincia":"CZ","provNascita":"CZ","provRilascio":"CZ","sesso":"M","telCellulare":"338 4111746","telefonoCasa":"0968 261976","tipoAnagrafica":"P","tipoDocumento":"CAR","tipoRapporto":"CL","ufficioRilascio":"COM"}],"filiale":"209","flagRecupero":"N","iban":"","numConto":"","numPratica":"8239643","pan":"","prodotto":"1N","puntoVendita":"174825","societa":"Compass","statoPratica":"90","subAgente":"0","tipoPagamento":"BP","tipoPratica":"CO","venditore":"6775977"},{"abi":"0","cab":"0","canale":"   ","codAttributoPratica":"","codCliente":"11016101","codRecuperatore":"","codStatoPratica":"50","convenzionato":"12","dataCaricamento":"22/08/2019","dataEstinzione":"","dealerCode":"12","desAttributoPratica":"","desRecuperatore":"","desStatoPratica":"Attivata","filiale":"103","flagRecupero":"","iban":"","numConto":"","numPratica":"16140429488","pan":"4877245548496887","prodotto":"L1","societa":"","statoPratica":"50","tipoPagamento":"","tipoPratica":"CA"},{"abi":"19275","agente":"12","cab":"1600","canale":"   ","classifRecupero":"","codAttributoPratica":"BE","codCliente":"11016101","codRecuperatore":"","codStatoPratica":"60","convenzionato":"","dataCaricamento":"22/08/2019","dataEstinzione":"","dealerCode":"","desAttributoPratica":"","desRecuperatore":"","desStatoPratica":"perfezionata","filiale":"103","flagRecupero":"","iban":"IT57L1927501600CC0010291467","numConto":"CC0010291467","numPratica":"123125","pan":"","prodotto":"49","puntoVendita":"","societa":"","statoPratica":"60BE","subAgente":"0","tipoPagamento":"","tipoPratica":"CQ","venditore":""},{"abi":"","agente":"","cab":"","canale":"   ","classifRecupero":"","codAttributoPratica":"","codCliente":"11016101","codRecuperatore":"","codStatoPratica":"50","convenzionato":"","dataCaricamento":"22/08/2019","dataEstinzione":"","dealerCode":"","desAttributoPratica":"","desRecuperatore":"","desStatoPratica":"","filiale":"103","flagRecupero":"","iban":"IT57L1927501600CC0010291467       ","numConto":"","numPratica":"1330291467","pan":"","prodotto":"LZ","puntoVendita":"","societa":"","statoPratica":"50","subAgente":"","tipoPagamento":"","tipoPratica":"CP","venditore":""},{"abi":"","agente":"","cab":"","canale":"   ","classifRecupero":"","codAttributoPratica":"","codCliente":"11016101","codRecuperatore":"","codStatoPratica":"50","convenzionato":"","dataCaricamento":"22/08/2019","dataEstinzione":"","dealerCode":"","desAttributoPratica":"","desRecuperatore":"","desStatoPratica":"","filiale":"103","flagRecupero":"","iban":"IT16P1927501600CC0990284360       ","numConto":"","numPratica":"1980284360","pan":"","prodotto":"B1","puntoVendita":"","societa":"","statoPratica":"50","subAgente":"","tipoPagamento":"","tipoPratica":"BE","venditore":""}]';
        json+=',"praticheFuturo":[],"provincia":"CZ","provNascita":"CZ","provRilascio":"CZ","sesso":"F","SFId":"'+personalAccount.Id+'","telCellulare":"391 3791292","telefonoCasa":"0968 261651","tipoAnagrafica":"P","tipoDocumento":"CAR","tipoRapporto":"","ufficioRilascio":"COM","tipoCliente":"Cliente"},"praticaSelezionataContainer":{"abi":"0","agente":"12","cab":"0","canale":"MAP","codAttributoPratica":"PGEN","codCliente":"11016101","codRecuperatore":"","codStatoPratica":"30","convenzionato":"13274476","dataCaricamento":"20/08/2019","dataEstinzione":"","dealerCode":"13274476","desAttributoPratica":"PRODOTTO GENERICO                                 ","desRecuperatore":"","desStatoPratica":"Deliberata","elencoCoobbligati":[{"cap":"88040","codCliente":"11016101","codFiscale":"MTRCTT27E48G734D","cognome":"MEATRMIRO","dataDepennamento":"20190821","dataNascita":"19270508","dataNascitaDate":"1927-05-08","dataNascitaItaliana":"08/05/1927","dataRilascio":"20130620","dataRilascioDate":"2013-06-20","dataScadenza":"20230109","dataScadenzaDate":"2023-01-09","dataScadenzaSlashed":"09/01/2023","denominazione":"CORETTA MEATRMIRO","denominazioneAzienda":"MEATRMIRO CORETTA","email":"MEATRMIRO.CORETTA§provider.com","formaGiuridica":"","indirizzo":"VIA ROSSI 1","localita":"PLATANIA","luogoNascita":"PLATANIA","luogoRilascio":"PLATANIA","ndg":"0","nome":"CORETTA","numDocumento":"544420AT4","paeseEstero":"086","piva":"","pratiche":[],"praticheFuturo":[],"provincia":"CZ","provNascita":"CZ","provRilascio":"CZ","sesso":"F","telCellulare":"391 3791292","telefonoCasa":"0968 261651","tipoAnagrafica":"P","tipoDocumento":"CAR","tipoRapporto":"CL","ufficioRilascio":"COM"},{"cap":"88040","codCliente":"19589892","codFiscale":"RCIMHI66H05G734W","cognome":"RIIOCI","dataDepennamento":"20190821","dataNascita":"19660605","dataNascitaDate":"1966-06-05","dataNascitaItaliana":"05/06/1966","dataRilascio":"20190328","dataRilascioDate":"2019-03-28","dataScadenza":"20290327","dataScadenzaDate":"2029-03-27","dataScadenzaSlashed":"27/03/2029","denominazione":"MI HAI RIIOCI","denominazioneAzienda":"RIIOCI MI HAI","email":"RIIOCI.MIHAI§provider.com","formaGiuridica":"","indirizzo":"VIA INDIPENDENZA 5","localita":"PLATANIA","luogoNascita":"PLATANIA","luogoRilascio":"PLATANIA","ndg":"0","nome":"MI HAI","numDocumento":"725546YB7","paeseEstero":"086","piva":"","pratiche":[],"praticheFuturo":[],"provincia":"CZ","provNascita":"CZ","provRilascio":"CZ","sesso":"M","telCellulare":"391 3791292","telefonoCasa":"","tipoAnagrafica":"P","tipoDocumento":"PAS","tipoRapporto":"CO","ufficioRilascio":"QUE"}],"filiale":"103","flagRecupero":"N","iban":"","numConto":"","numPratica":"21276003","pan":"","prodotto":"4D","puntoVendita":"0","societa":"Compass","statoPratica":"30RE","subAgente":"0","Tabella_Finanziaria":"4QH","tipoPagamento":"BP","tipoPratica":"CO","venditore":"0"},"comunicazionePresaInCarico":"Nessun invio","pacchettiAssicurativi":[],"mittentiList":[{"Name__c":"Filiale VITERBO","Email__c":"compass.viterbo@compass.it","Principale__c":true,"Autorita__c":false,"Predefinito__c":false,"Name":0,"Tipologia__c":"DOTTORE"}],"isSconosciuto":false}';
        
                
        Attachment attachment = new Attachment();
	    attachment.Body = Blob.valueOf('Unit Test Attachment Body');
	    attachment.Name = String.valueOf('test.txt');
        List<Attachment> listaAttachment = new List<Attachment>();
        listaAttachment.add(attachment);

        XCSReclamiInput reclamiInput = XCSReclamiUtils.getInputObj(json,societa);
        Case reclamo = XCSReclamiUtils.creaReclamo(reclamiInput, societa, listaAttachment, null);
        String dealerRecordTypeId  = RecordTypeUtil.getDealerRecordType();
        Account a = new Account(Name='Dealer',recordtypeId = dealerRecordTypeId, OCS_External_Id__c='123');
        insert a;
        reclamo.AccountId = a.id;
        Account filiale = new Account(Name='Filiale test',recordtypeId = RecordTypeUtil.getBranchRecordType(), OCS_External_Id__c='F103');
        insert filiale;
        Test.startTest();
         CRMReclamiInserimentoContainerController.creaReclamo(json, societa,listaAttachment,null, 'DN_53', '2154', false,'','',null);
         CRMReclamiInserimentoContainerController.creaReclamo(json, societa,listaAttachment,null, 'DN_53', '2154', false,'EMAIL_CLIENTE_APERTURA','test@gmail.com',null);
         CRMReclamiInserimentoContainerController.creaReclamo(json, societa,listaAttachment,null, 'DN_53', '2154', false,'SMS_CLIENTE_APERTURA','test@gmail.com','83045345');
        Test.stopTest();
    }
    
    @isTest
    public static void CRMReclamiInserimentoContainerController_getNomeFiliale(){
        Account filiale = new Account(Name='Filiale test',recordtypeId = RecordTypeUtil.getBranchRecordType(), OCS_External_Id__c='F103');
        insert filiale;
        Case reclamo = new Case();
        reclamo.Branch__c = filiale.id;
        insert reclamo;
        Test.startTest();
        CRMReclamiInserimentoContainerController.getNomeFiliale(filiale.id);
        Test.stopTest();
    
    }
    
       @isTest
    public static void CRMReclamiInserimentoContainerController_isInadempimento(){
        XCS_Categoria__c categoria1 = new XCS_Categoria__c(Livello__c = 1,Name = '1');
        insert categoria1;
        XCS_Categoria__c categoria2 = new XCS_Categoria__c(Livello__c = 2,Name = '2',Parent__c = categoria1.id);
        insert categoria2;
        Test.startTest();
        CRMReclamiInserimentoContainerController.isInadempimentoSelected(categoria2);
        Test.stopTest();
    
    }


   @isTest
    public static void CRMReclamiInserimentoContainerController_insertFeedItem(){
        XCS_Categoria__c categPostVendita = XCS_CategoriaUtil.getCategoryForExternalId('2154');
        insert categPostVendita;
        Account personalAccount = TestDataFactory.insertAccount();
        String societa = XCSCompassConstants.COMPASS;
        

        String json= '{"dettagliOutputObj":{"headerOutput":{"tipoDettagli":"4137","dataComunicazione":"2020-01-21","dataRicezione":"2020-01-21","dataRicezioneIDM":"2020-01-21","delegaPresente":"false","accessoDati":"false","categoriaDettagli":{"Id":"'+categPostVendita.id+'","Name":"Mancata variazione IBAN","External_Id__c":"3395"},"modalitaInvioDettagli":"Fax","isGrave":false},"radioOutput":{"rimborsoOutput":{"selection":"No","value":null},"standaloneOutput":{"selection":"No","value":null},"futuroOutput":null,"comuniOutput":{"abbuonoOutput":{"selection":"No","value":null},"risarcimentoOutput":{"selection":"No","value":null}}},"attribuzioneReclamo":["SOCIETA"],"codaSelezionata":{"Label":" - Selezionare Coda -","DeveloperName":"DN_53"},"contattoPrecedente":"Nessuno","aggiuntiviOutput":{"trattabile":"Trattabile","tipoProdottoVita":"","tipoProdottoDanni":"","areaAziendale":"","tipoProponente":"","areaGeograficaProponente":"","tipoReclamante":""}},"clienteSelezionatoContainer":{"cap":"88040","codCliente":"11016101","codFiscale":"MTRCTT27E48G734D","cognome":"MEATRMIRO","dataDepennamento":"20190821","dataNascita":"19270508","dataNascitaDate":"1927-05-08","dataNascitaItaliana":"08/05/1927","dataRilascio":"20130620","dataRilascioDate":"2013-06-20","dataScadenza":"20230109","dataScadenzaDate":"2023-01-09","dataScadenzaSlashed":"09/01/2023","denominazione":"CORETTA MEATRMIRO","denominazioneAzienda":"MEATRMIRO CORETTA","email":"MEATRMIRO.CORETTA§provider.com","formaGiuridica":"","indirizzo":"VIA ROSSI 1","localita":"PLATANIA","luogoNascita":"PLATANIA","luogoRilascio":"PLATANIA","ndg":"0","nome":"CORETTA","numDocumento":"544420AT4","paeseEstero":"086","piva":"","pratiche":[{"abi":"0","agente":"12","cab":"0","canale":"MAP","codAttributoPratica":"RE","codCliente":"11016101","codRecuperatore":"","codStatoPratica":"30","convenzionato":"13274476","dataCaricamento":"20/08/2019","dataEstinzione":"","dealerCode":"13274476","desAttributoPratica":"Respinta","desRecuperatore":"","desStatoPratica":"Deliberata","elencoCoobbligati":[{"cap":"88040","codCliente":"11016101","codFiscale":"MTRCTT27E48G734D","cognome":"MEATRMIRO","dataDepennamento":"20190821","dataNascita":"19270508","dataNascitaDate":"1927-05-08","dataNascitaItaliana":"08/05/1927","dataRilascio":"20130620","dataRilascioDate":"2013-06-20","dataScadenza":"20230109","dataScadenzaDate":"2023-01-09","dataScadenzaSlashed":"09/01/2023","denominazione":"CORETTA MEATRMIRO","denominazioneAzienda":"MEATRMIRO CORETTA","email":"MEATRMIRO.CORETTA§provider.com","formaGiuridica":"","indirizzo":"VIA ROSSI 1","localita":"PLATANIA","luogoNascita":"PLATANIA","luogoRilascio":"PLATANIA","ndg":"0","nome":"CORETTA","numDocumento":"544420AT4","paeseEstero":"086","piva":"","provincia":"CZ","provNascita":"CZ","provRilascio":"CZ","sesso":"F","telCellulare":"391 3791292","telefonoCasa":"0968 261651","tipoAnagrafica":"P","tipoDocumento":"CAR","tipoRapporto":"CL","ufficioRilascio":"COM","tipoCliente":"Coobbligato"},{"cap":"88040","codCliente":"19589892","codFiscale":"RCIMHI66H05G734W","cognome":"RIIOCI","dataDepennamento":"20190821","dataNascita":"19660605","dataNascitaDate":"1966-06-05","dataNascitaItaliana":"05/06/1966","dataRilascio":"20190328","dataRilascioDate":"2019-03-28","dataScadenza":"20290327","dataScadenzaDate":"2029-03-27","dataScadenzaSlashed":"27/03/2029","denominazione":"MI HAI RIIOCI","denominazioneAzienda":"RIIOCI MI HAI","email":"RIIOCI.MIHAI§provider.com","formaGiuridica":"","indirizzo":"VIA INDIPENDENZA 5","localita":"PLATANIA","luogoNascita":"PLATANIA","luogoRilascio":"PLATANIA","ndg":"0","nome":"MI HAI","numDocumento":"725546YB7","paeseEstero":"086","piva":"","provincia":"CZ","provNascita":"CZ","provRilascio":"CZ","sesso":"M","telCellulare":"391 3791292","telefonoCasa":"","tipoAnagrafica":"P","tipoDocumento":"PAS","tipoRapporto":"CO","ufficioRilascio":"QUE","tipoCliente":"Coobbligato"}],"filiale":"103","flagRecupero":"N","iban":"","numConto":"","numPratica":"21276003","pan":"","prodotto":"4D","puntoVendita":"0","societa":"Compass","statoPratica":"30RE","subAgente":"0","tipoPagamento":"BP","tipoPratica":"CO","venditore":"0"},{"abi":"0","agente":"12","cab":"0","canale":"CM1","codAttributoPratica":"","codCliente":"11012112","codRecuperatore":"","codStatoPratica":"90","convenzionato":"17889","dataCaricamento":"28/11/2009","dataEstinzione":"","dealerCode":"174825","desAttributoPratica":"","desRecuperatore":"","desStatoPratica":"Estinta","elencoCoobbligati":[],"filiale":"209","flagRecupero":"N","iban":"","numConto":"","numPratica":"7920714","pan":"","prodotto":"1N","puntoVendita":"174825","societa":"Compass","statoPratica":"90","subAgente":"0","tipoPagamento":"BP","tipoPratica":"CO","venditore":"6775977"},{"abi":"0","agente":"12","cab":"0","canale":"CM1","codAttributoPratica":"","codCliente":"11276428","codRecuperatore":"","codStatoPratica":"90","convenzionato":"17889","dataCaricamento":"30/03/2010","dataEstinzione":"","dealerCode":"174825","desAttributoPratica":"","desRecuperatore":"","desStatoPratica":"Estinta","elencoCoobbligati":[{"cap":"88040","codCliente":"11016101","codFiscale":"MTRCTT27E48G734D","cognome":"MEATRMIRO","dataDepennamento":"20190821","dataNascita":"19270508","dataNascitaDate":"1927-05-08","dataNascitaItaliana":"08/05/1927","dataRilascio":"20130620","dataRilascioDate":"2013-06-20","dataScadenza":"20230109","dataScadenzaDate":"2023-01-09","dataScadenzaSlashed":"09/01/2023","denominazione":"CORETTA MEATRMIRO","denominazioneAzienda":"MEATRMIRO CORETTA","email":"MEATRMIRO.CORETTA§provider.com","formaGiuridica":"","indirizzo":"VIA ROSSI 1","localita":"PLATANIA","luogoNascita":"PLATANIA","luogoRilascio":"PLATANIA","ndg":"0","nome":"CORETTA","numDocumento":"544420AT4","paeseEstero":"086","piva":"","provincia":"CZ","provNascita":"CZ","provRilascio":"CZ","sesso":"F","telCellulare":"391 3791292","telefonoCasa":"0968 261651","tipoAnagrafica":"P","tipoDocumento":"CAR","tipoRapporto":"CO","ufficioRilascio":"COM"},{"cap":"88040","codCliente":"11276428","codFiscale":"BHGGRD67S06G734T","cognome":"BIHGU","dataDepennamento":"20100330","dataNascita":"19671106","dataNascitaDate":"1967-11-06","dataNascitaItaliana":"06/11/1967","dataRilascio":"20151104","dataRilascioDate":"2015-11-04","dataScadenza":"20251215","dataScadenzaDate":"2025-12-15","dataScadenzaSlashed":"15/12/2025","denominazione":"GLORIDANO BIHGU","denominazioneAzienda":"BIHGU GLORIDANO","email":"","formaGiuridica":"","indirizzo":"VIA VERDI 52","localita":"PLATANIA","luogoNascita":"PLATANIA","luogoRilascio":"PLATANIA","ndg":"0","nome":"GLORIDANO","numDocumento":"267241AU5","paeseEstero":"086","piva":"","provincia":"CZ","provNascita":"CZ","provRilascio":"CZ","sesso":"M","telCellulare":"338 4111746","telefonoCasa":"0968 261976","tipoAnagrafica":"P","tipoDocumento":"CAR","tipoRapporto":"CL","ufficioRilascio":"COM"}],"filiale":"209","flagRecupero":"N","iban":"","numConto":"","numPratica":"8239643","pan":"","prodotto":"1N","puntoVendita":"174825","societa":"Compass","statoPratica":"90","subAgente":"0","tipoPagamento":"BP","tipoPratica":"CO","venditore":"6775977"},{"abi":"0","cab":"0","canale":"   ","codAttributoPratica":"","codCliente":"11016101","codRecuperatore":"","codStatoPratica":"50","convenzionato":"12","dataCaricamento":"22/08/2019","dataEstinzione":"","dealerCode":"12","desAttributoPratica":"","desRecuperatore":"","desStatoPratica":"Attivata","filiale":"103","flagRecupero":"","iban":"","numConto":"","numPratica":"16140429488","pan":"4877245548496887","prodotto":"L1","societa":"","statoPratica":"50","tipoPagamento":"","tipoPratica":"CA"},{"abi":"19275","agente":"12","cab":"1600","canale":"   ","classifRecupero":"","codAttributoPratica":"BE","codCliente":"11016101","codRecuperatore":"","codStatoPratica":"60","convenzionato":"","dataCaricamento":"22/08/2019","dataEstinzione":"","dealerCode":"","desAttributoPratica":"","desRecuperatore":"","desStatoPratica":"perfezionata","filiale":"103","flagRecupero":"","iban":"IT57L1927501600CC0010291467","numConto":"CC0010291467","numPratica":"123125","pan":"","prodotto":"49","puntoVendita":"","societa":"","statoPratica":"60BE","subAgente":"0","tipoPagamento":"","tipoPratica":"CQ","venditore":""},{"abi":"","agente":"","cab":"","canale":"   ","classifRecupero":"","codAttributoPratica":"","codCliente":"11016101","codRecuperatore":"","codStatoPratica":"50","convenzionato":"","dataCaricamento":"22/08/2019","dataEstinzione":"","dealerCode":"","desAttributoPratica":"","desRecuperatore":"","desStatoPratica":"","filiale":"103","flagRecupero":"","iban":"IT57L1927501600CC0010291467       ","numConto":"","numPratica":"1330291467","pan":"","prodotto":"LZ","puntoVendita":"","societa":"","statoPratica":"50","subAgente":"","tipoPagamento":"","tipoPratica":"CP","venditore":""},{"abi":"","agente":"","cab":"","canale":"   ","classifRecupero":"","codAttributoPratica":"","codCliente":"11016101","codRecuperatore":"","codStatoPratica":"50","convenzionato":"","dataCaricamento":"22/08/2019","dataEstinzione":"","dealerCode":"","desAttributoPratica":"","desRecuperatore":"","desStatoPratica":"","filiale":"103","flagRecupero":"","iban":"IT16P1927501600CC0990284360       ","numConto":"","numPratica":"1980284360","pan":"","prodotto":"B1","puntoVendita":"","societa":"","statoPratica":"50","subAgente":"","tipoPagamento":"","tipoPratica":"BE","venditore":""}]';
        json+=',"praticheFuturo":[],"provincia":"CZ","provNascita":"CZ","provRilascio":"CZ","sesso":"F","SFId":"'+personalAccount.Id+'","telCellulare":"391 3791292","telefonoCasa":"0968 261651","tipoAnagrafica":"P","tipoDocumento":"CAR","tipoRapporto":"","ufficioRilascio":"COM","tipoCliente":"Cliente"},"praticaSelezionataContainer":{"abi":"0","agente":"12","cab":"0","canale":"MAP","codAttributoPratica":"PGEN","codCliente":"11016101","codRecuperatore":"","codStatoPratica":"30","convenzionato":"13274476","dataCaricamento":"20/08/2019","dataEstinzione":"","dealerCode":"13274476","desAttributoPratica":"PRODOTTO GENERICO                                 ","desRecuperatore":"","desStatoPratica":"Deliberata","elencoCoobbligati":[{"cap":"88040","codCliente":"11016101","codFiscale":"MTRCTT27E48G734D","cognome":"MEATRMIRO","dataDepennamento":"20190821","dataNascita":"19270508","dataNascitaDate":"1927-05-08","dataNascitaItaliana":"08/05/1927","dataRilascio":"20130620","dataRilascioDate":"2013-06-20","dataScadenza":"20230109","dataScadenzaDate":"2023-01-09","dataScadenzaSlashed":"09/01/2023","denominazione":"CORETTA MEATRMIRO","denominazioneAzienda":"MEATRMIRO CORETTA","email":"MEATRMIRO.CORETTA§provider.com","formaGiuridica":"","indirizzo":"VIA ROSSI 1","localita":"PLATANIA","luogoNascita":"PLATANIA","luogoRilascio":"PLATANIA","ndg":"0","nome":"CORETTA","numDocumento":"544420AT4","paeseEstero":"086","piva":"","pratiche":[],"praticheFuturo":[],"provincia":"CZ","provNascita":"CZ","provRilascio":"CZ","sesso":"F","telCellulare":"391 3791292","telefonoCasa":"0968 261651","tipoAnagrafica":"P","tipoDocumento":"CAR","tipoRapporto":"CL","ufficioRilascio":"COM"},{"cap":"88040","codCliente":"19589892","codFiscale":"RCIMHI66H05G734W","cognome":"RIIOCI","dataDepennamento":"20190821","dataNascita":"19660605","dataNascitaDate":"1966-06-05","dataNascitaItaliana":"05/06/1966","dataRilascio":"20190328","dataRilascioDate":"2019-03-28","dataScadenza":"20290327","dataScadenzaDate":"2029-03-27","dataScadenzaSlashed":"27/03/2029","denominazione":"MI HAI RIIOCI","denominazioneAzienda":"RIIOCI MI HAI","email":"RIIOCI.MIHAI§provider.com","formaGiuridica":"","indirizzo":"VIA INDIPENDENZA 5","localita":"PLATANIA","luogoNascita":"PLATANIA","luogoRilascio":"PLATANIA","ndg":"0","nome":"MI HAI","numDocumento":"725546YB7","paeseEstero":"086","piva":"","pratiche":[],"praticheFuturo":[],"provincia":"CZ","provNascita":"CZ","provRilascio":"CZ","sesso":"M","telCellulare":"391 3791292","telefonoCasa":"","tipoAnagrafica":"P","tipoDocumento":"PAS","tipoRapporto":"CO","ufficioRilascio":"QUE"}],"filiale":"103","flagRecupero":"N","iban":"","numConto":"","numPratica":"21276003","pan":"","prodotto":"4D","puntoVendita":"0","societa":"Compass","statoPratica":"30RE","subAgente":"0","Tabella_Finanziaria":"4QH","tipoPagamento":"BP","tipoPratica":"CO","venditore":"0"},"comunicazionePresaInCarico":"Nessun invio","pacchettiAssicurativi":[],"mittentiList":[{"Name__c":"Filiale VITERBO","Email__c":"compass.viterbo@compass.it","Principale__c":true,"Autorita__c":false,"Predefinito__c":false,"Name":0,"Tipologia__c":"DOTTORE"}],"isSconosciuto":false}';
        
                
        Attachment attachment = new Attachment();
	    attachment.Body = Blob.valueOf('Unit Test Attachment Body');
	    attachment.Name = String.valueOf('test.txt');
        List<Attachment> listaAttachment = new List<Attachment>();
        listaAttachment.add(attachment);

        XCSReclamiInput reclamiInput = XCSReclamiUtils.getInputObj(json,societa);
        Case reclamo = XCSReclamiUtils.creaReclamo(reclamiInput, societa, listaAttachment, null);
        String dealerRecordTypeId  = RecordTypeUtil.getDealerRecordType();
        Account a = new Account(Name='Dealer',recordtypeId = dealerRecordTypeId, OCS_External_Id__c='123');
        insert a;
        reclamo.AccountId = a.id;
        Account filiale = new Account(Name='Filiale test',recordtypeId = RecordTypeUtil.getBranchRecordType(), OCS_External_Id__c='F103');
        insert filiale;
        Test.startTest();
         CRMReclamiInserimentoContainerController.insertFeedItem(reclamo.id);
        Test.stopTest();
    }

    @isTest
    public static void CRMReclamiInserimentoContainerController_pathOrg(){   
        Test.startTest();
        CRMReclamiInserimentoContainerController.pathOrg();
        Test.stopTest();
    }
      
      
    @isTest
    public static void CRMReclamiInserimentoContainerController_postOnChatterInadempimento(){   
        Case reclamo = new Case();
        insert reclamo;
        XCS_CompassParameters__c  compassPara = new XCS_CompassParameters__c(Name = 'forwardandtrack.baseurl',Value__c = 'http://test.com');
        insert compassPara;
        CollaborationGroup  collGroup = new CollaborationGroup (Name='Monitoraggio Dealer',CollaborationType = 'Public');
//        insert collGroup;
        Test.startTest();
        CRMReclamiInserimentoContainerController.postOnChatterInadempimento(reclamo.id);
        Test.stopTest();
    }   


    @isTest
    public static void CRMReclamiInserimentoDettagliSelCoda_getQueues(){   
        XCS_Categoria__c categ2181 = new XCS_Categoria__c( Name= 'test',External_Id__c = '2181');
        insert categ2181;
        XCS_Categoria__c categ2165 = new XCS_Categoria__c( Name= 'test',External_Id__c = '2165');
        insert categ2165;
        Test.startTest();
        List<CodaXSocieta__mdt> listCode =CRMReclamiInserimentoDettagliSelCodaCtrl.getQueues('Compass', '5411', categ2181, false, null, false, null);
        List<CodaXSocieta__mdt> listCode2 =CRMReclamiInserimentoDettagliSelCodaCtrl.getQueues('Compass', '4136', categ2165, false, null, false, null);
        Test.stopTest();
    }
}