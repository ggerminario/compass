public with sharing class IVASS_OutsourcerNavigation {
   public Map<String,String> mapParameters {get;set;}
   
   public IVASS_OutsourcerNavigation() {
        mapParameters=ApexPages.currentPage().getParameters();
        System.debug('mapParameters-->'+mapParameters);      
    }

    public Pagereference goToDealer(){
        String ocsCode='D'+mapParameters.get('OCSCode');
        List<Account> lstDealer=[select id from account where OCS_External_Id__c=:ocsCode and recordtype.name='Dealer'];
        if(lstDealer.size()>0)   return redirectPage(lstDealer[0].id);
        else ApexPages.addmessage(new ApexPages.message(ApexPages.severity.WARNING,'OCSCode '+ocsCode+' not found'));

        return null;
    }

     public Pagereference redirectPage(String accountId){
        PageReference pg = new PageReference('/lightning/r/Account/'+accountId+'/view');
        pg.setRedirect(true);
        return pg;
    }
    
}