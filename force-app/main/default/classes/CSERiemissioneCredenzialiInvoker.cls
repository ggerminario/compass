/**
 * @File Name          : CSERiemissioneCredenzialiInvoker.cls
 * @Description        :
 * @Author             : Raffaele Prudenzano
 * @Group              :
 * @Last Modified By   : Raffaele Prudenzano
 * @Last Modified On   : 17/12/2019, 16:08:16
 * @Modification Log   :
 * Ver       Date            Author                  Modification
 * 1.0    17/12/2019   Raffaele Prudenzano     Initial Version
 **/
public with sharing class CSERiemissioneCredenzialiInvoker {
	/*
	 * REQUEST
	 */

	public class Request extends OCSRequest {

		public CSERiemissioneCredenzialiRequestDTO cseRiemissioneCredenzialiRequest { get; set; }

		public Request() {
			serviceId = 'cseRiemissioneCredenziali';
			cseRiemissioneCredenzialiRequest = new CSERiemissioneCredenzialiRequestDTO();
		}

	}

	public class CSERiemissioneCredenzialiRequestDTO {
		public String contrattohb { get; set; }
		public String mezzo { get; set; }
		public String recapito { get; set; }
		public String tipoBusta { get; set; }
	}

	/*
	 * RESPONSE
	 */

	public class Response extends OCSResponse {
		@AuraEnabled
		public CSERiemissioneCredenzialiResponseDTO cseRiemissioneCredenzialiResponse { get; set; }
	}

	public class CSERiemissioneCredenzialiResponseDTO {
		@AuraEnabled public String esito { get; set; }
		@AuraEnabled public String messaggio { get; set; }
	}

	/*
	 * INVOKER
	 */

	public static Response invoke(CSERiemissioneCredenzialiRequestDTO objectIn) {
		Request req = new Request();
		req.cseRiemissioneCredenzialiRequest = objectIn;

		return  (Response) ApiUtils.callApi('cse.riemissioneCredenziali', req, Response.class, 'C');
	}
}