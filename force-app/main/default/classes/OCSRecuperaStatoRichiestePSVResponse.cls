/**
 * @File Name          : OCSRecuperaStatoRichiestePSVResponse.cls
 * @Description        : 
 * @Author             : Federico Negro
 * @Group              : 
 * @Last Modified By   : Federico Negro
 * @Last Modified On   : 18/11/2019, 17:59:20
 * @Modification Log   : 
 * Ver       Date            Author      		    Modification
 * 1.0    18/11/2019   Federico Negro     Initial Version
**/
public class OCSRecuperaStatoRichiestePSVResponse extends OCSResponse
{
    @AuraEnabled
    public recuperaStatoRichiestePSVResponseClass recuperaStatoRichiestePSVResponse{get;set;}
    
    public OCSRecuperaStatoRichiestePSVResponse(){ 
        recuperaStatoRichiestePSVResponse = new recuperaStatoRichiestePSVResponseClass();
    }
    
    public class recuperaStatoRichiestePSVResponseClass{
        @AuraEnabled
        public List<ResponseClass> elencoStatiRichieste;
    }
    
    public class ResponseClass{
        @AuraEnabled
        public String progressivo{get;set;}
        @AuraEnabled
        public String stato{get;set;}
        @AuraEnabled
        public String blocco{get;set;}
        @AuraEnabled
        public String dataAzione{get;set;}
        @AuraEnabled
        public String codAzione{get;set;}
    }
}