/**
*@author 		Mame bousso kane
*created 		19/09/2019
*descripttion 	test of the AppuntamentoListaFilialiService class
*/
@isTest
public class AppuntamentoListaFilialiServiceTest {
	@testSetup 
    static void testSetup() {
        
          ApiRest__c apiRest = new ApiRest__c(Method__c = 'POST' ,
                                             //Test_Response__c= response ,
                                             Test_Request__c = 'testRequest',
                                              Mock__c = false, 
                                              User__c = 'CDSLF00',
                                              Password__c = 'P00FLSDC' ,
                                              Name ='locator',
                                              EndPoint__c = 'https://richiestaonlinesvi.compassonline.it/B2BSOAP/rest/B2BREST/execute'
                                              );      
            insert apiRest;  
            System.debug(apiRest);
            List<Product2> listproduit = new List<Product2>{
            new Product2(Name='P1', ProductCode='145', Family='PP_ONLINE_COMPASS_DS' , Livello__c = 0 ),
            new Product2(Name='P2', ProductCode='146', Family='PP_ONLINE_PARTNER_DS' , Livello__c = 0 ),
            new Product2(Name='P3', ProductCode='147', Family='PP_ONLINE_PARTNER_DS' , Livello__c = 1 )
        };
            insert listproduit;

        //AppuntamentoListaFilialiResponse response = new AppuntamentoListaFilialiResponse();
        AppuntamentoListaFilialiResponse.PuntoRicercatoOCS punt= new AppuntamentoListaFilialiResponse.PuntoRicercatoOCS();
        punt.coordinates='coord';
        punt.postalCodeNumber='postCod';
        punt.addressGeoCode='adress';

        AppuntamentoListaFilialiResponse.FilialeOCS fl = new AppuntamentoListaFilialiResponse.FilialeOCS();
        fl.id='';
        fl.idL='';
        fl.idMappa='';
        fl.pV='';
        fl.indirizzo='';
        fl.citta='';
        fl.provincia='';
        fl.cap='';
        fl.email='';
        fl.area='';
        fl.manager='';
        fl.tel='';
        fl.longitudine='';
        fl.latitudine='';
        fl.dst='';
        fl.occupazione='';
        fl.ele_text='';

        List<AppuntamentoListaFilialiResponse.FilialeOCS>  Filiali=new List<AppuntamentoListaFilialiResponse.FilialeOCS>();

        AppuntamentoListaFilialiResponse.Result res = new AppuntamentoListaFilialiResponse.Result();
        res.puntoRicercato=punt;
        res.Filiali=Filiali;

        AppuntamentoListaFilialiResponse.XMLWrapper xml = new AppuntamentoListaFilialiResponse.XMLWrapper();
        xml.result=res;
        xml.prodotto='';
	}
    
    @isTest
    static void testBuildAppuntamentoListaFiliali(){
       
        Product2 product = [SELECT Name,Livello__c FROM Product2 limit 1];
        ApiRest__c apiObj = ApiRest__c.getValues('locator');
        System.debug(' ************** apiObj locator ' +apiObj);
        Test.startTest();
        AppuntamentoListaFilialiService filiali= new AppuntamentoListaFilialiService();
 		AppuntamentoListaFilialiResponse response= filiali.buildAppuntamentoListaFiliali('Milano','','',product.Name);
   		Test.stopTest();
        System.assert(response!=null, '');
    }
    
    @isTest
    static void testValidteResponse(){
        Test.startTest();
        AppuntamentoListaFilialiResponse response = new AppuntamentoListaFilialiResponse();
        AppuntamentoListaFilialiService filiali= new AppuntamentoListaFilialiService();
 		Boolean resp= filiali.validteResponse(response);

   		Test.stopTest();
    }
    
    @isTest
    static void testValidteRequest(){
        Test.startTest();
        AppuntamentoListaFilialiRequest request = new AppuntamentoListaFilialiRequest();
        AppuntamentoListaFilialiService filiali= new AppuntamentoListaFilialiService();
 		Boolean response= filiali.validteRequest(request);
   		Test.stopTest();
    }

    
    @isTest
    static void getTagNamesAsArrayTest(){
        Test.startTest();
        AppuntamentoListaFilialiResponse response = new AppuntamentoListaFilialiResponse();
        response.getTagNamesAsArray();
        System.assert(response!=null, '');
   		Test.stopTest();
    }

    
    @isTest
    static void getParametriTest(){
        Test.startTest();
        AppuntamentoListaFilialiRequest request = new AppuntamentoListaFilialiRequest();
        request.getParametri();
        System.assert(request!=null, '');
   		Test.stopTest();
    }

    

   
    
}