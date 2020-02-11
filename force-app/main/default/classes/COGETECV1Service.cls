//----------------------------------------------------------------------
//-- - Author       : SANA BADJI
//-- - Date         : 12/07/2019
//-- - Description  : Handle WS_COGETECV1Service
//----------------------------------------------------------------------
public  class COGETECV1Service {
    public static Boolean hasError = false;
    public static List<ValidationError> errors = new List<ValidationError>();
    public static COGETECV1Response invoke(COGETECV1Request req){
        return (COGETECV1Response) OCSApiUtils.callApi('OCS_COGETEC_V1',
                                                                                req,
                                                                                COGETECV1Response.class,'C');
    }

    public static COGETECV1Response buildCOGETECV1Response (
                                                    String mftcoeciNUMPRATICA,
                                                    String  msfilogonUTENTEOVR,
                                                    String msfilogonRIFSICOVR,
                                                    String msfilogonUTENTEAS400,
                                                    String msfilogonCODINTFILIALE,
                                                    String msfilogonCREAUTENTECOLL,
                                                    String msfilogonPOSTAZIONE, 
                                                    String mftcoeciPROGRESSIVO,
                                                    String mftcoeciDATASITUAZIONE,
                                                    String mftcoeciSELEZSCAD,
                                                    String mftcoeciSELEZSALDO,
                                                    String mftcoeciNUMELEMENTI,
                                                    String msflogonTMPKEY,
                                                    String msfilogonSENDERTIPO,
                                                    Integer msfilogonSENDERCODICE,
                                                    String msfilogonCANALEACQUISIZ,
                                                    String msfilogonTIPOCARICAMENTO){
        COGETECV1Response response;
        COGETECV1Request request = new COGETECV1Request();
      /*  COGETECV1Request.COGETECV1RequestDTO obj = new  COGETECV1Request.COGETECV1RequestDTO ();
         request.cogetecv1Request = obj;*/
        request.cogetecv1Request.mftcoeci_NUM_PRATICA = mftcoeciNUMPRATICA;
        request.cogetecv1Request.msfilogon_UTENTE_OVR = msfilogonUTENTEOVR;
        request.cogetecv1Request.msfilogon_RIF_SIC_OVR = msfilogonRIFSICOVR;
        request.cogetecv1Request.msfilogon_UTENTE_AS400 = msfilogonUTENTEAS400;
        request.cogetecv1Request.msfilogon_COD_INT_FILIALE = msfilogonCODINTFILIALE;
        request.cogetecv1Request.msfilogon_CREA_UTENTE_COLL = msfilogonCREAUTENTECOLL;
        request.cogetecv1Request.msfilogon_POSTAZIONE = msfilogonPOSTAZIONE;
        request.cogetecv1Request.mftcoeci_PROGRESSIVO = mftcoeciPROGRESSIVO;
        request.cogetecv1Request.mftcoeci_DATA_SITUAZIONE = mftcoeciDATASITUAZIONE;
        request.cogetecv1Request.mftcoeci_SELEZ_SCAD = mftcoeciSELEZSCAD;
        request.cogetecv1Request.mftcoeci_SELEZ_SALDO = mftcoeciSELEZSALDO;
        request.cogetecv1Request.mftcoeci_NUM_ELEMENTI = mftcoeciNUMELEMENTI;
        request.cogetecv1Request.msflogon_TMP_KEY = msflogonTMPKEY;
        request.cogetecv1Request.msfilogon_SENDER_TIPO = msfilogonSENDERTIPO;
        request.cogetecv1Request.msfilogon_SENDER_CODICE = msfilogonSENDERCODICE;
        request.cogetecv1Request.msfilogon_CANALE_ACQUISIZ = msfilogonCANALEACQUISIZ;
        request.cogetecv1Request.msfilogon_TIPO_CARICAMENTO = msfilogonTIPOCARICAMENTO; 
        
        response = invoke(request);
    return response;
}
     public static COGETECV1Response buildCOGETECV1Response (String numPratica, String tmpKey,
                                                             String senderTipo, Integer senderCodice,
                                                             String tipoCaricamento, String canalAqusiz){
          COGETECV1Response response;
          COGETECV1Request request = new COGETECV1Request();
          request.cogetecv1Request.mftcoeci_NUM_PRATICA = numPratica;
          request.cogetecv1Request.msfilogon_SENDER_TIPO = senderTipo;
          request.cogetecv1Request.msflogon_TMP_KEY = tmpKey;
          request.cogetecv1Request.msfilogon_SENDER_CODICE = senderCodice;
          request.cogetecv1Request.msfilogon_TIPO_CARICAMENTO = tipoCaricamento;
          request.cogetecv1Request.msfilogon_CANALE_ACQUISIZ = canalAqusiz;
          response = invoke(request);
          return response;
     }


/*
    *@Author SANA BADJI
    *@description Validate field Response
    *@param response : validateResponse
    *@return Boolean
    */
    public static Boolean validateResponse (COGETECV1Response response){
                
                System.debug(' ************** response.cogetecv1Response.mftcoecoOCCURS '+response.cogetecv1Response.mftcoeco_OCCURS.size());
                //System.debug(' ************** response.cogetecv1Response.mfterrOMSFERROCCURS '+response.cogetecv1Response.mfterrOMSFERROCCURS.size());
                    if(response.resultCode != 0 ){
                        hasError = true;
                        errors.add(new ValidationError ('invalid Response ', 'COGETECV1Response')); }

                    if(response.resultMessage=='KO' ){
                        hasError = true;
                        errors.add(new ValidationError('InValid resultMessage','COGETECV1Response' ) );
                    }
                    if (response.cogetecv1Response.mftcoeco_OCCURS.size() == 0 ){
                    hasError = true;
                    errors.add(new ValidationError ('mftcoecoOCCURS list can\'t be null ', 'COGETECV1Response'));
                    }
                    if (response.cogetecv1Response.mftcoeco_OCCURS.size() == 0 ){
                    hasError = true;
                    errors.add(new ValidationError ('mftcoECO  can\'t be null ', 'COGETECV1Response'));
                    }
                    // if (response.cogetecv1Response.mfterrOMSFERROCCURS.size() == 0 ){
                    // hasError = true;
                    // errors.add(new ValidationError ('mftcoecoOCCURS list can\'t be null ', 'COGETECV1Response'));
                    // }
                    System.debug(' ************** hasError '+ hasError);
            return !hasError;
    }

