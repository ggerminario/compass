global class RetentionPrestiti_ControlTaskBatch
{
	global static void execute()
    {
        date d = system.today().addDays(-5);
        RecordType rt = [Select id from RecordType where DeveloperName = 'Note' and SobjectType = 'XCS_Messaggio__c' ]; 
        String aliasUser = [select alias from user where id = :UserInfo.getUserId()].alias;
        List<XCS_Messaggio__c> lOCSNote = new List<XCS_Messaggio__c>();
        Group g = GroupUtils.getQueue('UNumeroBlu');
        List<Group> queueBranchList = GroupUtils.getQueueBranchList();
        List<Case> listActivityCase = CaseUtils.caseListForCategoryAndCategory(XCS_CategoriaUtil.OUTBOUND_CALLING_RETENTION,queueBranchList);
        Map<String,Case> caseAct = new Map<String,Case>(listActivityCase);
        Id r = RecordtypeUtil.getRecordType('Case','XCS_Post_Vendita');
        list<Case> listCaseToCreate = new List<Case>();
        String noteTemplate = XCS_TemplateUtils.getBody(CRMRetentionUtil.NOTE_RETENTION_CONTROL_TASK);
        Map<Integer,ContentNote> mapNoteCase = new Map<Integer,ContentNote>();
        Map<Integer,Case> caseRefe = new Map<Integer,Case>();
        List<Task> taskToUpdate = new List<Task>();
        List<Task> listTask = [Select id,disposition__r.External_Id__c,whatid,Status,Disposition__c,pratica__c,customer__c,Customer__r.getCodice_Cliente__c,Customer__r.FirstName,Customer__r.Lastname from Task where WhatId in :listActivityCase AND CreatedDate = :d];
        System.debug('*******' + listTask);
        Integer i = 0;
        for(Task tsk : listTask)
        {
            if(tsk.disposition__c == null || ! XCS_DispositionUtils.APPUNTAMENTO_FISSATO.equalsIgnoreCase(tsk.disposition__r.External_id__c))
            {
                System.debug('ECCOLOOOOO');
                List<String> toNoteTemplate = new List<String>();
                i++;
                tsk.status = 'Closed';
                taskToUpdate.add(tsk);
                case ca = new Case(recordtypeid = r ,Step_PV__c = '4',OwnerId = g.id ,numeroPratica__c = tsk.pratica__c,accountId = tsk.customer__c, Subject = 'Da Customer Service a Filiale', Categoria_Riferimento__r = new XCS_Categoria__c(External_id__c = XCS_CategoriaUtil.PV_DA_CUSTOMER_SERVICE_A_FILIALE));
                caseRefe.put(i,ca);
                toNoteTemplate.add(caseAct.get(tsk.whatid).branch__r.name);
                toNoteTemplate.add(tsk.Pratica__c);
                toNoteTemplate.add(tsk.Customer__r.getCodice_Cliente__c);
                toNoteTemplate.add(tsk.Customer__r.FirstName + ' ' + tsk.Customer__r.Lastname);
                String n = XCS_TemplateUtils.buildTemplate(noteTemplate,toNoteTemplate);
                ContentNote nota = new ContentNote();
        		nota.Title = 'Nota Di Sistema';
        		nota.Content = Blob.valueOf(n.escapeXML());
                mapNoteCase.put(i,nota);
                lOCSNote.add(OCSGestioneNoteInvoker.createOCSNote(rt,aliasUser,tsk.Customer__r.getCodice_Cliente__c ,tsk.Pratica__c ,'' , 'A', 'P',n ));
            }
        }
        if(!taskToUpdate.isEmpty())
        {
            update taskToUpdate;
        }
        if(!caseRefe.values().isEmpty())
        {
            insert caseRefe.values();
            insert mapNoteCase.values();
            List<ContentDocumentLink> lDL = new List<ContentDocumentLink>();
            for(Integer key : caseRefe.keyset())
            {
                lDL.add(new ContentDocumentLink(
                	contentDocumentId = mapNoteCase.get(key).id,
                    LinkedEntityId = caseRefe.get(key).id,
                    ShareType = 'I',
                    Visibility = 'AllUsers'
                ));
            }
            Insert lDL;
            if(!lOCSNote.isEmpty())
            {
                insert lOCSNote;
            }
        }   
    }
}