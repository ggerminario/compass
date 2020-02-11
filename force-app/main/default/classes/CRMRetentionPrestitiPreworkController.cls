public without sharing class CRMRetentionPrestitiPreworkController 
{
    @AuraEnabled
    public static wrapInit doHandlerInit(String customerId)
    {
       	Account a = AccountUtils.getAccountFromId(customerId);
        System.debug('°°°°°°°°°' + a);
        OCSRecuperaDatiRetentionResponse res = OCSRecuperaDatiRetentionInvoker.invoke(a.getCodice_Cliente__c, 'CO', '');
        String descRetention = '';
        String tempPratica = '';
        List<String[]> lPratiche = new List<String[]>();
        Map<String,String> mapPratiche = new Map<String,String>();
        List<String> lPraticheSi = new List<String>();
        List<String> lPraticheNo = new List<String>();
        List<OCSRecuperaDatiRetentionResponse.PraticheResponse> listResponse = res.recuperaDatiRetentionResponse.elencoPratiche;
        List<PraticheRetention> listPraticheRetention = new List<PraticheRetention>();
        boolean retentionNonPossibile = false;
        List<Account_Retention__c> listAR = [SELECT Id, Esito__c, Valore__c, Partner__c, Prt1__c, Prt2__c, Prt3__c, Prt4__c, Prt5__c, Prt6__c, Prt7__c, Prt8__c, Offerta__c, Customer__c FROM Account_Retention__c where CIP__c = :a.getCodice_Cliente__c];
        Account_Retention__c ar = (listAR.isEmpty() ? null : listAR.get(0));
        if(ar != null)
        {
            for(Integer i = 1; i <= 8 ; i++)
            {
                if(ar.get('Prt' + i + '__c') != null && !''.equals(ar.get('Prt' + i + '__c')))
                {
                    String tempString = (String)ar.get('Prt' + i + '__c');
                    String[] tempStringVector = tempString.split('\\|');
                    lPratiche.add(tempStringVector);
                    mapPratiche.put(tempStringVector[1],tempStringVector[0]);
                }
            }
            if(String.isNotBlank(ar.Esito__c) && String.isNotBlank(ar.Valore__c))
            {
                if(ar.Partner__c)
                {
                    for(String[] pr : lPratiche)
                    {
                        if(pr[0].equalsIgnoreCase('SI'))
                        {
                            lPraticheSi.add(pr[1]); 
                            system.debug('holllaaaaa');
                        }
                        else
                        {
                            lPraticheNo.add(pr[1]);
                        }
                    }
                    if(lPraticheSi.size() >= listResponse.size())
                    {
                        descRetention = CRMRetentionUtil.SOLO_CONTRATTI_ATTIVI;		
                        retentionNonPossibile = true;
                    }
                    else
                    {
                        descRetention = CRMRetentionUtil.CONTRATTI_ATTIVI;
                    }
                }
            }
            else
            {
                descRetention = CRMRetentionUtil.INFORMAZIONI_MANCANTI;
                RetentionNonPossibile = true;
            }
        }
        else
        {
            descRetention = CRMRetentionUtil.INFORMAZIONI_MANCANTI;
            RetentionNonPossibile = true;
        }
        if(!RetentionNonPossibile)
        {
            for(OCSRecuperaDatiRetentionResponse.PraticheResponse l : listResponse)
            {
                PraticheRetention prt = new PraticheRetention();
                prt.tipoPratica = l.tipoPratica;
                prt.numPratica = l.numPratica;
                prt.statoPratica = l.statoPratica;
                prt.attributoPratica = l.attributoPratica;
                prt.dataPrimaScadenza = l.dataPrimaScadenza;
                prt.dataUltimaScadenza = l.dataUltimaScadenza;
                prt.codProdotto = l.codProdotto;
                prt.desProdotto = l.desProdotto;
                prt.modalitaPagamento = l.modalitaPagamento;
                prt.importoFinanziato = l.importoFinanziato;
                prt.montante = l.montante;
                prt.saldoPratica = l.saldoPratica;
                prt.dataEstinzione = l.dataEstinzione;
                prt.dataLiquidazione = l.dataLiquidazione;
                prt.codCliente = l.codCliente;
                prt.agente = l.agente;
                prt.partner = (mapPratiche.get(l.numPratica) != null) ? mapPratiche.get(l.numPratica) : 'NO';
                prt.source = 'M';
                listPraticheRetention.add(prt);
                
            }
        }
        wrapInit wrInit = new wrapInit();
        wrInit.retentionNonPossibile = retentionNonPossibile;
        wrInit.retentionDesc = descRetention;
        wrInit.listaRetention = listPraticheRetention;
        wrInit.arrayLength = listPraticheRetention.size();
        wrInit.esitoCliente =  ar != null ? ar.Esito__c : '';
        wrInit.valoreCliente = ar != null ? ar.Valore__c : '';
        wrInit.customerId =  a.id;
        wrInit.customerOCSCode = a.OCS_External_Id__c;
        wrInit.customerEmail = String.isNotBlank(a.personEmail) ? a.PersonEmail : '';
        wrInit.customerTelefono = String.isNotBlank(a.PersonMobilePhone) ? a.PersonMobilePhone : '';
        wrInit.esitoDescriptionCustomer = CRMRetentionUtil.MAP_ESITO_DESCRIPTION.get(ar != null ? ar.Esito__c : '');
        wrInit.redirectComponentName = XCSCompassConstants.POSTVENDITA_LAUNCHER_COMPONENT;
        wrInit.redirectPostvenditaId = XCSCompassConstants.POSTVENDITA_ID_ESTINZIONE_ANTICIPATA;
        
        return wrInit; 
    }
    @AuraEnabled
    public static wrapObj completaAttivita(String noteUtente,String esitoCliente, String valoreCliente,String customerId,String customerEmail,String customerCellulare,boolean flagPrivacy,String fasciaOraria,List<CRMRetentionPrestitiAction.PraticheRetention> listRetention)
    {
        boolean res = true;
        String messToast = '';
        boolean retentionNonPossibile = false;
        System.debug('*************' + listRetention);
        try{        
            
            if(String.isBlank(customerEmail))
                customerEmail = '';
            if(String.isBlank(customerCellulare))
                customerCellulare = '';
            boolean isAccountToUpdate = false;
            String notePratiche = '';
            String note = '';
            List<String> listNoteValue = new List<String>();
            List<String> listOCSNoteValue = new List<String>();
            //RecordType = 
            Account cliente = AccountUtils.getAccountFromId(customerId);
            if(String.isBlank(cliente.PersonEmail))
                cliente.PersonEmail = '';
            if(String.isBlank(cliente.PersonMobilePhone))
                cliente.PersonMobilePhone = '';
            List<CRM_Retention__c> listRetentionToInsert = new List<CRM_Retention__c>();
            Account a = new Account(id = customerId);
            Case c = new Case();
            if(listRetention.size() > 0 )
            {
                if(flagPrivacy != null)
                {
                    if(cliente.Privacy_SMS__pc != flagPrivacy)
                    {
                        a.Privacy_SMS__pc = flagPrivacy;
                        isAccountToUpdate = true;
                    }
                }
                else
                {
                    messToast += CaseUtils.PRIVACY_NON_SELEZIONATA;
                    res = false;
                }
                if(!customerEmail.equalsIgnoreCase(cliente.PersonEmail))
                {
                    if(ValidationUtils.isEmailValida(customerEmail))
                    {
                        a.PersonEmail = customerEmail;
                        isAccountToUpdate = true;
                    }
                    else
                    {
                        messToast += CRMRetentionUtil.EMAILNONCONFORME;
                        res = false;
                    }
                }
                if(!customerCellulare.equalsIgnoreCase(cliente.PersonMobilePhone))
                {
                    if(CRMRetentionUtil.isCellBeginWithThree(customerCellulare))
                    {
                        if(CRMRetentionUtil.isCellLengthRight(customerCellulare))
                        {
                            a.PersonMobilePhone = customerCellulare;
                        	isAccountToUpdate = true;
                        }
                        else
                        {
                            messToast += CRMRetentionUtil.TELEFONO_NON_CONFORME_LUNGHEZZA;
                            res = false;
                        }
                    }
                    else
                    {
                        messToast += CRMRetentionUtil.TELEFONO_NON_CONFORMA_INIZIALE;
                        res = false;
                    }
                    
                    
                    
                }
                if(String.isNotBlank(fasciaOraria))
                {
                    String[] fascia = fasciaOraria.split('\\-');
                    c.CC_FasciaContattoDalle__c = integer.valueOf(fascia[0]);
                    c.CC_FasciaContattoAlle__c = integer.valueOf(fascia[1]);
                }
                else
                {
                    res = false;
                    messToast += CRMRetentionUtil.FASCIANONSELEZIONATA;
                }
            }
            else
            {
                res = false;
                messToast = CRMRetentionUtil.NESSUNA_PRATICA_TROVATA;
            }
            if(res)
            {
                c.TentativoNum__c = 0;
                c.Type = XCSCompassConstants.CASETYPECRM;
                c.Accountid = cliente.id;
                c.product__c = Product2Util.getProductFromExternalId(Product2Util.RETENTIONPRODUCTCODE).id;
                c.Categoria_Riferimento__r = XCS_CategoriaUtil.getCategoryForExternalId(XCS_CategoriaUtil.BACKOFFICEINBOUNDCATEGORYCODE);
                c.Disposition__r = XCS_DispositionUtils.getInstanceWithExternalID(XCS_DispositionUtils.RETENTION_INSERITA); 
                c.TentativoNum__c = 0;   
                c.recordtypeid = RecordtypeUtil.getCaseRecordType(RecordtypeUtil.RETENTIONCLIENTE);
                if('BAD'.equalsIgnoreCase(esitoCliente))
                {
                    c.Subject = CRMRetentionUtil.CASE_RETENTION_PRESTITI_BAD_SUBJECT;
                    c.ProcessType__c = CRMRetentionUtil.CASE_RETENTION_PRESTITI_PROCESSTYPE_RETENTIONBAD;
                    c.ownerId = GroupUtils.getQueue(CRMRetentionUtil.QUEUE_RETENTION_EA_BAD_NAME).id;
                }	
                else
                {
                    c.Subject = CRMRetentionUtil.CASE_RETENTION_PRESTITI_SUBJECT;
                    c.ProcessType__c = CRMRetentionUtil.CASE_RETENTION_PRESTITI_PROCESSTYPE_RETENTIONOK;
                    c.ownerId = GroupUtils.getQueue(CRMRetentionUtil.QUEUE_RETENTION_EA_NAME).id;
                }
                For(CRMRetentionPrestitiAction.PraticheRetention obj : listRetention)
                {
                    if(! 'SI'.equalsIgnoreCase(obj.partner))
                    {
                        listRetentionToInsert.add(
                            new CRM_Retention__c(
                                loanType__c = obj.tipoPratica,
                                loanNumber__c = obj.numPratica,
                                loanStatus__c = obj.statoPratica,
                                loanStatusAttribute__c = obj.attributoPratica,
                                firstDueDate__c = (String.isNotBlank(obj.dataPrimaScadenza) && obj.dataPrimaScadenza.length() == 8) ? (date.valueOf(obj.dataPrimaScadenza.substring(0,4) + '-' + obj.dataPrimaScadenza.substring(4,6) + '-' + obj.dataPrimaScadenza.substring(6,8))) : null,
                                lastDueDate__c = (String.isNotBlank(obj.dataUltimaScadenza) && obj.dataUltimaScadenza.length() == 8) ? (date.valueOf(obj.dataUltimaScadenza.substring(0,4) + '-' + obj.dataUltimaScadenza.substring(4,6) + '-' + obj.dataUltimaScadenza.substring(6,8))) : null,
                                productCode__c = obj.codProdotto,
                                productDescription__c = obj.desProdotto,
                                repaymentMode__c = obj.modalitaPagamento,
                                financedAmount__c = String.isNotBlank(obj.importoFinanziato) ? Integer.valueOf(obj.importoFinanziato) : null,
                                totalAmount__c = Integer.valueOf(obj.montante),
                                liquidDate__c = (String.isNotBlank(obj.dataLiquidazione) && obj.dataLiquidazione.length() == 8) ? (date.valueOf(obj.dataLiquidazione.substring(0,4) + '-' + obj.dataLiquidazione.substring(4,6) + '-' + obj.dataLiquidazione.substring(6,8))) : null,
                                ExtinctionDate__c = (String.isNotBlank(obj.dataEstinzione) && obj.dataEstinzione.length() == 8) ? (date.valueOf(obj.dataEstinzione.substring(0,4) + '-' + obj.dataEstinzione.substring(4,6) + '-' + obj.dataEstinzione.substring(6,8))) : null,
                                balance__c = obj.saldoPratica,    
                                selected__c = true,
                                retentionValue__c = valoreCliente,
                                Action__c = esitoCliente,
                                type__c= CRMRetentionUtil.RETENTIONTYPEREQUESTED,
                                Customer__c = customerId,
                                Source__c = obj.source
                            )); 
                        notePratiche += obj.numPratica + ',';
                    }
                    else
                    {
                        retentionNonPossibile = true;
                        messToast = CRMRetentionUtil.PRATICA_PARTNER;
                    }
                }
            }
            if(res && !retentionNonPossibile)
            {
                System.debug('#########' + notePratiche);
                String roleUserName = [select name from UserRole where id = :userInfo.getUserRoleId()].name;
                String aliasUser = [SELECT Alias FROM User Where Id = :userinfo.getUserId()].Alias;
                XCS_Disposition__c dispo = XCS_DispositionUtils.findDispositionByExternalID(XCS_DispositionUtils.RETENTION_INSERITA);
                listNoteValue.add(roleUserName);
                listNoteValue.add(aliasUser);
                listNoteValue.add(XCS_DispositionUtils.getParentHierarchy('', dispo ) + dispo.Name);
                listNoteValue.add(esitoCliente);
                listNoteValue.add(valoreCliente);
                listNoteValue.add(String.isNotBlank(notePratiche) ? notePratiche.substring(0, notePratiche.length() - 2) : '' );
                listNoteValue.add(flagPrivacy ? 'Si' : 'No');
                listNoteValue.add(fasciaOraria);
                note = XCS_TemplateUtils.buildTemplateByName(CRMRetentionUtil.NOTE_RETENTION_PRESTITI_PREWORK,listNoteValue);
                insert c;
                listOCSNoteValue.add(c.CaseNumber);
                listOCSNoteValue.add(note);
                listOCSNoteValue.add(noteUtente == null ? '' : noteUtente);
                for(CRM_Retention__c r : listRetentionToInsert)
                {
                    r.Case__c = c.id;
                }
                insert listRetentionToInsert;
                XCSNoteUtils.postANote(c.id,XCSNoteUtils.SYSTEM_NOTE_TITLE,note);
                if(String.isNotBlank(noteUtente))
                {
                    XCSNoteUtils.postANote(c.id,XCSNoteUtils.USER_NOTE_TITLE,noteUtente);    
                }
                OCSGestioneNoteInvoker.filtraNote(aliasUser,cliente.getCodice_Cliente__c ,'' ,'' , 'A', 'P', XCS_TemplateUtils.buildTemplateByName(CRMRetentionUtil.NOTE_RETENTION_PRESTITI_RICHIESTA_CRM,listOCSNoteValue)); 
                messToast = XCSCompassConstants.SUCCESSO_CHIUDERE_CHIAMATA;
                
            }
        }catch(exception e)
        {
            res = false;
            messToast = CRMRetentionUtil.ERRORE_TECNICO;
            System.debug('*******' + e);
        }
        
        return new wrapObj(res,retentionNonPossibile,messToast);
    }

    public class wrapObj
    {
        @AuraEnabled
        boolean res {get; set;}
        @AuraEnabled
        boolean retentionNonPossibile {get; set;}
        @AuraEnabled
        String messToast {get; set;}
        public wrapObj(boolean res, boolean retentionNonPossibile, String messToast)
        {
            this.res = res;
            this.retentionNonPossibile = retentionNonPossibile;
            this.messToast = messToast;
        }
    }
 
    public class PraticheRetention
    {
        @AuraEnabled
        public String tipoPratica {get; set;}
        @AuraEnabled
        public String numPratica {get; set;}
        @AuraEnabled
        public String statoPratica {get; set;}
        @AuraEnabled
        public String attributoPratica {get; set;}
        @AuraEnabled
        public String dataPrimaScadenza {get; set;}
        @AuraEnabled
        public String dataUltimaScadenza {get; set;}
        @AuraEnabled
        public String codProdotto {get; set;}
        @AuraEnabled
        public String desProdotto {get; set;}
        @AuraEnabled
        public String modalitaPagamento {get; set;}
        @AuraEnabled
        public String importoFinanziato {get; set;}
        @AuraEnabled
        public String montante {get; set;}
        @AuraEnabled
        public String saldoPratica {get; set;}
        @AuraEnabled
        public String dataEstinzione {get; set;}
        @AuraEnabled
        public String dataLiquidazione {get; set;}
        @AuraEnabled
        public String codCliente {get; set;}
        @AuraEnabled
        public String agente {get; set;}
        @AuraEnabled
        public String partner {get; set;}
        @AuraEnabled
        public String source {get;set;}
    }
 
    public class PraticheResponseWrap
    {
        @AuraEnabled
        public String listRetention {get; set;} 
    }

    public class wrapInit
    {
        @AuraEnabled
        public Boolean retentionNonPossibile {get; set;}
        @AuraEnabled
        public String retentionDesc {get; set;}
        @AuraEnabled
        public List<PraticheRetention> listaRetention {get; set;}
        @AuraEnabled
        public Integer arrayLength {get; set;}
        @AuraEnabled
        public  String esitoCliente {get; set;}
        @AuraEnabled
        public  String valoreCliente {get; set;}
        @AuraEnabled
        public  String customerId {get; set;}
        @AuraEnabled
        public  String customerOCSCode {get; set;}
        @AuraEnabled
        public String customerEmail {get; set;}
        @AuraEnabled
        public String customerTelefono {get; set;}
        @AuraEnabled
        public String esitoDescriptionCustomer {get; set;}
        @AuraEnabled
        public String redirectComponentName {get; set;}
        @AuraEnabled
        public String redirectPostvenditaId {get; set;}
    }
}