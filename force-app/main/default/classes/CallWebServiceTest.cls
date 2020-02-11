//----------------------------------------------------------------------
//-- - Author       : SANA BADJI
//-- - Date         : 30/07/2019
//-- - Description  : Handle RichOnlinePrescoringServiceTest
//----------------------------------------------------------------------
@isTest
public  class CallWebServiceTest {
    

@TestSetup
static void makeData(){
        String response = '{"resultCode": 0,"resultMessage": "Ok","recuperaStatiAttributiPrtResponse": {  "elencoPratiche": [{"tipoPratica": "CA","numPratica": "33190097388","statoPratica": "05","attrbutoPratica": "BT","canale": "MAE"}]}}';
        ApiRest__c apiRest = new ApiRest__c(Method__c = 'POST' ,
                                            Test_Response__c= response ,
                                            Test_Request__c = 'testRequest',
                                            Mock__c = false, 
                                            User__c = 'CDSLF00',
                                            Password__c = 'P00FLSDC' ,
                                            Name ='recuperaStatiAttributiPrt',
                                            EndPoint__c = 'https://richiestaonlinesvi.compassonline.it/B2BSOAP/rest/B2BREST/execute');      
        insert apiRest;  
        System.debug(apiRest);
    
    Product2 product = new Product2(Name='Produit1', Family='PP_ONLINE_COMPASS_DS',DEMAnomalie__c='2072');
    insert product;

    Case  v1 = new Case (Stato_Pratica__c='20',NumeroPratica__c='18866725',
    Attributi_Pratica__c ='SD',stato_ocs__c='20SD',RO_Vecchio_Cellulare__c='773528750',RO_Link_Bozza__c='https://compass--dev3.lightning.force.com/',
    Subject='This is a test case for testCaseForForum' ,Is_Discordanza_Cellulare__c=false, Product__c=product.Id);
    insert v1;   
}
@isTest 
static void recuperaRequestPreSicTest(){
    String jsonString = '{"serviceId" : "recuperaStatiAttributiPrt","companyType" : { "value" : "COMPASS"},"recuperaStatiAttributiPrtRequest" : {"elencoPratiche" : [ {"tipoPratica" : "CA","numPratica" : "33190097388","statoPratica" : "05","attributoPratica" : "BT","canale" : null} ]}}';
    ApiRest__c apiObj = ApiRest__c.getValues('recuperaStatiAttributiPrt');
    System.debug(' ************** apiObj recuperaStatiAttributiPrt ' +apiObj);
    RecuperaStatiAttributiPrtRequest rest = (RecuperaStatiAttributiPrtRequest) JSON.deserializeStrict(jsonString, RecuperaStatiAttributiPrtRequest.class);
    System.debug(' ************** rest  ' +rest);
    Test.startTest();
    Set<Id> caseId = new Set<Id>();
    Case v2 = [SELECT Id FROM Case ];
    caseId.add(v2.Id);
    UtilityMockResponse umr = new UtilityMockResponse();
    umr.apiname ='recuperaStatiAttributiPrt';
    Test.setMock(HttpCalloutMock.class, umr);
    CallWebService.recuperaRequestPreSic(caseId);
    System.assert(v2 != null,'');                                                                                                         
    Test.stopTest();
}

@isTest 
static void addToQueuAfterCallWebserviceTest(){
    Test.startTest();
    UtilityMockResponse umr = new UtilityMockResponse();
    umr.apiname ='recuperaStatiAttributiPrt';
    Test.setMock(HttpCalloutMock.class, umr);
    Set<Id> caseId = new Set<Id>();
    Case v2 = [SELECT Id,OwnerId,Is_Discordanza_Cellulare__c FROM Case ];
    Product2  p = [SELECT Id,Family FROM Product2 ];
    caseId.add(v2.Id);
    String family=p.Family;
    CallWebService.addToQueuAfterCallWebservice(caseId,'Q377',family);
    System.assert(v2 != null,'');                                                                                                         
    Test.stopTest();
}


@isTest 
static void updateStatoOcsTest(){
    Test.startTest();
    UtilityMockResponse umr = new UtilityMockResponse();
    umr.apiname ='recuperaStatiAttributiPrt';
    Test.setMock(HttpCalloutMock.class, umr);
    Set<Id> caseId = new Set<Id>();
    Case v2 = [SELECT Id,OwnerId,Is_Discordanza_Cellulare__c FROM Case ];
    Product2  p = [SELECT Id,Family FROM Product2 ];
    caseId.add(v2.Id);
    String family=p.Family;
    CallWebService.updateStatoOcs(caseId, '20SD','');
    System.assert(v2 != null,'');                                                                                                         
    Test.stopTest();
}

@isTest 
static void createNoteTest(){
    Test.startTest();
    Set<Id> caseId = new Set<Id>();
    Id idcase;
    Case v2 = [SELECT Id,OwnerId,Is_Discordanza_Cellulare__c,RO_Link_Bozza__c FROM Case ];
    Product2  p = [SELECT Id,Family FROM Product2 ];
    caseId.add(v2.Id);
    String family=p.Family;
    String roLinkBozza=v2.RO_Link_Bozza__c;
    idcase=v2.Id;
    CallWebService.createNote('inviata demAnomalie','m@gmail.com',roLinkbozza,'anomalie error',idcase );
    System.assert(v2 != null,'');                                                                                                         
    Test.stopTest();
}

@isTest 
static void createNoteExceptionTest(){
    Test.startTest();
    Set<Id> caseId = new Set<Id>();
    Id idcase;
    Case v2 = [SELECT Id,OwnerId,Is_Discordanza_Cellulare__c,RO_Link_Bozza__c FROM Case ];
    Product2  p = [SELECT Id,Family FROM Product2 ];
    caseId.add(v2.Id);
    String family=p.Family;
    String roLinkBozza=null;
    idcase=v2.Id;
    CallWebService.createNote('inviata demAnomalie','m@gmail.com',roLinkbozza,'anomalie error',idcase );
    System.assert(v2 != null,'');                                                                                                         
    Test.stopTest();
}

}