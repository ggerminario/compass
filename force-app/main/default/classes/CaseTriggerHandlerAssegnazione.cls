public without sharing class CaseTriggerHandlerAssegnazione extends TriggerHandler{
    
    //check della possibilità di assegnare solo una persona del proprio ufficio
    public override void beforeUpdate() {
        Map<Id,Case> newMap =(Map<Id,Case>)Trigger.newMap;
        Map<Id,Case> oldMap =(Map<Id,Case>)Trigger.oldMap;
        //get lstUser from case
        List<Id> lstUser=new List<Id>();
        for(Case c : newMap.values()) lstUser.add(c.Owner_User__c);
        //map user 
        Map<Id,User> userRoleMap=new Map<Id,User>([select id,UserRoleId from User where id in :lstUser]);
        
        Set<Id> targetUserRoleSet=new Set<Id>();
        for(Id caseId : newMap.keySet()){
            Case newCase=newMap.get(caseId);
            //verifica che l'owner sia veramente cambiato
            if(newCase.Owner_User__c!=null && newCase.Owner_User__c!=oldMap.get(caseId).Owner_User__c) {
                if( userRoleMap.get(newCase.Owner_User__c).UserRoleId==null) 
                    newCase.addError('L\' utente selezionato '+newCase.Owner_User__r.Name+' non ha un ruolo associato\n Non è pertanto possibile effettuare l\'assegnazione');
                else
                    targetUserRoleSet.add(userRoleMap.get(newCase.Owner_User__c).UserRoleId);
            }
        }                             
        if(targetUserRoleSet.size()>0) checkRoleAssegnazione(targetUserRoleSet);
    }

    public override void beforeInsert() {
       //TODO capire se questa validazione deve essere fatta anche in inserimento
    }

    private void checkRoleAssegnazione(Set<Id> targetUserRoleSet){
        //verifico che il ruolo di targetUser sia lo stesso o subordinato di quello di User
        Id loggedUserRoleId = Userinfo.getUserRoleId(); //ruolo dell'utente loggato              
        //se i ruoli individuati sono lo stesso dell'utente ho finito       
        system.debug('--target role set '+targetUserRoleSet.size()) ;
        system.debug('--loggeduser RoleId '+loggedUserRoleId) ;
        system.debug('--target role set contains '+targetUserRoleSet.contains(loggedUserRoleId)) ;
        system.debug('--target role set contains '+targetUserRoleSet) ;
        if(targetUserRoleSet.size()==1 && targetUserRoleSet.contains(loggedUserRoleId) ) return;

        //occorre verificare se i ruoli sono subordinati
        // STEP 1 carico la mappa dei ruoli        
		Map<Id, UserRole> mapRole = new Map<Id, UserRole>([SELECT id, name,DeveloperName, ParentRoleId FROM UserRole ]);
                                                                //where id in :targetUserRoleSet]);
        // STEP 2 cerco per ciascun ruolo risalendo se appartiene alla gerarchia
        //ricerca gerarchia del  ruolo utente...l'utente stesso fa parte della sua gerarchia
        for(Id userRoleId : targetUserRoleSet){
            List<Id> lstHierarchyRoleId=new List<Id>{userRoleId};
            Id parentRoleId=mapRole.get(userRoleId).ParentRoleId;
            while(parentRoleId!=null){
                lstHierarchyRoleId.add(parentRoleId);
                parentRoleId=mapRole.get(parentRoleId).ParentRoleId;            
            }
            system.debug('lstHierarchyRoleID '+lstHierarchyRoleId);
            // verifico se l'utente loggato si trova nella gerarchia del ruolo individuato
            if(! lstHierarchyRoleId.contains(loggedUserRoleId)) 
                for(Case c : (List<Case>)Trigger.new)
                c.addError('Il ruolo dell\'utente selezionato '+mapRole.get(userRoleId).name+' non è nella gerarchia di '+mapRole.get(loggedUserRoleId).name);
                //throw new AssegnazioneException('Il ruolo dell\'utente selezionato '+mapRole.get(userRoleId).name+' non è nella gerarchia di '+mapRole.get(loggedUserRoleId).name);
        }       

    }

    public class AssegnazioneException extends Exception{}
}