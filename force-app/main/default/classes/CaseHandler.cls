/**
 * @File Name          : CaseHandler.cls
 * @Description        : 
 * @Author             : Unknown
 * @Group              : 
 * @Last Modified By   : Andrea Vanelli
 * @Last Modified On   : 31/1/2020, 15:23:22
 * @Modification Log   : 
 * Ver       Date            Author      		    Modification
 * 1.0    30/1/2019   Unkonwn     Initial Version
**/
public class CaseHandler extends TriggerHandler {

    public override void beforeUpdate() {
		System.debug('dentro beforeUpdate');
        final TriggerData ticketingCsTentativoTriggerData = createTicketingCsTentativoTriggerData();
        if (TriggerData.isData(ticketingCsTentativoTriggerData)) {
            TicketingCsCaseHandler ticketingCsTentativoCaseHandler = new TicketingCsCaseHandler(ticketingCsTentativoTriggerData);
            ticketingCsTentativoCaseHandler.gestisciClienteNonTrovatoByNum();
        }

        final TriggerData ticketingCsRecallTriggerData = createTicketingCsRecallTriggerData();
        if (TriggerData.isData(ticketingCsRecallTriggerData)) {
            TicketingCsCaseHandler ticketingCsRecallCaseHandler = new TicketingCsCaseHandler(ticketingCsRecallTriggerData);
            ticketingCsRecallCaseHandler.gestisciRichiamaCliente();
        }

        final TriggerData ticketingCsClosedTriggerData = createTicketingCsClosedTriggerData();
        if (TriggerData.isData(ticketingCsClosedTriggerData)) {
            TicketingCsCaseHandler ticketingCsCloseCaseHandler = new TicketingCsCaseHandler(ticketingCsClosedTriggerData);
            ticketingCsCloseCaseHandler.gestisciChiusuraCase();
        }
/*
        final TriggerData ticketingClosedTriggerData = createTicketingClosedTriggerData();
        if (TriggerData.isData(ticketingClosedTriggerData)) {
            TicketingCaseHandler ticketingCloseCaseHandler = new TicketingCaseHandler(ticketingClosedTriggerData);
            ticketingCloseCaseHandler.addChiusuraFeed();
        }
        */
        final TriggerData ticketingCsInvioSMSTriggerData = createTicketingCsInvioSMSTriggerData();
        if (TriggerData.isData(ticketingCsInvioSMSTriggerData)) {
            TicketingCsCaseHandler ticketingCsInvioSMSCaseHandler = new TicketingCsCaseHandler(ticketingCsInvioSMSTriggerData);
            ticketingCsInvioSMSCaseHandler.handleInviaSMS();
        }
        
        final TriggerData ticketingSollecitoTriggerData = createTicketingSollecitoData();
        if (TriggerData.isData(ticketingSollecitoTriggerData)) {
            TicketingCaseHandler ticketingSollecitoCaseHandler = new TicketingCaseHandler(ticketingSollecitoTriggerData);
            ticketingSollecitoCaseHandler.addSollecitoFeed();
        }

        final TriggerData ticketingAnnulloTriggerData = createTicketingAnnulloData();
        if (TriggerData.isData(ticketingAnnulloTriggerData)) {
            TicketingCaseHandler ticketingAnnulloCaseHandler = new TicketingCaseHandler(ticketingAnnulloTriggerData);
            ticketingAnnulloCaseHandler.addAnnulloFeed();
        }

        
        
    }

    public override void beforeInsert() {
        System.debug('dentro beforeInsert');
        final TriggerData ticketingTriggerData = createTicketingTriggerData();
        if (TriggerData.isData(ticketingTriggerData)) {
            TicketingCaseHandler ticketingCaseHandler = new TicketingCaseHandler(ticketingTriggerData);
            ticketingCaseHandler.setBranch();
        }
		
        final TriggerData ticketingCsTriggerData = createTicketingCsTriggerData();
        if (TriggerData.isData(ticketingCsTriggerData)) {
            TicketingCsCaseHandler ticketingCsCaseHandler = new TicketingCsCaseHandler(ticketingCsTriggerData);
            System.debug('DP ticketingCsTriggerData: '+ticketingCsTriggerData);
            ticketingCsCaseHandler.updateDispositionAndCategory();
        }
    }

