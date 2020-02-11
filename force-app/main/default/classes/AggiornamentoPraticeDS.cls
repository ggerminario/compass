/********************************************************************************
  *@Author Madicke BALDE 
  *@description Apex Class Contatti con il cliente in fase di Carico : Digital Strategy (DS)
  *@Date : 

 *****************************************************************************************/
public class AggiornamentoPraticeDS {

    public static Map < Id, Case > caseMaps;
    public static Map < Id, Case > caseMapsPrimoDs = new Map < Id, Case > ();
    public static Map < Id, Case > caseMapsPostSecciDs = new Map < Id, Case > ();
    public static Map < Id, Case > caseMapsnonForzosoCheAbbandonaDs = new Map < Id, Case > ();
    public static Map < Id, Case > caseMaps_Ricontatto_ClienteForzoso_FilialeDS = new Map < Id, Case > ();
    public static Map < Id, Case > caseMaps_Ricontatto_ClienteCheSceglieDS = new Map < Id, Case > ();
    public static final String AFTER_TWENTY_FOUR_HOURS = 'afterTwentyFourHours';
    public static final String AFTER_SEVENTY_TWO_HOURS = 'afterSeventyTwoHours';

    public static final String AFTER_TWENTY_FOUR_HOURS_POST_SECCI = 'afterTwentyFourHoursPostSecci';
    public static final String AFTER_SEVENTY_TWO_HOURS_POST_SECCI = 'afterSeventyTwoHoursPostSecci';
    public static Map < Id, Case > caseMapFS = new Map < Id, Case > ();

    public static final String AFTER_TWENTY_FOUR_HOURS_NON_FORZOSO_CHE_ABBANDONA = 'afterTwentyFourHoursnonForzosoCheAbbandona';
    public static final String AFTER_SEVENTY_TWO_HOURS_NON_FORZOSO_CHE_ABBANDONA = 'afterSeventyTwoHoursnonForzoso';

    public static final String AFTER_TWENTY_FOUR_HOURS_FORZOSO_FILIALEDS = 'afterTwentyFourHoursForzosoFiliale';
    public static final String AFTER_SEVENTY_TWO_HOURS_FORZOSO_FILIALEDS = 'afterSeventyTwoHoursForzosoFiliale';
    public static final Datetime dateTimeNow = Datetime.now();

    /**
     *@Author Madicke BALDE
     *@
     *@param caseList : Case List
     *@param casesR :
     */
    public static void aggiornamentoDS(List<Case> caseList, Map<Id,Case> casesR) {
        System.debug('******************* running aggiornamentoDS  ');
        if (caseList == null || caseList.size() == 0) {
            return;
        } 

        System.debug('******************* running aggiornamentoDS else ');
        Recursion.isBeforeTriggerExcecuting = true;
        caseMaps = new Map <Id, Case> (caseList);
        System.debug('******************* caseMaps aggiornamentoDS  ' + caseMaps.keySet().size());
        abbandonaPrimaDelSecci(caseMaps, casesR);
        abbandonaPostSecci(caseMaps, casesR);
        nonForzosoCheAbbandona(caseMaps, casesR);
        ricontattoClienteForzosoFilialeDS(caseMaps, casesR);
        
        System.debug('************** Case Map at the finish *********** ' + caseMaps);
        System.debug('************** caseMapFS ****  ' + caseMapFS.keySet().size());
    }

    @InvocableVariable(label='Case')
    public Case c;

    @InvocableMethod
    public static void abbandonaPrimaDelSecci(List<Case> cases) {
        System.debug('!!!!!!!PROCESS BUIDER!!!!!!' + cases);
        Map <Id,Case> caseMap = new Map<Id,Case>();
        /*
        List<String> idList = new List<String>();
        for (CaseIds ids : caseIds) {
            System.debug('!!!!!!!PROCESS BUIDER!!!!!! Case ids ' + ids);
            System.debug('!!!!!!!PROCESS BUIDER!!!!!! Case ids.caseId ' + ids.caseId);
            idList.add(ids.caseId);
        }
        List<Case> cases = [SELECT Id, Status, RO_Link_Bozza__c, RO_Engine_channel__c, LastModifiedDate FROM Case where Id IN :idList];
        System.debug('!!!!!!!PROCESS BUIDER!!!!!! found ' + cases.size() + ' cases');
        */
        for (Case cas : cases) {
            caseMap.put(cas.Id, cas);
        }
        Map <Id,Case> casesR = new Map<Id,Case>();
        // abbandonaPrimaDelSecci(caseMap, casesR); // TODO
    }

