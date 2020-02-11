/**-----------------------------------------------------------------------
  *@Author Madicke BALDE
  *@description 
  @date 2019/08/29
 *---------------------------------------------------------------------*/
 @RestResource(UrlMapping = '/AppuntoOccupazioneFiliale')
global with sharing class AppuntamentoOccupazioneFiliale  extends CGMServiceWsr_1_1 {
 
  @HttpPost
  global static void appuntamentoOccupazioneFiliale (){
            final RestRequest req = RestContext.request;
            final RestResponse resp = RestContext.response;
    try {
          String response = execute(req.requestBody);
          resp.statusCode = 200;
          resp.responseBody = Blob.valueOf(response); 
          System.debug(' ################### responseBody '+resp);
      
    } catch (Exception e) {
      System.debug(' #################  errorMessage ########## '+e.getMessage() );
      System.debug(' #################  errorMessage ########## '+ e.getStackTraceString() );
    }

  }
  /**------------------------------------------------------------------------------
    *@Author Madicke BALDE
    *@description
    *@date
    *@param  jsonRequest
    *@return AppuntamentoOccupazioneWrapper
   *-------------------------------------------------------------------------------------*/
  public static AppuntamentoOccupazioneWrapper deserializeRequest(Blob jsonRequest){
      AppuntamentoOccupazioneWrapper  appuntamento = new AppuntamentoOccupazioneWrapper();
      try {
        String jsonRequestBody = jsonRequest.toString().trim();
        appuntamento = (AppuntamentoOccupazioneWrapper) JSON.deserializeStrict(jsonRequestBody, AppuntamentoOccupazioneWrapper.class);
        return appuntamento;
      } catch (Exception e) {
        System.debug(' ############## errorMessage '+e.getMessage());
        System.debug(' ############## errorMessage '+e.getStackTraceString() );
        throw new CGMWSUtils_1_0.CGMWSRException('[KO-CREQ0005]');
        
      }
  }
  
  /**------------------------------------------------------------------------------
    *@Author Madicke BALDE
    *@description
    *@param jsonRequest
   *------------------------------------------------------------------------------*/
  public static String execute(Blob jsonRequest){
     AppuntamentoOccupazioneFilialeReturn appuntamentoReturn;
     String responseWService;
   try {
       AppuntamentoOccupazioneWrapper appuntaOccupa = deserializeRequest(jsonRequest);
       Account filiale = AppuntamentoDomainWS.getFilialeByCodiceCliente(appuntaOccupa.codFiliale);
     /*  Date dtIni = CGMWSUtils_1_0.formatStringToDate(appuntaOccupa.dataA);
       Date dtEnd = CGMWSUtils_1_0.formatStringToDate(appuntaOccupa.dataDa);*/
     //  String response = AppuntamentoDomainWS.appuntamentoOccupazionniFiliale(dtIni, dtEnd, filiale);
       Map<String,Object> response = EventDomaine.occupazionniFiliale(appuntaOccupa.dataDa, appuntaOccupa.dataA, filiale );
       if(!AppuntamentoError.hasError && !Boolean.valueOf(response.get('error'))){
          System.debug('############### response occupazione '+response);
          System.debug(' ##################### response '+response);
          appuntamentoReturn = new AppuntamentoOccupazioneFilialeReturn((String) response.get('response'));
          appuntamentoReturn.resultCode = 0;
          appuntamentoReturn.resultMessage = 'OK';
          //   appuntamentoReturn.r
          responseWService = JSON.serialize(appuntamentoReturn); 
       }
       else {
           System.debug('############### AppuntamentoError.errorMessage '+AppuntamentoError.errorMessage);
           appuntamentoReturn = new AppuntamentoOccupazioneFilialeReturn(AppuntamentoError.errorMessage, (String) response.get('response'));
          appuntamentoReturn.resultCode = 1;
          appuntamentoReturn.resultMessage = 'K0';
          responseWService = JSON.serialize(appuntamentoReturn); 
       }
     
        
     
   } catch (Exception e) {
      appuntamentoReturn = new AppuntamentoOccupazioneFilialeReturn();
      appuntamentoReturn.resultCode = 1;
      appuntamentoReturn.resultMessage ='K0';
     System.debug('################# errorMessage execute  ###########  '+e.getMessage());
     System.debug('################# errorMessage ###########  execute  '+e.getStackTraceString() );
     responseWService = JSON.serialize(appuntamentoReturn);
   }
   System.debug(' ######################### responseWService '+responseWService);
   return responseWService;
  }
  /*public class AppuntamentoOccupazioneFilialeReturn extends GenericResponse{
     String errorMessage;
     AppuntamentoOccupazioneFilialeResponseDTO appuntamentoOccupazioneFilialeReturn;
     public AppuntamentoOccupazioneFilialeReturn(){
       super();
     }
      public AppuntamentoOccupazioneFilialeReturn(String occupazione){
       super();
       this.appuntamentoOccupazioneFilialeReturn = new AppuntamentoOccupazioneFilialeResponseDTO();
       this.appuntamentoOccupazioneFilialeReturn.occupazione = occupazione;
     }
       public AppuntamentoOccupazioneFilialeReturn(String errorMessage, String occupazione){
       super();
       this.errorMessage = errorMessage;
       this.appuntamentoOccupazioneFilialeReturn = new AppuntamentoOccupazioneFilialeResponseDTO();
       this.appuntamentoOccupazioneFilialeReturn.occupazione = occupazione;
     }
  }*/
  public class AppuntamentoOccupazioneFilialeReturn extends GenericResponse{
     String occupazione;
     String errorMessage;
     public AppuntamentoOccupazioneFilialeReturn(){
       super();
     }
      public AppuntamentoOccupazioneFilialeReturn(String occupazione){
       super();
       this.occupazione = occupazione;
     }
       public AppuntamentoOccupazioneFilialeReturn(String errorMessage, String occupazione){
       super();
       this.errorMessage = errorMessage;
       this.occupazione = occupazione;
     }
  }
  public class  AppuntamentoOccupazioneWrapper {
    public String dataA {get;set;}
    public String dataDa  {get;set;}
    public String codFiliale {get;set;}
  }
  /*public class AppuntamentoOccupazioneFilialeResponseDTO{
      String occupazione;
    }*/
  
   //codFiliale
}