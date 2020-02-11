public  class AggiornamentoPraticeDSP {
public static Map<Id, Case> caseMaps;

public static Map<Id, Case> caseMapsPrimoDelSecciDSP = new Map<Id, Case>();
public static Map<Id, Case> caseMapsPostSecciDSP = new Map<Id, Case>();
public static final String AFTER_TWENTY_FOUR_HOURS_PRIMA_SECCI_DSP = 'afterTwentyFourHoursPrimaSecciDSP'; 
public static final String AFTER_SEVENTY_TWO_HOURS_PRIMA_SECCI_DSP ='afterSeventyTwoHoursPrimaSecciDSP';
public static final String AFTER_TWENTY_FOUR_HOURS_POST_SECCI_DSP = 'afterTwentyFourHoursPostSecciDSP';
public static final String AFTER_SEVENTY_TWO_HOURS_POST_SECCI_DSP = 'afterSeventyTwoHoursPostSecciDSP';
public static final  Datetime dateTimeNow = Datetime.now();

public static void aggiornamentoDSP(List<Case> caseList, Map<Id,Case> casesR){
    System.debug('********************* running ***********  aggiornamentoDSP');
  if(caseList == null || caseList.size() == 0){
      return;
  }
  else {
      System.debug('***************** aggiornamentoDSP ************* else ');
       Recursion.isBeforeTriggerExcecuting = true;
      caseMaps  = new Map<Id, Case>(caseList);
      abbandonaPrimaDelSecciDSP(caseMaps, casesR);
      abbandonaPostSecciDSP(caseMaps, casesR);

  }
}
public static void abbandonaPrimaDelSecciDSP(Map<Id,Case> caseMap, Map<Id,Case> casesR){
    if(caseMap == null || caseMap.size() == 0){
        return;
    }
    else {
        System.debug('********************* running abbandonaPrimaDelSecciDSP *********** '+caseMap.keySet().size());
           for(Id idCase : caseMap.keySet()){
              if(  (caseMap.get(idCase)).RO_Link_Bozza__c == null && 
                    (caseMap.get(idCase)).Status !='Gestito' &&
                    CGMWSUtils_1_0.DatetimeWithin30mn((caseMap.get(idCase)).LastModifiedDate, dateTimeNow)){
                    caseMapsPrimoDelSecciDSP.put(idCase,caseMap.get(idCase));
                    casesR.put(idCase, caseMap.get(idCase));
                    caseMaps.remove(idCase);
                 } 
        }
     
    }
    abbandonaPrimaDelSecciDSPAzioni(caseMapsPrimoDelSecciDSP);
   // CGMWSUtils_1_0.schedulableJob(caseMap, AFTER_TWENTY_FOUR_HOURS_PRIMA_SECCI_DSP, 24);
}

public static void abbandonaPrimaDelSecciDSPAzioni(Map<Id,Case> caseMap){
    System.debug('***abbandonaPrimaDelSecciDSPAzioni***START');
    if(caseMap == null || caseMap.size() == 0){
        return;
    }
    else {
         //CGMWSUtils_1_0.sendInvioDemAndSMS(caseMap, 'DEMAbbandonoPostSecci_PP_CB', '2551', 'SMSAbbandonoPreSecci', 'Prestito Online CheBanca!: riprendi la tua richiesta', 'prestitoonlinechebanca@compass.it', 'Compass Banca S.p.A ');
       // CGMWSUtils_1_0.sendInvioDemAndSMS(caseMap, 'SMSAbbandonoPreSecci');
       
       CGMWSUtils_1_0.sendNotifications(caseMap.values(),'DEMAbbandonoPreSecci__c','SMSAbbandonoPreSecci__c',CGMWSUtils_1_0.EMAIL_NO_REPLY, CGMWSUtils_1_0.EMAIL_LABEL_COMPASS);
    }
    System.debug('***abbandonaPrimaDelSecciDSPAzioni***DONE');
}
 
public static void abbandonaPostSecciDSP(Map<Id,Case> caseMap, Map<Id,Case> casesR ){
    List<Case> listCase = new List<Case>();
    if(caseMap == null || caseMap.size() == 0){
        return;
    }
    else {
        System.debug('******************** abbandonaPostSecciDSP *** '+caseMap.keySet().size());
        for(Id idCase: caseMap.keySet()){
            String linkBozza = caseMap.get(idCase).RO_Link_Bozza__c;
            String engineChannel = caseMap.get(idCase).RO_Engine_channel__c;
            String status = caseMap.get(idCase).Status;
            String numPratica = caseMap.get(idCase).NumeroPratica__c;
            Boolean isLastModifiedDateIn30Mins = CGMWSUtils_1_0.DatetimeWithin30mn(CaseService.getLastModifiedDate(idCase), dateTimeNow);
            System.debug('************** running abbandonaPostSecci  linkBozza ' + linkBozza);
                System.debug('************** running abbandonaPostSecci  engineChannel ' + engineChannel);
                System.debug('************** running abbandonaPostSecci  status ' + status);
                System.debug('************** running abbandonaPostSecci  numPratica ' + numPratica);
                System.debug('************** running abbandonaPostSecci  isLastModifiedDateIn30Mins ' + isLastModifiedDateIn30Mins);  
                if(numPratica == null &&
                String.isNotBlank(linkBozza)  &&
                    status !='Gestito' &&
                    isLastModifiedDateIn30Mins){
                        System.debug('************** running getCaseAbbandonaPostSecci  abbandonaPostDelSecci  if yes ');
                        caseMapsPostSecciDSP.put(idCase, caseMap.get(idCase));
                        listCase.add(caseMap.get(idCase));
                        casesR.put(idCase, caseMap.get(idCase));
                        caseMap.remove(idCase);

              } 
        }

        abbandonaPostSecciDSPAzioni(caseMapsPostSecciDSP);
     //   CGMWSUtils_1_0.schedulableJob(caseMapsPostSecciDSP, AFTER_TWENTY_FOUR_HOURS_POST_SECCI_DSP, 24);

    }
}

 public static void abbandonaPostSecciDSPAzioni(Map<Id,Case> caseMap){
    if(caseMap == null || caseMap.size() == 0){
        return;
    }
    else {
        System.debug('changing queue post secci');
            Group g = CaseService.getQueue('Q375');
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
         // CGMWSUtils_1_0.sendInvioDemAndSMS(caseMap, 'DEMAbbandonoPostSecci_PP_CB', '2552', 'SMSAbbandonoPostSecci', 'Prestito Online CheBanca!: completa la tua richiesta', 'prestitoonlinechebanca@compass.it', 'Compass Banca S.p.A ');
       // CGMWSUtils_1_0.sendInvioDemAndSMS(caseMap, 'SMSAbbandonoPostSecci');
       CGMWSUtils_1_0.sendNotifications(caseMap.values(),'DEMAbbandonoPostSecci__c','SMSAbbandonoPostSecci__c',CGMWSUtils_1_0.EMAIL_NO_REPLY, CGMWSUtils_1_0.EMAIL_LABEL_COMPASS);
    }
}

}