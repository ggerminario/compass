@isTest
public class CRMReclamiUtilsTest {
    @isTest
    public static void testCreaReclamoCompass(){
        XCS_Categoria__c categPostVendita = XCS_CategoriaUtil.getCategoryForExternalId('5355');
        insert categPostVendita;
        Account personalAccount = TestDataFactory.insertAccount();
        String societa = XCSCompassConstants.COMPASS;
        String json = '{"dettagliOutputObj":{"headerOutput":{"tipoDettagli":"4137","dataComunicazione":"2019-12-20","dataRicezione":"2019-12-20","dataRicezioneIDM":"2019-12-20","delegaPresente":"false","accessoDati":"false","categoriaDettagli":{"Id":"'+categPostVendita.id+'","Name":"Mancata variazione IBAN","External_Id__c":"3395"},"modalitaInvioDettagli":"Telegramma","isGrave":false},"radioOutput":{"rimborsoOutput":{"selection":"No","value":null},"standaloneOutput":{"selection":"No","value":null},"futuroOutput":null,"comuniOutput":{"abbuonoOutput":{"selection":"No","value":null},"risarcimentoOutput":{"selection":"No","value":null}}},"attribuzioneReclamo":["SOCIETA"],"codaSelezionata":{"Label":" - Selezionare Coda -","DeveloperName":"DN_53"},"contattoPrecedente":"Ufficio Sede","aggiuntiviOutput":null},"clienteSelezionatoContainer":{"cap":"95041","codCliente":"567779","codFiscale":"YHBLRL42S19****C","cognome":"YHABST","dataDepennamento":"0","dataNascita":"19421119","dataNascitaDate":"1942-11-19","dataNascitaItaliana":"19/11/1942","dataRilascio":"0","dataScadenza":"0","denominazione":"ALVARO LUIS YHABST","denominazioneAzienda":"YHABST ALVARO LUIS","email":"","formaGiuridica":"","indirizzo":"VIA INDIPENDENZA 9","localita":"CALTAGIRONE","luogoNascita":"","luogoRilascio":"","ndg":"0","nome":"ALVARO LUIS","numDocumento":"","paeseEstero":"086","piva":"","pratiche":[{"abi":"0","agente":"12","cab":"0","canale":"   ","codAttributoPratica":"","codCliente":"567779","codRecuperatore":"","codStatoPratica":"90","convenzionato":"2472828","dataCaricamento":"22/02/1990","dataEstinzione":"","dealerCode":"2472828","desAttributoPratica":"","desRecuperatore":"","desStatoPratica":"Estinta","elencoCoobbligati":[],"filiale":"206","flagRecupero":"N","iban":"","numConto":"","numPratica":"123125","pan":"","prodotto":"4E","puntoVendita":"0","societa":"Compass","statoPratica":"90","subAgente":"0","tipoPagamento":"BP","tipoPratica":"CO","venditore":"0"}],"praticheFuturo":[],"provincia":"CT","provNascita":"","provRilascio":"","sesso":"M","SFId":"'+personalAccount.Id+'","telCellulare":"","telefonoCasa":"0933 51813","tipoAnagrafica":"P","tipoDocumento":"","tipoRapporto":"","ufficioRilascio":"","tipoCliente":"Cliente"},"praticaSelezionataContainer":{"abi":"0","agente":"12","cab":"0","canale":"   ","codAttributoPratica":"ZZZZ","codCliente":"567779","codRecuperatore":"","codStatoPratica":"90","convenzionato":"2472828","dataCaricamento":"22/02/1990","dataEstinzione":"","dealerCode":"2472828","desAttributoPratica":"-NON IDENTIFICATA-                                ","desRecuperatore":"","desStatoPratica":"Estinta","elencoCoobbligati":[],"filiale":"206","flagRecupero":"N","iban":"","numConto":"","numPratica":"123125","pan":"","prodotto":"4E","puntoVendita":"0","societa":"Compass","statoPratica":"90","subAgente":"0","Tabella_Finanziaria":"999","tipoPagamento":"BP","tipoPratica":"CO","venditore":"0"},"pacchettiAssicurativi":[],"mittentiList":[{"Name__c":"Filiale MILANO LA FOPPA","Email__c":"compass.milano.lafoppa@compass.it","Principale__c":true,"Autorita__c":false,"Predefinito__c":false}],"isSconosciuto":false}';
        Attachment attachment = new Attachment();
	    attachment.Body = Blob.valueOf('Unit Test Attachment Body');
	    attachment.Name = String.valueOf('test.txt');
        List<Attachment> listaAttachment = new List<Attachment>();
        listaAttachment.add(attachment);
        Test.startTest();
        XCSReclamiInput reclamiInput = XCSReclamiUtils.getInputObj(json,societa);
        Case reclamo = XCSReclamiUtils.creaReclamo(reclamiInput, societa, listaAttachment, null);
        Test.stopTest();
        System.assert(reclamo!=null);
    }

