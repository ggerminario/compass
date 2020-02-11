//----------------------------------------------------------------------
//-- - Author       : SANA BADJI
//-- - Date         : 15/07/2019
//-- - Description  : Handle WS_RecuperaInfoInserimentoBloccoTest
//----------------------------------------------------------------------
@isTest
public  class COGETECV1Test {
    
    @TestSetup
    static void makeData(){
    //String response = '{"resultCode": 0,"resultMessage": "Ok","OCS_COGETEC_V1": {"movimenti": [{ "dataValuta": "20180131","dataRegistrazione": "20180108","dataAcquisto": "20180103","causale": "10","importo": "1275"}]}}';

    String response = '{"resultCode": 0,"resultMessage": "Ok","cogetecv1Response": {"mftcoecoOCCURS": [{"mftcoecoELEMENTO": [{"mftcoecoPARTITA": 1,"mftcoecoPARTITATIPO": "RP","mftcoecoIMPORTO": 53530,"mftcoecoIMPORTOS": "","mftcoecoNUMERORATA": "1","mftcoecoSALDOS": ""}]}]}}';
    ApiRest__c apiRest = new ApiRest__c(Method__c = 'POST',
                                        Test_Response__c= response,
                                        Test_Request__c = 'testRequest',
                                        Mock__c = false, 
                                        User__c = 'CDSLF00',
                                        Password__c = 'P00FLSDC' ,
                                        Name ='OCS_COGETEC_V1',
                                        EndPoint__c = 'https://richiestaonlinesvi.compassonline.it/B2BSOAP/rest/B2BREST/execute');      
    insert apiRest;  
    System.debug('apiRest '+ apiRest);
              
               // insert mylist;

    }

    @isTest   static void testInvoke(){
        
        Test.startTest();
        UtilityMockResponse UTM = new UtilityMockResponse();
        UTM.apiname ='OCS_COGETEC_V1';
        Test.setMock(HttpCalloutMock.class, UTM);


       COGETECV1Response resp1 =  COGETECV1Service.buildCOGETECV1Response ('16132993','tmpKey',
                                                              'senderTipo', 12,
                                                             'tipoCaricamento','canalAqusiz');
        COGETECV1Response resp2 =
        COGETECV1Service.buildCOGETECV1Response(
            '16132993',null,null,null,null,null, null, null,
                                                    null,
                                                    null,
                                                    null,
                                                    null,
                                                    null,
                                                    null,
                                                    12,
                                                '',
                                                'ES');
    System.debug('****************** resp2 '+ resp2);
    //     System.debug(' ************** resp2 ' +resp2);

        Test.stopTest();
    }

