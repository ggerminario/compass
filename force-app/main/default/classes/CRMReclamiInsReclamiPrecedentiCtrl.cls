public without sharing class CRMReclamiInsReclamiPrecedentiCtrl {
	@AuraEnabled
    public static List<Case> getReclami(String clienteCode,String praticaCode, String nReclamo ){
        System.debug('CRMReclamiInsReclamiPrecedentiCtrl getReclami input:\nclienteCode: '+clienteCode+'\npraticaCode: '+praticaCode);
        List<Case> res=[select Id, Categoria_Riferimento__c,Categoria_Riferimento__r.Name,Numero_Reclamo__c,Numero_Progressivo_Reclamo__c,NumeroPratica__c,Numero_Reclamo_Calc__c,
                       Owner.Name,Status,CreatedDate,Subnumber_Reclamo__c,Progressivo_Annuale_Assicurazione__c,Anno__c, Categoria__c
                       from Case
                        where  RecordType.name='CRM_Reclami' and NumeroPratica__c=:praticaCode and AccountId =:clienteCode and (not Numero_Reclamo__c =:nReclamo) and Subject = 'Reclamo'];
       
        return res;
    }
    @AuraEnabled
    public static List<Case> getReclamiMB_Futuro(String clienteCode,String praticaCode, String nReclamo ){
        System.debug('CRMReclamiInsReclamiPrecedentiCtrl getReclamiMB_Futuro input:\nclienteCode: '+clienteCode+'\npraticaCode: '+praticaCode);
        List<Case> res=[select Id, Categoria_Riferimento__c,Categoria_Riferimento__r.Name,Numero_Reclamo__c,Numero_Progressivo_Reclamo__c,NumeroPratica__c,Numero_Reclamo_Calc__c,
                       Owner.Name,Status,CreatedDate,Subnumber_Reclamo__c,Progressivo_Annuale_Assicurazione__c,Anno__c, Categoria__c
                       from Case
                        where  RecordType.name='CRM_Reclami' and NumeroPratica__c=:praticaCode and Account_Futuro_MBCS__c =:clienteCode and (not Numero_Reclamo__c =:nReclamo) and Subject = 'Reclamo'];
        System.debug('CRMReclamiInsReclamiPrecedentiCtrl getReclamiMB_Futuro res: '+res);
        return res;
    }
    @AuraEnabled
    public static List<Case> getReclamiMB_Credit(String clienteCode,String praticaCode, String nReclamo ){
        System.debug('CRMReclamiInsReclamiPrecedentiCtrl getReclamiMB_Credit input:\nclienteCode: '+clienteCode+'\npraticaCode: '+praticaCode);
        List<Case> res=[select Id, Categoria_Riferimento__c,Categoria_Riferimento__r.Name,Numero_Reclamo__c,Numero_Progressivo_Reclamo__c,NumeroPratica__c,Numero_Reclamo_Calc__c,
                       Owner.Name,Status,CreatedDate,Subnumber_Reclamo__c,Progressivo_Annuale_Assicurazione__c,Anno__c, Categoria__c
                       from Case
                        where  RecordType.name='CRM_Reclami' and NumeroPratica__c=:praticaCode and (not Numero_Reclamo__c =:nReclamo) and Subject = 'Reclamo'];
        
        return res;
    }
}