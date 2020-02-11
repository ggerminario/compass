/**------------------------------------------------------------------
 *@Auhtor Madicke BALDE
 *@description service class for Case
 *@version 1.0
 *uses
 *@codes
 *2019-05-10
 **---------------------------------------------------------------------------*/
global with sharing class CaseService {

    /**
     * @author ADIOP
     * @date  03/06/2019
     * @description Method to update a Case 
     * @param List<Case> cases a list of case
     * @param String developerName. the code of the queue
     **/
    public static Map < String, Object > addCasesToQueue(List < Case > cases, String developerName) {
        Map < String, Object > response = new Map < String, Object > ();
        try {
            if (!cases.isEmpty()) {
                Group gr = [SELECT Id FROM Group WHERE Type = 'Queue'
                    AND DeveloperName =: developerName
                ];
                System.debug('###### group id ' + gr.Id);
                System.debug('************ update Case  before ' + cases);
                if (gr != null) {
                    for (Case caseObject: cases) {
                        caseObject.OwnerId = gr.Id;
                    }
                    System.debug('************ update Case ' + cases);
                    Recursion.isTriggerExecuting = true;
                    update cases;
                    response.put('result', 0);
                    response.put('cases', cases);
                } else {
                    response.put('result', 1);
                    response.put('error', 'the group is not found');
                }
            }
        } catch (Exception e) {
            System.debug('errorMessage ****** ' + e.getMessage());
            System.debug('errorMessage ****** ' + e.getStackTraceString());
            response.put('result', 1);
            response.put('error', e.getMessage() + ' ' + e.getStackTraceString() + ' ' + e.getCause());
        }
        return response;
    }

    /**
     * @author ADIOP
     * @date  03/12/2019
     * @description Method to update a Case 
     * @param List<Case> cases a list of case
     * @param String developerName. the code of the queue
     **/
    public static Map < String, Object > addCasesToQueue(List < Case > cases, String developerName, String title, String body) {
        Map < String, Object > response = new Map < String, Object > ();
        try {
            if (!cases.isEmpty()) {
                Group gr = [SELECT Id FROM Group WHERE Type = 'Queue'
                    AND DeveloperName =: developerName
                ];
                List < FeedItem > feeds = new List < FeedItem > ();
                System.debug('###### group id ' + gr.Id);
                System.debug('************ update Case  before ' + cases);
                if (gr != null) {
                    for (Case caseObject: cases) {
                        FeedItem feeditem = new FeedItem();
                        feeditem.ParentId = caseObject.Id;
                        feeditem.Body = title + ' ' + body;
                        feeditem.Title = title;
                        feeds.add(feeditem);
                        caseObject.OwnerId = gr.Id;
                    }
                    System.debug('************ update Case ' + cases);
                    Recursion.isTriggerExecuting = true;
                    update cases;
                    insert feeds;
                    response.put('result', 0);
                    response.put('cases', cases);
                } else {
                    response.put('result', 1);
                    response.put('error', 'the group is not found');
                }
            }
        } catch (Exception e) {
            System.debug('errorMessage ****** ' + e.getMessage());
            System.debug('errorMessage ****** ' + e.getStackTraceString());
            response.put('result', 1);
            response.put('error', e.getMessage() + ' ' + e.getStackTraceString() + ' ' + e.getCause());
        }
        return response;
    }

    /**
     * @author ADIOP
     * @date  03/06/2019
     * @description Method get a developerName(code) in queue
     * @param String ownerId, the owner of the case
     **/
    public static String getGroupByOwner(String ownerId) {
        System.debug('********* running  getGroupByOwner ');
        Group gr = [SELECT Id, Name, DeveloperName FROM Group WHERE Type = 'Queue'
            AND Id =: ownerId
        ];
        System.debug('********* gr ' + gr);
        if (gr != null) {
            System.debug('#### developerName ' + gr.DeveloperName);
            return gr.DeveloperName;
        }
        System.debug('#### developerName ' + null);
        return null;
    }

    /** 
     * @author ADIOP
     * @date  12/06/2019
     **/
    public static Group getQueue(String developerName) {
        Map < String, Object > response = new Map < String, Object > ();
        Group gr = null;
        try {
            gr = [SELECT Id FROM Group WHERE Type = 'Queue'
                AND DeveloperName =: developerName
            ];
        } catch (Exception e) {
            gr = null;
        }
        return gr;
    }

    /**
     * @author ADIOP
     * @date 22/08/2019
     * @description Method get Account By the Id 
     * @param String idCase
     **/
    public static Boolean checkCodiceOcs(String id) {
        try {
            Account account = [SELECT Id, OCS_External_id__c FROM Account WHERE Id =: id]; //CIP__c
            if (account != null && account.OCS_External_id__c != null) {
                return true;
            }
        } catch (Exception e) {
            System.debug('#### account ####' + e.getCause() + ' ' + e.getMessage() + ' ' + e.getStackTraceString());
            return false;
        }
        return false;
    }


    /** --------------------------------
     * @Auhtor Madicke BALDE 
     * @description search link_bozza in Case
     * @param Case 
     * @return Id Case
     **---------------------------------------------------*/
    global static String searchLinkBozaInCase(Case cas) {
        //  System.debug('Runinng *************** searchLinkBozaInCase '+ cas.RO_Link_Bozza__c);
        if (String.isNotEmpty(cas.RO_Link_Bozza__c)) {
            throw new CGMWSUtils_1_0.CGMWSRException('[KO-CREQ0009]', cas.Codice_Cliente__c);
        }
        System.debug('**************** test *********************');
        return cas.Id;
    }

    /** ---------------------------------------------------------------------
     * @description : search for a Case corresponds to the three parameters:
                      1. Same product
                      2. open status
                      3. creation date less than 30 days
     * @param cas : Case
     * @param  codiceCliente
     * @param  codiceFiscale
     * @return Case
     *-----------------------------------------------------------------------*/
    global static Case searchRichieste(Case cas, String codiceCliente, String codiceFiscale) {
        Case myCase = new Case();
        try {
            List < Case > listCases = preventiveControl(codiceFiscale, codiceCliente);
            System.debug('******* list Case ' + listCases.size());
            for (Case ca: listCases) {
                System.debug('ca.CreatedDate *** ' + ca.CreatedDate);
                Integer numberOfDay = (system.today()).daysBetween(Date.valueOf(ca.CreatedDate));
                System.debug('numberOfDay *** ' + numberOfDay);
                System.debug('******** ca status ' + ca.Status);
                System.debug('******** ca.Product__c ' + ca.Product__c);
                System.debug('******** cas.Product__c ' + cas.Product__c);
                if (numberOfDay < 30 && ca.Status == 'On Hold' && ca.Product__c == cas.Product__c) {
                    System.debug('test serarchRichieste');
                    myCase = ca;
                }

            }
        } catch (Exception e) {
            System.debug('errorMessage ******* searchrichieste ' + e.getMessage());
        }
        return myCase;
    }

    /**-------- -----------------------------------------------------------------
     * @description : this method create Case
     * @param : cas : the Case to create
     * @return Case
     *-----------------------------------------------------------------------------*/
    global static Case createCase(Case cas) {
        System.debug('********************** Create Case***************** ');
        System.debug('********************** Create Case***************** ' + cas.Status);
        try {
            cas.RecordTypeId = CGMWSUtils_1_0.getRecordTypeId('Case', 'CRM_RichiestaOnline');
            Recursion.isTriggerExecuting = true;
            insert cas;
        } catch (Exception e) {
            System.debug('errorMessage createCase ' + e.getMessage());
            System.debug('errorStract' + e.getStackTraceString());
        }
        System.debug('################# c  status ' + cas.Status);
        return cas;
    }

    /*---------------------------------------------------------------------------
     * @description : update Case
     * @param cas the case to update
     * @return Case
     *---------------------------------------------------------------------------------*/
    global static Case updateCase(Case cas) {
        System.debug('********************* update Case ********** ' + cas);
        try {
            Recursion.isBeforeTriggerExcecuting = true;
            Recursion.isTriggerExecuting = true;
            cas.Trattabile__c = false;
            update cas;
            Recursion.isBeforeTriggerExcecuting = false;
            Recursion.isTriggerExecuting = false;
            cas.Trattabile__c = true;
            update cas;
        } catch (Exception e) {
            System.debug('errorMessage UpdateCase ' + e.getMessage());
            System.debug('errorStract UpdateCase ' + e.getStackTraceString());
        }
        System.debug('Update Case ' + cas);
        return cas;
    }

    public static void caseToUpdate(Case c, Product2 p) {
        System.debug('***********  caseToUpdate ***************** ');
        try {
            Case oldCase = [SELECT Id, RO_Current_Step__c FROM Case WHERE Id =: c.Id];
            //  if(oldCase.RO_Current_Step__c != c.RO_Current_Step__c ){
            RO_CRMRich_online_steplog__c log = RichOnlineSteplogService.createCrmOnlineStepLog(c);
            if (p.Family == 'PP_ONLINE_COMPASS_DS')
                RO_CRMRich_online_prescoring__c logprescoring = RichOnlinePrescoringService.createCrmOnlinePrescoring(c);

            //  }
            updateCase(c);

        } catch (Exception e) {
            System.debug('***************** caseToUpdate errorMessage ******  ' + e.getMessage());
            System.debug('***************** caseToUpdate errorStract ******  ' + e.getStackTraceString());
        }

    }

    /*********---------------------------------------------
     * @Auhtor Madicke BALDE  
     * @description update Case
     * @param List<Case>
     * @return List<Case>
     **-------------------------------------------------------*/
    global static List < Case > updateCase(List < Case > caseList) {
        try {
            update caseList;
            return caseList;

        } catch (Exception ex) {
            System.debug('error Message UpdateCase ****** CaseService ' + ex.getMessage());
            System.debug('errorStract UpdateCase CaseService' + ex.getStackTraceString());
            return null;
        }

    }

    /**------------------------------------------------------------------------------
     * @description this method applies preventive control with the parameters entered
     * @param codiceFiscale , codeCliente
     * @return a Case Liste
     *-------------------------------------------------------------------------------------*/
    global static List < Case > preventiveControl(String codiceFiscale, String codeCliente) {
        List < Case > listCases = new List < Case > ();

        System.debug('********** codiceFiscale ' + codiceFiscale);

        if (!String.isBlank(codiceFiscale)) {
            listCases = [SELECT Product__c, Status, CreatedDate, RO_Link_Bozza__c FROM Case WHERE Account.Codice_Fiscale__c =: codiceFiscale];
            System.debug('List case with codice fiscale ' + listCases.size());
            if (listCases.size() > 0) return listCases;
        }
        if (!String.isBlank(codeCliente)) {
            System.debug('********** codeCliente ' + codeCliente);
            listCases = [SELECT Product__c, Status, CreatedDate, RO_Link_Bozza__c FROM Case WHERE Account.Codice_Cliente__c =: codeCliente];
            System.debug('List case with codice cliente  new ' + listCases.size());
            return listCases;
        }
        return listCases;
    }

    /**-----------------------------------------------------------------------
     * @description Method to get CaseNumber by Id Case
     * @param Case Id
     * @return the  CaseNumber 
     **-----------------------------------------------------------------------*/
    global static String getCaseNumner(String idCase) {
        Case cas = [
            SELECT caseNumber
            FROM Case
            WHERE Id =: idCase
        ];
        return cas.caseNumber;
    }
    /*-------------------------------------------------------------------------
     *@description add Case to queue
     *@param List Id Case : ids
     *@param queue name : queueName
     *---------------------------------------------------------------------------*/
    public static void addCaseToQueue(Set < Id > ids, String queueName) {
        System.debug('****************** addCaseToQueue**********  ');
        try {
            List < Case > listCases = [SELECT Id, OwnerId FROM Case WHERE Id IN: ids];
            Group gr = [select Id from Group where Type = 'Queue'
                AND NAME =: queueName
            ];
            for (Case c: listCases) {
                c.OwnerId = gr.Id;
            }
            update listCases;
            Recursion.isTriggerExecuting = true;
            System.debug('***** Cases updated' + listCases);
        } catch (Exception e) {
            System.debug(' ******** addCaseToQueue' + e.getMessage());
            System.debug('errorStract' + e.getStackTraceString());
        }

    }

    /*-----------------------------------------------------------------------------
     *@description add Case to queue
     *@param List Id Case : ids
     *@param queue name : queueName
     *----------------------------------------------------------------------------*/
    public static List < Case > addCaseToQueue(List < Case > caseLists, String code) {
        try {
            if (caseLists.size() > 0) {

                Group gr = [
                    select Id
                    from Group
                    where Type = 'Queue'
                    AND DeveloperName =: code
                ];
                System.debug('********* group id' + gr.Id);
                for (Case c: caseLists) {
                    c.OwnerId = gr.Id;
                }
                update caseLists;
                System.debug('***** Cases updated' + caseLists);
            }
            return caseLists;

        } catch (Exception e) {
            System.debug(' ******** addCaseToQueue' + e.getMessage());
            System.debug('errorStract' + e.getStackTraceString());
            return null;
        }

    }


    /*-------------------------------------------------------------
     *@description add Case to queue
     *@param List Id Case : ids
     *@param code queue : code
     **--------------------------------------------------------------*/
    public static void addCase_To_Queue(Set < Id > ids, String code) {
        System.debug(' ***********  addCase_To_Queue ' + code);
        try {
            //List < Case > listCases = [SELECT Id, OwnerId FROM Case WHERE Id IN: ids];
            List<Case> listToUpdate = new List<Case>();
            Group gr = [
                select Id
                from Group
                where Type = 'Queue'
                AND DeveloperName =: code
            ];
            System.debug('********* group id' + gr.Id);
            /*for (Case c: listCases) {
                c.OwnerId = gr.Id;
            }*/
            for(Id idCase : ids){
                Case caso = new Case(ID=idCase,ownerId=gr.Id);
                listToUpdate.add(caso);
            }
            //update listCases;
            update listToUpdate;
            //System.debug('***** Cases updated' + listCases);
        } catch (Exception e) {
            System.debug(' ******** addCaseToQueue' + e.getMessage());
            System.debug('errorStract' + e.getStackTraceString());
        }

    }
    /*----------------------------------------------------------------------------
     *@description check if Case is in queue
     *@param ownerId
     *@return Boolean
     *------------------------------------------------------------------------------*/

    public static Boolean checkCaseInQueue(String ownerId) {
        Boolean existe = false;
        try {
            Group g = [select Id from Group where Type = 'Queue'
                AND Id =: ownerId
            ];
            if (g.Id != null) existe = true;
        } catch (Exception e) {
            System.debug('********** checkCaseInQueue' + e.getMessage());
            System.debug('errorStract' + e.getStackTraceString());
        }
        return existe;
    }
    /**------------------------------------------------------------------------
     * @author Madicke BALDE
     * @date 2019/07/22
     * @param SET Id Case
     * @return List Case
     **--------------------------------------------------------------------------*/
    public static List < Case > getCaseByIds(Set < Id > ids) {
        List < Case > cases = new List < Case > ();
        try {
            cases = [SELECT Id, RO_Vecchio_Cellulare__c, Is_Discordanza_Cellulare__c, RO_Nuovo_Cellulare__c FROM Case WHERE Id IN: ids];

        } catch (Exception e) {
            System.debug('************ getCaseByIds ' + e.getMessage());
        }

        return cases;
    }
    /**-------------------------------------------------------------------
     * @author Madicke BALDE
     * @description method to check if case contains discorda cellulare
     * @param Id Case SET
     * @return Case List
     *-----------------------------------------------------------------------*/
    public static List < Case > checkd_Discorda(Set < Id > ids) {
        List < Case > cases = getCaseByIds(ids);
        System.debug('********** cases ' + cases);
        List < Case > casesWihtAnomalies = new List < Case > ();
        try {
            if (cases.size() > 0) {
                for (Case c: cases) {
                    System.debug('********** c.RO_Vecchio_Cellulare__c ' + c.RO_Vecchio_Cellulare__c);
                    if (c.Is_Discordanza_Cellulare__c) {
                        casesWihtAnomalies.add(c);
                    } else {
                        System.debug('No cellulare');
                    }
                }
            }
        } catch (Exception e) {
            System.debug('****************** errorMessage checkd_Discorda ' + e.getMessage());
            System.debug('****************** errorMessage checkd_Discorda ' + e.getStackTraceString());
        }
        return casesWihtAnomalies;
    }
    /**------------------------------------------------------------------
     *@auhtor Madicke BALDE
     *@description check Discorda cellulare in case
     *@param Set<Id> : Set Id Case
     *@return List<Case>
     **---------------------------------------------------------------------*/
    public static List < Case > check_Discorda_cellulare(Set < Id > ids) {
        List < Case > cases = getCaseByIds(ids);
        List < Case > casesWihtAnomalies = getCaseByIds(ids);
        try {
            if (cases.size() > 0) {
                for (Case c: cases) {

                    if (!String.isBlank(c.RO_Vecchio_Cellulare__c)) {
                        casesWihtAnomalies.add(c);

                    }
                }
            }

        } catch (Exception e) {
            System.debug(' ******** error Message check_Discorda_cellulare ' + e.getMessage());

        }
        return casesWihtAnomalies;
    }
    /**------------------------------------------------------------------------
     *@author Madicke BALDE
     *@description get Case by codOcsPratica
     *@param codOcsPratica : 
     *@return Map<String ,Object>
     **-----------------------------------------------------------------------*/
    public static Map < String, Object > getCaseBycodOCSPratica(String codOcsPratica) {
        Map < String, Object > returnValue = new Map < String, Object > ();
        returnValue.put('exception', false);
        try {
            Case cas = [
                SELECT Id,
                AccountId,
                CaseNumber,
                Codice_Cliente__c,
                RO_Vecchio_Cellulare__c,
                RO_Nuovo_Cellulare__c,
                RO_Link_Bozza__c
                FROM Case
                WHERE NumeroPratica__c =: codOcsPratica
                LIMIT 1
            ];
            returnValue.put('case', cas);

        } catch (Exception ex) {
            System.debug(' ********** errorMessage getCaseBycodOCSPratica ' + ex.getMessage());
            returnValue.put('exception', true);
            returnValue.put('codeException', '[KO-Anomalie0003]');
        }

        return returnValue;
    }

    /* ---------------------------------------------------------------
     * Autheur : Sana Badji 
     * @param idsetCases
     * @param statoocs
     * @date  28/05/2019
     *-------------------------------------------------------------------*/
    public static void UpdateCaseStatoOcs(Set < Id > idCases, String statoocs) {
        try {
            List < Case > thisCase = [SELECT Id, stato_ocs__c FROM Case WHERE Id IN: idCases];
            System.debug('************ thisCase ' + thisCase);

            for (Case c: thisCase) {
                c.stato_ocs__c = statoocs;
                System.debug('************c.stato_ocs__c ' + c.stato_ocs__c);
            }
            upsert thisCase;
            System.debug('************  thisCase[0].stato_ocs__c ' + thisCase[0].stato_ocs__c);
            System.debug('************  thisCase[0].Id ' + thisCase[0].Id);
        } catch (Exception e) {
            System.debug('The following exception has occurred: ' + e.getMessage());
        }
    }
    /**--------------------------------------------------------------------
     * @author Madicke BALDE 
     * @description  get stato value of Case
     * @return SelectOption List
     *----------------------------------------------------------------------*/
    public static List < SelectOption > getStato_Value() {
        List < SelectOption > options = new List < SelectOption > ();
        try {
            Schema.DescribeFieldResult fieldResult = Case.Status.getDescribe();
            List < Schema.PicklistEntry > ple = fieldResult.getPicklistValues();
            for (Schema.PicklistEntry f: ple) {
                options.add(new SelectOption(f.getLabel(), f.getValue()));
            }

        } catch (Exception e) {
            System.debug(' ********** errorMessage ' + e.getMessage());
        }
        return options;
    }

    public static Boolean checkValueInCasePicklist(String value) {

        try {
            Schema.DescribeFieldResult fieldResult = Case.Status.getDescribe();
            List < Schema.PicklistEntry > ple = fieldResult.getPicklistValues();
            for (Schema.PicklistEntry t: ple) {
                System.debug('****** values t' + t.getValue());
                if (t.getValue().equals(value)) {
                    System.debug('YESSSSSSSSSSS');
                    return true;
                }
            }
            return false;

        } catch (Exception e) {
            System.debug('******** error Message checkValueInCasePicklist ' + e.getMessage());
            return false;
        }
    }

    public static List < Case > changeStatoCase(List < Case > caseLists, String stato) {
        try {
            if (caseLists.size() > 0) {
                if (checkValueInCasePicklist(stato)) {
                    for (Case c: caseLists) {
                        c.Status = stato;
                    }
                }

            }
        } catch (Exception e) {
            System.debug(' ************* changeStatoCase ' + e.getMessage());
        }
        return caseLists;
    }

    public static List < Case > getCaseByCCCF(String codiceCliente, String codiceFiscale) {
        System.debug(' *****************  codiceCliente ' + codiceCliente);
        System.debug(' *****************  codiceFiscale' + codiceFiscale);
        List < Case > listCases = new List < Case > ();
        if (!String.isBlank(codiceFiscale)) {
            listCases = [SELECT Product__c, CaseNumber, RO_fea__c, Tipo_Prodotto__c, NumeroPratica__c, Status, CreatedDate, RO_Link_Bozza__c, Codice_Cliente__c FROM Case WHERE Account.Codice_Fiscale__c =: codiceFiscale];
            System.debug('List case with codice fiscale ' + listCases.size());
            if (listCases.size() > 0)
                return listCases;
        }

        if (!String.isBlank(codiceCliente)) {
            System.debug(' ***************** ' + codiceCliente);
            listCases = [SELECT Product__c, Status, CreatedDate, RO_Link_Bozza__c, Codice_Cliente__c FROM Case WHERE Account.Codice_Cliente__c =: codiceCliente];
            System.debug('List case with codice cli9ente  new ' + listCases.size());
            return listCases;
        }
        return listCases;
    }

    public static void executeForTwentyHours(Map < Id, Case > caseMap) {
        System.debug('******************** executeForTwentyHours ****** ');
        if (caseMap.keySet().size() == 0) {
            return;
        } else {
            System.debug('******************** executeForTwentyHours else  ****** ');
            Map < String, String > returnValue = parseNameJobAndCronExp(24);
            System.debug('******************** namejob ****** ' + returnValue.get('namejob'));
            System.debug('******************** namejob ****** ' + returnValue.get('cronExp'));
        }
    }

    public static void getListCases(Map < Id, Case > caseMap) {
        try {
            List < Case > listCase = [
                SELECT Id, CreatedDate,
                LastModifiedDate,
                RO_Link_Bozza__c,
                RO_Engine_channel__c,
                Time30__c
                FROM Case
                WHERE(RO_Link_Bozza__c != null OR RO_Engine_channel__c != 'WEB') AND Id IN: caseMap.keySet()
            ];
            System.debug('******* listCase ' + listCase.size());
            for (Case c: listCase) {
                System.debug(' ********** test condition ');
                caseMap.remove(c.Id);
            }
        } catch (Exception e) {
            System.debug('*********** errorMessage ' + e.getMessage());
            System.debug('*********** errorMessage ' + e.getStackTraceString());
        }
    }

    public static Map < String, String > parseNameJobAndCronExp(Integer numberOfHours) {
        Map < String, String > returnValue = new Map < String, String > ();
        Datetime dt;
        dt = (Datetime.now()).addHours(numberOfHours);
        System.debug(' ************** dt parseNameJobAndCronExp  **** ' + dt);

        String cronExp = CGMWSUtils_1_0.formatedDatimeToStringSchedulable(dt);
        String namejob = 'schedule_Ds-' + cronExp;
        System.debug('******** cronExp ' + cronExp);
        returnValue.put('namejob', namejob);
        returnValue.put('cronExp', cronExp);
        return returnValue;
    }

    public static void addACaseToQueue(List < Case > casesList, String code) {
        Group gr;
        try {
            if (casesList == null || casesList.size() == 0) {
                return;
            } else {
                gr = [SELECT Id FROM Group WHERE Type = 'Queue'
                    AND DeveloperName =: code
                ];
                for (Case c: casesList) {
                    c.OwnerId = gr.Id;
                    System.debug('****** adding a Case to queur ');
                }
            }

        } catch (Exception e) {
            System.debug('***************** errorMessage **************** ' + e.getMessage());
            System.debug('**************** errorStackTrace ************* ' + e.getStackTraceString());

        }
    }

    public static Case getCaseBiId(Id idCase) {
        Case c = new Case();
        try {
            c = [
                SELECT Id, NumeroPratica__c,
                Codice_Cliente__c, pan__c, CreatedDate, LastModifiedDate,
                Account.LastName, Account.FirstName, tipo_Pratica__c,
                Account.PersonBirthdate, Account.Codice_Fiscale__c,
                Account.Phone, Account.Fax, Account.BusinessEmail__c, Account.ResidenceProvince__c,
                Account.Region_Name__c
                FROM Case
                WHERE Id =: idCase
            ];

        } catch (Exception e) {
            System.debug('*************** errorMessage ********* ' + e.getMessage());
            System.debug('*************** errorMessage ********* ' + e.getStackTraceString());
        }
        return c;
    }

    /**
     * @author Mame Bousso
     * @date  21/08/2019
     * @description Method to check event by codiceFiscale
     * @param String idCase. Id Case
     **/
    public static Boolean checkEventByCFAndCreateDate(Id idCase) {
        List < Event > events = new List < Event > ();
        Datetime today = Datetime.now();
        try {
            Case c = getCaseBiId(idCase);
            //events = [ Select Id FROM Event where Codice_Cliente__c = :c.Account.Codice_Fiscale__c  AND CreatedDate >= :c.CreatedDate AND ActivityDateTime > today];
            events = [Select Id FROM Event where Customer__r.Codice_Fiscale__c =: c.Account.Codice_Fiscale__c AND
                ActivityDateTime >=: c.CreatedDate AND ActivityDateTime >: today AND isChild = false AND Stato_Azione__c != 'Non presentato/Annullato'
            ];

            if (events.size() > 0) {
                return true;
            }
        } catch (Exception e) {
            System.debug('errorMessage getEventsByCliente' + e.getMessage());
            return false;
        }
        return false;
    }

    /**
     * @author Mame Bousso
     * @date  21/08/2019
     * @description Method to check case by modified date  
     * @param String idCase. Id Case
     **/
    public static Boolean checkLastModificationDate(Id idCase) {
        try {
            Case c = getCaseBiId(idCase);
            Datetime halfHourBack = Datetime.now().addMinutes(-30); //-30
            if (c.LastModifiedDate > halfHourBack) { // 30 minutes
                return false;
            }
        } catch (Exception e) {
            System.debug('errorMessage getEventsByCliente' + e.getMessage());
        }
        return true;
    }
    /**---------------------------------------------------------------------
     *@description update is discordaza cellulare
     *@
     *-------------------------------------------------------------------*/
    public static void casewithDiscordanza(Case c) {
        c.Is_Discordanza_Cellulare__c = true;
        update c;
    }

    public static String getNumeroPratica(Id idCase) {
        Case c = [SELECT Id, NumeroPratica__c FROM Case WHERE Id =: idCase];
        return c.NumeroPratica__c;
    }


    /**
     * @author SANA BADJI
     * @date  14/11/2019
     * @description Method to check case before delete 
     * @param String idCase
     **/
    Public static void checkCaseToInsertBeforeDelete(Set < Id > caseIds) {
        List < Case > listCaseToDelete = new List < Case > ();
        List < Case > cases = CaseSelector.getCaseWebservice(caseIds);
        String numPratica;
        List < Case > listeNumpratica = CaseSelector.getNumeroPratica();
        Set < String > numPraticaExist = new Set < String > ();
        System.debug('************cases ' + cases);
        try {
            for (Case cnum: listeNumpratica) {
                numPraticaExist.add(cnum.NumeroPratica__c);
            }
            System.debug('************ cases ' + cases);
            for (Case c: cases) {
                numPratica = c.NumeroPratica__c;
                if (numPraticaExist.contains(numPratica)) {
                    listCaseToDelete.add(c);
                }
            }
            System.debug('************listCaseToDelete ' + listCaseToDelete.size());
            if (!listCaseToDelete.isEmpty()) {
                Recursion.isTriggerExecuting = true;
                delete listCaseToDelete;
                System.debug('************Recursion.isTriggerExecuting After ' + Recursion.isTriggerExecuting);
            }

        } catch (Exception e) {
            //Recursion.isTriggerExecuting=true;}
            System.debug('The following exception has occurred: ' + e.getMessage());
            System.debug('errorStract' + e.getStackTraceString());
            System.debug('cases: ' + cases);
            System.debug('************ finish methode');
        }
    }

    public static Boolean checkCRMStepLogInLast30Mn(String idCase) {
        Id recordTypeId = CGMWSUtils_1_0.getRecordTypeId('RO_CRMRich_online_steplog__c', 'RO_CRMRichiesta_Online');
        Case caseObject = [SELECT Id, (SELECT Id, CreatedDate, Ro_DeveloperName__c FROM Rich_online_steplogs__r WHERE RecordTypeId =: recordTypeId ORDER BY CreatedDate DESC LIMIT 1)
            FROM Case WHERE Id =: idCase
        ];
        Datetime last30mn = Datetime.now().addMinutes(-30);
        Map < Id, Boolean > returnValue = new Map < Id, Boolean > ();
        Boolean isIn = (caseObject.Rich_online_steplogs__r.size() > 0 && caseObject.Rich_online_steplogs__r[0].Ro_DeveloperName__c != 'Q525' && caseObject.Rich_online_steplogs__r[0].CreatedDate > last30mn) ? true : false;
        return isIn;
    }
	
	public static Boolean isCaseModifiedInLast30Minutes(String idCase) {
        Id recordTypeId = CGMWSUtils_1_0.getRecordTypeId('RO_CRMRich_online_steplog__c', 'RO_CRMRichiesta_Online');
        Case caseObject = [SELECT Id, (SELECT Id, CreatedDate, Ro_DeveloperName__c, RO_CRMStep__c FROM Rich_online_steplogs__r WHERE RecordTypeId =: recordTypeId ORDER BY CreatedDate DESC LIMIT 1)
            FROM Case WHERE Id =: idCase
        ];
        RO_CRMRich_online_steplog__c stepLog = caseObject.Rich_online_steplogs__r[0];
        System.debug('caseObject.Rich_online_steplogs__r.size(): ' + caseObject.Rich_online_steplogs__r.size());
        if (caseObject.Rich_online_steplogs__r.size() == 0) return false;
        System.debug('stepLog.Ro_DeveloperName__c: ' + stepLog.Ro_DeveloperName__c);
        if (stepLog.Ro_DeveloperName__c == 'Q525') return false;
        System.debug('stepLog.RO_CRMStep__c: ' + stepLog.RO_CRMStep__c);
        if (stepLog.RO_CRMStep__c == 'SELF') return false;

        DateTime now = Datetime.now();
        DateTime lastModify = stepLog.CreatedDate;

        Date lastModifyDateGMT = lastModify.dateGMT();
        Time lastModifyTimeGMT = lastModify.timeGMT();

        DateTime lastModifyGMT = Datetime.newInstanceGMT(lastModifyDateGMT, lastModifyTimeGMT);

        Boolean bool = lastModifyGMT > now.addMinutes(-CGMWSUtils_1_0.GIACENZA_PRECARICO) ? true : false;
        System.debug('isCaseModifiedInLast30Minutes: ' + bool);
        return bool;
    }

    public static DateTime getLastModifiedDate(String idCase) {
        Id recordTypeId = CGMWSUtils_1_0.getRecordTypeId('RO_CRMRich_online_steplog__c', 'RO_CRMRichiesta_Online');
        Case caseItem = [SELECT Id, LastModifiedDate from Case where Id =: idCase];
        List<RO_CRMRich_online_steplog__c> stepLogs = [SELECT Id, CreatedDate, RO_CRMStep__c FROM RO_CRMRich_online_steplog__c WHERE RecordTypeId =: recordTypeId AND RO_CRMRichiesta_Online__c =: idCase ORDER BY CreatedDate DESC];
        
        DateTime lastModify = caseItem.LastModifiedDate;

        if (stepLogs.size() == 0) return lastModify;

        for (RO_CRMRich_online_steplog__c stepLog : stepLogs) {
            if (stepLog.RO_CRMStep__c == 'SELF') continue;
            return stepLog.CreatedDate;
        }
        
        return lastModify;
    }

}