    public override void afterInsert() {
		System.debug('dentro afterInsert');

/************************* */
/*        final TriggerData emailToCaseRouterTriggerData = createEmailToCaseRouterTriggerData();
        if (TriggerData.isData(emailToCaseRouterTriggerData)) {
            EmailToCaseRouter emailToCaseRouterCaseHandler = new EmailToCaseRouter(emailToCaseRouterTriggerData);
            emailToCaseRouterCaseHandler.route();
        } */
/************************* */


        final TriggerData ticketingTriggerData = createTicketingTriggerData();
        if (TriggerData.isData(ticketingTriggerData)) {
            TicketingCaseHandler ticketingCaseHandler = new TicketingCaseHandler(ticketingTriggerData);
            ticketingCaseHandler.insertTeamMemberCase();
            ticketingCaseHandler.insertNotaOCSBorg();
            ticketingCaseHandler.caseShare();
            ticketingCaseHandler.parentChangeStatusOnInsert();
        } 
            /**
             * per Case non di Ticketing, gestione share:
             * il Case creato va condiviso con il ruolo e subordinato del 
             * creatore del case
             */
            CaseUtils.shareRoleAndSubordinates(Trigger.New,'Edit');
        
        
        final TriggerData ticketingCsTriggerData = createTicketingCsTriggerData();
        if (TriggerData.isData(ticketingCsTriggerData)) {
            TicketingCsCaseHandler ticketingCsCaseHandler = new TicketingCsCaseHandler(ticketingCsTriggerData);
            System.debug('DP ticketingCsTriggerData: '+ticketingCsTriggerData);
            ticketingCsCaseHandler.updateSuPrimoInserimento();
        }


    }

    public override void afterUpdate() {
		System.debug('dentro afterUpdate');
        /*final TriggerData ticketingChangeOwnerTriggerData = createTicketingChangeOwnerTriggerData();
        if (TriggerData.isData(ticketingChangeOwnerTriggerData)) {
            TicketingCaseHandler ticketingChangeOwnerCaseHandler = new TicketingCaseHandler(ticketingChangeOwnerTriggerData);
            ticketingChangeOwnerCaseHandler.caseShare();
        }*/
        final TriggerData changeOwnerTriggerData = changeOwnerTriggerData();
        if (TriggerData.isData(changeOwnerTriggerData)) {
            TicketingCaseHandler changeOwnerCaseHandler = new TicketingCaseHandler(changeOwnerTriggerData);
            changeOwnerCaseHandler.caseShare();
        }

        final TriggerData ticketingTriggerData = createTicketingTriggerData();
        if (TriggerData.isData(ticketingTriggerData)) {
            TicketingCaseHandler ticketingCaseHandler = new TicketingCaseHandler(ticketingTriggerData);
            ticketingCaseHandler.parentChangeStatusOnUpdate();
            
        }

        final TriggerData ticketingChangeCategoryTriggerData = createTicketingChangeCategoryData();
        if (TriggerData.isData(ticketingChangeCategoryTriggerData)) {
            TicketingCaseHandler ticketingChangeCategoryCaseHandler = new TicketingCaseHandler(ticketingChangeCategoryTriggerData);
            ticketingChangeCategoryCaseHandler.changeCategory();
        }

        final TriggerData ticketingInfoAggiuntiveTriggerData = createTicketingInfoAggiuntiveData();
        if (TriggerData.isData(ticketingInfoAggiuntiveTriggerData)) {
            TicketingCaseHandler ticketingInfoAggiuntiveCaseHandler = new TicketingCaseHandler(ticketingInfoAggiuntiveTriggerData);
            ticketingInfoAggiuntiveCaseHandler.infoAggiuntive();
        }

        
/*
        final TriggerData ticketingClosedAndChangeStatusTriggerData = createTicketingClosedAndChangeStatusTriggerData();
        if (TriggerData.isData(ticketingClosedAndChangeStatusTriggerData)) {
            TicketingCaseHandler ticketingClosedAndChangeStatusCaseHandler = new TicketingCaseHandler(ticketingClosedAndChangeStatusTriggerData);
            ticketingClosedAndChangeStatusCaseHandler.changeChildCaseStatusOnClose();
        }
*/

        final TriggerData richOnlineDiscordanzaTriggerData = createRichOnlineDiscordanzaData();
        if (TriggerData.isData(richOnlineDiscordanzaTriggerData)) {
            RichiesteOnlineCaseHandler richOnlineDiscordanzaCaseHandler = new RichiesteOnlineCaseHandler(richOnlineDiscordanzaTriggerData);
            richOnlineDiscordanzaCaseHandler.discordanza();
        }

    }