    public class CaseIds {
        @InvocableVariable
        public String caseId;
    }

    /********************************************************************************
     *@Author Madicke BALDE
     *@description : Cliente web che abbandona prima del secci.
     *@param caseMap : Case Map
     *@param casesR : 
     */
    public static void abbandonaPrimaDelSecci(Map < Id, Case > caseMap, Map < Id, Case > casesR) {
        System.debug('************** running abbandonaPrimaDelSecci  dateTimeNow' + dateTimeNow);
        try {
            if (caseMap == null || caseMap.size() == 0) {
                return;
            } 
            System.debug('************** map size before ' + caseMap.keySet().size());

            for (Id key: caseMap.keySet()) {
                String linkBozza = caseMap.get(key).RO_Link_Bozza__c;
                String engineChannel = caseMap.get(key).RO_Engine_channel__c;
                String status = caseMap.get(key).Status;
                Boolean isLastModifiedDateIn30Mins = CGMWSUtils_1_0.DatetimeWithin30mn(CaseService.getLastModifiedDate(key), dateTimeNow);
                
                System.debug('************** running abbandonaPrimaDelSecci  linkBozza ' + linkBozza);
                System.debug('************** running abbandonaPrimaDelSecci  engineChannel ' + engineChannel);
                System.debug('************** running abbandonaPrimaDelSecci  status ' + status);
                System.debug('************** running abbandonaPrimaDelSecci  isLastModifiedDateIn30Mins ' + isLastModifiedDateIn30Mins);
                
                if (String.isBlank(linkBozza) && engineChannel == 'W' && isLastModifiedDateIn30Mins && status != 'Gestito') {
                    System.debug('************** running abbandonaPrimaDelSecci  if yes ');
                    System.debug('************** running abbandonaPrimaDelSecci  key ' + key);
                    System.debug('************** running abbandonaPrimaDelSecci  key ' + caseMap.get(key));
                    caseMapsPrimoDs.put(key, caseMap.get(key));
                    casesR.put(key, caseMap.get(key));
                    HandlerCaseTriggerClass.mapCases.put(key, caseMap.get(key));
                    caseMap.remove(key);
                }
            }

            // launch batch 24
            System.debug('************** map size  after ' + caseMap.keySet().size());
            System.debug('************** caseMapsPrimoDs size ' + caseMapsPrimoDs.size());
            inviiSuccessivi24hPrimaDelSecci(caseMapsPrimoDs);
        } catch (Exception e) {
            System.debug('*************** errorMessage abbandonaPrimaDelSecci ' + e.getMessage());
            System.debug('*********** abbandonaPrimaDelSecci ' + e.getStackTraceString());
        }

    }

    /*************************************************************************
      *@Author Madicke BALDE 
      *@param  caseMap : Case Map
     */
    public static void inviiSuccessivi24hPrimaDelSecci(Map < Id, Case > caseMap) {
        System.debug('************** running inviiSuccessivi24h ' + caseMap);
        try {
            if (caseMap == null || caseMap.keySet().size() == 0) {
                System.debug('************** running inviiSuccessivi24h  Nooooooooo');
                return;
            } else {
                // Call invio DEM
                CGMWSUtils_1_0.sendInvioDemAndSMS(caseMap, 'DEMAbbandonoWEBPreSecci', '2059', 'SMSAbbandonoWEBPreSecci', 'richiedi il tuo Prestito Online Compass!', 'richiesta@compass.it', 'Compass Banca S.p.A ');
                CaseDomain.createNote('Invia Mail:DEMAbbandonoWEBPreSecci(2059)', caseMap.values()[0]);
                // Call SMS
                System.debug('************** running inviiSuccessivi24h else  ');
            }

        } catch (Exception e) {
            System.debug(' ************ errorMessage nviiSuccessivi24h  ' + e.getMessage());
            System.debug(' ************ errorMessage nviiSuccessivi24h  ' + e.getStackTraceString());
        }
    }

