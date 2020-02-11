/* 
* Autheur : Sana Badji 
* description Class created for handle  Anomalie by Family: DS
* @date  27/06/2019
*/

public with sharing class AnomalieDocProductDSP {
  public static final String AFTER_FIVE_DAYS = 'afterFiveDays';
   public static String cronAfterThreeHours;
  public static final String AFTER_THREE_THREE_HOURS = 'afterThreeHours';
  public static String cronAfterThirtyMinutes;
  public static final String AFTER_THIRTY_MINUTES = 'afterThirtyMinutes';
  public static String cronAfterFiveDays;
  public static  Set<Id> idCase = new Set<Id>();
  public static   List<Case> listCaseToUpdate = new List<Case>();

    public AnomalieDocProductDSP() {

    }

/* 
    * Autheur : Sana Badji 
    * @param idAccount
    * @param idAno
    * @date  16/05/2019
    */  
      public static void  dEMAnomalieDocumentaliDSP (Id idAccount, Set<Id> idAno ){
            List<Anomalie_Doc__c> anomalibyId =AnomalieSelector.anomalieByID(idAno);
           // List<XCS_Template__c> templateAnoContpp = AnomalieSelector.templateTesto('SMSAnomalieContratto_DSP');
            //List<XCS_Template__c> templateAnoDocppPartener = AnomalieSelector.templateTesto('SMSAnomalieDoc_DSP');
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
            Map<String, String> descrizioneAnoMap = new Map<String, String>();
            Map<String, String> codiceMacroMap = new Map<String, String>();
            Map<String, String> numPraticaMap = new Map<String, String>();
            Map<String, String> codiceAnomMap = new Map<String, String>();
            if(anomalibyId.size() ==0){
              System.debug('******** anomalibyId is empty'+anomalibyId.size());
            }
            else
              {
                  for(Anomalie_Doc__c ano: anomalibyId ){
                    System.debug('******** Codice_Macro_Documento__c AnoDocumentali '+ano.Codice_Macro_Documento__c);
                    System.debug('******** codice_Anomalia__c AnoDoc'+ano.codice_Anomalia__c);
                    System.debug('******** Descrizione_Anomalia_Op__c Anoc'+ano.Descrizione_Anomalia_Op__c);
                      if(ano.Descrizione_Anomalia_Cliente__c!=null){
                            bodyNote+=ano.descrizione_Macro_Doc__c+' : '+ano.Descrizione_Anomalia_Cliente__c;
                      }   
                    caseId= ano.CaseId__c;
                    numPratica=ano.CaseId__r.NumeroPratica__c;
                    codiceAnom=ano.codice_Anomalia__c;
                    codiceMacro=ano.Codice_Macro_Documento__c;
                    descrizioneAno=ano.Descrizione_Anomalia_Op__c;
                    idCase.add(ano.CaseId__c);      
                   // bodyNote=ano.Codice_Macro_Documento__c +' '+ano.Descrizione_Anomalia_Cliente__c;
                    telefonoCellulare=getAccount.PersonMobilePhone;
                    roLinkbozza= ano.CaseId__r.RO_Link_Bozza__c;
                    email=getAccount.PersonEmail;
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
                      numPraticaMap.get('numPratica')!=null && descrizioneAnoMap.get('descrizioneAno')!=null){
                     // Send Mail 
                      CaseDomain.mailDem('2555', caseId,'Prestito Online CheBanca!: firma contratto', 
                      'PrestitoonlineCheBanca@compass.it', 'Compass Banca S.p.A');
                      // Send SMS
                      //OCSInviaSMSInvoker.inviaSMS('',telefonoCellulare,'','',templateAnoContpp[0].Body__c);
                      CaseDomain.sendSMS(telefonoCellulare,'SMSAnomalieContratto_DSP');
                      // Create Note
                      CallWebService.createNote('Inviata mail DEMAnomalieContratto_PP_CB',email,roLinkbozza,bodyNote,caseId);
                      System.debug('************ DEM AND SMS Anomalie Contratto PP Partner  sended succesfully');              }
            else if(idCase.contains(caseId) && codiceMacroMap.get('codiceMacro')!='RIC' && codiceAnomMap.get('codiceAnom')!=null &&
                      numPraticaMap.get('numPratica')!=null && descrizioneAnoMap.get('descrizioneAno')!=null){
                    // Send Mail 
                      CaseDomain.mailDem('2554', caseId,'Prestito online CheBanca!: richiesta con anomalie', 
                      'PrestitoonlineCheBanca@compass.it', 'Compass Banca S.p.A');
                      // Send SMS
                      //OCSInviaSMSInvoker.inviaSMS('',telefonoCellulare,'','',templateAnoDocppPartener[0].Body__c);
                      CaseDomain.sendSMS(telefonoCellulare,'SMSAnomalieDoc_DSP');
                      // Create Note
                      CallWebService.createNote('Inviata mail DEMAnomalieDoc_PP_CB',email,roLinkbozza,bodyNote,caseId);
                      System.debug('************ DEM AND SMS Anomalie Documentali PP Partner');
              }
               else if(idCase.contains(caseId) && codiceAnomMap.get('codiceAnom')==null && descrizioneAnoMap.get('descrizioneAno')==null &&
                    numPraticaMap.get('numPratica')!=null){
                    // Create Note
                    CallWebService.createNote('nessuna anomalia inviata',email,roLinkbozza,bodyNote,caseId);
                    System.debug('************ nessuna anomalia inviata');
              }
        }
      }
 
/*  
* Autheur : Sana Badji 
* @param idAccount
* @param idAno
* @date  16/05/2019
     */
  public static void  dEMAccountReassuranceDSP (Id idAccount, Set<Id> idAno){
            List<Anomalie_Doc__c> anomalibyId = AnomalieSelector.anomalieByID(idAno);
            //List<XCS_Template__c> templateRassCliente = AnomalieSelector.templateTesto('SMSRassicuraCliente_DSP');
            Account getAccount=AnomalieSelector.getAccount(idAccount);
            String telefonoCellulare;
            Id  caseId;
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
            if(anomalibyId.size() == 0){
              System.debug('******** anomalibyId is empty'+anomalibyId.size());
            }
            else{
                for(Anomalie_Doc__c ano: anomalibyId ){
                    if(ano.Descrizione_Anomalia_Cliente__c!=null){
                          bodyNote+=ano.descrizione_Macro_Doc__c+' : '+ano.Descrizione_Anomalia_Cliente__c;
                         }   
                  caseId= ano.CaseId__c;
                  numPratica=ano.CaseId__r.NumeroPratica__c;
                  statoOcs=ano.CaseId__r.stato_ocs__c;
                  codiceAnom=ano.codice_Anomalia__c;
                  descrizioneAno=ano.Descrizione_Anomalia_Op__c;
                  bodyNote=ano.Codice_Macro_Documento__c +' '+ano.Descrizione_Anomalia_Cliente__c;
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
                  Case c = [select id,Product__r.DEMRassicuraCliente__c,Product__r.SMSRassicuraCliente_DS__r.Name FROM Case where id=:caseId];
                   // Send Mail 
                  /*CaseDomain.mailDem('2725', caseId, getAccount.Name+', manca poco per conoscere l\'esito del Prestito Online Compass!', 
                  'richiesta@compass.it', 'Compass Banca S.p.A');
                  // Send SMS
                  //OCSInviaSMSInvoker.inviaSMS('',telefonoCellulare,'','',templateRassCliente[0].Body__c);
                  CaseDomain.sendSMS(telefonoCellulare,'SMSRassicuraCliente_DSP');*/
                  CGMWSUtils_1_0.sendNotifications(new List<Case>{c},'DEMRassicuraCliente__c','SMSRassicuraCliente_DS__c',CGMWSUtils_1_0.EMAIL_NO_REPLY, CGMWSUtils_1_0.EMAIL_LABEL_COMPASS);
                  // Create Note
                  CallWebService.createNote('Inviata mail DEMRassicuraCliente_DS',email,roLinkbozza,bodyNote,caseId);
                  System.debug('********Rassicura Cliente DSP');
              }
  }
}

  /* 
  * Autheur : Sana Badji 
  * @param idsetCases
  * @date  28/05/2019
  */
      public static void  checkAnoPPPartnersThreeHours (Set<Id> caseIds ){
            CallWebService.addToQueuAfterCallWebservice(caseIds,'Q376','PP_ONLINE_PARTNER_DS');     
  }

/* 
* Autheur : Sana Badji 
* @param caseIds
* @date  20/05/2019
     */
      public static String anomaliePPPartners  (Set<Id> caseIds){
          List<Anomalie_Doc__c> anomalibyId=AnomalieSelector.listAnomalieByID(caseIds);
          Account getAccount;
          String statoOcs;
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
                getAccount=AnomalieSelector.getAccount(ano.CaseId__r.AccountId);
                System.debug('******** ano.CaseId__r.stato_ocs__c '+ano.CaseId__r.stato_ocs__c);
                System.debug('******** ano.Descrizione_Anomalia_Op__c '+ano.Descrizione_Anomalia_Op__c);
                System.debug('********  ano.CaseId__r.RO_Vecchio_Cellulare__c '+ ano.CaseId__r.RO_Vecchio_Cellulare__c);
                System.debug('********  getAccount.getCodice_Cliente__c '+ getAccount.getCodice_Cliente__c);    
                idCas=ano.CaseId__c;
                System.debug('********  ano.CaseId__r.Is_Discordanza_Cellulare__c '+ ano.CaseId__r.Is_Discordanza_Cellulare__c);
                statoOcs=ano.CaseId__r.stato_ocs__c;
                cronAfterThreeHours= CaseHandlerTriggerClass.createCronExpressionFromDateTimeThreeHours(ano.LastModifiedDate);
                statoOcsMap.put('statoOcs',statoOcs);
                descrizioneAnoMap.put('descrizioneAno',ano.Descrizione_Anomalia_Op__c);
                isDisco.put('isDisco',ano.CaseId__r.Is_Discordanza_Cellulare__c);
                numPraticaMap.put('numPratica',ano.CaseId__r.NumeroPratica__c);
                System.debug('******** statoOcs added'+statoOcs);
          }
          if((statoOcsMap.get('statoOcs')=='05BT' || statoOcsMap.get('statoOcs')=='10') && numPraticaMap.get('numPratica')!=null 
          && (descrizioneAnoMap.get('descrizioneAno')!=null || isDisco.get('isDisco')==true)){
            System.debug('********lancio job 3 ore');  
            SchedulableDSP anoSchedulAfterThreeHoursDSP = new SchedulableDSP(caseIds,AFTER_THREE_THREE_HOURS,'');
                   // CGMWSUtils_1_0.abordJobAno(idCase);
              String jobIDAfterThreeHoursDSP = System.schedule('anoSchedul_DSP-'+idCas+'-'+cronAfterThreeHours, cronAfterThreeHours, anoSchedulAfterThreeHoursDSP);
              //CGMWSUtils_1_0.abordJobAno(idCas,jobIDAfterThreeHoursDSP);
              CGMWSUtils_1_0.abortJobs('anoSchedul_DSP-', idCas, jobIDAfterThreeHoursDSP);

              System.debug('################### jobIDAfterThreeHoursDSP PP Partner '+anoSchedulAfterThreeHoursDSP);

          }
          else if((statoOcsMap.get('statoOcs')=='05BT' || statoOcsMap.get('statoOcs')=='10') && 
                (descrizioneAnoMap.get('descrizioneAno')==null && isDisco.get('isDisco')==false)) {
                //CGMWSUtils_1_0.abordJobAno(idCas);
                System.debug('********elimino tutti i job per il case -->'+idCas);  
                CGMWSUtils_1_0.abortJobs('anoSchedul_DSP-', idCas);
          }
    }
    return statoOcs;
  }

