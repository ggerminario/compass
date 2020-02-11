public class CRMRetentionPrestitiController 
{
    @AuraEnabled
    public static wrapInit doInit(String caseId)
    {     	  
        return new wrapInit(CaseUtils.caseGenericQueryById(CaseUtils.SELECT_PROCESSTYPE,caseId),CRMRetentionUtil.getRetentionRequestedByCaseId(caseId)); 
    }
    @AuraEnabled
    public static void insertContentNote(String note,String recordId)
    {
        Case c = CaseUtils.caseGenericQueryById(Caseutils.SELECT_ACCOUNT_FIELD,recordId);
        String roleUserName = [select name from UserRole where id = :userInfo.getUserRoleId()].name;
        String aliasUser = [SELECT Alias FROM User Where Id = :userinfo.getUserId()].Alias;
        XCS_Disposition__c dispo = XCS_DispositionUtils.findDispositionByExternalID(c.Disposition__r.External_Id__c);
        List<String> listToNote = New List<String>();
        listToNote.add(c.caseNumber);
        listToNote.add(roleUserName + ' - ' + aliasUser + ' - ' + XCS_DispositionUtils.getParentHierarchy('', dispo ) + dispo.Name);
        listToNote.add(c.TentativoNum__c + '');
        String noteToInsert = XCS_TemplateUtils.buildTemplate(note,listToNote);
        ContentNote cNote = XCSNoteUtils.createCaseNote(XCSNoteUtils.SYSTEM_NOTE_TITLE,noteToInsert);
        insert cNote;
        ContentDocumentLink cDL = XCSNoteUtils.createDocumentLink(cNote.id,c.id);
        insert cDL;
        System.debug('NOTE DA INSERIRE RET CARTE');
        OCSGestioneNoteInvoker.filtraNote('',c.account.getCodice_Cliente__c,'','','A','P',noteToInsert);
    }
    @AuraEnabled
    public static wrapResponse completaAction(String caseId,List<CRM_Retention__c> listaRetention,String noteUtente,String tassoSelezionato,String obiezioneSelezionata)
    {
        System.debug('******' + obiezioneSelezionata);
        Case c = CaseUtils.caseGenericQueryById(CRMRetentionUtil.QUERY_CASE_ACCOUNTCODE, caseId);
        List<String> idDispositionsToQuery = new List<String>();
        String dispNonInteressato = XCS_DispositionUtils.findDispositionByExternalID(XCS_DispositionUtils.NON_INTERESSATO_ALLA_PROPOSTA).id;
        for(CRM_Retention__c rm : listaRetention)
        {
            if(String.isNotBlank(rm.Disposition__c))
               {
                   idDispositionsToQuery.add(rm.Disposition__c);
               }
        }
        Map<String,XCS_Disposition__c> mapDisposition = New Map<String,XCS_Disposition__c>(XCS_DispositionUtils.getListDispositionById(idDispositionsToQuery));
        boolean res = true;
        String messToast = '';
        String notaSistema = '';
        String notaOCS = '';
        List<CRM_Retention__c> listRetentionToCreate = new List<CRM_Retention__c>();
        String notaPraticaBody = XCS_TemplateUtils.getBody(CRMRetentionUtil.NOTE_PRATICA_ESITO);
        String notaPratica = '';
        OCSRecuperaDatiPostvenditaResponse resp = OCSRecuperaDatiPostvenditaInvoker.callRecDatiPV(c.account.getCodice_Cliente__c);
        System.debug('**************************************' + listaRetention);
        for(CRM_Retention__c r : listaRetention)
        {
            if(String.isNotBlank(r.Disposition__c))
            {
                notaPratica = '\n' + XCS_templateUtils.buildTemplate(notaPraticaBody,new List<String>{r.LoanNumber__c,mapDisposition.get(r.Disposition__c).Name});
            }
            else
            {
                res = false;
            }
        }
        if(res)
        {
            System.debug('************' + listaRetention.size());
            String roleName = [select name from userRole where id = :userinfo.getUserRoleId()].name;
            notaSistema = XCS_templateUtils.buildTemplateByName(CRMRetentionUtil.NOTE_UFFICIO_HEADER,new List<String>{roleName,notaPratica});
            notaOCS = XCS_TemplateUtils.buildTemplateByName(CRMRetentionUtil.NOTE_RETENTION_PRESTITI_RICHIESTA_CRM, new List<String>{c.CaseNumber,notaPratica,noteUtente});
            for(CRM_Retention__c r : listaRetention)
            {
                System.debug('dentro if prima di zero' + r.Disposition__c);
                If(dispNonInteressato.equalsIgnoreCase(r.Disposition__c))
                {
                    System.debug('Dentro If Zero');
                    if(CRMRetentionUtil.COD_PRODOTTO_PP.equalsIgnoreCase(r.ProductCode__c) || CRMRetentionUtil.COD_PRODOTTO_PE.equalsIgnoreCase(r.ProductCode__c))
                    {
                        System.debug('Dentro Primo If');
                        if(resp.pratiche != null)
                        {
                            for(OCSRecuperaDatiPostvenditaResponse.PSVDatiPraticaDTO pratica : resp.pratiche)
                            {
                                System.debug('Dentro secondo If : ' + r.LoanNumber__c + ' ------ ' + pratica.numPratica);
                                if(r.LoanNumber__c.equalsIgnoreCase(pratica.numPratica))
                                {
                                    System.debug('Dentro terzo If agenzia' + pratica.agente + '-----' + pratica.filiale);		
                                    if((pratica.agente.equals('12') ||  pratica.agente.equals('0')) || (Integer.valueOf(pratica.filiale) >= 700 && Integer.valueOf(pratica.filiale) < 800 )) 
                                    {
                                        System.debug('Son Dentro gli if');
                                        listRetentionToCreate.add(
                                            new CRM_Retention__c( 
                                                customer__c  = c.AccountId,
                                                Branch__r = new Account(OCS_External_id__c = AccountUtils.OCSBranchChar + Integer.valueOf(pratica.filiale)),
                                                type__c = CRMRetentionUtil.RETENTION_TYPE_TO_CREATE,
                                                loanNumber__c = r.LoanNumber__c
                                            )
                                        );
                                    }
                                }
                            }
                        }
                    }
                }
            }
            c.Status =  CaseUtils.CHIUSO;
            if(String.isNotBlank(tassoSelezionato))
            {
                c.retention_Tasso__c = tassoSelezionato;  
            }
            if(String.isNotBlank(obiezioneSelezionata))
            {
                c.retention_obiezione__c = obiezioneSelezionata;
            }
            List<sObject> lToUpdate = new List<sObject>();
            lToUpdate.addAll(listaRetention);
            lToUpdate.add(c);
            messToast = CaseUtils.TOAST_SUCCESS ;
            XCSNoteUtils.postANote(c.id,XCSNoteUtils.SYSTEM_NOTE_TITLE,notaSistema);
            if(String.isNotBlank(noteUtente))
                XCSNoteUtils.postANote(c.id,XCSNoteUtils.USER_NOTE_TITLE,noteUtente);
            String aliasUser = [select alias from user where id = :UserInfo.getUserId()].alias;
            OCSGestioneNoteInvoker.filtraNote(aliasUser,c.account.getCodice_Cliente__c ,'' ,'' , 'A', 'P',notaOCS );
            System.debug('**********' + listRetentionToCreate);
            if(! listRetentionToCreate.isEmpty())
            {
                insert listRetentionToCreate;
            }
            update lToUpdate;
        }
        else
        {
            res = false;
            messToast = CRMRetentionUtil.PRATICHE_NON_ESITATE;
        }
        return new wrapResponse(res,messToast);
    }
    public class wrapInit
    {
        @AuraEnabled
        public Case c {get; set;}
        @AuraEnabled
        public List<CRM_Retention__c> lRetention {get; set;}
        public wrapInit(Case c, List<CRM_Retention__c> lRetention)
        {
            this.c = c;
            this.lRetention = lRetention;
        }
    }
    public class wrapResponse
    {
        @AuraEnabled
        public boolean res {get; set;}
        @AuraEnabled
        public String messToast {get; set;}
        public wrapResponse(boolean res, String messToast)
        {
            this.res = res;
            this.messToast = messToast;
        }
    }
}