    @isTest
    public static void testCreaReclamoCompass2(){
        XCS_Categoria__c categPostVendita = XCS_CategoriaUtil.getCategoryForExternalId('5355');
        insert categPostVendita;
        Account personalAccount = TestDataFactory.insertAccount();
        String societa = XCSCompassConstants.COMPASS;
        String json = '{"dettagliOutputObj":{"headerOutput":{"tipoDettagli":"4137","dataComunicazione":"2019-12-20","dataRicezione":"2019-12-20","dataRicezioneIDM":"2019-12-20","delegaPresente":"false","accessoDati":"false","categoriaDettagli":{"Id":"'+categPostVendita.id+'","Name":"Mancata variazione IBAN","External_Id__c":"3395"},"modalitaInvioDettagli":"Telegramma","isGrave":false},"radioOutput":{"rimborsoOutput":{"selection":"No","value":null},"standaloneOutput":{"selection":"No","value":null},"futuroOutput":null,"comuniOutput":{"abbuonoOutput":{"selection":"No","value":null},"risarcimentoOutput":{"selection":"No","value":null}}},"attribuzioneReclamo":["SOCIETA"],"codaSelezionata":{"Label":" - Selezionare Coda -","DeveloperName":"DN_53"},"contattoPrecedente":"Ufficio Sede","aggiuntiviOutput":null},"clienteSelezionatoContainer":{"cap":"95041","codCliente":"567779","codFiscale":"YHBLRL42S19****C","cognome":"YHABST","dataDepennamento":"0","dataNascita":"19421119","dataNascitaDate":"1942-11-19","dataNascitaItaliana":"19/11/1942","dataRilascio":"0","dataScadenza":"0","denominazione":"ALVARO LUIS YHABST","denominazioneAzienda":"YHABST ALVARO LUIS","email":"","formaGiuridica":"","indirizzo":"VIA INDIPENDENZA 9","localita":"CALTAGIRONE","luogoNascita":"","luogoRilascio":"","ndg":"0","nome":"ALVARO LUIS","numDocumento":"","paeseEstero":"086","piva":"","pratiche":[{"abi":"0","agente":"12","cab":"0","canale":"   ","codAttributoPratica":"","codCliente":"567779","codRecuperatore":"","codStatoPratica":"90","convenzionato":"2472828","dataCaricamento":"22/02/1990","dataEstinzione":"","dealerCode":"2472828","desAttributoPratica":"","desRecuperatore":"","desStatoPratica":"Estinta","elencoCoobbligati":[],"filiale":"206","flagRecupero":"N","iban":"","numConto":"","numPratica":"123125","pan":"","prodotto":"4E","puntoVendita":"0","societa":"Compass","statoPratica":"90","subAgente":"0","tipoPagamento":"BP","tipoPratica":"CO","venditore":"0"}],"praticheFuturo":[],"provincia":"CT","provNascita":"","provRilascio":"","sesso":"M","SFId":"'+personalAccount.Id+'","telCellulare":"","telefonoCasa":"0933 51813","tipoAnagrafica":"P","tipoDocumento":"","tipoRapporto":"","ufficioRilascio":"","tipoCliente":"Cliente"},"praticaSelezionataContainer":{"abi":"0","agente":"12","cab":"0","canale":"   ","codAttributoPratica":"ZZZZ","codCliente":"567779","codRecuperatore":"","codStatoPratica":"90","convenzionato":"2472828","dataCaricamento":"22/02/1990","dataEstinzione":"","dealerCode":"2472828","desAttributoPratica":"-NON IDENTIFICATA-                                ","desRecuperatore":"","desStatoPratica":"Estinta","elencoCoobbligati":[],"filiale":"206","flagRecupero":"N","iban":"","numConto":"","numPratica":"123125","pan":"","prodotto":"4E","puntoVendita":"0","societa":"Compass","statoPratica":"90","subAgente":"0","Tabella_Finanziaria":"999","tipoPagamento":"BP","tipoPratica":"CO","venditore":"0"},"pacchettiAssicurativi":[],"mittentiList":[{"Name__c":"Filiale MILANO LA FOPPA","Email__c":"compass.milano.lafoppa@compass.it","Principale__c":true,"Autorita__c":false,"Predefinito__c":false}],"isSconosciuto":false}';
        Attachment attachment = new Attachment();
	    attachment.Body = Blob.valueOf('Unit Test Attachment Body');
	    attachment.Name = String.valueOf('test.txt');
        List<Attachment> listaAttachment = new List<Attachment>();
        listaAttachment.add(attachment);
        Test.startTest();
        XCSReclamiInput reclamiInput = XCSReclamiUtils.getInputObj(json,societa);
        Case reclamo = XCSReclamiUtils.creaReclamo(reclamiInput, societa, listaAttachment, null,null,null,false);
        Test.stopTest();
        System.assert(reclamo!=null);
    }



