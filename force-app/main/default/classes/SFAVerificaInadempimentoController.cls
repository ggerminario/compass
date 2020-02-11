public class SFAVerificaInadempimentoController {
    
    @AuraEnabled
    public static List<Case> loadCase() {
        String userid = UserInfo.getUserId();
        List<Case> reclami = new list<case>();
        Group verificaInad = [Select id from Group where Developername = 'Q72'][0];
        User currentuser  = [Select id,DefaultQueueId__c,profileId from User where id = :userid];
        if(currentuser.profileid.equals(ProfileUtils.getAdminProfile()))
        {
            reclami = [SELECT Id, tipo_reclamo__c,Tipo_Prodotto__c,Numero_Reclamo__c, Subject,Categoria_Riferimento__r.Name,
                              DealerName__c,Tipo_Pratica__c,Branch__r.getCodice_Cliente__c,Branch__r.Name, Branch__c,
                              Inadempimento_Grave__c,NumeroPratica__c,Status,Owner.Name,
                              ClosedDate,Data_Ricezione__c,CreatedDate,Account.Name,Account.Codice_Fiscale__pc,
                              Account.getCodice_Cliente__c,Referenced_Company__c,
                              Stato_Pratica__c
                              FROM Case 
                              WHERE Ownerid = :verificaInad.Id];
        }
        else
        {
            reclami = [SELECT Id, tipo_reclamo__c,Tipo_Prodotto__c,Numero_Reclamo__c, Subject,Categoria_Riferimento__r.Name,
                              DealerName__c,Tipo_Pratica__c,Branch__r.getCodice_Cliente__c,Branch__r.Name, Branch__c,
                              Inadempimento_Grave__c,NumeroPratica__c,Status,Owner.Name,
                              ClosedDate,Data_Ricezione__c,CreatedDate,Account.Name,Account.Codice_Fiscale__pc,
                              Account.OCS_External_Id__c,Referenced_Company__c,
                              Stato_Pratica__c
                              FROM Case 
                              WHERE Ownerid = :verificaInad.Id AND Branch__r.OCS_External_Id__c =:currentUser.DefaultQueueId__c];
        }
            
        List<String> listaTipo = new List<String>();
        for(Case c : reclami) listaTipo.add(c.tipo_reclamo__c);
        List<CRM_RCL_Tipologia_Reclamo__mdt> tipologia = [SELECT Id, DeveloperName,External_Id__c, MasterLabel, Label, Descrizione__c FROM CRM_RCL_Tipologia_Reclamo__mdt where External_Id__c=:listaTipo and societa__c ='C'];
        Map<String, String> mappaTipo = new Map<String, String>();
        for(CRM_RCL_Tipologia_Reclamo__mdt temp : tipologia) mappaTipo.put(temp.External_Id__c, temp.Descrizione__c);
        for(Case c : reclami) c.tipo_reclamo__c = mappaTipo.get(c.tipo_reclamo__c);
        for(Case c : reclami) c.SuppliedCompany  = c.Branch__r.Name;
        return reclami;
    } 
    
    @AuraEnabled
    public static Case loadCaseCtrl(String caseId) {
        List<Case> reclami = [SELECT Id, owner.type, Tipo_Prodotto__c,ownerId, Numero_Reclamo__c, tipo_reclamo__c, Subject,Categoria_Riferimento__r.Name,
                              DealerName__c,Tipo_Pratica__c,Branch__r.getCodice_Cliente__c,Account.OCS_External_Id__c,
                              Inadempimento_Grave__c,NumeroPratica__c,Status,Owner.Name,
                              ClosedDate,Data_Ricezione__c,CreatedDate,Account.Name,Account.Codice_Fiscale__pc,
                              Account.getCodice_Cliente__c,Referenced_Company__c,
                              Stato_Pratica__c
                              FROM Case 
                              WHERE id = :caseId]; //coda verifica filiale
        String tipo = reclami[0].tipo_reclamo__c;
        CRM_RCL_Tipologia_Reclamo__mdt tipologia = [SELECT Id, DeveloperName, MasterLabel, Label, Descrizione__c FROM CRM_RCL_Tipologia_Reclamo__mdt where External_Id__c=:tipo and societa__c ='C'];
        reclami[0].tipo_reclamo__c = tipologia.Descrizione__c;
        reclami[0].Abbuono_Chiusura__c = false;
        if(reclami[0].Owner.Type == 'Queue'){
            Group filiale = [Select id, developerName From Group where id =:reclami[0].OwnerId];
            reclami[0].Abbuono_Chiusura__c = filiale.developerName.contains('F');
        }
        
        return reclami[0];
    } 
    
    @AuraEnabled
    public static void esitaCtrl(String ident, String note){
       /* Case c = [Select id, subject, parentId From Case Where id =:ident];
        Case parent = [Select id,F_T_Sent_Count__c, F_T_Received_Count__c, stage_inadempimento__c from case where id = :c.parentID];
        
        if(parent!=null && c.subject == 'Verifica Richiesta'){
           //XCSReclamiUtils.creaCorrispondenza(parent, note, null);
            parent.F_T_Sent_Count__c = parent.F_T_Sent_Count__c+1;
           if(parent.F_T_Received_Count__c == parent.F_T_Sent_Count__c && parent.F_T_Sent_Count__c==4) parent.Stage_Inadempimento__c = '4170';
               
        }
        if(note!=null && note.length() > 0){
           // XCSReclamiUtils.creaCorrispondenza(c, note, null);
        }
        
        c.status='Gestito';
        update c;*/
    }
    
    
    @AuraEnabled
    public static List<Attachment> getAttachments(Id caseId) {
        return [SELECT Id,Body,ContentType,Name,ParentId FROM Attachment WHERE ParentId=:caseId];
    }
    
    @AuraEnabled
    public static List<ContentNote> getNotes(Id caseId) {
        return XCSNoteUtils.getAllNotes(caseId);
    }
    
    @AuraEnabled
    public static List<EmailMessage> getEmails(Id caseId) {
        return [SELECT Id,MessageDate,Subject,TextBody,ToAddress FROM EmailMessage WHERE ParentId=:caseId];
    }
    
    @AuraEnabled
    public static List<ContentVersion> getFiles(Id caseId) {
        List<ContentVersion> result = new List<ContentVersion>();
        List<ContentDocumentLink> contentDocLinkList = [SELECT ContentDocumentId, LinkedEntityId  FROM ContentDocumentLink where LinkedEntityId=:caseId and LinkedEntity.Type='Case'];
        if (contentDocLinkList.size() > 0) {
            List<Id> docIdList = new List<Id>();
            for (ContentDocumentLink c : contentDocLinkList) {
                docIdList.add(c.ContentDocumentId);
            }
            System.debug('docIdList: '+docIdList);
            result = [SELECT Id,Title,CreatedDate FROM ContentVersion WHERE ContentDocumentId IN :docIdList AND IsLatest=true AND FileType != 'SNOTE' ORDER BY CreatedDate];
            
        }
        System.debug('files: '+result);
        return result;
    }
    
    @AuraEnabled
    public static void assignToCentroRecuperoLegale(Case myCase) {
        Id centroRecuperoLegaleId = [SELECT Id FROM Group WHERE Type='Queue' AND DeveloperName='Q57'].Id; //Reclami - Centro Recupero Legale
        myCase.OwnerId = centroRecuperoLegaleId;
        update myCase;
    }
    
    @AuraEnabled
    public static void saveAttachments(Id caseId, List<Attachment> allegati, Integer allegatiOriginali,String note) {
        	
        List<Id> listaDocumentId = new List<Id>();
        if(allegati.size() > 0){ 
            system.debug('@@@finalConfirm');
            listaDocumentId = XCSReclamiUtils.createFile(allegati, CaseId);
        }
        List<String> documentIdList = new List<String>();
        System.debug('@@@@@@@' + allegati);
        for(Attachment attach : allegati){ 
            if(attach.Description != null){
                String documentId = attach.Description.split('=').get(0);
                if(!documentIdList.contains(documentId)){
                    documentIdList.add(documentId);             
                }
            }
        }
        //String concatDocumentId = String.join(listaDocumentId,',');
        String testo = makeMessage(note);
        case c = new Case(Id=caseId);
        try{
            XCSReclamiUtils.creaCorrispondenza(c,testo,listaDocumentId);
            assignToCentroRecuperoLegale(c);
        }catch(exception e)
        {
         	  System.debug('********ERRORE:' + e); 
        }

    }
    @AuraEnabled
    public static String makeMessage(String messaggio){
        String underscores = '--------------------------------------------';
        String intestazione = 'Risposta Verifica Filiale';
        String res = 'Messaggio:' + messaggio != null ? messaggio : '' ;
        String totale = intestazione + '\n' + underscores + '\n' + res + '\n' + underscores;
        System.debug('feed item body: '+totale);
        return totale;
    }
}