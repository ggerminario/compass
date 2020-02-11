/**
 * @File Name          : OCSRistampaCarnetBollettiniInvoker.cls
 * @Description        : 
 * @Author             : Matteo Gobbo
 * @Group              : 
 * @Last Modified By   : Matteo Gobbo
 * @Last Modified On   : 9/12/2019, 14:26:27
 * @Modification Log   : 
 * Ver       Date            Author      		    Modification
 * 1.0    9/12/2019   Matteo Gobbo     Initial Version
**/
public with sharing class OCSRistampaCarnetBollettiniInvoker {
   //********************
    // REQUEST
    //********************
    public class Request extends OCSRequest  {
        
        public RistampaCarnetBollettiniRequestDTO ristampaCarnetBollettiniRequest {get; set;}
        
        public Request() {
            serviceId = 'ristampaCarnetBollettini';
            ristampaCarnetBollettiniRequest = new RistampaCarnetBollettiniRequestDTO();
        }
        
    }
    
    public class RistampaCarnetBollettiniRequestDTO {      				
        public String numPratica{get;set;}  
        public String statoPrenotazione{get;set;}       
        public String tipoGenerazione{get;set;}                               
        public String numeroCCP{get;set;}                                     
        public String dataScadenza{get;set;}     //Da chiedere                                           
        public String flagUltimoInvio{get;set;}    //Da chiedere                          
    }
    
    //********************
    // RESPONSE DTO
    //********************
    
    public class Response extends OCSResponse {
        @AuraEnabled
        public RistampaCarnetBollettiniResponseDTO ristampaCarnetBollettiniResponse {get; set;} 
        
        public override boolean isOK() {           
            return super.isOK();
        }     
        
        
        public override string getMessage() {
            return super.getMessage().equalsIgnoreCase('success') ? ristampaCarnetBollettiniResponse.desErrore : super.getMessage();
        }    
        
    }
    
    public class RistampaCarnetBollettiniResponseDTO {   
        @AuraEnabled 
        public String dataElaborazione{get;set;}   	
        @AuraEnabled 
        public String oraElaborazione{get;set;}
        @AuraEnabled 
        public String utenteElaborazione{get;set;}   
        @AuraEnabled 
        public String flagErrore{get;set;}
        @AuraEnabled 
        public String desErrore{get;set;}
        @AuraEnabled 
        public String esito{get;set;}  
        @AuraEnabled 
        public String dataUltimoInvio{get;set;}
    }

    //********************
    // INVOKER
    //********************
    public static Response invoke (RistampaCarnetBollettiniRequestDTO objectIn){
        Request req = new Request();
        req.ristampaCarnetBollettiniRequest = objectIn;
        return (Response)ApiUtils.callApi ('ocs.'+req.serviceId,req, Response.class, 'C');
    }
    
    /*
    public static Response invoke (String  NumeroPratica){
        Request req = new Request();		
        req.ristampaCarnetBollettiniRequest.DataScadenza = formatDate(System.today());    //Da chiedere             
        req.ristampaCarnetBollettiniRequest.NumPratica  = NumeroPratica;                          
        req.ristampaCarnetBollettiniRequest.NumeroCCP = '001';                                 
        req.ristampaCarnetBollettiniRequest.StatoPrenotazione = 'T';                          
        req.ristampaCarnetBollettiniRequest.TipoGenerazione = 'RC';                         
        req.ristampaCarnetBollettiniRequest.FlagUltimoInvio = 'S'; //Da chiedere 
        return 	(Response)ApiUtils.callApi ('ocs.'+req.serviceId,req, Response.class, 'C');
    }
    */
	
}