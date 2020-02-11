public class CRMReclamiInsDettagliContainerController {
	@AuraEnabled
    public static List<String> getContattiPrecedenti(){
        List<String> res=new List<String>();
        Schema.DescribeFieldResult fieldResult=Case.Contatto_Precedente__c.getDescribe();
        List<Schema.PicklistEntry> ple=fieldResult.getPicklistValues();
        for(Schema.PicklistEntry pickListVal:ple){
            res.add(pickListVal.getLabel());
        }    
        return res;
    }

// METODO PER LA GESTIONE DELLE COMUNICAZIONI PRESA IN CARICO
// DA DECOMMENTARE QUANDO CI DANNO L'OK
// 09/01/2020
//    @AuraEnabled
//    public static List<String> getComunicazioniPresaInCarico(){
//        List<String> res=new List<String>();
//        Schema.DescribeFieldResult fieldResult=Case.ComunicazionePresaInCarico__c.getDescribe();
//        List<Schema.PicklistEntry> ple=fieldResult.getPicklistValues();
//        for(Schema.PicklistEntry pickListVal:ple){
//            res.add(pickListVal.getLabel());
//        }    
//        return res;
//    }
    
}