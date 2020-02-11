/**
 * @File Name          : GestioneIVRTrovaRichiesteOnlineTest.cls
 * @Description        : 
 * @Author             : Federico Negro
 * @Group              : 
 * @Last Modified By   : Federico Negro
 * @Last Modified On   : 4/12/2019, 11:08:44
 * @Modification Log   : 
 * Ver       Date            Author      		    Modification
 * 1.0    4/12/2019   Federico Negro     Initial Version
**/
@isTest (SeeAllData=true)
public with sharing class GestioneIVRTrovaRichiesteOnlineTest {

    private  static void setRestRequestResponse(GestioneIVRTrovaRichiesteOnline.TrovaRichiesteOnlineRequest request){

        String myJSON = JSON.serialize(request);
        RestRequest req = new RestRequest();
        req.requestUri ='https://localhost/services/apexrest/ivr_trovaRichiesteOnline';
        req.httpMethod = 'POST';
        req.addHeader('Content-Type', 'application/json'); 
        req.requestBody = Blob.valueOf(myJSON);
        RestContext.request = req;
        RestContext.response = new RestResponse();

    }

  	@isTest
    static void testTrovaReqOnline(){	        
            
        Test.startTest();
        GestioneIVRTrovaRichiesteOnline.TrovaRichiesteOnlineRequest request = new GestioneIVRTrovaRichiesteOnline.TrovaRichiesteOnlineRequest('00001283');
        setRestRequestResponse(request);
        GestioneIVRTrovaRichiesteOnline.doPost('00001283');	  
        Test.stopTest();   
        String body =RestContext.response.responseBody.toString();
        System.debug(body);
        System.assertEquals('1',body); // incident presente
        
    
    }	             

}