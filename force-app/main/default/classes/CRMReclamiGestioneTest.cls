@isTest
public with sharing class CRMReclamiGestioneTest {

    private static void insertVarie(){

        ApiRest__c rest4 = new ApiRest__c(Method__c = 'POST' ,Test_Response__c='',Test_Request__c = 'testRequest',Mock__c = false,User__c = 'CDSLF00',Password__c = 'P00FLSDC' ,ref__c = 'CompassInternal',Name ='ocs.recuperaDatiPostvendita',EndPoint__c = 'https://richiestaonlinesvi.compassonline.it/B2BSOAP/rest/B2BREST/execute');
        insert rest4;
        ApiUtil__c uti = new ApiUtil__c(Name = 'CompassInternal' ,EndPoint__c ='https://richiestaonlinesvi.compassonline.it/B2BSOAP/rest/B2BREST/execute' ,Password__c = 'P00FLSDC',User__c = 'CDSLF00');      
        insert uti;
    }
    private static testmethod void CRMReclamiGestioneChiusuraTotaleCtrlTest() {
        
        Account a = new Account();
        a.firstname='LEO';
        a.lastname = 'GULLOTTA';
        a.Codice_Fiscale__c  = 'RTUMRN89C02R800Q';
        a.Codice_Fiscale__pc = 'RTUMRN89C02R800Q';
        a.OCS_External_Id__c = '123456';
        insert a;

        Case c = new Case();
        // c.Subject = 
        c.NumeroPratica__c = '1234';
        c.AccountId = a.Id;
        c.Status = 'Sospeso';
        insert c;

        Test.startTest();

            CRMReclamiGestioneChiusuraTotaleCtrl.getCase(c.id);
        	CRMReclamiGestioneChiusuraTotaleCtrl.isDecisioneVisible('4137');
        	CRMReclamiGestioneChiusuraTotaleCtrl.getInitValues(c);
        	CRMReclamiGestioneChiusuraTotaleCtrl.getHasResponsabilita(c.id);
        	CRMReclamiGestioneChiusuraTotaleCtrl.setValoriResponsabilita('Compass', c.Id);
        	List <responsabilita__mdt> lResp = [SELECT Id FROM responsabilita__mdt];
        	CRMReclamiGestioneChiusuraTotaleCtrl.getResponsabilita('Compass', lResp);
        	CRMReclamiGestioneChiusuraTotaleCtrl.getResponsabilitaSearched('Compass', 'Reclamo');
        	List<XCS_Responsabilita__c> lRespc = [SELECT Id FROM XCS_Responsabilita__c];
        	XCS_Responsabilita__c xResp = new XCS_Responsabilita__c();
        	List<String> s = new List<String>();
            for(responsabilita__mdt x : [SELECT Id FROM responsabilita__mdt LIMIT 5]){
				s.add(x.Id);                
            }
        	CRMReclamiGestioneChiusuraTotaleCtrl.createRecordResponsabilita(c.id, a.id, s);
        	List<Attachment> lAtt = [SELECT id FROM Attachment];
        	CRMReclamiGestioneChiusuraTotaleCtrl.createRecordCaseIDM(c.id, lAtt);
        
        Test.stopTest();
       
    }


    private static testmethod void CRMReclamiGestioneContainerControllerTest() {
        

        insertVarie();



        Account a = new Account();
        a.firstname='LEO';
        a.lastname = 'GULLOTTA';
        a.Codice_Fiscale__c  = 'RTUMRN89C02R800Q';
        a.Codice_Fiscale__pc = 'RTUMRN89C02R800Q';
        a.OCS_External_Id__c = '123456';
        insert a;

        Account_Futuro_MBCS__c a1 = new Account_Futuro_MBCS__c();
        a1.FirstName__c='LEO';
        a1.LastName__c = 'GULLOTTA';
        a1.Codice_Fiscale__c  = 'RTUMRN89C02R800Q';
        a1.External_Id__c = '123456';
        insert a1;

        Attachment attachment = new Attachment();
	    attachment.Body = Blob.valueOf('Unit Test Attachment Body');
	    attachment.Name = String.valueOf('test.txt');
        List<Attachment> listaAttachment = new List<Attachment>();
        listaAttachment.add(attachment);

        Case c = new Case();
        // c.Subject = 
        c.NumeroPratica__c = '1234';
        c.AccountId = a.Id;
        c.Status = 'Sospeso';
        c.Stage_Inadempimento__c = '4165';
        c.is_frode__c = true;
        c.Referenced_Company__c = 'Compass';
        insert c;

        Case c1 = new Case();
        // c.Subject = 
        c1.NumeroPratica__c = '5678';
        c1.AccountId = a.Id;
        c1.Status = 'Nuovo';
        c1.Stage_Inadempimento__c = '4165';
        c1.is_frode__c = false;
        insert c1;

		Map<String,List<String>> serviceIdResponseMap = new Map<String,List<String>>();
        
        List<String> respRDPV = new List<String>();
        
        respRDPV.add('{"resultCode":0,"resultMessage":"Ok", "pratiche":[{"numPratica":"1234","codCliente":null,"abi":null,"cab":null,"numConto":null,"iban":null,"statoPratica":null,"tipoPagamento":null,"prodotto":null,"filiale":null,"dataEstinzione":null,"tipoPratica":null,"dataCaricamento":null,"pan":null,"convenzionato":null,"puntoVendita":null,"venditore":null,"agente":null,"subAgente":null,"flagRecupero":null,"classiRecupero":null,"societa":null,"elencoCoobbligati":null,"codStatoPratica":null,"codAttributoPratica":null,"desStatoPratica":null,"desAttributoPratica":null,"codRecuperatore":null,"desRecuperatore":null,"canale":null}],"cliente":[{"cognome":"GIULIANI","codCliente":"55281774","nome":"FABIO", "dataNascita":"19690318", "luogoNascita":"ROMA", "provNascita":"RM", "sesso":"M", "codFiscale":null, "piva":null, "indirizzo":"VIALE ETIOPIA", "cap":"00199", "localita":"ROMA", "provincia":"RM", "paeseEstero":null, "email":null, "tipoDocumento":"", "numDocumento":"","ufficioRilascio":""}]}');

        serviceIdResponseMap.put('recuperaDatiPostvendita', respRDPV);
        
        UtilityMockResponse UMR = new UtilityMockResponse(); 


        Test.startTest();
            Test.setMock(HttpCalloutMock.class, new UtilityMockResponseMultipleService(serviceIdResponseMap));


            Map <String,String> mpm = CRMReclamiGestioneContainerController.makePraticaMap(c,'TEST');
            Messaging.SingleEmailMessage sem = new Messaging.SingleEmailMessage();
            sem.ToAddresses= new String[]{'test@test.com'};
            sem.Subject='oggetto test';
            sem.HtmlBody='test';
            sem.PlainTextBody='test';
            CRMReclamiGestioneContainerController.linkEmailToCase(sem, c.Id);

            CRMReclamiGestioneContainerController.isEditableDataScadenza('Compass', '5418');

            CRMReclamiGestioneContainerController.getCase(c.Id);
            CRMReclamiGestioneContainerController.isInadempimentoChangeStatusCTRL(c.Id, '4166');
            CRMReclamiGestioneContainerController.getListViewId();
            CRMReclamiGestioneContainerController.isFrodeCTRL('Piano di rientro', 'Compass', c.Id);
            CRMReclamiGestioneContainerController.isFrodeCTRL('Reclamo', 'Compass', c1.Id);
            CRMReclamiGestioneContainerController.hasEditAccess(c.id);
            CRMReclamiGestioneContainerController.hasIDMResponse(true, listaAttachment, 'Compass', c.Id);
            CRMReclamiGestioneContainerController.hasIDMResponse(false, listaAttachment, 'Compass', c.Id);
            CRMReclamiGestioneContainerController.hasIDMResponse(true, listaAttachment, 'Futuro', c.Id);
            CRMReclamiGestioneContainerController.hasIDMResponse(false, listaAttachment, 'Futuro', c.Id);
            CRMReclamiGestioneContainerController.hasIDMResponse(true, listaAttachment, 'MBCredit Solutions', c.Id);
            CRMReclamiGestioneContainerController.hasIDMResponse(false, listaAttachment, 'MBCredit Solutions', c.Id);
            CRMReclamiGestioneContainerController.deleteAttachment(attachment.id, c.Id);
            String sId = Id.valueOf(c.Id);
            CRMReclamiGestioneContainerController.getReclamo(sId);

        Test.stopTest();
       
    }

    private static testmethod void CRMReclamiCorrispondenzaControllerTest() {
        
        Account a = new Account();
        a.firstname='LEO';
        a.lastname = 'GULLOTTA';
        a.Codice_Fiscale__c  = 'RTUMRN89C02R800Q';
        a.Codice_Fiscale__pc = 'RTUMRN89C02R800Q';
        a.OCS_External_Id__c = '123456';
        insert a;

        Case c = new Case();
        c.NumeroPratica__c = '1234';
        c.AccountId = a.Id;
        c.Status = 'Sospeso';
        c.Stage_Inadempimento__c = '4165';
        c.is_frode__c = true;
        c.Referenced_Company__c = 'Compass';
        insert c;



        Test.startTest();
            CRMReclamiCorrispondenzaController.getEmails(c.Id);
        Test.stopTest();
       
    }

    private static testmethod void CRMReclamiFormIDMControllerTest() {
        
        Account a = new Account();
        a.firstname='LEO';
        a.lastname = 'GULLOTTA';
        a.Codice_Fiscale__c  = 'RTUMRN89C02R800Q';
        a.Codice_Fiscale__pc = 'RTUMRN89C02R800Q';
        a.OCS_External_Id__c = '123456';
        insert a;

        Case c = new Case();
        c.NumeroPratica__c = '1234';
        c.AccountId = a.Id;
        c.Status = 'Sospeso';
        c.Stage_Inadempimento__c = '4165';
        c.is_frode__c = true;
        c.Referenced_Company__c = 'Compass';
        insert c;

        Id qId = [SELECT Id FROM Group WHERE Type = 'Queue' AND DeveloperName = 'F101'].Id;


        Case c1 = new Case();
        // c.Subject = 
        c1.NumeroPratica__c = '5678';
        c1.AccountId = a.Id;
        c1.Status = 'Nuovo';
        c1.Stage_Inadempimento__c = '4165';
        c1.is_frode__c = false;
        c1.ParentId = c.Id;
        c1.OwnerId = qId;
        insert c1;

        Test.startTest();
            CRMReclamiFormIDMController.loadObjects(c1.Id);
            CRMReclamiFormIDMController.gestisciReclamo(c1.Id);
        Test.stopTest();
       
    }

    private static testmethod void CRMReclamiGestioneChiusuraControllerTest() {
        
        Account a = new Account();
        a.firstname='LEO';
        a.lastname = 'GULLOTTA';
        a.Codice_Fiscale__c  = 'RTUMRN89C02R800Q';
        a.Codice_Fiscale__pc = 'RTUMRN89C02R800Q';
        a.OCS_External_Id__c = '123456';
        insert a;

        Case c = new Case();
        // c.Subject = 
        c.NumeroPratica__c = '1234';
        c.AccountId = a.Id;
        c.Status = 'Sospeso';
        c.Stage_Inadempimento__c = '4165';
        c.is_frode__c = true;
        c.Referenced_Company__c = 'Compass';
        insert c;

        Test.startTest();
            CRMReclamiGestioneChiusuraController.getInitValues(c);
        Test.stopTest();
       
    }

    private static testmethod void CRMReclamiTabReclamiAssociatiControllerTest() {
        
        Account a = new Account();
        a.firstname='LEO';
        a.lastname = 'GULLOTTA';
        a.Codice_Fiscale__c  = 'RTUMRN89C02R800Q';
        a.Codice_Fiscale__pc = 'RTUMRN89C02R800Q';
        a.OCS_External_Id__c = '123456';
        insert a;

        XCS_Categoria__c categPostVendita = XCS_CategoriaUtil.getCategoryForExternalId('5355');
        insert categPostVendita;


        Case c = new Case();
        c.NumeroPratica__c = '1234';
        c.AccountId = a.Id;
        c.Status = 'Sospeso';
        c.Stage_Inadempimento__c = '4165';
        c.is_frode__c = true;
        c.Referenced_Company__c = 'Compass';
        c.Numero_Reclamo__c = 'TEST-TEST';
        c.Numero_Progressivo_Reclamo__c = 'TEST1';
        c.Categoria_Riferimento__c = categPostVendita.Id;
        insert c;
  
        Case c1 = new Case();
        c1.NumeroPratica__c = '1234';
        c1.AccountId = a.Id;
        c1.Status = 'Sospeso';
        c1.Stage_Inadempimento__c = '4165';
        c1.is_frode__c = true;
        c1.Referenced_Company__c = 'Compass';
        c1.Numero_Reclamo__c = 'TEST-TEST';
        c1.Numero_Progressivo_Reclamo__c = 'TEST1';
        c1.Categoria_Riferimento__c = categPostVendita.Id;
        insert c1;
        
        String sId = Id.valueOf(c.Id);

        Test.startTest();
            CRMReclamiTabReclamiAssociatiController.doInit(sId);
            CRMReclamiTabReclamiAssociatiController.preRedirect(sId);
        Test.stopTest();
       
    }

    private static testmethod void CRMReclamiGestioneDettagliContainerCtrlTest() {
        
        Account a = new Account();
        a.firstname='LEO';
        a.lastname = 'GULLOTTA';
        a.Codice_Fiscale__c  = 'RTUMRN89C02R800Q';
        a.Codice_Fiscale__pc = 'RTUMRN89C02R800Q';
        a.OCS_External_Id__c = '123456';
        insert a;

        XCS_Categoria__c categPostVendita = XCS_CategoriaUtil.getCategoryForExternalId('5355');
        insert categPostVendita;


        Case c = new Case();
        c.NumeroPratica__c = '1234';
        c.AccountId = a.Id;
        c.Status = 'Sospeso';
        c.Stage_Inadempimento__c = '4165';
        c.is_frode__c = true;
        c.Referenced_Company__c = 'Compass';
        c.Numero_Reclamo__c = 'TEST-TEST';
        c.Numero_Progressivo_Reclamo__c = 'TEST1';
        c.Categoria_Riferimento__c = categPostVendita.Id;
        insert c;
  
        Case c1 = new Case();
        c1.NumeroPratica__c = '1234';
        c1.AccountId = a.Id;
        c1.Status = 'Sospeso';
        c1.Stage_Inadempimento__c = '4165';
        c1.is_frode__c = true;
        c1.Referenced_Company__c = 'Compass';
        c1.Numero_Reclamo__c = 'TEST-TEST';
        c1.Numero_Progressivo_Reclamo__c = 'TEST1';
        c1.Categoria_Riferimento__c = categPostVendita.Id;
        insert c1;
        
        String sId = Id.valueOf(c.Id);

        Test.startTest();
            CRMReclamiGestioneDettagliContainerCtrl.getModInvio();
            CRMReclamiGestioneDettagliContainerCtrl.getMod(sId);
            CRMReclamiGestioneDettagliContainerCtrl.getDecisione(sId);
        Test.stopTest();
       
    }

    private static testmethod void CRMReclamiGestioneHeaderControllerTest() {

        User currentUser = [SELECT Id, RNT_group_id__c FROM User where id =: UserInfo.getUserId()];

        Account a = new Account();
        a.firstname='LEO';
        a.lastname = 'GULLOTTA';
        a.Codice_Fiscale__c  = 'RTUMRN89C02R800Q';
        a.Codice_Fiscale__pc = 'RTUMRN89C02R800Q';
        a.OCS_External_Id__c = '123456';
        insert a;

        XCS_Categoria__c categPostVendita = XCS_CategoriaUtil.getCategoryForExternalId('5355');
        insert categPostVendita;


        Case c = new Case();
        c.NumeroPratica__c = '1234';
        c.AccountId = a.Id;
        c.Status = 'Sospeso';
        c.Stage_Inadempimento__c = '4165';
        c.is_frode__c = true;
        c.Referenced_Company__c = 'Compass';
        c.Numero_Reclamo__c = 'TEST-TEST';
        c.Numero_Progressivo_Reclamo__c = 'TEST1';
        c.Categoria_Riferimento__c = categPostVendita.Id;
        c.Tipo_Reclamo__c = '5433';
        c.Assegnatario__c = currentUser.Id;
        c.Scadenza_Reclamo__c = Date.valueOf('2019-10-16');
        c.Data_Ricezione__c = date.valueOf('2019-10-16');
        insert c;
  
        Case c1 = new Case();
        c1.NumeroPratica__c = '1234';
        c1.AccountId = a.Id;
        c1.Status = 'Sospeso';
        c1.Stage_Inadempimento__c = '4165';
        c1.is_frode__c = true;
        c1.Referenced_Company__c = 'Compass';
        c1.Numero_Reclamo__c = 'TEST-TEST';
        c1.Numero_Progressivo_Reclamo__c = 'TEST1';
        c1.Categoria_Riferimento__c = categPostVendita.Id;
        insert c1;
        

        String sId = Id.valueOf(c.Id);
        String cId = Id.valueOf(categPostVendita.Id);

        Test.startTest();
            CRMReclamiGestioneHeaderController.getInitValues('Compass');
            CRMReclamiGestioneHeaderController.getInitTipo(c.Id,XCSCompassConstants.MBC);
            CRMReclamiGestioneHeaderController.isDataScadenzaWritable('5433', 'Compass');
            CRMReclamiGestioneHeaderController.loadUserGroup();
            CRMReclamiGestioneHeaderController.getCurrentUser(sId);

            Id codaId = [Select id from group where type='Queue' and DeveloperName ='Q141'].Id;

            CRMReclamiGestioneHeaderController.salvaReclamoGestioneHeaderApex(sId, cId, 'Si', 'Si', 'Si', 'Nuovo','R', codaId);
            CRMReclamiGestioneHeaderController.checkAss(sId);
            CRMReclamiGestioneHeaderController.getAss(XCSCompassConstants.COMPASS);
            CRMReclamiGestioneHeaderController.calcolaScadenzaReclamo(c.Id, true);
            CRMReclamiGestioneHeaderController.calcolaScadenzaReclamo(c.Id, false);

        Test.stopTest();
       
    }

    private static testmethod void CRMReclamiGestioneRispostaApprCtrlTest() {

        Account a = new Account();
        a.firstname='LEO';
        a.lastname = 'GULLOTTA';
        a.Codice_Fiscale__c  = 'RTUMRN89C02R800Q';
        a.Codice_Fiscale__pc = 'RTUMRN89C02R800Q';
        a.OCS_External_Id__c = '123456';
        insert a;

        XCS_Categoria__c categPostVendita = XCS_CategoriaUtil.getCategoryForExternalId('5355');
        insert categPostVendita;


        Case c = new Case();
        c.NumeroPratica__c = '1234';
        c.AccountId = a.Id;
        c.Status = 'Sospeso';
        c.Stage_Inadempimento__c = '4165';
        c.is_frode__c = true;
        c.Referenced_Company__c = 'Compass';
        c.Numero_Reclamo__c = 'TEST-TEST';
        c.Numero_Progressivo_Reclamo__c = 'TEST1';
        c.Categoria_Riferimento__c = categPostVendita.Id;
        c.Tipo_Reclamo__c = '5433';
        c.Scadenza_Reclamo__c = Date.valueOf('2019-10-16');
        c.Data_Ricezione__c = date.valueOf('2019-10-16');
        c.Autorizzazione_Livello_1__c = 'Nessuno';
        c.Autorizzazione_Livello_2__c = 'Nessuno';
        insert c;

        Account personalAccount = TestDataFactory.insertAccount();

        String sId = Id.valueOf(c.Id);
        String cId = Id.valueOf(categPostVendita.Id);

        String str = JSON.serialize(c);

        Test.startTest();
            CRMReclamiGestioneRispostaApprCtrl.getProfileLevelUser('Compass');
            CRMReclamiGestioneRispostaApprCtrl.getCase(c.Id);
            CRMReclamiGestioneRispostaApprCtrl.autorizzaRespingiCtrl(str, 'Richiedi Autorizzazione');
            CRMReclamiGestioneRispostaApprCtrl.autorizzaRespingiCtrl(str, 'Autorizza Lv.1');
            CRMReclamiGestioneRispostaApprCtrl.autorizzaRespingiCtrl(str, 'Respingi Lv.1');
            CRMReclamiGestioneRispostaApprCtrl.autorizzaRespingiCtrl(str, 'Autorizza Lv.2');
            CRMReclamiGestioneRispostaApprCtrl.autorizzaRespingiCtrl(str, 'Respingi Lv.2');


        Test.stopTest();
       
    }

    private static testmethod void CRMReclamiGestioneRispostaLetteraCtrlTest() {

        Account a = new Account();
        a.firstname='LEO';
        a.lastname = 'GULLOTTA';
        a.Codice_Fiscale__c  = 'RTUMRN89C02R800Q';
        a.Codice_Fiscale__pc = 'RTUMRN89C02R800Q';
        a.OCS_External_Id__c = '123456';
        insert a;

        XCS_Categoria__c categPostVendita = XCS_CategoriaUtil.getCategoryForExternalId('5355');
        insert categPostVendita;


        Case c = new Case();
        c.NumeroPratica__c = '1234';
        c.AccountId = a.Id;
        c.Status = 'Sospeso';
        c.Stage_Inadempimento__c = '4165';
        c.is_frode__c = true;
        c.Referenced_Company__c = 'Compass';
        c.Numero_Reclamo__c = 'TEST-TEST';
        c.Numero_Progressivo_Reclamo__c = 'TEST1';
        c.Categoria_Riferimento__c = categPostVendita.Id;
        c.Tipo_Reclamo__c = '5433';
        c.Scadenza_Reclamo__c = Date.valueOf('2019-10-16');
        c.Data_Ricezione__c = date.valueOf('2019-10-16');
        insert c;
        String sId = Id.valueOf(c.Id);

        XCS_Mittente__c xcsM = new XCS_Mittente__c();
        xcsM.Case__c = c.Id;
        xcsM.Citta__c = 'TEST';
        xcsM.Via__c = 'TEST';
        xcsM.Tipologia__c = 'Cliente'; 
        xcsM.Salutation__c = ''; 
        xcsM.Provincia__c = 'LO';
        xcsM.Principale__c = true;
        xcsM.Predefinito__c = false;
        xcsM.Name__c = 'AMALIO SAAELIVO';
        xcsM.External_Id__c = ''; 
        xcsM.Incident_Id__c = '';
        xcsM.Codice_Postale__c = '00199';
        xcsM.Autorita__c = true;
        insert xcsM;

        Testo_Standard__c testoS = new Testo_Standard__c();
        testoS.Societa__c = 'Compass';
        testoS.Testo__c = 'TEST';
        testoS.Name = 'C_348';
        testoS.Titolo__c = 'TEST';
        testoS.RecordTypeId = RecordTypeUtil.getStandardTextRecordType();
        insert testoS;

		Map<String,List<String>> serviceIdResponseMap = new Map<String,List<String>>();
        List<String> respDAR= new List<String>();
        respDAR.add('{"resultMessage":"Ok","resultCode":0,"datiAggiuntiviReclamiResponse":{"abi":"","cab":"","cc":"","importo":"","nomeBanca":"","dataRevoca":"","dataDepennamento":"20061113","tabellaFinanziaria":"AA0","codAttributoPM":"PGEN","desAttributoPM":"PRODOTTO GENERICO"}}');
        serviceIdResponseMap.put('datiAggiuntiviReclami', respDAR);

        String responseTest ='{"resultMessage":"Ok","resultCode":0,"datiAggiuntiviReclamiResponse":{"abi":"","cab":"","cc":"","importo":"","nomeBanca":"","dataRevoca":"","dataDepennamento":"20061113","tabellaFinanziaria":"AA0","codAttributoPM":"PGEN","desAttributoPM":"PRODOTTO GENERICO"}}'; 
        ApiRest__c test1 = new ApiRest__c(Method__c = 'POST' ,Test_Response__c='',Test_Request__c = '',Mock__c = false,User__c = 'CDSLF00',Password__c = 'P00FLSDC' ,Name ='ocs.datiAggiuntiviReclami',EndPoint__c = 'https://richiestaonlinesvi.compassonline.it/B2BSOAP/rest/B2BREST/execute', Ref__c='CompassInternal');      
        insert test1;
        ApiUtil__c uti = new ApiUtil__c(Name = 'CompassInternal' ,EndPoint__c ='https://richiestaonlinesvi.compassonline.it/B2BSOAP/rest/B2BREST/execute' ,Password__c = 'P00FLSDC',User__c = 'CDSLF00');      
        insert uti;        

        Test.startTest();
            Test.setMock(HttpCalloutMock.class, new UtilityMockResponseMultipleService(serviceIdResponseMap));
            CRMReclamiGestioneRispostaLetteraCtrl.getCase(sId);
            CRMReclamiGestioneRispostaLetteraCtrl.loadStdtexts('3472', XCSCompassConstants.COMPASS);
            CRMReclamiGestioneRispostaLetteraCtrl.loadStdtexts('5388', XCSCompassConstants.FUTURO);
            CRMReclamiGestioneRispostaLetteraCtrl.loadStdtexts('5739', XCSCompassConstants.MBC);
            CRMReclamiGestioneRispostaLetteraCtrl.getMessageStandard('TEST');
            CRMReclamiGestioneRispostaLetteraCtrl.getMessageStandard(testoS.Name, sId);
            CRMReclamiGestioneRispostaLetteraCtrl.salvaLetteraCtrl(sId, 'TESTO DI RISPOSTA');
            CRMReclamiGestioneRispostaLetteraCtrl.loadText('TEST_TEST', c,null );
            CRMReclamiGestioneRispostaLetteraCtrl.generateAndAttach('TEST_TEST', c,'Compass Logo', 'TEST_TEST', '123123', 'Fabio', 'Giuliani');
        Test.stopTest();
       
    }

    private static testmethod void CRMReclamiGestioneRisLetMailCtrlTest() {

        Account a = new Account();
        a.firstname='LEO';
        a.lastname = 'GULLOTTA';
        a.Codice_Fiscale__c  = 'RTUMRN89C02R800Q';
        a.Codice_Fiscale__pc = 'RTUMRN89C02R800Q';
        a.OCS_External_Id__c = '123456';
        insert a;

        XCS_Categoria__c categPostVendita = XCS_CategoriaUtil.getCategoryForExternalId('5355');
        insert categPostVendita;

        Attachment attachment = new Attachment();
	    attachment.Body = Blob.valueOf('Unit Test Attachment Body');
	    attachment.Name = String.valueOf('test.txt');
        attachment.Description = '';
        List<Attachment> listaAttachment = new List<Attachment>();
        listaAttachment.add(attachment);

        Case c = new Case();
        c.NumeroPratica__c = '1234';
        c.AccountId = a.Id;
        c.Status = 'Sospeso';
        c.Stage_Inadempimento__c = '4165';
        c.is_frode__c = true;
        c.Referenced_Company__c = 'Compass';
        c.Numero_Reclamo__c = 'TEST-TEST';
        c.Numero_Progressivo_Reclamo__c = 'TEST1';
        c.Categoria_Riferimento__c = categPostVendita.Id;
        c.Tipo_Reclamo__c = '5433';
        c.Scadenza_Reclamo__c = Date.valueOf('2019-10-16');
        c.Data_Ricezione__c = date.valueOf('2019-10-16');
        insert c;

        Test.startTest();
            CRMReclamiGestioneRisLetMailCtrl.getInitValues(XCSCompassConstants.COMPASS);
        Test.stopTest();
       
    }

    private static testmethod void SFAVerificaInadempimentoControllerTest() {

        Account a = new Account();
        a.firstname='LEO';
        a.lastname = 'GULLOTTA';
        a.Codice_Fiscale__c  = 'RTUMRN89C02R800Q';
        a.Codice_Fiscale__pc = 'RTUMRN89C02R800Q';
        a.OCS_External_Id__c = '123456';
        insert a;

        XCS_Categoria__c categPostVendita = XCS_CategoriaUtil.getCategoryForExternalId('5355');
        insert categPostVendita;

        Attachment attachment = new Attachment();
	    attachment.Body = Blob.valueOf('Unit Test Attachment Body');
	    attachment.Name = String.valueOf('test.txt');
        attachment.Description = '';
        List<Attachment> listaAttachment = new List<Attachment>();
        listaAttachment.add(attachment);

        Case c = new Case();
        c.NumeroPratica__c = '1234';
        c.AccountId = a.Id;
        c.Status = 'Sospeso';
        c.Stage_Inadempimento__c = '4165';
        c.is_frode__c = true;
        c.Referenced_Company__c = 'Compass';
        c.Numero_Reclamo__c = 'TEST-TEST';
        c.Numero_Progressivo_Reclamo__c = 'TEST1';
        c.Categoria_Riferimento__c = categPostVendita.Id;
        c.Tipo_Reclamo__c = '5411';
        c.Scadenza_Reclamo__c = Date.valueOf('2019-10-16');
        c.Data_Ricezione__c = date.valueOf('2019-10-16');
        insert c;

        String sId = Id.valueOf(c.Id);

        Test.startTest();
            SFAVerificaInadempimentoController.loadCase();
            SFAVerificaInadempimentoController.loadCaseCtrl(sId);
            SFAVerificaInadempimentoController.getAttachments(c.Id);
            SFAVerificaInadempimentoController.getNotes(c.Id);
            SFAVerificaInadempimentoController.getEmails(c.Id);
            SFAVerificaInadempimentoController.getFiles(c.Id);
            SFAVerificaInadempimentoController.assignToCentroRecuperoLegale(c);
            SFAVerificaInadempimentoController.saveAttachments(c.Id, listaAttachment, 1, 'TEST');
            
        Test.stopTest();
       
    }

    private static testmethod void CRMReclamiInadempimentoFAndTCtrlTest() {

        Account a = new Account();
        a.firstname='LEO';
        a.lastname = 'GULLOTTA';
        a.Codice_Fiscale__c  = 'RTUMRN89C02R800Q';
        a.Codice_Fiscale__pc = 'RTUMRN89C02R800Q';
        a.OCS_External_Id__c = '123456';
        insert a;

        XCS_Categoria__c categPostVendita = XCS_CategoriaUtil.getCategoryForExternalId('5355');
        insert categPostVendita;

        Attachment attachment = new Attachment();
	    attachment.Body = Blob.valueOf('Unit Test Attachment Body');
	    attachment.Name = String.valueOf('test.txt');
        attachment.Description = '';
        List<Attachment> listaAttachment = new List<Attachment>();
        listaAttachment.add(attachment);

        Case c = new Case();
        c.NumeroPratica__c = '1234';
        c.AccountId = a.Id;
        c.Status = 'Sospeso';
        c.Stage_Inadempimento__c = '4165';
        c.is_frode__c = true;
        c.Referenced_Company__c = 'Compass';
        c.Numero_Reclamo__c = 'TEST-TEST';
        c.Numero_Progressivo_Reclamo__c = 'TEST1';
        c.Categoria_Riferimento__c = categPostVendita.Id;
        c.Tipo_Reclamo__c = '5411';
        c.Scadenza_Reclamo__c = Date.valueOf('2019-10-16');
        c.Data_Ricezione__c = date.valueOf('2019-10-16');
        insert c;

        XCS_Sites_Token__c xcsT = new XCS_Sites_Token__c();
        xcsT.ComponentApp__c = 'TEST';
        xcsT.ComponentName__c = 'TEST';
        xcsT.ObjectId__c = 'TEST';
        xcsT.Name = 'TEST';
        xcsT.token__c = '66735361-e5c3-c907-939b-bce8115ffc05';
        insert xcsT;

        String sId = Id.valueOf(c.Id);
        String aId = Id.valueOf(a.Id);
        String sT = Id.valueOf(xcsT.id);

        Test.startTest();
            CRMReclamiInadempimentoFAndTCtrl.getReclamo(c.Id);
            CRMReclamiInadempimentoFAndTCtrl.getFiles(c.Id);
            CRMReclamiInadempimentoFAndTCtrl.getCliente(aId);
            CRMReclamiInadempimentoFAndTCtrl.getCategoria(categPostVendita.Id);
            CRMReclamiInadempimentoFAndTCtrl.makeMessage('TEST', 'TEST');
            CRMReclamiInadempimentoFAndTCtrl.updateCount(sId, 'test', listaAttachment, 'test',xcsT);
            
        Test.stopTest();
       
    }

    private static testmethod void XCSReclamiLetteraRispostaCtrlTest() {

        Account a = new Account();
        a.firstname='LEO';
        a.lastname = 'GULLOTTA';
        a.Codice_Fiscale__c  = 'RTUMRN89C02R800Q';
        a.Codice_Fiscale__pc = 'RTUMRN89C02R800Q';
        a.OCS_External_Id__c = '123456';
        insert a;

        XCS_Categoria__c categPostVendita = XCS_CategoriaUtil.getCategoryForExternalId('5355');
        insert categPostVendita;

        Attachment attachment = new Attachment();
	    attachment.Body = Blob.valueOf('Unit Test Attachment Body');
	    attachment.Name = String.valueOf('test.txt');
        attachment.Description = '';
        List<Attachment> listaAttachment = new List<Attachment>();
        listaAttachment.add(attachment);

        Case c = new Case();
        c.NumeroPratica__c = '1234';
        c.AccountId = a.Id;
        c.Status = 'Sospeso';
        c.Stage_Inadempimento__c = '4165';
        c.is_frode__c = true;
        c.Referenced_Company__c = 'Compass';
        c.Numero_Reclamo__c = 'TEST-TEST';
        c.Numero_Progressivo_Reclamo__c = 'TEST1';
        c.Categoria_Riferimento__c = categPostVendita.Id;
        c.Tipo_Reclamo__c = '5411';
        c.Scadenza_Reclamo__c = Date.valueOf('2019-10-16');
        c.Data_Ricezione__c = date.valueOf('2019-10-16');
        insert c;

        XCS_Sites_Token__c xcsT = new XCS_Sites_Token__c();
        xcsT.ComponentApp__c = 'TEST';
        xcsT.ComponentName__c = 'TEST';
        xcsT.ObjectId__c = 'TEST';
        xcsT.Name = 'TEST';
        xcsT.token__c = '66735361-e5c3-c907-939b-bce8115ffc05';
        insert xcsT;

        String sId = Id.valueOf(c.Id);
        String aId = Id.valueOf(a.Id);
        String sT = Id.valueOf(xcsT.id);


        Test.startTest();
            
        Test.stopTest();
       
    }

    private static testmethod void CRMReclamiInvioRichiestaFeTCtrlTest() {

        Account a = new Account();
        a.firstname='LEO';
        a.lastname = 'GULLOTTA';
        a.Codice_Fiscale__c  = 'RTUMRN89C02R800Q';
        a.Codice_Fiscale__pc = 'RTUMRN89C02R800Q';
        a.OCS_External_Id__c = '123456';
        insert a;

        XCS_Categoria__c categPostVendita = XCS_CategoriaUtil.getCategoryForExternalId('5355');
        insert categPostVendita;

        Attachment attachment = new Attachment();
	    attachment.Body = Blob.valueOf('Unit Test Attachment Body');
	    attachment.Name = String.valueOf('test.txt');
        attachment.Description = '';
        List<Attachment> listaAttachment = new List<Attachment>();
        listaAttachment.add(attachment);

        Case c = new Case();
        c.NumeroPratica__c = '1234';
        c.AccountId = a.Id;
        c.Status = 'Sospeso';
        c.Stage_Inadempimento__c = '4165';
        c.is_frode__c = true;
        c.Referenced_Company__c = 'Compass';
        c.Numero_Reclamo__c = 'TEST-TEST';
        c.Numero_Progressivo_Reclamo__c = 'TEST1';
        c.Categoria_Riferimento__c = categPostVendita.Id;
        c.Tipo_Reclamo__c = '5411';
        c.Scadenza_Reclamo__c = Date.valueOf('2019-10-16');
        c.Data_Ricezione__c = date.valueOf('2019-10-16');
        insert c;

        XCS_Sites_Token__c xcsT = new XCS_Sites_Token__c();
        xcsT.ComponentApp__c = 'TEST';
        xcsT.ComponentName__c = 'TEST';
        xcsT.ObjectId__c = 'TEST';
        xcsT.Name = 'TEST';
        xcsT.token__c = '66735361-e5c3-c907-939b-bce8115ffc05';
        insert xcsT;

        String sId = Id.valueOf(c.Id);
        String aId = Id.valueOf(a.Id);
        String sT = Id.valueOf(xcsT.id);
        String sCat = Id.valueOf(categPostVendita.Id);

        Test.startTest();
            CRMReclamiInvioRichiestaFeTCtrl.getReclamo(sId);
            CRMReclamiInvioRichiestaFeTCtrl.loadMessaggioCTRL(xcsT.token__c);
            CRMReclamiInvioRichiestaFeTCtrl.getFiles(sId);
            CRMReclamiInvioRichiestaFeTCtrl.getCliente(aId);
            CRMReclamiInvioRichiestaFeTCtrl.getCategoria(categPostVendita.Id);
            CRMReclamiInvioRichiestaFeTCtrl.makeMessage('TEST', 'TEST', 'TEST', 'TEST');
            CRMReclamiInvioRichiestaFeTCtrl.fileUpload(c, listaAttachment);
            CRMReclamiInvioRichiestaFeTCtrl.finalConfirm(c, 'TEST', 'TEST', 'TEST', 'TEST', listaAttachment, 1, 'TEST');
            
        Test.stopTest();
       
    }

    private static testmethod void CRMReclamiFrodeForwardAndTrackCtrlTest() {

        Account a = new Account();
        a.firstname='LEO';
        a.lastname = 'GULLOTTA';
        a.Codice_Fiscale__c  = 'RTUMRN89C02R800Q';
        a.Codice_Fiscale__pc = 'RTUMRN89C02R800Q';
        a.OCS_External_Id__c = '123456';
        insert a;

        XCS_Categoria__c categPostVendita = XCS_CategoriaUtil.getCategoryForExternalId('5355');
        insert categPostVendita;

        Attachment attachment = new Attachment();
	    attachment.Body = Blob.valueOf('Unit Test Attachment Body');
	    attachment.Name = String.valueOf('test.txt');
        attachment.Description = '';
        List<Attachment> listaAttachment = new List<Attachment>();
        listaAttachment.add(attachment);

        Case c = new Case();
        c.NumeroPratica__c = '1234';
        c.AccountId = a.Id;
        c.Status = 'Sospeso';
        c.Stage_Inadempimento__c = '4165';
        c.is_frode__c = true;
        c.Referenced_Company__c = 'Compass';
        c.Numero_Reclamo__c = 'TEST-TEST';
        c.Numero_Progressivo_Reclamo__c = 'TEST1';
        c.Categoria_Riferimento__c = categPostVendita.Id;
        c.Tipo_Reclamo__c = '5411';
        c.Scadenza_Reclamo__c = Date.valueOf('2019-10-16');
        c.Data_Ricezione__c = date.valueOf('2019-10-16');
        insert c;
        List <Case> lCas = new List <Case>();
        lCas.add(c);



        Testo_Standard__c testoS = new Testo_Standard__c();
        testoS.Societa__c = 'Compass';
        testoS.Testo__c = 'TEST';
        testoS.Name = 'C_348';
        testoS.Titolo__c = 'TEST';
        testoS.RecordTypeId = RecordTypeUtil.getStandardTextRecordType();
        insert testoS;

        XCS_CompassParameters__c xcsP = new XCS_CompassParameters__c();
        xcsP.value__c = 'https://dev3-compass--r1dev.cs84.force.com/ForwardAndTrack';
        xcsP.Name = 'forwardandtrack.baseurl';
        insert xcsP;

        XCS_CompassParameters__c xcsP2 = new XCS_CompassParameters__c();
        xcsP2.value__c = 'boris90@live.it';
        xcsP2.Name = 'ufficiofrodi.mail';
        insert xcsP2;


        String sId = Id.valueOf(c.Id);
        String aId = Id.valueOf(a.Id);
        String sCat = Id.valueOf(categPostVendita.Id);

        Test.startTest();
            CRMReclamiFrodeForwardAndTrackCtrl.getReclamo(sId);
            CRMReclamiFrodeForwardAndTrackCtrl.getCliente(aId);
            CRMReclamiFrodeForwardAndTrackCtrl.getCategoria(categPostVendita.Id);
            CRMReclamiFrodeForwardAndTrackCtrl.getFiles(sId);
            CRMReclamiFrodeForwardAndTrackCtrl.makeMessage('TEST', 'TEST', 'TEST', 'TEST');
            CRMReclamiFrodeForwardAndTrackCtrl.fileUpload(c, listaAttachment);
            CRMReclamiFrodeForwardAndTrackCtrl.finalConfirm(c, 'TEST', 'TEST', 'TEST', 'TEST', listaAttachment, 1, 'TEST');
            CRMReclamiFrodeForwardAndTrackCtrl.getUserName();
            CRMReclamiFrodeForwardAndTrackCtrl.sendFrodeMail(lCas);
            
            
        Test.stopTest();
       
    }

    private static testmethod void CRMReclamiGesInadContainerCtrlTest() {

        Id rtId = [SELECT Id FROM RecordType WHERE Name = 'Branch'].Id;

        Account a = new Account();
//        a.firstname='LEO';
//        a.lastname = 'GULLOTTA';
        a.Name = 'TEST';
        a.Codice_Fiscale__c  = 'RTUMRN89C02R800Q';
//        a.Codice_Fiscale__pc = 'RTUMRN89C02R800Q';
        a.OCS_External_Id__c = 'UReclami';
        a.RecordTypeId = rtId;
        insert a;

        XCS_Categoria__c categPostVendita = XCS_CategoriaUtil.getCategoryForExternalId('5355');
        insert categPostVendita;
        XCS_Categoria__c categPostVendita2 = XCS_CategoriaUtil.getCategoryForExternalId('5299');
        insert categPostVendita2;

        Attachment attachment = new Attachment();
	    attachment.Body = Blob.valueOf('Unit Test Attachment Body');
	    attachment.Name = String.valueOf('test.txt');
        attachment.Description = '';
        List<Attachment> listaAttachment = new List<Attachment>();
        listaAttachment.add(attachment);

        Case c = new Case();
        c.NumeroPratica__c = '1234';
        c.AccountId = a.Id;
        c.Status = 'Sospeso';
        c.Stage_Inadempimento__c = '4166';
        c.is_frode__c = true;
        c.Referenced_Company__c = 'Compass';
        c.Numero_Reclamo__c = 'TEST-TEST';
        c.Numero_Progressivo_Reclamo__c = 'TEST1';
        c.Categoria_Riferimento__c = categPostVendita.Id;
        c.Tipo_Reclamo__c = '5411';
        c.Scadenza_Reclamo__c = Date.valueOf('2019-10-16');
        c.Data_Ricezione__c = date.valueOf('2019-10-16');
        c.Branch__c = a.Id;
        c.F_T_Sent_Count__c = 3;
        insert c;
        List <Case> lCas = new List <Case>();
        lCas.add(c);

        Case c2 = new Case();
        c2.NumeroPratica__c = '1234';
        c2.AccountId = a.Id;
        c2.Status = 'Sospeso';
        c2.Stage_Inadempimento__c = '4165';
        c2.is_frode__c = true;
        c2.Referenced_Company__c = 'Compass';
        c2.Numero_Reclamo__c = 'TEST-TEST';
        c2.Numero_Progressivo_Reclamo__c = 'TEST1';
        c2.Categoria_Riferimento__c = categPostVendita.Id;
        c2.Tipo_Reclamo__c = '5411';
        c2.Scadenza_Reclamo__c = Date.valueOf('2019-10-16');
        c2.Data_Ricezione__c = date.valueOf('2019-10-16');
        c2.Branch__c = a.Id;
        c2.F_T_Sent_Count__c = 2;
        insert c2;

        Case c3 = new Case();
        c3.NumeroPratica__c = '1234';
        c3.AccountId = a.Id;
        c3.Status = 'Sospeso';
        c3.Stage_Inadempimento__c = '4164';
        c3.is_frode__c = true;
        c3.Referenced_Company__c = 'Compass';
        c3.Numero_Reclamo__c = 'TEST-TEST';
        c3.Numero_Progressivo_Reclamo__c = 'TEST1';
        c3.Categoria_Riferimento__c = categPostVendita.Id;
        c3.Tipo_Reclamo__c = '5411';
        c3.Scadenza_Reclamo__c = Date.valueOf('2019-10-16');
        c3.Data_Ricezione__c = date.valueOf('2019-10-16');
        c3.Branch__c = a.Id;
        c3.F_T_Sent_Count__c = 2;
        insert c3;

        Case c4 = new Case();
        c4.NumeroPratica__c = '1234';
        c4.AccountId = a.Id;
        c4.Status = 'Sospeso';
        c4.Stage_Inadempimento__c = '4166';
        c4.is_frode__c = true;
        c4.Referenced_Company__c = 'Compass';
        c4.Numero_Reclamo__c = 'TEST-TEST';
        c4.Numero_Progressivo_Reclamo__c = 'TEST1';
        c4.Categoria_Riferimento__c = categPostVendita.Id;
        c4.Tipo_Reclamo__c = '5411';
        c4.Scadenza_Reclamo__c = Date.valueOf('2019-10-16');
        c4.Data_Ricezione__c = date.valueOf('2019-10-16');
        c4.Branch__c = a.Id;
        c4.F_T_Sent_Count__c = 2;
        insert c4;

        Case c5 = new Case();
        c5.NumeroPratica__c = '1234';
        c5.AccountId = a.Id;
        c5.Status = 'Sospeso';
        c5.Stage_Inadempimento__c = '4167';
        c5.is_frode__c = true;
        c5.Referenced_Company__c = 'Compass';
        c5.Numero_Reclamo__c = 'TEST-TEST';
        c5.Numero_Progressivo_Reclamo__c = 'TEST1';
        c5.Categoria_Riferimento__c = categPostVendita.Id;
        c5.Tipo_Reclamo__c = '5411';
        c5.Scadenza_Reclamo__c = Date.valueOf('2019-10-16');
        c5.Data_Ricezione__c = date.valueOf('2019-10-16');
        c5.Branch__c = a.Id;
        c5.F_T_Sent_Count__c = 2;
        c5.F_T_Received_Count__c = 2;
        insert c5;

        Case c6 = new Case();
        c6.NumeroPratica__c = '1234';
        c6.AccountId = a.Id;
        c6.Status = 'Sospeso';
        c6.Stage_Inadempimento__c = '4168';
        c6.is_frode__c = true;
        c6.Referenced_Company__c = 'Compass';
        c6.Numero_Reclamo__c = 'TEST-TEST';
        c6.Numero_Progressivo_Reclamo__c = 'TEST1';
        c6.Categoria_Riferimento__c = categPostVendita.Id;
        c6.Tipo_Reclamo__c = '5411';
        c6.Scadenza_Reclamo__c = Date.valueOf('2019-10-16');
        c6.Data_Ricezione__c = date.valueOf('2019-10-16');
        c6.Branch__c = a.Id;
        c6.F_T_Sent_Count__c = 2;
        c6.F_T_Received_Count__c = 2;
        insert c6;

        Case c7 = new Case();
        c7.NumeroPratica__c = '1234';
        c7.AccountId = a.Id;
        c7.Status = 'Sospeso';
        c7.Stage_Inadempimento__c = '4171';
        c7.is_frode__c = true;
        c7.Referenced_Company__c = 'Compass';
        c7.Numero_Reclamo__c = 'TEST-TEST';
        c7.Numero_Progressivo_Reclamo__c = 'TEST1';
        c7.Categoria_Riferimento__c = categPostVendita.Id;
        c7.Tipo_Reclamo__c = '5411';
        c7.Scadenza_Reclamo__c = Date.valueOf('2019-10-16');
        c7.Data_Ricezione__c = date.valueOf('2019-10-16');
        c7.Branch__c = a.Id;
        c7.F_T_Sent_Count__c = 1;
        c7.F_T_Received_Count__c = 1;
        insert c7;

        Case c8 = new Case();
        c8.NumeroPratica__c = '1234';
        c8.AccountId = a.Id;
        c8.Status = 'Sospeso';
        c8.Stage_Inadempimento__c = '4166';
        c8.is_frode__c = true;
        c8.Referenced_Company__c = 'Compass';
        c8.Numero_Reclamo__c = 'TEST-TEST';
        c8.Numero_Progressivo_Reclamo__c = 'TEST1';
        c8.Categoria_Riferimento__c = categPostVendita.Id;
        c8.Tipo_Reclamo__c = '5411';
        c8.Scadenza_Reclamo__c = Date.valueOf('2019-10-16');
        c8.Data_Ricezione__c = date.valueOf('2019-10-16');
        c8.Branch__c = a.Id;
        c8.F_T_Sent_Count__c = 2;
        insert c8;

        Case c9 = new Case();
        c9.NumeroPratica__c = '1234';
        c9.AccountId = a.Id;
        c9.Status = 'Sospeso';
        c9.Stage_Inadempimento__c = '6000';
        c9.is_frode__c = true;
        c9.Referenced_Company__c = 'Compass';
        c9.Numero_Reclamo__c = 'TEST-TEST';
        c9.Numero_Progressivo_Reclamo__c = 'TEST1';
        c9.Categoria_Riferimento__c = categPostVendita.Id;
        c9.Tipo_Reclamo__c = '5411';
        c9.Scadenza_Reclamo__c = Date.valueOf('2019-10-16');
        c9.Data_Ricezione__c = date.valueOf('2019-10-16');
        c9.Branch__c = a.Id;
        c9.F_T_Sent_Count__c = 2;
        c9.F_T_Received_Count__c = 2;
        insert c9;

        Case c10 = new Case();
        c10.NumeroPratica__c = '1234';
        c10.AccountId = a.Id;
        c10.Status = 'Sospeso';
        c10.Stage_Inadempimento__c = '4170';
        c10.is_frode__c = true;
        c10.Referenced_Company__c = 'Compass';
        c10.Numero_Reclamo__c = 'TEST-TEST';
        c10.Numero_Progressivo_Reclamo__c = 'TEST1';
        c10.Categoria_Riferimento__c = categPostVendita.Id;
        c10.Tipo_Reclamo__c = '5411';
        c10.Scadenza_Reclamo__c = Date.valueOf('2019-10-16');
        c10.Data_Ricezione__c = date.valueOf('2019-10-16');
        c10.Branch__c = a.Id;
        c10.F_T_Sent_Count__c = 2;
        c10.F_T_Received_Count__c = 2;
        insert c10;

        XCS_CompassParameters__c xcsP = new XCS_CompassParameters__c();
        xcsP.value__c = 'test@test.com';
        xcsP.Name = 'reclami.inadempimento.oscuraPresenzaTO';
        insert xcsP;

        XCS_CompassParameters__c xcsP1 = new XCS_CompassParameters__c();
        xcsP1.value__c = 'test@test.com';
        xcsP1.Name = 'reclami.inadempimento.sospesoTO';
        insert xcsP1;

        XCS_CompassParameters__c xcsP2 = new XCS_CompassParameters__c();
        xcsP2.value__c = 'boris90@live.it';
        xcsP2.Name = 'reclami.inadempimento.oscuraPresenzaCC';
        insert xcsP2;

        XCS_CompassParameters__c xcsP3 = new XCS_CompassParameters__c();
        xcsP3.value__c = 'https://dev3-compass--r1dev.cs84.force.com/ForwardAndTrack';
        xcsP3.Name = 'forwardandtrack.baseurl';
        insert xcsP3;

        XCS_CompassParameters__c xcsP4 = new XCS_CompassParameters__c();
        xcsP4.value__c = 'test@test.com';
        xcsP4.Name = 'reclami.inadempimento.sospesoCC';
        insert xcsP4;

        XCS_Disposition__c xcsD = new XCS_Disposition__c();
        xcsD.External_Id__c = 'DP2208';
        insert xcsD;


        String sId = Id.valueOf(c.Id);
        String sId2 = Id.valueOf(c2.Id);
        String sId3 = Id.valueOf(c3.Id);
        String sId4 = Id.valueOf(c4.Id);
        String sId5 = Id.valueOf(c5.Id);
        String sId6 = Id.valueOf(c6.Id);
        String sId7 = Id.valueOf(c7.Id);
        String sId8 = Id.valueOf(c8.Id);
        String sId9 = Id.valueOf(c9.Id);
        String sId10 = Id.valueOf(c10.Id);
        String aId = Id.valueOf(a.Id);
        String sCat = Id.valueOf(categPostVendita.Id);

        Test.startTest();
            CRMReclamiGesInadContainerCtrl.getInitValues();
            CRMReclamiGesInadContainerCtrl.getCurrentValue(sid);
            CRMReclamiGesInadContainerCtrl.getCorrispondenzaMessaggioEmail('test@test.com', 'TEST');
            CRMReclamiGesInadContainerCtrl.sendEmailForwardAndTrackInadempimento(c);
            CRMReclamiGesInadContainerCtrl.sendEmailForwardAndTrackInadempimentoNonGrave(c);
            CRMReclamiGesInadContainerCtrl.sendEmailForwardAndTrackInadempimentoWaiting(c);
            CRMReclamiGesInadContainerCtrl.salvaReclamoInadempimentoApex(sid,'',1,1,'');
            CRMReclamiGesInadContainerCtrl.salvaReclamoInadempimentoApex(sid7,'',1,1,'');
            CRMReclamiGesInadContainerCtrl.salvaReclamoInadempimentoApex(sid8,'',2,2,'');
            CRMReclamiGesInadContainerCtrl.salvaReclamoInadempimentoApex(sid2,'',1,1,'DP2208');
            CRMReclamiGesInadContainerCtrl.salvaReclamoInadempimentoApex(sid3,'',1,1,'DP2208');
            CRMReclamiGesInadContainerCtrl.salvaReclamoInadempimentoApex(sid4,'',1,2,'DP2208');  
            CRMReclamiGesInadContainerCtrl.salvaReclamoInadempimentoApex(sid5,'',1,2,'DP2208');
            CRMReclamiGesInadContainerCtrl.salvaReclamoInadempimentoApex(sid6,'',1,2,'DP2208');
            CRMReclamiGesInadContainerCtrl.salvaReclamoInadempimentoApex(sid9,'',1,1,'DP2208');
            CRMReclamiGesInadContainerCtrl.salvaReclamoInadempimentoApex(sid10,'',1,1,'DP2208');
            
        Test.stopTest();
       
    }



    private static testmethod void CRMReclamiGestioneCorrispondenzaCtrlTest() {
        
        Account a = new Account();
        a.firstname='LEO';
        a.lastname = 'GULLOTTA';
        a.Codice_Fiscale__c  = 'RTUMRN89C02R800Q';
        a.Codice_Fiscale__pc = 'RTUMRN89C02R800Q';
        a.OCS_External_Id__c = '123456';
        insert a;

        XCS_categoria__c categEmail = new XCS_categoria__c(external_id__c = CRM_GestioneEmail.GESTIONE_EMAIL_CATEGORY);
        insert categEmail;

        Case c = new Case();
        c.NumeroPratica__c = '1234';
        c.AccountId = a.Id;
        c.Status = 'Sospeso';
        c.Stage_Inadempimento__c = '4165';
        c.is_frode__c = true;
        c.Referenced_Company__c = 'Compass';
        c.Numero_Reclamo__c = 'TEST-TEST';
        c.Numero_Progressivo_Reclamo__c = 'TEST1';
        insert c;

        Attachment att = new Attachment();
        att.Body = Blob.valueOf('TEST');
        att.Name = 'TEST';
        att.ParentId = a.id;
        att.OwnerId = UserInfo.getUserId();
        insert att;

        Attachment att1 = new Attachment();
        att1.Body = Blob.valueOf('TEST');
        att1.Name = 'TEST';
        att1.ParentId = a.Id;
        att1.OwnerId = UserInfo.getUserId();
        insert att1;


        List<Attachment> lAtt = [SELECT Id, Body, ContentType, Name, ownerId, Description FROM Attachment]; 

        List<Id> listaDocumentId = new List<Id>();
        listaDocumentId = XCSReclamiUtils.createFile(lAtt, c.Id);

  
        Test.startTest();

            List<ContentDocument> cd = [SELECT Id,FileType FROM ContentDocument];

            System.debug('size '+cd.size());
            System.debug('FileType '+cd[0].FileType);
            System.debug('FileType '+cd[1].FileType);
            



//            CRMReclamiGestioneCorrispondenzaCtrl.getNote(c.Id);
//            CRMReclamiGestioneCorrispondenzaCtrl.getFileNote(c.Id);
//            CRMReclamiGestioneCorrispondenzaCtrl.insertNote(c.Id,'TESTO');
        Test.stopTest();
       
    }

}