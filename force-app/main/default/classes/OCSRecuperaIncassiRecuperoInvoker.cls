/**
 * @File Name          : OCSRecuperaIncassiRecuperoInvoker.cls
 * @Description        : 
 * @Author             : Federico Negro
 * @Group              : 
 * @Last Modified By   : Federico Negro
 * @Last Modified On   : 3/1/2020, 13:42:52
 * @Modification Log   : 
 * Ver       Date            Author      		    Modification
 * 1.0    23/12/2019   Federico Negro     Initial Version
**/
public with sharing class OCSRecuperaIncassiRecuperoInvoker {
    
    //********************
    // REQUEST
    //********************
	public class Request extends OCSRequest {

		@AuraEnabled public RecuperaIncassiRecuperoRequestDTO recuperaIncassiRecuperoRequestDTO {get; set;}

		public Request() {
			serviceId = 'recuperaIncassiRecupero';
            recuperaIncassiRecuperoRequestDTO = new RecuperaIncassiRecuperoRequestDTO();
		}

	}

	public class RecuperaIncassiRecuperoRequestDTO {
		@AuraEnabled public String numPratica {get; set;}
		@AuraEnabled public String tipoPratica {get; set;}
    } 
	
	
    //********************
    // RESPONSE
    //********************

	public class Response extends OCSResponse {

		@AuraEnabled public RecuperaIncassiRecuperoResponseDTO recuperaIncassiRecuperoDTO {get; set;}

		/*public Response() {
			recuperaIncassiRecuperoDTO = new RecuperaIncassiRecuperoResponseDTO();
		}*/

		public override boolean isOK() {    
			return super.isOK() && recuperaIncassiRecuperoDTO.AS400Status.equalsIgnoreCase('');
		}    

		public override string getMessage() {
			return super.getMessage().equalsIgnoreCase('success') ? recuperaIncassiRecuperoDTO.AS400Errore : super.getMessage();
		}  
	
	}

	public class RecuperaIncassiRecuperoResponseDTO{        	
		@AuraEnabled public String AS400Status{get;set;}
		@AuraEnabled public String AS400Errore{get;set;}   
		@AuraEnabled public IncassoDTO[] incassi{get;set;}
	}

	public class IncassoDTO {        	
		
		@AuraEnabled public String progressivo {get;set;}
		@AuraEnabled public String tipoPagamento {get;set;}
		@AuraEnabled public String importo {get;set;}
		@AuraEnabled public String dataValuta {get;set;}
		@AuraEnabled public String dataRegistrazione {get;set;}
		@AuraEnabled public String descrizione {get;set;}

	}
	

    //********************
    // INVOKER
    //********************

	public static Response invoke (RecuperaIncassiRecuperoRequestDTO objectIn){

		Request req = new Request();
		req.recuperaIncassiRecuperoRequestDTO = objectIn;

		return (Response)ApiUtils.callApi ('ocs.'+req.serviceId,req, Response.class, 'C' );
		
	}

}
    //**********************
    //   CHIAMATA PER TEST
    //**********************

/*

		OCSRecuperaIncassiRecuperoInvoker.Request req = new OCSRecuperaIncassiRecuperoInvoker.Request();

        req.recuperaIncassiRecuperoRequestDTO.numPratica='9102419539';
        req.recuperaIncassiRecuperoRequestDTO.tipoPratica='CA';
        
        OCSRecuperaIncassiRecuperoInvoker.Response res = OCSRecuperaIncassiRecuperoInvoker.invoke(req.recuperaIncassiRecuperoRequestDTO);
        
        System.debug('RISPOSTA = '+res);
*/