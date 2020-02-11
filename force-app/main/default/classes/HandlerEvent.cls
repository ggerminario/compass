public without sharing class HandlerEvent extends TriggerHandler {
  

    public override void afterInsert() {
           
         System.debug('_______HandlerEvent.afterInsert____START');     

//         AppuntomentoQuery.checkCaseInSchedulable(Trigger.new);

         System.debug('_______HandlerEvent.afterInsert____DONE');       
  

    } 
   
}