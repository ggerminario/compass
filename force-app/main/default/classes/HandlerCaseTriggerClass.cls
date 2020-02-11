public class HandlerCaseTriggerClass {
    public static Boolean afterThirtyMinutes = true;
    public static Boolean afterSeventyTwoHours = false;
    public static Boolean afterTwentyFourHours = false;
    public static String cronExpTwentyFourHoursAfter;
    public static String cronExpSeventyTwoHoursAfter;
    public static Map <Id, Case> casesMap;
    public static final String AFTER_THIRTY_MINUTES = 'afterThirtyMinutes';
    public static final String AFTER_SEVENTY_TWO_HOURS = 'afterSeventyTwoHours';
    public static final String AFTER_TWENTY_FOUR_HOURS = 'afterTwentyFourHours';
    public static Map <Id, Case> mapCases = new Map <Id, Case>();

    public static void contattiInFaseDiCaricoDSPrimoInvio(List <Case> casesList) {
        System.debug(' *********** running contattiInFaseDiCaricoDSPrimoInvio  ');
        casesMap = new Map <Id, Case> (casesList);
        System.debug('***************** casesList[0].Time30__c ' + casesList[0].Time30__c);
        String cronExp = CGMWSUtils_1_0.formatedDatimeToStringSchedulable(casesList[0].Time30__c);
        System.debug('cronExp  ' + cronExp);
        String namejob = 'schedule_Ds-' + cronExp;
    }

    public static void aggiornamentoHandler(List <Case> caseList) {
        System.debug('####################  aggiornamentoHandler test running');
        Map <Id, Case> mapCases = new Map <Id, Case> ();
        Group g = CaseService.getQueue('Q333');
        for (Case c: caseList) {
            if (c.OwnerId != g.Id) {
                if (!mapCases.containsKey(c.Id)) {
                    mapCases.put(c.Id, c);
                }
            }
        }

        executeJobAfterThirtyMinutes(mapCases);
    }

    public static Map <Id, Case> caseHandlerDispatcher(List <Case> caseList) {
        System.debug('**************** caseHandlerDispatcher ************ ');
        Map <Id, Case> returnCase = new Map <Id, Case>();
        Map <String, List <Case>> caseMapList = DsEcomDSPaggiornamento(caseList);
        System.debug('############  caseMapList ' + caseMapList);
        AggiornamentoPraticeDS.aggiornamentoDS(caseMapList.get('DS'), returnCase);
        AggiornamentoPraticeDSP.aggiornamentoDSP(caseMapList.get('DSP'), returnCase);
        return returnCase;
    }

    public static Map <String, List <Case>> DsEcomDSPaggiornamento(List <Case> caseList) {
        Map <String, List <Case>> mapCases = new Map <String, List <Case>> ();
        try {
            List <Case> listCaseWithProductFamily = [SELECT Id,
                Product__c,
                Product__r.DEMAbbandono__c,
                Product__r.DEMAbbandonoForz__c,
                Product__r.DEMAbbandonoNONForzPreSecci__c,
                Product__r.DEMAbbandonoPostSecci__c,
                Product__r.DEMAbbandonoPreSecci__c,
                Product__r.DEMAbbandonoWEBPostSecci__c,
                Product__r.DEMAbbandonoWEBPreSecci__c,
                Product__r.DEMAnomalie__c,
                Product__r.DEMAnomalieContratto__c,
                Product__r.DEMAnomalieDoc__c,
                Product__r.DEMNonTrovato__c,
                Product__r.DEMNonTrovatoAnomalie__c,
                Product__r.DEMNonTrovatoAnomaliePostSIC__c,
                Product__r.DEMNonTrovatoAnomaliePreSIC__c,
                Product__r.DEMNonTrovatoFirmaContratto__c,
                Product__r.DEMNumeroInesistenteContratto__c,
                Product__r.DEMRassicuraCliente__c,
                Product__r.DEMRipresaBozza__c,
                Product__r.SMSAbbandonoForz__r.Name,
                Product__r.SMSAbbandonoNONForzPreSecci__r.Name,
                Product__r.SMSAbbandonoPostSecci__r.Name,
                Product__r.SMSAbbandonoPreSecci__r.Name,
                Product__r.SMSAbbandonoWEBPostSecci__r.Name,
                Product__r.SMSAbbandonoWEBPreSecci__r.Name,
                Product__r.SMSAnomalieContratto_DS__r.Name,
                Product__r.SMSAnomalieDoc_DS__r.Name,
                Product__r.SMSNonTrovatoAnomaliePostSIC_DS__r.Name,
                Product__r.SMSNonTrovatoAnomaliePreSIC_DS__r.Name,
                Product__r.SMSNonTrovatoFirmaContratto_DS__r.Name,
                Product__r.SMSRassicuraCliente_DS__r.Name,
                Product__r.SMSTentativoDiContatto__r.Name,
                RO_Vecchio_Cellulare__c,
                RO_Link_Bozza__c,
                RO_Engine_channel__c,
                Account.getCodice_Cliente__c,
                NumeroPratica__c,
                Time30__c,
                Status,
                Richiesta_appuntamento__c,
                Account.Codice_Fiscale__c,
                RO_Current_Step__c,
                AccountId,
                Account.PersonEmail,
                Account.PersonMobilePhone,
                (SELECT Id, descrizione_Documento__c FROM Anomalie_Doc__r),
                RO_fea__c,
                Account.Phone,
                Tipo_Prodotto__c,
                LastModifiedDate,
                Product__r.Family,
                (SELECT Id, RO_CRMModalita_richiesta__c FROM Rich_online_steplogs__r)
                FROM Case WHERE Id IN: caseList
            ];

            System.debug('************ Liste Case size ' + listCaseWithProductFamily.size());

            for (Case c: listCaseWithProductFamily) {
                switch on c.Product__r.Family {
                    when 'PP_ONLINE_COMPASS_DS' {
                        if (!mapCases.containsKey('DS')) {
                            mapCases.put('DS', new List <Case> {c});
                        } else {
                            List <Case> cases = mapCases.get('DS');
                            cases.add(c);
                            mapCases.put('DS', cases);
                        }
                        System.debug('######################## DS test ' + mapCases);
                    }
                    when 'PP_ONLINE_PARTNER_DS' {
                        if (!mapCases.containsKey('DSP')) {
                            mapCases.put('DSP', new List <Case> {c});
                        } else {
                            List <Case> cases = mapCases.get('DSP');
                            cases.add(c);
                            mapCases.put('DSP', cases);
                        }
                    }
                    when 'PF_ECOMMERCE_STANDARD' {
                        if (!mapCases.containsKey('ECOM')) {
                            mapCases.put('ECOM', new List <Case> {c});
                        } else {
                            List <Case> cases = mapCases.get('ECOM');
                            cases.add(c);
                            mapCases.put('ECOM', cases);
                        }
                    }
                }
            }
            System.debug('Map' + mapCases);
            System.debug('Map Size ' + mapCases.keySet().size());
        } catch (Exception e) {
            System.debug(' *************** errorMessage aggiornamentoHandler ' + e.getMessage());
            System.debug(' *************** errorMessage aggiornamentoHandler ' + e.getStackTraceString());
        }
        return mapCases;
    }

    public static void schedulableJobs(Map <Id, Case> caseMap) {
        System.debug('*********** executing  schedulableJobs ******');
        System.debug('*********** executing  schedulableJobs ******' + caseMap);
        System.debug('*********** executing  schedulableJobs  ******' + caseMap.size());
        if (caseMap == null || caseMap.size() == 0) {
            return;
        } else {
            System.debug('*********** shedulable job tses ttest  schedulableJobs ');
            System.debug('*********** taille du Map ' + caseMap.keySet().size());
            CGMWSUtils_1_0.schedulableJobexecute(caseMap, AFTER_TWENTY_FOUR_HOURS, 24);
            // System.schedule(jobName, cronExp, schedulable);
        }
    }

    public static void executeJobAfterSeventyTwoHours(Map <Id, Case> caseMap) {
        if (caseMap == null || caseMap.size() == 0) {
            return;
        } else {
            System.debug('************* executeJobAfterSeventyTwoHours' + caseMap.keySet().size());
            CGMWSUtils_1_0.schedulableJobexecute(caseMap, AFTER_SEVENTY_TWO_HOURS, 72);
        }
    }

    public static void executeJobAfterThirtyMinutes(Map <Id, Case> caseMap) {
        if (caseMap == null || caseMap.size() == 0) {
            return;
        } else {
            System.debug('************* executeJobAfterThirtyMinutes' + caseMap.keySet().size());
            CGMWSUtils_1_0.schedulableJobexecute(caseMap, AFTER_THIRTY_MINUTES);
        }
    }
}