public without sharing class  EventHandler extends TriggerHandler{

public override void afterInsert() {   
        System.debug('_______EventHandler.afterInsert____START');       
                
        Map<String,String> mapBranchEvent = new Map<String,String> (); 
        Map<String,Event> mapResourceEvent = new Map<String,Event> (); 
        Set<Id> desks = new Set<Id>();
        Set<Id> setAccount = new Set<Id>();
        for(Event ev : (List<Event>)Trigger.new){
            if('Appuntamento'.equals(ev.Type)){
                desks.add(ev.Desk__c);
            }
            if('Appuntamento'.equals(ev.Type) && false == ev.IsChild){
                setAccount.add(ev.AccountId);
            }
        }

        if(desks.size()>0){
            //recupera i desk degli appuntamenti
            Map<String,XCS_Desk__c> deskMap = new Map<String,XCS_Desk__c>([SELECT ID,Branch__c,Branch__r.OCS_External_Id__c,DeskName__c FROM XCS_Desk__c WHERE ID IN :desks AND Branch__c != NULL]);
            if(deskMap.size()> 0){
                
                for(Event ev : (List<Event>)Trigger.new){
                    if('Appuntamento'.equals(ev.Type) && deskMap.containsKey(ev.Desk__c)){
                            mapBranchEvent.put(deskMap.get(ev.Desk__c).Branch__c,ev.Id);
                            XCS_Desk__c desk = deskMap.get(ev.Desk__c);
                            mapResourceEvent.put(desk.Branch__r.OCS_External_Id__c+'-'+desk.DeskName__c,ev);
                    }
                }
            }
        }
       
                       
        
        if(mapResourceEvent.size()>0){
            ShareBranchCalendar.shareResources(mapResourceEvent);
        }

        if(mapBranchEvent.size()>0){
            ShareBranchCalendar.future_shareUser(mapBranchEvent);
        }


        //elimina invii successivi +24/+72 per quel cliente (richieste online)
        if(setAccount.size()>0){
            System.debug('***cerco in future, richieste online per i clienti ->'+setAccount);
            CGMWSUtils_1_0.futureAbortJobRicontattoFromAccount(setAccount,'cronExp');
        }
        

        System.debug('_______EventHandler.afterInsert____DONE');  

        
    }

    public override void beforeInsert() {
        System.debug('_______EventHandler.beforeInsert____START');
        
        List<Event> lstEvent=(List<Event>)Trigger.new;
        Boolean isSFAUser=isSFAUser();
        List<Id> lstAccountId=new List<Id>();
        for(Event e : lstEvent){
            if(String.isBlank(e.Canale_Acquisizione__c)) {
                //popolare il canale
                if(isSFAUser) e.Canale_Acquisizione__c='agency';
                else e.Canale_Acquisizione__c='call center';
            }
           lstAccountId.add(e.customer__c);
        }
        //get account info
        
        Map<Id,Account> mapAccount=new Map<Id,Account>([select id, firstname,lastname,phone from account where id in :lstAccountId]);
//Account.FirstName +' '+ Account.LastName+' '+Account.Phone
        for(Event e: lstEvent)
            if(e.type=='Appuntamento')
            e.subject=mapAccount.get(e.customer__c).lastName+' '+mapAccount.get(e.customer__c).firstName+' '+mapAccount.get(e.customer__c).phone;

        System.debug('_______EventHandler.beforeInsert____DONE');  
    }
  
    private static boolean isSFAUser(){
        Map<Id,UserRole> mapUserRole=new Map<Id,UserRole>([select id,name,parentroleid from userrole]);      
        Id roleId=UserInfo.getUserRoleId();
        //ciclo sui ruoli padri fin tanto che non arrivo al nodo SFA se esiste        
        while (roleId!=null && mapUserRole.get(roleId).name != 'SFA' )  roleId=mapUserRole.get(roleId).parentroleid;
        
        
       return (roleId!=null) ;

    }
    public override void beforeUpdate() {
        System.debug('_______EventHandler.beforeUpdate____START');
        //GESTIONE MODIFICA APPUNTAMENTO - START
            System.debug('new.Stato_Azione__c-->'+((Event)Trigger.new[0]).Stato_Azione__c);
            System.debug('new.Stato_Azione__c-->'+((Event)Trigger.old[0]).Stato_Azione__c);

        /*Set<ID> desks = new Set<ID>();
        for(Event ev : (List<Event>)Trigger.new){
            desks.add(ev.Desk__c);
        }  
        Map<Id,XCS_Desk__c> deskMap = new Map<Id,XCS_Desk__c>([SELECT ID,Branch__r.OCS_External_Id__c FROM XCS_Desk__c where id in:desks]);     
        //check disponibilità da drag and drop
        for(Event ev : (List<Event>)Trigger.new){
            if(ev.isChild == false){
                Datetime startDate = ev.StartDateTime;
                System.debug('ev.start->'+startDate.format('yyyyMMdd'));
                System.debug('ocs external:'+deskMap.get(ev.Desk__c).Branch__r.OCS_External_Id__c);
                Set<Time> disponibilita = AppuntamentoDomainWS.appuntamentoDisponilitaCompleta(deskMap.get(ev.Desk__c).Branch__r.OCS_External_Id__c,startDate.format('yyyyMMdd'));
                System.debug('disponibilita-->'+disponibilita);
                if(!disponibilita.contains(startDate.timeGmt().addHours(1))){
                    ev.addError('Non è possibile modificare l\'appuntamento. Verifica la disponibilità della filiale e riprova.');
                }
            }
        //GESTIONE MODIFICA APPUNTAMENTO - END        
        }*/
        System.debug('_______EventHandler.beforeUpdate____DONE'); 
    }

    public override void afterUpdate() {
        System.debug('_______EventHandler.afterUpdate____START');       
        // --START-- elimina tutti gli elementi correlati all'appuntamento annullato 
        Set<Id> eventToDeleteSons = new Set<Id>();
        System.debug('nuovo stato azione-->'+((Event)Trigger.new[0]).Stato_Azione__c);
        System.debug('vecchio stato azione-->'+((Event)Trigger.old[0]).Stato_Azione__c);
        Integer cont = 0;
        for(Event ev : (List<Event>)Trigger.new){
            if('Appuntamento'.equals(ev.Type)  
                && ((Event)Trigger.new[cont]).Stato_Azione__c!=((Event)Trigger.old[0]).Stato_Azione__c 
                && 'Non presentato/Annullato'.equals(((Event)Trigger.new[cont]).Stato_Azione__c)){
                eventToDeleteSons.add(ev.Id);
            }
            cont ++;
        }

        if(eventToDeleteSons != null && eventToDeleteSons.size()>0){
            //elimina gli eventi correlati all'appuntamento annullato
            List<EventRelation> eventSons = [select id,EventId 
                                                FROM EventRelation where EventId in :eventToDeleteSons 
                                                    AND IsInvitee = true];
            if(eventSons!=null && eventSons.size()>0)
                delete eventSons;
        }

        // --END-- elimina tutti gli elementi correlati all'appuntamento annullato 

        System.debug('_______EventHandler.afterUpdate____DONE'); 
    }

    public override void beforeDelete() {
        System.debug('_______EventHandler.beforeDelete____START');       
                
        
        System.debug('_______EventHandler.beforeDelete____DONE'); 
    }
}