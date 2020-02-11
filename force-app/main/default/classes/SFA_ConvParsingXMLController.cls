public class SFA_ConvParsingXMLController {
    
    
    private static final String PRESENTE = 'Presente';
    private static final String RICHIESTO = 'Richiesto';
    private static final String QUICK_REPORT = 'Quick Report';
    private static final String GLOBAL_EXPERT = 'Global Expert';
    private static final String ATTIVO = 'A';
    private static final String ISCRITTO = 'I';
    private static final String CHIUSO = 'C';
    private static final String STEP_INIZIALE = 'NewDealerProspect_StepIniziale';
    private static final String REPORT_PRESENTE = 'NewDealerProspect_ReportPresente';
    private static final String QUICK_REPORT_RICHIESTO = 'NewDealerProspect_QuickReportRichiesto';
    private static final String GLOBAL_EXPERT_RICHIESTO = 'NewDealerProspect_GlobalExpertRichiesto';
    private static final String RICHIEDI_QUICK_REPORT = 'NewDealerProspect_RichiediQuickReport';
    private static final String RICHIEDI_GLOBAL_EXPERT = 'NewDealerProspect_RichiediGlobalExpert';
    private static final String IN_ISCRIZIONE = 'NewDealerProspect_DealerInIscrizione';
    private static final String ESITA_CASE = 'NewDealerProspect_EsitaCase';
    private static final String RUOLO_SOC = 'SOC';
    private static final String READ_TIMED_OUT = 'Read timed out';
    

    @AuraEnabled
    public static CheckPresenzaReportResult doInit(String dealerId)
    {
        List<Case> lCase = [Select id,createddate from case where AccountId = :dealerId AND categoria_riferimento__r.External_Id__c = '3127' AND StepAttivitaConvenzionamento__c = 'NewDealerProspect_RichiediQuickReport' order by createddate desc];
        CheckPresenzaReportResult ck;
        if(!lCase.isEmpty())
        {
           Case c = lCase[0];
           ck =  simulaRichiestaQuickReport(c.id,dealerId);   
        }
        else
        {
           ck = new CheckPresenzaReportResult();
           ck.errorCode = -10;
           ck.errorMessage = 'Nessun Case di convenzionamento Trovato per il dealer in questione'; 
        }
        return ck;
    }
    
    @AuraEnabled
    public static CheckPresenzaReportResult simulaRichiestaQuickReport(String caseId, String dealerProspectId) {
        
        System.debug('*** richiediQuickReport()');
        
        CheckPresenzaReportResult cprr = new CheckPresenzaReportResult();
        
        try {
            
            Case c = [SELECT Id, StepAttivitaConvenzionamento__c FROM Case WHERE Id = :caseId][0];
            ReportCerved__c reportCerved;
            List<ReportCerved__c> lstReportCerved = 
                [SELECT Id, IdDifferita__c
                 FROM ReportCerved__c 
                 WHERE DealerId__c = :dealerProspectId AND IdAttivita__c = :caseId ORDER BY CreatedDate DESC];
            if (lstReportCerved.size() > 0)
            {
                reportCerved = lstReportCerved.get(0);
                
                
                String step = c.StepAttivitaConvenzionamento__c;
                String idDifferita;
                String requestType = 'DOCUMENT';
                
                ReportCerved__c nuovoQuickReport = new ReportCerved__c();
                nuovoQuickReport.Tipo__c = QUICK_REPORT;
                nuovoQuickReport.DealerId__c = dealerProspectId;
                nuovoQuickReport.IdAttivita__c = caseId;
                nuovoQuickReport.id = reportCerved.id;
                
                List<ContentDocumentLink> lCDL = [SELECT Id, Visibility, ShareType, LinkedEntityId, ContentDocumentId FROM ContentDocumentLink where LinkedEntityId = :reportCerved.id];
                Set<Id> idSets = new Set<Id>();
                for(ContentDocumentLink l : LCDL)
                {
                    idSets.add(l.ContentDocumentId);
                }
                if(!idSets.isEmpty())
                {
                    List<ContentVersion> lc = [select id,versiondata From ContentVersion where fileType = 'XML' AND ContentDocumentId IN :idSets order by Createddate desc];
                    if(!lc.isEmpty())
                    {
                        ContentVersion cv = lc[0];
                        DatiReportCervedDaQuickReport datiDaQRP = salvaDatiDaQuickReport(cv.versiondata, dealerProspectId, caseId);
                        nuovoQuickReport.Rating__c = datiDaQRP.rating;
                        nuovoQuickReport.Protesti__c = datiDaQRP.protesti;
                        nuovoQuickReport.Pregiudizievoli__c = datiDaQRP.pregiudizievoli; 
                        nuovoQuickReport.Status__c = PRESENTE;
                        upsert nuovoQuickReport;
                        c.StepAttivitaConvenzionamento__c = REPORT_PRESENTE;
                        update c;
                        cprr.errorCode = 0;
               			cprr.errorMessage = 'Parsing Effettuato con Successo';
                    }
                    else
                    {
                        cprr.errorCode = -10;
               			cprr.errorMessage = 'Nessun Report XML trovato';
                    }
                }
                else
                {
                    cprr.errorCode = -10;
               		cprr.errorMessage = 'Nessun Report XML trovato';
                }
            }
                else{
                    cprr.errorCode = -10;
               		cprr.errorMessage = 'Nessun Report XML trovato';
                }
            }
            catch (Exception e) {
                System.debug('*** errorMessage :: '+e.getMessage() );
                cprr.errorCode = -10;
                cprr.errorMessage = 'Si è verificato un errore durante il recupero del Quick Report.';
            }
            
            return cprr;
            
        }
        @AuraEnabled
        public static DatiReportCervedDaQuickReport salvaDatiDaQuickReport(blob base64strXML, String dealerProspectId, String caseId){
            
            System.debug('*** salvaDatiDaQuickReport()');
            
            //System.debug('*** base64strXML :: ' + base64strXML);
            
            QuickReportResponseAndXPath qrpandxp = getQuickReportResponseFromFixedXML(base64strXML);
            
            QuickReportResponse quickReportResponse = qrpandxp.quickReportResponse;
            Xpath xpath = qrpandxp.xpath;
            
            List<AccountContactRelation> lstAccountContactRelation = new List<AccountContactRelation>();
            
            Map<String, Contact> mapCFtoContact = new Map<String, Contact>();
            Map<String, String> mapCFToRole = new Map<String, String>();
            
            //List<Contact> lstContactIL = new List<Contact>();
            //List<Contact> lstContactSL = new List<Contact>();
            
            Account account = 
                [SELECT Id, Name, Sae__c, Rae__c, ShippingStreet, Forma_Giuridica__c,ShippingPostalCode, ShippingState, ShippingCity, Partita_IVA__c, Codice_Fiscale__c, DataInizioAttivita__c, Desc_Ateco__c, Tipo_Intermediario__c, Type_Anag__c 
                 FROM Account
                 WHERE Id = :dealerProspectId][0];
            
            Case c = 
                [SELECT Id, Fido__c, DataAnalisi__c, Pagamenti__c 
                 FROM Case 
                 WHERE Id = :caseId][0];
            
            DatiReportCervedDaQuickReport datiReport = new DatiReportCervedDaQuickReport();
            
            //System.debug('*** quickReportResponse :: ' + JSON.serialize(quickReportResponse));
            //System.debug('*** quickReportResponse.s2xResponse :: ' + JSON.serialize(quickReportResponse.s2xResponse));
            //System.debug('*** quickReportResponse.s2xResponse.s2xData :: ' + JSON.serialize(quickReportResponse.s2xResponse.s2xData));
            //System.debug('*** quickReportResponse.s2xResponse.s2xData.EconomicalActivity :: ' + JSON.serialize(quickReportResponse.s2xResponse.s2xData.EconomicalActivity));
            //System.debug('*** quickReportResponse.s2xResponse.s2xData.EconomicalActivity.SAECode2007 :: ' + JSON.serialize(quickReportResponse.s2xResponse.s2xData.EconomicalActivity.SAECode2007));
            
            /********MC INTERVENTI */
            //20191213 MC using xpath
            //account.Sae__c = quickReportResponse.s2xResponse.s2xData.EconomicalActivity.SAECode2007;
            //account.Rae__c = quickReportResponse.s2xResponse.s2xData.EconomicalActivity.RAECode2007;
            String xmlRoot='/s2xResponse/s2xData';
            String xmlRoot_1=xmlRoot+'/IdentifyingData/CervedProspectAdditionalInformations/RegisteredHeadOfficeIdentification';
            String xmlRoot_2=xmlRoot+'/IdentifyingData/CervedProspectAdditionalInformations/RegisteredHeadOfficeLocation';
            account.Sae__c = xpath.getText(xmlRoot+'/EconomicalActivity/SAECode2007');
            account.Rae__c=xpath.getText(xmlRoot+'/EconomicalActivity/RAECode2007');
            /********MC INTERVENTI */
            
            //String formaGiuridicaFromCerved = quickReportResponse.s2xResponse.s2xData.IdentifyingData.CervedProspectAdditionalInformations.RegisteredHeadOfficeIdentification.CompanyTitle;               
            String formaGiuridicaFromCerved = xpath.getText(xmlRoot_1+'/CompanyTitle');
            system.debug('formaGiuridicaCerved '+formaGiuridicaFromCerved);
            if (formaGiuridicaFromCerved != null)
                account.Forma_Giuridica__c = SFAConvenzionamentoNewDealProspctCtrller.getFormaGiuridica(dealerProspectId, formaGiuridicaFromCerved);
            
            if ('DIN'.equals(account.Forma_Giuridica__c))
                account.Type_Anag__c = 'F';
            else
                account.Type_Anag__c = 'G';
            /*****20191213 MC intervento */                    
            //account.Name = quickReportResponse.s2xResponse.s2xData.IdentifyingData.CervedProspectAdditionalInformations.RegisteredHeadOfficeIdentification.CompanyName;
            
            String accountname = xpath.getText(xmlRoot_1+'/CompanyName');
            
            if(!String.isBlank(accountname))
            {
                account.Name = accountname;
            }
            
            //System.debug('*** quickReportResponse.s2xResponse.s2xData.IdentifyingData.CervedProspectAdditionalInformations.RegisteredHeadOfficeLocation.Address.ToponymCode :: ' + JSON.serialize(quickReportResponse.s2xResponse.s2xData.IdentifyingData.CervedProspectAdditionalInformations.RegisteredHeadOfficeLocation.Address.ToponymCode));
            /***20191213 MC intervento */
            //account.ShippingStreet = quickReportResponse.s2xResponse.s2xData.IdentifyingData.CervedProspectAdditionalInformations.RegisteredHeadOfficeLocation.Address.ToponymCode + ' ' + quickReportResponse.s2xResponse.s2xData.IdentifyingData.CervedProspectAdditionalInformations.RegisteredHeadOfficeLocation.Address.StreetName + ' ' +
            account.ShippingStreet =xpath.getText(xmlRoot_2+'/Address/ToponymCode') + ' ' + xpath.getText(xmlRoot_2+'/Address/StreetName') + ' ' +
                //quickReportResponse.s2xResponse.s2xData.IdentifyingData.CervedProspectAdditionalInformations.RegisteredHeadOfficeLocation.Address.StreetNo;
                xpath.getText(xmlRoot_2+'/Address/StreetNo');
            //System.debug('*** quickReportResponse.s2xResponse.s2xData.IdentifyingData.CervedProspectAdditionalInformations.RegisteredHeadOfficeLocation.Address.Postcode :: ' + JSON.serialize(quickReportResponse.s2xResponse.s2xData.IdentifyingData.CervedProspectAdditionalInformations.RegisteredHeadOfficeLocation.Address.Postcode));
            /***INTERVENTO  */
            //account.ShippingPostalCode = quickReportResponse.s2xResponse.s2xData.IdentifyingData.CervedProspectAdditionalInformations.RegisteredHeadOfficeLocation.Address.Postcode;
            account.ShippingPostalCode = xpath.getText(xmlRoot_2+'/Address/Postcode');
            
            //System.debug('*** quickReportResponse.s2xResponse.s2xData.IdentifyingData.CervedProspectAdditionalInformations.RegisteredHeadOfficeLocation.Address.ProvinceCode :: ' + JSON.serialize(quickReportResponse.s2xResponse.s2xData.IdentifyingData.CervedProspectAdditionalInformations.RegisteredHeadOfficeLocation.Address.ProvinceCode));
            //account.ShippingState = quickReportResponse.s2xResponse.s2xData.IdentifyingData.CervedProspectAdditionalInformations.RegisteredHeadOfficeLocation.Address.ProvinceCode;
            account.ShippingState = xpath.getText(xmlRoot_2+'/Address/ProvinceCode');
            
            //System.debug('*** quickReportResponse.s2xResponse.s2xData.IdentifyingData.CervedProspectAdditionalInformations.RegisteredHeadOfficeLocation.Address.DescriptionCityIfNotISTAT :: ' + JSON.serialize(quickReportResponse.s2xResponse.s2xData.IdentifyingData.CervedProspectAdditionalInformations.RegisteredHeadOfficeLocation.Address.DescriptionCityIfNotISTAT));
            //account.ShippingCity = quickReportResponse.s2xResponse.s2xData.IdentifyingData.CervedProspectAdditionalInformations.RegisteredHeadOfficeLocation.Address.DescriptionCityIfNotISTAT;
            /***INTERVENTO */
            account.ShippingCity = xpath.getText(xmlRoot_2+'/Address/DescriptionCityIfNotISTAT');
            
            //System.debug('*** quickReportResponse.s2xResponse.s2xData.IdentifyingData.CervedProspectAdditionalInformations.RegisteredHeadOfficeIdentification.VATRegistrationNo :: ' + JSON.serialize(quickReportResponse.s2xResponse.s2xData.IdentifyingData.CervedProspectAdditionalInformations.RegisteredHeadOfficeIdentification.VATRegistrationNo));
            //account.Partita_IVA__c = (String.isNotBlank(quickReportResponse.s2xResponse.s2xData.IdentifyingData.CervedProspectAdditionalInformations.RegisteredHeadOfficeIdentification.VATRegistrationNo) ? quickReportResponse.s2xResponse.s2xData.IdentifyingData.CervedProspectAdditionalInformations.RegisteredHeadOfficeIdentification.VATRegistrationNo : quickReportResponse.s2xResponse.s2xData.IdentifyingData.VATNo);
            //da verificare se aggiungere un check su null
            account.Partita_IVA__c = (String.isNotBlank(xpath.getText(xmlRoot_1+'/VATRegistrationNo'))) ? xpath.getText(xmlRoot_1+'/VATRegistrationNo') : xpath.getText(xmlRoot+'/IdentifyingData/VATNo');
            
            //System.debug('*** riga 313');
            //account.Codice_Fiscale__c = quickReportResponse.s2xResponse.s2xData.IdentifyingData.CervedProspectAdditionalInformations.RegisteredHeadOfficeIdentification.TaxCode;
            account.Codice_Fiscale__c = xpath.getText(xmlRoot_1+'/TaxCode');
            
            //System.debug('*** riga 316');
            //account.dataInizioAttivita__c = DateUtils.parseFromYYYYMMDDString(quickReportResponse.s2xResponse.s2xData.CharacteristicData.ActivityStartDate);
            //da testare quando data è nulla
            account.dataInizioAttivita__c = DateUtils.parseFromYYYYMMDDString(xpath.getText(xmlRoot+'/CharacteristicData/ActivityStartDate'));
            
            //System.debug('*** riga 319');
            //account.Desc_Ateco__c = quickReportResponse.s2xResponse.s2xData.EconomicalActivity.CompanyActivity.Ateco2007List.Ateco2007[0].Code + ' - ' + xpath.findFirst('/s2xResponse/s2xData/EconomicalActivity/CompanyActivity/Ateco2007List/Ateco2007/Code').getAttributeValue('Description', null);
            String descAteco=xpath.getText(xmlRoot+'/EconomicalActivity/CompanyActivity/Ateco2007List/Ateco2007/Code');
            
            if(!String.isBlank(descAteco)) {
                String codeAteco=xpath.findFirst('/s2xResponse/s2xData/EconomicalActivity/CompanyActivity/Ateco2007List/Ateco2007/Code').getAttributeValue('Description', null);
                
                //System.debug('*** riga 322');
                //account.COD_Ateco__c = quickReportResponse.s2xResponse.s2xData.EconomicalActivity.CompanyActivity.Ateco2007List.Ateco2007[0].Code;
                account.COD_Ateco__c = xpath.getText(xmlRoot+'/EconomicalActivity/CompanyActivity/Ateco2007List/Ateco2007/Code');
                account.Desc_Ateco__c = descAteco + ' - ' + codeAteco;
            }
            
            //System.debug('*** riga 322');
            //account.COD_Ateco__c = quickReportResponse.s2xResponse.s2xData.EconomicalActivity.CompanyActivity.Ateco2007List.Ateco2007[0].Code;
            account.COD_Ateco__c = xpath.getText(xmlRoot+'/EconomicalActivity/CompanyActivity/Ateco2007List/Ateco2007/Code');
            
            update account;
            
            //System.debug('*** riga 327');
            //c.Fido__c = quickReportResponse.s2xResponse.s2xData.AssessmentSummary.RecommendedMaximumCreditLimit;
            c.Fido__c = xpath.getText(xmlRoot+'/AssessmentSummary/RecommendedMaximumCreditLimit');
            //c.DataAnalisi__c = DateUtils.parseFromYYYYMMDDString(quickReportResponse.s2xResponse.s2xData.InfocomData.DateOfUpdate);
            c.DataAnalisi__c = DateUtils.parseFromYYYYMMDDString(xpath.getText(xmlRoot+'/InfocomData/DateOfUpdate'));
            
            if( xpath.findFirst('/s2xResponse/s2xData/Payline')!=null && xpath.findFirst('/s2xResponse/s2xData/Payline').getChildElements().size() == 0)
                c.Pagamenti__c = xpath.getText('/s2xResponse/s2xData/Payline');
            else
                c.Pagamenti__c = xpath.getText('/s2xResponse/s2xData/Payline/Score');
            
            update c;
            
            if (xpath.findFirst('/s2xResponse/s2xData/AssessmentSummary/CervedGroupRating') != null) {
                Integer cervedRating = Integer.valueOf(xpath.findFirst('/s2xResponse/s2xData/AssessmentSummary/CervedGroupRating').getAttributeValue('Code', null));
                
                if (cervedRating >= 1 && cervedRating <= 10) {
                    datiReport.rating = 'CGS_' + String.valueOf(cervedRating);
                }
            }
            else if (xpath.findFirst('/s2xResponse/s2xData/AssessmentSummary/Rating') != null) {
                String rating = xpath.findFirst('/s2xResponse/s2xData/AssessmentSummary/Rating').getAttributeValue('Code', null);
                system.debug('--RATING '+rating+' node '+xpath.findFirst('/s2xResponse/s2xData/AssessmentSummary/Rating')!=null);
                datiReport.rating = rating;
            }
            
            //String protesti = quickReportResponse.s2xResponse.s2xData.ProtestsAndPrejudicialEvents.Protests.FlagAlarm;
            String protesti = xpath.getText(xmlRoot+'/ProtestsAndPrejudicialEvents/Protests/FlagAlarm');
            //String pregiudizievoli = quickReportResponse.s2xResponse.s2xData.ProtestsAndPrejudicialEvents.PrejudicialEvents.FlagAlarm;
            String pregiudizievoli = xpath.getText(xmlRoot+'/ProtestsAndPrejudicialEvents/PrejudicialEvents/FlagAlarm');
            
            datiReport.protesti = ('1'.equals(protesti)) ? 'S' : 'N'; 
            datiReport.pregiudizievoli = ('1'.equals(pregiudizievoli)) ? 'S' : 'N'; 
            
            Contact contactDiRiferimento = SFAConvenzionamento.getContactDiRiferimentoDealer(dealerProspectId);
            //contactDiRiferimento.Email = quickReportResponse.s2xResponse.s2xData.IdentifyingData.Email;
            contactDiRiferimento.Email = xpath.getText(xmlRoot+'/IdentifyingData/Email');
            
            //Map<String, QuickReportResponse.IndividualList> mapCFtoIL = new Map<String, QuickReportResponse.IndividualList>();
            
            Integer i = 0;
            
            if (quickReportResponse.s2xResponse.s2xData!=null && 
                quickReportResponse.s2xResponse.s2xData.Representatives !=null && 
                quickReportResponse.s2xResponse.s2xData.Representatives.IndividualList != null) {
                    
                    for (QuickReportResponse.Individual il : quickReportResponse.s2xResponse.s2xData.Representatives.IndividualList.Individual) {
                        Contact contact = new Contact();
                        contact.AccountId = dealerProspectId;
                        //PersonData is required
                        contact.LastName = il.PersonalData.LastName;
                        contact.FirstName = il.PersonalData.FirstName;
                        contact.Codice_Fiscale__c = il.PersonalData.TaxCode;
                        if(il.PersonalData.Birth!=null){
                            contact.Birthdate = DateUtils.parseFromYYYYMMDDString(il.PersonalData.Birth.BirthDate);
                            contact.Provincia_Nascita__c = il.PersonalData.Birth.BirthplaceProvinceCode;
                            contact.Luogo_Nascita__c = il.PersonalData.Birth.City;
                        }
                        contact.Sesso__c = il.PersonalData.Sex;
                        
                        if ( 'DIN'.equals(account.Forma_Giuridica__c) && i == 0 ) {
                            contactDiRiferimento.LastName = il.PersonalData.LastName;
                            contactDiRiferimento.FirstName = il.PersonalData.FirstName;
                            contactDiRiferimento.Codice_Fiscale__c = il.PersonalData.TaxCode;
                            if(il.PersonalData.Birth!=null){
                                contactDiRiferimento.Birthdate = DateUtils.parseFromYYYYMMDDString(il.PersonalData.Birth.BirthDate);
                                contactDiRiferimento.Provincia_Nascita__c = il.PersonalData.Birth.BirthplaceProvinceCode;
                                contactDiRiferimento.Luogo_Nascita__c = il.PersonalData.Birth.City;
                            }
                            contactDiRiferimento.Sesso__c = il.PersonalData.Sex;
                        }
                        
                        contact.Tipo_Anagrafica__c = 'F';
                        //contact.Email = il.PersonalData.FirstName;
                        //System.debug('*** il.PersonalData :: ' + JSON.serialize(il.PersonalData));
                        //System.debug('*** il.PersonalData.Domicile :: ' + JSON.serialize(il.PersonalData.Domicile));
                        
                        if (il.PersonalData.TaxDomicile != null) {
                            
                            if (String.isNotBlank(il.PersonalData.TaxDomicile.ForeignCountryCode)) {
                                contact.MailingStreet = il.PersonalData.TaxDomicile.StreetName + ' ' + il.PersonalData.TaxDomicile.StreetNo;
                                contact.MailingCountry = il.PersonalData.TaxDomicile.ForeignCountryCode;
                            }
                            else {
                                contact.MailingStreet = il.PersonalData.TaxDomicile.ToponymCode + ' ' + il.PersonalData.TaxDomicile.StreetName + ' ' + il.PersonalData.TaxDomicile.StreetNo;
                            }
                            
                            contact.MailingPostalCode = il.PersonalData.TaxDomicile.Postcode;
                            contact.MailingState = il.PersonalData.TaxDomicile.ProvinceCode;
                            contact.MailingCity = il.PersonalData.TaxDomicile.City;
                        }
                        
                        else if (il.PersonalData.Domicile != null) {
                            
                            if (String.isNotBlank(il.PersonalData.Domicile.ForeignCountryCode)) {
                                contact.MailingStreet = il.PersonalData.Domicile.StreetName + ' ' + il.PersonalData.Domicile.StreetNo;
                                contact.MailingCountry = il.PersonalData.Domicile.ForeignCountryCode;
                            }
                            else {
                                contact.MailingStreet = il.PersonalData.Domicile.ToponymCode + ' ' + il.PersonalData.Domicile.StreetName + ' ' + il.PersonalData.Domicile.StreetNo;
                            }
                            
                            contact.MailingPostalCode = il.PersonalData.Domicile.Postcode;
                            contact.MailingState = il.PersonalData.Domicile.ProvinceCode;
                            contact.MailingCity = il.PersonalData.Domicile.City;
                        }
                        
                        //lstContactIL.add(contact);
                        
                        System.debug('*** riga 393');
                        //mapCFtoIL.put(il.PersonalData.TaxCode, il);
                        mapCFtoContact.put(contact.Codice_Fiscale__c, contact);
                        
                        System.debug('*** riga 397');
                        String role = xpath.getText('/s2xResponse/s2xData/Representatives/IndividualList/Individual/OfficesAndAuthority/OfficesInGroup/OfficeHeldList/Office/Code');
                        System.debug('*** riga 399');
                        mapCFToRole.put(contact.Codice_Fiscale__c, role);
                        i++;
                    }
                    
                }
            
            update contactDiRiferimento; 
            
            system.debug('*** Valuto shareholders');
            
            if (quickReportResponse.s2xResponse.s2xData !=null && 
                quickReportResponse.s2xResponse.s2xData.Shareholders!=null && 
                quickReportResponse.s2xResponse.s2xData.Shareholders.ShareholdersList != null) {
                    for (QuickReportResponse.Shareholder sl : quickReportResponse.s2xResponse.s2xData.Shareholders.ShareholdersList.Shareholder ){
                        Contact contact = new Contact();
                        contact.AccountId = dealerProspectId;
                        contact.LastName = sl.LastName != null ? sl.LastName : sl.Name;
                        contact.FirstName = sl.FirstName;
                        contact.Codice_Fiscale__c = sl.TaxCode;
                        
                        if(sl.LastName != null && sl.FirstName != null) {
                            
                            system.debug('***  Elaborazione Persona fisica');
                            string VerifIData = xpath.getText('/s2xResponse/s2xData/Shareholders/ShareholdersList/Shareholder/OtherIdentificationData/IdentificationData');
                            if(VerifIData != null && VerifIData != ''){
                                contact.Birthdate = DateUtils.parseFromYYYYMMDDString(xpath.getText('/s2xResponse/s2xData/Shareholders/ShareholdersList/Shareholder/OtherIdentificationData/IdentificationData/BirthDate'));
                                contact.Luogo_Nascita__c = xpath.getText('/s2xResponse/s2xData/Shareholders/ShareholdersList/Shareholder/OtherIdentificationData/IdentificationData/BirthPlace');
                                if(xpath.findFirst('/s2xResponse/s2xData/Shareholders/ShareholdersList/Shareholder/OtherIdentificationData/IdentificationData/BirthProvince')!=null)
                                    contact.Provincia_Nascita__c = xpath.findFirst('/s2xResponse/s2xData/Shareholders/ShareholdersList/Shareholder/OtherIdentificationData/IdentificationData/BirthProvince').getAttributeValue('Code', null);
                                contact.Tipo_Anagrafica__c = 'F';
                                contact.Sesso__c = SFAConvenzionamentoNewDealProspctCtrller.getSessoFromCodiceFiscale(sl.TaxCode);
                            }
                            
                            
                        }
                        
                        else {
                            system.debug('***  Elaborazione Persona giuridica');
                            contact.DataInizioAttivita__c = DateUtils.parseFromYYYYMMDDString(xpath.getText('/s2xResponse/s2xData/Shareholders/ShareholdersList/Shareholder/Company/ActivityStatus/Date'));
                            contact.RagioneSociale__c = sl.Name;
                            contact.Partita_IVA__c = sl.TaxCode;
                            contact.Tipo_Anagrafica__c = 'G';
                        }
                        
                        //lstContactSL.add(contact);
                        
                        //mapCFtoSL.put(sl.Shareholder.TaxCode, sl);
                        
                        mapCFtoContact.put(contact.Codice_Fiscale__c, contact);
                        
                        mapCFToRole.put(contact.Codice_Fiscale__c, RUOLO_SOC);
                    }
                }
            
            /* listaCollegati è la lista definitiva di collegati presi dal QRP */
            List<Contact> listaCollegati = mapCFtoContact.values();
            
            insert listaCollegati;
            
            List<Contact> listaCollegatiConId = new List<Contact>();
            
            System.debug('*** listaCollegati :: ' + JSON.serialize(listaCollegati));
            
            List<Contact> listaCollegatiDaServizioEsistenti = new List<Contact>();
            
            Set<String> setCodiceFiscale = new Set<String>();
            setCodiceFiscale = mapCFtoContact.keySet();
            List<String> lstCodiceFiscale = new List<String>();
            lstCodiceFiscale.addAll(setCodiceFiscale);
            
            System.debug('*** lstCodiceFiscale :: ' + JSON.serialize(lstCodiceFiscale));
            
            List<String> lstCFCollegatiDaAggiornare = new List<String>();
            
            Map<String, String> mapCFToId = new Map<String, String>();
            
            listaCollegatiDaServizioEsistenti = [SELECT Id, Codice_Fiscale__c FROM Contact WHERE Codice_Fiscale__c IN :lstCodiceFiscale];
            System.debug('*** listaCollegatiDaServizioEsistenti :: ' + JSON.serialize(listaCollegatiDaServizioEsistenti));
            
            for (Contact collegato : listaCollegatiDaServizioEsistenti) {
                lstCFCollegatiDaAggiornare.add(collegato.Codice_Fiscale__c);
                mapCFToId.put(collegato.Codice_Fiscale__c, collegato.Id);
            }
            
            System.debug('*** lstCFCollegatiDaAggiornare :: ' + JSON.serialize(lstCFCollegatiDaAggiornare));
            System.debug('*** mapCFToId :: ' + JSON.serialize(mapCFToId));
            
            for (Contact collegato : listaCollegati) {
                if (lstCFCollegatiDaAggiornare.contains(collegato.Codice_Fiscale__c))
                    collegato.Id = mapCFToId.get(collegato.Codice_Fiscale__c);
                listaCollegatiConId.add(collegato);
            }
            
            System.debug('*** listaCollegatiConId :: ' + JSON.serialize(listaCollegatiConId));
            upsert listaCollegatiConId;
            
            List<AccountContactRelation> listACR = 
                [SELECT Id, AccountId, ContactId, Contact.Codice_Fiscale__c, Roles 
                 FROM AccountContactRelation
                 WHERE AccountId = :dealerProspectId AND IsDeleted = false AND isCollegatoEliminato__c = false];
            
            for (AccountContactRelation acr : listACR) {
                acr.Roles = mapCFToRole.get(acr.Contact.Codice_Fiscale__c);
            }
            
            update listACR;
            
            return datiReport;
        }
        @AuraEnabled
        public static QuickReportResponseAndXPath getQuickReportResponseFromFixedXML(Blob blobXML){
            
            /** 
Scopo di questo metodo è prendere in ingresso l'XML di Cerved, toglierne i nodi che, oltre a non essere di interesse 
per il processo, si sono dimostrati problematici per il parsing XML di Salesforce. Infine tornare l'oggetto parserizzato al chiamante.
lstXpathDaEliminare contiene la lista dei nodi che, prima ancora della conversione da XML a JSON, vengono eliminati dall'XML.
E' stato aggiunto anche ShareholdersList perché, nonostante sia d'interesse per il processo, in un caso, era presente come tag
autochiudente e quindi questo faceva rompere il parsing. Per precauzione, è stato aggiunto anche un controllo su IndividualList.

Inoltre, se si dovesse verificare un'eccezione System.JSONException: Illegal value for primitive durante la conversione XML->JSON, bisogna accertarsi che non ci sono altri tag con lo stesso nome e nello stesso XPATH che abbiano struttura diversa. Si può risolvere andando a limitare al minimo indispensabile (quelli strettamente sufficienti per mappare i nodi di interesse) le classi e i rispettivi attributi che modellano il QRP.
*/
            
            // Blob blobXML = EncodingUtil.base64decode(base64strXML);
            HttpRequest tmp = new HttpRequest();
            tmp.setBodyAsBlob(blobXML);
            String strXML = tmp.getBody();
            
            Dom.Document doc = new DOM.Document();
            doc.load(strXML);
            XPath xpath = new XPath(doc);
            System.debug('*** strXMLPre Eliminzazione Path :: ' + strXML);
            QuickReportResponseAndXPath qrpandxp = new QuickReportResponseAndXPath();
            
            List<String> lstXpathDaEliminare = new List<String>();
            if(xpath.findFirst('/s2xResponse/s2xData/Budgets')!=null)
                lstXpathDaEliminare.add('/s2xResponse/s2xData/Budgets');
            if(xpath.findFirst('/s2xResponse/s2xData/Shareholders/ShareholdersList')!=null &&  xpath.findFirst('/s2xResponse/s2xData/Shareholders/ShareholdersList').getChildElements().size() == 0)
                lstXpathDaEliminare.add('/s2xResponse/s2xData/Shareholders/ShareholdersList');
            if(xpath.findFirst('/s2xResponse/s2xData/Representatives/IndividualList')!=null && xpath.findFirst('/s2xResponse/s2xData/Representatives/IndividualList').getChildElements().size() == 0)
                lstXpathDaEliminare.add('/s2xResponse/s2xData/Representatives/IndividualList');
            
            for (String xpathDaEliminare : lstXpathDaEliminare) {
                Dom.XmlNode child = xpath.findFirst(xpathDaEliminare);            
                Boolean remove = child.getParent().removeChild(child);
            }
            
            strXML = doc.toXmlString();
            
            System.debug('*** strXML :: ' + strXML);
            
            Set<String> deSerializeNodesAsArray = new Set<String>();
            deSerializeNodesAsArray.add('Individual');
            deSerializeNodesAsArray.add('Shareholder');
            deSerializeNodesAsArray.add('Ateco2007');
            
            XMLSerializer xmls = new XMLSerializer();
            QuickReportResponse quickReportResponse = new QuickReportResponse();
            
            System.debug('*** prima di xmls.deserialize()');
            quickReportResponse = (QuickReportResponse) xmls.deserialize(strXML, QuickReportResponse.class, deSerializeNodesAsArray);
            System.debug('*** dopo xmls.deserialize()'+ quickReportResponse);
            //System.debug('*** quickReportResponse :: ' + JSON.serialize(quickReportResponse));
            
            qrpandxp.quickReportResponse = quickReportResponse;
            qrpandxp.xpath = xpath;
            
            return qrpandxp;
        }
        
        public class CheckPresenzaReportResult {
            @AuraEnabled public String step {get;set;} 
            @AuraEnabled public String reportUrl {get;set;}
            @AuraEnabled public Integer errorCode {get;set;}
            @AuraEnabled public String errorMessage {get;set;}
        }
        
        public class DatiReportCervedDaQuickReport {
            @AuraEnabled public String rating {get;set;}
            @AuraEnabled public String protesti {get;set;} 
            @AuraEnabled public String pregiudizievoli {get;set;}
        }
        public class QuickReportResponseAndXPath {
            @AuraEnabled public QuickReportResponse QuickReportResponse {get;set;}
            @AuraEnabled public XPath xpath {get;set;} 
        }
    }