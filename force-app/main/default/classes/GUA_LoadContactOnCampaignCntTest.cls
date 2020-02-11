//----------------------------------------------------------------------
//-- - Author       : Sana Badji
//-- - Date         : 08/10/2019
//-- - Class  : GUA_LoadContactOnCampaignCntTest
//-- - Modify by: Aminata GUEYE | Date: 16/10/19
//----------------------------------------------------------------------
@isTest
public  class GUA_LoadContactOnCampaignCntTest {
   
    private static String dealerRecordTypeId = RecordTypeUtil.getDealerRecordType();
    
   public static string myDate{get;set;}
    @TestSetup
    static void makeData(){
        Id recordType=CGMWSUtils_1_0.getRecordTypeId('Campaign','GUA_Unita_Affari_Campagna');
        
        List<Campaign> campaigns = new List<Campaign>{
        new Campaign(StartDate= Date.today(),UAF_DatiAggiuntivi__c='Sana,Diop,Ba',
        EndDate=Date.today(),
        UAF_Script__c='ff', Name='Campagna-New',RecordTypeId=recordType),
        new Campaign(StartDate=Date.today(),UAF_DatiAggiuntivi__c='Balde,Camara,Balde',
        EndDate=Date.today(),UAF_Script__c='test', Name='Campagna',RecordTypeId=recordType)
        };
        insert campaigns;
        XCS_Categoria__c xcs = new XCS_Categoria__c();
        xcs.Name='Diouf';  xcs.External_Id__c = '5221';
        insert xcs;
        // Account account=GUA_LoadContactOnCampaignCnt.createAccount('398366');
        // Map<Account, DealerAccount> accountMap = new Map<Account, DealerAccount>();  
        // accountMap.put(account, null);
        // XCSGestioneAnagraficaDealer.execute(accountMap, true);

         // Ricerca per OCS ID e EMAIL non valida
         
        /* String RecTypeId = [select Id from RecordType where (Name='Dealer') and (SobjectType='Account')].Id;
        Account acc1 = new Account(
            RecordTypeID = RecTypeId,
            Name = 'Ragione Sociale 1',
            OCS_External_Id__c = '417768',
            BusinessEmail__c = 'fakemail'
        );

        final Map<Account, DealerAccount> accountMap = new Map<Account, DealerAccount>();
        accountMap.put(acc1, null);
        XCSGestioneAnagraficaDealer.execute(accountMap, true);
 */

    }

    @isTest
    static void saveFileTest(){
        Test.startTest();
        //Id recordType=CGMWSUtils_1_0.getRecordTypeId('Case','GUA_Contact');
        String input1  ='{15050011;40;1;02/01/2017;CASCINO;SERGIO;17/06/2015;18/06/2015;19/06/2015;629;337788;H3G SPA;2517580920;13378520152;398366;398366;H3G - FLL 8000004808;917 219 192;;102;Palermo La Favorita;;101;CONTRATTO RICHIEDENTE FIRME IN FOTOCOPIA INVIARE CONTRATTO CORRETTO IN ORIGINALE;;;;}';
        String input2  ='{15040318;40;2;01/01/2017;CONTU;ALESSANDRA;15/06/2015;17/06/2015;22/06/2015;739;13468476;HI-TECH09 SRL;1344890916;1344890916;0;13468476;HI-TECH09 SRL;784 999 055;;237;Nuoro;;98;FASCICOLO COMPLETO FASCICOLO NON PERVENUTO IN ORIGINALE;;;;}';
        String input3  ='{15032009;40;3;31/12/2016;DALESSANDRO;FABIO;12/06/2015;15/06/2015;01/07/2015;739;337788;H3G SPA;2517580920;13378520152;417768;417768;H3G - 3C BRUNO 9000782288;244 581;3 804 957 626;179;Terracina;;89;CONTRATTO RICHIEDENTE FIRME IN FOTOCOPIA INVIARE CONTRATTO CORRETTO IN ORIGINALE;;;;}';
        List<String> data=new List<String>();
        data.add(input1);
        data.add(input2);
        data.add(input3);
        String input4  ='{15050011;40;1;02/01/2017;CASCINO;SERGIO;17/06/2015;18/06/2015;19/06/2015;629;337788;H3G SPA;2517580920;13378520152;398366;398366;H3G - FLL 8000004808;917 219 192;;102;Palermo La Favorita;;101;CONTRATTO RICHIEDENTE FIRME IN FOTOCOPIA INVIARE CONTRATTO CORRETTO IN ORIGINALE;;;;}';
        String input5  ='{15040318;40;2;01/01/2017;CONTU;ALESSANDRA;15/06/2015;17/06/2015;22/06/2015;739;13468476;HI-TECH09 SRL;1344890916;1344890916;0;13468476;HI-TECH09 SRL;784 999 055;;237;Nuoro;;98;FASCICOLO COMPLETO FASCICOLO NON PERVENUTO IN ORIGINALE;;;;}';
        List<String> errors=new List<String>();
        errors.add(input4);
        errors.add(input5);
        String campaignId = '';
        List<Campaign> campaigns = 
        [SELECT Id, Name, StartDate, EndDate, UAF_Script__c, 
                    UAF_DatiAggiuntivi__c 
                FROM Campaign LIMIT 1];
        campaignId = campaigns[0].Id;
        Map<String,Object> listSavefile=GUA_LoadContactOnCampaignCnt.saveFile(data,campaignId,errors);
        System.debug('listSavefile '+listSavefile);
        //  List<Campaign> campaigns = 
        //  [SELECT Id, Name, StartDate, EndDate, UAF_Script__c, 
        //                 UAF_DatiAggiuntivi__c 
        //             FROM Campaign Where RecordTypeId =:recordType];
        // System.assertEquals(2, campaigns.size(), 'campaigns.size()==2');

        Test.stopTest();
    }
    @isTest
    static void setStringToDateFormattest(){
        Test.startTest();
       
        myDate='16/10/2019';
        Date dat=GUA_LoadContactOnCampaignCnt.setStringToDateFormat(myDate);
        System.debug('date '+dat);
       System.assert(dat!=null,'');
        Test.stopTest();
    }
    
     @isTest
    static void createAccountTest(){
        GUA_LoadContactOnCampaignCnt.createAccount('2555411');
    }
}