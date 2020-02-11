/*
* Autheur : Sana Badji
* description Class created for handle  Anomalie by Family: Ecommerce
* @date  27/06/2019
*/

public with sharing class AnomalieDocProductEcommerce {
public static final String AFTER_TWO_TWO_HOURS = 'afterTwoHours';
public static String cronAfterThirtyMinutes;
public static final String AFTER_THIRTY_MINUTES = 'afterThirtyMinutes';
public static String bodyNote;
public static String jobIDEcom;
public static String email;
public static String roLinkbozza;
public static Set<Id> idCase= new Set<Id>();
public static Id idAccount;
public static Id caseId ;
public static Account getAccount;
public static Id idCas;
public static String statoOcs ; 
public static String crOnTwoHours;
public static Map<String, String> stepLogMap = new Map<String, String>();
public static Map<String, String> numPraticaMap = new Map<String, String>();
public static SchedulableEcommerce anoSchedulEcomAfterThirtyMinutes;
public static SchedulableEcommerce anoSchedul;
/*
* Autheur : Sana Badji
* @param idsetCases
* @description
    Method execute After 30 minutes of inactivity of the client
    the DEM mail "Abandonment E-commerce" will be sent
(last modified date> 30mn)
* @param idCases
* @date  24/06/2019
     */
      public static void  abbandonoPostCaricoOCSAfterThirtyMinutes(Set<Id> idCases){
          List<RO_CRMRich_online_steplog__c> steplogByCase = CaseSelector.SelectorRichOnlineStepLog(idCases);
          Id caseId;
          String bodyNote;
             for(RO_CRMRich_online_steplog__c steplog: steplogByCase){
                  roLinkbozza=steplog.RO_CRMRichiesta_Online__r.RO_Link_Bozza__c;
                  email=steplog.RO_CRMRichiesta_Online__r.Account.PersonEmail;
                  caseId=steplog.RO_CRMRichiesta_Online__c;
                  bodyNote='';
                  crOnTwoHours= CaseHandlerTriggerClass.createCronExpressionFromDateTimeTwoHours(steplog.RO_CRMRichiesta_Online__r.LastModifiedDate);
                  System.debug('************ crOnTwoHours '+steplog.RO_CRMRichiesta_Online__r.LastModifiedDate);
             }
              CaseDomain.mailDem('2070', caseId,  'Ripresa Bozza E-commerce!',  
                    'noreply@compass.it', 'Compass Banca S.p.A ');
              CallWebService.createNote('Inviata mail DEMAbbandonoEcommerce',email,roLinkbozza,bodyNote,caseId);
              System.debug('************ Abbandono E-commerce sended successfully');
              //anoSchedul = new SchedulableEcommerce(idCases,AFTER_TWO_TWO_HOURS);
              //String jobID = System.schedule('anoSchedul_Ecom-'+caseId+'-'+crOnTwoHours+'-'+'TwoHours', crOnTwoHours, anoSchedul);
              //CGMWSUtils_1_0.abordJobAno(caseId,jobID);
  }

/*
* Autheur : Sana Badji
* @param idCases
* @description
    Method execute After 2 hours, if the customer has not carried out any operation,
    The request will be entered into "Abandonment E-commerce" queue managed by RTC (Lastmodified Date> 2 hours)
* @date  24/06/2019
  */
      public static void  abbandonoPostCaricoOCSAfterTwoHours(Set<Id> idCases){     
              CallWebService.addToQueuAfterCallWebservice(idCases,'Q336','PF_ECOMMERCE_STANDARD');           
}

    public static Id checkAbbandonoPostCaricoOCS(List<RO_CRMRich_online_steplog__c> steplogByCase){

          for(RO_CRMRich_online_steplog__c steplog: steplogByCase){
                    caseId=steplog.RO_CRMRichiesta_Online__c;
                    idCase.add(caseId);
                    cronAfterThirtyMinutes= CaseHandlerTriggerClass.createCronExpressionFromDateTimeThirtyMinutes(steplog.LastModifiedDate);
                    stepLogMap.put('steplog',steplog.RO_CRMStep__c);
                    numPraticaMap.put('numPratica',steplog.RO_CRMRichiesta_Online__r.NumeroPratica__c);
                    System.debug('stepLogMap'+ stepLogMap.get('steplog') );
                    System.debug('numPratica'+ numPraticaMap.get('numPratica'));
                  }
            if((stepLogMap.get('steplog')!='Step 5 - Upload Document' || stepLogMap.get('steplog')!='Step 8 - Scelta Firma')
                  && numPraticaMap.get('numPratica')!=null){
              anoSchedulEcomAfterThirtyMinutes = new SchedulableEcommerce(idCase,AFTER_THIRTY_MINUTES);
              jobIDEcom = System.schedule('anoSchedul_Ecom-'+caseId+'-'+cronAfterThirtyMinutes, cronAfterThirtyMinutes, anoSchedulEcomAfterThirtyMinutes);
            //   if(CaseSelector.getStatusjobIDEcom(jobIDEcom).get('idJobEcom')==caseId){
            //        CGMWSUtils_1_0.abordJobAno(caseId,jobIDEcom);
            //   }
            //   CGMWSUtils_1_0.abordJobAno(caseId,jobIDEcom);
               System.System.debug('getStatusjobIDEcom before'+CaseSelector.getStatusjobIDEcom(jobIDEcom).get('idJobEcom'));
                        // if(CaseSelector.getStatusjobIDEcom(jobIDEcom).get('state')=='DELETED'){
                        //       System.System.debug('getStatusjobIDEcom after cronAfterThirtyMinutes'+CaseSelector.getStatusjobIDEcom(jobIDEcom).get('state'));}
              }else {
          //    CGMWSUtils_1_0.abordJobAno(caseId);
            }
         return caseId;
}


}