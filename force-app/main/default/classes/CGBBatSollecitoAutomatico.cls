//----------------------------------------------------------------------
//-- - Class Name   : CGBBatSollecitoAutomatico
//-- - Autor        : Fabio Giuliani(Lynx)
//-- - Date         : 13/01/2020
//-- - Description  : Batch che effettua il sollecito automatico dei sospesi
//-- - Version      : 1.0
//----------------------------------------------------------------------


global class CGBBatSollecitoAutomatico implements Database.Batchable<sObject>, Database.AllowsCallouts, Database.Stateful  {

    global String query;
    global String emailBodySollecito;
    global String sDataSollecito;
    global List<Case> caseToUpdate = new List<Case>();
    global List<Case> caseWithError = new List<Case>();
    global final String NEXT_SCHEDULE = '0 0 0 3 9 ? 2022'; //TODO: settare adeguatamente
    global Integer countProcessed = 0;
    global Integer countError = 0;
    global String SOLLECITO = 'Questo Messaggio è un sollecito alla richiesta inviata il ';

    
    global Database.QueryLocator start(Database.BatchableContext bc){
        system.debug('----------------------------------------------------------------------');
        system.debug('-- - Class Name  : CGBBatSollecitoAutomatico                      ');

//        emailBodySollecito = XCS_TemplateUtils.getBody('CGBBatSollecitoAutomatico');

//        System.debug('emailBodySollecito: '+emailBodySollecito);

        Date oggi = date.today();
        System.debug('oggi -> ' + oggi );
        Date oldData = oggi.addMonths(-1);
        System.debug('oldData -> ' + oldData);
        
		String myDate = oldData.year() + '-' + oldData.month() + '-' + oldData.day();
        System.debug('myDate -> '+myDate);

        query = 'SELECT Id, createddate';
        query += ' FROM Case';
        query += ' WHERE RecordType.Name = \'CRM Gestione Email\'';
//        query += ' AND Data_Notifica__c <= ' + Date.valueOf(myDate) ;
        query += ' AND Data_Notifica__c <= ' + myDate ;
        query += ' AND Status = \'Inoltrato\'';
//        query += ' AND Status = \'Inoltrata\'';
        System.debug('query: '+query);
        List<Case> ltest = [SELECT id, status, data_notifica__c FROM Case];
        System.debug('ltest----> ' + ltest );
        return Database.getQueryLocator(query);
        
    }
    
    global void execute(Database.BatchableContext bc, List<Case> caseList){
        system.debug('---------------------------------------------------------------------------------------');
        system.debug('-- Class Name: CGBBatSollecitoAutomatico - Method Name: Execute'); 
        

        if(caseList!=null){

            Set<String> sId = new Set<String>();
            for(case c : caseList){
                sId.add(c.Id);
            }

            List<EmailMessage> emailM = [SELECT id, ActivityId, BccAddress, CcAddress, CreatedDate, 
                FromName, FromAddress, EmailTemplateId, Headers, HtmlBody, Incoming, Status, 
                Subject, TextBody, ToAddress, ParentId FROM EmailMessage WHERE ParentId in :sId];

            for(EmailMessage em:emailM){

                countProcessed += 1;
                Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();

                if(em.ToAddress!=null){
                    if (em.ToAddress.contains(',')){
                        List<String> lstTo = em.ToAddress.split(',');
                        mail.setToAddresses(lstTo);
                    }else{
                        List<String> sEm = new List<String>();
                        sEm.add(em.ToAddress);
                        mail.setToAddresses(sEm);
                    }

                }

                if(em.CcAddress!=null){
                    if (em.CcAddress.contains(',')){
                        List<String> lstCc = em.CcAddress.split(',');
                        mail.setCcAddresses(lstCc);
                    }else{
                        List<String> sEm1 = new List<String>();
                        sEm1.add(em.CcAddress);
                        mail.setCcAddresses(sEm1);
                    }

                }

                if(em.BccAddress!=null){
                    if (em.BccAddress.contains(',')){
                        List<String> lstBcc = em.BccAddress.split(',');
                        mail.setBccAddresses(lstBcc);
                    }else{
                        List<String> sEm2 = new List<String>();
                        sEm2.add(em.BccAddress);
                        mail.setBccAddresses(sEm2);
                    }
                }

                mail.setSenderDisplayName('Salesforce Support');
                
                mail.Subject = 'SOLLECITO ' + em.Subject;
                mail.setPlainTextBody(SOLLECITO + em.CreatedDate);
                mail.whatId = em.ParentId;
                
                System.debug('mail: '+mail);
                System.debug('subject: ' + mail.Subject);
 
                
                Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail }); 

            }

        }

    }

    global void finish(Database.BatchableContext bc){
        System.debug('---------------------------------------------------------------------------------------');
        System.debug('-- Class Name: CGBBatSollecitoAutomatico - Method Name: Finish'); 
        System.debug('-- Record Processati -> '+ countProcessed);
            
//        CGBBatSollecitoAutomatico bSollecito = new CGBBatSollecitoAutomatico();
        
//        DateTime dt = Datetime.now();
//        DateTime dt2 = dt.addMinutes(15);
//        System.debug('dt --> ' + dt);
//        System.debug('new dt --> ' + dt.addMinutes(15));
        
//        hour = String.valueOf(dt2.hour());
//        min = String.valueOf(dt2.minute());
//        ss = String.valueOf(dt2.second());
//        System.debug('hour -> ' + hour);
//        System.debug('min -> ' + min);
//        System.debug('ss -> ' + ss);
        
//        String nextTime = ss + ' ' + min + ' ' + hour + ' * * ?';
//        System.debug('nextTime -> ' + nextTime);

    }

    public static void sendEmailManuale(String caseId){
        System.debug('---------------------------------------------------------------------------------------');
        System.debug('-- Class Name: CGBBatSollecitoAutomatico - Method Name: Finish'); 

        List<EmailMessage> emailM = [SELECT id, ActivityId, BccAddress, CcAddress, CreatedDate, 
            FromName, FromAddress, EmailTemplateId, Headers, HtmlBody, Incoming, Status, 
            Subject, TextBody, ToAddress, ParentId FROM EmailMessage WHERE ParentId = :caseId];
        
        System.debug('emailM -> '+emailM);

        for(EmailMessage em:emailM){

            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();

            if(em.ToAddress!=null){
                if (em.ToAddress.contains(',')){
                    List<String> lstTo = em.ToAddress.split(',');
                    mail.setToAddresses(lstTo);
                }else{
                    List<String> sEm = new List<String>();
                    sEm.add(em.ToAddress);
                    mail.setToAddresses(sEm);
                }

            }

            if(em.CcAddress!=null){
                if (em.CcAddress.contains(',')){
                    List<String> lstCc = em.CcAddress.split(',');
                    mail.setCcAddresses(lstCc);
                }else{
                    List<String> sEm1 = new List<String>();
                    sEm1.add(em.CcAddress);
                    mail.setCcAddresses(sEm1);
                }

            }

            if(em.BccAddress!=null){
                if (em.BccAddress.contains(',')){
                    List<String> lstBcc = em.BccAddress.split(',');
                    mail.setBccAddresses(lstBcc);
                }else{
                    List<String> sEm2 = new List<String>();
                    sEm2.add(em.BccAddress);
                    mail.setBccAddresses(sEm2);
                }
            }

            mail.setSenderDisplayName('Salesforce Support');
            
            mail.Subject = 'SOLLECITO ' + em.Subject;
            mail.setPlainTextBody('Questo Messaggio è un sollecito alla richiesta inviata il ' + em.CreatedDate);
            mail.whatId = em.ParentId;
            
            System.debug('mail: '+mail);
            System.debug('subject: ' + mail.Subject);

            Messaging.sendEmail(new Messaging.SingleEmailMessage[] { mail }); 

        }
    }
}