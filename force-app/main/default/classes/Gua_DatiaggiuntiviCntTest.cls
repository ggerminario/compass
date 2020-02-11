/**
 * @File Name          : Gua_DatiaggiuntiviCntTest.cls
 * @Description        : 
 * @Author             : Dieynaba Diallo
 * @CreatedDate        : 05/12/2019
 */
@isTest
public class Gua_DatiaggiuntiviCntTest {

    @testSetup
    static void makeData(){
        
        Account[] accts = new List < Account > ();
        Account a1 = new Account(
        Name = 'test1', DEM_Da_Inviare__c = false,  BillingCity = 'San Francisco', OCS_External_Id__c = 'C11911134');
        
        Account a2 = new Account(
        Name = 'test2', DEM_Da_Inviare__c = true, BillingCity = 'San Francisco', OCS_External_Id__c = 'C11911135');
        
        accts.add(a1);
        accts.add(a2);
        
        insert accts;
        
        Id recordType=CGMWSUtils_1_0.getRecordTypeId('Campaign','GUA_Unita_Affari_Campagna');         
        List<Campaign> campaigns = new List<Campaign>{
            new Campaign(StartDate= Date.today(),UAF_DatiAggiuntivi__c='diayna,Diop,Ba',
            EndDate=Date.today(), UAF_Script__c='testDiayna', Name='Campagna-New',RecordTypeId=recordType)
        };
        insert campaigns;
        
		List<Case> v1 = new List<Case>{
            new Case (Status = 'Ricevuto', AccountId=accts[0].Id, CodiceDealer__c = 'test1', CampaignId__c = campaigns[0].Id),
            new Case(Stato_Pratica__c=null, AccountId=accts[1].Id, CodiceDealer__c = 'test2', CampaignId__c = campaigns[0].Id)
		}; 
		insert v1;
    }
    
    @isTest
    public static void getDatiaggiuntiviByCaseTest1() {
        
        Case myCase = [select id, Stato_Pratica__c from Case limit 1];
        Map<String ,Object> returnValue = Gua_DatiaggiuntiviCnt.getDatiaggiuntiviByCase(myCase.Id);
    }
    
    @isTest
    public static void getDatiaggiuntiviByCaseTest2() {
        
        Map<String ,Object> returnValue = Gua_DatiaggiuntiviCnt.getDatiaggiuntiviByCase('');
    }
}