/*  
* Autheur : Sana Badji 
* @param idCases
* @descriptiion this method check If there are still documentary anomalies after 5 hours
    For Product Family : DSP
* @date  26/06/2019
 */
      public static void  checkCodaSolContraPPPartnersAfterFiveDays ( Set<Id> idCases){
        
            CallWebService.addToQueuAfterCallWebservice(idCases,'Q341','PP_ONLINE_PARTNER_DS');
}


/*  
* Autheur : Sana Badji 
* @param idCase
* @date  20/05/2019
     */
      public static String  codaSollecitoContratto  (Set<Id> idCase){
          Id idCas;
          String statoOcs ; 
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
            for(Case c : [select id,stato_ocs__c from case where id in :idCase]){
              if(c.stato_ocs__c == '30'){
                CGMWSUtils_1_0.abordJobAno(c.Id);
              }
            }
          }else{
            System.debug('************ codaSollecitoContrattoAnomalia is not empty'+ codaSollecitoContratto  );
              for(Anomalie_Doc__c ano: codaSollecitoContratto){
                      System.debug('************ Descrizione_Anomalia_Op__c'+ ano.Descrizione_Anomalia_Op__c);
                      System.debug('************ ano.Codice_Macro_Documento__c'+ ano.Codice_Macro_Documento__c);
                      System.debug('************ ano.codice_Anomalia__c'+ ano.codice_Anomalia__c);
                      System.debug('************ ano.Descrizione_Anomalia_Op__c'+ ano.Descrizione_Anomalia_Op__c);
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
                  
          }

          System.debug('++++++++++++++++++++++++CONDIZIONI_START_DSP+++++++++++++++++++++++');
          System.debug('codiceMacroMap.get(codiceMacro)-->'+codiceMacroMap.get('codiceMacro'));
          System.debug('codiceAnomMap.get(codiceAnom)-->'+codiceAnomMap.get('codiceAnom'));
          System.debug('numPraticaMap.get(numPratica)-->'+numPraticaMap.get('numPratica'));
          System.debug('descrizioneAnoMap.get(descrizioneAno)-->'+descrizioneAnoMap.get('descrizioneAno'));
          System.debug('statoOcsMap.get(statoOcs)-->'+statoOcsMap.get('statoOcs'));
          System.debug('steplogMap.get(stepLog)-->'+steplogMap.get('stepLog'));
          System.debug('modalitafirmaMap.get(modalitafirma)-->'+modalitafirmaMap.get('modalitafirma'));
          System.debug('++++++++++++++++++++++++CONDIZIONI_END++++++++++++++++++++++++++');
           if(codiceMacroMap.get('codiceMacro')=='RIC' && codiceAnomMap.get('codiceAnom')!=null &&
              numPraticaMap.get('numPratica')!=null && descrizioneAnoMap.get('descrizioneAno')!=null && 
              statoOcsMap.get('statoOcs')=='30' &&  steplogMap.get('stepLog')=='Step 8 - Scelta Firma' && 
              (modalitafirmaMap.get('modalitafirma')=='FEA' || modalitafirmaMap.get('modalitafirma')==null)){
              System.debug('++++++++AnomalieDocProductDSP.codaSollecitoContratto++++++ ENTRATO STEP1');
              SchedulableDSP anoSchedulAfterThirtyMinutesDSP = new SchedulableDSP(idCase,AFTER_THIRTY_MINUTES,'');
              String jobIDAfterThirtyMinutesDSP = System.schedule('anoSchedul_DSP-'+idCas+'-'+cronAfterThirtyMinutes, cronAfterThirtyMinutes, anoSchedulAfterThirtyMinutesDSP);
              CGMWSUtils_1_0.abordJobAno(idCas,jobIDAfterThirtyMinutesDSP); 
              }
             else if(statoOcsMap.get('statoOcs')=='30' && codiceMacroMap.get('codiceMacro')=='RIC' && 
              codiceAnomMap.get('codiceAnom')!=null && numPraticaMap.get('numPratica')!=null && 
              descrizioneAnoMap.get('descrizioneAno')!=null && steplogMap.get('stepLog')=='Step 8 - Scelta Firma' && 
              modalitafirmaMap.get('modalitafirma')=='CART'){
              System.debug('++++++++AnomalieDocProductDSP.codaSollecitoContratto++++++ ENTRATO STEP2');
              System.debug('************ statoOcsMap coda'+ statoOcsMap.get('statoOcs'));
              System.debug('************ codiceAnomMap coda'+ codiceMacroMap.get('codiceMacro'));
              System.debug('************ descrizioneAnoMap coda'+ descrizioneAnoMap.get('descrizioneAno'));
              System.debug('************ statoOcsMap coda'+ statoOcsMap.get('statoOcs'));
              System.debug('************ steplogMap coda'+ steplogMap.get('stepLog'));
              SchedulableDSP anoSchedul = new SchedulableDSP(idCase,AFTER_FIVE_DAYS,'');  
              String jobID = System.schedule('anoSchedul_DSP-'+idCas+'-'+cronAfterFiveDays, cronAfterFiveDays, anoSchedul);
              CGMWSUtils_1_0.abordJobAno(idCas,jobID); 
                             // CGMWSUtils_1_0.abordJobAno(idCas,jobID);
            }
            /*else if(statoOcsMap.get('statoOcs')=='30' && codiceMacroMap.get('codiceMacro')!='RIC'){
              System.debug('++++++++AnomalieDocProductDSP.codaSollecitoContratto++++++ ENTRATO STEP3');
              CGMWSUtils_1_0.abordJobAno(idCas);
            }*/
      }
  return modalitafirma;
}

/*  
* Autheur : Sana Badji 
* @param idCases
* @descriptiion this method check If there are still documentary anomalies after 30 minutes
    For Product Family : DSP
* @date  26/06/2019
 */
      public static List<Case>  checkCodaSolContraPPPartnersAfterThirtyMinutes (Set<Id> idCases){
            CallWebService.addToQueuAfterCallWebservice(idCases,'Q341','PP_ONLINE_PARTNER_DS');
  return listCaseToUpdate;
}



/*  
* Autheur : Sana Badji 
* @descriptiion this method execute the Shedule  after 5 hours
    For Product Family : DSP
* @date  01/07/2019
 */
      public static void executeSheduleFiveDays(String cronAfterFiveHours,Set<Id> setIdcase){
        
}

}