    @isTest
    public static void testCreaReclamoFuturo(){
        XCS_Categoria__c categPostVendita = XCS_CategoriaUtil.getCategoryForExternalId('5355');
        insert categPostVendita;
        Account_Futuro_MBCS__c personalAccount = TestDataFactory.insertAccountFuturo();
        String societa = XCSCompassConstants.FUTURO;
        String json = '{"dettagliOutputObj":{"headerOutput":{"tipoDettagli":"5411","dataComunicazione":"2019-12-20","dataRicezione":"2019-12-20","dataRicezioneIDM":"2019-12-20","delegaPresente":"false","accessoDati":"false","categoriaDettagli":{"Id":"'+categPostVendita.id+'","Name":"Condizioni contrattuali promesse non conformi","External_Id__c":"5355"},"modalitaInvioDettagli":"Email","isGrave":false},"radioOutput":{"rimborsoOutput":null,"standaloneOutput":null,"futuroOutput":{"commissioniOutput":{"selection":"No","value":null},"provvAccOutput":{"selection":"No","value":null},"premioAssOutput":{"selection":"No","value":null},"varieOutput":{"selection":"No","value":null},"speseLegaliOutput":{"selection":"No","value":null}},"comuniOutput":{"abbuonoOutput":{"selection":"No","value":null},"risarcimentoOutput":{"selection":"No","value":null}}},"attribuzioneReclamo":["SOCIETA","FILIALE"],"codaSelezionata":{"Label":" - Selezionare Coda -","DeveloperName":"DN_298"},"contattoPrecedente":"Filiale","aggiuntiviOutput":null},"clienteSelezionatoContainer":{"cap":"10030","codCliente":"166341","codFiscale":"NVGZRJ55S41A859V","cognome":"AONVGRENL","dataDepennamento":"20060301","dataNascita":"19551101","dataNascitaDate":"1955-11-01","dataNascitaItaliana":"01/11/1955","dataRilascio":"20020920","dataRilascioDate":"2002-09-20","dataScadenza":"20070919","dataScadenzaDate":"2007-09-19","dataScadenzaSlashed":"19/09/2007","denominazione":"ZAGORE JACQUELINE AONVGRENL","denominazioneAzienda":"AONVGRENL ZAGORE JACQUELINE","email":"","formaGiuridica":"","indirizzo":"VIA ROSSI 1","localita":"MAGLIONE","luogoNascita":"BIELLA","luogoRilascio":"CIGLIANO","ndg":"0","nome":"ZAGORE JACQUELINE","numDocumento":"526556AG3","paeseEstero":"086","piva":"","pratiche":[],"praticheFuturo":[{"agenteCod":"35","agenteRagSoc":"ITALCREDI SPA","assicImpiegoCod":"206794","assicImpiegoRagSoc":"A.C.A.T. ALBERGO","assicVitaCod":"232313","assicVitaRagSoc":"A.R.P.A. MUSICISTI","aziendaCap":"13100","aziendaCod":"126988","aziendaIndirizzo":"VIA ROMA 6","aziendaLocalita":"VERCELLI                ","aziendaProv":"VC","aziendaRagSoc":"HOTEL VISTA","aziendaSedeCod":"0","aziendaSedeIndirizzo":"","aziendaSedeRagSoc":"","bancaRagSoc":"","codAttributoPratica":"  ","codCliente":"166341","codRecuperatore":"","codStatoPratica":"90","dataCaricamento":"05/11/2004","dataContratto":"05/11/2004","dataEstinzioneAnticipata":"10/10/2005","desRecuperatore":"","desStatoPratica":" Estinta                    ","filBancaRagSoc":"","flagRecupero":"N","numPratica":"123125","subAgenteCod":"0","subAgenteRagSoc":"","tipoPratica":"C"},{"agenteCod":"35","agenteRagSoc":"ITALCREDI SPA","assicImpiegoRagSoc":"","assicVitaRagSoc":"","aziendaCap":"28060","aziendaCod":"186412","aziendaIndirizzo":"PIAZZA REPUBBLICA 1","aziendaLocalita":"CASALVOLONE             ","aziendaProv":"NO","aziendaRagSoc":"CANGIA LA TAVERNA DEL COMPUTER","aziendaSedeCod":"0","aziendaSedeIndirizzo":"","aziendaSedeRagSoc":"","bancaRagSoc":"","codAttributoPratica":"  ","codCliente":"166341","codRecuperatore":"","codStatoPratica":"80","dataCaricamento":"31/03/2006","dataContratto":"31/03/2006","desRecuperatore":"","desStatoPratica":" Chiusa                     ","filBancaRagSoc":"","flagRecupero":"N","numPratica":"149554","subAgenteCod":"0","subAgenteRagSoc":"","tipoPratica":"C"}],"provincia":"TO","provNascita":"BI","provRilascio":"VC","sesso":"F","SFId":"'+personalAccount.Id+'","telCellulare":"","telefonoCasa":"333 8684138","tipoAnagrafica":"P","tipoDocumento":"CAR","tipoRapporto":"","ufficioRilascio":"COM"},"praticaSelezionataContainer":{"agenteCod":"35","agenteRagSoc":"ITALCREDI SPA","assicImpiegoCod":"206794","assicImpiegoRagSoc":"A.C.A.T. ALBERGO","assicVitaCod":"232313","assicVitaRagSoc":"A.R.P.A. MUSICISTI","aziendaCap":"13100","aziendaCod":"126988","aziendaIndirizzo":"VIA ROMA 6","aziendaLocalita":"VERCELLI                ","aziendaProv":"VC","aziendaRagSoc":"HOTEL VISTA","aziendaSedeCod":"0","aziendaSedeIndirizzo":"","aziendaSedeRagSoc":"","bancaRagSoc":"","codAttributoPratica":"  ","codCliente":"166341","codRecuperatore":"","codStatoPratica":"90","dataCaricamento":"05/11/2004","dataContratto":"05/11/2004","dataEstinzioneAnticipata":"10/10/2005","desRecuperatore":"","desStatoPratica":" Estinta                    ","filBancaRagSoc":"","flagRecupero":"N","numPratica":"123125","subAgenteCod":"0","subAgenteRagSoc":"","tipoPratica":"C"},"mittentiList":[{"Name__c":"Ufficio Gestione Operativa Post Acquisizione","Email__c":"null","Principale__c":true,"Autorita__c":false,"Predefinito__c":false}],"isSconosciuto":false}';
        Attachment attachment = new Attachment();
	    attachment.Body = Blob.valueOf('Unit Test Attachment Body');
	    attachment.Name = String.valueOf('test.txt');
        List<Attachment> listaAttachment = new List<Attachment>();
        listaAttachment.add(attachment);
        Test.startTest();
        XCSReclamiInput reclamiInput = XCSReclamiUtils.getInputObj(json,societa);
        Case reclamo = XCSReclamiUtils.creaReclamo(reclamiInput, societa, listaAttachment, null);
        Test.stopTest();
        System.assert(reclamo!=null);
    }

