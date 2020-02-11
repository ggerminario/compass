public class XCSReclamiNumProgressivoUtils {

    public static final String PREFIX_TEMP = 'TEMP';

    public static String getProgAnnAss(String referenceCompany){
        String res='';
        
        XCS_Sequence_Numero_Assicurativo__c obj=new XCS_Sequence_Numero_Assicurativo__c(Name = PREFIX_TEMP+referenceCompany);
        insert obj;
        // start Trigger (increment Numero_Progressivo_Annuale__c)
        delete obj;
        res= String.valueOf([select Numero_Progressivo_Annuale__c FROM XCS_Sequence_Numero_Assicurativo__c WHERE Name =:referenceCompany  LIMIT 1].Numero_Progressivo_Annuale__c);
        
        System.debug('XCSReclamiNumProgressivoUtils getProgAnnAss res: '+res);

	   return res;
    }
    
    public static String getNumProgRec(String referenceCompany){
        String res='';  
        XCS_Sequence_Numero_Reclamo__c obj=new XCS_Sequence_Numero_Reclamo__c(Name = PREFIX_TEMP+referenceCompany);
        insert obj;
        // start Trigger (increment Numero_Progressivo__c)
        delete obj;
        res = String.valueOf([select Numero_Progressivo__c from XCS_Sequence_Numero_Reclamo__c WHERE Name =:referenceCompany LIMIT 1].Numero_Progressivo__c);
        System.debug('XCSReclamiNumProgressivoUtils getNumProgRec res: '+res);
	
    	return res;
    }
}