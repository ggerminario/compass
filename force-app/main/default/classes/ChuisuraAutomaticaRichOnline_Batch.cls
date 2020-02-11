/**
  *************** @author Madicke BALDE*********************************************************
  *************** @description : This batch will close all Cases that are registered with an empty 
                                 and that their creation dates are about 7 days for DS and DSP product
                                 and one hour for ECOM Product. Then he puts them in a queue (Q524)
  *************** @date 2019/05/12
 **/
global  class ChuisuraAutomaticaRichOnline_Batch  implements Database.Batchable<sObject>, Database.Stateful{
    public String query; 
    public Datetime dt;
    String famigliaDiProdottiDS ='PP_ONLINE_COMPASS_DS';
    String famigliaDiProdottiPDS ='PP_ONLINE_PARTNER_DS';
    String famigliaDiProdottiECOM ='PF_ECOMMERCE_STANDARD';
    String statusCaseClosed ='Gestito';
    private final Integer GIORNI_RICERCA_CASE = -6; //Default 6 giorni precedenti
    public List<Case> casesUpdated = new List<Case>();
   
   /**
    */
    public ChuisuraAutomaticaRichOnline_Batch() {
        Date d = System.today().addDays(GIORNI_RICERCA_CASE);
        Datetime sdt = datetime.newInstance(d.year(), d.month(),d.day(),00,00,00);
        String startTimeFormat = sdt.format('yyyy-MM-dd\'T\'00:00:00\'Z\'');
        query ='SELECT Id, CreatedDate,Status, Product__r.Name, Product__r.Family, NumeroPratica__c FROM Case WHERE NumeroPratica__c= null AND Codice_Cliente__c = null AND Status != :statusCaseClosed  AND  ( Product__r.Family= :famigliaDiProdottiDS OR Product__r.Family= :famigliaDiProdottiPDS ) AND  CreatedDate <= '+startTimeFormat ;
        System.debug(query);

    }

     public ChuisuraAutomaticaRichOnline_Batch(Datetime dt) {
        this.dt = dt;
        System.debug('********* DateTime Values '+dt);
        query = 'Select Id, CreatedDate, Status, Product__r.Name, Product__r.Family  From Case  Where NumeroPratica__c =null  AND Product__r.Family = :famigliaDiProdottiECOM AND CreatedDate <:dt';
        System.debug(' ************ constructor in  not in 22 h ');
    }
   //Status != :statusCaseClosed
    global Database.QueryLocator start (Database.BatchableContext bc){
        System.debug('********** execute start *******');
        System.debug('famigliaDiProdottiDS-->'+famigliaDiProdottiDS);
        System.debug('statusCaseClosed-->'+statusCaseClosed);
        //System.debug('d-->'+d);
        System.debug('vvvvvvvvvvvvvvvvvv '+query);
       return Database.getQueryLocator(query);
    }

    global void execute(Database.BatchableContext bc, List<Case> list_Cases){
        List<Case> listes = CaseService.changeStatoCase(list_Cases, 'Gestito');
        addDisposion('DP6163', listes);
        if(listes.size() > 0 ) casesUpdated = CaseService.addCaseToQueue(list_Cases, 'Q524');
          
       
    }
    global void finish(Database.BatchableContext bc){
        System.debug('********** finish job ChuisuraAutomaticaRichOnline_Batch *******' + casesUpdated);
       if(casesUpdated.size()  > 0) update casesUpdated;

    }

    public static void addDisposion(String externalId, List<Case> cases){
        XCS_Disposition__c disposition = [SELECT Id FROM XCS_Disposition__c WHERE External_Id__c =: externalId];
        if(disposition.Id != null){
             for(Case c: cases){
             c.Disposition__c = disposition.Id;
        }

        }
    }

}