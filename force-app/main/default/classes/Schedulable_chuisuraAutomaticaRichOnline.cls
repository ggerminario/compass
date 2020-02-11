global  class Schedulable_chuisuraAutomaticaRichOnline implements Schedulable {
    public String query;
    public Datetime dt;
    public  Datetime currentDateTime;
    
    // Compass_query__c  compassQuery;
     global static Boolean testjob = false;
     
    public Schedulable_chuisuraAutomaticaRichOnline() {
    } 
    
    global void execute(SchedulableContext ctx ){
         try{
           Id idjob =  Database.executeBatch(new ChuisuraAutomaticaRichOnline_Batch() );
         }catch(Exception e){
           System.debug('ECCEZIONE-->'+e);
           System.debug(e.getCause());
           System.debug(e.getMessage());
           System.debug('EXCEPTION SCHEDULAZIONE JOB');
         }
        
    }

}