@isTest
public class XPathTest {
    
    @testSetup
    public static void setup(){
		XCS_Categoria__c cat = new XCS_Categoria__c(Name='Contabilità  Generale',External_Id__c='5299');
        insert cat;
    }
    @isTest
    public static void XPathTest() {
        /**NOT USED
        StaticResourceCalloutMock mock = new StaticResourceCalloutMock();
        mock.setStatus('OK');
        mock.setStatusCode(200);
        mock.setStaticResource('quickReport');
        Test.setMock(HttpCalloutMock.class, mock);
***/
        //PageReference somefileRef =  new PageReference('/resource/quickReport');
        //Blob contentAsBlob = somefileRef.getContent();
        //String contentAsText = contentAsBlob.toString();
        Blob contentAsBlob=[SELECT Body FROM StaticResource WHERE Name = 'quickReport' ].Body;
        String contentAsText=EncodingUtil.base64encode(contentAsBlob);
        SFAConvenzionamentoNewDealProspctCtrller.QuickReportResponseAndXPath qrpandxp = SFAConvenzionamentoNewDealProspctCtrller.getQuickReportResponseFromFixedXML(contentAsText);
        
        
        QuickReportResponse quickReportResponse = qrpandxp.quickReportResponse;
        Xpath xpath = qrpandxp.xpath;

        String SAE=xpath.getText('/s2xResponse/s2xData/EconomicalActivity/SAECode2007');
        System.debug('--SAE '+SAE);
    }

    @isTest
    public static void test1(){
        Blob contentAsBlob=[SELECT Body FROM StaticResource WHERE Name = 'quickReport' ].Body;
        String base64strXML=EncodingUtil.base64encode(contentAsBlob);
        //salvaDatiDaQuickReport(String base64strXML, String dealerProspectId, String caseId){
        //create dealer per convenzionamento
        FObject objDealer=new FObject('Account',1);
        objDealer.setDefinition('RecordTypeId', 'static value(Dealer)');
        objDealer.setDefinition('Name','static value(Dealer1)');
        objDealer.insertRecords(true);
        FObject objRifContact=new FObject('Contact',1);
        objRifContact.setDefinition('AccountId', 'random lookup(Account) source(salesforce)');
        objRifContact.setDefinition('LastName','static value(Rif)');
        objRifContact.setDefinition('IsContactDiRiferimentoDealer__c','static value(true)');
        objRifContact.insertRecords(true);

        Id dealerProspectId=[select id from account].Id;
         FObject objCase=new FObject('Case',1);
        //objDealer.setDefinition('RecordTypeId', 'statc value(Dealer)');
        //objDealer.setDefinition('Name','Dealer1');
        objCase.insertRecords(true);
        Id caseId=[select id from case].Id;
        //create case per convenzionamento
        SFAConvenzionamentoNewDealProspctCtrller.DatiReportCervedDaQuickReport datiReport = SFAConvenzionamentoNewDealProspctCtrller.salvaDatiDaQuickReport(base64strXML,dealerProspectId,caseId);

        System.assertEquals(null, datiReport.rating);
        System.assertEquals('N', datiReport.protesti);
        System.assertEquals('N', datiReport.pregiudizievoli);

        Account dealer=[select Sae__c, Rae__c,Forma_Giuridica__c,Name,ShippingStreet,ShippingPostalCode,ShippingState,
            ShippingCity,Partita_IVA__c,Codice_Fiscale__c,dataInizioAttivita__c,Desc_Ateco__c,COD_Ateco__c from account];
        System.assertEquals('430', dealer.Sae__c);
        System.assertEquals('950', dealer.Rae__c);
        System.assertEquals('SRL', dealer.Forma_Giuridica__c);
        System.assertEquals('ETICA DENTALE SRL', dealer.Name);
        System.assertEquals('VIA DEL FRANCESE 21', dealer.ShippingStreet);
        System.assertEquals('00015', dealer.ShippingPostalCode);
        System.assertEquals('RM', dealer.ShippingState);
        System.assertEquals('MONTEROTONDO', dealer.ShippingCity);
        System.assertEquals('14128781003', dealer.Partita_IVA__c);
        System.assertEquals('14128781003', dealer.Codice_Fiscale__c);
        System.assertEquals(null, dealer.dataInizioAttivita__c);
        System.assertEquals('8623 - Attivita\' degli studi odontoiatrici', dealer.Desc_Ateco__c);
        System.assertEquals('8623', dealer.COD_Ateco__c);

        Case c=[select Fido__c,DataAnalisi__c,Pagamenti__c from case];
        System.assertEquals(null, c.Fido__c);
        System.assertEquals('16/02/2017', c.DataAnalisi__c.format());
        System.assertEquals(null, c.Pagamenti__c);

        Contact contactRif=[select Email from contact where lastName='Rif'];

        System.assertEquals('eticadentalesrl@legalmail.it', contactRif.Email);
        
        Contact con = [select accountid,LastName,FirstName,Codice_Fiscale__c,Birthdate,Provincia_Nascita__c,
            Sesso__c,Tipo_Anagrafica__c,MailingStreet,MailingCountry,MailingPostalCode,MailingState,MailingCity  from contact where lastName!='Rif'][0];
        System.assertEquals(dealerProspectId, con.AccountId);
        System.assertEquals('GIACOMONI', con.LastName);
        System.assertEquals('SIMONE', con.FirstName);
        System.assertEquals('GCMSMN75C08H501U', con.Codice_Fiscale__c);
        System.assertEquals('08/03/1975', con.Birthdate.format());
        System.assertEquals('RM', con.Provincia_Nascita__c);
        System.assertEquals('M', con.Sesso__c);
        System.assertEquals('F', con.Tipo_Anagrafica__c);
        System.assertEquals('C/VILADOMAT 11 4/2', con.MailingStreet);
        System.assertEquals('E', con.MailingCountry);
        System.assertEquals(null, con.MailingPostalCode);
        System.assertEquals(null, con.MailingState);
        System.assertEquals('BARCELLONA', con.MailingCity);

        con = [select accountid,DataInizioAttivita__c,RagioneSociale__c,Partita_IVA__c,LastName,FirstName,Codice_Fiscale__c,Birthdate,Provincia_Nascita__c,
            Sesso__c,Tipo_Anagrafica__c,MailingStreet,MailingCountry,MailingPostalCode,MailingState,MailingCity  from contact where lastName!='Rif'][1];
        System.assertEquals(dealerProspectId, con.AccountId);
        System.assertEquals('FOOD TRADE CONSULTING S.R.L.', con.LastName);
        System.assertEquals(null, con.FirstName);
        System.assertEquals('12753361000', con.Codice_Fiscale__c);
        System.assertEquals(null, con.Birthdate);
        System.assertEquals(null, con.Provincia_Nascita__c);
        System.assertEquals(null, con.Sesso__c);
        System.assertEquals('G', con.Tipo_Anagrafica__c);
        System.assertEquals('21/02/2014', con.DataInizioAttivita__c.format());
        System.assertEquals('FOOD TRADE CONSULTING S.R.L.', con.RagioneSociale__c);
        System.assertEquals('12753361000', con.Partita_IVA__c);                 


        //[select AccountId,LastName,FirstName,Codice_Fiscale__c,Birthdate,Provincia_Nascita__c,Luogo_Nascita__c,Sesso__c from contact];
        
    }


