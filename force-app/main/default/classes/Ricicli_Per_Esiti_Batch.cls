/**
* @Author Madicke Balde
* @Modified by Abdoulaye DIOP 11/10/2019
* @date  10/10/2019
**/
global  class Ricicli_Per_Esiti_Batch implements Database.Batchable<sObject>, Database.Stateful {
    public String query;
    public Set<Id> idsCase;
    public String developerNameQueue;
    public Integer numeroRecicli;
    public Integer numeroDiOreLavoro;
    
    /**
     * @Author Madicke Balde
     * @date  10/10/2019
     **/
    public Ricicli_Per_Esiti_Batch(Set<Id> idsCase, String developerNameQueue, Integer numeroRecicli, Integer numeroDiOreLavoro){
      this.idsCase = idsCase;
      this.developerNameQueue = developerNameQueue;
      this.numeroRecicli = numeroRecicli;
      this.numeroDiOreLavoro =  numeroDiOreLavoro;
      query =' SELECT Id, CreatedDate, OwnerId, RO_Tentativo_Ricicli__c,(SELECT Id, CreatedDate, CaseId__c FROM Anomalie_Doc__r ORDER BY CreatedDate DESC LIMIT 1),LastModifiedDate FROM Case WHERE Id IN : idsCase';
    }

    /**
     * @Author Madicke Balde
     * @date  10/10/2019
     **/
    global Database.QueryLocator start(Database.BatchableContext ctx){
       return Database.getQueryLocator(query);
    }
    
    /**
     * @Author Abdoulaye DIOP
     * @date  11/10/2019
     **/
    global void execute(Database.BatchableContext ctx, List<Case> cases){
        List<Case> caseToUpdates = new List<Case>();
        Map<Id,Boolean> mapcheckCaseInQueue = checkCaseInQueue(cases, 'Q525');
        //Boolean checkAnomalieCase= checkAnomalieCase(cases, this.numeroDiOreLavoro );
        if(cases.size() > 0) {
            for(Case c : cases) {
                /*Datetime dateNow = System.now();
                integer intDays =  c.LastModifiedDate.Date().daysBetween(dateNow.Date());
                datetime sameDayEndDate = c.LastModifiedDate.addDays(intDays);
                decimal decHours = ((dateNow.getTime())/1000/60/60) - ((sameDayEndDate.getTime())/1000/60/60);
                System.debug('### decHours '+ decHours);*/

                Double tentativo = 0;
                Map<String, Object> caseMap = (Map<String, Object>) JSON.deserializeUntyped(JSON.serialize(c));
                if (caseMap.keySet().contains('RO_Tentativo_Ricicli__c')) {
                    tentativo = c.RO_Tentativo_Ricicli__c;
                }
                // decHours >= this.numeroDiOreLavoro &&
                /*if (tentativo <= this.numeroRecicli &&  mapcheckCaseInQueue.get(c.Id) !checkAnomalieCase)  {
                    if (tentativo == 0) {
                        c.RO_Tentativo_Ricicli__c = 1;
                    } else {
                        c.RO_Tentativo_Ricicli__c += 1;
                    }
                    caseToUpdates.add(c);
                }*/
                c.RO_Tentativo_Ricicli__c += 1;
                caseToUpdates.add(c);
            }
            if (caseToUpdates.size() > 0) {
                System.debug('#l caseToUpdates ### '+ JSON.serialize(caseToUpdates));                
                updateCase(developerNameQueue, caseToUpdates);
            }
        }
    }

    /**
     * @Author Madicke Balde
     * @date  10/10/2019
     **/
    global void finish(Database.BatchableContext bc){
        System.debug('######################### finish ');
    }

    /**
     * @Author Madicke Balde
     * @Modified by Abdoulaye DIOP 11/10/2019
     * @date  10/10/2019
     **/
    public static void updateCase (String developName, List<Case> caseToUpdate){
       Group gr = CaseService.getQueue(developName);
       for(Case c : caseToUpdate){
           c.OwnerId = gr.Id;
       }
       Recursion.isTriggerExecuting = true;
       update caseToUpdate;
       System.debug('################" case updated '+ caseToUpdate);
    }
    /****************************************************************************************
      *@Madicke BALDE
      *@description
      *@param cases:
      *@param developerName
      *@return Map<Id, Boolean>
     ***************************************************************************************/
    public static Map<Id, Boolean> checkCaseInQueue(List<Case> cases, String developerName){
        Group g = [SELECT Id FROM Group WHERE Type='queue' AND DeveloperName = :developerName ];
        Map<Id, Boolean> returnValue = new Map<Id, Boolean>();
         Boolean b;
        for(Case c : cases){
            b = (c.OwnerId == g.Id) ? true : false;
            returnValue.put(c.Id, b);
        }
        JSON.serialize('#l returnValue checkCaseInQueue '+ JSON.serialize(returnValue));
        return returnValue;
    }
    
    /**************************************************************************************
      *@Author Madicke BALDE
      *@description
      *@param cases :
      @param numeroDiOreLavoro
      *@return Map<Id, Boolean>
     **************************************************************************************/
    /*public static  Boolean checkAnomalieCase(List<Case> cases, Integer numeroDiOreLavoro){
     //    Boolean  returnValue = new Map<Id, Boolean>();

        //Datetime hourBack = Datetime.now().addHours(-numeroDiOreLavoro); 
        Datetime hourBack = System.now().addMinutes(-numeroDiOreLavoro);
        Boolean b = false;
        List<Date> createdDateAnomalies = new List<Date>();
        Case c = cases[0];
        Map<String, Object> caseObjectMap = (Map<String, Object>) JSON.deserializeUntyped(JSON.serialize(c));
        if(caseObjectMap.containsKey('Anomalie_Doc__r')){
            Anomalie_Doc__c anomalie = c.Anomalie_Doc__r[0];            
            List<Anomalie_Doc__c> anomalies = [SELECT Id, CreatedDate, codice_Anomalia__c, Descrizione_Anomalia_Op__c
                                                FROM Anomalie_Doc__c WHERE CreatedDate =:anomalie.CreatedDate AND  CaseId__c =:c.Id];
            
            if (c.Anomalie_Doc__r.size() > 0 && c.Anomalie_Doc__r[0].CreatedDate > hourBack) {
                for(Anomalie_Doc__c ano : anomalies){
                    if( c.Anomalie_Doc__r[0].CreatedDate > hourBack && (String.isNotBlank(ano.codice_Anomalia__c) && String.isNotBlank(ano.Descrizione_Anomalia_Op__c))){
                      b = true;
                      break;
                    }
                }
            }
        }
        
       /* for(Case c  : cases){
            Boolean isAnomalie = false;
            Map<String, Object> caseObjectMap = (Map<String, Object>) JSON.deserializeUntyped(JSON.serialize(c));
            if (caseObjectMap.containsKey('Anomalie_Doc__r')) {
                if (c.Anomalie_Doc__r.size() > 0 && c.Anomalie_Doc__r[0].CreatedDate > hourBack) {
                   for(Anomalie_Doc__c ano : anomalies){
                      if( String.isNotBlank(ano.codice_Anomalia__c) || String.isNotBlank(ano.Descrizione_Anomalia_Op__c)){
                         
                         break;
                      }

                   }

                    b = (c.Anomalie_Doc__r[0].CreatedDate > hourBack  && c.Anomalie_Doc__r[0].codice_Anomalia__c != null && 
                        c.Descrizione_Anomalia_Op__c != null )? false : true;
                    returnValue.put(c.Id, b);
                } else {  
                    returnValue.put(c.Id, true);
                }
            } else {
                returnValue.put(c.Id, true);
            }
        }
        System.debug('#l returnValue '+ JSON.serialize(returnValue));*/
        /*return b;
    }*/

}