    private TriggerData createTicketingTriggerData() {
        final List<Case> ticketingCaseList = new List<Case>();
        for (Case caseItem : (List<Case>) trigger.new) {
            if (TKT_RECORDTYPE_ID == caseItem.RecordTypeId) ticketingCaseList.add(caseItem);
        }
        System.debug('Trovati ' + ticketingCaseList.size() + ' Case di Ticketing');
        TriggerData ticketingTriggerData = null;
        if (ticketingCaseList.size() > 0) {
            ticketingTriggerData = new TriggerData(ticketingCaseList, Trigger.oldMap, Trigger.newMap);
        }
        return ticketingTriggerData;
    }

    private TriggerData createTicketingChangeOwnerTriggerData() {   
        final List<Case> ticketingChangeOwnerCaseList = new List<Case>();
        for (Case caseItem : (List<Case>) trigger.new)
        {
            final Id caseId = caseItem.Id;
            final Case oldCase = (Case) Trigger.oldMap.get(caseId);
            final Case newCase = (Case) Trigger.newMap.get(caseId);
            
            if (TKT_RECORDTYPE_ID == caseItem.RecordTypeId && oldCase.OwnerId != newCase.OwnerId) 
                ticketingChangeOwnerCaseList.add(newCase);
        }
        System.debug('Trovati ' + ticketingChangeOwnerCaseList.size() + ' Case di Ticketing con cambio owner');
        TriggerData ticketingTriggerData = null;
        if (ticketingChangeOwnerCaseList.size() > 0) {
            ticketingTriggerData = new TriggerData(ticketingChangeOwnerCaseList, Trigger.oldMap, Trigger.newMap);
        }
        return ticketingTriggerData;
    }

    private TriggerData changeOwnerTriggerData() {   
        final List<Case> changeOwnerCaseList = new List<Case>();
        for (Case caseItem : (List<Case>) trigger.new)
        {
            final Id caseId = caseItem.Id;
            final Case oldCase = (Case) Trigger.oldMap.get(caseId);
            final Case newCase = (Case) Trigger.newMap.get(caseId);
            
            if (oldCase.OwnerId != newCase.OwnerId) 
                changeOwnerCaseList.add(newCase);
        }
        System.debug('Trovati ' + changeOwnerCaseList.size() + ' Case con cambio owner');
        TriggerData triggerData = null;
        if (changeOwnerCaseList.size() > 0) {
            triggerData = new TriggerData(changeOwnerCaseList, Trigger.oldMap, Trigger.newMap);
        }
        return triggerData;
    }

    public TriggerData createTicketingClosedAndChangeStatusTriggerData() {
        final List<Case> ticketingCaseList = new List<Case>();
        for (Case caseItem : (List<Case>) trigger.new) {
            final Id caseId = caseItem.Id;
            final Case oldCase = (Case) Trigger.oldMap.get(caseId);
            final Case newCase = (Case) Trigger.newMap.get(caseId);

            if (TKT_RECORDTYPE_ID == caseItem.RecordTypeId && newCase.isClosed && newCase.Status <> oldCase.Status) 
                ticketingCaseList.add(caseItem);
        }
        System.debug('Trovati ' + ticketingCaseList.size() + ' Case di Ticketing chiusi e con cambio stato');
        TriggerData ticketingTriggerData = null;
        if (ticketingCaseList.size() > 0) {
            ticketingTriggerData = new TriggerData(ticketingCaseList, Trigger.oldMap, Trigger.newMap);
        }
        return ticketingTriggerData;
    }