      @isTest
    public static void test2(){
        Blob contentAsBlob=[SELECT Body FROM StaticResource WHERE Name = 'quickReport_2' ].Body;
        String base64strXML=EncodingUtil.base64encode(contentAsBlob);
        //salvaDatiDaQuickReport(String base64strXML, String dealerProspectId, String caseId){
        //create dealer per convenzionamento
        FObject objDealer=new FObject('Account',1);
        objDealer.setDefinition('RecordTypeId', 'static value(Dealer)');
        objDealer.setDefinition('Name','static value(Dealer1)');
        objDealer.insertRecords(true);
        FObject objRifContact=new FObject('Contact',1);
        objRifContact.setDefinition('AccountId', 'random lookup(Account) source(salesforce)');
        objRifContact.setDefinition('LastName','static value(Rif)');
        objRifContact.setDefinition('IsContactDiRiferimentoDealer__c','static value(true)');
        objRifContact.insertRecords(true);

        Id dealerProspectId=[select id from account].Id;
         FObject objCase=new FObject('Case',1);
        //objDealer.setDefinition('RecordTypeId', 'statc value(Dealer)');
        //objDealer.setDefinition('Name','Dealer1');
        objCase.insertRecords(true);
        Id caseId=[select id from case].Id;
        //create case per convenzionamento
        SFAConvenzionamentoNewDealProspctCtrller.DatiReportCervedDaQuickReport datiReport = SFAConvenzionamentoNewDealProspctCtrller.salvaDatiDaQuickReport(base64strXML,dealerProspectId,caseId);

        System.assertEquals('CGS_5', datiReport.rating);
        System.assertEquals('N', datiReport.protesti);
        System.assertEquals('N', datiReport.pregiudizievoli);

        Account dealer=[select Sae__c, Rae__c,Forma_Giuridica__c,Name,ShippingStreet,ShippingPostalCode,ShippingState,
            ShippingCity,Partita_IVA__c,Codice_Fiscale__c,dataInizioAttivita__c,Desc_Ateco__c,COD_Ateco__c from account];
        System.assertEquals('615', dealer.Sae__c);
        System.assertEquals('648', dealer.Rae__c);
        System.assertEquals('DIN', dealer.Forma_Giuridica__c);
        System.assertEquals('SELIS CATERINA', dealer.Name);
        System.assertEquals('VIA MATTEOTTI 28', dealer.ShippingStreet);
        System.assertEquals('08029', dealer.ShippingPostalCode);
        System.assertEquals('NU', dealer.ShippingState);
        System.assertEquals('SINISCOLA', dealer.ShippingCity);
        System.assertEquals('00870780913', dealer.Partita_IVA__c);
        System.assertEquals('SLSCRN64H56Z103Q', dealer.Codice_Fiscale__c);
        System.assertEquals('08/10/1990', dealer.dataInizioAttivita__c.format());
        System.assertEquals('47591 - Commercio al dettaglio di mobili per la casa', dealer.Desc_Ateco__c);
        System.assertEquals('47591', dealer.COD_Ateco__c);

        Case c=[select Fido__c,DataAnalisi__c,Pagamenti__c from case];
        System.assertEquals(null, c.Fido__c);
        System.assertEquals('13/12/2019', c.DataAnalisi__c.format());
        System.assertEquals('6', c.Pagamenti__c);

        Contact contactRif=[select Email,LastName,FirstName,Codice_Fiscale__c,Sesso__c from contact where IsContactDiRiferimentoDealer__c=true];

        System.assertEquals('seliscaterina@pec.it', contactRif.Email);
        System.assertEquals('SELIS', contactRif.LastName);
        System.assertEquals('CATERINA', contactRif.FirstName);
        System.assertEquals('SLSCRN64H56Z103Q', contactRif.Codice_Fiscale__c);
        System.assertEquals('F', contactRif.Sesso__c);
        
        Contact con = [select accountid,LastName,FirstName,Codice_Fiscale__c,Birthdate,Provincia_Nascita__c,
            Sesso__c,Tipo_Anagrafica__c,MailingStreet,MailingCountry,MailingPostalCode,MailingState,MailingCity  from contact where IsContactDiRiferimentoDealer__c=false][0];
        System.assertEquals(dealerProspectId, con.AccountId);
        System.assertEquals('SELIS', con.LastName);
        System.assertEquals('CATERINA', con.FirstName);
        System.assertEquals('SLSCRN64H56Z103Q', con.Codice_Fiscale__c);
        System.assertEquals('16/06/1964', con.Birthdate.format());
        System.assertEquals(null, con.Provincia_Nascita__c);
        System.assertEquals('F', con.Sesso__c);
        System.assertEquals('F', con.Tipo_Anagrafica__c);
        System.assertEquals('VIA MATTEOTTI 28', con.MailingStreet);
        System.assertEquals(null, con.MailingCountry);
        System.assertEquals('08029', con.MailingPostalCode);
        System.assertEquals('NU', con.MailingState);
        System.assertEquals('SINISCOLA', con.MailingCity);    
        
    }
     @isTest
    public static void testfileblank(){
        Blob contentAsBlob=[SELECT Body FROM StaticResource WHERE Name = 'quickreportblank' ].Body;
        String base64strXML=EncodingUtil.base64encode(contentAsBlob);
        //salvaDatiDaQuickReport(String base64strXML, String dealerProspectId, String caseId){
        //create dealer per convenzionamento
        FObject objDealer=new FObject('Account',1);
        objDealer.setDefinition('RecordTypeId', 'static value(Dealer)');
        objDealer.setDefinition('Name','static value(Dealer1)');
        objDealer.insertRecords(true);
        FObject objRifContact=new FObject('Contact',1);
        objRifContact.setDefinition('AccountId', 'random lookup(Account) source(salesforce)');
        objRifContact.setDefinition('LastName','static value(Rif)');
        objRifContact.setDefinition('IsContactDiRiferimentoDealer__c','static value(true)');
        objRifContact.insertRecords(true);

        Id dealerProspectId=[select id from account].Id;
         FObject objCase=new FObject('Case',1);
        //objDealer.setDefinition('RecordTypeId', 'statc value(Dealer)');
        //objDealer.setDefinition('Name','Dealer1');
        objCase.insertRecords(true);
        Id caseId=[select id from case].Id;
        //create case per convenzionamento
        SFAConvenzionamentoNewDealProspctCtrller.DatiReportCervedDaQuickReport datiReport = SFAConvenzionamentoNewDealProspctCtrller.salvaDatiDaQuickReport(base64strXML,dealerProspectId,caseId);
/*
        System.assertEquals('CGS_5', datiReport.rating);
        System.assertEquals('N', datiReport.protesti);
        System.assertEquals('N', datiReport.pregiudizievoli);

        Account dealer=[select Sae__c, Rae__c,Forma_Giuridica__c,Name,ShippingStreet,ShippingPostalCode,ShippingState,
            ShippingCity,Partita_IVA__c,Codice_Fiscale__c,dataInizioAttivita__c,Desc_Ateco__c,COD_Ateco__c from account];
        System.assertEquals('615', dealer.Sae__c);
        System.assertEquals('648', dealer.Rae__c);
        System.assertEquals('SELIS CATERINA', dealer.Name);
        System.assertEquals('VIA MATTEOTTI 28', dealer.ShippingStreet);
        System.assertEquals('08029', dealer.ShippingPostalCode);
        System.assertEquals('NU', dealer.ShippingState);
        System.assertEquals('SINISCOLA', dealer.ShippingCity);
        System.assertEquals('00870780913', dealer.Partita_IVA__c);
        System.assertEquals('SLSCRN64H56Z103Q', dealer.Codice_Fiscale__c);
        System.assertEquals('08/10/1990', dealer.dataInizioAttivita__c.format());
        System.assertEquals('47591 - Commercio al dettaglio di mobili per la casa', dealer.Desc_Ateco__c);
        System.assertEquals('47591', dealer.COD_Ateco__c);

        Case c=[select Fido__c,DataAnalisi__c,Pagamenti__c from case];
        System.assertEquals(null, c.Fido__c);
        System.assertEquals('13/12/2019', c.DataAnalisi__c.format());
        System.assertEquals('6', c.Pagamenti__c);

        Contact contactRif=[select Email,LastName,FirstName,Codice_Fiscale__c,Sesso__c from contact where IsContactDiRiferimentoDealer__c=true];

        System.assertEquals('seliscaterina@pec.it', contactRif.Email);
        System.assertEquals('SELIS', contactRif.LastName);
        System.assertEquals('CATERINA', contactRif.FirstName);
        System.assertEquals('SLSCRN64H56Z103Q', contactRif.Codice_Fiscale__c);
        System.assertEquals('F', contactRif.Sesso__c);
        
        Contact con = [select accountid,LastName,FirstName,Codice_Fiscale__c,Birthdate,Provincia_Nascita__c,
            Sesso__c,Tipo_Anagrafica__c,MailingStreet,MailingCountry,MailingPostalCode,MailingState,MailingCity  from contact where IsContactDiRiferimentoDealer__c=false][0];
        System.assertEquals(dealerProspectId, con.AccountId);
        System.assertEquals('SELIS', con.LastName);
        System.assertEquals('CATERINA', con.FirstName);
        System.assertEquals('SLSCRN64H56Z103Q', con.Codice_Fiscale__c);
        System.assertEquals('16/06/1964', con.Birthdate.format());
        System.assertEquals(null, con.Provincia_Nascita__c);
        System.assertEquals('F', con.Sesso__c);
        System.assertEquals('F', con.Tipo_Anagrafica__c);
        System.assertEquals('VIA MATTEOTTI 28', con.MailingStreet);
        System.assertEquals(null, con.MailingCountry);
        System.assertEquals('08029', con.MailingPostalCode);
        System.assertEquals('NU', con.MailingState);
        System.assertEquals('SINISCOLA', con.MailingCity);    
        */
    }
     @isTest
    public static void testfile_bug_1710(){
        Blob contentAsBlob=[SELECT Body FROM StaticResource WHERE Name = 'quickreport_error_1701' ].Body;
        String base64strXML=EncodingUtil.base64encode(contentAsBlob);
        //salvaDatiDaQuickReport(String base64strXML, String dealerProspectId, String caseId){
        //create dealer per convenzionamento
        FObject objDealer=new FObject('Account',1);
        objDealer.setDefinition('RecordTypeId', 'static value(Dealer)');
        objDealer.setDefinition('Name','static value(Dealer1)');
        objDealer.insertRecords(true);
        FObject objRifContact=new FObject('Contact',1);
        objRifContact.setDefinition('AccountId', 'random lookup(Account) source(salesforce)');
        objRifContact.setDefinition('LastName','static value(Rif)');
        objRifContact.setDefinition('IsContactDiRiferimentoDealer__c','static value(true)');
        objRifContact.insertRecords(true);

        Id dealerProspectId=[select id from account].Id;
         FObject objCase=new FObject('Case',1);
        //objDealer.setDefinition('RecordTypeId', 'statc value(Dealer)');
        //objDealer.setDefinition('Name','Dealer1');
        objCase.insertRecords(true);
        Id caseId=[select id from case].Id;
        //create case per convenzionamento
        SFAConvenzionamentoNewDealProspctCtrller.DatiReportCervedDaQuickReport datiReport = SFAConvenzionamentoNewDealProspctCtrller.salvaDatiDaQuickReport(base64strXML,dealerProspectId,caseId);
/*
        System.assertEquals('CGS_5', datiReport.rating);
        System.assertEquals('N', datiReport.protesti);
        System.assertEquals('N', datiReport.pregiudizievoli);

        Account dealer=[select Sae__c, Rae__c,Forma_Giuridica__c,Name,ShippingStreet,ShippingPostalCode,ShippingState,
            ShippingCity,Partita_IVA__c,Codice_Fiscale__c,dataInizioAttivita__c,Desc_Ateco__c,COD_Ateco__c from account];
        System.assertEquals('615', dealer.Sae__c);
        System.assertEquals('648', dealer.Rae__c);
        System.assertEquals('SELIS CATERINA', dealer.Name);
        System.assertEquals('VIA MATTEOTTI 28', dealer.ShippingStreet);
        System.assertEquals('08029', dealer.ShippingPostalCode);
        System.assertEquals('NU', dealer.ShippingState);
        System.assertEquals('SINISCOLA', dealer.ShippingCity);
        System.assertEquals('00870780913', dealer.Partita_IVA__c);
        System.assertEquals('SLSCRN64H56Z103Q', dealer.Codice_Fiscale__c);
        System.assertEquals('08/10/1990', dealer.dataInizioAttivita__c.format());
        System.assertEquals('47591 - Commercio al dettaglio di mobili per la casa', dealer.Desc_Ateco__c);
        System.assertEquals('47591', dealer.COD_Ateco__c);

        Case c=[select Fido__c,DataAnalisi__c,Pagamenti__c from case];
        System.assertEquals(null, c.Fido__c);
        System.assertEquals('13/12/2019', c.DataAnalisi__c.format());
        System.assertEquals('6', c.Pagamenti__c);

        Contact contactRif=[select Email,LastName,FirstName,Codice_Fiscale__c,Sesso__c from contact where IsContactDiRiferimentoDealer__c=true];

        System.assertEquals('seliscaterina@pec.it', contactRif.Email);
        System.assertEquals('SELIS', contactRif.LastName);
        System.assertEquals('CATERINA', contactRif.FirstName);
        System.assertEquals('SLSCRN64H56Z103Q', contactRif.Codice_Fiscale__c);
        System.assertEquals('F', contactRif.Sesso__c);
        
        Contact con = [select accountid,LastName,FirstName,Codice_Fiscale__c,Birthdate,Provincia_Nascita__c,
            Sesso__c,Tipo_Anagrafica__c,MailingStreet,MailingCountry,MailingPostalCode,MailingState,MailingCity  from contact where IsContactDiRiferimentoDealer__c=false][0];
        System.assertEquals(dealerProspectId, con.AccountId);
        System.assertEquals('SELIS', con.LastName);
        System.assertEquals('CATERINA', con.FirstName);
        System.assertEquals('SLSCRN64H56Z103Q', con.Codice_Fiscale__c);
        System.assertEquals('16/06/1964', con.Birthdate.format());
        System.assertEquals(null, con.Provincia_Nascita__c);
        System.assertEquals('F', con.Sesso__c);
        System.assertEquals('F', con.Tipo_Anagrafica__c);
        System.assertEquals('VIA MATTEOTTI 28', con.MailingStreet);
        System.assertEquals(null, con.MailingCountry);
        System.assertEquals('08029', con.MailingPostalCode);
        System.assertEquals('NU', con.MailingState);
        System.assertEquals('SINISCOLA', con.MailingCity);    
        */
    }
 
    
    
    
    
}