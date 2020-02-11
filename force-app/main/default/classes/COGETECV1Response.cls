//----------------------------------------------------------------------
//-- - Author       : SANA BADJI
//-- - Date         : 12/07/2019
//-- - Description  : Handle WS_COGETECV1Response
//----------------------------------------------------------------------
public  class COGETECV1Response extends OCSAPIResponse{
    @AuraEnabled
    public COGETECV1ResponseDTO cogetecv1Response {get;set;}
     @AuraEnabled
    public MFTCOECO mftcoECO {get;set;}
     @AuraEnabled
    public MSFERR_ERRORIV1 mfterrOMSFERROCCURSV1 {get;set;}
    
    public COGETECV1Response() {
        this.cogetecv1Response=new COGETECV1ResponseDTO();
        this.mftcoECO=new MFTCOECO();
        this.mfterrOMSFERROCCURSV1=new MSFERR_ERRORIV1();
        this.cogetecv1Response.mftcoeco_OCCURS=new List<MFTCOECO>();
        this.cogetecv1Response.mfterr_OMSFERR_OCCURS=new  List<MSFERR_ERRORIV1>();
        this.mftcoECO.mftcoeco_ELEMENTO=new List<MFTCOECO_ELEMENTO>();

    }
    public class COGETECV1ResponseDTO{
        @AuraEnabled  public String msfologon_STATUS;
        @AuraEnabled  public String msfologon_SESSION_ID;
        @AuraEnabled  public String msfologon_ERRORE;
        @AuraEnabled  public String msfologon_ERRORE_DES;
        @AuraEnabled public List<MSFERR_ERRORIV1> mfterr_OMSFERR_OCCURS {get;set;}
        @AuraEnabled public List<MFTCOECO>  mftcoeco_OCCURS{get;set;}

    }
    public class MSFERR_ERRORIV1{
        @AuraEnabled public String msferr_N_RECORD;
        @AuraEnabled public String msferr_TIPO;
        @AuraEnabled public String msferr_CODICE;
        @AuraEnabled public String msferr_DESCRIZIONE;
        @AuraEnabled public String msferr_N_CAMPO;
        @AuraEnabled public String msferr_COD_MSG;
    }
    public class MFTCOECO{
        public List<MFTCOECO_ELEMENTO> mftcoeco_ELEMENTO {get;set;}
        
    }
    public class MFTCOECO_ELEMENTO{
       @AuraEnabled  public Integer mftcoeco_PARTITA;
       @AuraEnabled  public String mftcoeco_PARTITA_TIPO;
       @AuraEnabled  public String mftcoeco_IMPORTO;
      @AuraEnabled   public String mftcoeco_IMPORTO_S;
       @AuraEnabled  public String mftcoeco_NUMERO_RATA;
       @AuraEnabled  public String mftcoeco_DATA_SCADENZA;
       @AuraEnabled  public Integer mftcoeco_MORA_MATURATA;
       @AuraEnabled  public Integer mftcoeco_SALDO;
        @AuraEnabled public String mftcoeco_SALDO_S;
    }
}