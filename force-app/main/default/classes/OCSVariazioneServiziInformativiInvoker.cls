/**
 * @File Name          : OCSVariazioneServiziInformativiInvoker.cls
 * @Description        :
 * @Author             : Raffaele Prudenzano
 * @Group              :
 * @Last Modified By   : Raffaele Prudenzano
 * @Last Modified On   : 29/11/2019, 17:27:33
 * @Modification Log   :
 *==============================================================================
 * Ver         Date                     Author                    Modification
 *==============================================================================
 * 1.0    29/11/2019, 17:27:33  Raffaele Prudenzano     Initial Version
 **/
public with sharing class OCSVariazioneServiziInformativiInvoker {
   
   // #########
	// REQUEST DTO
	// #########

	public class Request extends OCSRequest {

		public VariazioneServiziInformativiRequestDTO variazioneServiziInformativiRequest { get; set; }

		public Request() {
			serviceId = 'variazioneServiziInformativi';
			variazioneServiziInformativiRequest = new VariazioneServiziInformativiRequestDTO();
		}

	}


	public class VariazioneServiziInformativiRequestDTO {
		public String provenienza { get; set; }
		public String tipoIntermediario { get; set; }
		public String intermediario { get; set; }
        public String procedura { get; set; }
		public String numPratica { get; set; }
        public String servSoglia { get; set; }
        public String impServSoglia { get; set; }
        public String servSaldo { get; set; }
        public String servAggEc { get; set; }
        public String freqServSaldo { get; set; }
        public String servAcqSaldoCm { get; set; }
        public String servInfo { get; set; }
        public String pind { get; set; }
        public String avvisoAut { get; set; }
        public String impSogliaAut { get; set; }
        public String avvisoAutTot { get; set; }
        public String impSogliaAutTot { get; set; }
        public String variazProxRata { get; set; }
        public String cellulare { get; set; }
        public String email { get; set; }
        public String operatoreTel { get; set; }
        public String attesaAttivaz { get; set; }
        public String protCampServ { get; set; }
        public String bloccoServ { get; set; }
        public String presSogliaAut { get; set; }
        public String risPrincServ { get; set; }
        public String codiceRifExt { get; set; }
        public String codiceRifExt2 { get; set; }
        public String utente { get; set; }
		
	}


    // #########
	// RESPONSE DTO
	// #########

	public class Response extends OCSResponse {

		@AuraEnabled
		public VariazioneServiziInformativiResponseDTO variazioneServiziInformativiResponse { get; set; }

	}

	public class VariazioneServiziInformativiResponseDTO {
		@AuraEnabled public String AS400Status { get; set; }
		@AuraEnabled public String AS400Errore { get; set; }
	}

    // #########
	// INVOKER
	// #########

	public static Response invoke(VariazioneServiziInformativiRequestDTO input) {
	    Request req = buildReq(input);
	    return  (Response) ApiUtils.callApi('ocs.variazioneServiziInformativi', req, Response.class, 'C');
	}

	public static Request buildReq(VariazioneServiziInformativiRequestDTO input) {
		Request req = new Request();
		req.variazioneServiziInformativiRequest = input;
		return req;
	}
}