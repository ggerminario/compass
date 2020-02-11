global class SFACommodityCheckBatDelete implements Database.Batchable <sObject>, Schedulable {
	
	global Database.QueryLocator start(Database.BatchableContext bcx){
		
		return Database.getQueryLocator([Select Id from SFA_ComCheck__c]);
	
	}
	
	global void execute(Database.BatchableContext bcx, List<SFA_ComCheck__c> scope){
		if(scope.size()>0){
		delete scope;
		}
	
	}
	
	global void execute(SchedulableContext sc) {
        SFACommodityCheckBatDelete batch = new SFACommodityCheckBatDelete(); 
        Database.executebatch(batch);
    }
	
	global void finish(Database.BatchableContext bcx){
		
	}

}