/**
 * @File Name          : GUA_Dettaglio_DealerCnt.cls
 * @Description        : 
 * @Author             : Khadim R Ndeye
 * @CreatedDate        : 24/10/2019
 */
 public with sharing class GUA_Dettaglio_FilialeCnt{
 @AuraEnabled
    public static Map<String ,Object> getCase(String idCase){
        Map<String ,Object> returnValue = new  Map<String ,Object>();
        returnValue.put('erreur', false);
       try {
           Case cse = Gua_ManageUnitaAffariQuery.getFilaliByCase(idCase);
           System.debug('sucessMessage Gua_ManageUnitaAffariCnt Gua_ManageUnitaAffariCnt '+ cse);
           if(cse.Id == null){
               throw new CustomException('Nessun case trovato');
           }
           returnValue.put('data',cse);
       } catch (Exception e) {
            System.debug('errorMessage Gua_ManageUnitaAffariCnt Gua_ManageUnitaAffariCnt '+e.getMessage());
             returnValue.put('message', e.getMessage()+' '+e.getCause()+' '+e.getLineNumber());
             returnValue.put('erreur', true);
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
    @AuraEnabled 
    public static Map<String ,Object>  getRecuperaUtenzeIntermediario(String role){
        Map<String ,Object> response = new  Map<String ,Object>();
         response.put('erreur', false);
        try {
            System.debug('role >> '+role); 
            role =role.replace('_', ' ');
            String roleEmployee=role;
            if(role.contains('Manager')){
                roleEmployee=role.replace(' Manager', '');
            }
            System.debug('role >> '+role+'/// roleEmployee '+roleEmployee); 
            List<User> utentente = [SELECT Id, Name, Alias, UserRole.Name, Profile.Name, UserType, Email, FirstName, LastName, EmployeeNumber FROM User
                                    WHERE  UserRole.Name in(:role,:roleEmployee) AND Profile.Name in (:PermissionUtils.BRANCH_MANAGER, :PermissionUtils.BRANCH_EMPLOYEE) 
                                    AND IsActive=true order By Profile.Name desc];
            System.debug('utentente >> '+utentente);            
            response.put('utentente', utentente);
        } catch (Exception e) {
            System.debug('errorMessage GUA_Dettaglio2ContactCnt getRecuperaUtenzeIntermediario '+e.getMessage());
             response.put('message', e.getMessage()+' '+e.getCause()+' '+e.getLineNumber());
             response.put('erreur', true);
        }
     
        return response;
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
                                    FROM Account WHERE Id=:idFiliale];
                //RecordType.Name='Branch'
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
     public class CustomException extends Exception {}
}