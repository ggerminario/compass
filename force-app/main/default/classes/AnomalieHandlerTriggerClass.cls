/* Autheur : Sana Badji 
   @date  16/05/2019
 */

public with sharing class AnomalieHandlerTriggerClass {
    public Static boolean Compute = true;
    public static String cronAfterThreeHours;
    public static String cronAfterThirtyMinutes;
    public static String cronAfterTwoHours;
    public static String cronAfterFiveDays;
    public static final String AFTER_THIRTY_MINUTES = 'afterThirtyMinutes';
    public static final String AFTER_THREE_THREE_HOURS = 'afterThreeHours';
    public static final String AFTER_TWO_TWO_HOURS = 'afterTwoHours';
    public static List < Case > caseProductDS = new List < Case > ();
    public static List < Case > caseProductDSP = new List < Case > ();
    public static List < Case > caseProductEcommerce = new List < Case > ();
    public static Set < Id > casePreUscitaCoda = new Set < Id > ();

    /**
     * @author Madicke BALDE
     *@description methode execute after insert
     *@param Anomalies List
     */
    public static void AfterInsertAnomalieDoc(List < Anomalie_Doc__c > list_anomalies) {
        if (compute) {
            System.debug('############################## list anomalie ' + list_anomalies);
            Case c = [SELECT Id, (SELECT Id, codice_Anomalia__c, Codice_Documento__c, descrizione_Documento__c FROM Anomalie_Doc__r), Is_Discordanza_Cellulare__c, Product__r.Family FROM Case WHERE Id =: list_anomalies[0].CaseId__c];
            System.debug('####################################### in trigger c.Is_Discordanza_Cellulare__c ' + c.Is_Discordanza_Cellulare__c);
            CaseDomain.createNtote('Anomalie Doc. E-commerce', c, 'Anomalie');
            if (c.Product__r.Family != 'PF_ECOMMERCE_STANDARD') {
                return;
            }
            if (c.Is_Discordanza_Cellulare__c == true) {
                CaseDomain.mailDem('2072', c.Id, 'Anomalie Doc. E-commerce ', 'noreply@compass.it', 'Compass Banca S.P.A.');
                String name = 'ScheduleBatchAnomalieDoc' + String.valueOfGmt(list_anomalies[0].CreatedDate);
                //***** retrieve CreatedDate for Anomalie_Doc__c
                Datetime createdDate = list_anomalies[0].CreatedDate;
                XCS_CompassParameters__c cp = XCS_CompassParameters__c.getValues('Number_of_hours');
                System.debug('####################### cp ' + cp);
                String executionDate = CGMWSUtils_1_0.formatDate(createdDate, (Integer) cp.Number_of_hours__c);
                System.debug('*********** test ******** ' + executionDate);
                System.debug('*********** test 2 ******** ');
                //**** schedulable the batch
                AnomalieDocService.shedulableAnomalieBatch(list_anomalies, name, executionDate);
            }


        }

    }

    /*  
     * Autheur : Sana Badji 
     * @param anoList
     * @param idsToProcess
     * @param Date Time
     * @date  19/11/2019
     */
    public static void anomalieHandlerDispatcher(List < Anomalie_Doc__c > anoList, Set < Id > idsToProcess) {
        String statoOcs;
        String descrizioneAno;
        boolean isDusco;
        Map < String, String > descrizioneAnoMap = new Map < String, String > ();
        Map < String, String > newTrigger = new Map < String, String > ();
        Id idCase;
        SchedulableDS anoSchedulDAfterThreeHoursDS;
        String jobIDAfterThreeHoursDS;

        for (Anomalie_Doc__c ano: anoList) {
            //   statoOcs=ano.CaseId__r.stato_ocs__c;
            descrizioneAno = ano.Descrizione_Anomalia_Op__c;
            descrizioneAnoMap.put('descrizioneAno', descrizioneAno);
            idCase = ano.CaseId__c;
            System.debug('************ statoOcs ' + statoOcs);
            System.debug('************ descrizioneAno ' + descrizioneAno);
            //isDusco=ano.CaseId__r.Is_Discordanza_Cellulare__c=true;
            cronAfterThreeHours = CaseHandlerTriggerClass.createCronExpressionFromDateTimeThreeHours(ano.LastModifiedDate);
            cronAfterThirtyMinutes = CaseHandlerTriggerClass.createCronExpressionFromDateTimeThirtyMinutes(ano.LastModifiedDate);
            cronAfterFiveDays = CaseHandlerTriggerClass.createCronExpressionFromDateTimeFiveDays(ano.LastModifiedDate);
            cronAfterTwoHours = CaseHandlerTriggerClass.createCronExpressionFromDateTimeTwoHours(ano.LastModifiedDate);
        }
        //Case c = [SELECT Id, (SELECT Id, Descrizione_Anomalia_Op__c FROM Anomalie_Doc__r), Is_Discordanza_Cellulare__c, Product__r.Family,stato_ocs__c FROM Case WHERE Id =: anoList[0].CaseId__c];
        caseProductDS = CaseSelector.getPropuitFamily(idsToProcess, 'PP_ONLINE_COMPASS_DS');
        caseProductDSP = CaseSelector.getPropuitFamily(idsToProcess, 'PP_ONLINE_PARTNER_DS');
        caseProductEcommerce = CaseSelector.getPropuitFamily(idsToProcess, 'PF_ECOMMERCE_STANDARD');
        System.debug('idsToProcess-->' + idsToProcess);
        System.debug('caseProductDS-->' + caseProductDS);
        if (caseProductDS.size() > 0) {
            afterUpdateDEMAnomalieDocumentaliDS(anoList);
            afterUpdateDEMAccountReassuranceDS(anoList);
            AnomalieDocProductDS.anomaliePreSicPP(idsToProcess);
            AnomalieDocProductDS.anomaliePostSicPP(idsToProcess);
            AnomalieDocProductDS.codaSollecitoContratto(idsToProcess);

        }
        if (caseProductDSP.size() > 0) {
            afterUpdateDEMAnomalieDocumentaliDSP(anoList);
            afterUpdateDEMAccountReassuranceDSP(anoList);
            AnomalieDocProductDSP.anomaliePPPartners(idsToProcess);
            AnomalieDocProductDSP.codaSollecitoContratto(idsToProcess);
        }

        //se arriva un aggiornamento di anomalia, elimino tutte le code di riciclo per quel case
        for(Id c : idsToProcess){
            CGMWSUtils_1_0.abortJobs('riciclo-',String.valueOf(c));
        }
    }
    /*  
     * Autheur : Sana Badji 
     * @param ListAno 
     * @date  01/06/2019
     */
    public static void afterUpdateDEMAnomalieDocumentaliDS(List < Anomalie_Doc__c > listAno) {
        Set < Id > caseIds = new Set < Id > ();
        Set < Id > anoId = new Set < Id > ();
        Id idAccount;
        String nameOfCampaign;
        for (Anomalie_Doc__c ano: listAno) {
            caseIds.add(ano.CaseId__c);
            anoId.add(ano.Id);
        }
        System.debug('********CaseIds' + caseIds);
        if (caseIds.size() > 0) {
            List < Case > listcasProd = [SELECT Product__r.DEMAnomalie__c, Product__r.Family, AccountId FROM
                Case WHERE Id IN: caseIds
            ];
            for (Case casProd: listcasProd) {
                idAccount = casProd.AccountId;
                System.debug('********casprod.Product__r.Family ' + casProd.Product__r.Family);
            }
            System.debug('********idAccount ' + idAccount);
            if (idAccount != null) {
                AnomalieDocProductDS.dEMAnomalieDocumentaliDS(idAccount, anoId);
            }
        }
    }

    /*  
     * Autheur : Sana Badji 
     * @param ListAno
     * @date  01/06/2019
     */

    public static void afterUpdateDEMAccountReassuranceDS(List < Anomalie_Doc__c > listAno) {
        Set < Id > caseIds = new Set < Id > ();
        Set < Id > anoId = new Set < Id > ();
        Id idAccount;
        String nameOfCampaign;
        for (Anomalie_Doc__c ano: listAno) {
            caseIds.add(ano.CaseId__c);
            anoId.add(ano.Id);
        }
        System.debug('********CaseIds' + caseIds);
        if (caseIds.size() > 0) {
            List < Case > listcasProd = [SELECT Product__r.DEMAnomalie__c, Product__r.Family, AccountId FROM
                Case WHERE Id IN: caseIds
            ];
            for (Case casProd: listcasProd) {
                idAccount = casProd.AccountId;
                System.debug('********casprod.Product__r.Family ' + casProd.Product__r.Family);
            }
            System.debug('********idAccount ' + idAccount);
            if (idAccount != null) {
                System.debug('********idAccount ' + idAccount);
                AnomalieDocProductDS.dEMAccountReassuranceDS(idAccount, anoId);
            }
        }
    }

    /*  
     * Autheur : Sana Badji 
     * @param ListAno 
     * @date  01/06/2019
     */
    public static void afterUpdateDEMAnomalieDocumentaliDSP(List < Anomalie_Doc__c > listAno) {
        Set < Id > caseIds = new Set < Id > ();
        Set < Id > anoId = new Set < Id > ();
        Id idAccount;
        String nameOfCampaign;
        for (Anomalie_Doc__c ano: listAno) {
            caseIds.add(ano.CaseId__c);
            anoId.add(ano.Id);
        }
        System.debug('********CaseIds' + caseIds);
        if (caseIds.size() > 0) {
            List < Case > listcasProd = [SELECT Product__r.DEMAnomalie__c, Product__r.Family, AccountId FROM
                Case WHERE Id IN: caseIds
            ];
            for (Case casProd: listcasProd) {
                idAccount = casProd.AccountId;
                System.debug('********casprod.Product__r.Family ' + casProd.Product__r.Family);
            }
            System.debug('********idAccount ' + idAccount);
            if (idAccount != null) {
                AnomalieDocProductDSP.dEMAnomalieDocumentaliDSP(idAccount, anoId);
            }
        }
    }

    /*  
     * Autheur : Sana Badji 
     * @param ListAno
     * @date  01/06/2019
     */

    public static void afterUpdateDEMAccountReassuranceDSP(List < Anomalie_Doc__c > listAno) {
        Set < Id > caseIds = new Set < Id > ();
        Set < Id > anoId = new Set < Id > ();
        Id idAccount;
        String nameOfCampaign;
        for (Anomalie_Doc__c ano: listAno) {
            caseIds.add(ano.CaseId__c);
            anoId.add(ano.Id);
        }
        System.debug('********CaseIds' + caseIds);
        if (caseIds.size() > 0) {
            List < Case > listcasProd = [SELECT Product__r.DEMAnomalie__c, Product__r.Family, AccountId FROM
                Case WHERE Id IN: caseIds
            ];
            for (Case casProd: listcasProd) {
                idAccount = casProd.AccountId;
                System.debug('********casprod.Product__r.Family ' + casProd.Product__r.Family);
            }
            System.debug('********idAccount ' + idAccount);
            if (idAccount != null) {
                System.debug('********idAccount ' + idAccount);
                AnomalieDocProductDSP.dEMAccountReassuranceDSP(idAccount, anoId);
            }
        }
    }


    /*public static void regolaDiUscitaDelleCode(List < Anomalie_Doc__c > anomalies) {
        Map < Id, List < Anomalie_Doc__c >> mapCaseAnomalies = new Map < Id, List < Anomalie_Doc__c >> ();
        Set < Id > caseWithAnomalies = new Set < Id > ();
        for (Anomalie_Doc__c an: anomalies) {
            System.debug('############## an ' + an.CaseId__c);
            if (!mapCaseAnomalies.keySet().contains(an.CaseId__c)) {
                mapCaseAnomalies.put(an.CaseId__c, new List < Anomalie_Doc__c > {
                    an
                });
            } else {
                mapCaseAnomalies.get(an.CaseId__c).add(an);
            }
        }
        Map < Id, Boolean > returnValueAnomalieCellulare = checkCaseAnomalieCellulare(mapCaseAnomalies);
        Map < Id, Boolean > returnValueInDiscordanzaCellaure = checkCaseInDiscordanzaCellaure(mapCaseAnomalies);
        Map < Id, Boolean > returnValuecheckCaseInQueue = checkCaseInQueue(mapCaseAnomalies);
        System.debug('######## returnValueAnomalieCellulare ' + returnValueAnomalieCellulare);
        System.debug('######## returnValueInDiscordanzaCellaure ' + returnValueInDiscordanzaCellaure);
        System.debug('######## returnValuecheckCaseInQueue ' + returnValuecheckCaseInQueue);
        Group gr = [select Id from Group where Type = 'Queue'
            AND DeveloperName = 'Q525'
        ];
        for (Id key: mapCaseAnomalies.keySet()) {
            if (returnValueAnomalieCellulare.get(key) == false &&
                returnValueInDiscordanzaCellaure.get(key) == false &&
                returnValuecheckCaseInQueue.get(key) == true) {
                caseWithAnomalies.add(key);
            }
        }
        eliminaLaCoda(caseWithAnomalies);
    }*/

    /*public static Map < Id, Boolean > checkCaseAnomalieCellulare(Map < Id, List < Anomalie_Doc__c >> mapCaseAnomalies) {
        Map < Id, Boolean > returnValue = new Map < Id, Boolean > ();
        /*  List<Anomalie_Doc__c> anomalies = [SELECT Id, CaseId__c, Descrizione_Anomalia_Op__c FROM Anomalie_Doc__c WHERE CaseId__c IN : mapCaseAnomalies.keySet() ];
          for(Anomalie_Doc__c an : anomalies ){
               if(an.)
          }*//*
        for (Id key: mapCaseAnomalies.keySet()) {
            returnValue.put(key, false);
            for (Anomalie_Doc__c an: mapCaseAnomalies.get(key)) {
                if (String.isNotBlank(an.Descrizione_Anomalia_Op__c)) {
                    returnValue.put(key, true);
                }
            }
        }
        return returnValue;
    }*//*
    public static Map < Id, Boolean > checkCaseInDiscordanzaCellaure(Map < Id, List < Anomalie_Doc__c >> mapCaseAnomalies) {
        Map < Id, Boolean > returnValue = new Map < Id, Boolean > ();
        List < Case > caseLists = [SELECT Id, Is_Discordanza_Cellulare__c FROM Case WHERE Id IN: mapCaseAnomalies.keySet()];
        for (Case c: caseLists) {
            returnValue.put(c.Id, false);
            if (c.Is_Discordanza_Cellulare__c == true) returnValue.put(c.Id, true);
        }
        return returnValue;
    }*/

    public static Map < Id, Boolean > checkCaseInQueue(Map < Id, List < Anomalie_Doc__c >> mapCaseAnomalies) {
        // pre Q339
        //post Q340
        //Q341
        // Anomalie PP : Q376
        // Q341
        Map < Id, Boolean > returnValue = new Map < Id, Boolean > ();
        List < Case > caseLists = [SELECT Id, Is_Discordanza_Cellulare__c, OwnerId FROM Case WHERE Id IN: mapCaseAnomalies.keySet()];
        List < String > developerNames = new List < String > {
            'Q339',
            'Q340',
            'Q341',
            'Q376'
        };
        Map < Id, Group > mapGroup = new Map < Id, Group > ([SELECT Id, DeveloperName, Name FROM Group WHERE Type = 'queue'
            AND DeveloperName IN: developerNames
        ]);
        for (Case c: caseLists) {
            returnValue.put(c.Id, false);
            if (mapGroup.keySet().contains(c.OwnerId)) returnValue.put(c.Id, true);

        }
        return returnValue;
    }

    /*public static void eliminaLaCoda(Set < Id > idCases) {
        //  try {
        System.debug('##########################  eliminaLaCoda ' + idCases.size());
        if (idCases.size() == 0) {
            return;
        }
        Group gr = [select Id from Group where Type = 'Queue'
            AND DeveloperName = 'Q525'
        ];
        List < Case > caseLists = [SELECT Id, OwnerId FROM Case WHERE Id IN: idCases];
        if (gr.Id != null) {
            for (Case c: caseLists) {
                c.OwnerId = gr.Id;
            }
            update caseLists;

        }


        /* } catch (Exception e) {
                 System.debug('#################### error Message eliminaLaCoda  '+e.getMessage());
                 System.debug('#################### error Message eliminaLaCoda  '+e.getStackTraceString());
              
         }*//*
    }*/

    public static void regoleDiUscitaCodaBefore (Set < Id > idsToProcess) {
        /**
         * il Case esce dalla coda se e solo se:
         * A.	Se non sono presenti anomalie sui documenti
         * B.	Se in quel momento la richiesta online si trova in coda Anomalie Pre o Post o  Sollecito Contratto
         * C.	Se non è presente l’anomalia cellulare
         */
         System.debug('****regoleDiUscitaCoda-BEFORE*****START');
         try{
            Set<String> condizioniCode = new Set<String> {'Q339','Q340','Q341'};
            Map<Id,Group> gruppi = new Map<Id,Group>([SELECT ID FROM GROUP WHERE DeveloperName in :condizioniCode]);
            
            if(gruppi.size()>0){
                //query del case prima che cambi coda
                Map<Id,Case> caseList = new Map<Id,Case>([select id from case where id in :idsToProcess and Is_Discordanza_Cellulare__c = false and OwnerId in :gruppi.keySet()]);
                casePreUscitaCoda = caseList.keySet();
            }

            
        }catch(Exception e){
            System.debug('EXCEPTION-->'+e);
            System.debug(e.getCause());
            System.debug(e.getMessage());
        }

         System.debug('****regoleDiUscitaCoda-BEFORE*****DONE');
    }


    public static void regoleDiUscitaCodaAfter () {
        System.debug('****regoleDiUscitaCoda-AFTER*****START');
        System.debug('regoleDiUscitaCodaPost-->'+casePreUscitaCoda);
        try{
            Set<ID> caseCambioCode = new Set<ID> ();
            List<Case> caseList = [select id, (select id from Anomalie_Doc__r where codice_Anomalia__c!=null) from case where id in :casePreUscitaCoda];
            System.debug('caseList-->'+caseList);
                if(caseList.size()>0){
                    System.debug('caseList[0].Anomalie_Doc__r-->'+caseList[0].Anomalie_Doc__r);
                    for(Case c : caseList){
                        System.debug('c.Anomalie_Doc__r.size()-->'+c.Anomalie_Doc__r.size());
                        if(c.Anomalie_Doc__r.size()==0){
                            //soddisfatti tutti i requisiti per uscire dalla coda
                            caseCambioCode.add(c.Id);
                        }
                    }
            
            }
            if(caseCambioCode.size()>0){
                System.debug('CAMBIO CODE PER I CASE-->'+caseCambioCode);
                CaseService.addCase_To_Queue(caseCambioCode,'Q525');
            }
        }catch(Exception e){
            System.debug('EXCEPTION-->'+e);
            System.debug(e.getCause());
            System.debug(e.getMessage());
        }
        System.debug('****regoleDiUscitaCoda-AFTER*****DONE');
    }

}