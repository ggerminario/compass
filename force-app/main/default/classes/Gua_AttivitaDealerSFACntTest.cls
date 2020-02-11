/**
*@author 		Youssouph Niaouba Diedhiou
*created 		16/12/2019
*descripttion 	test of the Gua_AttivitaDealerSFACnt class
*/

@isTest
public class Gua_AttivitaDealerSFACntTest {
@testSetup 
    static void testSetup() {
        Id recordTypeDealer =CGMWSUtils_1_0.getRecordTypeId('Account','Dealer');
        Account dealer = new Account(Name='Basse', Region_Name__c='RS', Address_Abbr_Sms__c='Drand Standing', Telefono_Casa__c='339654585',
                           Telefono_Cellulare__c='772581432', Phone='338589236' , RecordTypeId=recordTypeDealer);
        insert dealer;
        Case cas = new Case(CodiceDealer__c='dev', Pratica_Codice_Attributo_PM__c='test', UAF_DatiAggiuntiviFile__c='test 1', Status='New', Esito__c='test 2',
                             Dealer__c=dealer.Id);
        insert cas;
	}
    @isTest
    static void getTest(){
        Account acc = [Select Id From Account Limit 1];
    	Map<String ,Object> cse = Gua_AttivitaDealerSFACnt.getCasesByAccount(acc.Id);
   		    
    }
}