    private TriggerData createTicketingCsTriggerData() {   
        final List<Case> ticketingCsCaseList = new List<Case>();
        
        for (Case caseItem : (List<Case>) trigger.new) {
            if (TKTCS_RECORDTYPE_ID == caseItem.RecordTypeId) ticketingCsCaseList.add(caseItem);
        }
        System.debug('Trovati ' + ticketingCsCaseList.size() + ' Case di TicketingCS');
        TriggerData ticketingCsTriggerData = null;
        if (ticketingCsCaseList.size() > 0) {
            ticketingCsTriggerData = new TriggerData(ticketingCsCaseList, Trigger.oldMap, Trigger.newMap);
        }
        return ticketingCsTriggerData;
    }

    private TriggerData createTicketingCsRecallTriggerData() {   
        final List<Case> ticketingCsCaseList = new List<Case>();

        for (Case caseItem : (List<Case>) trigger.new) {
            final Id caseId = caseItem.Id;
            final Case oldCase = (Case) Trigger.oldMap.get(caseId);
            final Case newCase = (Case) Trigger.newMap.get(caseId);

            if (TKTCS_RECORDTYPE_ID == caseItem.RecordTypeId && oldCase.RecallDate__c <> newCase.RecallDate__c && newCase.TentativoNum__c == oldCase.TentativoNum__c)
                ticketingCsCaseList.add(caseItem);
        }
        System.debug('Trovati ' + ticketingCsCaseList.size() + ' Case di TicketingCS di Richiamo Cliente');
        TriggerData ticketingCsTriggerData = null;
        if (ticketingCsCaseList.size() > 0) {
            ticketingCsTriggerData = new TriggerData(ticketingCsCaseList, Trigger.oldMap, Trigger.newMap);
        }
        return ticketingCsTriggerData;
    }

    private TriggerData createTicketingCsClosedTriggerData() {   
        final List<Case> ticketingCsCaseList = new List<Case>();

        for (Case caseItem : (List<Case>) trigger.new) {
            final Id caseId = caseItem.Id;
            final Case oldCase = (Case) Trigger.oldMap.get(caseId);
            final Case newCase = (Case) Trigger.newMap.get(caseId);
			System.debug('oldCase status: '+ oldCase.Status);
            System.debug('newCase status: ' + newCase.Status);
            if (TKTCS_RECORDTYPE_ID == caseItem.RecordTypeId && oldCase.Status <> newCase.Status && newCase.Status == 'Closed')
                ticketingCsCaseList.add(caseItem);
        }
        System.debug('Trovati ' + ticketingCsCaseList.size() + ' Case di TicketingCS che aggiornano lo stato a Closed');
        TriggerData ticketingCsTriggerData = null;
        if (ticketingCsCaseList.size() > 0) {
            ticketingCsTriggerData = new TriggerData(ticketingCsCaseList, Trigger.oldMap, Trigger.newMap);
        }
        return ticketingCsTriggerData;
    }

    private TriggerData createTicketingClosedTriggerData() {   
        final List<Case> ticketingCaseList = new List<Case>();

        for (Case caseItem : (List<Case>) trigger.new) {
            final Id caseId = caseItem.Id;
            final Case oldCase = (Case) Trigger.oldMap.get(caseId);
            final Case newCase = (Case) Trigger.newMap.get(caseId);
			System.debug('oldCase status: '+ oldCase.Status);
            System.debug('newCase status: ' + newCase.Status);
            if (TKT_RECORDTYPE_ID == caseItem.RecordTypeId && oldCase.Status <> newCase.Status && newCase.Status == 'Closed')
                ticketingCaseList.add(caseItem);
        }
        System.debug('Trovati ' + ticketingCaseList.size() + ' Case di Ticketing che aggiornano lo stato a Closed');
        TriggerData ticketingTriggerData = null;
        if (ticketingCaseList.size() > 0) {
            ticketingTriggerData = new TriggerData(ticketingCaseList, Trigger.oldMap, Trigger.newMap);
        }
        return ticketingTriggerData;
    }

