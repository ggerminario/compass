@isTest 
public class Batch_Di_Allineamento_Stato_OCSPrDSPTest {
	static testMethod void testMethod1() 
    {
        Product2 pro = new Product2();
        pro.Family= 'PP_ONLINE_PARTNER_DS';
        pro.Name ='product 1';
        insert pro;
        System.debug('lid du produit '+pro.Id);
        List<Case> lstCase= new List<Case>();
        for(Integer i=0 ;i <200;i++)
        {
            Case cs = new Case();
			cs.Product__c = pro.Id;
            cs.Status ='Annullato';
            lstCase.add(cs);
        }
        
        insert lstCase;
        
        Test.startTest();

            Batch_Di_Allineamento_Stato_OCS_Pr_DSP obj = new Batch_Di_Allineamento_Stato_OCS_Pr_DSP();
            DataBase.executeBatch(obj); 
            
        Test.stopTest();
    }
}