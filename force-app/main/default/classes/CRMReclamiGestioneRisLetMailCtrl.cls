public class CRMReclamiGestioneRisLetMailCtrl {
   

    @AuraEnabled
    public static List<Destinatario__c> getInitValues(String societa){
        return [SELECT Id, Email__c, Name__c, Societa__c, DeveloperName__c FROM Destinatario__c WHERE Societa__c =: societa order by Name__c asc];
    }
    
    @AuraEnabled
    public static Boolean inviaRispostaApex(String a, String cc, String bcc, String body, List<Attachment> listaAllegati, Case campiCase, OCSCliente clienteSelezionato, String praticaSelezionata, Boolean hasFeT) {

        if(clienteSelezionato == null)
            clienteSelezionato = new OCSCliente();
       
        System.debug('***************** ');
        System.debug('campiCase = ' + campiCase);
        System.debug('CRMReclamiGestioneRisLetMailCtrl inviaRispostaApex input: a: ' + a + '\n cc :' + cc + '\n bcc :' + bcc + '\n body : ' + body + '\n listaAllegati : ' + listaAllegati);
        List<String> toAddressList = a.split(';');
        List<String> ccList = (String.isNotEmpty(cc))? cc.split(';'):null;
        List<String> bccList = (String.isNotEmpty(bcc))? bcc.split(';'):null;
        List<id> idsAllegati = new List<id>();
        for(Attachment allegato:listaAllegati) {
            List<String> lst = new List<String>();
            for(String spl : allegato.Description.split('=')){
                lst.add(spl);
            }
            //idsAllegati.add(allegato.Id);
            idsAllegati.add(lst.get(0));
            
        }
        System.debug('Allegati Boris');
        System.debug(idsAllegati);
        List<Id> docVersionId = new List<Id> ();
        if(!idsAllegati.isEmpty()){
            List<ContentVersion> idDocument = [SELECT ContentDocumentId,FileType,Id FROM ContentVersion WHERE ContentDocumentId IN: idsAllegati and isLatest=true];
            system.debug('idDocument: '+idDocument);
            for(ContentVersion cv : idDocument){
                docVersionId.add(cv.Id);
            }
        }
        
        Case c = [Select id,Account.name,referenced_company__c, Account_Futuro_MBCS__r.FirstName__c, Account_Futuro_MBCS__r.LastName__c, numeroPratica__c from Case Where id=:campiCase.Id];
        String subject = 'Reclamo n.';
        if(campiCase != null){
            subject += campiCase.Numero_Reclamo__c;
        }
        if(c.referenced_company__c=='Futuro'){
            subject += ' - '+c.Account_Futuro_MBCS__r.FirstName__c +' '+c.Account_Futuro_MBCS__r.LastName__c;
        }
        else{
             subject += ' - '+c.Account.Name;
        }
        
		subject += ' - Prt. '+c.NumeroPratica__c;
        
        Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();
        //TO Do Creazione Corrispondenza
        String underscores = '--------------------------------------------';
        String destinatari= a;
        if(cc!= null && cc.length() !=0) destinatari+='; '+cc;
        if(bcc!= null && bcc.length() !=0) destinatari+='; '+bcc;
        
        String intestazione = 'Destinatari: ' + destinatari;
        String res;
        if(hasFeT) res = 'Richiesta inviata tramite Forward and Track';
        else res = 'Risposta al cliente inviata tramite email';
        String totale = intestazione + '\n'+res+'\n' + underscores + '\n' + underscores;
        XCSReclamiUtils.creaCorrispondenza(campiCase, totale+'\n'+body, listaAllegati);
        //Inserimento F&T
        List<XCS_CompassParameters__c> siteUrlList = [SELECT Id, Value__c FROM XCS_CompassParameters__c WHERE Name = 'forwardandtrack.baseurl'];
        String crmUrl = URL.getSalesforceBaseUrl().toExternalForm() + '/lightning/cmp/c__CRMReclamiFrodeForwardAndTrack?c__objectid=' + campiCase.Id;
        
        String messaggio = '';
        //SELECT Id, objectId__c, ComponentApp__c, ComponentName__c, token__c FROM XCS_Sites_Token__c where componentname__c = 'c:CRMReclamiInvioRichiesteFeT'
        String siteUrl = siteUrlList[0].Value__c+'?token='+SitesTokenUtil.generateToken(datetime.now().addMinutes(400),'c:CRMReclamiInvioRichiesteFeT','c:CRMReclamiFrodeForwardAndTrackApp', campiCase.id, body);
        if(hasFeT){
            body+='\n\n Cliccare qui per rispondere.\n\n';
            body+=siteUrl;
        }
        
        //Fine F&T
        
        
        message.setToAddresses(toAddressList);
        message.setCcAddresses(ccList);
        message.setBccAddresses(bccList);
        message.setPlainTextBody(body);
        message.setSubject(subject);
        if(docVersionId!= null && docVersionId.size() > 0) message.setEntityAttachments(docVersionId);
        system.debug('Messaging.SingleEmailMessage message: '+message);
        Messaging.SingleEmailMessage[] messages =   new List<Messaging.SingleEmailMessage> {message};
            try{
                Messaging.sendEmail(messages);
                
                if(hasFeT)CaseUtils.changeStatus(campiCase.id,'F&T Sent');
                return true;
            }
        catch(Exception e){
            System.debug('The email failed to send');
            return false;
        }
        
    }
    
    
}