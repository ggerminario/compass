/* 
* Autheur : Sana Badji 
* description Class created for handle Method to call on Trigger
* @date  16/05/2019
*/
 
public  class CaseHandlerTriggerClass { 
     public static String cronAfterThreeHours;
     public static String cronAfterThirtyMinutes;
     public static String cronAfterTwoHours;
     public static String cronAfterFiveDays;
     public static final String AFTER_THIRTY_MINUTES = 'afterThirtyMinutes';
     public static final String AFTER_THREE_THREE_HOURS = 'afterThreeHours';
     public static final String AFTER_TWO_TWO_HOURS = 'afterTwoHours';
     public static List<Case> caseProductDS = new List<Case>();
     public static List<Case> caseProductDSP = new List<Case>();
     public static List<Case> caseProductEcommerce = new List<Case>();

     
     public static void  caseHandlerDispatcher(List<Case> caseList, Set<Id> idsToProcess){
    
}
/*  
* Autheur : Sana Badji 
* @param Date Time
* @date  20/06/2019
*/
public static String createCronExpressionFromDateTimeThreeHours(DateTime fireTime) {
          DateTime newTime = fireTime.addMinutes(CGMWSUtils_1_0.GIACENZA_PRE_POST_SIC);
          return getcronExpression(newTime);
     }


/*  
* Autheur : Sana Badji 
* @description method created for handle Cron Expression FromDateTime for 30min
* @param Date Time
* @date  20/06/2019
*/
public static String createCronExpressionFromDateTimeThirtyMinutes(DateTime fireTime) {
          DateTime newTime = fireTime.addMinutes(30);
          return getcronExpression(newTime);
     }


/*  
* Autheur : Sana Badji 
* @param idsetCases
* @description method created for handle Cron Expression FromDateTime for 2hour
* @param Date Time
* @date  20/06/2019
*/
public static String createCronExpressionFromDateTimeTwoHours(DateTime fireTime) {
          DateTime newTime = fireTime.addMinutes(120);
          return getcronExpression(newTime);
     }

public static String createCronExpressionFromDateTimeFiveDays(DateTime fireTime) {
          DateTime newTime = fireTime.addMinutes(CGMWSUtils_1_0.GIACENZA_5_GIORNI);
          return getcronExpression(newTime);
          
     }

public static String getcronExpression(DateTime newTime){
     List<String> timeParts = new List<String>();
     String daysAdded= String.valueOf(newTime.format('dd'));
     String hour= String.valueOf(newTime.format('HH'));
     String minAdded= String.valueOf(newTime.format('mm'));
     String min= String.valueOf(newTime.format('mm'));
     String sec= String.valueOf(newTime.format('ss'));
     timeParts.add(String.valueof(sec));
     timeParts.add(String.valueof(minAdded));
     timeParts.add(String.valueof(hour));
     timeParts.add(String.valueof(daysAdded));
     timeParts.add(String.valueOf(newTime.month()));
     timeParts.add('?');
     timeParts.add(String.valueOf(newTime.year()));
     return String.join(timeParts, ' ');
}


@future (callout=true)
     Public static void updateStatoOcs(Set<Id> idsToProcess)
     {
          String statoOcs= CallWebService.recuperaRequestPreSic(idsToProcess);
          System.debug('tipo pratica-->'+CallWebService.tipoPratica);
            if(statoOcs!=null){
                CallWebService.updateStatoOcs(idsToProcess,statoOcs,CallWebService.tipoPratica);
            }else{
                System.debug('************ statoOcs is  '+statoOcs);
            }
     }
@future (callout=true)
     Public static void checkCaseToInsertBeforeDelete(Set<Id> idsToProcess)
     {
          CaseService.checkCaseToInsertBeforeDelete(idsToProcess);
     }

@future (callout=true)
     Public static void updateCaseChangeQueue(Set<Id> idsToProcess)
     {
          CallWebService.updateCaseChangeQueue(idsToProcess);
     }


}