    @isTest
        static void validateResponsetest(){
        Test.startTest();
        String jsonString = '{"resultCode":1,"resultMessage": "KO","cogetecv1Response": {"mftcoeco_OCCURS": [],"mfterr_OMSFERR_OCCURS": null,\n'+
                '"msfologon_ERRORE_DES": "","msfologon_STATUS": "","msfologon_SESSION_ID": "","msfologon_ERRORE": ""}}';
        System.debug(' ************** jsonString ' +jsonString);
        COGETECV1Response response = (COGETECV1Response) JSON.deserializeStrict(jsonString, COGETECV1Response.class);
        Boolean bool=COGETECV1Service.validateResponse(response);
        System.debug(' ************** bool ' +bool);
        System.assertEquals(false, bool,'') ;
        Test.stopTest();
        }
    @isTest
        static void getElementoWithSoldeZerotest(){
         // Test.startTest();
                List<COGETECV1Response.MFTCOECO_ELEMENTO> mylist = new List<COGETECV1Response.MFTCOECO_ELEMENTO>();
                COGETECV1Response.MFTCOECO_ELEMENTO e1 = new COGETECV1Response.MFTCOECO_ELEMENTO();
                e1.mftcoeco_PARTITA =1;
                e1.mftcoeco_SALDO = 0;
                COGETECV1Response.MFTCOECO_ELEMENTO e2 = new COGETECV1Response.MFTCOECO_ELEMENTO();
                e2.mftcoeco_DATA_SCADENZA ='20190720';
                e2.mftcoeco_SALDO = 3;
                COGETECV1Response.MFTCOECO_ELEMENTO e3 = new COGETECV1Response.MFTCOECO_ELEMENTO();
                e3.mftcoeco_DATA_SCADENZA ='20190721';
                e3.mftcoeco_SALDO = 0;
                COGETECV1Response.MFTCOECO_ELEMENTO e4 = new COGETECV1Response.MFTCOECO_ELEMENTO();
                e4.mftcoeco_DATA_SCADENZA ='20190722';
                e4.mftcoeco_SALDO = 1;
                mylist.add(e1); 
                mylist.add(e2); 
                mylist.add(e3);
                mylist.add(e4);
                List<COGETECV1Response.MFTCOECO_ELEMENTO> test = COGETECV1Service.getElementoWithSoldeZero(mylist);
                System.debug('************* size getElementoWithSoldeZero'+test.size());
                for(COGETECV1Response.MFTCOECO_ELEMENTO e : test){
                System.debug('xxxxx ele'+e.mftcoeco_DATA_SCADENZA);
                }
                System.assertEquals(2, test.size(),'') ;
     //  Test.stopTest();
        }

@isTest
    static void gestitoCOGETECV1Servicetest(){
       // Test.startTest();
    
            List<COGETECV1Response.MFTCOECO_ELEMENTO> mylist = new List<COGETECV1Response.MFTCOECO_ELEMENTO>();
            List<COGETECVElementoRecent> listRecent = new List<COGETECVElementoRecent>();
            COGETECV1Response.MFTCOECO_ELEMENTO e1 = new COGETECV1Response.MFTCOECO_ELEMENTO();
            e1.mftcoeco_DATA_SCADENZA ='20190720';
            e1.mftcoeco_PARTITA =1;
            e1.mftcoeco_SALDO = 0;
            e1.mftcoeco_IMPORTO='50089';
            COGETECV1Response.MFTCOECO_ELEMENTO e2 = new COGETECV1Response.MFTCOECO_ELEMENTO();
            e2.mftcoeco_DATA_SCADENZA ='20190720';
            e2.mftcoeco_PARTITA =1;
            e2.mftcoeco_SALDO = 3;
            e2.mftcoeco_IMPORTO='50089';
            COGETECV1Response.MFTCOECO_ELEMENTO e3 = new COGETECV1Response.MFTCOECO_ELEMENTO();
            e3.mftcoeco_DATA_SCADENZA ='20190721';
            e3.mftcoeco_SALDO = 0;
            e3.mftcoeco_IMPORTO='50089';
            e3.mftcoeco_PARTITA =1;
            COGETECV1Response.MFTCOECO_ELEMENTO e4 = new COGETECV1Response.MFTCOECO_ELEMENTO();
            e4.mftcoeco_DATA_SCADENZA ='20190722';
            e4.mftcoeco_SALDO = 1;
            e4.mftcoeco_IMPORTO='50089';
            e4.mftcoeco_PARTITA =1;
            mylist.add(e1); 
            mylist.add(e2); 
            mylist.add(e3);
            mylist.add(e4);
            listRecent.add(new COGETECVElementoRecent(e1)); 
            listRecent.add(new COGETECVElementoRecent(e2));
            listRecent.add(new COGETECVElementoRecent(e3));
            listRecent.add(new COGETECVElementoRecent(e4));
            COGETECV1Service.dividendoElimina(e1);
            //listRecent[0].mftCoecoElement.mftcoeco_PARTITA;
            System.debug('************* mylist  '+mylist);
           // insert mylist;
            COGETECV1Response.MFTCOECO_ELEMENTO test = COGETECV1Service.gestitoCOGETECV1Service(mylist);
            System.debug('************* size gestitoCOGETECV1Service '+test);
           

   System.assert(test!=null,'') ;
    //Test.stopTest();
    }
}