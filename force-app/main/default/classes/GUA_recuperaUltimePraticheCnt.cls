public with sharing class GUA_recuperaUltimePraticheCnt {

    @AuraEnabled(cacheable=true)
    public static Map<String, Object> retrieveAllPraticheCarta(String caseId,String tipo,String codiceCliente, String tipoConv){

        Map<String, Object> response = new Map<String, Object>();
        response.put('error',false);

        if (caseId != null ) {

            try {

                List<Case> c = Gua_ManageUnitaAffariQuery.getCaseById(caseId);
              //  List<Case> c = Gua_ManageUnitaAffariQuery.getCaseById(caseId);
                System.debug('########################## recupera Case '+c);
                if ( c.size() > 0) {
                    System.debug('##################### tipo Pratica '+tipo);
                     System.debug('##################### codiceCliente '+c[0].Account.getCodice_Cliente__c);
                    String flagInfoCliente = 'DEALER#'+tipoConv+'#'+codiceCliente;
                    //String flagInfoCliente = 'DEALER#'+tipoConv+'#112525';
                 /*   RecuperaDatiPostvenditaResponse data =  RecuperaDatiPostVenditaService.builtbuildRecuperaDatiPostvendit('' ,
                                                                                                                             '',
                                                                                                                             '',
                                                                                                                             tipo,
                                                                                                                              'DEALER#CV#112525'
                                                                                                                               ) ; */
                      RecuperaDatiPostvenditaRequest req = new RecuperaDatiPostvenditaRequest('', '', '',
                                         '', '', '', tipo, flagInfoCliente, '',  '', '',  '',  '',  ''); 
                                        
                   /*RecuperaDatiPostvenditaRequest req = new RecuperaDatiPostvenditaRequest('', '', '',
                                         '', '', '', tipo, '', '',  '', '',  '',  '',  '16563377');   */                
                                        
                   System.debug('################# req '+req);
                   RecuperaDatiPostvenditaResponse data = RecuperaDatiPostVenditaService.buldRequest(req);

                    System.debug('#### Pratiche ############ '+ data.pratiche.size() );
                    System.debug('#### data ####'+ JSON.serialize(data));
                    response.put('data',JSON.serialize(data));
                }

            } catch (Exception e) {
                response.put('error',true);
                response.put('message',e.getMessage());
                System.debug('## Erreur log ## '+e.getMessage());
            }    

        }else {
            response.put('data',null);

        }
        return response;   

    }


}