    public static COGETECV1Response.MFTCOECO_ELEMENTO gestitoCOGETECV1Service(List<COGETECV1Response.MFTCOECO_ELEMENTO> elements){
      if(elements == null || elements.size() == 0){
        return null;
    }
    else {
         System.debug('********** bef element '+elements);
         COGETECV1Response.MFTCOECO_ELEMENTO recent;
         List<COGETECVElementoRecent> listRecent = new List<COGETECVElementoRecent>();
         List<COGETECV1Response.MFTCOECO_ELEMENTO> elementos = getElementoWithSoldeZero(elements);
         System.debug('************* elementos '+elementos);
         for(COGETECV1Response.MFTCOECO_ELEMENTO element : elementos){
             listRecent.add(new COGETECVElementoRecent(element) );
         }
        listRecent.sort();
        System.debug('********** sor element '+listRecent);
        recent = (listRecent.size() > 0)? listRecent[0].mftCoecoElement:null;
        dividendoElimina(recent);
        return recent;
    }
}
public static List<COGETECV1Response.MFTCOECO_ELEMENTO> getElementoWithSoldeZero(List<COGETECV1Response.MFTCOECO_ELEMENTO> elemento){
      List<COGETECV1Response.MFTCOECO_ELEMENTO> elementos = new List<COGETECV1Response.MFTCOECO_ELEMENTO>();
      try {
          for( COGETECV1Response.MFTCOECO_ELEMENTO  ele : elemento){
              if(ele.mftcoeco_SALDO == 0){
                  elementos.add(ele);
              }
          }
          
      } catch (Exception e) {
           System.debug('***********  getElementoWithSoldeZero erroMessage '+e.getMessage());
           System.debug('***********  getElementoWithSoldeZero erroMessage '+e.getStackTraceString() );
      }
      return elementos;
}

 public static void dividendoElimina(COGETECV1Response.MFTCOECO_ELEMENTO rc){
            if(rc == null){
                return;
            }
            else {
                String importom = (rc.mftcoeco_IMPORTO).remove('-');
                Integer montant = Integer.valueOf(importom)/100;
                String   importoString = String.valueOf(montant);
                rc.mftcoeco_IMPORTO = importoString;
                Datetime df= CGMWSUtils_1_0.formatStringToDatetime(rc.mftcoeco_DATA_SCADENZA);
                String deteformat = 'dd/MM/yyyy';
                String ds = df.format(deteformat);
                rc.mftcoeco_DATA_SCADENZA = ds;

                
            }
}
}