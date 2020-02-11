@isTest
public class SFAConvenzNewDealProspctCtrllerTest {

    
    @testSetup
    public static void setup()
    {
       	XCS_Categoria__c cat = new XCS_Categoria__c(Name='Contabilità  Generale',External_Id__c='5299');
        insert cat;
    }
    @isTest
    public static void testParsingFunction()
    {
         FObject objAccount=new FObject('Account',1);
        objAccount.setDefinition('RecordTypeId', 'static value(Dealer)');
        objAccount.setDefinition('Name','static value(Dealer1)');
        objAccount.insertRecords(true);
        Account a = [Select id from account][0];
        Case c = new Case(AccountId=a.id,Subject='Rif');
        insert c;
        SFAConvenzionamentoNewDealProspctCtrller.richiediQuickReport(c.id,c.accountid,'03512600374');
        
        
        
        
    }
}