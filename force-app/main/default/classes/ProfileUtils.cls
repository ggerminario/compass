public class ProfileUtils {

    public static final String MonitoraggioDealer = 'Monitoraggio Dealer';
    
    
    public static Id getProfileId(String profileName){
        Id profileId = [SELECT Id FROM Profile WHERE Name =:profileName][0].Id;
        return profileId;
    }
    
    public static Id getAdminProfile()
    {
		id profileid = [Select id from profile where name = 'System Administrator' OR name = 'Amministratore del sistema'][0].id;
        return profileid;
    }
    
}