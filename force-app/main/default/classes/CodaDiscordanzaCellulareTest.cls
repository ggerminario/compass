//----------------------------------------------------------------------
//-- - Author       : SANA BADJI
//-- - @Modified By ADIOP 01/11/2019
//-- - Date         : 29/07/2019
//-- - Description  : Handle CodaDiscordanzaCellulareTest
//----------------------------------------------------------------------
@isTest
public  class CodaDiscordanzaCellulareTest {

/*
    public static final String AFTER_THIRTY_MINUTES = 'afterThirtyMinutes';
    public static final String AFTER_THREE_THREE_HOURS = 'afterThreeHours';
    public static final String AFTER_TWO_TWO_HOURS = 'afterTwoHours';
    
    @TestSetup
    static void makeData(){
            
        Id recordType=CGMWSUtils_1_0.getRecordTypeId('Case','CRM_RichiestaOnline');

        Case v1 = new Case (Stato_Pratica__c='20',NumeroPratica__c='18866725',
        Attributi_Pratica__c ='SD',stato_ocs__c='20SD',RO_Vecchio_Cellulare__c='773528750',Status='Ricevuto',
        RecordTypeId=recordType,Subject='This is a test case for testCaseForForum');    
        insert v1;
        System.debug('v1  '+ v1 );
    }

    @IsTest
    static void performCRMActivityTest(){
    
        // List<Case> listCase = [SELECT Id,LastModifiedDate ,NumeroPratica__c,caseNumber  FROM Case ];
        //  System.debug('listCase  '+ listCase );
       
        Test.startTest();
          Id recordType=CGMWSUtils_1_0.getRecordTypeId('Case','CRM_RichiestaOnline');
           String numeroPratica;
        // for(Case c : listCase){
        //     System.debug('Id  '+ c.id );
        //     numeroPratica=c.NumeroPratica__c ;
        //     System.debug('numPratica  '+ numeroPratica );
        // }
         Case caseObject = new Case (Stato_Pratica__c='20',
                Attributi_Pratica__c ='SD',stato_ocs__c='20SD',
                NumeroPratica__c='18866725',
                Status='Ricevuto',RecordTypeId=recordType,
                Subject='This is a test case for testCaseForForum');
                insert caseObject;
                caseObject = [SELECT NumeroPratica__c FROM Case WHERE Id = :caseObject.Id];
                numeroPratica=caseObject.NumeroPratica__c;
        //ID thisCaseId
        CodaDiscordanzaCellulare.PerformCRMActivityResponse performCRMActResp =
         CodaDiscordanzaCellulare.performCRMActivity(numeroPratica, 'C0', '327 2635104', 
        '348 5958536' , 'note 1');
        System.assert(performCRMActResp.resultCode != 1,'');
        Case v1 = new Case (Stato_Pratica__c=null,AccountId=null,Product__c=null);

        CodaDiscordanzaCellulare.CaseWrapper caseW = new CodaDiscordanzaCellulare.CaseWrapper(v1);
        caseW.numeroPratica='';
        caseW.tipoPratica='';
        caseW.vecchioCell='';
        caseW.nuovoCell='';
        caseW.testoNota='';

         System.assert(caseObject != null,'');
        Test.stopTest();
    }

    // @IsTest
    // static void getnumeroPraticaAndIdTest(){

    //     Test.startTest();
    //     List<Case> listCase = [SELECT Id,LastModifiedDate ,caseNumber,NumeroPratica__c  FROM Case ];
    //     String caseNumber;
    //     for(Case c : listCase){
    //         System.debug('Id  '+ c.id );
    //         caseNumber=c.caseNumber ;
    //         System.debug('caseNumber  '+ caseNumber );
    //         }
    //     Case ca=CodaDiscordanzaCellulare.getnumeroPraticaAndId(caseNumber);
    //     System.assert(ca != null,'');  
    //     Test.stopTest();
    // }

    @IsTest
    static void getnumeroPraticaAndIdExceptionTest(){

        Test.startTest();
        List<Case> listCase = [SELECT Id,LastModifiedDate ,caseNumber,NumeroPratica__c  FROM Case ];
        String numeroPratica;
        for(Case c : listCase){
            System.debug('Id  '+ c.id );
            numeroPratica=c.NumeroPratica__c ;
            System.debug('numeroPratica  '+ numeroPratica );
            }
        Case ca=CodaDiscordanzaCellulare.getnumeroPraticaAndId('88');
        System.assert(ca == null,'');  
        Test.stopTest();
    }
    */
}