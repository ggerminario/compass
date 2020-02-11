/**
* @File Name          : PV3267VariazioneIndirizziTest.cls
* @Description        :
* @Author             : Raffaele Prudenzano
* @Group              :
* @Last Modified By   : Raffaele Prudenzano
* @Last Modified On   : 11/11/2019, 10:01:02
* @Modification Log   :
* Ver       Date            Author                  Modification
* 1.0    11/11/2019   Raffaele Prudenzano     Initial Version
**/

@isTest(SeeAllData=true)
public with sharing class PV3267VariazioneIndirizziTest {
    
    
    @isTest public static void parseIndirizziToReqVariazioniTest1() {
        String codCliente = '123465';
        
        List<PV3267VariazioneIndirizzi.IndirizzoDTO> indirizzi = new List<PV3267VariazioneIndirizzi.IndirizzoDTO>();
        
        PV3267VariazioneIndirizzi.IndirizzoDTO indD = new PV3267VariazioneIndirizzi.IndirizzoDTO();
        indD.tipoIndirizzo = 'Domicilio';
        indD.indirizzo = 'Via tal dei tali 55';
        indD.azione = 'Cancellato';
        
        PV3267VariazioneIndirizzi.IndirizzoDTO indR = new PV3267VariazioneIndirizzi.IndirizzoDTO();
        indR.tipoIndirizzo = 'Residenza';
        indR.indirizzo = 'Via tal dei tali 55';
        indR.azione = 'Inserito';
        
        PV3267VariazioneIndirizzi.IndirizzoDTO indP = new PV3267VariazioneIndirizzi.IndirizzoDTO();
        indP.tipoIndirizzo = 'Precedente';
        indP.indirizzo = 'Via tal dei tali 55';
        indP.azione = 'Modificato';
        
        indirizzi.add(indD);
        indirizzi.add(indR);
        indirizzi.add(indP);
        
        PV3267VariazioneIndirizzi.parseIndirizziToReqVariazioni(indirizzi, '123456');
        
    }
    
    @isTest public static void parseIndirizziToReqVariazioniTest2() {
        String codCliente = '123465';
        
        List<PV3267VariazioneIndirizzi.IndirizzoDTO> indirizzi = new List<PV3267VariazioneIndirizzi.IndirizzoDTO>();
        
        PV3267VariazioneIndirizzi.IndirizzoDTO indD = new PV3267VariazioneIndirizzi.IndirizzoDTO();
        indD.tipoIndirizzo = 'Domicilio';
        indD.indirizzo = 'Via tal dei tali 55 ABCDEFGHILMNOPQRSTUVZ';
        indD.azione = 'Modificato';
        
        PV3267VariazioneIndirizzi.IndirizzoDTO indR = new PV3267VariazioneIndirizzi.IndirizzoDTO();
        indR.tipoIndirizzo = 'Residenza';
        indR.indirizzo = 'Via tal dei tali 55 ABCDEFGHILMNOPQRSTUVZ';
        indR.azione = 'Inserito';
        
        PV3267VariazioneIndirizzi.IndirizzoDTO indP = new PV3267VariazioneIndirizzi.IndirizzoDTO();
        indP.tipoIndirizzo = 'Precedente';
        indP.indirizzo = 'Via tal dei tali 55 ABCDEFGHILMNOPQRSTUVZ';
        indP.azione = 'Modificato';
        
        indirizzi.add(indD);
        indirizzi.add(indR);
        indirizzi.add(indP);
        
        PV3267VariazioneIndirizzi.parseIndirizziToReqVariazioni(indirizzi, '123456');
        
    }
    
    @isTest public static void doProcessaResponseTest() {
        String response = '{"normalizzaIndirizzoResponse":{"elencoIndirizzi":[{"cap":"20129","civico":"5","indirizzo":"INDIPENDENZA","localita":"MILANO","nazione":"ITALIA","provincia":"MI","tipoIndirizzo":"CORSO"}]},"resultCode":0,"resultMessage":"Ok","status":"OK","statusCode":200}';
        PV3267VariazioneIndirizzi.doProcessaResponse(response);
        
    }
    
    @isTest public static void doNormalizzaIndirizzoTest() {
        String response ='{"resultCode":0,"resultMessage":"Ok","normalizzaIndirizzoResponse":{"esito":"1","codErrore":"0000","desErrore":"","elencoIndirizzi":[{"tipoIndirizzo":"VIALE","indirizzo":"CERTOSA","civico":"14","cap":"20155","localita":"MILANO","provincia":"MI","nazione":"ITALIA","capRischio":null}]}}';
        
        Test.startTest();
        
        MyUtilityMockResponse UMR = new MyUtilityMockResponse();
        UMR.apiname = 'ocs.normalizzaIndirizzo';
        UMR.response=response;
        Test.setMock(HttpCalloutMock.class, UMR);
        
        PV3267VariazioneIndirizzi.doNormalizzaIndirizzo( 'Viale Certosa 14',  '20155',  'MILANO',  'MI');
        
        Test.stopTest();
    }
    
    
    @isTest public static void confermaTest() {
        String datiFormJson = '{"sobjectype":"PVForm","attachmentsIDs":null,"attachmentList":[],"parentId":null,"annulla":"N","userData":{"accountOffice":{"Id":"0010Q00000SU0EaQAL","RecordTypeId":"0120Q000000D0atQAC"},"user":{"Alias":"cfusc","Name":"CarmineFusco","LastName":"Fusco","FirstName":"Carmine","UserRoleId":"00E0Q000000EVf5UAG","Branch_Or_Office__c":"CCInterno","Id":"0055E0000056b5RQAQ","UserRole":{"Name":"NumeroBluManager","DeveloperName":"Numero_Blu_Manager","Id":"00E0Q000000EVf5UAG"}}},"categoriaPV":{"Id":"a0O0Q000001eII5UAM","External_Id__c":"3267","Visibility__c":"|CCInterno|NumeroBlu|NET|Visiant|","Flag_Ricerca_Cliente__c":true,"Flag_Urgente__c":true,"Flag_Mostra_Pratiche__c":false,"Name":"Variazioneindirizzi","XCS_Template__c":"a0C0Q0000027wRAUAY","XCS_Template__r":{"Body__c":"{0}-{1}<br>Stato:{2}<br>Urgente:{3}<br>Descrizionemotivazione:{4}<br>Codicecliente:{5}<br>Nomecliente:{6}<br>{7}<br>{8}<br>Note:{9}","Id":"a0C0Q0000027wRAUAY"}},"pratica":null,"cliente":{"cap":"20129","codCliente":"15080269","codFiscale":"RCCMDL71T24F784X","cognome":"RAOACICRO","dataDepennamento":"20141111","dataNascita":"19711224","dataNascitaDate":"1971-12-24","dataNascitaItaliana":"24/12/1971","dataRilascio":"20110609","dataRilascioDate":"2011-06-09","dataScadenza":"20210608","dataScadenzaDate":"2021-06-08","dataScadenzaSlashed":"08/06/2021","denominazione":"MAMADOUALASSANERAOACICRO","denominazioneAzienda":"RAOACICROMAMADOUALASSANE","email":"RAOACICRO.MAMADOUALASSANE§provider.com","formaGiuridica":"","indirizzo":"CORSOINDIPENDENZA5","localita":"MILANO","luogoNascita":"MOTTOLA","luogoRilascio":"MILANO","ndg":"0","nome":"MAMADOUALASSANE","numDocumento":"464997AR9","paeseEstero":"086","piva":"","pratiche":[{"abi":"3069","cab":"9471","canale":"","codAttributoPratica":"","codCliente":"15080269","codRecuperatore":"","codStatoPratica":"50","convenzionato":"12","dataCaricamento":"11/11/2014","dataEstinzione":"","dealerCode":"12","desAttributoPratica":"","desRecuperatore":"","desStatoPratica":"Attivata","filiale":"16","flagRecupero":"","iban":"IT59B0306909471100000000087","numConto":"100000000087","numPratica":"52144534119","pan":"5262114454599532","prodotto":"28","societa":"","statoPratica":"50","tipoPagamento":"RI","tipoPratica":"CA"}],"praticheFuturo":[],"provincia":"MI","provNascita":"TA","provRilascio":"MI","sesso":"M","telCellulare":"3338644919","telefonoCasa":"","tipoAnagrafica":"P","tipoDocumento":"CAR","tipoRapporto":"","ufficioRilascio":"COM"},"variazioneIndirizzi":[{"cap":"","capRischio":"N","indirizzo":"","localita":"","provincia":"","tipoIndirizzo":"Domicilio"},{"cap":"20129","indirizzo":"CORSOINDIPENDENZA5","localita":"MILANO","nazione":"ITALIA","provincia":"MI","azione":"Modificato","tipoIndirizzo":"Residenza"},{"cap":"20100","capRischio":"N","indirizzo":"VIAINDIPENDENZA5","localita":"MILANO","provincia":"MI","tipoIndirizzo":"Precedente"}]}';
        PV3267VariazioneIndirizzi.PV3267VariazioneIndirizziForm datiForm = (PV3267VariazioneIndirizzi.PV3267VariazioneIndirizziForm) JSON.deserialize(datiFormJson, PV3267VariazioneIndirizzi.PV3267VariazioneIndirizziForm.class);
        
        String response = '{"resultCode":0,"resultMessage":"Ok","variazioneIndirizziResponse":{"dataElaborazione":"20190409","oraElaborazione":"11123182","utenteElaborazione":"WB","esitoElaborazione":"OK"}}';
        
        Test.startTest();
        
        MyUtilityMockResponse UMR = new MyUtilityMockResponse();
        UMR.apiname = 'ocs.variazioneIndirizzi';
        UMR.response=response;
        Test.setMock(HttpCalloutMock.class, UMR);
        
        PV3267VariazioneIndirizzi.conferma(datiForm);
        
        Test.stopTest();
    }
    
    @isTest public static void doRecuperaIndirizziClienteTest() {
        
        
        String response = '{"resultCode":0,"resultMessage":"Ok","recuperaIndirizziClienteResponse":{"elencoIndirizzi":[{"tipoIndirizzo":"R","indirizzo":"VIAVERDI","civico":"52","cap":"08010","localita":"MONTRESTA","provincia":"OR","nazione":"Italia", "capRischio":"N"}]}}';
        
        Test.startTest();
        
        MyUtilityMockResponse UMR = new MyUtilityMockResponse();
        UMR.apiname = 'ocs.recuperaIndirizziCliente';
        UMR.response=response;
        Test.setMock(HttpCalloutMock.class, UMR);
        
        List<OCSRecuperaIndirizziClienteResponse.IndirizzoDTO> indirizzi = PV3267VariazioneIndirizzi.doRecuperaIndirizziCliente('123456789');
        OCSRecuperaIndirizziClienteResponse.IndirizzoDTO thisIndirizzo = indirizzi[0];
        
        System.assertEquals('R',thisIndirizzo.tipoIndirizzo);
        System.assertEquals('VIAVERDI',thisIndirizzo.indirizzo);
        System.assertEquals('52',thisIndirizzo.civico);
        System.assertEquals('08010',thisIndirizzo.cap);
        System.assertEquals('MONTRESTA',thisIndirizzo.localita);
        System.assertEquals('OR',thisIndirizzo.provincia);
        System.assertEquals('Italia', thisIndirizzo.nazione);
		System.assertEquals('N', thisIndirizzo.capRischio);
        
        Test.stopTest();
        
    }
    
    @isTest public static void doGestisciAlertSuPraticheTestOK(){
        String praticaJson = '[{"abi": "3069","cab": "9471","canale": "   ","codAttributoPratica": "","codCliente": "15080269","codRecuperatore": "","codStatoPratica": "50","convenzionato":"12","dataCaricamento": "11/11/2014","dataEstinzione": "","dealerCode": "12","desAttributoPratica": "","desRecuperatore": "","desStatoPratica": "Attivata","filiale": "16","flagRecupero": "","iban": "IT59B0306909471100000000087","numConto": "100000000087","numPratica": "52144534119","pan": "5262114454599532","prodotto": "28","societa": "","statoPratica": "50","tipoPagamento": "RI","tipoPratica": "CA"}]';
        String cartaDatiFinanziariERecuperaSaldoClienteResponse = '{"resultCode":0,"resultMessage":"Ok","datiCartaDatiFinanziariResponse":{"numeroPratica":"8180824247","filiale":"212","emettitore":"8","pagamentoMinimo":"0","pagamentoMinimoPerc":"0.00","commissioneEntrata":"0","modCalcoloRata":"T","intestazione1":"GAMBADOROANDREA","intestazione2":"","dataValidita":"20130426","dataScadenza":"201905","checkIntermediario":"12","pagamento":"RI","bancaCliAbi":"3058","bancaCliCab":"1604","contoCorrente":"100571605864","iban":"IT04P0305801604100571605864","comRinnovo":"0","comRinnovo1":"0","comRinnovoDurata1":"0","comRinnovo2":"0","comRinnovoDurata2":"0","comRinnovo3":"0","comRinnovoDurata3":"0","stato":"60","blocco":"IV","tassoTan":"0.000","tassoTaeg":"5.160","pan":"4134280846406477","fidoTotale":"350000","dispTotale":"350000","fidoRiserva1":"200000","dispRiserva1":"200000","fidoRiserva2":"150000","dispRiserva2":"150000","fidoRiserva3":"0","dispRiserva3":"0","flagAttivazioneCarta":"N","codProdotto":"NI","desProdotto":"CARTADIPENDENTIFIDO3500","flagAlertSms":"N","riservaPrincipaleFido":"200000","riservaPrincipaleFidoSegno":"","riservaPrincipaleSaldo":"0","riservaPrincipaleSaldoSegno":"","riservaPrincipaleDisp":"200000","riservaPrincipaleDispSegno":"","riservaPrincipaleSconfino":"0","riservaPrincipaleSconfinoSegno":"","riservaPrincipaleOverlimit":"5000","riservaPrincipaleOverlimitSegno":"","riservaPrincipaleDispTeorMax":"355000","riservaPrincipaleDispTeorMaxSegno":"","riservaSalvadanaioFido":"150000","riservaSalvadanaioFidoSegno":"","riservaSalvadanaioSaldo":"0","riservaSalvadanaioSaldoSegno":"","riservaSalvadanaioDisp":"150000","riservaSalvadanaioDispSegno":"","riservaSalvadanaioSconfino":"0","riservaSalvadanaioSconfinoSegno":"","riservaSalvadanaioOverlimit":"0","riservaSalvadanaioOverlimitSegno":"","riservaSalvadanaioDispTeorMax":"355000","riservaSalvadanaioDispTeorMaxSegno":"","riservaInternetFido":"0","riservaInternetFidoSegno":"","riservaInternetSaldo":"0","riservaInternetSaldoSegno":"","riservaInternetDisp":"0","riservaInternetDispSegno":"","riservaInternetSconfino":"0","riservaInternetSconfinoSegno":"","riservaInternetOverlimit":"0","riservaInternetOverlimitSegno":"","riservaInternetDispTeorMax":"0","riservaInternetDispTeorMaxSegno":"","riservaMulticontoFido":"0","riservaMulticontoFidoSegno":"","riservaMulticontoSaldo":"0","riservaMulticontoSaldoSegno":"","riservaMulticontoDisp":"0","riservaMulticontoDispSegno":"","riservaMulticontoSconfino":"0","riservaMulticontoSconfinoSegno":"","riservaMulticontoOverlimit":"0","riservaMulticontoOverlimitSegno":"","riservaMulticontoDispTeorMax":"0","riservaMulticontoDispTeorMaxSegno":"","as400Status":"OK","as400Errore":""},"recuperaSaldoClienteResponse":{"elencoPratiche":[{"numPratica":"6100025944","tipoPratica":"CA","saldo":"0","tipoProdotto":"","dataEsame":"20001106","stato":"70","attributo":"CV","tipoRapporto":"CL","prodotto":"DF","scaduto":"0","finanziato":"500000","dataPrimoUtilizzo":"","dataPrimaAttivazione":"20001127","dataCompetenzaPrimoEC":""},{"numPratica":"8109435018","tipoPratica":"CA","saldo":"0","tipoProdotto":"","dataEsame":"20120925","stato":"70","attributo":"XZ","tipoRapporto":"CL","prodotto":"AW","scaduto":"0","finanziato":"0","dataPrimoUtilizzo":"","dataPrimaAttivazione":"20121012","dataCompetenzaPrimoEC":""},{"numPratica":"8185777259","tipoPratica":"CA","saldo":"161365","tipoProdotto":"","dataEsame":"20110223","stato":"50","attributo":"","tipoRapporto":"CL","prodotto":"DI","scaduto":"0","finanziato":"350000","dataPrimoUtilizzo":"20110331","dataPrimaAttivazione":"20110318","dataCompetenzaPrimoEC":"20110430"},{"numPratica":"24100015679","tipoPratica":"CA","saldo":"0","tipoProdotto":"","dataEsame":"20021125","stato":"70","attributo":"LS","tipoRapporto":"CL","prodotto":"01","scaduto":"0","finanziato":"200000","dataPrimoUtilizzo":"","dataPrimaAttivazione":"20021219","dataCompetenzaPrimoEC":""},{"numPratica":"24100045692","tipoPratica":"CA","saldo":"0","tipoProdotto":"","dataEsame":"20021125","stato":"70","attributo":"CV","tipoRapporto":"CL","prodotto":"01","scaduto":"0","finanziato":"200000","dataPrimoUtilizzo":"","dataPrimaAttivazione":"20021219","dataCompetenzaPrimoEC":""}]}}';
        doGestisciAlertSuPraticheTest(praticaJson,cartaDatiFinanziariERecuperaSaldoClienteResponse);
    }
    
    @isTest public static void doGestisciAlertSuPraticheTestCaso1(){
        String praticaJson = '[{"abi": "3069","cab": "9471","canale": "   ","codAttributoPratica": "","codCliente": "15080269","codRecuperatore": "","codStatoPratica": "50","convenzionato":"12","dataCaricamento": "11/11/2014","dataEstinzione": "","dealerCode": "12","desAttributoPratica": "","desRecuperatore": "","desStatoPratica": "Attivata","filiale": "16","flagRecupero": "","iban": "IT59B0306909471100000000087","numConto": "100000000087","numPratica": "52144534119","pan": "5262114454599532","prodotto": "28","societa": "","statoPratica": "05","tipoPagamento": "RI","tipoPratica": "CO"}]';
        String cartaDatiFinanziariERecuperaSaldoClienteResponse = '{"resultCode":0,"resultMessage":"Ok","datiCartaDatiFinanziariResponse":{"numeroPratica":"8180824247","filiale":"212","emettitore":"8","pagamentoMinimo":"0","pagamentoMinimoPerc":"0.00","commissioneEntrata":"0","modCalcoloRata":"T","intestazione1":"GAMBADOROANDREA","intestazione2":"","dataValidita":"20130426","dataScadenza":"201905","checkIntermediario":"12","pagamento":"RI","bancaCliAbi":"3058","bancaCliCab":"1604","contoCorrente":"100571605864","iban":"IT04P0305801604100571605864","comRinnovo":"0","comRinnovo1":"0","comRinnovoDurata1":"0","comRinnovo2":"0","comRinnovoDurata2":"0","comRinnovo3":"0","comRinnovoDurata3":"0","stato":"60","blocco":"IV","tassoTan":"0.000","tassoTaeg":"5.160","pan":"4134280846406477","fidoTotale":"350000","dispTotale":"350000","fidoRiserva1":"200000","dispRiserva1":"200000","fidoRiserva2":"150000","dispRiserva2":"150000","fidoRiserva3":"0","dispRiserva3":"0","flagAttivazioneCarta":"N","codProdotto":"NI","desProdotto":"CARTADIPENDENTIFIDO3500","flagAlertSms":"N","riservaPrincipaleFido":"200000","riservaPrincipaleFidoSegno":"","riservaPrincipaleSaldo":"0","riservaPrincipaleSaldoSegno":"","riservaPrincipaleDisp":"200000","riservaPrincipaleDispSegno":"","riservaPrincipaleSconfino":"0","riservaPrincipaleSconfinoSegno":"","riservaPrincipaleOverlimit":"5000","riservaPrincipaleOverlimitSegno":"","riservaPrincipaleDispTeorMax":"355000","riservaPrincipaleDispTeorMaxSegno":"","riservaSalvadanaioFido":"150000","riservaSalvadanaioFidoSegno":"","riservaSalvadanaioSaldo":"0","riservaSalvadanaioSaldoSegno":"","riservaSalvadanaioDisp":"150000","riservaSalvadanaioDispSegno":"","riservaSalvadanaioSconfino":"0","riservaSalvadanaioSconfinoSegno":"","riservaSalvadanaioOverlimit":"0","riservaSalvadanaioOverlimitSegno":"","riservaSalvadanaioDispTeorMax":"355000","riservaSalvadanaioDispTeorMaxSegno":"","riservaInternetFido":"0","riservaInternetFidoSegno":"","riservaInternetSaldo":"0","riservaInternetSaldoSegno":"","riservaInternetDisp":"0","riservaInternetDispSegno":"","riservaInternetSconfino":"0","riservaInternetSconfinoSegno":"","riservaInternetOverlimit":"0","riservaInternetOverlimitSegno":"","riservaInternetDispTeorMax":"0","riservaInternetDispTeorMaxSegno":"","riservaMulticontoFido":"0","riservaMulticontoFidoSegno":"","riservaMulticontoSaldo":"0","riservaMulticontoSaldoSegno":"","riservaMulticontoDisp":"0","riservaMulticontoDispSegno":"","riservaMulticontoSconfino":"0","riservaMulticontoSconfinoSegno":"","riservaMulticontoOverlimit":"0","riservaMulticontoOverlimitSegno":"","riservaMulticontoDispTeorMax":"0","riservaMulticontoDispTeorMaxSegno":"","as400Status":"OK","as400Errore":""},"recuperaSaldoClienteResponse":{"elencoPratiche":[{"numPratica":"6100025944","tipoPratica":"CA","saldo":"0","tipoProdotto":"","dataEsame":"20001106","stato":"70","attributo":"CV","tipoRapporto":"CL","prodotto":"DF","scaduto":"0","finanziato":"500000","dataPrimoUtilizzo":"","dataPrimaAttivazione":"20001127","dataCompetenzaPrimoEC":""},{"numPratica":"8109435018","tipoPratica":"CA","saldo":"0","tipoProdotto":"","dataEsame":"20120925","stato":"70","attributo":"XZ","tipoRapporto":"CL","prodotto":"AW","scaduto":"0","finanziato":"0","dataPrimoUtilizzo":"","dataPrimaAttivazione":"20121012","dataCompetenzaPrimoEC":""},{"numPratica":"8185777259","tipoPratica":"CA","saldo":"161365","tipoProdotto":"","dataEsame":"20110223","stato":"50","attributo":"","tipoRapporto":"CL","prodotto":"DI","scaduto":"0","finanziato":"350000","dataPrimoUtilizzo":"20110331","dataPrimaAttivazione":"20110318","dataCompetenzaPrimoEC":"20110430"},{"numPratica":"24100015679","tipoPratica":"CA","saldo":"0","tipoProdotto":"","dataEsame":"20021125","stato":"70","attributo":"LS","tipoRapporto":"CL","prodotto":"01","scaduto":"0","finanziato":"200000","dataPrimoUtilizzo":"","dataPrimaAttivazione":"20021219","dataCompetenzaPrimoEC":""},{"numPratica":"24100045692","tipoPratica":"CA","saldo":"0","tipoProdotto":"","dataEsame":"20021125","stato":"70","attributo":"CV","tipoRapporto":"CL","prodotto":"01","scaduto":"0","finanziato":"200000","dataPrimoUtilizzo":"","dataPrimaAttivazione":"20021219","dataCompetenzaPrimoEC":""}]}}';
        doGestisciAlertSuPraticheTest(praticaJson,cartaDatiFinanziariERecuperaSaldoClienteResponse);
    }
    
    @isTest public static void doGestisciAlertSuPraticheTestCaso2A(){
        String praticaJson = '[{"abi": "3069","cab": "9471","canale": "   ","codAttributoPratica": "","codCliente": "15080269","codRecuperatore": "","codStatoPratica": "50","convenzionato":"12","dataCaricamento": "11/11/2014","dataEstinzione": "","dealerCode": "12","desAttributoPratica": "","desRecuperatore": "","desStatoPratica": "Attivata","filiale": "16","flagRecupero": "S","iban": "IT59B0306909471100000000087","numConto": "100000000087","numPratica": "52144534119","pan": "5262114454599532","prodotto": "28","societa": "","statoPratica": "50","tipoPagamento": "RI","tipoPratica": "CA"}]';
        String cartaDatiFinanziariERecuperaSaldoClienteResponse = '{"resultCode":0,"resultMessage":"Ok","datiCartaDatiFinanziariResponse":{"numeroPratica":"8180824247","filiale":"212","emettitore":"8","pagamentoMinimo":"0","pagamentoMinimoPerc":"0.00","commissioneEntrata":"0","modCalcoloRata":"T","intestazione1":"GAMBADOROANDREA","intestazione2":"","dataValidita":"20130426","dataScadenza":"201905","checkIntermediario":"12","pagamento":"RI","bancaCliAbi":"3058","bancaCliCab":"1604","contoCorrente":"100571605864","iban":"IT04P0305801604100571605864","comRinnovo":"0","comRinnovo1":"0","comRinnovoDurata1":"0","comRinnovo2":"0","comRinnovoDurata2":"0","comRinnovo3":"0","comRinnovoDurata3":"0","stato":"60","blocco":"IV","tassoTan":"0.000","tassoTaeg":"5.160","pan":"4134280846406477","fidoTotale":"350000","dispTotale":"350000","fidoRiserva1":"200000","dispRiserva1":"200000","fidoRiserva2":"150000","dispRiserva2":"150000","fidoRiserva3":"0","dispRiserva3":"0","flagAttivazioneCarta":"N","codProdotto":"NI","desProdotto":"CARTADIPENDENTIFIDO3500","flagAlertSms":"N","riservaPrincipaleFido":"200000","riservaPrincipaleFidoSegno":"","riservaPrincipaleSaldo":"0","riservaPrincipaleSaldoSegno":"","riservaPrincipaleDisp":"200000","riservaPrincipaleDispSegno":"","riservaPrincipaleSconfino":"0","riservaPrincipaleSconfinoSegno":"","riservaPrincipaleOverlimit":"5000","riservaPrincipaleOverlimitSegno":"","riservaPrincipaleDispTeorMax":"355000","riservaPrincipaleDispTeorMaxSegno":"","riservaSalvadanaioFido":"150000","riservaSalvadanaioFidoSegno":"","riservaSalvadanaioSaldo":"0","riservaSalvadanaioSaldoSegno":"","riservaSalvadanaioDisp":"150000","riservaSalvadanaioDispSegno":"","riservaSalvadanaioSconfino":"0","riservaSalvadanaioSconfinoSegno":"","riservaSalvadanaioOverlimit":"0","riservaSalvadanaioOverlimitSegno":"","riservaSalvadanaioDispTeorMax":"355000","riservaSalvadanaioDispTeorMaxSegno":"","riservaInternetFido":"0","riservaInternetFidoSegno":"","riservaInternetSaldo":"0","riservaInternetSaldoSegno":"","riservaInternetDisp":"0","riservaInternetDispSegno":"","riservaInternetSconfino":"0","riservaInternetSconfinoSegno":"","riservaInternetOverlimit":"0","riservaInternetOverlimitSegno":"","riservaInternetDispTeorMax":"0","riservaInternetDispTeorMaxSegno":"","riservaMulticontoFido":"0","riservaMulticontoFidoSegno":"","riservaMulticontoSaldo":"0","riservaMulticontoSaldoSegno":"","riservaMulticontoDisp":"0","riservaMulticontoDispSegno":"","riservaMulticontoSconfino":"0","riservaMulticontoSconfinoSegno":"","riservaMulticontoOverlimit":"0","riservaMulticontoOverlimitSegno":"","riservaMulticontoDispTeorMax":"0","riservaMulticontoDispTeorMaxSegno":"","as400Status":"OK","as400Errore":""},"recuperaSaldoClienteResponse":{"elencoPratiche":[{"numPratica":"6100025944","tipoPratica":"CA","saldo":"0","tipoProdotto":"","dataEsame":"20001106","stato":"70","attributo":"CV","tipoRapporto":"CL","prodotto":"DF","scaduto":"0","finanziato":"500000","dataPrimoUtilizzo":"","dataPrimaAttivazione":"20001127","dataCompetenzaPrimoEC":""},{"numPratica":"8109435018","tipoPratica":"CA","saldo":"0","tipoProdotto":"","dataEsame":"20120925","stato":"70","attributo":"XZ","tipoRapporto":"CL","prodotto":"AW","scaduto":"0","finanziato":"0","dataPrimoUtilizzo":"","dataPrimaAttivazione":"20121012","dataCompetenzaPrimoEC":""},{"numPratica":"8185777259","tipoPratica":"CA","saldo":"161365","tipoProdotto":"","dataEsame":"20110223","stato":"50","attributo":"","tipoRapporto":"CL","prodotto":"DI","scaduto":"0","finanziato":"350000","dataPrimoUtilizzo":"20110331","dataPrimaAttivazione":"20110318","dataCompetenzaPrimoEC":"20110430"},{"numPratica":"24100015679","tipoPratica":"CA","saldo":"0","tipoProdotto":"","dataEsame":"20021125","stato":"70","attributo":"LS","tipoRapporto":"CL","prodotto":"01","scaduto":"0","finanziato":"200000","dataPrimoUtilizzo":"","dataPrimaAttivazione":"20021219","dataCompetenzaPrimoEC":""},{"numPratica":"24100045692","tipoPratica":"CA","saldo":"0","tipoProdotto":"","dataEsame":"20021125","stato":"70","attributo":"CV","tipoRapporto":"CL","prodotto":"01","scaduto":"0","finanziato":"200000","dataPrimoUtilizzo":"","dataPrimaAttivazione":"20021219","dataCompetenzaPrimoEC":""}]}}';
        doGestisciAlertSuPraticheTest(praticaJson,cartaDatiFinanziariERecuperaSaldoClienteResponse);
    }
    
    @isTest public static void doGestisciAlertSuPraticheTestCaso2B(){
        String praticaJson = '[{"abi": "3069","cab": "9471","canale": "   ","codAttributoPratica": "","codCliente": "15080269","codRecuperatore": "","codStatoPratica": "50","convenzionato":"12","dataCaricamento": "11/11/2014","dataEstinzione": "","dealerCode": "12","desAttributoPratica": "","desRecuperatore": "","desStatoPratica": "Attivata","filiale": "16","flagRecupero": "","iban": "IT59B0306909471100000000087","numConto": "100000000087","numPratica": "52144534119","pan": "5262114454599532","prodotto": "28","societa": "","statoPratica": "50","tipoPagamento": "RI","tipoPratica": "CA"}]';
        String cartaDatiFinanziariERecuperaSaldoClienteResponse = '{"resultCode":0,"resultMessage":"Ok","datiCartaDatiFinanziariResponse":{"numeroPratica":"8180824247","filiale":"212","emettitore":"8","pagamentoMinimo":"0","pagamentoMinimoPerc":"0.00","commissioneEntrata":"0","modCalcoloRata":"T","intestazione1":"GAMBADOROANDREA","intestazione2":"","dataValidita":"20130426","dataScadenza":"201905","checkIntermediario":"12","pagamento":"RI","bancaCliAbi":"3058","bancaCliCab":"1604","contoCorrente":"100571605864","iban":"IT04P0305801604100571605864","comRinnovo":"0","comRinnovo1":"0","comRinnovoDurata1":"0","comRinnovo2":"0","comRinnovoDurata2":"0","comRinnovo3":"0","comRinnovoDurata3":"0","stato":"60","blocco":"IV","tassoTan":"0.000","tassoTaeg":"5.160","pan":"4134280846406477","fidoTotale":"350000","dispTotale":"350000","fidoRiserva1":"200000","dispRiserva1":"200000","fidoRiserva2":"150000","dispRiserva2":"150000","fidoRiserva3":"0","dispRiserva3":"0","flagAttivazioneCarta":"N","codProdotto":"NI","desProdotto":"CARTADIPENDENTIFIDO3500","flagAlertSms":"N","riservaPrincipaleFido":"200000","riservaPrincipaleFidoSegno":"","riservaPrincipaleSaldo":"0","riservaPrincipaleSaldoSegno":"","riservaPrincipaleDisp":"200000","riservaPrincipaleDispSegno":"","riservaPrincipaleSconfino":"0","riservaPrincipaleSconfinoSegno":"","riservaPrincipaleOverlimit":"5000","riservaPrincipaleOverlimitSegno":"","riservaPrincipaleDispTeorMax":"355000","riservaPrincipaleDispTeorMaxSegno":"","riservaSalvadanaioFido":"150000","riservaSalvadanaioFidoSegno":"","riservaSalvadanaioSaldo":"0","riservaSalvadanaioSaldoSegno":"","riservaSalvadanaioDisp":"150000","riservaSalvadanaioDispSegno":"","riservaSalvadanaioSconfino":"0","riservaSalvadanaioSconfinoSegno":"","riservaSalvadanaioOverlimit":"0","riservaSalvadanaioOverlimitSegno":"","riservaSalvadanaioDispTeorMax":"355000","riservaSalvadanaioDispTeorMaxSegno":"","riservaInternetFido":"0","riservaInternetFidoSegno":"","riservaInternetSaldo":"0","riservaInternetSaldoSegno":"","riservaInternetDisp":"0","riservaInternetDispSegno":"","riservaInternetSconfino":"0","riservaInternetSconfinoSegno":"","riservaInternetOverlimit":"0","riservaInternetOverlimitSegno":"","riservaInternetDispTeorMax":"0","riservaInternetDispTeorMaxSegno":"","riservaMulticontoFido":"0","riservaMulticontoFidoSegno":"","riservaMulticontoSaldo":"0","riservaMulticontoSaldoSegno":"","riservaMulticontoDisp":"0","riservaMulticontoDispSegno":"","riservaMulticontoSconfino":"0","riservaMulticontoSconfinoSegno":"","riservaMulticontoOverlimit":"0","riservaMulticontoOverlimitSegno":"","riservaMulticontoDispTeorMax":"0","riservaMulticontoDispTeorMaxSegno":"","as400Status":"OK","as400Errore":""},"recuperaSaldoClienteResponse":{"elencoPratiche":[{"numPratica":"6100025944","tipoPratica":"CA","saldo":"0","tipoProdotto":"","dataEsame":"20001106","stato":"70","attributo":"CV","tipoRapporto":"CL","prodotto":"DF","scaduto":"0","finanziato":"500000","dataPrimoUtilizzo":"","dataPrimaAttivazione":"20001127","dataCompetenzaPrimoEC":""},{"numPratica":"8109435018","tipoPratica":"CA","saldo":"0","tipoProdotto":"","dataEsame":"20120925","stato":"70","attributo":"XZ","tipoRapporto":"CL","prodotto":"AW","scaduto":"501","finanziato":"0","dataPrimoUtilizzo":"","dataPrimaAttivazione":"20121012","dataCompetenzaPrimoEC":""},{"numPratica":"8185777259","tipoPratica":"CA","saldo":"161365","tipoProdotto":"","dataEsame":"20110223","stato":"50","attributo":"","tipoRapporto":"CL","prodotto":"DI","scaduto":"0","finanziato":"350000","dataPrimoUtilizzo":"20110331","dataPrimaAttivazione":"20110318","dataCompetenzaPrimoEC":"20110430"},{"numPratica":"24100015679","tipoPratica":"CA","saldo":"0","tipoProdotto":"","dataEsame":"20021125","stato":"70","attributo":"LS","tipoRapporto":"CL","prodotto":"01","scaduto":"0","finanziato":"200000","dataPrimoUtilizzo":"","dataPrimaAttivazione":"20021219","dataCompetenzaPrimoEC":""},{"numPratica":"24100045692","tipoPratica":"CA","saldo":"0","tipoProdotto":"","dataEsame":"20021125","stato":"70","attributo":"CV","tipoRapporto":"CL","prodotto":"01","scaduto":"0","finanziato":"200000","dataPrimoUtilizzo":"","dataPrimaAttivazione":"20021219","dataCompetenzaPrimoEC":""}]}}';
        doGestisciAlertSuPraticheTest(praticaJson,cartaDatiFinanziariERecuperaSaldoClienteResponse);
    }
    
    @isTest public static void doGestisciAlertSuPraticheTestCaso3A(){
        String praticaJson = '[{"abi": "3069","cab": "9471","canale": "   ","codAttributoPratica": "","codCliente": "15080269","codRecuperatore": "","codStatoPratica": "50","convenzionato":"12","dataCaricamento": "11/11/2014","dataEstinzione": "","dealerCode": "12","desAttributoPratica": "","desRecuperatore": "","desStatoPratica": "Attivata","filiale": "16","flagRecupero": "","iban": "IT59B0306909471100000000087","numConto": "100000000087","numPratica": "52144534119","pan": "5262114454599532","prodotto": "28","societa": "","statoPratica": "50","tipoPagamento": "RI","tipoPratica": "CA"}]';
        String cartaDatiFinanziariERecuperaSaldoClienteResponse = '{"resultCode":0,"resultMessage":"Ok","datiCartaDatiFinanziariResponse":{"numeroPratica":"8180824247","filiale":"212","emettitore":"8","pagamentoMinimo":"0","pagamentoMinimoPerc":"0.00","commissioneEntrata":"0","modCalcoloRata":"T","intestazione1":"GAMBADOROANDREA","intestazione2":"","dataValidita":"20130426","dataScadenza":"201905","checkIntermediario":"12","pagamento":"RI","bancaCliAbi":"3058","bancaCliCab":"1604","contoCorrente":"100571605864","iban":"IT04P0305801604100571605864","comRinnovo":"0","comRinnovo1":"0","comRinnovoDurata1":"0","comRinnovo2":"0","comRinnovoDurata2":"0","comRinnovo3":"0","comRinnovoDurata3":"0","stato":"60","blocco":"IV","tassoTan":"0.000","tassoTaeg":"5.160","pan":"4134280846406477","fidoTotale":"350000","dispTotale":"350000","fidoRiserva1":"200000","dispRiserva1":"200000","fidoRiserva2":"150000","dispRiserva2":"150000","fidoRiserva3":"0","dispRiserva3":"0","flagAttivazioneCarta":"S","codProdotto":"NI","desProdotto":"CARTADIPENDENTIFIDO3500","flagAlertSms":"N","riservaPrincipaleFido":"200000","riservaPrincipaleFidoSegno":"","riservaPrincipaleSaldo":"0","riservaPrincipaleSaldoSegno":"","riservaPrincipaleDisp":"200000","riservaPrincipaleDispSegno":"","riservaPrincipaleSconfino":"0","riservaPrincipaleSconfinoSegno":"","riservaPrincipaleOverlimit":"5000","riservaPrincipaleOverlimitSegno":"","riservaPrincipaleDispTeorMax":"355000","riservaPrincipaleDispTeorMaxSegno":"","riservaSalvadanaioFido":"150000","riservaSalvadanaioFidoSegno":"","riservaSalvadanaioSaldo":"0","riservaSalvadanaioSaldoSegno":"","riservaSalvadanaioDisp":"150000","riservaSalvadanaioDispSegno":"","riservaSalvadanaioSconfino":"0","riservaSalvadanaioSconfinoSegno":"","riservaSalvadanaioOverlimit":"0","riservaSalvadanaioOverlimitSegno":"","riservaSalvadanaioDispTeorMax":"355000","riservaSalvadanaioDispTeorMaxSegno":"","riservaInternetFido":"0","riservaInternetFidoSegno":"","riservaInternetSaldo":"0","riservaInternetSaldoSegno":"","riservaInternetDisp":"0","riservaInternetDispSegno":"","riservaInternetSconfino":"0","riservaInternetSconfinoSegno":"","riservaInternetOverlimit":"0","riservaInternetOverlimitSegno":"","riservaInternetDispTeorMax":"0","riservaInternetDispTeorMaxSegno":"","riservaMulticontoFido":"0","riservaMulticontoFidoSegno":"","riservaMulticontoSaldo":"0","riservaMulticontoSaldoSegno":"","riservaMulticontoDisp":"0","riservaMulticontoDispSegno":"","riservaMulticontoSconfino":"0","riservaMulticontoSconfinoSegno":"","riservaMulticontoOverlimit":"0","riservaMulticontoOverlimitSegno":"","riservaMulticontoDispTeorMax":"0","riservaMulticontoDispTeorMaxSegno":"","as400Status":"OK","as400Errore":""},"recuperaSaldoClienteResponse":{"elencoPratiche":[{"numPratica":"6100025944","tipoPratica":"CA","saldo":"0","tipoProdotto":"","dataEsame":"20001106","stato":"70","attributo":"CV","tipoRapporto":"CL","prodotto":"DF","scaduto":"0","finanziato":"500000","dataPrimoUtilizzo":"","dataPrimaAttivazione":"20001127","dataCompetenzaPrimoEC":""},{"numPratica":"8109435018","tipoPratica":"CA","saldo":"0","tipoProdotto":"","dataEsame":"20120925","stato":"70","attributo":"XZ","tipoRapporto":"CL","prodotto":"AW","scaduto":"0","finanziato":"0","dataPrimoUtilizzo":"","dataPrimaAttivazione":"20121012","dataCompetenzaPrimoEC":""},{"numPratica":"8185777259","tipoPratica":"CA","saldo":"161365","tipoProdotto":"","dataEsame":"20110223","stato":"50","attributo":"","tipoRapporto":"CL","prodotto":"DI","scaduto":"0","finanziato":"350000","dataPrimoUtilizzo":"20110331","dataPrimaAttivazione":"20110318","dataCompetenzaPrimoEC":"20110430"},{"numPratica":"24100015679","tipoPratica":"CA","saldo":"0","tipoProdotto":"","dataEsame":"20021125","stato":"70","attributo":"LS","tipoRapporto":"CL","prodotto":"01","scaduto":"0","finanziato":"200000","dataPrimoUtilizzo":"","dataPrimaAttivazione":"20021219","dataCompetenzaPrimoEC":""},{"numPratica":"24100045692","tipoPratica":"CA","saldo":"0","tipoProdotto":"","dataEsame":"20021125","stato":"70","attributo":"CV","tipoRapporto":"CL","prodotto":"01","scaduto":"0","finanziato":"200000","dataPrimoUtilizzo":"","dataPrimaAttivazione":"20021219","dataCompetenzaPrimoEC":""}]}}';
        doGestisciAlertSuPraticheTest(praticaJson,cartaDatiFinanziariERecuperaSaldoClienteResponse);
    }
    
    @isTest public static void doGestisciAlertSuPraticheTestCaso3B(){
        String praticaJson = '[{"abi": "3069","cab": "9471","canale": "   ","codAttributoPratica": "","codCliente": "15080269","codRecuperatore": "","codStatoPratica": "05","convenzionato":"12","dataCaricamento": "11/11/2014","dataEstinzione": "","dealerCode": "12","desAttributoPratica": "","desRecuperatore": "","desStatoPratica": "Attivata","filiale": "16","flagRecupero": "","iban": "IT59B0306909471100000000087","numConto": "100000000087","numPratica": "52144534119","pan": "5262114454599532","prodotto": "28","societa": "","statoPratica": "05","tipoPagamento": "RI","tipoPratica": "CA"}]';
        String cartaDatiFinanziariERecuperaSaldoClienteResponse = '{"resultCode":0,"resultMessage":"Ok","datiCartaDatiFinanziariResponse":{"numeroPratica":"8180824247","filiale":"212","emettitore":"8","pagamentoMinimo":"0","pagamentoMinimoPerc":"0.00","commissioneEntrata":"0","modCalcoloRata":"T","intestazione1":"GAMBADOROANDREA","intestazione2":"","dataValidita":"20130426","dataScadenza":"201905","checkIntermediario":"12","pagamento":"RI","bancaCliAbi":"3058","bancaCliCab":"1604","contoCorrente":"100571605864","iban":"IT04P0305801604100571605864","comRinnovo":"0","comRinnovo1":"0","comRinnovoDurata1":"0","comRinnovo2":"0","comRinnovoDurata2":"0","comRinnovo3":"0","comRinnovoDurata3":"0","stato":"60","blocco":"IV","tassoTan":"0.000","tassoTaeg":"5.160","pan":"4134280846406477","fidoTotale":"350000","dispTotale":"350000","fidoRiserva1":"200000","dispRiserva1":"200000","fidoRiserva2":"150000","dispRiserva2":"150000","fidoRiserva3":"0","dispRiserva3":"0","flagAttivazioneCarta":"N","codProdotto":"NI","desProdotto":"CARTADIPENDENTIFIDO3500","flagAlertSms":"N","riservaPrincipaleFido":"200000","riservaPrincipaleFidoSegno":"","riservaPrincipaleSaldo":"0","riservaPrincipaleSaldoSegno":"","riservaPrincipaleDisp":"200000","riservaPrincipaleDispSegno":"","riservaPrincipaleSconfino":"0","riservaPrincipaleSconfinoSegno":"","riservaPrincipaleOverlimit":"5000","riservaPrincipaleOverlimitSegno":"","riservaPrincipaleDispTeorMax":"355000","riservaPrincipaleDispTeorMaxSegno":"","riservaSalvadanaioFido":"150000","riservaSalvadanaioFidoSegno":"","riservaSalvadanaioSaldo":"0","riservaSalvadanaioSaldoSegno":"","riservaSalvadanaioDisp":"150000","riservaSalvadanaioDispSegno":"","riservaSalvadanaioSconfino":"0","riservaSalvadanaioSconfinoSegno":"","riservaSalvadanaioOverlimit":"0","riservaSalvadanaioOverlimitSegno":"","riservaSalvadanaioDispTeorMax":"355000","riservaSalvadanaioDispTeorMaxSegno":"","riservaInternetFido":"0","riservaInternetFidoSegno":"","riservaInternetSaldo":"0","riservaInternetSaldoSegno":"","riservaInternetDisp":"0","riservaInternetDispSegno":"","riservaInternetSconfino":"0","riservaInternetSconfinoSegno":"","riservaInternetOverlimit":"0","riservaInternetOverlimitSegno":"","riservaInternetDispTeorMax":"0","riservaInternetDispTeorMaxSegno":"","riservaMulticontoFido":"0","riservaMulticontoFidoSegno":"","riservaMulticontoSaldo":"0","riservaMulticontoSaldoSegno":"","riservaMulticontoDisp":"0","riservaMulticontoDispSegno":"","riservaMulticontoSconfino":"0","riservaMulticontoSconfinoSegno":"","riservaMulticontoOverlimit":"0","riservaMulticontoOverlimitSegno":"","riservaMulticontoDispTeorMax":"0","riservaMulticontoDispTeorMaxSegno":"","as400Status":"OK","as400Errore":""},"recuperaSaldoClienteResponse":{"elencoPratiche":[{"numPratica":"6100025944","tipoPratica":"CA","saldo":"0","tipoProdotto":"","dataEsame":"20001106","stato":"70","attributo":"CV","tipoRapporto":"CL","prodotto":"DF","scaduto":"0","finanziato":"500000","dataPrimoUtilizzo":"","dataPrimaAttivazione":"20001127","dataCompetenzaPrimoEC":""},{"numPratica":"8109435018","tipoPratica":"CA","saldo":"0","tipoProdotto":"","dataEsame":"20120925","stato":"70","attributo":"XZ","tipoRapporto":"CL","prodotto":"AW","scaduto":"0","finanziato":"0","dataPrimoUtilizzo":"","dataPrimaAttivazione":"20121012","dataCompetenzaPrimoEC":""},{"numPratica":"8185777259","tipoPratica":"CA","saldo":"161365","tipoProdotto":"","dataEsame":"20110223","stato":"50","attributo":"","tipoRapporto":"CL","prodotto":"DI","scaduto":"0","finanziato":"350000","dataPrimoUtilizzo":"20110331","dataPrimaAttivazione":"20110318","dataCompetenzaPrimoEC":"20110430"},{"numPratica":"24100015679","tipoPratica":"CA","saldo":"0","tipoProdotto":"","dataEsame":"20021125","stato":"70","attributo":"LS","tipoRapporto":"CL","prodotto":"01","scaduto":"0","finanziato":"200000","dataPrimoUtilizzo":"","dataPrimaAttivazione":"20021219","dataCompetenzaPrimoEC":""},{"numPratica":"24100045692","tipoPratica":"CA","saldo":"0","tipoProdotto":"","dataEsame":"20021125","stato":"70","attributo":"CV","tipoRapporto":"CL","prodotto":"01","scaduto":"0","finanziato":"200000","dataPrimoUtilizzo":"","dataPrimaAttivazione":"20021219","dataCompetenzaPrimoEC":""}]}}';
        doGestisciAlertSuPraticheTest(praticaJson,cartaDatiFinanziariERecuperaSaldoClienteResponse);
    }
    
    public static void doGestisciAlertSuPraticheTest(String praticaJson,String cartaDatiFinanziariERecuperaSaldoClienteResponse) {
        
        List<OCSPratica> pratiche = (List<OCSPratica>) JSON.deserialize(praticaJson, List<OCSPratica>.class);
        System.debug('Pratiche: ' + pratiche);
        
        Test.startTest();
        MyUtilityMockResponse UMR = new MyUtilityMockResponse();
        UMR.apiname = 'ocs.cartaDatiFinanziari';
        UMR.response = cartaDatiFinanziariERecuperaSaldoClienteResponse;
        Test.setMock(HttpCalloutMock.class, UMR);
        PV3267VariazioneIndirizzi.doGestisciAlertSuPratiche(pratiche, '123456');
        Test.stopTest();
        
    }
    
    
    
    public class MyUtilityMockResponse implements HttpCalloutMock {
        public String apiname;
        public String response;
        public HTTPResponse respond(HTTPRequest req) {
            HttpResponse res = new HttpResponse();
            String urlId = req.getEndpoint();
            //System.assert(urlId != null, 'API endpoint missing.');
            res.setHeader('Content-Type', 'application/json');
            System.debug('APINAME:::::::::::::> ' + apiname);
            ApiRest__c ar = [select Test_Request__c from Apirest__c where endpoint__c = :urlId and name = :apiname LIMIT 1];
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