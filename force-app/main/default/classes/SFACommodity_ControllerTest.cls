@isTest
public with sharing class SFACommodity_ControllerTest {
 

    private static void insertVarie(){

        ApiRest__c rest1 = new ApiRest__c(Method__c = 'POST' ,Test_Response__c='',Test_Request__c = 'testRequest',Mock__c = false,User__c = 'CDSLF00',Password__c = 'P00FLSDC' ,ref__c = 'CompassInternal',Name =OCSRecuperaDatiCartaDealerInvoker.SERVICE_NAME,EndPoint__c = 'https://richiestaonlinesvi.compassonline.it/B2BSOAP/rest/B2BREST/execute');
        insert rest1;
        ApiRest__c rest2 = new ApiRest__c(Method__c = 'POST' ,Test_Response__c='',Test_Request__c = 'testRequest',Mock__c = false,User__c = 'CDSLF00',Password__c = 'P00FLSDC' ,ref__c = 'CompassInternal',Name =OCSRecuperaDatiPraticaCommodityInvoker.SERVICE_NAME,EndPoint__c = 'https://richiestaonlinesvi.compassonline.it/B2BSOAP/rest/B2BREST/execute');
        insert rest2;

        ApiUtil__c uti = new ApiUtil__c(Name = 'CompassInternal' ,EndPoint__c ='https://richiestaonlinesvi.compassonline.it/B2BSOAP/rest/B2BREST/execute' ,Password__c = 'P00FLSDC',User__c = 'CDSLF00');      
        insert uti;

        
        XCS_Disposition__c dis = new XCS_Disposition__c();
        dis.Name = 'Branch_Activity_Complete';
        dis.External_Id__c = 'AO253';
        insert dis;
        XCS_Disposition__c dis2 = new XCS_Disposition__c();
        dis2.Name = 'Branch_Activity_Complete';
        dis2.External_Id__c = 'AO250';
        insert dis2;
        XCS_Disposition__c dis3 = new XCS_Disposition__c();
        dis3.Name = 'Complete';
        dis3.External_Id__c = 'AO256';
        insert dis3;
        XCS_Disposition__c dis4 = new XCS_Disposition__c();
        dis4.Name = 'Return_To_Branch';
        dis4.External_Id__c = 'AO254';
        insert dis4;
        XCS_Disposition__c dis5 = new XCS_Disposition__c();
        dis5.Name = 'Return_To_Branch';
        dis5.External_Id__c = 'AO251';
        insert dis5;
        XCS_Disposition__c dis6 = new XCS_Disposition__c();
        dis6.Name = 'Activity_Complete';
        dis6.External_Id__c = 'AO255';
        insert dis6;
        XCS_Disposition__c dis7 = new XCS_Disposition__c();
        dis7.Name = 'Activity_Complete';
        dis7.External_Id__c = 'AO252';
        insert dis7;

        
     }

    private static testmethod void testSERV() {
        
        
        String responseApi = '{"resultCode":0,"resultMessage":"Ok","recuperaDatiPraticaCommodityResponse":{"datiPraticaCommodityDTO":{"numPratica":"20417681","codCliente":"19112773","cognome":"RAOPSTALLA","importoRata":"20021"}}}';
        
        ApiRest__c test1 = new ApiRest__c(Method__c = 'POST', Test_Response__c= responseApi, Test_Request__c = 'testRequest',
                                          Mock__c = false,
                                          User__c = 'CDSLF00',
                                          Password__c = 'P00FLSDC' ,
                                          Name =OCSRecuperaDatiPraticaCommodityInvoker.SERVICE_NAME,
                                          Ref__c='CompassInternal',
                                          EndPoint__c = 'https://richiestaonlinesvi.compassonline.it/B2BSOAP/rest/B2BREST/execute');      
        insert test1;
        
        ApiUtil__c uti = new ApiUtil__c(Name = 'CompassInternal' ,EndPoint__c ='https://richiestaonlinesvi.compassonline.it/B2BSOAP/rest/B2BREST/execute' ,Password__c = 'P00FLSDC',User__c = 'CDSLF00');      
        
        insert uti;
        UtilityMockResponse UMR = new UtilityMockResponse();
        UMR.apiname=OCSRecuperaDatiPraticaCommodityInvoker.SERVICE_NAME;
        
        Test.startTest();
        Test.setMock(HttpCalloutMock.class,UMR);
        
        Map<String,String> mRDPC = SFACommodity_Controller.getDatiPratica('123456', true);

        Test.stopTest();
    }   

        private static testmethod void testSERV2() {

        insertVarie();

        Id idProfile = [SELECT Id FROM Profile WHERE Name = 'Monitoraggio Dealer'].Id;

        User us = new User();
        us.FirstName = 'TestNome';
        us.LastName = 'TestCognome';
        us.ProfileId = idProfile;
        us.Username = 'testFabio@test.com';
        us.Email = 'test@test.com';
        us.Alias = 'TEST';
        us.TimeZoneSidKey = 'Europe/Rome';
        us.LocaleSidKey = 'en_US';
        us.EmailEncodingKey = 'UTF-8'; 
        us.LanguageLocaleKey = 'en_US';
        us.DefaultQueueId__c = '241';
        
        insert us;

        System.runAs(us){


            Map<String,List<String>> serviceIdResponseMap = new Map<String,List<String>>();
            
            List<String> respRDCD = new List<String>();
            List<String> respRDPC = new List<String>();
            
            respRDCD.add('{"resultCode":0,"resultMessage":"Ok","recuperaDatiCartaDealerResponse":{"numeroPratica":"103135280390","codCliente":"5479910","codDealer":"167442","codProdotto":"05","statoDealer":"AT","telCellulare":"392044612"}}');
            respRDPC.add('{"resultCode":0,"resultMessage":"Ok","recuperaDatiPraticaCommodityResponse":{"datiPraticaCommodityDTO":{"numPratica":"20417681","codCliente":"19112773","cognome":"RAOPSTALLA","importoRata":"20021"}}}');

            serviceIdResponseMap.put('recuperaDatiCartaDealer', respRDCD);
            serviceIdResponseMap.put('recuperadatiPraticaCommodity', respRDPC);

            UtilityMockResponse UMR = new UtilityMockResponse(); 
            
    //        Id idProfile = [SELECT Id FROM Profile WHERE Name = 'BackOffice'].Id;

            Test.startTest();
            Test.setMock(HttpCalloutMock.class, new UtilityMockResponseMultipleService(serviceIdResponseMap));

    //        System.runAs(us){
            try {
                
                Map<String,String> mRDCD = SFACommodity_Controller.getDatiCarta('123456', true);
//                Map<String,String> mRDPC = SFACommodity_Controller.getDatiPratica('123456', true);
                
                
            } 
            catch (System.AsyncException ex) {
            }
            Test.stopTest();
        }
    }   
    
    
    
    
    
    private static testmethod void testBMAA() {

        insertVarie();

        Id idProfile = [SELECT Id FROM Profile WHERE Name = 'Branch Manager'].Id;

        User us = new User();
        us.FirstName = 'TestNome';
        us.LastName = 'TestCognome';
        us.ProfileId = idProfile;
        us.Username = 'testFabio@test.com';
        us.Email = 'test@test.com';
        us.Alias = 'TEST';
        us.TimeZoneSidKey = 'Europe/Rome';
        us.LocaleSidKey = 'en_US';
        us.EmailEncodingKey = 'UTF-8'; 
        us.LanguageLocaleKey = 'en_US';
        us.DefaultQueueId__c = '241';
        
        insert us;

        System.runAs(us){

            Account acc = new Account();
            acc.Name = 'test account';
            acc.COM_NumeroTotali_Pratiche__c='10';
            acc.COM_PraticheChiuse_Conforme__c='5';
            acc.COM_ChiusoNon_Conforme__c='2';
            acc.OCS_External_Id__c = 'F142';
            insert acc;
            
            XCS_Categoria__c xcsC = new XCS_Categoria__c();
            xcsC.Name = 'Commodity Check Anomaly';
            insert xcsC;

            Case caso = new Case();
            caso.Subject = 'Activity';
            caso.Status = 'New';
            caso.Branch__c = acc.Id;
            caso.NumeroPratica__c ='2342342';
            caso.Categoria_Riferimento__c = xcsC.Id;
            insert caso;   

            sfa_commodity_check_activity_details__c act = new sfa_commodity_check_activity_details__c();        
            act.Activity_id__c = caso.id;
            act.Allegato_sospeso__c = 0;	
            act.Categoria__c = '';	
            act.Cod_agente_convenzionato__c = '';
            act.Cod_esito__c = '';
            act.Cod_subagente_pv__c = '';
            act.Data_notifica__c = Date.valueOf('2019-10-16');
            act.Data_verifica__c = Date.valueOf('2019-10-16');
            act.Debitore__c = '';
            act.Dipendente__c = '';
            act.Esito__c = '';
            act.Esito_finale_md__c = '';
            act.Nota_compass__c = '';
            act.Nota_societa_esterna__c = '';
            act.Nota_sospesa__c = '';
            act.Num_Pratica__c = '';
            act.pratica_carta__c = 'C';
            act.question1__c = '';
            act.question2__c = '';
            act.question3__c = '';
            act.Rag_sociale_agente_convenzionato__c = '';
            act.Rag_sociale_subagente_pv__c = '';
            act.Ritardo_dealer__c = '';
            act.Societa__c = '';
            act.Tipo_prodotto__c = '';
            insert act;

            Map<String,List<String>> serviceIdResponseMap = new Map<String,List<String>>();
            
            List<String> respRDCD = new List<String>();
            List<String> respRDPC = new List<String>();
            
            respRDCD.add('{"resultCode":0,"resultMessage":"Ok","recuperaDatiCartaDealerResponse":{"numeroPratica":"103135280390","codCliente":"5479910","codDealer":"167442","codProdotto":"05","statoDealer":"AT","telCellulare":"392044612"}}');
            respRDPC.add('{"resultCode":0,"resultMessage":"Ok","recuperaDatiPraticaCommodityResponse":{"datiPraticaCommodityDTO":{"numPratica":"20417681","codCliente":"19112773","cognome":"RAOPSTALLA","importoRata":"20021"}}}');

            serviceIdResponseMap.put('recuperaDatiCartaDealer', respRDCD);
            serviceIdResponseMap.put('recuperadatiPraticaCommodity', respRDPC);

            UtilityMockResponse UMR = new UtilityMockResponse(); 
            
    //        Id idProfile = [SELECT Id FROM Profile WHERE Name = 'BackOffice'].Id;

            Test.startTest();
            Test.setMock(HttpCalloutMock.class, new UtilityMockResponseMultipleService(serviceIdResponseMap));

    //        System.runAs(us){
            try {
                SFACommodity_Controller sfa = new SFACommodity_Controller();
                
                List<sfa_commodity_check_activity_details__c> lSfa = SFACommodity_Controller.getActivity(caso.Id);
                List<sfa_commodity_check_esiti_finali_md__mdt> lChi = SFACommodity_Controller.getChiusura('PAPF');
                Map<String,String> mUser = SFACommodity_Controller.getUserMap();
                Boolean bSospendi = SFACommodity_Controller.getSospendi(caso.Id, 'NOTA TEST', 'SI', 'Casa', 'Si', true, 'Branch_Activity_Complete', '', Date.valueOf('2019-12-31'));
                Boolean bSospendi2 = SFACommodity_Controller.getSospendi(caso.Id, 'NOTA TEST', 'SI', 'Casa', 'Si', false, 'Branch_Activity_Complete', '', Date.valueOf('2019-12-31'));
                Boolean bCompleta = SFACommodity_Controller.getCompleta(caso.Id, 'NOTA TEST', 'SI', 'Casa', 'Si', true, 'Branch_Activity_Complete', '', Date.valueOf('2019-12-31'));
                
//                Map<String,String> mRDCD = SFACommodity_Controller.getDatiCarta('123456', true);
//                Map<String,String> mRDPC = SFACommodity_Controller.getDatiPratica('123456', true);
                
                List<ContentDocumentLink> lCD = SFACommodity_Controller.getFile(String.ValueOf(caso.Id));
                List<ContentVersion> lCV = SFACommodity_Controller.getFileCompleta(String.ValueOf(caso.Id));
                List<ListView> lLV = SFACommodity_Controller.getListViews('Commodity Check Anomaly');
                
                //                    String sf = SFACommodity_Controller.Attachment(null,'D');
                //                    String sf2 = SFACommodity_Controller.Attachment(null,'S');
                //                    List<ContentDocumentLink> lCD2 = SFACommodity_Controller.finishUploadFile(null, null, 'TEST', 'TEST');
                
            } 
            catch (System.AsyncException ex) {
            }
            Test.stopTest();
        }
    }   

    private static testmethod void testBMAC() {

        insertVarie();

        Id idProfile = [SELECT Id FROM Profile WHERE Name = 'Branch Manager'].Id;

        User us = new User();
        us.FirstName = 'TestNome';
        us.LastName = 'TestCognome';
        us.ProfileId = idProfile;
        us.Username = 'testFabio@test.com';
        us.Email = 'test@test.com';
        us.Alias = 'TEST';
        us.TimeZoneSidKey = 'Europe/Rome';
        us.LocaleSidKey = 'en_US';
        us.EmailEncodingKey = 'UTF-8'; 
        us.LanguageLocaleKey = 'en_US';
        us.DefaultQueueId__c = '241';
        
        insert us;

        System.runAs(us){

            Account acc = new Account();
            acc.Name = 'test account';
            acc.COM_NumeroTotali_Pratiche__c='10';
            acc.COM_PraticheChiuse_Conforme__c='5';
            acc.COM_ChiusoNon_Conforme__c='2';
            acc.OCS_External_Id__c = 'F142';
            insert acc;
            
            XCS_Categoria__c xcsC = new XCS_Categoria__c();
            xcsC.Name = 'Commodity Check Critical';
            insert xcsC;

            Case caso = new Case();
            caso.Subject = 'Activity';
            caso.Status = 'New';
            caso.Branch__c = acc.Id;
            caso.NumeroPratica__c ='2342342';
            caso.Categoria_Riferimento__c = xcsC.Id;
            insert caso;   

            sfa_commodity_check_activity_details__c act = new sfa_commodity_check_activity_details__c();        
            act.Activity_id__c = caso.id;
            act.Allegato_sospeso__c = 0;	
            act.Categoria__c = '';	
            act.Cod_agente_convenzionato__c = '';
            act.Cod_esito__c = '';
            act.Cod_subagente_pv__c = '';
            act.Data_notifica__c = Date.valueOf('2019-10-16');
            act.Data_verifica__c = Date.valueOf('2019-10-16');
            act.Debitore__c = '';
            act.Dipendente__c = '';
            act.Esito__c = '';
            act.Esito_finale_md__c = '';
            act.Nota_compass__c = 'TEST';
            act.Nota_societa_esterna__c = '';
            act.Nota_sospesa__c = '';
            act.Num_Pratica__c = '';
            act.pratica_carta__c = 'P';
            act.question1__c = '';
            act.question2__c = '';
            act.question3__c = '';
            act.Rag_sociale_agente_convenzionato__c = '';
            act.Rag_sociale_subagente_pv__c = '';
            act.Ritardo_dealer__c = '';
            act.Societa__c = '';
            act.Tipo_prodotto__c = '';
            insert act;

            Map<String,List<String>> serviceIdResponseMap = new Map<String,List<String>>();
            
            List<String> respRDCD = new List<String>();
            List<String> respRDPC = new List<String>();
            
            respRDCD.add('{"resultCode":0,"resultMessage":"Ok","recuperaDatiCartaDealerResponse":{"numeroPratica":"","codCliente":"","codDealer":"","codProdotto":"","descProdotto":"","dataRichiesta":"","fido":"","ragioneSociale":"","ragioneSocialeDealer":"","statoDealer":"","telCellulare":"","telDatore":"","telCase":""}}');
            respRDPC.add('{"resultCode":0,"resultMessage":"Ok","recuperaDatiPraticaCommodityResponse":{"numeroPratica":"","codCliente":"","cognome":"","nome":"","ragioneSociale":"","telefonoCasa":"","codDealer":"","statoDealer":"","telCellulare":"","telDatore":"","codClienteCoob":"","cognomeCoob":"","nomeCoob":"","ragioneSocialeCoob":"","telefonoCasaCoob":"","telCellulareCoob":"","telDatoreCoob":"","dataLiquidazione":"","descrizioneBene":"","codDestFinanziamento":"","descDestFinanziamento":"","tipoProdotto":"","numRata":"","importoRata":"","finanziato":"","ragioneSocialeDealer":"","canale":""}}');

            serviceIdResponseMap.put('recuperaDatiCartaDealer', respRDCD);
            serviceIdResponseMap.put('recuperadatiPraticaCommodity', respRDPC);

            UtilityMockResponse UMR = new UtilityMockResponse(); 
            
    //        Id idProfile = [SELECT Id FROM Profile WHERE Name = 'BackOffice'].Id;

            Test.startTest();
            Test.setMock(HttpCalloutMock.class, new UtilityMockResponseMultipleService(serviceIdResponseMap));

    //        System.runAs(us){
                try {
                    SFACommodity_Controller sfa = new SFACommodity_Controller();

                    List<sfa_commodity_check_activity_details__c> lSfa = SFACommodity_Controller.getActivity(caso.Id);
                    List<sfa_commodity_check_esiti_finali_md__mdt> lChi = SFACommodity_Controller.getChiusura('PAPF');
                    Map<String,String> mUser = SFACommodity_Controller.getUserMap();
                    Boolean bSospendi = SFACommodity_Controller.getSospendi(caso.Id, 'NOTA TEST', 'SI', 'Casa', 'Si', true, 'Branch_Activity_Complete', '', Date.valueOf('2019-12-31'));
                    Boolean bSospendi2 = SFACommodity_Controller.getSospendi(caso.Id, 'NOTA TEST', 'SI', 'Casa', 'Si', false, 'Branch_Activity_Complete', '', Date.valueOf('2019-12-31'));
                    Boolean bCompleta = SFACommodity_Controller.getCompleta(caso.Id, 'NOTA TEST', 'SI', 'Casa', 'Si', true, 'Branch_Activity_Complete', '', Date.valueOf('2019-12-31'));

//                    Map<String,String> mRDCD = SFACommodity_Controller.getDatiCarta('123456', true);
//                    Map<String,String> mRDPC = SFACommodity_Controller.getDatiPratica('123456', true);

                    List<ContentDocumentLink> lCD = SFACommodity_Controller.getFile(String.ValueOf(caso.Id));
                    List<ContentVersion> lCV = SFACommodity_Controller.getFileCompleta(String.ValueOf(caso.Id));
                    List<ListView> lLV = SFACommodity_Controller.getListViews('Commodity Check Anomaly');

                } 
                catch (System.AsyncException ex) {
                }
            Test.stopTest();
        }
    }   
    private static testmethod void testBMVA() {

        insertVarie();

        Id idProfile = [SELECT Id FROM Profile WHERE Name = 'Branch Manager'].Id;

        User us = new User();
        us.FirstName = 'TestNome';
        us.LastName = 'TestCognome';
        us.ProfileId = idProfile;
        us.Username = 'testFabio@test.com';
        us.Email = 'test@test.com';
        us.Alias = 'TEST';
        us.TimeZoneSidKey = 'Europe/Rome';
        us.LocaleSidKey = 'en_US';
        us.EmailEncodingKey = 'UTF-8'; 
        us.LanguageLocaleKey = 'en_US';
        us.DefaultQueueId__c = '241';
        
        insert us;

        System.runAs(us){

            Account acc = new Account();
            acc.Name = 'test account';
            acc.COM_NumeroTotali_Pratiche__c='10';
            acc.COM_PraticheChiuse_Conforme__c='5';
            acc.COM_ChiusoNon_Conforme__c='2';
            acc.OCS_External_Id__c = 'F142';
            insert acc;
            
//            XCS_Categoria__c xcsC = new XCS_Categoria__c();
//            xcsC.Name = 'Commodity Check Critical';
//            insert xcsC;

            Case caso = new Case();
            caso.Subject = 'Activity';
            caso.Status = 'New';
            caso.Branch__c = acc.Id;
            caso.NumeroPratica__c ='2342342';
//            caso.Categoria_Riferimento__c = xcsC.Id;
            insert caso;   

            sfa_commodity_check_activity_details__c act = new sfa_commodity_check_activity_details__c();        
            act.Activity_id__c = caso.id;
            act.Allegato_sospeso__c = 0;	
            act.Categoria__c = '';	
            act.Cod_agente_convenzionato__c = '';
            act.Cod_esito__c = '';
            act.Cod_subagente_pv__c = '';
            act.Data_notifica__c = Date.valueOf('2019-10-16');
            act.Data_verifica__c = Date.valueOf('2019-10-16');
            act.Debitore__c = '';
            act.Dipendente__c = '';
            act.Esito__c = '';
            act.Esito_finale_md__c = '';
            act.Nota_compass__c = '';
            act.Nota_societa_esterna__c = '';
            act.Nota_sospesa__c = '';
            act.Num_Pratica__c = '';
            act.pratica_carta__c = '';
            act.question1__c = '';
            act.question2__c = '';
            act.question3__c = '';
            act.Rag_sociale_agente_convenzionato__c = '';
            act.Rag_sociale_subagente_pv__c = '';
            act.Ritardo_dealer__c = '';
            act.Societa__c = '';
            act.Tipo_prodotto__c = '';
            insert act;

            Map<String,List<String>> serviceIdResponseMap = new Map<String,List<String>>();
            
            List<String> respRDCD = new List<String>();
            List<String> respRDPC = new List<String>();
            
            respRDCD.add('{"resultCode":0,"resultMessage":"Ok","recuperaDatiCartaDealerResponse":{"numeroPratica":"","codCliente":"","codDealer":"","codProdotto":"","descProdotto":"","dataRichiesta":"","fido":"","ragioneSociale":"","ragioneSocialeDealer":"","statoDealer":"","telCellulare":"","telDatore":"","telCase":""}}');
            respRDPC.add('{"resultCode":0,"resultMessage":"Ok","recuperaDatiPraticaCommodityResponse":{"numeroPratica":"","codCliente":"","cognome":"","nome":"","ragioneSociale":"","telefonoCasa":"","codDealer":"","statoDealer":"","telCellulare":"","telDatore":"","codClienteCoob":"","cognomeCoob":"","nomeCoob":"","ragioneSocialeCoob":"","telefonoCasaCoob":"","telCellulareCoob":"","telDatoreCoob":"","dataLiquidazione":"","descrizioneBene":"","codDestFinanziamento":"","descDestFinanziamento":"","tipoProdotto":"","numRata":"","importoRata":"","finanziato":"","ragioneSocialeDealer":"","canale":""}}');

            serviceIdResponseMap.put('recuperaDatiCartaDealer', respRDCD);
            serviceIdResponseMap.put('recuperadatiPraticaCommodity', respRDPC);

            UtilityMockResponse UMR = new UtilityMockResponse(); 
            
    //        Id idProfile = [SELECT Id FROM Profile WHERE Name = 'BackOffice'].Id;

            Test.startTest();
            Test.setMock(HttpCalloutMock.class, new UtilityMockResponseMultipleService(serviceIdResponseMap));

    //        System.runAs(us){
                try {
                    SFACommodity_Controller sfa = new SFACommodity_Controller();

                    List<sfa_commodity_check_activity_details__c> lSfa = SFACommodity_Controller.getActivity(caso.Id);
                    List<sfa_commodity_check_esiti_finali_md__mdt> lChi = SFACommodity_Controller.getChiusura('PAPF');
                    Map<String,String> mUser = SFACommodity_Controller.getUserMap();

                    Boolean bSospendi = SFACommodity_Controller.getSospendi(caso.Id, 'NOTA TEST', 'SI', 'Casa', 'Si', true, 'Branch_Activity_Complete', '', Date.valueOf('2019-12-31'));
                    Boolean bSospendi2 = SFACommodity_Controller.getSospendi(caso.Id, 'NOTA TEST', 'SI', 'Casa', 'Si', false, 'Branch_Activity_Complete', '', Date.valueOf('2019-12-31'));
                    Boolean bCompleta = SFACommodity_Controller.getCompleta(caso.Id, 'NOTA TEST', 'SI', 'Casa', 'Si', true, 'Branch_Activity_Complete', '', Date.valueOf('2019-12-31'));

    //                Map<String,String> mRDCD = SFACommodity_Controller.getDatiCarta('123456', true);
    //                Map<String,String> mRDPC = SFACommodity_Controller.getDatiPratica('123456', true);

                    List<ContentDocumentLink> lCD = SFACommodity_Controller.getFile(String.ValueOf(caso.Id));

                    List<ContentVersion> lCV = SFACommodity_Controller.getFileCompleta(String.ValueOf(caso.Id));

                    List<ListView> lLV = SFACommodity_Controller.getListViews('Commodity Check Anomaly');

                } 
                catch (System.AsyncException ex) {
                }
            Test.stopTest();
        }
    }   
    
    private static testmethod void testMDRBAA() {

        insertVarie();

        Id idProfile = [SELECT Id FROM Profile WHERE Name = 'Monitoraggio Dealer'].Id;

        User us = new User();
        us.FirstName = 'TestNome';
        us.LastName = 'TestCognome';
        us.ProfileId = idProfile;
        us.Username = 'testFabio@test.com';
        us.Email = 'test@test.com';
        us.Alias = 'TEST';
        us.TimeZoneSidKey = 'Europe/Rome';
        us.LocaleSidKey = 'en_US';
        us.EmailEncodingKey = 'UTF-8'; 
        us.LanguageLocaleKey = 'en_US';
        us.DefaultQueueId__c = '241';
        
        insert us;

        System.runAs(us){

            Account acc = new Account();
            acc.Name = 'test account';
            acc.COM_NumeroTotali_Pratiche__c='10';
            acc.COM_PraticheChiuse_Conforme__c='5';
            acc.COM_ChiusoNon_Conforme__c='2';
            acc.OCS_External_Id__c = 'F142';
            insert acc;
            
            XCS_Categoria__c xcsC = new XCS_Categoria__c();
            xcsC.Name = 'Commodity Check Anomaly';
            insert xcsC;

            Case caso = new Case();
            caso.Subject = 'Activity';
            caso.Status = 'New';
            caso.Branch__c = acc.Id;
            caso.NumeroPratica__c ='2342342';
            caso.Categoria_Riferimento__c = xcsC.Id;
            insert caso;   

            sfa_commodity_check_activity_details__c act = new sfa_commodity_check_activity_details__c();        
            act.Activity_id__c = caso.id;
            act.Allegato_sospeso__c = 0;	
            act.Categoria__c = '';	
            act.Cod_agente_convenzionato__c = '';
            act.Cod_esito__c = '';
            act.Cod_subagente_pv__c = '';
            act.Data_notifica__c = Date.valueOf('2019-10-16');
            act.Data_verifica__c = Date.valueOf('2019-10-16');
            act.Debitore__c = '';
            act.Dipendente__c = '';
            act.Esito__c = '';
            act.Esito_finale_md__c = '';
            act.Nota_compass__c = '';
            act.Nota_societa_esterna__c = '';
            act.Nota_sospesa__c = '';
            act.Num_Pratica__c = '';
            act.pratica_carta__c = '';
            act.question1__c = '';
            act.question2__c = '';
            act.question3__c = '';
            act.Rag_sociale_agente_convenzionato__c = '';
            act.Rag_sociale_subagente_pv__c = '';
            act.Ritardo_dealer__c = '';
            act.Societa__c = '';
            act.Tipo_prodotto__c = '';
            insert act;

            Map<String,List<String>> serviceIdResponseMap = new Map<String,List<String>>();
            
            List<String> respRDCD = new List<String>();
            List<String> respRDPC = new List<String>();
            
            respRDCD.add('{"resultCode":0,"resultMessage":"Ok","recuperaDatiCartaDealerResponse":{"numeroPratica":"","codCliente":"","codDealer":"","codProdotto":"","descProdotto":"","dataRichiesta":"","fido":"","ragioneSociale":"","ragioneSocialeDealer":"","statoDealer":"","telCellulare":"","telDatore":"","telCase":""}}');
            respRDPC.add('{"resultCode":0,"resultMessage":"Ok","recuperaDatiPraticaCommodityResponse":{"numeroPratica":"","codCliente":"","cognome":"","nome":"","ragioneSociale":"","telefonoCasa":"","codDealer":"","statoDealer":"","telCellulare":"","telDatore":"","codClienteCoob":"","cognomeCoob":"","nomeCoob":"","ragioneSocialeCoob":"","telefonoCasaCoob":"","telCellulareCoob":"","telDatoreCoob":"","dataLiquidazione":"","descrizioneBene":"","codDestFinanziamento":"","descDestFinanziamento":"","tipoProdotto":"","numRata":"","importoRata":"","finanziato":"","ragioneSocialeDealer":"","canale":""}}');

            serviceIdResponseMap.put('recuperaDatiCartaDealer', respRDCD);
            serviceIdResponseMap.put('recuperadatiPraticaCommodity', respRDPC);

            UtilityMockResponse UMR = new UtilityMockResponse(); 
            
    //        Id idProfile = [SELECT Id FROM Profile WHERE Name = 'BackOffice'].Id;

            Test.startTest();
            Test.setMock(HttpCalloutMock.class, new UtilityMockResponseMultipleService(serviceIdResponseMap));

    //        System.runAs(us){
                try {
                    SFACommodity_Controller sfa = new SFACommodity_Controller();

                    List<sfa_commodity_check_activity_details__c> lSfa = SFACommodity_Controller.getActivity(caso.Id);
                    List<sfa_commodity_check_esiti_finali_md__mdt> lChi = SFACommodity_Controller.getChiusura('PAPF');
                    Map<String,String> mUser = SFACommodity_Controller.getUserMap();

                    Boolean bSospendi = SFACommodity_Controller.getSospendi(caso.Id, 'NOTA TEST', 'SI', 'Casa', 'Si', true, 'Return to Branch', '', Date.valueOf('2019-12-31'));
                    Boolean bSospendi2 = SFACommodity_Controller.getSospendi(caso.Id, 'NOTA TEST', 'SI', 'Casa', 'Si', false, 'Return to Branch', '', Date.valueOf('2019-12-31'));
                    Boolean bCompleta = SFACommodity_Controller.getCompleta(caso.Id, 'NOTA TEST', 'SI', 'Casa', 'Si', true, 'Return to Branch', '', Date.valueOf('2019-12-31'));

    //                Map<String,String> mRDCD = SFACommodity_Controller.getDatiCarta('123456', true);
    //                Map<String,String> mRDPC = SFACommodity_Controller.getDatiPratica('123456', true);

                    List<ContentDocumentLink> lCD = SFACommodity_Controller.getFile(String.ValueOf(caso.Id));

                    List<ContentVersion> lCV = SFACommodity_Controller.getFileCompleta(String.ValueOf(caso.Id));

                    List<ListView> lLV = SFACommodity_Controller.getListViews('Commodity Check Anomaly');

                } 
                catch (System.AsyncException ex) {
                }
            Test.stopTest();
        }
    }   


    private static testmethod void testMDRBAC() {

        insertVarie();

        Id idProfile = [SELECT Id FROM Profile WHERE Name = 'Monitoraggio Dealer'].Id;

        User us = new User();
        us.FirstName = 'TestNome';
        us.LastName = 'TestCognome';
        us.ProfileId = idProfile;
        us.Username = 'testFabio@test.com';
        us.Email = 'test@test.com';
        us.Alias = 'TEST';
        us.TimeZoneSidKey = 'Europe/Rome';
        us.LocaleSidKey = 'en_US';
        us.EmailEncodingKey = 'UTF-8'; 
        us.LanguageLocaleKey = 'en_US';
        us.DefaultQueueId__c = '241';
        
        insert us;

        System.runAs(us){

            Account acc = new Account();
            acc.Name = 'test account';
            acc.COM_NumeroTotali_Pratiche__c='10';
            acc.COM_PraticheChiuse_Conforme__c='5';
            acc.COM_ChiusoNon_Conforme__c='2';
            acc.OCS_External_Id__c = 'F142';
            insert acc;
            
            XCS_Categoria__c xcsC = new XCS_Categoria__c();
            xcsC.Name = 'Commodity Check Critical';
            insert xcsC;

            Case caso = new Case();
            caso.Subject = 'Activity';
            caso.Status = 'New';
            caso.Branch__c = acc.Id;
            caso.NumeroPratica__c ='2342342';
            caso.Categoria_Riferimento__c = xcsC.Id;
            insert caso;   

            sfa_commodity_check_activity_details__c act = new sfa_commodity_check_activity_details__c();        
            act.Activity_id__c = caso.id;
            act.Allegato_sospeso__c = 0;	
            act.Categoria__c = '';	
            act.Cod_agente_convenzionato__c = '';
            act.Cod_esito__c = '';
            act.Cod_subagente_pv__c = '';
            act.Data_notifica__c = Date.valueOf('2019-10-16');
            act.Data_verifica__c = Date.valueOf('2019-10-16');
            act.Debitore__c = '';
            act.Dipendente__c = '';
            act.Esito__c = '';
            act.Esito_finale_md__c = '';
            act.Nota_compass__c = '';
            act.Nota_societa_esterna__c = '';
            act.Nota_sospesa__c = '';
            act.Num_Pratica__c = '';
            act.pratica_carta__c = '';
            act.question1__c = '';
            act.question2__c = '';
            act.question3__c = '';
            act.Rag_sociale_agente_convenzionato__c = '';
            act.Rag_sociale_subagente_pv__c = '';
            act.Ritardo_dealer__c = '';
            act.Societa__c = '';
            act.Tipo_prodotto__c = '';
            insert act;

            Map<String,List<String>> serviceIdResponseMap = new Map<String,List<String>>();
            
            List<String> respRDCD = new List<String>();
            List<String> respRDPC = new List<String>();
            
            respRDCD.add('{"resultCode":0,"resultMessage":"Ok","recuperaDatiCartaDealerResponse":{"numeroPratica":"","codCliente":"","codDealer":"","codProdotto":"","descProdotto":"","dataRichiesta":"","fido":"","ragioneSociale":"","ragioneSocialeDealer":"","statoDealer":"","telCellulare":"","telDatore":"","telCase":""}}');
            respRDPC.add('{"resultCode":0,"resultMessage":"Ok","recuperaDatiPraticaCommodityResponse":{"numeroPratica":"","codCliente":"","cognome":"","nome":"","ragioneSociale":"","telefonoCasa":"","codDealer":"","statoDealer":"","telCellulare":"","telDatore":"","codClienteCoob":"","cognomeCoob":"","nomeCoob":"","ragioneSocialeCoob":"","telefonoCasaCoob":"","telCellulareCoob":"","telDatoreCoob":"","dataLiquidazione":"","descrizioneBene":"","codDestFinanziamento":"","descDestFinanziamento":"","tipoProdotto":"","numRata":"","importoRata":"","finanziato":"","ragioneSocialeDealer":"","canale":""}}');

            serviceIdResponseMap.put('recuperaDatiCartaDealer', respRDCD);
            serviceIdResponseMap.put('recuperadatiPraticaCommodity', respRDPC);

            UtilityMockResponse UMR = new UtilityMockResponse(); 
            
    //        Id idProfile = [SELECT Id FROM Profile WHERE Name = 'BackOffice'].Id;

            Test.startTest();
            Test.setMock(HttpCalloutMock.class, new UtilityMockResponseMultipleService(serviceIdResponseMap));

    //        System.runAs(us){
                try {
                    SFACommodity_Controller sfa = new SFACommodity_Controller();

                    List<sfa_commodity_check_activity_details__c> lSfa = SFACommodity_Controller.getActivity(caso.Id);
                    List<sfa_commodity_check_esiti_finali_md__mdt> lChi = SFACommodity_Controller.getChiusura('PAPF');
                    Map<String,String> mUser = SFACommodity_Controller.getUserMap();

                    Boolean bSospendi = SFACommodity_Controller.getSospendi(caso.Id, 'NOTA TEST', 'SI', 'Casa', 'Si', true, 'Return to Branch', '', Date.valueOf('2019-12-31'));
                    Boolean bSospendi2 = SFACommodity_Controller.getSospendi(caso.Id, 'NOTA TEST', 'SI', 'Casa', 'Si', false, 'Return to Branch', '', Date.valueOf('2019-12-31'));
                    Boolean bCompleta = SFACommodity_Controller.getCompleta(caso.Id, 'NOTA TEST', 'SI', 'Casa', 'Si', true, 'Return to Branch', '', Date.valueOf('2019-12-31'));

    //                Map<String,String> mRDCD = SFACommodity_Controller.getDatiCarta('123456', true);
    //                Map<String,String> mRDPC = SFACommodity_Controller.getDatiPratica('123456', true);

                    List<ContentDocumentLink> lCD = SFACommodity_Controller.getFile(String.ValueOf(caso.Id));

                    List<ContentVersion> lCV = SFACommodity_Controller.getFileCompleta(String.ValueOf(caso.Id));

                    List<ListView> lLV = SFACommodity_Controller.getListViews('Commodity Check Anomaly');

                } 
                catch (System.AsyncException ex) {
                }
            Test.stopTest();
        }
    }   

    private static testmethod void testMDACAC() {

        insertVarie();

        Id idProfile = [SELECT Id FROM Profile WHERE Name = 'Monitoraggio Dealer'].Id;

        User us = new User();
        us.FirstName = 'TestNome';
        us.LastName = 'TestCognome';
        us.ProfileId = idProfile;
        us.Username = 'testFabio@test.com';
        us.Email = 'test@test.com';
        us.Alias = 'TEST';
        us.TimeZoneSidKey = 'Europe/Rome';
        us.LocaleSidKey = 'en_US';
        us.EmailEncodingKey = 'UTF-8'; 
        us.LanguageLocaleKey = 'en_US';
        us.DefaultQueueId__c = '241';
        
        insert us;

        System.runAs(us){

            Account acc = new Account();
            acc.Name = 'test account';
            acc.COM_NumeroTotali_Pratiche__c='10';
            acc.COM_PraticheChiuse_Conforme__c='5';
            acc.COM_ChiusoNon_Conforme__c='2';
            acc.OCS_External_Id__c = 'F142';
            insert acc;
            
            XCS_Categoria__c xcsC = new XCS_Categoria__c();
            xcsC.Name = 'Commodity Check Critical';
            insert xcsC;

            Case caso = new Case();
            caso.Subject = 'Activity';
            caso.Status = 'New';
            caso.Branch__c = acc.Id;
            caso.NumeroPratica__c ='2342342';
            caso.Categoria_Riferimento__c = xcsC.Id;
            insert caso;   

            sfa_commodity_check_activity_details__c act = new sfa_commodity_check_activity_details__c();        
            act.Activity_id__c = caso.id;
            act.Allegato_sospeso__c = 0;	
            act.Categoria__c = '';	
            act.Cod_agente_convenzionato__c = '';
            act.Cod_esito__c = '';
            act.Cod_subagente_pv__c = '';
            act.Data_notifica__c = Date.valueOf('2019-10-16');
            act.Data_verifica__c = Date.valueOf('2019-10-16');
            act.Debitore__c = '';
            act.Dipendente__c = '';
            act.Esito__c = '';
            act.Esito_finale_md__c = '';
            act.Nota_compass__c = '';
            act.Nota_societa_esterna__c = '';
            act.Nota_sospesa__c = '';
            act.Num_Pratica__c = '';
            act.pratica_carta__c = '';
            act.question1__c = '';
            act.question2__c = '';
            act.question3__c = '';
            act.Rag_sociale_agente_convenzionato__c = '';
            act.Rag_sociale_subagente_pv__c = '';
            act.Ritardo_dealer__c = '';
            act.Societa__c = '';
            act.Tipo_prodotto__c = '';
            insert act;

            Map<String,List<String>> serviceIdResponseMap = new Map<String,List<String>>();
            
            List<String> respRDCD = new List<String>();
            List<String> respRDPC = new List<String>();
            
            respRDCD.add('{"resultCode":0,"resultMessage":"Ok","recuperaDatiCartaDealerResponse":{"numeroPratica":"","codCliente":"","codDealer":"","codProdotto":"","descProdotto":"","dataRichiesta":"","fido":"","ragioneSociale":"","ragioneSocialeDealer":"","statoDealer":"","telCellulare":"","telDatore":"","telCase":""}}');
            respRDPC.add('{"resultCode":0,"resultMessage":"Ok","recuperaDatiPraticaCommodityResponse":{"numeroPratica":"","codCliente":"","cognome":"","nome":"","ragioneSociale":"","telefonoCasa":"","codDealer":"","statoDealer":"","telCellulare":"","telDatore":"","codClienteCoob":"","cognomeCoob":"","nomeCoob":"","ragioneSocialeCoob":"","telefonoCasaCoob":"","telCellulareCoob":"","telDatoreCoob":"","dataLiquidazione":"","descrizioneBene":"","codDestFinanziamento":"","descDestFinanziamento":"","tipoProdotto":"","numRata":"","importoRata":"","finanziato":"","ragioneSocialeDealer":"","canale":""}}');

            serviceIdResponseMap.put('recuperaDatiCartaDealer', respRDCD);
            serviceIdResponseMap.put('recuperadatiPraticaCommodity', respRDPC);

            UtilityMockResponse UMR = new UtilityMockResponse(); 
            
    //        Id idProfile = [SELECT Id FROM Profile WHERE Name = 'BackOffice'].Id;

            Test.startTest();
            Test.setMock(HttpCalloutMock.class, new UtilityMockResponseMultipleService(serviceIdResponseMap));

    //        System.runAs(us){
                try {
                    SFACommodity_Controller sfa = new SFACommodity_Controller();

                    List<sfa_commodity_check_activity_details__c> lSfa = SFACommodity_Controller.getActivity(caso.Id);
                    List<sfa_commodity_check_esiti_finali_md__mdt> lChi = SFACommodity_Controller.getChiusura('PAPF');
                    Map<String,String> mUser = SFACommodity_Controller.getUserMap();

                    Boolean bSospendi = SFACommodity_Controller.getSospendi(caso.Id, 'NOTA TEST', 'SI', 'Casa', 'Si', true, 'Activity Complete', '', Date.valueOf('2019-12-31'));
                    Boolean bSospendi2 = SFACommodity_Controller.getSospendi(caso.Id, 'NOTA TEST', 'SI', 'Casa', 'Si', false, 'Activity Complete', '', Date.valueOf('2019-12-31'));
                    Boolean bCompleta = SFACommodity_Controller.getCompleta(caso.Id, 'NOTA TEST', 'SI', 'Casa', 'Si', true, 'Activity Complete', '', Date.valueOf('2019-12-31'));

    //                Map<String,String> mRDCD = SFACommodity_Controller.getDatiCarta('123456', true);
    //                Map<String,String> mRDPC = SFACommodity_Controller.getDatiPratica('123456', true);

                    List<ContentDocumentLink> lCD = SFACommodity_Controller.getFile(String.ValueOf(caso.Id));

                    List<ContentVersion> lCV = SFACommodity_Controller.getFileCompleta(String.ValueOf(caso.Id));

                    List<ListView> lLV = SFACommodity_Controller.getListViews('Commodity Check Anomaly');

                } 
                catch (System.AsyncException ex) {
                }
            Test.stopTest();
        }
    }   

    private static testmethod void testMDACAA() {

        insertVarie();

        Id idProfile = [SELECT Id FROM Profile WHERE Name = 'Monitoraggio Dealer'].Id;

        User us = new User();
        us.FirstName = 'TestNome';
        us.LastName = 'TestCognome';
        us.ProfileId = idProfile;
        us.Username = 'testFabio@test.com';
        us.Email = 'test@test.com';
        us.Alias = 'TEST';
        us.TimeZoneSidKey = 'Europe/Rome';
        us.LocaleSidKey = 'en_US';
        us.EmailEncodingKey = 'UTF-8'; 
        us.LanguageLocaleKey = 'en_US';
        us.DefaultQueueId__c = '241';
        
        insert us;

        System.runAs(us){

            Account acc = new Account();
            acc.Name = 'test account';
            acc.COM_NumeroTotali_Pratiche__c='10';
            acc.COM_PraticheChiuse_Conforme__c='5';
            acc.COM_ChiusoNon_Conforme__c='2';
            acc.OCS_External_Id__c = 'F142';
            insert acc;
            
            XCS_Categoria__c xcsC = new XCS_Categoria__c();
            xcsC.Name = 'Commodity Check Anomaly';
            insert xcsC;

            Case caso = new Case();
            caso.Subject = 'Activity';
            caso.Status = 'New';
            caso.Branch__c = acc.Id;
            caso.NumeroPratica__c ='2342342';
            caso.Categoria_Riferimento__c = xcsC.Id;
            insert caso;   

            sfa_commodity_check_activity_details__c act = new sfa_commodity_check_activity_details__c();        
            act.Activity_id__c = caso.id;
            act.Allegato_sospeso__c = 0;	
            act.Categoria__c = '';	
            act.Cod_agente_convenzionato__c = '';
            act.Cod_esito__c = '';
            act.Cod_subagente_pv__c = '';
            act.Data_notifica__c = Date.valueOf('2019-10-16');
            act.Data_verifica__c = Date.valueOf('2019-10-16');
            act.Debitore__c = '';
            act.Dipendente__c = '';
            act.Esito__c = '';
            act.Esito_finale_md__c = '';
            act.Nota_compass__c = '';
            act.Nota_societa_esterna__c = '';
            act.Nota_sospesa__c = '';
            act.Num_Pratica__c = '';
            act.pratica_carta__c = '';
            act.question1__c = '';
            act.question2__c = '';
            act.question3__c = '';
            act.Rag_sociale_agente_convenzionato__c = '';
            act.Rag_sociale_subagente_pv__c = '';
            act.Ritardo_dealer__c = '';
            act.Societa__c = '';
            act.Tipo_prodotto__c = '';
            insert act;

            Map<String,List<String>> serviceIdResponseMap = new Map<String,List<String>>();
            
            List<String> respRDCD = new List<String>();
            List<String> respRDPC = new List<String>();
            
            respRDCD.add('{"resultCode":0,"resultMessage":"Ok","recuperaDatiCartaDealerResponse":{"numeroPratica":"","codCliente":"","codDealer":"","codProdotto":"","descProdotto":"","dataRichiesta":"","fido":"","ragioneSociale":"","ragioneSocialeDealer":"","statoDealer":"","telCellulare":"","telDatore":"","telCase":""}}');
            respRDPC.add('{"resultCode":0,"resultMessage":"Ok","recuperaDatiPraticaCommodityResponse":{"numeroPratica":"","codCliente":"","cognome":"","nome":"","ragioneSociale":"","telefonoCasa":"","codDealer":"","statoDealer":"","telCellulare":"","telDatore":"","codClienteCoob":"","cognomeCoob":"","nomeCoob":"","ragioneSocialeCoob":"","telefonoCasaCoob":"","telCellulareCoob":"","telDatoreCoob":"","dataLiquidazione":"","descrizioneBene":"","codDestFinanziamento":"","descDestFinanziamento":"","tipoProdotto":"","numRata":"","importoRata":"","finanziato":"","ragioneSocialeDealer":"","canale":""}}');

            serviceIdResponseMap.put('recuperaDatiCartaDealer', respRDCD);
            serviceIdResponseMap.put('recuperadatiPraticaCommodity', respRDPC);

            UtilityMockResponse UMR = new UtilityMockResponse(); 
            
    //        Id idProfile = [SELECT Id FROM Profile WHERE Name = 'BackOffice'].Id;

            Test.startTest();
            Test.setMock(HttpCalloutMock.class, new UtilityMockResponseMultipleService(serviceIdResponseMap));

    //        System.runAs(us){
                try {
                    SFACommodity_Controller sfa = new SFACommodity_Controller();

                    List<sfa_commodity_check_activity_details__c> lSfa = SFACommodity_Controller.getActivity(caso.Id);
                    List<sfa_commodity_check_esiti_finali_md__mdt> lChi = SFACommodity_Controller.getChiusura('PAPF');
                    Map<String,String> mUser = SFACommodity_Controller.getUserMap();

                    Boolean bSospendi = SFACommodity_Controller.getSospendi(caso.Id, 'NOTA TEST', 'SI', 'Casa', 'Si', true, 'Activity Complete', '', Date.valueOf('2019-12-31'));
                    Boolean bSospendi2 = SFACommodity_Controller.getSospendi(caso.Id, 'NOTA TEST', 'SI', 'Casa', 'Si', false, 'Activity Complete', '', Date.valueOf('2019-12-31'));
                    Boolean bCompleta = SFACommodity_Controller.getCompleta(caso.Id, 'NOTA TEST', 'SI', 'Casa', 'Si', true, 'Activity Complete', '', Date.valueOf('2019-12-31'));

    //                Map<String,String> mRDCD = SFACommodity_Controller.getDatiCarta('123456', true);
    //                Map<String,String> mRDPC = SFACommodity_Controller.getDatiPratica('123456', true);

                    List<ContentDocumentLink> lCD = SFACommodity_Controller.getFile(String.ValueOf(caso.Id));

                    List<ContentVersion> lCV = SFACommodity_Controller.getFileCompleta(String.ValueOf(caso.Id));

                    List<ListView> lLV = SFACommodity_Controller.getListViews('Commodity Check Anomaly');

                } 
                catch (System.AsyncException ex) {
                }
            Test.stopTest();
        }
    }   
    
    
    
    
}