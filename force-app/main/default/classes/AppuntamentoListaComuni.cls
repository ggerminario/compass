/**
 *@author Mame bousso    
 *@date 2019/08/07
 *@description web service Appuntamento lista Comuni
 */
@RestResource(UrlMapping = '/AppuntamentoListaComuni')
global with sharing class AppuntamentoListaComuni {
    // Map contains require field to call web service
    public  static Map<String, String> REQUIRED_FIELDS_POST_MAP = new Map<String, String>{
            'provincia' => ''
    };
    	
    @HttpPost
    global static void listComuni(){
            final RestRequest req = RestContext.request;
            final RestResponse res = Restcontext.response;
          /*  String province = req.requestURI.substring(req.requestURI.lastIndexOf('/')+1);
            System.debug('province '+province); */
            try {
               String response = execute(req.requestBody);
               res.statusCode = 200;
               res.responseBody = Blob.valueOf(response);
                
            } catch (Exception e) {
                System.debug('******** errorMessage '+e.getMessage());
                System.debug('******** errorMessage '+e.getStackTraceString());
            }
        }
        
    public static String execute (Blob jsonRequest){
           // ListXcsTown listXcsTown = new ListXcsTown();
            String responseService;
            try {
                        ListaComunaWrapper lc = deserializationRequest(jsonRequest);
                        System.debug('lc '+lc);
                       /*  REQUIRED_FIELDS_POST_MAP.put('provincia',lc.provincia);
                         validateData(REQUIRED_FIELDS_POST_MAP, 'POST');*/
                         List<XcsTown> listaXcstTow = getLisXcsTown(lc.provincia);

                        if(listaXcstTow.size() != 0){
                                AppuntamentoListaComuniResponseDTO dto  = new AppuntamentoListaComuniResponseDTO(listaXcstTow);
                               
                                dto.resultCode = 0;
                                
                                dto.resultMessage ='OK';
                                
                                responseService= JSON.serialize(dto);
                        }
                        else {
                              AppuntamentoListaComuniResponseDTO dto  = new AppuntamentoListaComuniResponseDTO();
                               
                                dto.resultCode = 1;
                                
                                dto.resultMessage ='KO';
                                
                                responseService= JSON.serialize(dto);
                            
                        }
                        System.debug('#################### responseService '+responseService);
            } catch (Exception e) {
                    AppuntamentoListaComuniResponseDTO dto  = new AppuntamentoListaComuniResponseDTO();
                    dto.resultCode = 1;
                    dto.resultMessage ='KO';
                 /*   dto.errorMessage = CGMWSUtils_1_0.ERROR_MESSAGE_MAP.get(e.getMessage());
                    dto.errorMessage   += String.isNotBlank(e.additionalInfo) ? ' ' + e.additionalInfo : '';*/
                    responseService= JSON.serialize(dto);
                    System.debug('******* errorMessage execute '+e.getMessage());
                    System.debug('******* errorMessage execute '+e.getStackTraceString());
            } 
            return responseService;
    }

    public static ListaComunaWrapper deserializationRequest(Blob jsonRequest){

        ListaComunaWrapper wrapper = new ListaComunaWrapper();

        try {
                String stringRequest = jsonRequest.toString().trim();
                wrapper = (ListaComunaWrapper) JSON.deserializeStrict(stringRequest, ListaComunaWrapper.class);
            
           } catch (Exception e) {
               
                AppuntamentoError.hasError = true;

                AppuntamentoError.errorMessage = CGMWSUtils_1_0.ERROR_MESSAGE_MAP.get('[KO-CREQ0005]');

                System.debug('############# errorMessage '+e.getMessage());

                System.debug('############### error '+e.getStackTraceString());  
        }
        return wrapper;
    }

    public class ListaComunaWrapper {
        public String provincia {get;set;}
    }
        
    public static List<XcsTown> getLisXcsTown(String provincia){
        System.debug('provincia '+provincia);
    	List<XcsTown> lista = new List<XcsTown>();
        list<XCS_Town__c> xcsTowns;
        if(String.isNotEmpty(provincia)){
             xcsTowns= [select Id, CAP__c, Catastale__c, Comune__c,Provincia_Desc__c,Provincia__c from XCS_Town__c where Provincia__c =:provincia
                                                ORDER BY Comune__c ASC];
             for(XCS_Town__c town: xcsTowns){
                XcsTown xcsTow= new XcsTown(town.CAP__c, town.Comune__c);
                lista.add(xcsTow);
              }
        }
      else{
            xcsTowns= [select Id, Provincia_Desc__c, CAP__c, Provincia__c from XCS_Town__c where Provincia__c != null
                                                ORDER BY Provincia_Desc__c ASC];
            Map<String,XCS_Town__c> mapxcsTown = new  Map<String,XCS_Town__c>();
            // Map<Id,XCS_Town__c> mapxcsTown = new  Map<Id,XCS_Town__c>(xcsTowns);
            for(XCS_Town__c town : xcsTowns){
                if(!mapxcsTown.containsKey(town.Provincia_Desc__c)){
                    mapxcsTown.put(town.Provincia_Desc__c, town);
                }
            }

            for(XCS_Town__c town: mapxcsTown.values()){
                    XcsTown xcsTow= new XcsTown(town.CAP__c, town.Provincia_Desc__c);
                    lista.add(xcsTow);
            }
      }
       System.debug('provincia '+xcsTowns);
       

   		return lista;
   }

   global class AppuntamentoListaComuniResponseDTO extends GenericResponse {
       List<XcsTown> lista {get;set;}
       String errorMessage;
       global AppuntamentoListaComuniResponseDTO(){
           super();
       }
       global AppuntamentoListaComuniResponseDTO( List<XcsTown> lista){
           super();
           this.lista = lista;
          // this.descrizione = descrizione;
       }

   }
		
 
	global class XcsTown{
    	String codice {get;set;}
        String descrizione {get;set;}
        global XcsTown(String codice, String descrizione){
            this.codice = codice;
            this.descrizione = descrizione;
        }
         global XcsTown(String descrizione){
            this.descrizione = descrizione;
        }
    }

    public static void validateData(Map<String,Object> mapData, String requestType){
         List<String> errorFields = new List<String>();
         if(requestType == 'POST'){
             for(String fieldName : mapData.keySet()){
                 System.debug('################### validation '+mapData.get(fieldName));
                 if(String.isEmpty((String)mapData.get(fieldName))){
                     errorFields.add(fieldName);
                 }
             }

            if(!errorFields.isEmpty()){
               throw new CGMWSUtils_1_0.CGMWSRException('[KO-APPLC01]', String.join(errorFields, ', '));
           }
         }
    }
}