    @isTest
    public static void testCreaReclamoCreditech(){
        XCS_Categoria__c categPostVendita = XCS_CategoriaUtil.getCategoryForExternalId('5355');
        insert categPostVendita;
        Account_Futuro_MBCS__c personalAccount = TestDataFactory.insertAccountFuturo();
        String societa = XCSCompassConstants.MBC;
        String json = '{"dettagliOutputObj":{"headerOutput":{"tipoDettagli":"5433","dataComunicazione":"2019-12-20","dataRicezione":"2019-12-20","dataRicezioneIDM":"2019-12-20","delegaPresente":"false","accessoDati":"false","categoriaDettagli":{"Id":"'+categPostVendita.id+'","Name":"Filiale mancata informazione","External_Id__c":"5663"},"areaDettagli":"CM","modalitaInvioDettagli":"Email","isGrave":false},"radioOutput":{"rimborsoOutput":{"selection":"No","value":null},"standaloneOutput":null,"futuroOutput":null,"comuniOutput":{"abbuonoOutput":{"selection":"No","value":null},"risarcimentoOutput":{"selection":"No","value":null}}},"attribuzioneReclamo":["SOCIETA","FILIALE"],"codaSelezionata":{"Label":" - Selezionare Coda -","DeveloperName":"DN_342"},"contattoPrecedente":"Filiale","aggiuntiviOutput":null},"clienteSelezionatoContainer":{"cedenteCommittente":"cedente9","cognome":"Lorin","dataNascitaItaliana":"","denominazione":"Renato Lorin","nome":"Renato","pratiche":[{"cedCom":"cedente9","dataCaricamento":"","dealerCode":"","elencoCoobbligati":[],"numPratica":"93495345"}],"praticheFuturo":[],"ragioneSociale":"Ragione","SFId":"'+personalAccount.Id+'"},"praticaSelezionataContainer":null,"mittentiList":[{"Name__c":"Ufficio Controllo di Gestione","Principale__c":true,"Autorita__c":false,"Predefinito__c":false}]}';
        Attachment attachment = new Attachment();
	    attachment.Body = Blob.valueOf('Unit Test Attachment Body');
	    attachment.Name = String.valueOf('test.txt');
        List<Attachment> listaAttachment = new List<Attachment>();
        listaAttachment.add(attachment);
        Test.startTest();
        XCSReclamiInput reclamiInput = XCSReclamiUtils.getInputObj(json,societa);
        Case reclamo = XCSReclamiUtils.creaReclamo(reclamiInput, societa, listaAttachment, null);
        Test.stopTest();
        System.assert(reclamo!=null);
    }

    @isTest
    public static void testgetDate(){
        Test.startTest();
        String s = XCSReclamiUtils.getDate(Datetime.Now(),true);
        Test.stopTest();
        System.assert(s!=null);
    }

   @isTest
    public static void testcreateFeedItemForGestione_chisusura(){
        Case caso = new Case();
        insert caso;
        Test.startTest();
        XCSReclamiUtils.createFeedItemForGestione(caso.id);
         XCSReclamiUtils.createFeedItemForChiusura(caso.id);
        Test.stopTest();
        List<FeedItem> listfeed = [SELECT Id FROM FeedItem ];
        System.assert(listfeed!=null && listfeed.size()>0);
    }

   @isTest
    public static void testcreateFeedItem(){
       
        Case caso = new Case();
        insert caso;
        Test.startTest();
        Reclami_Timestamp__c r = XCSReclamiUtils.createFeedItem(caso.id,Datetime.Now(),'evento','utente',true);
        Test.stopTest();
        System.assert(r!=null );
    }
    
   @isTest
    public static void testsetLivelloAutorizzazione(){
        
        Case myCase = new Case();
        myCase.Tipo_Reclamo__c =  '5413';
        myCase.Referenced_Company__c = 'Compass';
        insert myCase;
        Test.startTest();
        XCSReclamiUtils.setLivelloAutorizzazione(myCase.id);
        Test.stopTest();
    }

   @isTest
    public static void testisFrode(){
       
        Test.startTest();
        Boolean b = XCSReclamiUtils.isFrode('Reclamo', 'Compass');
        Test.stopTest();
//        System.assert(s!=null );
    }

   @isTest
    public static void testsendEmailDebug(){
       
        Test.startTest();
        XCSReclamiUtils.sendEmailDebug('Testo per TEST');
        Test.stopTest();
//        System.assert(s!=null );
    }

   @isTest
    public static void testisReclamoReadOnly(){

        Case caso = new Case();
        insert caso;
        Test.startTest();
        Boolean b = XCSReclamiUtils.isReclamoReadOnly(caso.Id);
        Test.stopTest();
    }
    
   @isTest
    public static void testtakeUsersFromQueue(){

        String uniqueUserName = 'standarduser' + DateTime.now().getTime() + '@testorg.com';
        Profile p = [SELECT Id FROM Profile WHERE Name='Standard User'];
        User u = new User(Alias = 'standt', Email='standarduser@testorg.com',
        EmailEncodingKey='UTF-8', LastName='Testing', LanguageLocaleKey='en_US',
        LocaleSidKey='en_US', ProfileId = p.Id,
        TimeZoneSidKey='America/Los_Angeles',
        UserName=uniqueUserName);
        
        
        System.runAs(u){
            Id gId = [SELECT Id FROM Group WHERE Name = 'PARMA'].id;
            String uIs = UserInfo.getUserId();
    
            Case caso = new Case();
            insert caso;
    
            Test.startTest();
            List<User> lU = XCSReclamiUtils.takeUsersFromQueue(caso.OwnerId);
            Test.stopTest();
            
        }
        
    }

   @isTest
    public static void testResponsabilitaBranch(){
    
            Case caso = new Case();
            insert caso;
    
            Test.startTest();
            List<XCS_Responsabilita__c> lX = XCSReclamiUtils.ResponsabilitaBranch(caso);
            List<String> lS = XCSReclamiUtils.parsResponsabilitaBranch(caso);
            Test.stopTest();
        
    }
    
   @isTest
    public static void testgetGrave(){
    
 			String societa = XCSCompassConstants.COMPASS;
            Test.startTest();
            Boolean b = XCSReclamiUtils.getGrave('Reclamo' , societa);
            Test.stopTest();
        
    }

   @isTest
    public static void testgetIdReclamiUser(){

            String uIs = UserInfo.getUserId();

            Test.startTest();
            String s = XCSReclamiUtils.getIdReclamiUser(uIs);
            Test.stopTest();
        
    }

   @isTest
    public static void testisGrave(){
    
 			String societa = XCSCompassConstants.COMPASS;
            Test.startTest();
            Boolean b = XCSReclamiUtils.isGrave('Reclamo' , societa);
            Test.stopTest();
        
    }

