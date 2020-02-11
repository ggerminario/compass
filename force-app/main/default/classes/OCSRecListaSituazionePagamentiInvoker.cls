/**
 * @File Name          : RecuperoListaSituazionePagamentiInvoker.cls
 * @Description        : 
 * @Author             : Federico Negro
 * @Group              : 
 * @Last Modified By   : Federico Negro
 * @Last Modified On   : 3/1/2020, 17:11:43
 * @Modification Log   : 
 * Ver       Date            Author      		    Modification
 * 1.0    3/1/2020   Federico Negro     Initial Version
**/
public with sharing class OCSRecListaSituazionePagamentiInvoker {
	
    //********************
    // REQUEST
    //********************
	public class Request extends OCSRequest {

		@AuraEnabled public RecuperoListaSituazionePagamentiRequestDTO recuperoListaSituazionePagamentiRequest {get; set;}

		public Request() {
			serviceId = 'recuperoListaSituazionePagamenti';
            recuperoListaSituazionePagamentiRequest = new RecuperoListaSituazionePagamentiRequestDTO();
		}

	}

	public class RecuperoListaSituazionePagamentiRequestDTO {
		@AuraEnabled public String numPratica {get; set;}
		@AuraEnabled public String tipoPratica {get; set;}
    } 
	
	
    //********************
    // RESPONSE
    //********************

	public class Response extends OCSResponse {

		@AuraEnabled public RecuperoListaSituazionePagamentiResponseDTO recuperoListaSituazionePagamentiResponse {get; set;}

		/*public Response() {
			recuperaIncassiRecuperoDTO = new RecuperaIncassiRecuperoResponseDTO();
		}*/
	
	}

	public class RecuperoListaSituazionePagamentiResponseDTO{       
		@AuraEnabled public SituazionePagamentoDTO[] elencoSituazionePagamenti{get;set;}
	}

	public class SituazionePagamentoDTO {        	
		
		@AuraEnabled public String tipoPartita {get;set;}
		@AuraEnabled public String numeroRata {get;set;}
		@AuraEnabled public String dataScadenza {get;set;}
		@AuraEnabled public String importoAddebitato {get;set;}
		@AuraEnabled public String importoIncassato {get;set;}
		@AuraEnabled public String importoSaldo {get;set;}
		@AuraEnabled public String importoAltriMovimenti {get;set;}
		@AuraEnabled public String giorniRitardo {get;set;}
		@AuraEnabled public String interessiDiMora {get;set;}
		
	}
	

    //********************
    // INVOKER
    //********************

	public static Response invoke (RecuperoListaSituazionePagamentiRequestDTO objectIn){

		Request req = new Request();
		req.recuperoListaSituazionePagamentiRequest = objectIn;

		return (Response)ApiUtils.callApi ('ocs.'+req.serviceId,req, Response.class, 'C' );
		
	}

}
    //**********************
    //   CHIAMATA PER TEST
    //**********************

/*
		OCSRecListaSituazionePagamentiInvoker.Request req = new OCSRecListaSituazionePagamentiInvoker.Request();

        req.recuperoListaSituazionePagamentiRequest.numPratica='9102419539';
        req.recuperoListaSituazionePagamentiRequest.tipoPratica='CA';
        
        OCSRecListaSituazionePagamentiInvoker.Response res = OCSRecListaSituazionePagamentiInvoker.invoke(req.recuperoListaSituazionePagamentiRequest);
        
        System.debug('RISPOSTA = '+res);
*/