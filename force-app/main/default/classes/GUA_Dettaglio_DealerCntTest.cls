//----------------------------------------------------------------------
//-- - Author       : Aminata GUEYE
//-- - Date         : 06/11/2019
//-- - Description  : Handle GUA_Dettaglio_DealerCntTest
//----------------------------------------------------------------------
@isTest
public class GUA_Dettaglio_DealerCntTest {

    @TestSetup
static void makeData(){
    
    Account[] acc = new List < Account > ();

    Account a1 = new Account(
    Name = 'acc1');
    acc.add(a1);
    insert acc;

    System.debug(' listAccount '+ acc );

     List<Case> c = new List<Case>{ new Case(
         CodiceDealer__c='400000',
        AccountId = acc[0].Id)
        };
        insert c;  
        System.debug(' case '+ c );

}
    @IsTest
	static void getCaseDetailTest(){
        Test.startTest();
        Case cases = [SELECT Id FROM Case LImit 1];
        Map<String ,Object>  cases1= GUA_Dettaglio_DealerCnt.getCaseDetail(cases.Id);
        Map<String ,Object>  cases2= GUA_Dettaglio_DealerCnt.getCaseDetail('xxxxxx');
        //System.assertEquals(0, listCase.size(), 'listCase.size()==1');
        Test.stopTest();
	}
    
        @IsTest
	static void getFilialeByIdTest(){
        Test.startTest();
        Account acc = [SELECT Id,Name  ,BillingCity  FROM Account LImit 1];
        Map<String ,Object>  acc1 = GUA_Dettaglio_DealerCnt.getFilialeById(acc.Id);
        Map<String ,Object>  acc2 = GUA_Dettaglio_DealerCnt.getFilialeById('xxxxx');
        //System.assertEquals(0, listCase.size(), 'listCase.size()==1');
        Test.stopTest();
	}

}