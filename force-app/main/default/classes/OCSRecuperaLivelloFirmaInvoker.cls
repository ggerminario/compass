/**
 * @File Name          : OCSRecperaLivelloFirmaInvoker.cls
 * @Description        : 
 * @Author             : Fabio Giuliani
 * @Group              : 
 * @Last Modified By   : 
 * @Last Modified On   : 
 * @Modification Log   : 
 * Ver       Date            Author      		    Modification
 * 1.0    07/01/2020      Fabio Giuliani           Initial Version
**/
public class OCSRecuperaLivelloFirmaInvoker {

//********************
// REQUEST
//********************
	public class Request extends OCSRequest {
        

		public Request() {
			serviceId = 'genericRecuperaDati';

		}
        public Request(GenericRecuperaDatiRequestDTO dto){
			serviceId = 'genericRecuperaDati';
            this.genericRecuperaDatiRequestDTO=new List< GenericRecuperaDatiRequestDTO>();
            this.genericRecuperaDatiRequestDTO.add(dto);

        }
        public String nomeRichiesta = 'recuperaLivelloFirma';
        public List<GenericRecuperaDatiRequestDTO> genericRecuperaDatiRequestDTO{get; set;}

	}

	public class GenericRecuperaDatiRequestDTO {
		public String input_1 {get; set;}
		public String input_2 {get; set;}
		public String input_3 {get; set;}
		public String input_4 {get; set;}
		public String input_5 {get; set;}
	}


//********************
// RESPONSE DTO
//********************

	public class Response extends OCSResponse {
		@AuraEnabled
		public GenericRecuperaDatiResponseDTO genericRecuperaDatiResponse {get; set;}

		public Response() {
		}
	}

	public class GenericRecuperaDatiResponseDTO {
		// ritorno dal servizio
		@AuraEnabled public String out_1 {get; set;}
		@AuraEnabled public String out_2 {get; set;}
		@AuraEnabled public String out_3 {get; set;}
		@AuraEnabled public String out_4 {get; set;}
		@AuraEnabled public String out_5 {get; set;}
		@AuraEnabled public String out_6 {get; set;}
		@AuraEnabled public String out_7 {get; set;}
		@AuraEnabled public String out_8 {get; set;}
		@AuraEnabled public String out_9 {get; set;}
		@AuraEnabled public String out_10 {get; set;}
	}


//********************
// INVOKER
//********************

	public static Response invoke (GenericRecuperaDatiRequestDTO objectIn){

		Request req = new Request();
		req.genericRecuperaDatiRequestDTO = new List<GenericRecuperaDatiRequestDTO>();
        req.genericRecuperaDatiRequestDTO.add(objectIn);

		return (Response)ApiUtils.callApi ('ocs.'+req.serviceId,req, Response.class, 'C' );
        
	}

}