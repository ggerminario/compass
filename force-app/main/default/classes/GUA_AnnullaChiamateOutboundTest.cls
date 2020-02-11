//----------------------------------------------------------------------
    //-- - Author       : Aminata GUEYE
    //-- - Date         : 14/10/2019
    //-- - Class  : GUA_AnnullaChiamateOutboundTest
    //----------------------------------------------------------------------
@isTest
public class GUA_AnnullaChiamateOutboundTest {
    public List<Case> casList = new List<Case>();
    public List<Case> upRec = new List<Case>();
     @TestSetup
    static void makeData(){
        Id recordType=CGMWSUtils_1_0.getRecordTypeId('Campaign','GUA_Unita_Affari_Campagna');
        
        List<Campaign> campaigns = new List<Campaign>{
        new Campaign(StartDate= Date.today(),UAF_DatiAggiuntivi__c='Aminata,Diop,Ba',
        EndDate=Date.today(),
        UAF_Script__c='ff', Name='Campagna-Neuf',RecordTypeId=recordType),
        new Campaign(StartDate=Date.today(),UAF_DatiAggiuntivi__c='Gueye,Dia,Gueye',
        EndDate=Date.today(),UAF_Script__c='test', Name='Campagna',RecordTypeId=recordType)
        };
        insert campaigns;
        Case cas = new Case(CodiceDealer__c='400000',CampaignId__c=campaigns[0].Id);
        insert cas;
    }

    
    @isTest
    static void getCampNametest(){
        Test.startTest();
        Id recordType=CGMWSUtils_1_0.getRecordTypeId('Campaign','GUA_Unita_Affari_Campagna');
        
        Map<String, Object> campaigns=GUA_AnnullaChiamateOutboundCnt.getCampName();
        System.debug('campaigns '+campaigns);
        System.assertEquals(2, campaigns.size(), 'campaigns.size()==2');
        Test.stopTest();
    }
    @isTest
    static void fetchCasetest(){
        Test.startTest();
        String codi='400000';
        String campagna='Campagna-Neuf';
        String campagna1='Selezionatutte';
        List<Case> cases=GUA_AnnullaChiamateOutboundCnt.fetchCase(codi,campagna);
        List<Case> cases2=GUA_AnnullaChiamateOutboundCnt.fetchCase(codi,campagna1);
        List<Case> cases1=GUA_AnnullaChiamateOutboundCnt.fetchCase(null,campagna);
         System.debug('cases '+cases);
         //System.assertEquals(1, cases.size());

        Test.stopTest();
    }
    /*@isTest
    static void upSlctRectest(){
        Test.startTest();
        GUA_AnnullaChiamateOutboundCnt clc = new GUA_AnnullaChiamateOutboundCnt();
        List<String> slctRec=new list<String>{'00167318','Campagna-Ma','417768','15032009'};
        clc.upRec = [SELECT Id FROM Case WHERE Id IN: slctRec ];
         List<Case> cases=GUA_AnnullaChiamateOutboundCnt.upSlctRec(slctRec);
         System.debug('cases '+cases);
        Test.stopTest();
        
    }*/
     @isTest
    static void updateCasetest(){
        Test.startTest();
         List<String> slctRec =new list<String>{'00167318','Campagna-Ma','417768','15032009'};
         List<Case> listCase= [SELECT Id FROM Case WHERE Id IN: slctRec ] ;
         List<Case> cases=GUA_AnnullaChiamateOutboundCnt.updateCase(slctRec);
         System.debug('cases '+cases);
        Test.stopTest();
        
    }
}