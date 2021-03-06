/**
 * @File Name          : GUA_DettaglioDealerCnt.cls
 * @Description        : 
 * @Author             : Mame Bousso kane
 * @CreatedDate        : 23/10/2019
 */
public with sharing class GUA_DettaglioDealerCnt {

    @AuraEnabled
    public static Map<String ,Object> getDealerByCase(String idCase){
        Map<String ,Object> returnValue = new  Map<String ,Object>();
        returnValue.put('erreur', false);
       try {
           Case dealerCase = Gua_ManageUnitaAffariQuery.getDealerByCase(idCase);
           returnValue.put('resultat',dealerCase);
       } catch (Exception e) {
            System.debug('errorMessage GUA_DettaglioDealerCnt getDealerByCase '+e.getMessage());
             returnValue.put('message', e.getMessage()+' '+e.getCause()+' '+e.getLineNumber());
             returnValue.put('erreur', true);
       }
        return returnValue;
    }
    
    @AuraEnabled
    public static Map<String ,Object> getFilialeById(String idAccount){
        Map<String ,Object> returnValue = new  Map<String ,Object>();
        returnValue.put('erreur', false);
       try {
           Account filialeCase = Gua_ManageUnitaAffariQuery.getFilialeById(idAccount);
           returnValue.put('filiale',filialeCase);
       } catch (Exception e) {
            System.debug('errorMessage GUA_DettaglioDealerCnt getFilialeById '+e.getMessage());
             returnValue.put('message', e.getMessage()+' '+e.getCause()+' '+e.getLineNumber());
             returnValue.put('erreur', true);
       }
        return returnValue;
    }

    @AuraEnabled
    public static Map<String ,Object> getCapoFiliale(String idFiliale){
        Map<String ,Object> returnValue = new  Map<String ,Object>();
        returnValue.put('erreur', false);
        returnValue.put('filiale', false);
        returnValue.put('resultat','');
       try {
            
            if(idFiliale!=null){
                returnValue.put('filiale', true);
                Account filiale = [SELECT Id,Name,CittaSede__pc,getCodice_Cliente__c,Provincia_Nascita__pc,Luogo_Nascita__pc,BillingAddress,ShippingStreet, 
                                    ShippingCity, ShippingState, ShippingPostalCode, NameRoleReference__c,NameParentRoleReference__c
                                    FROM Account WHERE RecordType.Name='Branch'
                                    AND Id=:idFiliale limit 1];
                Map<String, Object> filialeMap = (Map<String, Object>) JSON.deserializeUntyped(JSON.serialize(filiale));
                if(filialeMap.keySet().contains('NameRoleReference__c')){
                     String roleReference = filiale.NameRoleReference__c;
                    roleReference=roleReference.replace('_', ' ');
                    roleReference= roleReference+' Manager';
                    User capoFiliale=[select id,name,profile.name,UserRole.Name from User 
                                                    where  profile.name in (:PermissionUtils.BRANCH_MANAGER)
                                                    and UserRole.Name=:roleReference limit 1];                
                    if(capoFiliale.Id!=null){
                        returnValue.put('resultat',capoFiliale);
                    }
                }else {
                            
                }
               
       }else {
            returnValue.put('filiale', false);
       }
       } catch (Exception e) {
            System.debug('errorMessage GUA_DettaglioDealerCnt getCapoFiliale '+e.getMessage());
             returnValue.put('message', e.getMessage()+' '+e.getCause()+' '+e.getLineNumber());
             returnValue.put('erreur', true);
       }
        return returnValue;
    }

    @AuraEnabled
    public static Map<String ,Object> getDispositionDay(String idFiliale){
        Map<String ,Object> returnValue = new  Map<String ,Object>();
        returnValue.put('erreur', false);
        returnValue.put('resultat','');
       try {
            
            if(idFiliale!=null){
                returnValue.put('filiale', true);
                Account filiale = [SELECT Id,Name,CittaSede__pc,getCodice_Cliente__c,Provincia_Nascita__pc,Luogo_Nascita__pc,BillingAddress,ShippingStreet, 
                                    ShippingCity, ShippingState, ShippingPostalCode, NameRoleReference__c,NameParentRoleReference__c
                                    FROM Account WHERE Id=:idFiliale ];
                if(filiale.Id!=null){
                    Map<String,List<XCS_DeskItem__c>> result = XCS_GestioneDeskClass.initDeskItemPerDesk(filiale);
                }else {
                            
                }
            }else {
                returnValue.put('filiale', false);
            }
       } catch (Exception e) {
            System.debug('errorMessage GUA_DettaglioDealerCnt getCapoFiliale '+e.getMessage());
             returnValue.put('message', e.getMessage()+' '+e.getCause()+' '+e.getLineNumber());
             returnValue.put('erreur', true);
       }
        return returnValue;
    }

public with sharing class GUA_CSVparsingJSON {
   public String cognome{get;set;}
   public String nome{get;set;}
   public String data_caricamento{get;set;}
   public String data_delibera{get;set;}
   public String data_liquidazione{get;set;}
   public String importo_erogato{get;set;}
   public String cod_Convenzionato_H3G{get;set;}
   public String descr_Convenzionato_H3g{get;set;}
   public String codice_Fiscale_Conv{get;set;}
   public String partita_IVA_Conv{get;set;}
   public String codice_PV_H3G{get;set;}
   public String descr_PV_H3G{get;set;}
   public String num_I_telefono{get;set;}
   public String num_II_telefono{get;set;}
   public String codice_Filiale_Compass{get;set;}
   public String filiale_Compass{get;set;}
   public String gg_trascorsi_dalla_delibera{get;set;}
   public String gg_trascorsi_dalla_liquidazione{get;set;}
   public String anomalia_num_2{get;set;}
   public String anomalia_num_3{get;set;}
   public String anomalia_num_4{get;set;}
   public String anomalia_num_5{get;set;}

   //Constructor

Public GUA_CSVparsingJSON(String val1,String val2,String val3,String val4,String val5,String val6,String val7,
                          String val8,String val9,String val10,String val11,String val12,String val13,
                          String val14,String val15,String val16,String val17, String val18,
                          String val19,String val20,String val21, String val22){
        this.cognome = val1;
        this.nome = val2;
        this.data_caricamento = val3;
        this.data_delibera = Val4;
        this.data_liquidazione = val5;
        this.importo_erogato = val6;
        this.cod_Convenzionato_H3G = val7;
        this.descr_Convenzionato_H3g = val8;
        this.codice_Fiscale_Conv = val9;
        this.partita_IVA_Conv = val10;
        this.codice_PV_H3G = val11;
        this.descr_PV_H3G = val12;
        this.num_I_telefono = val13;
        this.num_II_telefono = val14;
        this.codice_Filiale_Compass = val15;
        this.filiale_Compass = val16;
        this.gg_trascorsi_dalla_delibera = val17;
        this.gg_trascorsi_dalla_liquidazione = val18;
        this.anomalia_num_2 = val19;
        this.anomalia_num_3 = val20;
        this.anomalia_num_4 = val21;
        this.anomalia_num_5 = val22;


    }
}
 @AuraEnabled
 public static Map<String ,Object> searchDisponibilitaFiliale(Id idFiliale){
     Map<String ,Object> returnValue = new Map<String ,Object>();
     returnValue.put('date','Filiale Non disponibile');
     returnValue.put('error', false);
     try {
         Date dateDisponibilita = AppuntamentoDomainWS.filialeDisponibleSobato(idFiliale);
         System.debug('################ appDate searchDisponibilitaFiliale '+dateDisponibilita);
         if(dateDisponibilita != null)returnValue.put('date', dateDisponibilita.day()+'/'+dateDisponibilita.month()+'/'+dateDisponibilita.year());
             
     } catch (Exception e) {
         returnValue.put('error', true);
         System.debug('################### errorMessage '+e.getMessage());
         System.debug('################### errorMessage '+e.getStackTraceString() );
         
     }
     return returnValue;

 }

    /**
     * @author ADIOP
     * @date 11/12/2019
     * @description update caseObject
     * @param Case c
     **/
    @AuraEnabled
    public static Map<String ,Object> assignCaseToDealer(Case caseObject){
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
    
    @AuraEnabled
    public static Map<String ,Object> verificaRequisitiDematerializzazioneDealer(String tipoIntermediario, String codIntermediario){
        Map<String ,Object> returnValue = new Map<String ,Object>();
        
        try {
            VerificaRequisitiDemDealerInvoker.Request request = new VerificaRequisitiDemDealerInvoker.Request(tipoIntermediario, codIntermediario);
            VerificaRequisitiDemDealerInvoker.Response  response = VerificaRequisitiDemDealerInvoker.invoke(request);
            System.debug('#################### verificaRequisitiDematerializzazioneDealer '+response);

            VerificaRequisitiDemDealerInvoker.VerificaRequisitiDemDealerResponseDTO vRes= response.verificaRequisitiDematerializzazioneDealerResponse;
            System.debug('vRes--->'+vRes);
            if(vRes.desErrore.equals('Dealer già Dematerializzato')){
                returnValue.put('error', false);
            } else if (vRes.desErrore.equals('Dealer con canale D2D non DEMATERIALIZZABILE')) {
                returnValue.put('error', false);
                vRes.desErrore = 'Non Abilitato (verificare abilitazione D2D)';
            } else {
                returnValue.put('error', false);
                vRes.desErrore = 'Non Abilitato';
            }

            returnValue.put('demPasscom', vRes);
        } catch (Exception e) {
            returnValue.put('error', true);
            System.debug('#################### errorLog '+e.getMessage());
            System.debug('#################### errorLog '+e.getStackTraceString() );
        }

        return returnValue;
    }

     @AuraEnabled
    public static String unitaAffari(String codiceCliente, String ocsAreaId){
        System.debug('codice cliente -->'+codiceCliente);
        List<GUA_Queue_Assigment__c> queueAssignements = [SELECT Id, Q281__c, Q285__c, Q286__c, Q287__c, IsActive__c FROM GUA_Queue_Assigment__c WHERE IsActive__c = true];
        String groupName='';

        if (!queueAssignements.isEmpty()) {
            if (queueAssignements.size() == 1) {
                List<String> q281List = new List<String>();
                List<String> q285List = new List<String>();
                List<String> q286List = new List<String>();
                List<String> q287List = new List<String>();
                GUA_Queue_Assigment__c queueAssignement = queueAssignements[0];
                Map<String, Object> queueAssignementMap = (Map<String, Object>) JSON.deserializeUntyped(JSON.serialize(queueAssignement));
                Set<String> queueAssigkey = queueAssignementMap.keySet();
                if (queueAssigkey.contains('Q281__c')) {
                    q281List =  ((String) queueAssignementMap.get('Q281__c')).split(';');
                }
                if (queueAssigkey.contains('Q285__c')) {
                    q285List = ((String) queueAssignementMap.get('Q285__c')).split(';');
                }
                if (queueAssigkey.contains('Q286__c')) {
                    q286List = ((String) queueAssignementMap.get('Q286__c')).split(';');
                }
                if (queueAssigkey.contains('Q287__c')) {
                    q287List = ((String) queueAssignementMap.get('Q287__c')).split(';');
                }
                if (String.isNotBlank(ocsAreaId)) {
                            
                    if (q281List.contains(ocsAreaId)) {
                        groupName = 'Q281';
                    } else if(q285List.contains(ocsAreaId)) {
                        groupName = 'Q285';
                    } else if(q286List.contains(ocsAreaId)) {
                        groupName = 'Q286';
                    } else if(q287List.contains(ocsAreaId)) {
                        groupName = 'Q287';
                    }
                }

            } else {
                            System.debug('ERRORE--> MULTI CONFIGURAZIONE QUEUE ASSIGNMENT');
                }
            }
        List<Group> unitaAffariGroup = [SELECT Id, Name, DeveloperName FROM Group WHERE DeveloperName = :groupName];
        if(unitaAffariGroup.size()==0) return null;
        return unitaAffariGroup[0].Name;
    }



}