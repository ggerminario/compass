/**
 * @File Name          : OCSRimozioneAttesaAttivazioneInvoker.cls
 * @Description        :
 * @Author             : Raffaele Prudenzano
 * @Group              :
 * @Last Modified By   : Raffaele Prudenzano
 * @Last Modified On   : 29/11/2019, 16:18:07
 * @Modification Log   :
 *==============================================================================
 * Ver         Date                     Author                    Modification
 *==============================================================================
 * 1.0    29/11/2019, 16:18:07  Raffaele Prudenzano     Initial Version
 **/

public with sharing class OCSRimozioneAttesaAttivazioneInvoker {

	// #########
	// REQUEST DTO
	// #########

	public class Request extends OCSRequest {

		public RimozioneAttesaAttivazioneRequestDTO rimozioneAttesaAttivazioneRequest { get; set; }

		public Request() {
			serviceId = 'rimozioneAttesaAttivazione';
			rimozioneAttesaAttivazioneRequest = new RimozioneAttesaAttivazioneRequestDTO();
		}

	}


	public class RimozioneAttesaAttivazioneRequestDTO {
		public String provenienza { get; set; }
		public String tipoIntermediario { get; set; }
		public String intermediario { get; set; }
		public String numCarta { get; set; }
		public String pan { get; set; }
		public String operatoreTel {get; set;}
        public String dataNascita {get; set;}
        public String codiceRifExt2 {get; set;}
        public String utente {get; set;}
	}


    // #########
	// RESPONSE DTO
	// #########

	public class Response extends OCSResponse {

		@AuraEnabled
		public RimozioneAttesaAttivazioneResponseDTO rimozioneAttesaAttivazioneResponse { get; set; }

	}

	public class RimozioneAttesaAttivazioneResponseDTO {
		@AuraEnabled public String AS400Status { get; set; }
		@AuraEnabled public String AS400Errore { get; set; }
	}


    // #########
	// INVOKER
	// #########

	public static Response invoke(RimozioneAttesaAttivazioneRequestDTO input) {
	    Request req = buildReq(input);
	    return  (Response) ApiUtils.callApi('ocs.rimozioneAttesaAttivazione', req, Response.class, 'C');
	}

	public static Request buildReq(RimozioneAttesaAttivazioneRequestDTO input) {
		Request req = new Request();
		req.rimozioneAttesaAttivazioneRequest = input;
		return req;
	}

}