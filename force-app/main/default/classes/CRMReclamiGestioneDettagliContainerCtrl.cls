public class CRMReclamiGestioneDettagliContainerCtrl {
    
    @AuraEnabled
    public static Map<String,List<Object>> getModInvio(){
        Map<String,List<Object>> res = new Map<String,List<Object>>();
        List<String> modalita = new List<String>();
        Schema.DescribeFieldResult fieldResultMod = Case.Modalita_Invio__c.getDescribe();
        List<Schema.PicklistEntry> ple = fieldResultMod.getPicklistValues();
        for(Schema.PicklistEntry pickListVal:ple){
            modalita.add(pickListVal.getLabel());
        }
        
        res.put('modList', modalita);
        return res;
    }
    
    @AuraEnabled
    public static String getMod(String recordId){
        Case c = [Select Modalita_Invio__c from case where id =: recordId];
        
        String modalita = '';
        Schema.DescribeFieldResult fieldResultMod=Case.Modalita_Invio__c.getDescribe();
        List<Schema.PicklistEntry> ple=fieldResultMod.getPicklistValues();
       	if(c.Modalita_Invio__c == null) return '';
        for(Schema.PicklistEntry pickListVal:ple){
            if(c.Modalita_Invio__c.equalsIgnoreCase(pickListVal.getValue()))
                modalita = pickListVal.getLabel();
        }
        return modalita;
    }
    @AuraEnabled
    public static Datetime getDecisione(String recordId){
        Case c = [Select Data_Decisione__c from case where id =: recordId];
    
        return c.Data_Decisione__c;
        
    }

   
}