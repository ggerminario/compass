@isTest
public  class CreaProspectServiceTest {
/*
    @TestSetup
    static void makeData(){
      List<Account> listAccount = new List<Account>{
           new Account (LastName='xxxx', Codice_Cliente__c='54874', Codice_Fiscale__c ='GHDESXWZD'),
           new Account (LastName='Sana', Codice_Cliente__c='5487441', Codice_Fiscale__c ='GHDESXWZDSDE'),
           new Account (LastName='Sana', Codice_Cliente__c='5487', Codice_Fiscale__c ='GHDESX')
      };
      insert listAccount;
   //PP_ONLINE_PARTNER_DS
        Product2 produit = new Product2(Name='P1', ProductCode='145', Family='PP_ONLINE_COMPASS_DS');
        Product2 produit2 = new Product2(Name='P2DSP', ProductCode='146', Family='PP_ONLINE_PARTNER_DS');
        Product2 produit3 = new Product2(Name='P2DSP', ProductCode='147', Family='PP_ONLINE_PARTNER_DS');
        insert produit;
        insert produit2;
        insert produit3;

       List<Case> v1 = new List<Case>{
            new Case (RO_Link_Bozza__c='link', Codice_Cliente__c='54412587', Status='On Hold', AccountId= listAccount[0].Id, Product__c = produit.Id ),
            new Case ( RO_Link_Bozza__c= 'test', Codice_Cliente__c='544587'),
             new Case ( RO_Link_Bozza__c= 'test', Codice_Cliente__c='544587', Status='Gestito', AccountId= listAccount[0].Id, Product__c = produit.Id),
            new Case (Codice_Cliente__c ='5425', AccountId= listAccount[0].Id, Product__c = produit3.Id)
        };
       
      insert v1;    


      
     

    }
   //@IsTest
    static void search_Link_Boza_test(){
        
        Test.startTest();
        Case c = [SELECT Id, RO_Link_Bozza__c, Codice_Cliente__c FROM Case LIMIT  1 ];
        CreaProspectService.search_Link_Boza(c);
        Test.stopTest();
        
    }  
   @IsTest
    static void createCaseDsTest(){  
        RO_CRMRich_online_steplog__c ros = new RO_CRMRich_online_steplog__c();
        ros.RO_CRMStep__c = 'Step 2 - Scelta cliente';
        ros.RO_CRMModalita_firma__c = 'test';
        ros.RO_CRMModalita_richiesta__c = 'TEL_IN';
        ros.RO_documenti__c = 'document';
        RequestOnlineApexClass.data.put('ros', ros);

        RO_CRMRich_online_prescoring__c rop = new RO_CRMRich_online_prescoring__c();
        //  rop.Pricing__c = creaprospect.enginePricing;
        rop.Channel__c = null ;
        rop.RO_Input_motore__c = null;
        RequestOnlineApexClass.data.put('rop', rop);

        Test.startTest();
            Case c =  new Case (Codice_Cliente__c='xsdc', RO_Link_Bozza__c='');
            Product2 p = [SELECT Id, ProductCode, Family FROM Product2 WHERE ProductCode='145' ];
            Account acc = new Account (LastName='SanaBadji', Codice_Cliente__c='548744178', Codice_Fiscale__c ='GHDESXWZDSBE');
            insert acc;
            c.Product__c = p.Id;
            c.AccountId = acc.Id;
            CreaProspectService.createCaseDs(c, p, acc,'');
        Test.stopTest();  
    }
    
    @isTest
    static void createCaseDsNewCaseTest(){
        RO_CRMRich_online_steplog__c ros = new RO_CRMRich_online_steplog__c();
        ros.RO_CRMStep__c = 'Step 2 - Scelta cliente';
        ros.RO_CRMModalita_firma__c = 'test';
        ros.RO_CRMModalita_richiesta__c = 'TEL_IN';
        ros.RO_documenti__c = 'document';
        RequestOnlineApexClass.data.put('ros', ros);
        Test.startTest();
        Case c =  new Case (Codice_Cliente__c='xsdc', RO_Link_Bozza__c='');
        Product2 p = [SELECT Id, ProductCode, Family FROM Product2 WHERE ProductCode='145' ];
        Account acc = [SELECT Id, Codice_Cliente__c, Codice_Fiscale__c FROM Account LIMIT 1];
        c.Product__c = p.Id;
        c.AccountId = acc.Id;
        CreaProspectService.createCaseDs(c, p, acc,'');

        Test.stopTest();  


    }



    @isTest
    static void createCaseDsCaseClosed(){
         
        Case c = [SELECT Id, Status, CaseNumber, AccountId FROM Case WHERE Status ='Gestito'];
        Product2 p = [SELECT Id, ProductCode, Family FROM Product2 WHERE ProductCode='145' ];
        Account acc = [SELECT Id, Codice_Cliente__c, Codice_Fiscale__c FROM Account LIMIT 1];
        RO_CRMRich_online_steplog__c ros = new RO_CRMRich_online_steplog__c();
        ros.RO_CRMStep__c = 'Step 1 - Light Form';
        ros.RO_CRMModalita_firma__c = 'xx';
        ros.RO_CRMModalita_richiesta__c = 'xxx';
        ros.RO_documenti__c = 'xxx';
        RequestOnlineApexClass.data.put('ros', ros);

        RO_CRMRich_online_prescoring__c rop = new RO_CRMRich_online_prescoring__c();
        //  rop.Pricing__c = creaprospect.enginePricing;
        rop.Channel__c = 'F' ;
        rop.RO_Input_motore__c = 'xxx';
        RequestOnlineApexClass.data.put('rop', rop);



        Test.startTest();
        CreaProspectService.createCaseDs(c, p, acc,'');
        Test.stopTest();
    }
    @isTest
    static void createCaseDsCaseClosedNewCase(){
        Case c = [SELECT Id, Status, RO_Current_Step__c, CaseNumber, AccountId FROM Case WHERE Status ='On Hold'];
        Product2 p = [SELECT Id, ProductCode, Family FROM Product2 WHERE ProductCode='145' ];
        Account acc = [SELECT Id, Codice_Cliente__c, Codice_Fiscale__c FROM Account LIMIT 1];
        RO_CRMRich_online_steplog__c ros = new RO_CRMRich_online_steplog__c();
        ros.RO_CRMStep__c = 'Step 2 - Scelta cliente';
        ros.RO_CRMModalita_firma__c = 'xx';
        ros.RO_CRMModalita_richiesta__c = 'TEL_IN';
        ros.RO_documenti__c = 'xxx';
        RequestOnlineApexClass.data.put('ros', ros);
        RO_CRMRich_online_prescoring__c rop = new RO_CRMRich_online_prescoring__c();
        //  rop.Pricing__c = creaprospect.enginePricing;
        rop.Channel__c = 'F' ;
        rop.RO_Input_motore__c = 'xxx';
        RequestOnlineApexClass.data.put('rop', rop);
        Test.startTest();
        CreaProspectService.createCaseDs(c, p, acc,'xxxxxxxxxxxxxxx');
        Test.stopTest();
    }
  
    @isTest
    static void createCaseDsCaseClosedUpdateCase(){
        Case c = [SELECT Id, Status, RO_Current_Step__c, CaseNumber, AccountId FROM Case WHERE Status ='On Hold'];
        Product2 p = [SELECT Id, ProductCode, Family FROM Product2 WHERE ProductCode='145' ];
        Account acc = [SELECT Id, Codice_Cliente__c, Codice_Fiscale__c FROM Account LIMIT 1];
        RO_CRMRich_online_steplog__c ros = new RO_CRMRich_online_steplog__c();
        ros.RO_CRMStep__c = 'Step 1 - Light Form';
        ros.RO_CRMModalita_firma__c = 'xx';
        ros.RO_CRMModalita_richiesta__c = 'xxx';
        ros.RO_documenti__c = 'xxx';
        RequestOnlineApexClass.data.put('ros', ros);
        RO_CRMRich_online_prescoring__c rop = new RO_CRMRich_online_prescoring__c();
        //  rop.Pricing__c = creaprospect.enginePricing;
        rop.Channel__c = 'F' ;
        rop.RO_Input_motore__c = 'xxx';
        RequestOnlineApexClass.data.put('rop', rop);
        Test.startTest();
        CreaProspectService.createCaseDs(c, p, acc,'xxxxxxxxxxxxxxx');
        Test.stopTest();
    }
   
    @isTest
    static void createCaseDSPCresate(){
    Case c = new Case();
    List<Product2> ps = [SELECT Id, Family FROM Product2];
    Account account = [SELECT Id,  Codice_Cliente__c,Codice_Fiscale__c FROM Account LIMIT 1];
    Test.startTest();
    c.Product__c = ps[1].Id;
    c.AccountId = account.Id;
    CreaProspectService.createCaseDSP(c, ps[1], account);

    Test.stopTest();
    }
      @isTest
    static void createCaseDSPCresateElse(){
    Case c = new Case();
    List<Product2> ps = [SELECT Id, Family FROM Product2];
    Account account = [SELECT Id,  Codice_Cliente__c,Codice_Fiscale__c FROM Account WHERE  Codice_Fiscale__c ='GHDESXWZDSDE'];
    Test.startTest();
    c.Product__c = ps[1].Id;
    c.AccountId = account.Id;
    CreaProspectService.createCaseDSP(c, ps[1], account);

    Test.stopTest();
    }
     @isTest
    static void createCaseDSPCresateElseV(){
    Case c = [SELECT Id FROM Case LIMIT 1];
    List<Product2> ps = [SELECT Id, Family FROM Product2];
    Account account = [SELECT Id,  Codice_Cliente__c,Codice_Fiscale__c FROM Account WHERE  Codice_Fiscale__c ='GHDESX'];
    Test.startTest();
    c.Product__c = ps[1].Id;
    c.AccountId = account.Id;
    CreaProspectService.createCaseDSP(c, ps[1], account);

    Test.stopTest();
    }
    //@isTest 
    static void controleCaseTest (){
        Test.startTest();
        Case c = [SELECT Id, Codice_Cliente__c, Status, AccountId, Product__c  FROM Case LIMIT 1];
        System.debug('********* Case '+ c);
        Product2 p = [SELECT Id, ProductCode, Family FROM Product2];
        
        Case c2 = CreaProspectService.controleCase(p.Id, '54874', '');

        Test.stopTest();
    }
    @isTest
    static void gestatoRequestOnlineTest(){
     Test.startTest();
      Product2 p = [SELECT Id, ProductCode, Family FROM Product2 LIMIT 1];
          Account acc = [SELECT Id, Codice_Cliente__c, Codice_Fiscale__c FROM Account LIMIT 1];
      //  Case c = [SELECT Id, Codice_Cliente__c, Status, AccountId, Product__c  FROM Case LIMIT 1];
        Case c  = new Case (RO_Link_Bozza__c='link', Codice_Cliente__c='54412587', Status='On Hold', AccountId= acc.Id, Product__c = p.Id );
          //String idCRM =  Account.Id;
          CreaProspectService.gestatoRequestOnline(c, acc, p, '');

       Test.stopTest();

    }
    @isTest
    static void saveCasetest(){
      Case c = [SELECT Id FROM Case LIMIT 1];
      Product2 p = [SELECT Id, Family FROM Product2 LIMIT 1];
   
    Test.startTest();
    CreaProspectService.saveCase(c, p);
    System.assertNotEquals(null, c.Id, '* pass ');
    Test.stopTest();
    }
    
    @isTest
    static void inserimentoInCodatest(){
    Test.startTest();
        List<Case> cases = [SELECT Id , AccountId, Product__r.DEMAnomalie__c FROM Case];
        Map<Id, Case> caseMap = new Map<Id, Case>(cases);
        CreaProspectService.inserimentoInCoda(cases[0]);
        System.assertNotEquals(0, cases.size(), 'pass');
    Test.stopTest();
    }

    @isTest
    static void inserimentoInCodatestEmpty(){
    Test.startTest();
          Map<Id, Case> caseMap = new Map<Id, Case>();
          Case c = new Case();
          CreaProspectService.inserimentoInCoda(c);
          System.assertEquals(0, caseMap.keySet().size(), 'pass');
    Test.stopTest();
    }
    */
}