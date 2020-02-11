/**
 * @File Name          : OCSRecuperaCampAttiveAttivabInvoker.cls
 * @Description        :
 * @Author             : Raffaele Prudenzano
 * @Group              :
 * @Last Modified By   : Raffaele Prudenzano
 * @Last Modified On   : 29/11/2019, 16:15:16
 * @Modification Log   :
 *==============================================================================
 * Ver         Date                     Author                    Modification
 *==============================================================================
 * 1.0    29/11/2019, 15:04:05  Raffaele Prudenzano     Initial Version
 **/

public with sharing class OCSRecuperaCampAttiveAttivabInvoker {

	// #########
	// REQUEST DTO
	// #########

	public class Request extends OCSRequest {

		public OCSRecuperaCampAttiveAttivabRequestDTO recuperaCampagneAttiveAttivabiliRequest { get; set; }

		public Request() {
			serviceId = 'recuperaCampagneAttiveAttivabili';
			recuperaCampagneAttiveAttivabiliRequest = new OCSRecuperaCampAttiveAttivabRequestDTO();
		}

	}


	public class OCSRecuperaCampAttiveAttivabRequestDTO {
		public String provenienza { get; set; }
		public String tipoIntermediario { get; set; }
		public String intermediario { get; set; }
		public String numPratica { get; set; }
		public String pan { get; set; }
		public String emettitore { get; set; }
		public String protocollo { get; set; }
		public String riga { get; set; }
		public String prodotto { get; set; }
		public String flagAttive { get; set; }
		public String flagAttivabili { get; set; }
		public String utente { get; set; }
	}


	// #########
	// RESPONSE DTO
	// #########

	public class Response extends OCSResponse {

		@AuraEnabled
		public RecuperaCampagneAttiveAttivabiliResponseDTO recuperaCampagneAttiveAttivabiliResponse { get; set; }

	}

	public class RecuperaCampagneAttiveAttivabiliResponseDTO {
		@AuraEnabled public RecuperaCampagneAttivabiliResponseDTO recuperaCampagneAttivabiliResponse { get; set; }
		@AuraEnabled public RecuperaCampagneAttiveResponseDTO recuperaCampagneAttiveResponse { get; set; }
	}

	public class RecuperaCampagneAttivabiliResponseDTO {
		@AuraEnabled public List<CampagnaAttivabileDTO> elencoCampagneAttivabli;
		@AuraEnabled public String as400Status;
		@AuraEnabled public String as400Errore;
		@AuraEnabled public String statoRicercaCampagneAttivabili;
	}

	public class CampagnaAttivabileDTO {
		@AuraEnabled public String codCampagna;
		@AuraEnabled public String tipologia;
		@AuraEnabled public String mesiDilazione;
		@AuraEnabled public String numRate;
		@AuraEnabled public String tanCliente;
		@AuraEnabled public String dataInizioAutorizzazione;
		@AuraEnabled public String dataFineAutorizzazione;
		@AuraEnabled public String dataValidita;
		@AuraEnabled public String dataScadenza;
		@AuraEnabled public String descrizione;
	}

	public class RecuperaCampagneAttiveResponseDTO {
		@AuraEnabled public List<CampagnaAttivaDTO> elencoCampagneAttive;
		@AuraEnabled public String as400Status;
		@AuraEnabled public String as400Errore;
	}

	public class CampagnaAttivaDTO {
		@AuraEnabled public String emettitore;
		@AuraEnabled public String protocollo;
		@AuraEnabled public String riga;
		@AuraEnabled public String dareAvere;
		@AuraEnabled public String importoInizialeCampagna;
		@AuraEnabled public String numRate;
		@AuraEnabled public String debitoResiduo;
		@AuraEnabled public String capitaleResiduo;
		@AuraEnabled public String numRateResidue;
		@AuraEnabled public String dataScadenzaCampagna;
	}

	// #########
	// INVOKER
	// #########

	public static Response invoke(OCSRecuperaCampAttiveAttivabRequestDTO input) {
	    Request req = buildReq(input);
	    return  (Response) ApiUtils.callApi('ocs.recuperaCampagneAttiveAttivabili', req, Response.class, 'C');
	}

	private static Request buildReq(OCSRecuperaCampAttiveAttivabRequestDTO input) {
		Request req = new Request();
		req.recuperaCampagneAttiveAttivabiliRequest = input;
		return req;
	}
}