   @isTest
    public static void testcreateContentVersion(){
    
 			String societa = XCSCompassConstants.COMPASS;
            Test.startTest();
            ContentVersion cv = XCSReclamiUtils.createContentVersion('Reclamo' , null);
            Test.stopTest();
        
    }

   @isTest
    public static void testcreateContentDocumentLink(){
    
            Case c = new case();
            insert c;

            ContentVersion contentVersion = new ContentVersion(
                Title = 'Penguins',
                PathOnClient = 'Penguins.jpg',
                VersionData = Blob.valueOf('Test Content'),
                IsMajorVersion = true
            );
            insert contentVersion;
            List<ContentDocument> documents = [SELECT Id, Title, LatestPublishedVersionId FROM ContentDocument];

            Test.startTest();
            ContentDocumentLink cdl = XCSReclamiUtils.createContentDocumentLink(documents[0].Id , c.id);
            Test.stopTest();
        
    }

   @isTest
    public static void testdocumentToAttachment(){
    
            Case c = new case();
            insert c;

            Test.startTest();
            List<Attachment> att = XCSReclamiUtils.documentToAttachment(c.id);
            Test.stopTest();
        
    }

   @isTest
    public static void testgetUrlForDownloadFile(){
    
            Case c = new case();
            insert c;

            ContentVersion contentVersion = new ContentVersion(
                Title = 'Penguins',
                PathOnClient = 'Penguins.jpg',
                VersionData = Blob.valueOf('Test Content'),
                IsMajorVersion = true
            );
            insert contentVersion;
            List<ContentDocument> documents = [SELECT Id, Title, LatestPublishedVersionId FROM ContentDocument];

            Test.startTest();
            String s = XCSReclamiUtils.getUrlForDownloadFile(documents[0].Id);
            Test.stopTest();
        
    }

   @isTest
    public static void testcreaCorrispondenza(){
    
            Case c = new case();
            insert c;

            List<String> listS = new List<String>();
            listS.add('STRINGA1');

            Test.startTest();
            XCSReclamiUtils.creaCorrispondenza(c, 'TESTO TEST', listS);
            Test.stopTest();
        
    }

   @isTest
    public static void testcreaCorrispondenza2(){
    
        Case c = new case();
        insert c;

   	    Blob b = Blob.valueOf('Test Data');
    	
    	Attachment attachment = new Attachment();
    	attachment.ParentId = c.Id;
    	attachment.Name = 'Test Attachment for Parent';
    	attachment.Body = b;
    	
    	insert(attachment);

        List<Attachment> att = [SELECT Id, Description FROM Attachment];

        Test.startTest();
        XCSReclamiUtils.creaCorrispondenza(c, 'TESTO TEST', att);
        Test.stopTest();
        
    }




   @isTest
    public static void testwriteXCSMessaggio(){

        XCS_Categoria__c xcsParent = XCS_CategoriaUtil.getCategoryForExternalId('5355');
        xcsParent.External_Id__c = '5354';
        xcsParent.Livello__c = 0;
        insert xcsParent;
       
        XCS_Categoria__c categPostVendita = XCS_CategoriaUtil.getCategoryForExternalId('5355');
        categPostVendita.Parent__c = xcsParent.Id;
        insert categPostVendita;
        Account personalAccount = TestDataFactory.insertAccount();
        String societa = XCSCompassConstants.COMPASS;
        String json = '{"dettagliOutputObj":{"headerOutput":{"tipoDettagli":"4137","dataComunicazione":"2019-12-20","dataRicezione":"2019-12-20","dataRicezioneIDM":"2019-12-20","delegaPresente":"false","accessoDati":"false","categoriaDettagli":{"Id":"'+categPostVendita.id+'","Name":"Mancata variazione IBAN","External_Id__c":"3395"},"modalitaInvioDettagli":"Telegramma","isGrave":false},"radioOutput":{"rimborsoOutput":{"selection":"No","value":null},"standaloneOutput":{"selection":"No","value":null},"futuroOutput":null,"comuniOutput":{"abbuonoOutput":{"selection":"No","value":null},"risarcimentoOutput":{"selection":"No","value":null}}},"attribuzioneReclamo":["SOCIETA"],"codaSelezionata":{"Label":" - Selezionare Coda -","DeveloperName":"DN_53"},"contattoPrecedente":"Ufficio Sede","aggiuntiviOutput":null},"clienteSelezionatoContainer":{"cap":"95041","codCliente":"567779","codFiscale":"YHBLRL42S19****C","cognome":"YHABST","dataDepennamento":"0","dataNascita":"19421119","dataNascitaDate":"1942-11-19","dataNascitaItaliana":"19/11/1942","dataRilascio":"0","dataScadenza":"0","denominazione":"ALVARO LUIS YHABST","denominazioneAzienda":"YHABST ALVARO LUIS","email":"","formaGiuridica":"","indirizzo":"VIA INDIPENDENZA 9","localita":"CALTAGIRONE","luogoNascita":"","luogoRilascio":"","ndg":"0","nome":"ALVARO LUIS","numDocumento":"","paeseEstero":"086","piva":"","pratiche":[{"abi":"0","agente":"12","cab":"0","canale":"   ","codAttributoPratica":"","codCliente":"567779","codRecuperatore":"","codStatoPratica":"90","convenzionato":"2472828","dataCaricamento":"22/02/1990","dataEstinzione":"","dealerCode":"2472828","desAttributoPratica":"","desRecuperatore":"","desStatoPratica":"Estinta","elencoCoobbligati":[],"filiale":"206","flagRecupero":"N","iban":"","numConto":"","numPratica":"123125","pan":"","prodotto":"4E","puntoVendita":"0","societa":"Compass","statoPratica":"90","subAgente":"0","tipoPagamento":"BP","tipoPratica":"CO","venditore":"0"}],"praticheFuturo":[],"provincia":"CT","provNascita":"","provRilascio":"","sesso":"M","SFId":"'+personalAccount.Id+'","telCellulare":"","telefonoCasa":"0933 51813","tipoAnagrafica":"P","tipoDocumento":"","tipoRapporto":"","ufficioRilascio":"","tipoCliente":"Cliente"},"praticaSelezionataContainer":{"abi":"0","agente":"12","cab":"0","canale":"   ","codAttributoPratica":"ZZZZ","codCliente":"567779","codRecuperatore":"","codStatoPratica":"90","convenzionato":"2472828","dataCaricamento":"22/02/1990","dataEstinzione":"","dealerCode":"2472828","desAttributoPratica":"-NON IDENTIFICATA-                                ","desRecuperatore":"","desStatoPratica":"Estinta","elencoCoobbligati":[],"filiale":"206","flagRecupero":"N","iban":"","numConto":"","numPratica":"123125","pan":"","prodotto":"4E","puntoVendita":"0","societa":"Compass","statoPratica":"90","subAgente":"0","Tabella_Finanziaria":"999","tipoPagamento":"BP","tipoPratica":"CO","venditore":"0"},"pacchettiAssicurativi":[],"mittentiList":[{"Name__c":"Filiale MILANO LA FOPPA","Email__c":"compass.milano.lafoppa@compass.it","Principale__c":true,"Autorita__c":false,"Predefinito__c":false}],"isSconosciuto":false}';
        Attachment attachment = new Attachment();
	    attachment.Body = Blob.valueOf('Unit Test Attachment Body');
	    attachment.Name = String.valueOf('test.txt');
        List<Attachment> listaAttachment = new List<Attachment>();
        listaAttachment.add(attachment);
        XCSReclamiInput reclamiInput = XCSReclamiUtils.getInputObj(json,societa);
        Case reclamo = XCSReclamiUtils.creaReclamo(reclamiInput, societa, listaAttachment, null);

        

        reclamo.Categoria_Riferimento__c = categPostVendita.id;
        
        
        update reclamo;
        Test.startTest();
        XCSReclamiUtils.writeXCSMessaggio(reclamo);
        Test.stopTest();
        
    }