    private TriggerData createTicketingCsTentativoTriggerData() {   
        final List<Case> ticketingCsCaseList = new List<Case>();

        for (Case caseItem : (List<Case>) trigger.new) {
            final Id caseId = caseItem.Id;
            final Case oldCase = (Case) Trigger.oldMap.get(caseId);
            final Case newCase = (Case) Trigger.newMap.get(caseId);

            if (TKTCS_RECORDTYPE_ID == caseItem.RecordTypeId){ 
                if ((oldCase.TentativoNum__c == null && newCase.TentativoNum__c <> null) ||
                 (newCase.TentativoNum__c == oldCase.TentativoNum__c + 1))
                ticketingCsCaseList.add(caseItem);
            }
        }
        System.debug('Trovati ' + ticketingCsCaseList.size() + ' Case di TicketingCS con aumento di TentativoNum');
        TriggerData ticketingCsTriggerData = null;
        if (ticketingCsCaseList.size() > 0) {
            ticketingCsTriggerData = new TriggerData(ticketingCsCaseList, Trigger.oldMap, Trigger.newMap);
        }
        return ticketingCsTriggerData;
    }
    
    private TriggerData createTicketingCsInvioSMSTriggerData() {   
        final List<Case> ticketingCsCaseList = new List<Case>();

        for (Case caseItem : (List<Case>) trigger.new) {
            final Id caseId = caseItem.Id;
            final Case oldCase = (Case) Trigger.oldMap.get(caseId);
            final Case newCase = (Case) Trigger.newMap.get(caseId);

            if (TKTCS_RECORDTYPE_ID == caseItem.RecordTypeId && newCase.SMSInviatiNum__c <> oldCase.SMSInviatiNum__c && newCase.TentativoNum__c == oldCase.TentativoNum__c) {
                ticketingCsCaseList.add(caseItem);
            }
        }
        System.debug('Trovati ' + ticketingCsCaseList.size() + ' Case di TicketingCS con aumento di SMSInviatiNum');
        TriggerData ticketingCsTriggerData = null;
        if (ticketingCsCaseList.size() > 0) {
            ticketingCsTriggerData = new TriggerData(ticketingCsCaseList, Trigger.oldMap, Trigger.newMap);
        }
        return ticketingCsTriggerData;
    }

    private TriggerData createTicketingSollecitoData() {
        final List<Case> ticketingCaseList = new List<Case>();
        for (Case caseItem : (List<Case>) trigger.new) {
            final Id caseId = caseItem.Id;
            final Case oldCase = (Case) Trigger.oldMap.get(caseId);
            final Case newCase = (Case) Trigger.newMap.get(caseId);
            
            if (TKT_RECORDTYPE_ID == caseItem.RecordTypeId && newCase.Tentativo__c <> oldCase.Tentativo__c) 
                ticketingCaseList.add(caseItem);
        }
        System.debug('Trovati ' + ticketingCaseList.size() + ' Case di Sollecito');
        TriggerData ticketingTriggerData = null;
        if (ticketingCaseList.size() > 0) {
            ticketingTriggerData = new TriggerData(ticketingCaseList, Trigger.oldMap, Trigger.newMap);
        }
        return ticketingTriggerData;
    }
    
    private TriggerData createTicketingAnnulloData() {
        final List<Case> ticketingCaseList = new List<Case>();
        for (Case caseItem : (List<Case>) trigger.new) {
            final Id caseId = caseItem.Id;
            final Case oldCase = (Case) Trigger.oldMap.get(caseId);
            final Case newCase = (Case) Trigger.newMap.get(caseId);
            
            if (TKT_RECORDTYPE_ID == caseItem.RecordTypeId && newCase.Status <> oldCase.Status && 
                (newCase.Status == 'Annullata' || newCase.Status == 'Annullato')) 
                ticketingCaseList.add(caseItem);
        }
        System.debug('Trovati ' + ticketingCaseList.size() + ' Case di Annullamento');
        TriggerData ticketingTriggerData = null;
        if (ticketingCaseList.size() > 0) {
            ticketingTriggerData = new TriggerData(ticketingCaseList, Trigger.oldMap, Trigger.newMap);
        }
        return ticketingTriggerData;
    }

