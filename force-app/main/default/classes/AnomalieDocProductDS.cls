/* 
* Autheur : Sana Badji 
* description Class created for handle  Anomalie by Family: DS
* @date  27/06/2019
*/
public with sharing class AnomalieDocProductDS {

  public static final String AFTER_FIVE_DAYS = 'afterFiveDays';
  public static String cronAfterThreeHours;
  public static final String AFTER_THREE_THREE_HOURS = 'afterThreeHours';
  public static String cronAfterThirtyMinutes;
  public static final String AFTER_THIRTY_MINUTES = 'afterThirtyMinutes';
  public static String cronAfterFiveDays;
  public static List<Case> caseProductEcommerce = new List<Case>();
  public static  Set<Id> idCase = new Set<Id>();
  public static   List<Case> listCaseToUpdate = new List<Case>();

    public AnomalieDocProductDS() {

    }

/* 
    * Autheur : Sana Badji 
    * @param idAccount
    * @param idAno
    *@date  16/05/2019
    */  
    
    public static Set<Id>  dEMAnomalieDocumentaliDS (Id idAccount, Set<Id> idAno){
            List<Anomalie_Doc__c> anomalibyId =AnomalieSelector.anomalieByID(idAno);
           // List<XCS_Template__c> templateAnoContpp = AnomalieSelector.templateTesto('SMSAnomalieContratto_DS');
           // List<XCS_Template__c> templateAnoDocpp = AnomalieSelector.templateTesto('SMSAnomalieDoc_DS');
            Account getAccount=AnomalieSelector.getAccount(idAccount);
            String telefonoCellulare;
            Id  caseId;
            String bodyNote='';
            String roLinkbozza;
            String email;
            String numPratica;
            String codiceAnom;
            String descrizioneAno;
            String codiceMacro;
            //Set<String> descrizioneAnoSet = new Set<String>();
            Map<String, String> descrizioneAnoMap = new Map<String, String>();
            Map<String, String> codiceMacroMap = new Map<String, String>();
            Map<String, String> numPraticaMap = new Map<String, String>();
            Map<String, String> codiceAnomMap = new Map<String, String>();
            if(anomalibyId.size() == 0 || getAccount ==null)
              {
                System.debug('******** anomalibyId is empty'+anomalibyId.size());
                System.debug('******** Account is '+getAccount);
              }else
              {
                System.debug('******** anomalibyId '+anomalibyId.size());
                for(Anomalie_Doc__c ano: anomalibyId ){
                    if(ano.Descrizione_Anomalia_Cliente__c!=null){
                          bodyNote+=ano.descrizione_Macro_Doc__c+' : '+ano.Descrizione_Anomalia_Cliente__c;
                      }   
                    caseId= ano.CaseId__c;
                    numPratica=ano.CaseId__r.NumeroPratica__c;
                    codiceAnom=ano.codice_Anomalia__c;
                    descrizioneAno=ano.Descrizione_Anomalia_Op__c;
                    codiceMacro=ano.Codice_Macro_Documento__c;
                    telefonoCellulare=getAccount.PersonMobilePhone;
                    roLinkbozza= ano.CaseId__r.RO_Link_Bozza__c;
                    email=getAccount.PersonEmail;
                    idCase.add(ano.CaseId__c);
                    codiceAnomMap.put('codiceAnom',codiceAnom);
                    codiceMacroMap.put('codiceMacro',codiceMacro);
                    descrizioneAnoMap.put('descrizioneAno',descrizioneAno);
                    numPraticaMap.put('numPratica',numPratica);
                    System.debug('******** codiceAnomMap '+codiceAnomMap.get('codiceAnom'));
                    System.debug('******** codiceMacroMap '+codiceMacroMap.get('codiceMacro'));
                    System.debug('******** descrizioneAnoMap '+descrizioneAnoMap.get('descrizioneAno'));
                    System.debug('******** numPraticaMap '+numPraticaMap.get('numPratica'));
                }
              if(idCase.contains(caseId) && codiceMacroMap.get('codiceMacro')=='RIC' && codiceAnomMap.get('codiceAnom')!=null &&
                    numPraticaMap.get('numPratica')!=null && descrizioneAnoMap.get('descrizioneAno')!=null ){
                    // Send Mail 
                    CaseDomain.mailDem('2069', caseId, getAccount.Name+', il tuo contratto di Prestito Online Compass è pronto!', 
                    'richiesta@compass.it', 'richiesta@compass.it');
                    // Send Sms
                    CaseDomain.sendSMS(telefonoCellulare,'SMSAnomalieContratto_DS');
                    //OCSInviaSMSInvoker.inviaSMS('',telefonoCellulare,'','',templateAnoContpp[0].Body__c);
                    // Create Note
                    CallWebService.createNote('Inviata mail DEMAnomalieContrato_DS',email,roLinkbozza,bodyNote,caseId);
                    System.debug('************ DEM And SMS Anomalie Contratto PP sended Succesfully');
              }
              else if(idCase.contains(caseId) && codiceMacroMap.get('codiceMacro')!='RIC' && codiceAnomMap.get('codiceAnom')!=null &&
                    numPraticaMap.get('numPratica')!=null && descrizioneAnoMap.get('descrizioneAno')!=null){
                    // Send Mail 
                    CaseDomain.mailDem('2068', caseId, getAccount.Name+',abbiamo bisogno di te!', 
                    'richiesta@compass.it', 'Compass Banca S.p.a');
                    // Send Sms
                    CaseDomain.sendSMS(telefonoCellulare,'SMSAnomalieDoc_DS');
                    //OCSInviaSMSInvoker.inviaSMS('',telefonoCellulare,'','',templateAnoDocpp[0].Body__c);
                    // Create Note
                    CallWebService.createNote('Inviata mail DEMAnomalieDoc_DS',email,roLinkbozza,bodyNote,caseId);
                    System.debug('************ DEM And SMS Anomalie Documentali PP sended Succesfully');
              }
              else if(idCase.contains(caseId) && codiceAnomMap.get('codiceAnom')==null && descrizioneAnoMap.get('descrizioneAno')==null &&
                    numPraticaMap.get('numPratica')!=null){
                    // Create Note
                    CallWebService.createNote('nessuna anomalia documentale inviata',email,roLinkbozza,'nessuna anomalia documentale',caseId);
                    System.debug('************ nessuna anomalia documentale');
              }
              
        } 
      return idCase;
    } 

   
  /* 
  * Autheur : Sana Badji 
  * @param idAccount
  * @param idAno
  * @date  16/05/2019
  */
      public static void  dEMAccountReassuranceDS (Id idAccount, Set<Id> idAno){
          List<Anomalie_Doc__c> anomalibyId = AnomalieSelector.anomalieByID(idAno);
          //List<XCS_Template__c> templateRassCliente = AnomalieSelector.templateTesto('SMSRassicuraCliente_DS');
          Account getAccount=AnomalieSelector.getAccount(idAccount);
          Id  caseId;
          String telefonoCellulare;
          String bodyNote='';
          String roLinkbozza;
          String email;
          String numPratica;
          String statoOcs;
          String codiceAnom;
          String descrizioneAno;
          Map<String, String> descrizioneAnoMap = new Map<String, String>();
          Map<String, String> codiceMacroMap = new Map<String, String>();
          Map<String, String> numPraticaMap = new Map<String, String>();
          Map<String, String> codiceAnomMap = new Map<String, String>();
          Map<String, String> statoOcsMap = new Map<String, String>();
          if(anomalibyId.size() == 0 || getAccount==null){
                System.debug('******** anomalibyId is empty'+anomalibyId.size());
                System.debug('******** Account is '+getAccount);
            }
          else{
              System.debug('******** anomalibyId '+anomalibyId.size());
              for(Anomalie_Doc__c ano: anomalibyId ){
                System.debug('******** ano.CaseId__r.NumeroPratica__c '+ano.CaseId__r.NumeroPratica__c);
                System.debug('******** ano.Descrizione_Anomalia_Op__c '+ano.Descrizione_Anomalia_Op__c);
                System.debug('******** ano.CaseId__r.stato_ocs__c '+ano.CaseId__r.stato_ocs__c);
                System.debug('******** ano.CaseId__c '+ano.CaseId__c);
                if(ano.Descrizione_Anomalia_Cliente__c!=null){
                            bodyNote+=ano.descrizione_Macro_Doc__c+' : '+ano.Descrizione_Anomalia_Cliente__c;
                      }   
                  caseId= ano.CaseId__c;
                  numPratica=ano.CaseId__r.NumeroPratica__c;
                  statoOcs=ano.CaseId__r.stato_ocs__c;
                  codiceAnom=ano.codice_Anomalia__c;
                  descrizioneAno=ano.Descrizione_Anomalia_Op__c;
                  telefonoCellulare=getAccount.PersonMobilePhone;
                  roLinkbozza= ano.CaseId__r.RO_Link_Bozza__c;
                  email=getAccount.PersonEmail;
                  idCase.add(ano.CaseId__c);
                  codiceAnomMap.put('codiceAnom',codiceAnom);
                  statoOcsMap.put('statoOcs',statoOcs);
                  codiceMacroMap.put('codiceMacro',ano.Codice_Macro_Documento__c);
                  descrizioneAnoMap.put('descrizioneAno',descrizioneAno);
                  numPraticaMap.put('numPratica',numPratica);
                  System.debug('******** codiceAnomMap '+codiceAnomMap.get('codiceAnom'));
                  System.debug('******** codiceMacroMap '+codiceMacroMap.get('codiceMacro'));
                  System.debug('******** descrizioneAnoMap '+descrizioneAnoMap.get('descrizioneAno'));
                  System.debug('******** numPraticaMap '+numPraticaMap.get('numPratica'));
                  System.debug('******** statoOcsMap '+statoOcsMap.get('statoOcs')); 
              }
              if(idCase.contains(caseId) && codiceMacroMap.get('codiceMacro')!='RIC' && statoOcsMap.get('statoOcs')=='30' && 
                  codiceAnomMap.get('codiceAnom')==null && numPraticaMap.get('numPratica')!=null && 
                  descrizioneAnoMap.get('descrizioneAno')==null ){
                   // Send Mail
                  CaseDomain.mailDem('2725', caseId, getAccount.Name+', manca poco per conoscere l\'esito del Prestito Online Compass!', 
                  'richiesta@compass.it', 'Compass Banca S.p.A ');
                  // Send SMS
                  CaseDomain.sendSMS(telefonoCellulare,'SMSRassicuraCliente_DS');
                  //OCSInviaSMSInvoker.inviaSMS('',telefonoCellulare,'','',templateRassCliente[0].Body__c);
                  // Create Note
                  CallWebService.createNote('Inviata mail DEMRassicuraCliente_DS',email,roLinkbozza,'nessuna anomalia documentale',caseId);
                  System.debug('************ DEM And SMS Rassicura Cliente DS   sended Succesfully');
              }
      }
      }

/* 
* Autheur : Sana Badji 
* @param caseIds
* @date  28/05/2019
  */
     
      public static void  checkAnoPreSicPPAfterThreeHours(Set<Id> caseIds){
           CallWebService.addToQueuAfterCallWebservice(caseIds,'Q339','PP_ONLINE_COMPASS_DS');
        //}
  }
  
/*  
 * Autheur : Sana Badji 
 * @param idsetCases
 * @date  31/05/2019
     */
    
      public static void  checkAnoPostSicPPAfterThreeHours(Set<Id> caseIds){
           CallWebService.addToQueuAfterCallWebservice(caseIds,'Q340','PP_ONLINE_COMPASS_DS');
}

/*  
* Autheur : Sana Badji 
* @param idsetCases
* @date  17/05/2019
     */
  public static String  anomaliePreSicPP_old (Set<Id> idCase){
         // List<Anomalie_Doc__c> anomalibyId=AnomalieSelector.anomalieByID(idAno);
          List<Anomalie_Doc__c> anomalibyId=AnomalieSelector.listAnomalieByID(idCase);
          Account getAccount;
          String statoOcs ;
          Id idCas;
          SchedulableDS anoSchedulDAfterThreeHoursDS;
          String jobIDAfterThreeHoursDS;
          Map<String, String> descrizioneAnoMap = new Map<String, String>();
          Map<String, String> statoOcsMap = new Map<String, String>();
          Map<String, Boolean> isDisco = new Map<String, Boolean>();
          Map<String, String> numPraticaMap = new Map<String, String>();
          if(anomalibyId.size() == 0){
                System.debug('******** anomalibyId is empty'+anomalibyId.size());
            }
          else{
            System.debug('******** anomalibyId size '+anomalibyId.size());  
              for(Anomalie_Doc__c ano: anomalibyId){ 
                  System.debug('******** ano.CaseId__r.stato_ocs__c '+ano.CaseId__r.stato_ocs__c);
                  System.debug('******** ano.Descrizione_Anomalia_Op__c '+ano.Descrizione_Anomalia_Op__c);
                  idCas=ano.CaseId__c;
                  
                  statoOcs=ano.CaseId__r.stato_ocs__c;
                  cronAfterThreeHours= CaseHandlerTriggerClass.createCronExpressionFromDateTimeThreeHours(ano.LastModifiedDate);
                  statoOcsMap.put('statoOcs',statoOcs);
                  descrizioneAnoMap.put('descrizioneAno',ano.Descrizione_Anomalia_Op__c);
                  numPraticaMap.put('numPratica',ano.CaseId__r.NumeroPratica__c);
                  isDisco.put('isDisco',ano.CaseId__r.Is_Discordanza_Cellulare__c);
                  System.debug('********ano.CaseId__r.Is_Discordanza_Cellulare__c '+ ano.CaseId__r.Is_Discordanza_Cellulare__c);
                  System.debug('******** statoOcsPresIc added'+statoOcs);
                  System.debug('******** descrizioneAnoMap'+descrizioneAnoMap.get('descrizioneAno'));
                  System.debug('******** statoOcsMap'+statoOcsMap.get('statoOcs'));
                  //System.debug('******** descrizioneAnoMap'+descrizioneAnoMap.get('descrizioneAno'));
                  System.debug('******** isDisco Map'+isDisco.get('isDisco'));
          }
          if((statoOcsMap.get('statoOcs')=='05BT' || statoOcsMap.get('statoOcs')=='10') && numPraticaMap.get('numPratica')!=null 
          && (descrizioneAnoMap.get('descrizioneAno')!=null || isDisco.get('isDisco')==true) ){
              anoSchedulDAfterThreeHoursDS = new SchedulableDS(idCase,AFTER_THREE_THREE_HOURS,''); 
              jobIDAfterThreeHoursDS = System.schedule('anoSchedul_DS-'+idCas+'-'+cronAfterThreeHours, cronAfterThreeHours, anoSchedulDAfterThreeHoursDS);
              CGMWSUtils_1_0.abordJobAno (idCas,jobIDAfterThreeHoursDS);
              System.debug('################### jobIDAfterThreeHoursDS Pre sic '+jobIDAfterThreeHoursDS);

          }
          else if((statoOcsMap.get('statoOcs')=='05BT' || statoOcsMap.get('statoOcs')=='10') && 
                  (descrizioneAnoMap.get('descrizioneAno')==null &&  isDisco.get('isDisco')==false)) {
                CGMWSUtils_1_0.abordJobAno(idCas);
                System.debug('################### jobIDAfterThreeHoursDS null');
          }
          
    }
    return statoOcs;
  }


   public static void anomaliePreSicPP(Set<Id> caseIds) {
    List<Anomalie_Doc__c> anomalibyId = AnomalieSelector.listAnomalieByID(caseIds);

    System.debug('******** anomaliePreSicPP: anomalibyId size ' + anomalibyId.size());

    Map <String, List<Anomalie_Doc__c>> caseIdMap = new Map <String, List<Anomalie_Doc__c>> ();

    for (Anomalie_Doc__c ano: anomalibyId) {
      List<Anomalie_Doc__c> anomalies = caseIdMap.get(ano.CaseId__c);
      if (anomalies == null) {
        anomalies = new List<Anomalie_Doc__c>();
        caseIdMap.put(ano.CaseId__c, anomalies);
      }
      anomalies.add(ano);
    }

    List<Case> cases = [SELECT Id, Is_Discordanza_Cellulare__c, Codice_Cliente__c, stato_ocs__c, LastModifiedDate from Case where Id in :caseIds];

    for (Case caseItem : cases) {
      String caseId = caseItem.Id;
      List<Anomalie_Doc__c> anomalies = caseIdMap.get(caseId);
      String codiceOCS = caseItem.Codice_Cliente__c;
      String statoOCS = caseItem.stato_ocs__c;
      Boolean isDiscordanza = caseItem.Is_Discordanza_Cellulare__c;
      Boolean isAnomalia = false;
      DateTime anomalyDateTime = caseItem.LastModifiedDate;
      String jobNamePrefix = 'anoPreSicSchedul_DS-';

      System.debug('******** Check anomalies for Case ' + caseId);

      if (anomalies != null) {
        for (Anomalie_Doc__c anomaly : anomalies) {
          System.debug('******** anomaly ' + anomaly);

          isAnomalia = String.isNotBlank(anomaly.Codice_Anomalia__c);
          if (isAnomalia) {
            anomalyDateTime = anomaly.CreatedDate;
            break;
          }
        }
      }

      System.debug('******** codiceOCS ' + codiceOCS);
      System.debug('******** statoOCS ' + statoOCS);
      System.debug('******** isDiscordanza ' + isDiscordanza);
      System.debug('******** isAnomalia ' + isAnomalia);
      System.debug('******** anomalyDateTime ' + anomalyDateTime);

      if (String.isNotBlank(codiceOCS) && ('05BT' == statoOCS || '10' == statoOCS) && (isAnomalia || isDiscordanza)) {
        System.debug('******** anomaliePreSicPP job must be scheduled' );
        String cron = CaseHandlerTriggerClass.createCronExpressionFromDateTimeThreeHours(anomalyDateTime);
        String jobName = jobNamePrefix + caseId + '-' + cron;
        CGMWSUtils_1_0.rescheduleJobDS(jobNamePrefix, caseId, jobName, cron, AFTER_THREE_THREE_HOURS);
      }
      else {
        CGMWSUtils_1_0.abortJobs(jobNamePrefix, caseId);
      }
    }
  }

/*  
* Autheur : Sana Badji 
* @param idCase
* @date  20/05/2019
     */
      public static String  anomaliePostSicPP_old  (Set<Id> idCase){
          //List<Anomalie_Doc__c> anomalibyId=AnomalieSelector.anomalieByID(idCase);
          List<Anomalie_Doc__c> anomalibyId=AnomalieSelector.listAnomalieByID(idCase);
          Account getAccount;
          Id idCas;
          String statoOcs ;
          SchedulableDS anoSchedulDAfterThreeHoursDS;
          String jobIDAfterThreeHoursDS;
          Map<String, String> descrizioneAnoMap = new Map<String, String>();
          Map<String, String> statoOcsMap = new Map<String, String>();
          Map<String, Boolean> isDisco = new Map<String, Boolean>();
          Map<String, String> numPraticaMap = new Map<String, String>();

          if(anomalibyId.size() == 0){
                System.debug('******** anomalibyId is empty'+anomalibyId.size());
            }
          else{
            System.debug('******** anomalibyId size '+anomalibyId.size());  
              for(Anomalie_Doc__c ano: anomalibyId){ 
                      idCas=ano.CaseId__c;
                      System.debug('******** ano.CaseId__r.stato_ocs__c '+ano.CaseId__r.stato_ocs__c);
                      System.debug('******** ano.Descrizione_Anomalia_Op__c '+ano.Descrizione_Anomalia_Op__c);
                      System.debug('********  ano.CaseId__r.Is_Discordanza_Cellulare__c '+ ano.CaseId__r.Is_Discordanza_Cellulare__c);
                      cronAfterThreeHours= CaseHandlerTriggerClass.createCronExpressionFromDateTimeThreeHours(ano.LastModifiedDate);
                      statoOcs=ano.CaseId__r.stato_ocs__c;
                      statoOcsMap.put('statoOcs',statoOcs);
                      descrizioneAnoMap.put('descrizioneAno',ano.Descrizione_Anomalia_Op__c);
                      isDisco.put('isDisco',ano.CaseId__r.Is_Discordanza_Cellulare__c);
                      numPraticaMap.put('numPratica',ano.CaseId__r.NumeroPratica__c);
                      System.debug('******** statoOcsPostSic added'+statoOcs);
                
          }
          if((statoOcsMap.get('statoOcs')=='20SD' || statoOcsMap.get('statoOcs')=='20') && numPraticaMap.get('numPratica')!=null 
          && (descrizioneAnoMap.get('descrizioneAno')!=null || isDisco.get('isDisco')==true)){
              anoSchedulDAfterThreeHoursDS = new SchedulableDS(idCase,AFTER_THREE_THREE_HOURS,''); 
              jobIDAfterThreeHoursDS = System.schedule('anoSchedul_DS-'+idCas+'-'+cronAfterThreeHours, cronAfterThreeHours, anoSchedulDAfterThreeHoursDS);
              System.debug('################### jobIDAfterThreeHoursDS Post Sic  '+jobIDAfterThreeHoursDS);
              System.System.debug('idJobDS '+CaseSelector.getStatusjobIDEcom(jobIDAfterThreeHoursDS).get('idJobDS'));
              CGMWSUtils_1_0.abordJobAno (idCas,jobIDAfterThreeHoursDS);

          }
          else if((statoOcsMap.get('statoOcs')=='20SD' || statoOcsMap.get('statoOcs')=='20') && 
                  (descrizioneAnoMap.get('descrizioneAno')==null && isDisco.get('isDisco')==false)) {
                CGMWSUtils_1_0.abordJobAno(idCas);
          }


    }
    return statoOcs;
}


  public static void anomaliePostSicPP (Set<Id> caseIds) {
    List<Anomalie_Doc__c> anomalibyId = AnomalieSelector.listAnomalieByID(caseIds);

    System.debug('******** anomaliePostSicPP anomalibyId size ' + anomalibyId.size());

    Map <String, List<Anomalie_Doc__c>> caseIdMap = new Map <String, List<Anomalie_Doc__c>> ();

    for (Anomalie_Doc__c ano: anomalibyId) {
      List<Anomalie_Doc__c> anomalies = caseIdMap.get(ano.CaseId__c);
      if (anomalies == null) {
        anomalies = new List<Anomalie_Doc__c>();
        caseIdMap.put(ano.CaseId__c, anomalies);
      }
      anomalies.add(ano);
    }

    for (String caseId : caseIdMap.keySet()) {
      List<Anomalie_Doc__c> anomalies = caseIdMap.get(caseId);
      String codiceOCS;
      String statoOCS;
      Boolean isAnomalia = false;
      DateTime firstAnomalyDateTime;
      String jobNamePrefix = 'anoPostSicSchedul_DS-';

      System.debug('******** Check anomalies for Case ' + caseId);

      for (Anomalie_Doc__c anomaly : anomalies) {
        System.debug('******** anomaly ' + anomaly);
        codiceOCS = anomaly.CaseId__r.Codice_Cliente__c;
        statoOCS = anomaly.CaseId__r.stato_ocs__c;
        isAnomalia = String.isNotBlank(anomaly.Codice_Anomalia__c);
        if (isAnomalia) {
          firstAnomalyDateTime = anomaly.CreatedDate;
          break;
        }
      }

      System.debug('******** codiceOCS ' + codiceOCS);
      System.debug('******** statoOCS ' + statoOCS);
      System.debug('******** isAnomalia ' + isAnomalia);
      System.debug('******** firstAnomalyDateTime ' + firstAnomalyDateTime);

      if (String.isNotBlank(codiceOCS) && CGMWSUtils_1_0.isStatoGreaterThan(statoOCS, '20') && isAnomalia) {
        System.debug('******** anomaliePostSicPP job must be scheduled' );
        String cron = CaseHandlerTriggerClass.createCronExpressionFromDateTimeThreeHours(firstAnomalyDateTime);
        String jobName = jobNamePrefix + caseId + '-' + cron;
        CGMWSUtils_1_0.rescheduleJobDS(jobNamePrefix, caseId, jobName, cron, AFTER_THREE_THREE_HOURS);
      }
      else {
        CGMWSUtils_1_0.abortJobs(jobNamePrefix, caseId);
      }
    }

  }

public static String  codaSollecitoContratto  (Set<Id> idCase){
          System.debug('AnomalieDocProductDS.codaSollecitoContratto----START');
          System.debug('AnomalieDocProductDS.codaSollecitoContratto----idCase-->'+idCase);
          Id idCas;
          String statoOcs ; 
          String jobNamePrefix = 'solContrSchedul_DS-';
          Map<String, String> descrizioneAnoMap = new Map<String, String>();
          Map<String, String> codiceMacroMap = new Map<String, String>();
          Map<String, String> numPraticaMap = new Map<String, String>();
          Map<String, String> codiceAnomMap = new Map<String, String>();
          Map<String, String> statoOcsMap = new Map<String, String>();
          Map<String, String> steplogMap = new Map<String, String>();
          Map<String, String> modalitafirmaMap = new Map<String, String>();
          String modalitafirma;
          List<Anomalie_Doc__c> codaSollecitoContratto =AnomalieSelector.selectCodaSollecitoContratto(idCase);
          for(RO_CRMRich_online_steplog__c stepLog: CaseSelector.selectorRichOnlineStepLog(idCase)){
                  modalitafirma =stepLog.RO_CRMModalita_firma__c;
                  modalitafirmaMap.put('modalitafirma',modalitafirma);
                  steplogMap.put('stepLog',stepLog.RO_CRMStep__c);
                  System.debug('************ steplog'+ stepLog.RO_CRMStep__c);
              }
          if(codaSollecitoContratto.size() == 0 ){
            System.debug('************ codaSollecitoContrattoAnomalia is empty '+ codaSollecitoContratto  );
            //se non ho anomalie con Codice_Macro_Documento__c = RIC oppure c'è ma non ha anomalia (è stata sbiancata)
            for(Case c : [select id, stato_ocs__c from case where id in :idCase]){
              if(c.stato_ocs__c == '30'){
                //CGMWSUtils_1_0.abordJobAno(c.Id);
                CGMWSUtils_1_0.abortJobs(jobNamePrefix, String.valueOf(c.Id));
              }
            }
          }else{
            System.debug('************ codaSollecitoContrattoAnomalia is not empty'+ codaSollecitoContratto  );
              for(Anomalie_Doc__c ano: codaSollecitoContratto){
                      cronAfterThirtyMinutes= CaseHandlerTriggerClass.createCronExpressionFromDateTimeThirtyMinutes(ano.LastModifiedDate);
                      cronAfterFiveDays=CaseHandlerTriggerClass.createCronExpressionFromDateTimeFiveDays(ano.LastModifiedDate);
                      idCas=ano.CaseId__c;
                     // idCases.add(ano.CaseId__c);
                      statoOcs=ano.CaseId__r.stato_ocs__c;
                      codiceAnomMap.put('codiceAnom',ano.codice_Anomalia__c);
                      statoOcsMap.put('statoOcs',statoOcs);
                      codiceMacroMap.put('codiceMacro',ano.Codice_Macro_Documento__c);
                      descrizioneAnoMap.put('descrizioneAno',ano.Descrizione_Anomalia_Op__c);
                      numPraticaMap.put('numPratica',ano.CaseId__r.NumeroPratica__c);
                      System.debug('************ cronAfterThirtyMinutes coda before'+ cronAfterThirtyMinutes);
                      System.debug('************ cronAfterFiveDays coda before'+ cronAfterFiveDays);
                      System.debug('************ ano.LastModifiedDate coda before'+ ano.LastModifiedDate);
                      System.debug('************ statoOcsMap coda before'+ statoOcsMap.get('statoOcs'));
                      System.debug('************ codiceAnomMap coda before'+ codiceMacroMap.get('codiceMacro'));
                      System.debug('************ descrizioneAnoMap coda before'+ descrizioneAnoMap.get('descrizioneAno'));
                      System.debug('************ statoOcsMap coda bedfore'+ statoOcsMap.get('statoOcs'));
                      System.debug('************  modalitafirmaMap coda'+ modalitafirmaMap.get('modalitafirma'));
                  
          }
          System.debug('++++++++++++++++++++++++CONDIZIONI_START_DS+++++++++++++++++++++++');
          System.debug('codiceMacroMap.get(codiceMacro)-->'+codiceMacroMap.get('codiceMacro'));
          System.debug('codiceAnomMap.get(codiceAnom)-->'+codiceAnomMap.get('codiceAnom'));
          System.debug('numPraticaMap.get(numPratica)-->'+numPraticaMap.get('numPratica'));
          System.debug('descrizioneAnoMap.get(descrizioneAno)-->'+descrizioneAnoMap.get('descrizioneAno'));
          System.debug('statoOcsMap.get(statoOcs)-->'+statoOcsMap.get('statoOcs'));
          System.debug('steplogMap.get(stepLog)-->'+steplogMap.get('stepLog'));
          System.debug('modalitafirmaMap.get(modalitafirma)-->'+modalitafirmaMap.get('modalitafirma'));
          System.debug('++++++++++++++++++++++++CONDIZIONI_END++++++++++++++++++++++++++');
           if(statoOcsMap.get('statoOcs')=='30' && codiceMacroMap.get('codiceMacro')=='RIC' && 
              codiceAnomMap.get('codiceAnom')!=null && numPraticaMap.get('numPratica')!=null && 
              descrizioneAnoMap.get('descrizioneAno')!=null && steplogMap.get('stepLog')=='Step 8 - Scelta Firma' && 
              (modalitafirmaMap.get('modalitafirma')=='FEA' || modalitafirmaMap.get('modalitafirma')==null)){
              System.debug('++++++++AnomalieDocProductDS.codaSollecitoContratto++++++ ENTRATO STEP1');
              System.debug('************ statoOcsMap coda'+ statoOcsMap.get('statoOcs'));
              System.debug('************ codiceAnomMap coda'+ codiceMacroMap.get('codiceMacro'));
              System.debug('************ descrizioneAnoMap coda'+ descrizioneAnoMap.get('descrizioneAno'));
              System.debug('************ statoOcsMap coda'+ statoOcsMap.get('statoOcs'));
              System.debug('************ steplogMap coda'+ steplogMap.get('stepLog'));
              SchedulableDS anoSchedulAfterThirtyMinutesDS = new SchedulableDS(idCase,AFTER_THIRTY_MINUTES,'');  
              String jobIDAfterThirtyMinutesDS = System.schedule('solContrSchedul_DS-'+idCas+'-'+cronAfterThirtyMinutes, cronAfterThirtyMinutes, anoSchedulAfterThirtyMinutesDS);
              //CGMWSUtils_1_0.abordJobAno (idCas,jobIDAfterThirtyMinutesDS);
              CGMWSUtils_1_0.abortJobs(jobNamePrefix, idCas, jobIDAfterThirtyMinutesDS);
            }
            else if(statoOcsMap.get('statoOcs')=='30' && codiceMacroMap.get('codiceMacro')=='RIC' && 
              codiceAnomMap.get('codiceAnom')!=null && numPraticaMap.get('numPratica')!=null && 
              descrizioneAnoMap.get('descrizioneAno')!=null && steplogMap.get('stepLog')=='Step 8 - Scelta Firma' && 
              modalitafirmaMap.get('modalitafirma')=='CART'){
              System.debug('++++++++AnomalieDocProductDS.codaSollecitoContratto++++++ ENTRATO STEP2');
              System.debug('************ statoOcsMap coda'+ statoOcsMap.get('statoOcs'));
              System.debug('************ codiceAnomMap coda'+ codiceMacroMap.get('codiceMacro'));
              System.debug('************ descrizioneAnoMap coda'+ descrizioneAnoMap.get('descrizioneAno'));
              System.debug('************ statoOcsMap coda'+ statoOcsMap.get('statoOcs'));
              System.debug('************ steplogMap coda'+ steplogMap.get('stepLog'));
              System.debug('************  modalitafirmaMap coda'+ modalitafirmaMap.get('modalitafirma'));
              SchedulableDS anoSchedul = new SchedulableDS(idCase,AFTER_FIVE_DAYS,''); 
              String jobID = System.schedule('solContrSchedul_DS-'+idCas+'-'+cronAfterFiveDays, cronAfterFiveDays, anoSchedul);
              //CGMWSUtils_1_0.abordJobAno(idCas,jobID);
              CGMWSUtils_1_0.abortJobs(jobNamePrefix, idCas, jobID);
            }
            /*else if(statoOcsMap.get('statoOcs')=='30' && codiceMacroMap.get('codiceMacro')!='RIC' ){
                  System.debug('++++++++AnomalieDocProductDS.codaSollecitoContratto++++++ ENTRATO STEP');
                  CGMWSUtils_1_0.abordJobAno(idCas);
            }*/
      }
  return modalitafirma;
}


/*  
* Autheur : Sana Badji 
* @param idCases
* @descriptiion this method check If there are still documentary anomalies after 30min 
    For Product Family : DS
* @date  26/06/2019
 */
      public static List<Case>  checkCodaSolContrattoAfterThirtyMinutes ( Set<Id> idCases){   
            CallWebService.addToQueuAfterCallWebservice(idCases,'Q341','PP_ONLINE_COMPASS_DS');
    return listCaseToUpdate;
}

/*  
* Autheur : Sana Badji 
* @param cronAfterFiveDays
* @param setIdcase
* @descriptiion this method execute the Shedule  after 5 hours
    For Product Family : DS
* @date  01/07/2019
 */
      public static void executeSheduleFiveDays(String cronAfterFiveDays,Set<Id> setIdcase){
       
    }
/*  
* Autheur : Sana Badji 
* @param idCases
* @descriptiion this method check If there are still documentary anomalies after 5 hours
    For Product Family : DS
* @date  26/06/2019
 */
      public static void  checkCodaSolContrattoAfterFiveDays (Set<Id> idCases){
            CallWebService.addToQueuAfterCallWebservice(idCases,'Q341','PP_ONLINE_COMPASS_DS');
  }

  public static void leaveListView(Set<Id> setIdcase) {
    List<Case> cases = [SELECT Id, flagContattoCliente__c from Case where Id in :setIdcase];

    for (Case caseItem : cases) {
      caseItem.flagContattoCliente__c = false;
    }

    update cases;
  }

}