   @isTest
    public static void testModifReclamoNumber(){

        XCS_Categoria__c categPostVendita = XCS_CategoriaUtil.getCategoryForExternalId('5355');
        insert categPostVendita;
        Account personalAccount = TestDataFactory.insertAccount();
        String societa = XCSCompassConstants.COMPASS;
        String json = '{"dettagliOutputObj":{"headerOutput":{"tipoDettagli":"4137","dataComunicazione":"2019-12-20","dataRicezione":"2019-12-20","dataRicezioneIDM":"2019-12-20","delegaPresente":"false","accessoDati":"false","categoriaDettagli":{"Id":"'+categPostVendita.id+'","Name":"Mancata variazione IBAN","External_Id__c":"3395"},"modalitaInvioDettagli":"Telegramma","isGrave":false},"radioOutput":{"rimborsoOutput":{"selection":"No","value":null},"standaloneOutput":{"selection":"No","value":null},"futuroOutput":null,"comuniOutput":{"abbuonoOutput":{"selection":"No","value":null},"risarcimentoOutput":{"selection":"No","value":null}}},"attribuzioneReclamo":["SOCIETA"],"codaSelezionata":{"Label":" - Selezionare Coda -","DeveloperName":"DN_53"},"contattoPrecedente":"Ufficio Sede","aggiuntiviOutput":null},"clienteSelezionatoContainer":{"cap":"95041","codCliente":"567779","codFiscale":"YHBLRL42S19****C","cognome":"YHABST","dataDepennamento":"0","dataNascita":"19421119","dataNascitaDate":"1942-11-19","dataNascitaItaliana":"19/11/1942","dataRilascio":"0","dataScadenza":"0","denominazione":"ALVARO LUIS YHABST","denominazioneAzienda":"YHABST ALVARO LUIS","email":"","formaGiuridica":"","indirizzo":"VIA INDIPENDENZA 9","localita":"CALTAGIRONE","luogoNascita":"","luogoRilascio":"","ndg":"0","nome":"ALVARO LUIS","numDocumento":"","paeseEstero":"086","piva":"","pratiche":[{"abi":"0","agente":"12","cab":"0","canale":"   ","codAttributoPratica":"","codCliente":"567779","codRecuperatore":"","codStatoPratica":"90","convenzionato":"2472828","dataCaricamento":"22/02/1990","dataEstinzione":"","dealerCode":"2472828","desAttributoPratica":"","desRecuperatore":"","desStatoPratica":"Estinta","elencoCoobbligati":[],"filiale":"206","flagRecupero":"N","iban":"","numConto":"","numPratica":"123125","pan":"","prodotto":"4E","puntoVendita":"0","societa":"Compass","statoPratica":"90","subAgente":"0","tipoPagamento":"BP","tipoPratica":"CO","venditore":"0"}],"praticheFuturo":[],"provincia":"CT","provNascita":"","provRilascio":"","sesso":"M","SFId":"'+personalAccount.Id+'","telCellulare":"","telefonoCasa":"0933 51813","tipoAnagrafica":"P","tipoDocumento":"","tipoRapporto":"","ufficioRilascio":"","tipoCliente":"Cliente"},"praticaSelezionataContainer":{"abi":"0","agente":"12","cab":"0","canale":"   ","codAttributoPratica":"ZZZZ","codCliente":"567779","codRecuperatore":"","codStatoPratica":"90","convenzionato":"2472828","dataCaricamento":"22/02/1990","dataEstinzione":"","dealerCode":"2472828","desAttributoPratica":"-NON IDENTIFICATA-                                ","desRecuperatore":"","desStatoPratica":"Estinta","elencoCoobbligati":[],"filiale":"206","flagRecupero":"N","iban":"","numConto":"","numPratica":"123125","pan":"","prodotto":"4E","puntoVendita":"0","societa":"Compass","statoPratica":"90","subAgente":"0","Tabella_Finanziaria":"999","tipoPagamento":"BP","tipoPratica":"CO","venditore":"0"},"pacchettiAssicurativi":[],"mittentiList":[{"Name__c":"Filiale MILANO LA FOPPA","Email__c":"compass.milano.lafoppa@compass.it","Principale__c":true,"Autorita__c":false,"Predefinito__c":false}],"isSconosciuto":false}';
        Attachment attachment = new Attachment();
	    attachment.Body = Blob.valueOf('Unit Test Attachment Body');
	    attachment.Name = String.valueOf('test.txt');
        List<Attachment> listaAttachment = new List<Attachment>();
        listaAttachment.add(attachment);
        XCSReclamiInput reclamiInput = XCSReclamiUtils.getInputObj(json,societa);
        Case reclamo = XCSReclamiUtils.creaReclamo(reclamiInput, societa, listaAttachment, null);
 
        Test.startTest();
        XCSReclamiUtils.ModifReclamoNumber(reclamo,null);
        XCSReclamiUtils xcsr = new XCSReclamiUtils();
        XCSReclamiUtils.calcolaNumeroProgressivoAss(reclamo,reclamo);
        XCSReclamiUtils.calcolaNumeroProgressivoNonAss(reclamo,reclamo);
//        XCSReclamiUtils.VerificaSubNumber(reclamo,null, 'ASS');
//        XCSReclamiUtils.VerificaSubNumber(reclamo,null, 'NONASS');
        Test.stopTest();
        
    }