    public static void abbandonaPostSecci(Map < Id, Case > caseMap, Map < Id, Case > casesR) {
        System.debug('************************* running  abbandonaPostSecci ' + caseMap.keySet().size());
        if (caseMap == null || caseMap.size() == 0) {
            return;
        } else {
            for (Id idCase: caseMap.keySet()) {
                System.debug('************ Id' + (caseMap.get(idCase)).Id);
            }
            getCaseAbbandonaPostSecci(caseMap, casesR);
        }
        System.debug('**************** Post Secci DS ' + caseMapsPostSecciDs.size());
        abbandonaPostSecciAzioni(caseMapsPostSecciDs);
    }

    public static void getCaseAbbandonaPostSecci(Map < Id, Case > caseMap, Map < Id, Case > casesR) {
        Map < Id, Case > mapCases = new Map < Id, Case > ();
        try {
            if (caseMap == null || caseMap.size() == 0) {
                return;
            } 
            for (Id key: caseMap.keySet()) {
                String linkBozza = caseMap.get(key).RO_Link_Bozza__c;
                String engineChannel = caseMap.get(key).RO_Engine_channel__c;
                String status = caseMap.get(key).Status;
                String numPratica = caseMap.get(key).NumeroPratica__c;
                Boolean isLastModifiedDateIn30Mins = CGMWSUtils_1_0.DatetimeWithin30mn(CaseService.getLastModifiedDate(key), dateTimeNow);
                                
                System.debug('************** running abbandonaPostSecci  linkBozza ' + linkBozza);
                System.debug('************** running abbandonaPostSecci  engineChannel ' + engineChannel);
                System.debug('************** running abbandonaPostSecci  status ' + status);
                System.debug('************** running abbandonaPostSecci  numPratica ' + numPratica);
                System.debug('************** running abbandonaPostSecci  isLastModifiedDateIn30Mins ' + isLastModifiedDateIn30Mins);
                
                if (String.isNotBlank(linkBozza) && engineChannel == 'W' && status != 'Gestito' && numPratica == null && isLastModifiedDateIn30Mins) {
                    System.debug('************** running getCaseAbbandonaPostSecci  abbandonaPrimaDelSecci  if yes ');
                    caseMapsPostSecciDs.put(key, caseMap.get(key));
                    casesR.put(key, caseMap.get(key));
                    HandlerCaseTriggerClass.mapCases.put(key, caseMap.get(key));
                    caseMap.remove(key);
                }
            }
        } catch (Exception e) {
            System.debug('**************** errorMessage getCaseAbbandonaPostSecci ' + e.getMessage());
            System.debug('**************** errorMessage getCaseAbbandonaPostSecci ' + e.getStackTraceString());
        }
    }
    /*
     *@author Madicke BALDE
     *@description 
     *@param Map Case
     *
     */
    public static void abbandonaPostSecciAzioni(Map < Id, Case > caseMap) {
        if (caseMap == null || caseMap.size() == 0) {
            return;
        } else {
            System.debug('changing queue post secci');
            Group g = CaseService.getQueue('Q330');
            if (g != null) {
                for (Id idcase: caseMap.keySet()) {
                    (caseMap.get(idcase)).OwnerId = g.Id;
                }
                Recursion.isBeforeTriggerExcecuting = true;
                Recursion.isTriggerExecuting = true;
                System.debug('Updating queue...');
                update caseMap.values();
                System.debug('Queue updated');
            }
            System.debug('GMWSUtils_1_0.sendInvioDemAndSMS');
            CGMWSUtils_1_0.sendInvioDemAndSMS(caseMap, 'DEMAbbandonoWEBPostSecci', '2060', 'SMSAbbandonoWEBPostSecci', '', 'richiesta@compass.it', 'Compass Banca S.p.A ');
            System.debug('CaseDomain.createNote');
            CaseDomain.createNote('Invia Mail:DEMAbbandonoWEBPostSecci(2060)', caseMap.values()[0]);
        }
    }

