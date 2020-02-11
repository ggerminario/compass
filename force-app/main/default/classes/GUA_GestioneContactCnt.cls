/**
 * @File Name          : GUA_GestioneContactCnt.cls
 * @Description        : 
 * @Author             : Mame Bousso kane
 * @CreatedDate        : 20/09/2019
 */
public with sharing class GUA_GestioneContactCnt {
    
    @AuraEnabled
    public static Map<String ,Object> getContactCaseByQueue(Group grp,String pageSize, String pageNumber){
            System.debug('grp '+grp+' '+pageSize+' '+pageNumber);
        Map<String ,Object> returnValue = new  Map<String ,Object>();
        returnValue.put('erreur', false);
       try {
           List<Case> contactsCase = Gua_ManageUnitaAffariQuery.getContactsCaseByQueue(grp,pageSize,pageNumber);
           returnValue.put('resultat',contactsCase);
            if(contactsCase.size() == 0){
            	returnValue.put('message', 'Nessun contatto trovato');
                throw new CustomException('Nessun contatto trovato');
            }
       } catch (Exception e) {
            System.debug('errorMessage GUA_GestioneContactCnt getContactByQueue '+e.getMessage()+' '+e.getLineNumber());
             returnValue.put('message', e.getMessage()+' '+e.getCause()+' '+e.getLineNumber());
             returnValue.put('erreur', true);
       }
        return returnValue;
    }

    @AuraEnabled
    public static Map<String ,Object> getContactCaseFilter(Group grp,String pageSize, String pageNumber, String elementFilter){
        System.debug('grp '+grp+' '+pageSize+' '+pageNumber);
        Map<String ,Object> returnValue = new  Map<String ,Object>();
        returnValue.put('erreur', false);
       try {
           List<Case> contactsCase = Gua_ManageUnitaAffariQuery.filterCase(grp, pageSize, pageNumber, elementFilter);
           returnValue.put('resultat',contactsCase);
            if(contactsCase.size() == 0){
            	returnValue.put('message', 'Nessun contatto trovato');
                throw new CustomException('Nessun contatto trovato');
            }
       } catch (Exception e) {
            System.debug('errorMessage GUA_GestioneContactCnt getContactByQueue '+e.getMessage()+' '+e.getLineNumber());
             returnValue.put('message', e.getMessage()+' '+e.getCause()+' '+e.getLineNumber());
             returnValue.put('erreur', true);
       }
        return returnValue;
    }

    @AuraEnabled
    public static Map<String ,Object> getLastContactCaseByQueue(Group grp,String pageSize){
        Map<String ,Object> returnValue = new  Map<String ,Object>();
        returnValue.put('erreur', false);
       try {
           List<Case> contactsCase = Gua_ManageUnitaAffariQuery.getLastContactCaseByQueue(grp,pageSize);
           returnValue.put('resultat',contactsCase);
           if(contactsCase.size() == 0){
            	returnValue.put('message', 'Nessun contatto trovato');
                throw new CustomException('Nessun contatto trovato');
            }
       } catch (Exception e) {
            System.debug('errorMessage GUA_GestioneContactCnt getContactByQueue '+e.getMessage()+' '+e.getLineNumber());
             returnValue.put('message', e.getMessage()+' '+e.getCause()+' '+e.getLineNumber());
             returnValue.put('erreur', true);
       }
        return returnValue;
    } 

    @AuraEnabled
    public static Map<String, Object> getListViews(){
        Map<String, Object> response = new Map<String, Object>();
        try {
            Id rectypeId = CGMWSUtils_1_0.getRecordTypeId('Case', 'CRM_RichiestaOnline');
            // AND RecordTypeId =:rectypeId
            List<ListView> listview = [SELECT Id, Name, DeveloperName FROM ListView WHERE Name LIKE '%Affari e Delibere%'];
            response.put('error', false);
            response.put('listview', listview);
        } catch (Exception e) {
            response.put('error', true);
            response.put('message', e.getCause() + ' '+ e.getMessage());
        }
        return response;
    }

    @AuraEnabled
    public static Map<String ,Object> filterContactCaseByCampagna(Group grp, String nameCampagna, String orderCriter){
        Map<String ,Object> returnValue = new  Map<String ,Object>();
        returnValue.put('erreur', false);
       try {
           List<Case> contactsCase = Gua_ManageUnitaAffariQuery.filterCaseByCampagna(grp, nameCampagna, orderCriter);
           System.debug('contactsCase'+contactsCase);
           returnValue.put('resultatFilter',contactsCase);
           if(contactsCase.size() == 0){
            	returnValue.put('message', 'Nessun contatto trovato');
                throw new CustomException('Nessun contatto trovato');
            }
       } catch (Exception e) {
            System.debug('errorMessage GUA_GestioneContactCnt getContactByQueue '+e.getMessage());
             returnValue.put('message', e.getMessage()+' '+e.getCause()+' '+e.getLineNumber());
             returnValue.put('erreur', true);
       }
        return returnValue;
    } 
   
    @AuraEnabled
    public static Map<String,Object> filterCaseByNomeOcsCF(String nome, String codiceOcs, String utenzoCF, String pageSize, String pageNumber, String recordTypeNameCase){
        System.debug('################## running  filterCaseByNomeOcsCF');
        Map<String, Object> returnValue = new Map<String, Object>();
        returnValue.put('error',false);
        List<Account> dealers = new  List<Account> ();
        List<UtenZaDealer> utenzaWrappers = new List<UtenZaDealer>();
        Set<String> codiceOcsSet = new Set<String>();
      
        System.debug('##################  codiceOcs '+codiceOcs);
        try {
            if(String.isNotEmpty(codiceOcs) || String.isNotEmpty(nome) ){
                  System.debug('############################# No utenze');
                  dealers = Gua_ManageUnitaAffariQuery.searchDealer(codiceOcs,  nome, pageSize, pageNumber, recordTypeNameCase);
                   System.debug('#################  dealers '+dealers);
                   returnValue.put('cntactsCases', dealers);
                   //returnValueput('case', )
            }
            else{
                System.debug('#############################  utenze');
               RecuperaUtenzeIntermediarioInvoker.RecuperaUtenzeIntermediarioRequestDTO req = new   RecuperaUtenzeIntermediarioInvoker.RecuperaUtenzeIntermediarioRequestDTO();
                req.codiceIntermediario = '';
                req.codiceUtenza = utenzoCF;
                RecuperaUtenzeIntermediarioInvoker.Response  response = RecuperaUtenzeIntermediarioInvoker.invoke(req);
                System.debug('############## response '+response);
                 System.debug('############## response '+response.recuperaUtenzeIntermediarioResponse.utenze.size() );
                if(RecuperaUtenzeIntermediarioInvoker.validateResponse(response)){
                    for( RecuperaUtenzeIntermediarioInvoker.UtenzaIntermediarioDTO dto:  response.recuperaUtenzeIntermediarioResponse.utenze){
                        // utenzaWrappers.add(new UtenZaDealer(dto.Id, dto.ragSocIntermediario, dto.codiceIntermediario, dto.tipo, dto.statoDealer, dto.codiceFiscale, dto.localitaNascita, dto.provinciaNascita) );
                        System.debug('################ dto '+dto);
                       //  System.debug('################ dto size '+dto.size());
                        //codiceOcsSet.add(dto.codiceFiscale);
                        codiceOcsSet.add('D'+dto.codiceIntermediario);
                    }
                 if(codiceOcsSet.size() > 0){
                   System.debug('################# codice Dealer List '+codiceOcsSet);
                    dealers = Gua_ManageUnitaAffariQuery.getCasesByCodiceOcs(codiceOcsSet, pageSize, pageNumber );
                   returnValue.put('cntactsCases', dealers);
                 }
                    
                } 

            }

             System.debug('###################  dealers '+dealers.size());
          //  System.debug('##################  utf'+cntactsCases[0].UAF_DatiAggiuntiviFile__c);
            
        } catch (Exception e) {
             returnValue.put('error',true);
                 System.debug('################ errorMessage '+e.getMessage());
                 System.debug('################ '+e.getStackTraceString());
        } 
        return returnValue;
    }

    @AuraEnabled
    public static Map<String ,Object>  getInformazioniDealerByCodeOCS(String codiceOCS){
        Map<String,Object> returnValue = new  Map<String,Object>();
         returnValue.put('error', false);
        try {
         
                Account account = Gua_ManageUnitaAffariQuery.getDealerByCodiceOCS(codiceOCS);
                returnValue.put('dealer', account);
        } catch (Exception e) {
                returnValue.put('error', true);
                System.debug('############### errorMessage '+e.getMessage());
                System.debug('################# err '+e.getStackTraceString());
        }
        return returnValue;
    }
    

    @AuraEnabled
    public static Map<String ,Object> getQueus(){
        Map<String ,Object> returnValue = new  Map<String ,Object>();
        returnValue.put('erreur', false);
       try {
           List<Group> queus = Gua_ManageUnitaAffariQuery.getQueus();
           returnValue.put('resultat',queus);
       } catch (Exception e) {
            System.debug('errorMessage Gua_ManageUnitaAffariCnt Gua_ManageUnitaAffariCnt '+e.getMessage());
             returnValue.put('message', e.getMessage()+' '+e.getCause()+' '+e.getLineNumber());
             returnValue.put('erreur', true);
       }
        return returnValue;
    }

    public class UtenZaDealer {
        @AuraEnabled public Id idCase {get;set;}
        @AuraEnabled public String regionSociale {get;set;}
        @AuraEnabled public String codiceOcs {get;set;}
        @AuraEnabled public String tipo {get;set;}
        @AuraEnabled public String stato {get;set;}
        @AuraEnabled public String codiceFiscale {get;set;}
        @AuraEnabled public String comune {get;set;}
        @AuraEnabled public String province {get;set;}

        public UtenZaDealer(Id idCase, String regionSociale, String codiceOcs,String tipo, String stato,String codiceFiscale, String comune, String province  ){
                           this.idCase = idCase;
                           this.regionSociale = regionSociale;
                           this.codiceOcs = codiceOcs;
                           this.tipo = tipo;
                           this.stato = stato;
                           this.codiceFiscale = codiceFiscale;
                           this.comune = comune;
                           this.province = province; 
                           

        }

    }
    public class CustomException extends Exception {}

    /**
     * @author ADIOP
     * @date 11/12/2019
     * @description update caseObject
     * @param Case caseObject
     **/
    @AuraEnabled
    public static Map<String ,Object> assignCaseToDealer(String idAccount, String developerName){
        Map<String ,Object> response = new Map<String ,Object>();
        response.put('error', false);
        XCS_Categoria__c cat = [SELECT Id FROM XCS_Categoria__c WHERE External_Id__c = '5221' LIMIT 1];
            
        Id recordTypeId = Gua_Service.getRecordTypeId(developerName, 'Case');
        Case caseObject = new Case();
        caseObject.Status = 'New';
        caseObject.AccountId = idAccount;
        caseObject.recordTypeId = recordTypeId;
        caseObject.Categoria_Riferimento__c = cat.Id;
        try {
            insert caseObject;
            response.put('case', caseObject);
        } catch (Exception e) {
            response.put('error', true);
            response.put('message', e.getCause() + ' ' + e.getMessage() + ' '+ e.getStackTraceString());
        }
        return response;
    }

    /**
     * @author ADIOP
     * @date 11/12/2019
     * @description update caseObject
     * @param Case caseObject
     **/
    @AuraEnabled
    public static Map<String ,Object> updateCaseToDealer(Case caseObject){
        Map<String ,Object> response = new Map<String ,Object>();
        response.put('error', false);
        try {
            update caseObject;
            response.put('case', caseObject);
        } catch (Exception e) {
            response.put('error', true);
            response.put('message', e.getCause() + ' ' + e.getMessage() + ' '+ e.getStackTraceString());
        }
        return response;
    }
}