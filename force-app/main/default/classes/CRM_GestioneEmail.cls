public class CRM_GestioneEmail extends TriggerHandler{
    public static final String GESTIONE_EMAIL_CATEGORY = '5299';
    public static final String GESTIONE_EMAIL_ADDRESS = 'gestione_email';
    
    //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    ///////////////////////////////FORM INSERIMENTO///////////////////////////////////////////////////////////////////////////////////////////////////
    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    @AuraEnabled
    public static List<Account> initDestinatario(){
        List<String> destinatari = new List<String>();
        destinatari.add('Contabilita Clienti');
        destinatari.add('Finanza');
        destinatari.add('Rintraccio Pagamenti');
        destinatari.add('Segnalazioni CS');
        destinatari.add('Contact Center');
        destinatari.add('Contabilità Fornitori');
        
   		return [Select id, name from Account where recordtype.developername = 'Uffici_e_Altro' and name in :destinatari];
    }
    
    @AuraEnabled
    public static String cercaPratica(String codPratica){
        String filtro='CA#CO#CQ#PB';
        OCSRecuperaDatiPostvenditaResponse response = OCSRecuperaDatiPostvenditaInvoker.callRecDatiPVPratica(codPratica, filtro);
        System.debug(response);
        return JSON.serialize(response);
    }
   
    public static String getRefEmailToCase(Case c){
        String riferimento = '';
        if(c.id == null) return riferimento;
        String organizzazioneId = UserInfo.getOrganizationId();
        riferimento = organizzazioneId.substring(0, 5)+ ''+organizzazioneId.substring(10, 15);
        riferimento+='._';
        riferimento+=(c.id+'').substring(0,5)+''+(c.id+'').substring(10, 15);
        return riferimento;
      
    }
    
    @AuraEnabled
    public static void inviaEmail(String destinatarioId, String categoria, String oggetto, String tipo, String codPratica, String testo, String cc){
     
		 Contact cont = [select id, name, email from contact where email = 'boris90@live.it' limit 1];        
        Case c = new Case();
        c.status = 'Inoltrata'; 
        c.OwnerId = [Select id from group where developername = 'Q293'].Id;
        c.subject = oggetto; //Da confermare
        c.Categoria_Riferimento__c = [Select id from XCS_Categoria__c where External_Id__c = :categoria].id;
        c.Origin = 'Email';
        c.contactid = cont.id;
        c.RecordTypeId = [Select id from recordtype where developername='CRM_Gestione_Email' limit 1].Id;
        insert c;
        
        Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
        
        if(cc != null && cc.length() > 0) email.ccaddresses = cc.split(';');
        List<String> toAddress = new List<String>();
        toAddress.add(cont.email);
        OrgWideEmailAddress mittente = [SELECT Id, DisplayName, Address FROM OrgWideEmailAddress Where DisplayName='Email CGB Service' limit 1];
        email.setOrgWideEmailAddressId(mittente.id);
        email.setToAddresses(toAddress);
        email.setSubject(oggetto+'    [ ref:_'+getRefEmailToCase(c)+':ref ]');
        email.setHtmlBody(testo +'\n\n ref:_'+getRefEmailToCase(c)+':ref ');
        email.whatid = c.id;
        email.setTargetObjectId(cont.id);
        
        
        Messaging.SingleEmailMessage[] listEmail = new List<Messaging.SingleEmailMessage>();
        listEmail.add(email);
        Messaging.sendEmail(listEmail);
     
    }
    
  
   
    //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    ///////////////////////////////TRIGGER///////////////////////////////////////////////////////////////////////////////////////////////////
    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    public override void  beforeInsert(){
        XCS_categoria__c categoria = [Select id from xcs_categoria__c where external_id__c =:GESTIONE_EMAIL_CATEGORY];
        Recordtype rt = [Select id from Recordtype where developername = 'CRM_Gestione_Email' limit 1];
        for(Case c : (List<Case>)trigger.new){
            if(c.RecordTypeId == rt.id){
                c.Categoria_Riferimento__c = categoria.id;
            }
        }
    }
    
    public static void insertCase(List<EmailMessage> listMessages){
        List<Id> idList = new List<Id>();
        for(EmailMessage temp: listMessages) idList.add(temp.id);
        
        list<EmailMessage> messages = [Select id,FromAddress,parentid from emailMessage where id =: idList];
        list<Case> caseIds = [Select id, parentId, status from case where id IN (select parentId from emailMessage where Id =: messages)];
        System.debug(caseIds);
        System.debug(messages);
        /*
        Xcs_categoria__c categoria = [Select id from xcs_categoria__c where external_id__c =: GESTIONE_EMAIL_CATEGORY limit 1];
        List<Id> idList = new List<Id>();
        for(EmailMessage temp: listMessages)
            idList.add(temp.id);
        list<EmailMessage> messages = [Select id,FromAddress,parentid from emailMessage where id =: idList];
        list<Case> caseIds = [Select id from case where id IN (select parentId from emailMessage where Id =: messages)];
        EmailServicesAddress serviceEmail = [SELECT DeveloperName,EmailDomainName FROM EmailServicesAddress where developername =: GESTIONE_EMAIL_ADDRESS];
        Map<Id,EmailMessage> mapCaseEmail = new Map<Id,EmailMessage>();
        for(EmailMessage message : messages){
            mapCaseEmail.put(message.parentid,message);
        }
        System.debug('### lista dei case' + caseIds.size());
        for(Case i : caseIds){
           System.debug('###### provo debug ');
            i.Categoria_Riferimento__c =categoria.id;
            if(mapCaseEmail.get(i.id).FromAddress.contains(serviceEmail.EmailDomainName)){
                i.Status='Inoltrato';
                System.debug('###### provo debug 2 '+ serviceEmail.EmailDomainName);
            }

            else{
                i.Status ='Ricevuto';
                System.debug('###### provo debug 3 '+ serviceEmail.EmailDomainName);
                
            } 
        }
        update caseIds;*/
    }


    //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    //////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    ///////////////////////////////QUICK ACTION///////////////////////////////////////////////////////////////////////////////////////////////////
    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    @AuraEnabled
    public static void invioSollecitoCtrl(String recordId){
        //Chiamare il batch di Fabio
        CGBBatSollecitoAutomatico.sendEmailManuale(recordId);
    }
}