   @isTest
    public static void testCreateItemFeed(){

        Test.startTest();
            XCSReclamiUtils.CreateItemFeed cif = new XCSReclamiUtils.CreateItemFeed();

        Test.stopTest();

    }


    private static Map<String,String> createMapAccount(){
        Map<String,String> mAcc = new Map<String,String>();
        mAcc.put('cognome','TEST');
        mAcc.put('codCliente','123456');
        mAcc.put('nome','TEST');
        mAcc.put('dataNascita',null);
        mAcc.put('luogoNascita','TEST');
        mAcc.put('provNascita','TT');
        mAcc.put('sesso','M');
        mAcc.put('codFiscale','TTTSSS69C18H501Q');
        mAcc.put('piva',null);
        mAcc.put('indirizzo','TEST');
        mAcc.put('cap','00100');
        mAcc.put('localita','TEST');
        mAcc.put('provincia','TT');
        mAcc.put('paeseEstero','TEST');
        mAcc.put('email','TEST@TEST.COM');
        mAcc.put('tipoDocumento','PAT');
        mAcc.put('numDocumento','123456789');
        mAcc.put('ufficioRilascio','COMUNE');
        mAcc.put('luogoRilascio','TEST');
        mAcc.put('provRilascio','TT');
        mAcc.put('dataRilascio','01/01/2001');
        mAcc.put('denominazioneAzienda','TEST');
        mAcc.put('formaGiuridica','TEST');
        mAcc.put('tipoAnagrafica','F');
        mAcc.put('dataScadenza',null);
        mAcc.put('telefonoCasa',null);
        mAcc.put('telCellulare',null);
        mAcc.put('tipoRapporto',null);
        mAcc.put('dataDepennamento',null);
        mAcc.put('ndg',null);
        mAcc.put('ragioneSociale',null);
        mAcc.put('cedCom',null);
        return mAcc;

    }

   @isTest
    public static void testXCSReclamiFormContattoSconosciutoCtrl(){

        Map<String,String> mAcc = createMapAccount();

        Test.startTest();
            XCSReclamiFormContattoSconosciutoCtrl.makeCliente(mAcc,'Compass');
            XCSReclamiFormContattoSconosciutoCtrl.makeCliente(mAcc,'Futuro');

        Test.stopTest();

    }


   @isTest
    public static void testXCSReclamiFormInserimentoMBCreditCtrl() {
         Map<String,String> mAcc = createMapAccount();
         Map<String,String> mprat =  new Map<String,String>();
        Test.startTest();
        OCSCliente cliente =  XCSReclamiFormInserimentoMBCreditCtrl.makeCliente(mAcc,mprat);
   
        Test.stopTest();
        System.assert(cliente!=null);

    }

   @isTest
    public static void testXCSReclamiNumProgressivoUtil() {
        Test.startTest();
        String numProgAnn =  XCSReclamiNumProgressivoUtils.getProgAnnAss('Compass');
        String numProg =  XCSReclamiNumProgressivoUtils.getNumProgRec('Compass');   
        Test.stopTest();
        System.assert(numProgAnn!=null);
        System.assert(numProg!=null);

    }

    @isTest
    public static void testDateUtils() {
        Test.startTest();
        DateUtils.formatDateYYYYMMDD(Date.Today());
        DateUtils.formatDateYYMMDD(Date.Today());
        DateUtils.formatDateYYYYscoreMMscoreDD(Date.Today());
        DateUtils.formatDateYYYYslashMMslashDD(Date.Today());
        DateUtils.formatDateDDMMYYYY(Date.Today());
        DateUtils.formatDateDDscoreMMscoreYYYY(Date.Today());
        DateUtils.formatDateDDslashMMslashYYYY(Date.Today());
        DateUtils.formatDateDDscoreMMscoreYYYY(Datetime.now());
        DateUtils.formatDateDDslashMMslashYYYY(Datetime.now());
        DateUtils.parseFromYYYYMMDDString('12102001');
        DateUtils.parseFromYYYYMMDDStringToString('12102001');
        Test.stopTest();
 
    }