    private TriggerData createTicketingChangeCategoryData() {
        final List<Case> ticketingCaseList = new List<Case>();
        for (Case caseItem : (List<Case>) trigger.new) {
            final Id caseId = caseItem.Id;
            final Case oldCase = (Case) Trigger.oldMap.get(caseId);
            final Case newCase = (Case) Trigger.newMap.get(caseId);
            
            if (TKT_RECORDTYPE_ID == caseItem.RecordTypeId && newCase.Categoria_Riferimento__c <> oldCase.Categoria_Riferimento__c) 
                ticketingCaseList.add(caseItem);
        }
        System.debug('Trovati ' + ticketingCaseList.size() + ' Case con cambio Categoria');
        TriggerData ticketingTriggerData = null;
        if (ticketingCaseList.size() > 0) {
            ticketingTriggerData = new TriggerData(ticketingCaseList, Trigger.oldMap, Trigger.newMap);
        }
        return ticketingTriggerData;
    }

    private TriggerData createTicketingInfoAggiuntiveData() {
        final List<Case> ticketingCaseList = new List<Case>();
        for (Case caseItem : (List<Case>) trigger.new) {
            final Id caseId = caseItem.Id;
            final Case oldCase = (Case) Trigger.oldMap.get(caseId);
            final Case newCase = (Case) Trigger.newMap.get(caseId);
            
            if (TKT_RECORDTYPE_ID == caseItem.RecordTypeId && 
            (newCase.InfoAggiuntiveRichieste__c <> oldCase.InfoAggiuntiveRichieste__c 
            || newCase.NoteAggiuntive__c <> oldCase.NoteAggiuntive__c
           // || newCase.Note_Aggiuntive_Rich__c <> oldCase.Note_Aggiuntive_Rich__c
            ))
                ticketingCaseList.add(caseItem);
        }
        System.debug('Trovati ' + ticketingCaseList.size() + ' Case di Richiesta/Risposta Info aggiuntive');
        TriggerData ticketingTriggerData = null;
        if (ticketingCaseList.size() > 0) {
            ticketingTriggerData = new TriggerData(ticketingCaseList, Trigger.oldMap, Trigger.newMap);
        }
        return ticketingTriggerData;
    }


    private TriggerData createRichOnlineDiscordanzaData() {
        final List<Case> richOnlineCaseList = new List<Case>();
        for (Case caseItem : (List<Case>) trigger.new) {
            final Id caseId = caseItem.Id;
            final Case oldCase = (Case) Trigger.oldMap.get(caseId);
            final Case newCase = (Case) Trigger.newMap.get(caseId);
            
            if (RO_RECORDTYPE_ID == caseItem.RecordTypeId && newCase.Is_Discordanza_Cellulare__c <> oldCase.Is_Discordanza_Cellulare__c)
                richOnlineCaseList.add(caseItem);
        }
        System.debug('Trovati ' + richOnlineCaseList.size() + ' Case di Richiesta Online con modifica discordanza cellulare');
        TriggerData richiesteOnlineTriggerData = null;
        if (richOnlineCaseList.size() > 0) {
            richiesteOnlineTriggerData = new TriggerData(richOnlineCaseList, Trigger.oldMap, Trigger.newMap);
        }
        return richiesteOnlineTriggerData;
    }



/************************************ */
/************************************ */
/************************************ */
/*    private TriggerData createEmailToCaseRouterTriggerData() {
        final List<Case> caseList = new List<Case>();
        for (Case caseItem : (List<Case>) trigger.new) {
            if (EMAILTOCASE_ORIGIN_TO_ROUTE == caseItem.Origin) caseList.add(caseItem);
        }
        System.debug('Trovati ' + caseList.size() + ' Case di EmailTOCaseRouter');
        TriggerData triggerData = null;
        if (caseList.size() > 0) {
            triggerData = new TriggerData(caseList, Trigger.oldMap, Trigger.newMap);
        }
        return triggerData;
    }
*/
/************************************ */
/************************************ */
/************************************ */


    private static final String EMAILTOCASE_ORIGIN_TO_ROUTE = 'EmailToRoute';
    private static final String TKT_RECORDTYPE_ID = RecordTypeUtil.getCaseRecordType('Ticketing');
    private static final String TKTCS_RECORDTYPE_ID = RecordTypeUtil.getCaseRecordType('TicketingCS');
    private static final String RO_RECORDTYPE_ID = RecordTypeUtil.getCaseRecordType('CRM_RichiestaOnline');
}