global  class ContriggerRecent implements Comparable {
    public CronTrigger ctriger;
    public ContriggerRecent(CronTrigger ctr) {
        this.ctriger = ctr;

    }
    global Integer compareTo(Object compareTo){
        ContriggerRecent ctrRecent = (ContriggerRecent) compareTo;
        Integer returnValue = 0;
        if(ctriger.CreatedDate < ctrRecent.ctriger.CreatedDate  ){ 
            returnValue = 1;
         
        }
        else if (ctriger.CreatedDate >  ctrRecent.ctriger.CreatedDate){
              returnValue = -1; 
        }
         System.debug('********* returnValue '+returnValue);
         return returnValue;

    }
}