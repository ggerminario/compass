public class CRMRetentionRedirectController 
{
	@AuraEnabled
    public static XCSMenuActionResult initCarte(String accountid)
    {
        return CRMRetentionUtil.createRetentionCarte(accountId);
    }
    @AuraEnabled 
    public static XCSMenuActionResult initPrestiti(String accountid)
    {
        return CRMRetentionUtil.redirectRetentionPrestiti(accountid);
    }
    
    
}