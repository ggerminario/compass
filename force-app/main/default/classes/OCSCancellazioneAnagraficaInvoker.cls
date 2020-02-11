/**
 * @File Name          : OCSCancellazioneAnagraficaInvoker.cls
 * @Description        : 
 * @Author             : Adriana Lattanzi
 * @Group              : 
 * @Last Modified By   : Adriana Lattanzi
 * @Last Modified On   : 10/1/2020, 10:43:54
 * @Modification Log   : 
 * Ver       Date            Author      		    Modification
 * 1.0    10/1/2020   Adriana Lattanzi     Initial Version
**/
public with sharing class OCSCancellazioneAnagraficaInvoker {

	// #########
	// REQUEST DTO
	// #########

	public class Request extends OCSRequest {

		public CancellazioneAnagraficaRequestDTO cancellazioneAnagraficaRequest { get; set; }

		public Request() {
			serviceId = 'cancellazioneAnagrafica';
			cancellazioneAnagraficaRequest = new CancellazioneAnagraficaRequestDTO();
		}

	}


	public class CancellazioneAnagraficaRequestDTO {
		public String codCliente { get; set; }
		public String tipoEsecuzione { get; set; }
	}


    // #########
	// RESPONSE DTO
	// #########

	public class Response extends OCSResponse {

        @AuraEnabled public Integer resultCode {get;set;}
        @AuraEnabled public String resultMessage {get;set;}
		@AuraEnabled
		public CancellazioneAnagraficaResponseDTO cancellazioneAnagraficaResponse { get; set; }

	}

	public class CancellazioneAnagraficaResponseDTO {
		@AuraEnabled public String as400Status { get; set; }
		@AuraEnabled public String as400Errore { get; set; }
	}


    // #########
	// INVOKER
	// #########

	public static Response invoke(CancellazioneAnagraficaRequestDTO input) {
	    Request req = buildReq(input);
	    return  (Response) ApiUtils.callApi('ocs.cancellazioneAnagrafica', req, Response.class, 'C');
	}

	public static Request buildReq(CancellazioneAnagraficaRequestDTO input) {
		Request req = new Request();
		req.cancellazioneAnagraficaRequest = input;
		return req;
	}

}