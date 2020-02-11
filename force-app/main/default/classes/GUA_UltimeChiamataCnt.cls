//----------------------------------------------------------------------
    //-- - Author       : SANA BADJI
    //-- - Date         : 22/10/2019
    //-- - Class  : GUA_UltimeChiamateCnt
    //----------------------------------------------------------------------

public with sharing class GUA_UltimeChiamataCnt {
   
    /**
     * @author Sana Badji
     * @date  30/10/2019
     * @description Method used to get List Campaign 
     **/

    @AuraEnabled
    public static Map<String, Object> getTaskByID(String accountId){
        Map<String, Object> response = new Map<String, Object>();
        //List<Task> ultimeChiamateDealer=null;
        response.put('messageError','');
        response.put('error',false);
        
        try 
        {   
            ///case caseAccount =[select AccountId from Case where id=:idCase];
            /*ultimeChiamateDealer= [SELECT Id, CreatedDate, Description, Categoria__c, Disposition__c , Disposition__r.Name,  Subject, CallObject,CallType,Status,
                                                ActivityDate,CallDisposition,WhatId,What.RecordType.DeveloperName, CreatedBy.Alias
                                        FROM Task Where WhatId in (select Id from Case where AccountId=:accountId) ORDER BY CreatedDate DESC]; 
            */
            List<Case> ultimeChiamateDealer = [select id,Sotto_Categoria__c,(select Id, CreatedDate, Description, Categoria__c, Disposition__c , Disposition__r.Name,  Subject, CallObject,CallType,Status,
            ActivityDate,CallDisposition,WhatId,What.RecordType.DeveloperName, CreatedBy.Name, Note__c from tasks where RecordType.DeveloperName='gua_task') from case where accountId=:accountId];
            List<Case> ultimeChiamate = new List<Case>();
            for(Case c : ultimeChiamateDealer){
                if(c.tasks!=null && c.tasks.size()>0){
                    ultimeChiamate.add(c);
                }
            }
            User u = [select id,Name, Alias from User where id =: userInfo.getUserId()];
            if(ultimeChiamate.size()==0){
                //response.put('ultimeChiamateDealer', new List<Task>());
                response.put('ultimeChiamateDealer', new List<Case>());
            }else{
                //response.put('ultimeChiamateDealer', ultimeChiamateDealer);
                response.put('ultimeChiamateDealer', ultimeChiamate);
            }
            System.debug('ultimeChiamate-->'+ultimeChiamate);
            response.put('operatore', u);
        } catch (Exception e) {
            response.put('error',true);
            response.put('ultimeChiamateDealer', new List<Task>());
            response.put('operatore', null);
            response.put('messageError', e.getLineNumber()+' '+e.getMessage()+' '+e.getCause());
        }
        return response;
    }

}