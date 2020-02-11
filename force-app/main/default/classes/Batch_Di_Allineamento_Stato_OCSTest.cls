@istest
public class Batch_Di_Allineamento_Stato_OCSTest {
	static testmethod void Batch_Di_Allineamento_Stato_OCS_TestMethod(){
        DateTime dates = Datetime.newInstance(2019, 5, 28, 1, 6, 8);
        List<Case> v1 = new List<Case>{
        new Case (RO_Link_Bozza__c='xxx',RO_Engine_channel__c='F', Status='Ricevuto',NumeroPratica__c='', CreatedDate=dates),
        new Case(RO_Link_Bozza__c='xxx',RO_Engine_channel__c='W', Status='Ricevuto',NumeroPratica__c='', CreatedDate=dates),
        new Case(RO_Link_Bozza__c='xxx',RO_Engine_channel__c = 'F', Status='RiceVuto',NumeroPratica__c='', CreatedDate=dates),
        new Case (RO_Link_Bozza__c='xxx', RO_Engine_channel__c='F',Status='Ricevuto',NumeroPratica__c='', CreatedDate=dates),
        new Case(RO_Link_Bozza__c='xxx', RO_Engine_channel__c = 'FF', RO_Current_Step__c = 'Step 1 - Scelta clientee', Status='Ricevuto',NumeroPratica__c='', CreatedDate=dates),
        new Case(Description='xxx',RO_Engine_channel__c='FF', Status='Ricevuto',NumeroPratica__c='', CreatedDate=dates),
        new Case (Description ='xxx' ,RO_Engine_channel__c='W',Status='Ricevuto',NumeroPratica__c='', CreatedDate=dates)
        };
        insert v1;
        Datetime createdDate_Batch;
        String query = 'select Id, Status, CreatedDate from Case LIMIT 10 ';//where CreatedDate = createdDate_Batch
		Batch_Di_Allineamento_Stato_OCS_Pr_DS batchTest = new Batch_Di_Allineamento_Stato_OCS_Pr_DS (query);
		Database.executebatch(batchTest);
	}
}