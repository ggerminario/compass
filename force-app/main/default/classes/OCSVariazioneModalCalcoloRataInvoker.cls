public class OCSVariazioneModalCalcoloRataInvoker {
    //********************
    // REQUEST
    //********************
    public class Request extends OCSRequest {
        
        public VariazioneModalCalcoloRataRequestDTO variazioneModalCalcoloRataRequest {get; set;}
        public String authorization {get;set;}
        public Request() {
            serviceId = 'variazioneModalCalcoloRata';
            authorization = null;
            variazioneModalCalcoloRataRequest = new VariazioneModalCalcoloRataRequestDTO();
        }
        
    }
    
    public class VariazioneModalCalcoloRataRequestDTO {      				
        public String intermediario {get; set;}
        public String provenienza {get; set;}
        public String tipoIntermediario {get; set;}
        public String procedura {get; set;}
        public String codiceRifExt {get; set;}
        public String azione {get; set;}
        public String modCalcRata {get; set;}
        public String numPratica {get; set;}
        public String utente{get;set;}
        public String pagMinImporto {get;set;}
        public String pagMinPerc {get;set;}
    }
    
    //********************
    // RESPONSE DTO
    //********************
    
    public class Response extends OCSResponse {
        @AuraEnabled
        public VariazioneModalCalcoloRataResponseDTO variazioneModalCalcoloRataResponse {get; set;} 
        
        public override boolean isOK() {           
            return super.isOK();
        }     
        
        
        public override string getMessage() {
            return super.getMessage().equalsIgnoreCase('success') ? variazioneModalCalcoloRataResponse.as400Errore : super.getMessage();
        }    
        
    }
    
    public class VariazioneModalCalcoloRataResponseDTO {        	
        @AuraEnabled public String as400Status{get;set;}
        @AuraEnabled public String as400Errore{get;set;}
    }
    
    
    
    
    //********************
    // INVOKER
    //********************
    
    public static Response invoke (VariazioneModalCalcoloRataRequestDTO objectIn){
        Request req = new Request();		
        req.variazioneModalCalcoloRataRequest = objectIn; 
        return 	(Response)ApiUtils.callApi ('ocs.'+req.serviceId,req, Response.class, 'C');
    }
}