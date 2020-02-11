/**
 * @File Name          : GestioneIVRTrovaRichiesteOnline.cls
 * @Description        : 
 * @Author             : Federico Negro
 * @Group              : 
 * @Last Modified By   : Federico Negro
 * @Last Modified On   : 4/12/2019, 17:06:53
 * @Modification Log   : 
 * Ver       Date            Author      		    Modification
 * 1.0    4/12/2019   Federico Negro     Initial Version
**/
@RestResource(urlMapping='/ivr_trovaRichiesteOnline/*')
global with sharing class GestioneIVRTrovaRichiesteOnline {

    private final static String CATEG_RICHIESTE_ONLINE = '1324';

    global class TrovaRichiesteOnlineRequest {

        global String CaseNumber;
        
        public TrovaRichiesteOnlineRequest(String CaseNumber){
            this.CaseNumber = CaseNumber;
        }
       
    }

    private static Boolean isValidRequest(TrovaRichiesteOnlineRequest request) {
        if (request==null) {
            return false;
        }
        if (request.CaseNumber==null || String.isBlank(request.CaseNumber)) {
            return false;
        }
        return true;
    }


    // recupero codice cliente (codice OCS) con chiamata al WS OCS_RecuperaDatiPostVendita
    private static List<Case> getCaseNumber(TrovaRichiesteOnlineRequest request) {
        Case [] listaCase = [SELECT CaseNumber FROM Case WHERE CaseNumber =: request.CaseNumber AND CategoriaExternalId__c =: CATEG_RICHIESTE_ONLINE];
        return listaCase; 
    }


    global class TrovaRichiesteOnlineResponse {
        global Integer esito = 0; 
    }

    @HttpPost 
    global static void doPost(String CaseNumber) {
        TrovaRichiesteOnlineResponse response = checkReqOnline(CaseNumber);
        ApiUtils.serializeResponse(RestContext.response,RestContext.request,response);
    }


    private static TrovaRichiesteOnlineResponse checkReqOnline(String CaseNumber) {

        TrovaRichiesteOnlineRequest request = new TrovaRichiesteOnlineRequest(CaseNumber);
        TrovaRichiesteOnlineResponse response = new TrovaRichiesteOnlineResponse();

        System.debug('Trova Richieste Online start');

        if (!isValidRequest(request)) {
            response.esito = 0;
        }
        
        List<Case> listaCase = getCaseNumber(request);
        
        if (listaCase.size() > 0  && listaCase != null){
            response.esito = 1;
        } else {
            response.esito = 0;
        }
        
        return response;
    }

}