/**
 * @File Name          : CSEAnnulloBustaInvoker.cls
 * @Description        :
 * @Author             : Raffaele Prudenzano
 * @Group              :
 * @Last Modified By   : Raffaele Prudenzano
 * @Last Modified On   : 17/12/2019, 14:59:36
 * @Modification Log   :
 * Ver       Date            Author                  Modification
 * 1.0    17/12/2019   Raffaele Prudenzano     Initial Version
 **/
public with sharing class CSEAnnulloBustaInvoker {

	/*
	 * REQUEST
	 */

	public class Request extends OCSRequest {

		public CSEAnnulloBustaRequestDTO cseAnnulloBustaRequest { get; set; }

		public Request() {
			serviceId = 'cseAnnulloBusta';
			cseAnnulloBustaRequest = new CSEAnnulloBustaRequestDTO();
		}

	}

	public class CSEAnnulloBustaRequestDTO {
		public String contrattohb;
	}

	/*
	 * RESPONSE
	 */

	public class Response extends OCSResponse {
		@AuraEnabled
		public CSEAnnulloBustaResponseDTO cseAnnulloBustaResponse { get; set; }
	}

	public class CseAnnulloBustaResponseDTO {
		public string esito;
		public string messaggio;
	}

	/*
	 * INVOKER
	 */

	public static Response invoke(String contrattohb) {
		Request req1 = new Request();
		CSEAnnulloBustaRequestDTO req2 = new CSEAnnulloBustaRequestDTO();
		req2.contrattohb = contrattohb;
		req1.cseAnnulloBustaRequest = req2;

		return  (Response) ApiUtils.callApi('cse.annulloBusta', req1, Response.class, 'C');
	}
}