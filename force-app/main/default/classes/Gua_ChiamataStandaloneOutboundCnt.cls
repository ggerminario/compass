/**
* @File Name          : Gua_ChiamataStandaloneOutboundCnt.cls
* @Description        : 
* @Author             : Mame Bousso kane
* @CreatedDate        : 22/10/2019
*/
public with sharing class Gua_ChiamataStandaloneOutboundCnt {
    @AuraEnabled
    public static Map<String ,Object> getFilialeByNameOrCodiceFiliale(String valueNameCF){
        Map<String ,Object> returnValue = new  Map<String ,Object>();
        returnValue.put('erreur', false);
        try {
            List<Account> filiales = Gua_ManageUnitaAffariQuery.getFiliales(valueNameCF);
            returnValue.put('resultat',filiales);
            if(filiales.size() == 0){
                returnValue.put('message', 'Nessun filiale trovato');
                throw new CustomException('Nessun filiale trovato');
            }
        } catch (Exception e) {
            System.debug('errorMessage Gua_ChiamataStandaloneOutboundCnt getFilialeByNameOrCodiceFiliale '+e.getMessage());
            returnValue.put('message', e.getMessage()+' '+e.getCause()+' '+e.getLineNumber());
            returnValue.put('erreur', true);
        }
        return returnValue;
    }
    
    /**
    * @Description        : retrieve xcs_description__c
    * @Author             : Khalidou I. Sow BA
    * @CreatedDate        : 09/11/2019
    */
    @AuraEnabled(cacheable=true)
    public static Map<String,Object> retrieveDispositionValues(String caseId){
        Map<String ,Object> response = new  Map<String ,Object>();
        String critera = '';
        response.put('error', false);
        
        try {
            System.debug('caseId is blank '+String.isBlank(caseId));
            List<Case> caseList = [SELECT ID,RECORDTYPE.NAME FROM CASE WHERE ID = :caseId];
            System.debug('##caseList## '+caseList);

            if (caseList.size() > 0) {
                if (caseList[0].RECORDTYPE.NAME == 'GUA Contact') {
                    critera = 'CTI Outbound';
                }else if(caseList[0].RECORDTYPE.NAME == 'GUA Inbound') {
                    critera ='CTI Inbound';
                }
            }
            System.debug('##critera## '+critera);

            List<XCS_Disposition__c>  dispositions = [SELECT ID,NAME, Categoria__c FROM XCS_Disposition__c WHERE PARENT__r.Name = 'Affari@Phone' AND PARENT__r.PARENT__r.Name= :critera];                
            if (dispositions.size()>0) {
                response.put('data',dispositions);
            }else{
                response.put('data',null);
            }
            System.debug('##dispositions## '+dispositions);
            
        } catch (Exception e) {
            System.debug('errorMessage   '+e.getMessage());
            response.put('message', e.getMessage()+' '+e.getCause()+' '+e.getLineNumber());
            response.put('error', true);
        }

        return response;
    } 


    /**
    * @Description        : create new task with  GUA_Task recordTypeId
    * @Author             : AD
    * @CreatedDate        : 28/11/2019
    */
 	@AuraEnabled
    public static Map<String ,Object> createTasks(List<String> idDispositions,String description,String caseId,Map<String,String> datiAggiuntivi, Boolean closedCase,String subject){
        Map<String ,Object> response = new  Map<String ,Object>();
        response.put('error', false);
        String str = '';

        try {
            //get xml static ressource
            StaticResource TemplateToUser = [SELECT Id, Body FROM StaticResource WHERE Name = 'TemplateToUser' LIMIT 1];
            String rsBody = TemplateToUser.Body.toString();

            System.debug('### resource body ### '+rsBody);
            System.debug('### resource datiAggiuntivi.keyset() ### '+datiAggiuntivi.keyset());           
            for( String aggKey : datiAggiuntivi.keyset() )
            {
                str = str + '<'+aggKey+'>'+datiAggiuntivi.get( aggKey )+'</'+aggKey+'>';
            }
            
            System.debug('### str str ### '+str);

            //create task
            List<Task> tasks = new List<Task>();
            for (String idDisp : idDispositions) {
                Task task = new Task();
                Id recordtypeId = Gua_Service.getRecordTypeId('GUA_Task', 'Task');
                task.recordtypeId = recordtypeId;
                task.Disposition__c = idDisp;
                task.Description = description;
                if(String.isNotBlank(description)){
                    task.Note__c = description.replace('<p>', '').replace('</p>','');
                }
                
                task.WhatId = caseId;
                task.UAF_XMLDatiAggiuntivi__c = rsBody.replace('$content',str);
                task.Subject = subject;
                task.Status='Completato';
                tasks.add(task);
            }
            insert tasks;
 
            if (closedCase) {
                Case c = [SELECT Id, Status FROM Case WHERE Id =: caseId];
                c.Status = 'Closed';
                update c;
                response.put('caseChiamata', c);
            }
                
            System.debug('##### new task #####  '+tasks);
            response.put('data',tasks);

        } catch (Exception e) {
            System.debug('errorMessage   '+e.getMessage());
            System.debug('errorCause   '+e.getCause());
            response.put('message', e.getMessage()+' '+e.getCause()+' '+e.getLineNumber());
            response.put('error', true);
        }
        return response;
    }  

    @AuraEnabled 
    public static Map<String ,Object>  getRecuperaUtenzeIntermediario(String role){
        Map<String ,Object> response = new  Map<String ,Object>();
         response.put('erreur', false);
        try {
            System.debug('role >> '+role); 
            role =role.replace('_Manager', '');
            role =role.replace('_', ' ');
            System.debug('role >> '+role); 
            List<User> utentente = [SELECT Id, Name, UserRole.Name, Profile.Name, UserType, Email, FirstName, LastName, EmployeeNumber FROM User
                                    WHERE  UserRole.Name=:role AND Profile.Name='Branch Employee'];
            System.debug('utentente >> '+utentente);            
            response.put('utentente', utentente);
        } catch (Exception e) {
            System.debug('errorMessage getRecuperaUtenzeIntermediario '+e.getMessage());
             response.put('message', e.getMessage()+' '+e.getCause()+' '+e.getLineNumber());
             response.put('erreur', true);
        }
     
        return response;
    }
    
    @AuraEnabled
    public static Map<String ,Object> getCoordinatore(String idFiliale){
         Map<String ,Object> returnValue = new  Map<String ,Object>();
        returnValue.put('erreur', false);
        returnValue.put('resultat','');
       try {
            if(idFiliale!=null){
                Account filiale = [SELECT Id,Name,CittaSede__pc,getCodice_Cliente__c,Provincia_Nascita__pc,Luogo_Nascita__pc,BillingAddress,ShippingStreet,
                                    ShippingCity, ShippingState, ShippingPostalCode, NameRoleReference__c,NameParentRoleReference__c, OCSAreaId__c 
                                    FROM Account WHERE Id=:idFiliale];
                //RecordType.Name='Branch'
                Map<String, Object> filialeMap = (Map<String, Object>) JSON.deserializeUntyped(JSON.serialize(filiale));
                if(filialeMap.keySet().contains('OCSAreaId__c')){
                     String area = 'COORD. AREA '+filiale.OCSAreaId__c;
                    User coordonatoreFiliale=[select id,name,profile.name,UserRole.Name from User
                                                    where  profile.name in ('Area Manager')
                                                    and UserRole.Name=:area limit 1];
                    if(coordonatoreFiliale.Id!=null){
                        returnValue.put('resultat',coordonatoreFiliale);
                    }
                }else {
                }
       }
       } catch (Exception e) {
            System.debug('errorMessage GUA_DettaglioDealerCnt getCapoFiliale '+e.getMessage());
             returnValue.put('message', e.getMessage()+' '+e.getCause()+' '+e.getLineNumber());
             returnValue.put('erreur', true);
       }
        return returnValue;
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

    
    public class CustomException extends Exception {}
}