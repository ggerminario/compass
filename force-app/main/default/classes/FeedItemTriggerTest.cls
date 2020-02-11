@isTest
public class FeedItemTriggerTest {

    @testSetup
    public static void setup()
    {
     	Case res=new Case();
        res.ActivityType__c='CRM_RECLAMI';
        res.RecordTypeId=[select Id from RecordType where Name='CRM_Reclami'].Id;
        res.Type='CRM';
        res.Subject='Reclamo';
        Insert res;   
    }
    @isTest
    public static void testInsertNoAttach()
    {
    	Case c = [Select id from Case Where Subject = 'Reclamo'][0];
        String Note = 'nota del test';
        Create_Feed_Item__e myEvent = new Create_Feed_Item__e(
            UtenteId__c = UserInfo.getUserId(),
            Messaggio__c = Note,
            Title__c = 'Corrispondenza',
        	recordId__c = c.id,
            Lista_File__c = ''
        	);
        Test.startTest();
        Database.SaveResult sr = EventBus.publish(MyEvent);
    	Test.stopTest();
    }
}