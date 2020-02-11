//----------------------------------------------------------------------
//-- - Author       : SANA BADJI
//-- - Date         : 12/06/2019
//-- - Description  : Handle Call Web Service
//----------------------------------------------------------------------

public with sharing class CallWebService {
public static RecuperaStatiAttributiPrtResponse res;
public static  String statoPratica;
public static  String attributoPratica;
public static  String statoOcs;
public static  String tipoPratica;


/*
* @description This method  allow to retrieve statoPratica and attributoPratica
for Queue : Coda Contatto “Anomalie Pre Sic PP”
* @Param recuperaRequest
* @Param idCase
*/

public  static String recuperaRequestPreSic(Set<Id> idCase){
    RecuperaStatiAttributiPrtRequest  recuperaRequest= CallWebService.buildElencoPratica(idCase);
    if(recuperaRequest== null || idCase.size() == 0){
    System.debug('************ recuperaRequest is empty '+recuperaRequest);
    System.debug('************ idCase is  emmty'+idCase.size());
    return statoOcs;
    }
    if(recuperaRequest!= null && idCase.size() > 0){
            res = Invoker.invoke(recuperaRequest);
            System.debug('************ requestPresic '+recuperaRequest);
            System.debug('************ responsePresic '+res);
            if(RecuperaStatiAttributiPrtService.ValidateResponse(res)){
            List<RecuperaStatiAttributiPrtResponse.RecuperaStatiAttributiPrtRes> elencoPraticheResp = res.RecuperaStatiAttributiPrtResponse.elencoPratiche;
            List<RecuperaStatiAttributiPrtRequest.RecuperaStatiAttributiPrtReq>  elencoPratiche=recuperaRequest.RecuperaStatiAttributiPrtRequest.elencoPratiche;
            //System.debug('************ elencoPratiche '+recuperaRequest.elencoPratiche);
            System.debug('************ elencoPratiche request '+elencoPratiche);
           // System.debug('************ elencoPraticheResp '+elencoPraticheResp);
            System.debug('************ elencoPratiche response'+elencoPraticheResp);
            for(RecuperaStatiAttributiPrtResponse.RecuperaStatiAttributiPrtRes res: elencoPraticheResp){
                statoPratica=  res.statoPratica;
                attributoPratica= res.attributoPratica;
                tipoPratica = res.tipoPratica;
                 if(statoPratica!=null && attributoPratica!=null){
                    statoOcs=statoPratica+attributoPratica;
                }
                 if(statoPratica==null){
                    statoOcs=attributoPratica;
                }
                if(attributoPratica==null){
                    statoOcs=statoPratica;
                }
                if(statoPratica==null && attributoPratica==null){
                    statoOcs=null;
                }
                //CallWebService.updateStatoOcs(idCase,statoOcs);
                System.debug('************ stato_ocs '+statoOcs);
            }
        }
}
return statoOcs;
}


/*  
* Autheur : Sana Badji 
* @param idsetCases
* @date  17/05/2019
*/
 
    public static RecuperaStatiAttributiPrtRequest  buildElencoPratica  (Set<Id> idsetCases){
        List<Case> caseWebservice=CaseSelector.getCaseWebservice(idsetCases);
        RecuperaStatiAttributiPrtRequest  recuperaRequest;
        if(caseWebservice.size() == 0){
            System.debug('******** caseWebservice is empty'+caseWebservice.size());
        }
        else{ 
            for(Case  ca: caseWebservice){  
                if(ca.NumeroPratica__c!=null){
                    recuperaRequest=new RecuperaStatiAttributiPrtRequest();
                    recuperaRequest.buildElencoPratica('CO',
                    ca.NumeroPratica__c,ca.Stato_Pratica__c,
                    ca.Attributi_Pratica__c,ca.CanaleContatto__c);
                }else{
                    System.debug('******** ca.NumeroPratica__c = '+ca.NumeroPratica__c);
                    System.debug('******** Tipo_Pratica__c is empty ='+ca.Tipo_Pratica__c);
                }
            }
        }
    return recuperaRequest;
    }

/*  
* Autheur : Sana Badji 
* @param caseIds
* @param developperName
* @param familyProduct
* @date  18/05/2019
    */
     @future (callout=true)
        public static void   addToQueuAfterCallWebservice  (Set<Id> caseIds,String developperName,String familyProduct){
                List<Case> listCaseToUpdate = new List<Case>();
                Group gr = CaseService.getQueue(developperName);
                List<Case> cases= CaseSelector.getPropuitFamily(caseIds,familyProduct);
                String statoOcs= CallWebService.recuperaRequestPreSic(caseIds);
                List<Anomalie_Doc__c> anomalibyId=AnomalieSelector.listAnomalieByID(caseIds);
                System.debug('************gr' +gr);
                System.debug('************cases ' +cases);
                System.debug('************developperName ' +developperName);
                System.debug('************familyProduct ' +familyProduct);
                Boolean isRIC = anomalibyId != null && anomalibyId.size() > 0 && anomalibyId[0].Codice_Macro_Documento__c=='RIC';
                Boolean isCodAno = anomalibyId != null && anomalibyId.size() > 0 && anomalibyId[0].codice_Anomalia__c!=null;
                    try{
                        if (gr != null && cases.size() > 0 && (statoOcs=='05BT' || statoOcs=='10') 
                        // && (anomalibyId[0].Descrizione_Anomalia_Op__c!=null || cases[0].Is_Discordanza_Cellulare__c==true)
                        ) {
                            System.debug('************ casesPreSic '+cases);
                            System.debug('************ statoOcsPreSic exist '+statoOcs);
                            CaseService.addCasesToQueue(cases,developperName);
                        }
                        else if(gr != null && cases.size() > 0 && !CGMWSUtils_1_0.isStatoGreaterThan(statoOCS, '20') && isRIC && isCodAno){
                            System.debug('************ casesPostSic '+cases);
                            System.debug('************ statoOcs is  '+statoOcs);
                            CaseService.addCasesToQueue(cases,developperName);
                        }
                        else if(gr != null && cases.size() > 0 && CGMWSUtils_1_0.isStatoGreaterThan(statoOCS, '20')
                        // && (anomalibyId[0].Descrizione_Anomalia_Op__c!=null || cases[0].Is_Discordanza_Cellulare__c==true)
                        ){
                            System.debug('************ casesPostSic '+cases);
                            System.debug('************ statoOcsPostSic exist '+statoOcs);
                            CaseService.addCasesToQueue(cases,developperName);
                        }
                         else if(gr != null && cases.size() > 0 && !CGMWSUtils_1_0.isStatoGreaterThan(statoOCS, '20')){
                            System.debug('************ Ecom addTocase');
                           
                            CaseService.addCasesToQueue(cases,developperName);
                        }
                        
                        // if(checkStatoOcsPreSicExist!=statoOcs){
                        //     System.debug('************  the statoocsPreSic is different from that of the webservice '+statoOcs);
                        // }
                        // if(checkStatoOcsPostSicExist!=statoOcs){
                        //     System.debug('************  the statoocsPostSic is different from that of the webservice '+statoOcs);
                        // }
                        
                        System.debug('************listCaseToUpdate ' +listCaseToUpdate.size());
                        if(!listCaseToUpdate.isEmpty()){
                            Recursion.isTriggerExecuting=true;
                            upsert listCaseToUpdate;
                            System.debug('************Recursion.isTriggerExecuting After ' +Recursion.isTriggerExecuting);
                        }
                        }catch(Exception e){
                        //Recursion.isTriggerExecuting=true;}
                        System.debug('The following exception has occurred: ' + e.getMessage());
                        System.debug('errorStract'+ e.getStackTraceString() ); 
                        System.debug('cases: ' + cases);
                        System.debug('************ finish methode');
                }
    }
/*  
* Autheur : Sana Badji 
* @param nameDEM
* @param email
* @param roLinkbozza
* @param descrizioneAnomaliaop
* @param idcase
* @date  11/11/2019
*/

     public static void createNote(String nameDEM,String email,String roLinkbozza,String descrizioneAnomaliaop, Id idcase ){
        //String email = c.Account.PersonEmail;
        String body;
        System.debug('PersonEmail: ' +email);
        System.debug('roLinkbozza: ' +roLinkbozza);
        System.debug('descrizioneAnomaliaop: ' +descrizioneAnomaliaop);
        System.debug('idcase: ' +idcase);
        if(email!=null && roLinkbozza!=null && descrizioneAnomaliaop!=null){
            body= 'a:'+email+'\n'+
                                'Link Bozza :'+roLinkBozza+'\n'+
                                'Anomalie DOC:'+descrizioneAnomaliaop;
            CaseDomain.createFeeditem(nameDEM,body,idcase);
        }
        else if(roLinkbozza==null || descrizioneAnomaliaop==null){
            roLinkBozza='';
            descrizioneAnomaliaop='';
            body = 'a:'+email+'\n'+
                            'Link Bozza :'+roLinkBozza+'\n'+
                            'Anomalie DOC:'+descrizioneAnomaliaop;
            CaseDomain.createFeeditem(nameDEM,body,idcase);
        }
       
    }

/*  
* Autheur : Sana Badji 
* @param caseIds
* @param statoOcs
* @date  12/11/2019
    */
    public static void  updateStatoOcs(Set<Id> caseIds,String statoOcs,String tipoPratica){
                List<Case> listCaseToUpdate = new List<Case>();
                List<Case> cases= CaseSelector.getCaseWebservice(caseIds);
                Group gr = CaseService.getQueue('Q524');
                Set<Id> ownerId=new Set<Id>();
                Id groudId=gr.Id;
                System.debug('************cases ' +cases);
                    try{
                        if (cases.size() > 0) {
                            System.debug('************ cases '+cases);
                            for (Case c : cases) {
                                c.stato_ocs__c = statoOcs;
                                c.Tipo_Pratica__c = tipoPratica;
                                ownerId.add(groudId);
                                if(c.Status.toUppercase()=='Closed'.toUppercase() || c.Status.toUppercase()=='Chiuso'.toUppercase()){
                                    c.OwnerId = gr.Id;
                                }
                                if(c.OwnerId==groudId){
                                    System.debug('************c.OwnerId ' +c.OwnerId);
                                    System.debug('************gr.Id ' +gr.Id);
                                    c.Status='Closed';
                                    System.debug('************c.Status ' +c.Status);
                                }
                            listCaseToUpdate.add(c);
                            }
                            System.debug('************listCaseToUpdate ' +listCaseToUpdate.size());
                            if(!listCaseToUpdate.isEmpty()){
                                Recursion.isTriggerExecuting=true;
                                upsert listCaseToUpdate;
                                System.debug('************Recursion.isTriggerExecuting After ' +Recursion.isTriggerExecuting);
                            }
                        }
                    }catch(Exception e){
                        //Recursion.isTriggerExecuting=true;}
                        System.debug('The following exception has occurred: ' + e.getMessage());
                        System.debug('errorStract'+ e.getStackTraceString() ); 
                        System.debug('cases: ' + cases);
                        System.debug('************ finish methode');
                }
    }


/*  
* Autheur : Sana Badji 
* @param caseIds
* @date  12/11/2019
    */
    public static void  updateCaseChangeQueue(Set<Id> caseIds){
                List<Case> listCaseToUpdate = new List<Case>();
                List<Case> cases= CaseSelector.getCaseWebservice(caseIds);
                Group gr1 = CaseService.getQueue('Q525');
                Set<Id> ownerId=new Set<Id>();
                Id groudId=gr1.Id;
                System.debug('************cases ' +cases);
                    try{
                        if (cases.size() > 0) {
                            System.debug('************ cases '+cases);
                            for (Case c : cases) {
                                if(c.OwnerId!=groudId && c.Note__c=='-SELF-'){
                                    System.debug('************c.OwnerId ' +c.OwnerId);
                                    System.debug('************groudIdQ524' +groudId);
                                    c.Note__c='';
                                    c.RO_Messaggio_Non_Contattare__c='';
                                }
                            listCaseToUpdate.add(c);
                            }
                            System.debug('************listCaseToUpdate ' +listCaseToUpdate.size());
                            if(!listCaseToUpdate.isEmpty()){
                                Recursion.isTriggerExecuting=true;
                                upsert listCaseToUpdate;
                                System.debug('************Recursion.isTriggerExecuting After ' +Recursion.isTriggerExecuting);
                            }
                        }
                    }catch(Exception e){
                        //Recursion.isTriggerExecuting=true;}
                        System.debug('The following exception has occurred: ' + e.getMessage());
                        System.debug('errorStract'+ e.getStackTraceString() ); 
                        System.debug('cases: ' + cases);
                        System.debug('************ finish methode');
                }
    }

}