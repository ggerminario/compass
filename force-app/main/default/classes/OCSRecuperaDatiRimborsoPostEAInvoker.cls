/**
 * @File Name          : OCSRecuperaDatiRimborsoPostEAInvoker.cls
 * @Description        : 
 * @Author             : Marco Cutolo
 * @Group              : 
 * @Last Modified By   : Raffaele Prudenzano
 * @Last Modified On   : 31/1/2020, 15:55:12
 * @Modification Log   : 
 * Ver       Date            Author      		    Modification
 * 1.0    11/12/2019   Marco Cutolo     Initial Version
**/
public class OCSRecuperaDatiRimborsoPostEAInvoker {
    
    //********************
    // REQUEST
    //********************
    public class Request extends OCSRequest {    
        public OCSRecuperaDatiRimborsoPostEARequestDTO recuperaDatiRimborsoPostEARequest {get; set;}
        public String authorization {get;set;}
        public Request() {
            serviceId = 'recuperaDatiRimborsoPostEA';
            authorization = null;
            recuperaDatiRimborsoPostEARequest = new OCSRecuperaDatiRimborsoPostEARequestDTO();
        }
    }

    public class OCSRecuperaDatiRimborsoPostEARequestDTO {
        public String numPratica {get; set;}
    }

    public class Response extends OCSResponse {
        @AuraEnabled
        public RecuperaDatiRimborsoPostEAResponseDTO recuperaDatiRimborsoPostEAResponse {get; set;} 
        
        public override boolean isOK() {           
            return super.isOK();
        }     
        public override string getMessage() {
            return super.getMessage();
        }    
        
    }

    public class RecuperaDatiRimborsoPostEAResponseDTO {   
        @AuraEnabled public DatiRimborsoPostEADTO datiRimborsoPostEADTO{get;set;}
        @AuraEnabled public List<PacchettoServizioDTO> elencoPacchettiServizi{get;set;}
        @AuraEnabled public List<PianoAmmortamentoEADTO> elencoPianoAmmortamento{get;set;}
    }

    public class DatiRimborsoPostEADTO{
        @AuraEnabled public String tipoPratica{get;set;}
        @AuraEnabled public String numPratica{get;set;}
        @AuraEnabled public String codCliente{get;set;}
        @AuraEnabled public String statoPratica{get;set;}
        @AuraEnabled public String attributoPratica{get;set;}
        @AuraEnabled public String dataDecorrenza{get;set;}
        @AuraEnabled public String dataCaricamento{get;set;}
        @AuraEnabled public String dataPrimaScadenza{get;set;}
        @AuraEnabled public String dataUltimaScadenza{get;set;}
        @AuraEnabled public String dataEstinzione{get;set;}
        @AuraEnabled public String dataChiusura{get;set;}
        @AuraEnabled public String dataAccettazione{get;set;}
        @AuraEnabled public String numRate{get;set;}
    }

    public class PacchettoServizioDTO{
        @AuraEnabled public String codServizio{get;set;}
        @AuraEnabled public String codPacchetto{get;set;}
        @AuraEnabled public String codFornitore{get;set;}
        @AuraEnabled public String dataInizioCopertura{get;set;}
        @AuraEnabled public String dataFineCopertura{get;set;}
        @AuraEnabled public String assicurazioneAttivaFinanziata{get;set;}
        @AuraEnabled public String durata{get;set;}
        @AuraEnabled public String desFornitore{get;set{
            if(codServizio != null){
                desFornitore = getDesFornitore(codServizio);
            }
        }}
       
        
        @AuraEnabled public String dataFineCoperturaSlashed {get{
        if(dataFineCopertura == null || dataFineCopertura.length() < 6) return null;
            String res = '';   
            if(!String.isBlank(dataFineCopertura) && !'0'.equalsIgnoreCase(dataFineCopertura)){
                res += dataFineCopertura.subString(6) + '/';
                res += dataFineCopertura.subString(4, 6) + '/';
                res += dataFineCopertura.subString(0, 4);
            }
            return res;
        } set;}

        @AuraEnabled public String dataInizioCoperturaSlashed {get{
        if(dataInizioCopertura == null || dataInizioCopertura.length() < 6) return null;
            String res = '';   
            if(!String.isBlank(dataInizioCopertura) && !'0'.equalsIgnoreCase(dataInizioCopertura)){
                res += dataInizioCopertura.subString(6) + '/';
                res += dataInizioCopertura.subString(4, 6) + '/';
                res += dataInizioCopertura.subString(0, 4);
            }
            return res;
        } set;}
    }

    public class PianoAmmortamentoEADTO{
        @AuraEnabled public String ratePreammortamento{get;set;}
        @AuraEnabled public String numRata{get;set;}
        @AuraEnabled public String dataScadenzaRata{get;set;}
    }

    public static Response invoke (OCSRecuperaDatiRimborsoPostEARequestDTO objectIn){
        Request req = new Request();		
        req.recuperaDatiRimborsoPostEARequest = objectIn; 
        return 	(Response)ApiUtils.callApi ('ocs.'+req.serviceId,req, Response.class, 'C');
    }

    public static Response invoke (String numPratica) {
        OCSRecuperaDatiRimborsoPostEARequestDTO objectIn = new OCSRecuperaDatiRimborsoPostEARequestDTO();
        objectIn.numPratica = numPratica;
        return 	invoke(objectIn);
    }

    public static String getDesFornitore (String codiceServizio){
        String denominazione = [SELECT Company_Name__c FROM servizi_assicurativi__mdt WHERE Label=:codiceServizio].Company_Name__c;
        //System.debug('denominazione fornitore: ' + denominazione);
        return denominazione;
    }

}