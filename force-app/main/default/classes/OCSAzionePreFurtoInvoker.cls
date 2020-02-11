public with sharing class OCSAzionePreFurtoInvoker {
    //********************
	// REQUEST
	//********************

	public class Request extends OCSRequest {

		public AzionePreFurtoFurtoRequestDTO azionePreFurtoFurtoRequest { get; set; }

		public Request(AzionePreFurtoFurtoRequestDTO azionePreFurtoFurtoRequestDTO) {
			this.serviceId = 'azionePreFurtoFurto';
			this.azionePreFurtoFurtoRequest = azionePreFurtoFurtoRequestDTO;
		}
	}

	public class AzionePreFurtoFurtoRequestDTO {
		public String provenienza { get; set; }
        public String tipoIntermediario { get; set; }
        public String intermediario { get; set; }
        public String numCarta { get; set; }
        public String operazione { get; set; }
        public String modEmissione { get; set; }
        public String dataValidita { get; set; }
        public String mesiValidita { get; set; }
        public String importoCommissioni { get; set; }
        public String addebitoCommissioni { get; set; }
        public String utente { get; set; }
	}

    //********************
    // RESPONSE DTO
    //********************

	public class Response extends OCSResponse {
		@AuraEnabled
		public AzionePreFurtoFurtoResponseDTO azionePreFurtoFurtoResponse {get; set;}
        		
	}
	
    public class AzionePreFurtoFurtoResponseDTO {        	
      @AuraEnabled public String AS400Status{get;set;}
      @AuraEnabled public String AS400Errore{get;set;}
      @AuraEnabled public String panNuovo{get;set;}
    }

    //********************
	// INVOKER
	//********************

	public static Response invoke(AzionePreFurtoFurtoRequestDTO AzionePreFurtoFurtoRequestDTO) {
		Request request = new Request(AzionePreFurtoFurtoRequestDTO);
		return (Response) ApiUtils.callApi ('ocs.' + request.serviceId, request, Response.class, 'C');
	}
}