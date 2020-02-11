//----------------------------------------------------------------------
//-- - Author       : SANA BADJI
//-- - Date         : 12/07/2019
//-- - Description  : Handle WS_COGETECV1Request
//----------------------------------------------------------------------
public  class COGETECV1Request extends OCSAPIRequest{

    public   COGETECV1RequestDTO  cogetecv1Request  {get;set;}

    public COGETECV1Request() {
        this.serviceId='OCS_COGETEC_V1';
        this.cogetecv1Request=new COGETECV1RequestDTO();
    }
    
    public class COGETECV1RequestDTO {
        public  String mftcoeci_NUM_PRATICA {get;set;}
        public  String msfilogon_UTENTE_OVR {get;set;}
        public  String msfilogon_RIF_SIC_OVR {get;set;}
        public  String msfilogon_UTENTE_AS400 {get;set;}
        public  String msfilogon_COD_INT_FILIALE {get;set;}
        public  String msfilogon_CREA_UTENTE_COLL {get;set;}
        public  String msfilogon_POSTAZIONE {get;set;}
        public  String mftcoeci_PROGRESSIVO {get;set;}
        public  String mftcoeci_DATA_SITUAZIONE {get;set;}
        public  String mftcoeci_SELEZ_SCAD {get;set;}
        public  String mftcoeci_SELEZ_SALDO {get;set;}
        public  String mftcoeci_NUM_ELEMENTI {get;set;}
        public  String msflogon_TMP_KEY {get;set;}
        public  String msfilogon_SENDER_TIPO {get;set;}
        public  Integer msfilogon_SENDER_CODICE {get;set;}
        public  String msfilogon_CANALE_ACQUISIZ {get;set;}
        public  String msfilogon_TIPO_CARICAMENTO {get;set;}
    }
}