public with sharing class CSEInterrogazioneSaldoLightInvoker {

	// #########
	// REQUEST DTO
	// #########

	public class Request extends OCSRequest {

		public CSEInterrogazioneSaldoLightRequestDTO cseInterrogazioneSaldoLightRequest { get; set; }

		public Request() {
			serviceId = 'cseInterrogazioneSaldoLight';
			cseInterrogazioneSaldoLightRequest = new CSEInterrogazioneSaldoLightRequestDTO();
		}

	}


	public class CSEInterrogazioneSaldoLightRequestDTO {
		public String contrattohb { get; set; }
		public String fldispo { get; set; }

	}


	// #########
	// RESPONSE DTO
	// #########


	public class Response extends OCSResponse {

		@AuraEnabled
		public CSEInterrogazioneSaldoLightResponseDTO cseInterrogazioneSaldoLightResponse { get; set; }

	}

	public class CSEInterrogazioneSaldoLightResponseDTO {
		@AuraEnabled public String saldo { get; set; }
		@AuraEnabled public String disponibilita { get; set; }
	}


	// #########
	// INVOKER
	// #########


	public static Response invoke(String contrattohb) {
		Request req = buildReq(contrattohb, 'S');
		return  (Response) ApiUtils.callApi('cse.interrogazioneSaldoLight', req, Response.class, 'C');
	}

	private static Request buildReq(String contrattohb, String fldispo) {
		Request req = new Request();
		CSEInterrogazioneSaldoLightRequestDTO saldoLight = new CSEInterrogazioneSaldoLightRequestDTO();
		saldoLight.contrattohb = contrattohb;
		saldoLight.fldispo = fldispo;
		req.cseInterrogazioneSaldoLightRequest = saldoLight;
		return req;
	}

}