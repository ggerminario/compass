public class XCS_CaseListComponentControllerApex {
    
    @AuraEnabled
    public static List<Case> doInitApex(String caseId, String caseStatus, String filter){
        //MANTIS 0002246 - START
        Set<String> setCaseStatus = new Set<String>();
        if(caseStatus!= null){
            for(String s : caseStatus.split(',')){
                setCaseStatus.add(s);
            }
        }
        
        Case currentCase= [SELECT AccountId FROM Case WHERE Id=: caseId];
        if(String.isNotBlank(currentCase.AccountId)){
            String accountId = currentCase.AccountId;
            String addFilter = '';
            System.debug('filter-->'+filter);
            System.debug('setCaseStatus-->'+setCaseStatus);
            if(String.isNotBlank(filter)) addFilter = 'AND '+ filter;
            if(setCaseStatus!=null && setCaseStatus.size()>0) addFilter = 'AND Status in :setCaseStatus';
            //return [SELECT AccountId, Categoria_Rif_Parent__c, Esito__c, CaseNumber, Id, Status, CreatedDate, Categoria_Riferimento__r.Name,Subject FROM Case WHERE AccountId=: currentCase.AccountId AND Status in :setCaseStatus ORDER BY CreatedDate DESC];
            String query = 'SELECT AccountId, Categoria_Rif_Parent__c, Esito__c, CaseNumber, Id, Status, CreatedDate, Categoria_Riferimento__r.Name,Subject FROM Case WHERE AccountId=:accountId '+addFilter+' ORDER BY CreatedDate DESC';
            return Database.query(query);
            //MANTIS 0002246 - DONE
        }
        else{
            return new List<Case>();
        }
    }
}