    public static void addCaseToQueue(List < Case > casesList, String code) {
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
                }
            }

        } catch (Exception e) {
            System.debug('***************** errorMessage **************** ' + e.getMessage());
            System.debug('**************** errorStackTrace ************* ' + e.getStackTraceString());

        }
    }


    /**  *********************   Cliente non forzoso che abbandona ***********************************  ****/
    public static void nonForzosoCheAbbandona(Map < Id, Case > caseMap, Map < Id, Case > casesR) {
        System.debug('###################### nonForzosoCheAbbandona');
        if (caseMap == null || caseMap.size() == 0) {
            return;
        } else {
            Map < String, Event > eventMaps = appuntamentoCercaActive(caseMap);
            for (Id idCase: caseMap.keySet()) {
                System.debug('##################  RO_Engine_channel__c' + (caseMap.get(idCase)).RO_Engine_channel__c);
                System.debug('##################  NumeroPratica__c' + (caseMap.get(idCase)).NumeroPratica__c);
                System.debug('##################  RO_Current_Step__c' + (caseMap.get(idCase)).RO_Current_Step__c);
                if ((caseMap.get(idCase)).RO_Engine_channel__c == 'F' &&
                    (caseMap.get(idCase)).Status != 'Gestito' &&
                    (caseMap.get(idCase)).NumeroPratica__c == null &&
                    /*(caseMap.get(idCase)).RO_Current_Step__c != 'Step 2 - Scelta cliente' &&*/
                    AppuntamentoDomainWS.checkIfClienteHasAppuntamento(eventMaps, (caseMap.get(idCase)).Account.Codice_Fiscale__c) == false &&
                    CGMWSUtils_1_0.DatetimeWithin30mn(CaseService.getLastModifiedDate(idCase), dateTimeNow) &&
                    RichOnlineSteplogService.seracrModalitaRichesta((caseMap.get(idCase)).Rich_online_steplogs__r)) {
                    System.debug('############# nonForzosoCheAbbandona ok');
                    caseMapsnonForzosoCheAbbandonaDs.put(idCase, caseMap.get(idCase));
                    // caseMapFS.put(idCase,  caseMap.get(idCase) );
                    casesR.put(idCase, caseMap.get(idCase));
                    HandlerCaseTriggerClass.mapCases.put(idCase, caseMap.get(idCase));
                    caseMap.remove(idCase);

                }
            }
            System.debug('*****************  caseMapsnonForzosoCheAbbandonaDs ' + caseMapsnonForzosoCheAbbandonaDs.keySet().size());
            //sendInvioDemSMS(caseMapsnonForzosoCheAbbandonaDs);
            forzosoCheAbbandonaDsAzioni(caseMapsnonForzosoCheAbbandonaDs);
        }
    }
    /***************************************************************************************************************
      *@Author Madicke BALDE
      *@description 
      *@param 
      
     ******************************************************************************************************************/
    public static void forzosoCheAbbandonaDsAzioni(Map < Id, Case > caseMap) {
        if (caseMap == null || caseMap.size() == 0) {
            return;
        } else {
            System.debug('################# forzosoCheAbbandonaDsAzioni ');
            Group g = CaseService.getQueue('Q331');
            if (g != null) {
                for (Id idcase: caseMap.keySet()) {
                    (caseMap.get(idcase)).OwnerId = g.Id;
                }
                Recursion.isBeforeTriggerExcecuting = true;
                Recursion.isTriggerExecuting = true;
                update caseMap.values();
            }
            CGMWSUtils_1_0.sendInvioDemAndSMS(caseMap, 'DEMAbbandonoNONForzPreSecci', '2061', 'SMSAbbandonoNONForzPreSecci', 'fissa un appuntamento per il tuo Prestito Compass!', 'richiesta@compass.it', 'Compass Banca S.p.A ');
            CaseDomain.createNote('Invia Mail:DEMAbbandonoNONForzPreSecci(2061)', caseMap.values()[0]);
        }
    }


    /** *********************  Ricontatto cliente forzoso filiale *************************** */
    public static void ricontattoClienteForzosoFilialeDS(Map < Id, Case > caseMap, Map < Id, Case > casesR) {
        System.debug('**************** running ************ ricontattoClienteForzosoFilialeDS ');
        if (caseMap == null || caseMap.size() == 0) {
            return;
        } else {
            Map < String, Event > eventMaps = appuntamentoCercaActive(caseMap);
            for (Id idCase: caseMap.keySet()) {
                if (caseMap.get(idCase).RO_Engine_channel__c == 'FF' &&
                    caseMap.get(idCase).NumeroPratica__c == null &&
                    (caseMap.get(idCase)).Status != 'Gestito' &&
                    AppuntamentoDomainWS.checkIfClienteHasAppuntamento(eventMaps, (caseMap.get(idCase)).Account.Codice_Fiscale__c) == false &&
                    CGMWSUtils_1_0.DatetimeWithin30mn(CaseService.getLastModifiedDate(idCase), dateTimeNow)) {

                    caseMaps_Ricontatto_ClienteForzoso_FilialeDS.put(idCase, caseMap.get(idCase));
                    casesR.put(idCase, caseMap.get(idCase));
                    HandlerCaseTriggerClass.mapCases.put(idCase, caseMap.get(idCase));
                    caseMap.remove(idCase);
                }
            }
            System.debug('**************** ricontattoClienteForzosoFilialeDS size ' + caseMaps_Ricontatto_ClienteForzoso_FilialeDS.keySet().size());
            ricontattoClienteForzosoFilialeDSAzioni(caseMaps_Ricontatto_ClienteForzoso_FilialeDS);
        }
    }
    public static void ricontattoClienteForzosoFilialeDSAzioni(Map < Id, Case > caseMap) {
        if (caseMap == null || caseMap.size() == 0) {
            return;
        } else {
            Group g = CaseService.getQueue('Q332');
            if (g != null) {
                for (Id idcase: caseMap.keySet()) {
                    (caseMap.get(idcase)).OwnerId = g.Id;
                }
                Recursion.isBeforeTriggerExcecuting = true;
                update caseMap.values();
            }
            CGMWSUtils_1_0.sendInvioDemAndSMS(caseMap, 'DEMAbbandonoForz', '2062', 'SMSAbbandonoForz', ' vieni in Filiale per il tuo Prestito Compass!', 'richiesta@compass.it', 'Compass Banca S.p.A ');
            CaseDomain.createNote('Invia Mail:DEMAbbandonoForz(2062)', caseMap.values()[0]);
        }
    }

    /**************************************************************
     *@Author Madicke BALDE
     *@description search an appointment for a client
     *@param  codiceFiscale : Codice Fiscale Client
     *@return Boolean
     **************************************************************************/
    public static Map < String, Event > appuntamentoCercaActive(Map < Id, Case > caseMap) {
        Map < String, Event > eventMaps = new Map < String, Event > ();
        Set < String > codiceFiscales = new Set < String > ();
        for (Id key: caseMap.keySet()) {
            if (String.isNotBlank(caseMap.get(key).Account.Codice_Fiscale__c)) {
                codiceFiscales.add((caseMap.get(key).Account.Codice_Fiscale__c));
            }

        }

        List < Event > eventActifs = AppuntomentoQuery.appuntomentoCercaActive(codiceFiscales);
        if (eventActifs.size() > 0) {
            for (Event ev: eventActifs) {
                if (!eventMaps.keySet().contains(ev.Customer__r.Codice_Fiscale__c)) {
                    eventMaps.put(ev.Customer__r.Codice_Fiscale__c, ev);
                }
            }

        }
        return eventMaps;
    }

    public static Boolean checkIfClienteHasAppuntamento(Map < String, Event > mapEvents, String codicefIscale) {
        Boolean hasAppuntamento = false;
        if (mapEvents.get(codicefIscale) != null) {
            hasAppuntamento = true;
        }
        return hasAppuntamento;
    }
}