   @isTest
    public static void testXCSReclamiInputCompass() {
        XCSReclamiInputCompass reclamiInputCompass = new XCSReclamiInputCompass();
        reclamiInputCompass.pacchettiAssicurativi = new List<Map<String,String>>();
        Map<String,String> mappa = new  Map<String,String>();
        reclamiInputCompass.pacchettiAssicurativi.add(mappa);
        Test.startTest();
        reclamiInputCompass.getPratica();
        reclamiInputCompass.getPacchettiAssicurativi();
        reclamiInputCompass.getCliente();
        reclamiInputCompass.getDettagliOutput();
        reclamiInputCompass.getMittenti();
        reclamiInputCompass.getFiles();
        reclamiInputCompass.isSconosciuto();
        Test.stopTest();
    }


   @isTest
    public static void testXCSReclamiInputFuturo() {
        XCSReclamiInputFuturo reclamiInputFuturo = new XCSReclamiInputFuturo();
        reclamiInputFuturo.praticaSelezionataContainer = new OCSPraticaFuturo();
        Test.startTest();
        reclamiInputFuturo.getPratica();
        reclamiInputFuturo.getPacchettiAssicurativi();
        reclamiInputFuturo.getCliente();
        reclamiInputFuturo.getDettagliOutput();
        reclamiInputFuturo.getMittenti();
        reclamiInputFuturo.getFiles();
        reclamiInputFuturo.isSconosciuto();
        Test.stopTest();
    }

   @isTest
    public static void testXCSReclamiInputMBC() {
        XCSReclamiInputMBC reclamiInputMBC = new XCSReclamiInputMBC();
        reclamiInputMBC.clienteSelezionatoContainer = new OCSCliente();
        reclamiInputMBC.clienteSelezionatoContainer.pratiche = new List<OCSPratica>();
        reclamiInputMBC.clienteSelezionatoContainer.pratiche.add(new OCSPratica());
        Test.startTest();
        reclamiInputMBC.getPratica();
        reclamiInputMBC.getPacchettiAssicurativi();
        reclamiInputMBC.getCliente();
        reclamiInputMBC.getDettagliOutput();
        reclamiInputMBC.getMittenti();
        reclamiInputMBC.getFiles();
        reclamiInputMBC.isSconosciuto();
        Test.stopTest();
    }


   @isTest
    public static void testXCSReclamiRulesCodeUtils() {
        Map<String,Boolean> mapToFilter = new  Map<String,Boolean>();
        Test.startTest();
        XCSReclamiRulesCodeUtils.applyRule('Compass','2',mapToFilter,false);
        XCSReclamiRulesCodeUtils.applyRule('Compass','6',mapToFilter,false);
        XCSReclamiRulesCodeUtils.applyRule('Compass','9b',mapToFilter,false);
        XCSReclamiRulesCodeUtils.applyRule('Compass','9b',mapToFilter,true);
        XCSReclamiRulesCodeUtils.applyRule('Compass','10',mapToFilter,false);
        XCSReclamiRulesCodeUtils.applyRule('Futuro','11b',mapToFilter,false);
        Test.stopTest();
    }

   @isTest
    public static void testSitesTokenUtil() {
        Case myCase = TestDataFactory.insertCase();
        List<XCS_Sites_Token__c> listToken = new List<XCS_Sites_Token__c>();
        String tok = 'abcdefghil1234567890';
        XCS_Sites_Token__c token = new XCS_Sites_Token__c(token__c = tok , Expiration_Date__c = datetime.now(), ObjectId__c = myCase.Id , ComponentName__c = 'c:CRMReclamiFrodeForwardAndTrack' ,ComponentApp__c = 'c:CRMReclamiFrodeForwardAndTrackApp');
        insert token;
        listToken.add(token);
        Test.startTest();
        SitesTokenUtil.generateToken(myCase.Id,datetime.now().addMinutes(400),'c:CRMReclamiFrodeForwardAndTrack','c:CRMReclamiFrodeForwardAndTrackApp');
        SitesTokenUtil.generateToken(myCase.Id,datetime.now().addMinutes(400),'c:CRMReclamiFrodeForwardAndTrack','c:CRMReclamiFrodeForwardAndTrackApp','Oscuro');
        SitesTokenUtil.generateToken(datetime.now().addMinutes(400),'c:CRMReclamiFrodeForwardAndTrack','c:CRMReclamiFrodeForwardAndTrackApp',myCase.Id,'Messaggio');
        SitesTokenUtil.verifyToken(listToken);
        SitesTokenUtil.burnToken(listToken);
        SitesTokenUtil.burnToken(token.Id);
        Test.stopTest();
    } 


    @isTest
    public static void testReclamiTriggerHandler() {
            XCS_CompassParameters__c param = new XCS_CompassParameters__c(Name='inviomail.mock',Value__c= 'test@gmail.com');
            upsert param;
 
            XCS_Categoria__c cat = new XCS_Categoria__c(Name = '2',External_Id__c = '2');
            insert cat;
            Account acc = TestDataFactory.insertAccount();
             Case myCase = new Case();
            myCase.Status = 'New';
            myCase.Subject = 'Test';
            myCase.Esito__c='Esito';
            myCase.RecordTypeId = RecordTypeUtil.getCaseRecordType('CRM_Reclami');
            myCase.AccountId = acc.id;
            myCase.NumeroPratica__c = '12345';
            myCase.Scadenza_Reclamo__c = Date.today();
            myCase.Categoria_Riferimento__c = cat.Id;
            Group que = [SELECT Id,DeveloperName FROM Group WHERE DeveloperName ='F101'  LIMIT 1];
            myCase.OwnerId=que.Id;
            insert myCase;        
            Test.startTest();
            Group que2 = [SELECT Id,DeveloperName FROM Group WHERE DeveloperName ='F102'  LIMIT 1];
            myCase.OwnerId=que2.Id;
            myCase.Anno__c = '2001';
    
            update myCase;
            Test.stopTest();
    } 


}