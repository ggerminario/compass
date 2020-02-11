/**
 * @File Name          : OCSRecuperaAzioniCANResponse.cls
 * @Description        : 
 * @Author             : Nicola Musicco
 * @Group              : 
 * @Last Modified By   : Nicola Musicco
 * @Last Modified On   : 10/1/2020, 14:25:40
 * @Modification Log   : 
 * Ver       Date            Author      		    Modification
 * 1.0    23/12/2019   Nicola Musicco     Initial Version
**/
public with sharing class OCSRecuperaAzioniCANResponse extends OCSResponse{
    

	@AuraEnabled
	public RecuperaAzioniCANResponseDTO recuperaAzioniCANResponse { get; set; }

    public OCSRecuperaAzioniCANResponse(){

        recuperaAzioniCANResponse=new RecuperaAzioniCANResponseDTO();
    }
	

    public class RecuperaAzioniCANResponseDTO {
		@AuraEnabled public List<AzioniCANDTO> elencoAzioni;
		@AuraEnabled public String as400Status;
		@AuraEnabled public String as400Errore;
		@AuraEnabled public String statoRicercaAzioniCAN;
	}

	public class AzioniCANDTO {
		@AuraEnabled public String codCampagna { get; set; }
		@AuraEnabled public String stato { get; set; }
		@AuraEnabled public String dataAcquisto { get; set; }
        @AuraEnabled public String blocco { get; set; }
        @AuraEnabled public String operazione { get; set; }
        @AuraEnabled public String progressivo { get; set; }

	}
}