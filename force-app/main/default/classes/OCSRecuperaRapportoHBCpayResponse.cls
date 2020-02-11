public class OCSRecuperaRapportoHBCpayResponse extends OCSResponse{

    @AuraEnabled
    public RecuperaRapportoHBCpayResponseDTO recuperaRapportoHBCpayResponse {get;set;}

    public OCSRecuperaRapportoHBCpayResponse() {
        recuperaRapportoHBCpayResponse = new RecuperaRapportoHBCpayResponseDTO(); 
    }
    
    public class RecuperaRapportoHBCpayResponseDTO  {        
        @AuraEnabled public String rapportoHB {get;set;}
        @AuraEnabled public String isDipendente {get;set;}
    }

}