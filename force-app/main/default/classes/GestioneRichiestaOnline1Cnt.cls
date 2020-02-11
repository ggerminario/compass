/**
 * ***********************************************************************************
 *     * @author abdoulaye.diop@compass.com.dev
 *     * @date  16/05/2019
 *     * @description Wizard Controller for GestioneRichiestaOnline1 Aura Component
 * ************************************************************************************
 **/
public with sharing class GestioneRichiestaOnline1Cnt { 

    public static List<String> queuesNotShowLinkEvo = new List<String>{'Q340','Q377','Q525','Q336'};
    public static final List<String> codesQueue = new List<String>{'Q330', 'Q331', 'Q332', 'Q333', 'Q375'};

    /**
     * @Author AD
     * @date  16/05/2019
     * @description Method to get a Case related to Anomalie_Doc__c
     * @param String idCase the Id of the case to search
     **/
    @AuraEnabled
    public static Map<String, Object> getCase(String idCase){
        Map<String, Object> response = new Map<String, Object>();
        try { 
            /**
             * Giorni Lavorativi Recall Date 
             Si identificano i giorni della settimana lavorativi
                0 -> Domenica
                1 -> Lunedi
                2 -> Martedi
                3 -> Mercoledi
                4 -> Giovedi
                5 -> Venerdi
                6 -> Sabato

                Es: 1,2,3,4,5,6
             */
            XCS_CompassParameters__c recallDate = XCS_CompassParameters__c.getValues('richOnline_recall_date');
            if(recallDate != null)
                response.put('recallDateEnabled','['+recallDate.Value__c+']');
            
            /**
             * Si identificano le fasce orarie del giorno lavorativo, nel seguente formato:

                HH:mm-HH:mm

                di seguito un esempio:
                08:00-22:00
             */ 
            XCS_CompassParameters__c recallHours = XCS_CompassParameters__c.getValues('richOnline_recall_timeSlots');
            if(recallHours != null && recallHours.Value__c.split('-').size()==2){
                response.put('recallStartHoursEnabled', recallHours.Value__c.split('-')[0]);
                response.put('recallEndHoursEnabled',recallHours.Value__c.split('-')[1]);
            }

            /**
             * Il parametro rappresenta i giorni lavorativi entro il quale è possibile effettuare una recall:

                Es.
                1
             */
            XCS_CompassParameters__c recallWorkingDays = XCS_CompassParameters__c.getValues('richOnline_recall_workingDays');
            if(recallWorkingDays != null){
                response.put('recallWorkingDays', recallWorkingDays.Value__c);
            } 
                

            Case caseObject = [SELECT 
                Id, RO_Messaggio_Non_Contattare__c, Status, ContactMobile, RecallDate__c, Is_Discordanza_Cellulare__c, 
                TentativoNonRicorda__c, RO_Link_Bozza__c, stato_ocs__c, OwnerId, Owner.Name, RO_fea__c, NumeroPratica__c,
                Stato_Pratica__c, Note__c, RO_Nuovo_Cellulare__c, Tentativo__c, Tipo_Pratica__c, RO_Tentativo_Ricicli__c, 
                AccountId, Account.PersonMobilePhone, Product__r.DEMRipresaBozza__c, Product__r.Family, RO_Vecchio_Cellulare__c, 
                (SELECT Id, CreatedDate FROM Anomalie_Doc__r ORDER BY CreatedDate desc LIMIT 1) 
                FROM Case WHERE Id= :idCase];
            Map<String, Object> caseObjectMap = (Map<String, Object>) JSON.deserializeUntyped(JSON.serialize(caseObject));

            List<Anomalie_Doc__c> anomalies = new List<Anomalie_Doc__c>();
            if (caseObjectMap.keySet().contains('Anomalie_Doc__r')) {
                if(caseObject.Anomalie_Doc__r.size() > 0){
                    Datetime cDate = caseObject.Anomalie_Doc__r[0].CreatedDate;
                    anomalies = [SELECT Id, CreatedDate,codice_Anomalia__c, Descrizione_Anomalia_Op__c, Codice_Documento__c, descrizione_Documento__c FROM Anomalie_Doc__c WHERE CaseId__c=:idCase AND  CreatedDate =: cDate];
                }
            }
            Boolean isSelf = false;
            Group gr = [SELECT Id, Name, DeveloperName FROM Group WHERE Type = 'Queue' AND Id = :caseObject.OwnerId];
            XCS_Disposition__c xcsDisposition = [SELECT Id FROM XCS_Disposition__c WHERE External_Id__c = 'DP5895'];            
            System.debug('Case ' + caseObject.Id + ' is in queue: ' + caseObject.Owner.Name);
            if (CaseService.checkCaseInQueue(caseObject.OwnerId)) {
                System.debug('checkCaseInQueue is true');   
                response.put('isInQueue', true);
                String note = '-SELF-', body = '';                
                if (codesQueue.indexOf(gr.DeveloperName) != -1) {
                    System.debug('queue is in codesQueue'); 
                    if (CaseService.checkEventByCFAndCreateDate(idCase)) {
                        body = 'Il cliente ha già fissato un appuntamento';
                        caseObject.RO_Messaggio_Non_Contattare__c = body;
                        caseObject.Disposition__c = xcsDisposition.Id;
                        caseObject.Note__c = note;
                        CaseService.addCasesToQueue(new List<Case> {caseObject}, 'Q525', note, body);
                        response.put('developerName', 'Q525');
                        isSelf = true;
                    } else if (CaseService.isCaseModifiedInLast30Minutes(idCase)) {
                        body = 'Il cliente sta proseguendo la richiesta online. Non contattare.';
                        caseObject.RO_Messaggio_Non_Contattare__c = body;
                        caseObject.Note__c = note;
                        caseObject.Disposition__c = xcsDisposition.Id;
                        CaseService.addCasesToQueue(new List<Case> {caseObject}, 'Q525', note, body);
                        response.put('developerName', 'Q525');
                        isSelf = true;
                    } else if (caseObjectMap.containsKey('NumeroPratica__c')) {
                        body = 'il Cliente ha già un codice OCS';
                        caseObject.RO_Messaggio_Non_Contattare__c = body;
                        caseObject.Disposition__c = xcsDisposition.Id;
                        caseObject.Note__c = note;
                        CaseService.addCasesToQueue(new List<Case> {caseObject}, 'Q525', note, body);
                        response.put('developerName', 'Q525');
                        isSelf = true;
                    } else {
                        response.put('developerName', gr.DeveloperName);
                    }
                } 
                else if (gr.DeveloperName == 'Q375') {
                    if (caseObjectMap.containsKey('NumeroPratica__c')) {
                        body = 'il Cliente ha già un codice OCS';
                        caseObject.RO_Messaggio_Non_Contattare__c = body;
                        caseObject.Note__c = note;
                        CaseService.addCasesToQueue(new List<Case> {caseObject}, 'Q525', note, body);
                        response.put('developerName', 'Q525');
                        isSelf = true;
                    } else if (CaseService.isCaseModifiedInLast30Minutes(idCase)){
                        body = 'Il cliente sta proseguendo la richiesta online. Non contattare.';
                        caseObject.RO_Messaggio_Non_Contattare__c = body;
                        caseObject.Note__c = note;
                        caseObject.Disposition__c = xcsDisposition.Id;
                        CaseService.addCasesToQueue(new List<Case> {caseObject}, 'Q525', note, body);
                        response.put('developerName', 'Q525');
                        isSelf = true;
                    }
                    else {
                        response.put('developerName', gr.DeveloperName);
                    }
                }
                else {
                    response.put('developerName', gr.DeveloperName);
                }         
            }
            else {
                response.put('isInQueue', false);
                response.put('developerName', '');
            }
            System.debug('isSelf '+ isSelf);

            if (isSelf) {
                /*
                RO_CRMRich_online_steplog__c steplog = new RO_CRMRich_online_steplog__c();
                steplog.RO_CRMRichiesta_Online__c = caseObject.Id;
                steplog.RO_CRMStep__c = 'SELF';
                steplog.Ro_DeveloperName__c = gr.DeveloperName;
                steplog.RecordTypeId = CGMWSUtils_1_0.getRecordTypeId('RO_CRMRich_online_steplog__c', 'RO_CRMRichiesta_Online');
                System.debug('inserting SELF steplog');
                try {
                    insert steplog;
                    System.debug('SELF steplog inserted');
                }
                catch (Exception e) {
                    System.debug('ERROR in steplog insert: ' + e);
                }
                */
            }
            else {
                caseObject.Note__c = '-SELF-'.equals(caseObject.Note__c)?'': caseObject.Note__c;
                caseObject.RO_Messaggio_Non_Contattare__c = '';
                update caseObject;
            }

            Decimal cmpt = caseObject.Tentativo__c; 
            System.debug('#l case tentativo '+cmpt);
            if (cmpt == null) {
                cmpt = 0;
            }
            caseObject.Tentativo__c = cmpt;
            System.debug('#l caseObject '+ JSON.serialize(caseObject));
            response.put('anomalies', anomalies);
            response.put('case', caseObject);
            response.put('error', false);
        } catch (Exception e) {
            System.debug('ERROR:: '+ e);
            response.put('message', e.getCause() + ' ' + e.getMessage()+ ' '+ e.getStackTraceString());
            response.put('error', true);
            response.put('isInQueue', false);
            response.put('messaggio', '');
        }
        return response; 
    }

    /**
     * @Author AD
     * @date  17/05/2019
     * @description Method to update a Case 
     * @param Case case an instance of case
     **/
    @AuraEnabled()
    public static Map<String, Object> updateCase(Case caseObject, String code , String firstLevel, String secondLevel, 
                                                    String thirdLevel, Boolean showLinkEvo){
        System.debug('////////////////////// CASE UPDATE ////////////////////'); 
        Map<String, Object> response = new Map<String, Object>();
        response.put('linkevo', false);
        response.put('isOpenDomanda', false);
        system.debug('///////////////////////// showLinkEvo: ' + showLinkEvo);
        try {
            Map<String, Object> caseObjectMap = (Map<String, Object>) JSON.deserializeUntyped(JSON.serialize(caseObject));
            Decimal cmpt = caseObject.Tentativo__c;
            System.debug('********* case Object '+cmpt); 
            String clienteNonTrovato = 'CLIENTE NON TROVATO';
            if (secondLevel.toUpperCase() == clienteNonTrovato || thirdLevel.toUpperCase() == clienteNonTrovato) {
                Datetime dataNonTrovato = System.now().addMinutes(CGMWSUtils_1_0.USCITA_DALLA_CODA);
                System.debug('#l dataNonTrovato ' + dataNonTrovato);
                caseObject.RO_Data_Non_Trovato__c = dataNonTrovato;           
                if (cmpt == null) {
                    cmpt = 1;
                } else {
                    cmpt++;
                }
            }
            caseObject.Tentativo__c = cmpt;
            System.debug('response.get(linkevo)-->'+response.get('linkevo'));
            CaseDomain.Assembly assembly = new CaseDomain.Assembly(caseObject, code, firstLevel, secondLevel, thirdLevel, showLinkEvo); 
            System.debug('response.get(linkevo)-->'+response.get('linkevo'));
            String developerName = CaseService.getGroupByOwner(caseObject.OwnerId);
            System.debug('/////////////////////// developerName '+ developerName);
            String state = assembly.getEtat(developerName);
            System.debug('/////////////////////// state: '+ state);

            String contactMobile = caseObject.Account.PersonMobilePhone;
            String cellNum = null;
            if (assembly.getSecondLevel() == CaseDomain.CONFERMA_VECCHIO_RECAPITO) {
                cellNum = caseObject.RO_Vecchio_Cellulare__c;
            }
            if (assembly.getSecondLevel() == CaseDomain.CONFERMA_NUOVO_RECAPITO) {
                cellNum = caseObject.RO_Nuovo_Cellulare__c;
            }
            if (cellNum != null) {
                // Numero di telefono da aggiornare in anagrafica
                Account acc = new Account (Id = caseObject.AccountId,
                                            PersonMobilePhone = cellNum);
                Map<Account, Account> accountMap = new Map<Account, Account>();
                accountMap.put(acc, null);
                XCSGestioneAnagrafica.execute(accountMap, false, false);
                contactMobile = cellNum;
            }
            System.debug('///////////////// cmpt: ' + cmpt);
            switch on state {
                when '100' {
                    String dev = 'Q524';
                    if (developerName == 'Q338') {
                        if (secondLevel.toUpperCase() != 'Identità non confermata'.toUpperCase()) {
                            dev = 'Q525';
                        }
                        showLinkEvo = true;
                    } else if (developerName == 'Q339' && secondLevel.toUpperCase() == 'Identità non confermata'.toUpperCase()) {                       
                        showLinkEvo = true;
                    } else if ( developerName == 'Q337' && secondLevel.toUpperCase() == 'Identità non confermata'.toUpperCase()) {
                        showLinkEvo = true;
                    } else if (developerName == 'Q339' && secondLevel.toUpperCase() == 'NUMERO INESISTENTE') {
                        showLinkEvo = true;
                        caseObject.Status = 'Gestito';
                        dev = 'Q525';
                    }
                    CaseDomain.CaseContext context = new CaseDomain.CaseContext(caseObject, dev, showLinkEvo);
                    context.setState(new CaseDomain.ContattoNonEseguitoContext1());
                    response = context.action();
                } when '101' {
                    /*
                    if (developerName == 'Q339' && caseObject.Is_Discordanza_Cellulare__c) {
                        CaseDomain.tentativo = 4;
                    } else if(developerName == 'Q337') {
                        CaseDomain.tentativo = 4;
                    } */
                    CaseDomain.CaseContext context = new CaseDomain.CaseContext(caseObject, 'Q524',  true);
                    context.setState(new CaseDomain.ContattoNonEseguitoContext2());
                    response = context.action();
                    CaseDomain.sendEmailDem(developerName, caseObject.Id, state);
                    caseObject.Status = 'Gestito';
                    response.put('isOpenDomanda', true);
                } when '102' {
                    Boolean isDiscordanza = caseObject.Is_Discordanza_Cellulare__c;
                    if (cmpt == 1 && !isDiscordanza) {
                        CaseDomain.sendSMS(contactMobile, 'SMSNonTrovatoAnomaliePreSIC');
                    }
                    CaseDomain.CaseContext context = new CaseDomain.CaseContext(caseObject, 'Q525', isDiscordanza);
                    if (isDiscordanza) {
                        context.setState(new CaseDomain.ContattoNonEseguitoContext10());
                    }
                    else {
                        context.setState(new CaseDomain.ContattoNonEseguitoContext2());
                        CaseDomain.sendEmailDem(developerName, caseObject.Id, state);
                    }
                    response = context.action();
                } when '103' {                    
                    Boolean showLink = true;
                    if ((developerName == 'Q339' && !caseObject.Is_Discordanza_Cellulare__c) || developerName == 'Q336' || developerName == 'Q340' || developerName == 'Q377' || 
                            developerName == 'Q525' || developerName == 'Q341' || developerName == 'Q330' || developerName == 'Q331' || developerName == 'Q332' || developerName == 'Q333' || developerName == 'Q375') {
                        showLink = false;
                    }
                    system.debug('///////////////////////// showLink: ' + showLink);
                    CaseDomain.CaseContext context = new CaseDomain.CaseContext(caseObject, 'Q525',  showLink);
                    context.setState(new CaseDomain.ContattoNonEseguitoContext3());
                    response = context.action();
                    CaseDomain.sendEmailDem(developerName, caseObject.Id, state);                    
                } when '104' {
                    Boolean showLink = false;
                    if ((developerName == 'Q339' || developerName == 'Q376' || developerName == 'Q338') && caseObject.Is_Discordanza_Cellulare__c) {
                        showLink = true;
                    } else if(developerName == 'Q337'){
                        showLink = true;
                    }
                    CaseDomain.CaseContext context = new CaseDomain.CaseContext(caseObject, 'Q525',  showLink);
                    context.setState(new CaseDomain.ContattoNonEseguitoContext4());
                    response = context.action();
                } when '105' {
                    CaseDomain.CaseContext context = new CaseDomain.CaseContext(caseObject, 'Q524', true);
                    context.setState(new CaseDomain.ContattoNonEseguitoContext1());
                    response = context.action();
                    caseObject.Status = 'Gestito';
                    if (developerName == 'Q338' || developerName == 'Q339') {
                        GestioneRichiestaOnline1Cnt.sendEmailToCompassAffari(CGMWSUtils_1_0.EMAIL_UFFICIO_FRODI, caseObject.Id, 'Disconosce la pratica');
                    }
                } when '106' {
                    Boolean showLink = true;
                    if (queuesNotShowLinkEvo.indexOf(developerName) != -1 || developerName == 'Q336') {
                        showLink = false;
                    }
                    CaseDomain.CaseContext context = new CaseDomain.CaseContext(caseObject, 'Q524', showLink);
                    context.setState(new CaseDomain.ContattoNonEseguitoContext6());
                    response = context.action();
                    caseObject.Status = 'Gestito';
                    GestioneRichiestaOnline1Cnt.sendEmailToCompassAffari(CGMWSUtils_1_0.EMAIL_COMPASS_AFFARI, caseObject.Id, 'Disconosce la pratica');
                } when '107' {
                    CaseDomain.CaseContext context = new CaseDomain.CaseContext(caseObject, 'Q524', false);
                    context.setState(new CaseDomain.ContattoNonEseguitoContext1());
                    response = context.action();
                    caseObject.Status = 'Gestito';
                    if (developerName == 'Q339') {
                        GestioneRichiestaOnline1Cnt.sendEmailToCompassAffari(CGMWSUtils_1_0.EMAIL_COMPASS_AFFARI, caseObject.Id, 'Disconosce la pratica');
                    }
                } when '115' {
                    CaseDomain.CaseContext context = new CaseDomain.CaseContext(caseObject, 'Q524', false);
                    context.setState(new CaseDomain.ContattoNonEseguitoContext1());
                    response = context.action();
                    caseObject.Status = 'Gestito';
                } when '108' {
                    if (developerName == 'Q336') {
                        CaseDomain.tentativo = 5;
                        system.debug('///////////////////////// Tentativo impostato a 5');
                        if (cmpt == 5) {
                            CaseDomain.sendEmailDem(developerName, caseObject.Id, state);
                        }
                    } else if (developerName == 'Q338') {
                        CaseDomain.tentativo = 2;
                    }
                    CaseDomain.CaseContext context = new CaseDomain.CaseContext(caseObject, 'Q525', false);
                    context.setState(new CaseDomain.ContattoNonEseguitoContext7());
                    response = context.action();
                } when '109' {
                    CaseDomain.CaseContext context = new CaseDomain.CaseContext(caseObject, 'Q524',  caseObject.Is_Discordanza_Cellulare__c);
                    context.setState(new CaseDomain.ContattoNonEseguitoContext3());
                    response = context.action();    
                    caseObject.Status = 'Gestito'; 
                    System.debug('response.get(linkevo)-->'+response.get('linkevo'));
                    CaseDomain.sendEmailDem(developerName, caseObject.Id, state);               
                } when '110' {
                    CaseDomain.CaseContext context = new CaseDomain.CaseContext(caseObject, 'Q525',  false);
                    context.setState(new CaseDomain.ContattoNonEseguitoContext4());
                    response = context.action();
                } when '111' {
                    response.put('case', caseObject);
                } when '112' {
                    if (developerName == 'Q339' || developerName == 'Q340' || developerName == 'Q376') {
                        CaseDomain.tentativo = 3;
                    } else if (developerName == 'Q377') {
                        CaseDomain.tentativo = 10;
                    }
                    CaseDomain.CaseContext context = new CaseDomain.CaseContext(caseObject, 'Q525', false);
                    context.setState(new CaseDomain.ContattoNonEseguitoContext2());
                    response = context.action();
                } when '113' {
                    CaseDomain.CaseContext context = new CaseDomain.CaseContext(caseObject, 'Q525', false);
                    context.setState(new CaseDomain.ContattoNonEseguitoContext9());
                    response = context.action();
                    //Set<Id> ids = new Set<Id>();
                    //ids.add(caseObject.Id);
                    CaseDomain.ricicliEsiti(caseObject, developerName);
                } when '114' {
                    CaseDomain.sendEmailDem(developerName, caseObject.Id, state);
                } when '119' {
                    String dev = 'Q525';
                    switch on developerName {
                        when 'Q339' {
                            if (cmpt == 1) {
                                String nameSms = 'SMSTentativoDiContatto';
                                CaseDomain.sendSMS(contactMobile, nameSms);     
                            } else if (cmpt == 3) {
                                CaseDomain.sendEmailDem(developerName, caseObject.Id, state);
                                String nameSms = 'SMSNonTrovatoAnomaliePreSIC';
                                CaseDomain.sendSMS(contactMobile, nameSms);
                            }
                        }
                        when 'Q340' {
                            if (secondLevel.toUpperCase() == 'CLIENTE NON TROVATO') {
                                System.debug('*****CLIENTE NON TROVATO*****');
                                if (cmpt == 1) {
                                    System.debug('*****PRIMO TENTATIVO*****');
                                    String nameSms = 'SMSTentativoDiContatto';
                                    CaseDomain.sendSMS(contactMobile, nameSms);     
                                } else if (cmpt == 3) {
                                        CaseDomain.sendEmailDem(developerName, caseObject.Id, state);
                                        String nameSms = 'SMSNonTrovatoAnomaliePostSIC';
                                        CaseDomain.sendSMS(contactMobile, nameSms);
                                }
                            } else {
                                CaseDomain.sendEmailDem(developerName, caseObject.Id, state);
                            }
                        }
                        when  'Q377' {
                            CaseDomain.tentativo = 12;
                            if (cmpt == 1) {
                                CaseDomain.sendSMS(contactMobile, 'SMSTentativoDiContatto');   
                            }
                            Integer reminder = math.mod(cmpt.intValue(), 3);
                            if (reminder == 0) {
                                CaseDomain.sendEmailDem(developerName, caseObject.Id, state);
                                CaseDomain.sendSMS(contactMobile, 'SMSNonTrovatoFirmaContratto');
                            }
                        }
                        when 'Q376' {
                            dev = 'Q524';
                            if (cmpt == 1) {
                                if (!caseObject.Is_Discordanza_Cellulare__c) {
                                    String nameSms = 'SMSTentativoDiContatto';
                                    CaseDomain.sendSMS(contactMobile, nameSms);
                                }
                            } else if (cmpt == 3) {
                                CaseDomain.sendEmailDem(developerName, caseObject.Id, state);
                            }
                        }
                        when 'Q341' {
                            CaseDomain.tentativo = 12;
                            if (cmpt == 1) {
                                CaseDomain.sendSMS(contactMobile, 'SMSTentativoDiContatto');
                            }
                            Integer reminder = math.mod(cmpt.intValue(), 3);
                            if (reminder == 0) {
                                CaseDomain.sendEmailDem(developerName, caseObject.Id, state);
                                CaseDomain.sendSMS(contactMobile, 'SMSNonTrovatoFirmaContratto_DS');
                            }
                        }
                        when 'Q338' {
                            CaseDomain.tentativo = 2;                      
                            if (cmpt == 2) {
                                XCS_Template__c template = [SELECT Name, Body__c FROM XCS_Template__c LIMIT 1];
                                OCSInviaSMSInvoker.inviaSMS('', contactMobile,'','', template.Body__c);
                                CaseDomain.sendEmailDem(developerName, caseObject.Id, state);
                            }
                        }
                        when else {
                            System.debug('"#l developerName ' + developerName);
                        }
                    }
                    CaseDomain.CaseContext context = new CaseDomain.CaseContext(caseObject, dev, false);
                    context.setState(new CaseDomain.ContattoNonEseguitoContext8());
                    response = context.action();
                    System.debug('#l case in response '+ response.get('case'));
                } when '120' {
                    Boolean showlink = false;
                    if (developerName == 'Q339') {
                        showlink = true;
                    }
                    CaseDomain.CaseContext context =  new CaseDomain.CaseContext(caseObject, '',  showlink);
                    context.setState(new CaseDomain.ContattoNonEseguitoContext5());                    
                    response = context.action();
                    response.put('isOpenDomanda', true);
                } when else {
                    response.put('case', caseObject);
                    System.debug('#l else ');
                }
            }

            caseObject = (Case) response.get('case');      
            System.debug('response.get(linkevo)-->'+response.get('linkevo'));      
            if(!String.isEmpty(code)){
                XCS_Disposition__c xcsDisposition = [SELECT Id FROM XCS_Disposition__c WHERE External_Id__c = :code];
                if(xcsDisposition != null){
                    caseObject.Disposition__c = xcsDisposition.Id;
                }
            }
            if (CaseDomain.isResolved) {
                caseObject.Is_Discordanza_Cellulare__c = false;
            }
            Recursion.isTriggerExecuting = true;
            update caseObject;
            String devName  = CaseService.getGroupByOwner(caseObject.OwnerId);
            System.debug('#l caseObject '+ JSON.serialize(caseObject));
            System.debug('#l devName '+ devName);
            
            String title = 'Numero Blu - '+' ';
            String body =  firstLevel +' '+  secondLevel + ' '+ thirdLevel;
            if (caseObject.Tentativo__c != null) {
                body += '\n' +'Tentativo \t ' + caseObject.Tentativo__c;
            }
            CaseDomain.createFeeditem(title, body, caseObject.Id);
            System.debug('response.get(linkevo)-->'+response.get('linkevo'));
            response.put('case', caseObject);
            response.put('devName', devName);
            response.put('error', false);
            response.put('etat', state);
            response.put('code', code);
        } catch (Exception e) {
            response.put('message', e.getCause() + ' ' + e.getMessage()+ ' '+ e.getStackTraceString() + e.getLineNumber());
            response.put('error', true);
            response.put('linkevo', false);
        }
        return response;
    }

    /**
     * @Author AD
     * @date 27/07/2019
     * @description
     * @param
     **/
    @AuraEnabled
    public static Map<String, Object> sendDomanda(Case caseObject, Object questionManagement){
        
        Map<String, Object> response = new Map<String, Object>();
        System.debug('#### questionManagement ' + questionManagement);
        try {
            String questionManagementJson = JSON.serialize(questionManagement);    
            QuestionManagement questionManagementParsed = (QuestionManagement) JSON.deserialize(questionManagementJson, QuestionManagement.class);
            Map <String, Object> data = RecuperaDatiPostvenditaService.recuperaDatiPostvenditaControl(caseObject.Id, questionManagementParsed);
            System.debug('#### data ####'+ JSON.serialize(data));
            if (data.get('error') == true) {
                response.put('error', true); 
                response.put('message', data.get('errorMessage'));
            } else {
                response.put('error', false); 
                response.put('data', data);
            }
        } catch (Exception e) {
            response.put('message', e.getCause() + ' ' + e.getMessage()+ ' '+ e.getStackTraceString() + e.getLineNumber());
            response.put('error', true);            
        }
        return response;
    }

    /**
     * @author ADIOP
     * @date 25/06/2019
     **/
    @future
    public static void sendEmailToCompassAffari(String email, String IdCase, String name){

        try {
            EmailTemplate template = [SELECT Id, HtmlValue FROM EmailTemplate WHERE Name = :name];
            List<Messaging.SingleEmailMessage> allMsg = new List<Messaging.SingleEmailMessage>();
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();

            try {
                OrgWideEmailAddress owea = [select Id from OrgWideEmailAddress where Address = 'donotreply@compass.it']; //:fromAddress
                mail.setOrgWideEmailAddressId(owea.Id);
            } catch (Exception e) {
                mail.setSenderDisplayName('donotreply@compass.it');
                System.debug('error '+ e.getMessage() + ' '+ e.getStackTraceString());
            }

            Case caseObject = [SELECT Id, NumeroPratica__c, Note__c, Account.FirstName, Account.LastName FROM Case WHERE Id=:idCase];
            Map<String, Object> caseObjectMap = (Map<String, Object>) JSON.deserializeUntyped(JSON.serialize(caseObject));
            String numeroPratica = caseObjectMap.containsKey('NumeroPratica__c') ? caseObject.NumeroPratica__c : '';    

            String htmlBody = template.HtmlValue;
            mail.setToAddresses(email.split(','));
            mail.setTemplateID(template.Id);
            mail.setSaveAsActivity(true);

            switch on name {
                when 'Disconosce la pratica' {
                    mail.setSubject('Richieste Online: Disconosce Pratica');
                    String note = caseObjectMap.containsKey('Note__c') ? caseObject.Note__c : '';            
                    htmlBody = htmlBody.replace('{!Case.NumeroPratica__c}', numeroPratica);
                    htmlBody = htmlBody.replace('{!Case.Note__c}', note);
                }
                when 'Discordanza cellulare - Sospetta truffa ST' {
                    mail.setSubject('Discordanza cellulare - Sospetta truffa ST'); 
                    if (caseObjectMap.containsKey('Account')) {
                        Account acc =   caseObject.Account;
                        Map<String, Object> accObjectMap = (Map<String, Object>) JSON.deserializeUntyped(JSON.serialize(acc));
                        String firstName = accObjectMap.containsKey('FirstName') ? acc.FirstName : '';    
                        String lastName = accObjectMap.containsKey('LastName') ? acc.LastName : '';
                        htmlBody = htmlBody.replace('{!Nome}', firstName + ' ' + lastName); 
                    } else {
                        htmlBody = htmlBody.replace('{!Nome}', ''); 
                    }     
                    htmlBody = htmlBody.replace('{!Case.NumeroPratica__c}', numeroPratica);                    
                }
                when else {}
            }
            mail.setHtmlBody(htmlBody);
            allMsg.add(mail);
            List<Messaging.SendEmailResult> results = Messaging.sendEmail(allMsg);            
            // we can then check for success            
        } catch (EmailException e) {
            System.debug('sendTemplatedEmail error. ' + e.getMessage());
        }
    }

    /**
     * @author ADIOP
     * @date 05/07/2019
     */
    public static List<Anomalie_Doc__c> getAnomaliesByCase(String idCase){
        List<Anomalie_Doc__c> anomalies  = [SELECT Id FROM Anomalie_Doc__c  WHERE CaseId__c =:idCase];
        return anomalies;
    }

    /**
     * @Author AD
     * @date  30/07/2019
     * @description Method to update a Case 
     * @param Case case an instance of case
     **/
    @AuraEnabled
    public static Map<String, Object> updateNoteCase(Case caseObject, String developerName, Boolean sendEmail, String title, String body){
        Map<String, Object> response = new Map<String, Object>();
        response.put('linkevo', true);
        try {
            caseObject = CaseDomain.changeOwner(caseObject, developerName);
            Recursion.isTriggerExecuting = true;    
            update caseObject;
            FeedItem feedItem = CaseDomain.createFeeditem(title, body, caseObject.Id);
            if (sendEmail) {
                sendEmailToCompassAffari('test@test.com', caseObject.Id, 'Discordanza cellulare - Sospetta truffa ST');
            }
            response.put('case', caseObject);
            response.put('error', false);
        } catch (Exception e) {
            response.put('message', e.getCause() + ' ' + e.getMessage()+ ' '+ e.getStackTraceString() + e.getLineNumber());
            response.put('error', true);
            response.put('linkevo', false);
        }
        return response;
    }

    /**
     * @Author AD
     * @date  06/08/2019
     * @description getRichiamiLimiteTemporel
     * @param String developerName
     **/
    @AuraEnabled
    public static Map<String, Object> getRichiamiLimiteTemporel(String developerName){
        Map<String, Object> response = new Map<String, Object>();
        developerName = developerName.toLowerCase();
        try {
            //RichiamiLimiteTemporel__c richiamiTempLimit = [SELECT Name, Limit__c FROM RichiamiLimiteTemporel__c WHERE Name = :developerName LIMIT 1];
            XCS_CompassParameters__c richiamiTempLimit = [SELECT Name, Limit__c FROM XCS_CompassParameters__c WHERE Name = :developerName LIMIT 1];
            response.put('error', false);
            response.put('richiamiTempLimit', richiamiTempLimit);
        } catch (Exception e) {
            response.put('error', true);
            response.put('message', e.getCause() + ' ' + e.getMessage()+ ' '+ e.getStackTraceString());
        }
        return response;
    }

    /**
     * @Author AD
     * @date  12/11/2019
     * @description get Case List View
     * @param 
     **/
    @AuraEnabled
    public static Map<String, Object> getListViews(String listViewName){
        Map<String, Object> response = new Map<String, Object>();
        try {
            Id rectypeId = CGMWSUtils_1_0.getRecordTypeId('Case', 'CRM_RichiestaOnline');
            // AND RecordTypeId =:rectypeId
            ListView listview = [SELECT Id, Name FROM ListView WHERE SobjectType = 'Case' AND  Name=:listViewName];
            response.put('error', false);
            response.put('listview', listview);
        } catch (Exception e) {
            response.put('error', true);
            response.put('message', e.getCause() + ' '+ e.getMessage());
        }
        return response;
    }

    /**
     * @Author AD
     * @date  19/11/2019
     * @description get Case List View
     * @param
     **/
    @AuraEnabled
    public static Map<String, Object> createNote(String title, String body, Case caseObject){
        Map<String, Object> response = new Map<String, Object>();
        response.put('error', false);
        try {
            FeedItem feedItem = CaseDomain.createFeeditem(title, body, caseObject.Id);
            response.put('feedItem', feedItem);
        } catch (Exception e) {
            response.put('error', true);
            response.put('message', e.getMessage() + ' '+ e.getCause());
        }
        return response;
    }

    /**
     * @Author AD
     * @date  27/11/2019
     * @description Method to get the pratiche
     * @param idCase id of the case
     **/
    @AuraEnabled
    public static Map<String, Object> getDatiPostVendita(String idCase){
        Map<String, Object> response = new Map<String, Object>();
        response.put('error', false);
        try {            
            Map <String, Object> data = RecuperaDatiPostvenditaService.recuperaDatiPostvenditaControl(idCase);
            System.debug('#l data ####'+ JSON.serialize(data));
            if (data.get('error') == true) {
                response.put('error', true); 
                response.put('message', data.get('errorMessage'));
            } else {
                response.put('data', data);
            }
        } catch (Exception e) {
            response.put('message', e.getCause() + ' ' + e.getMessage()+ ' '+ e.getStackTraceString() + e.getLineNumber());
            response.put('error', true);            
        }
        return response;
    }

    /**
     * @author ADIOP
     * @date  23/07/2019
     * @description 
     * @param 
     **/
    public class QuestionManagement {
        @AuraEnabled public List<QuestionObject> questions {get;set;}
        @AuraEnabled public List<ProductObject> products {get;set;}
    }

    /**
     * @author ADIOP
     * @date  23/07/2019
     * @description 
     * @param 
     **/
    public class QuestionObject {
        @AuraEnabled public String question {get;set;}
        @AuraEnabled public String response {get;set;}
        @AuraEnabled public List<String> prodotto {get;set;}
    }

    /**
     * @author ADIOP
     * @date  24/07/2019
     * @description 
     * @param 
     **/
    public class ProductObject {
        @AuraEnabled public String prodotto {get;set;}
        @AuraEnabled public List<String> statoOcs {get;set;}
    }
}