//----------------------------------------------------------------------
//-- - Author       : SANA BADJI
//-- - Date         : 29/07/2019
//-- - Description  : Handle MailSentNotifyApexClassTest
//----------------------------------------------------------------------
@isTest
public  class MailSentNotifyApexClassTest {
/*
        public static EmailMessage thisEmailMessage;
        @TestSetup
        static void makeData(){

                Id recordType=CGMWSUtils_1_0.getRecordTypeId('Case','CRM_RichiestaOnline');

                Case caseObject = new Case (Stato_Pratica__c='20',
                Attributi_Pratica__c ='SD',stato_ocs__c='20SD',
                Status='Ricevuto',RecordTypeId=recordType,
                Subject='This is a test case for testCaseForForum');
                insert caseObject;
                caseObject = [SELECT CaseNumber FROM Case WHERE Id = :caseObject.Id];

                String crmIncidentId=caseObject.CaseNumber;

                System.debug(' caseObject '+ caseObject );
                System.debug(' caseObjectId '+ caseObject.Id );
                System.debug('crmIncidentIdSetup '+ caseObject.CaseNumber );
                //Case caseObj =MailSentNotifyApexClass.getCaseNumberAndId(crmIncidentId);
                ID caseId=caseObject.Id;
                thisEmailMessage= new EmailMessage(
                        CcAddress='',
                        FromAddress='richiesta@compass.it',
                        HtmlBody='<html><body><b>Hello</b></body></html>',
                        Subject='Prestito Online Compass: SECCI e tracking pratica', 
                        ToAddress='mballosamba99@gmail.com',
                        BccAddress='20190725100459_mballosamba99@gmail.com_MBLSMB93T30Z343P___996161465',
                        ParentId=caseId);
                upsert thisEmailMessage;
        }

        @IsTest
        static void mailSentNotifyTest(){
                Test.startTest();
                Id recordType=CGMWSUtils_1_0.getRecordTypeId('Case','CRM_RichiestaOnline');
                 Case caseObject = new Case (Stato_Pratica__c='20',
                Attributi_Pratica__c ='SD',stato_ocs__c='20SD',
                Status='Ricevuto',RecordTypeId=recordType,
                Subject='This is a test case for testCaseForForum');
                insert caseObject;
                caseObject = [SELECT CaseNumber FROM Case WHERE Id = :caseObject.Id];
                List<EmailMessage> listEmailMessage = 
                [SELECT Id, ParentId,RelatedToId,CcAddress,FromName,HtmlBody,Subject,TextBody,ToAddress,
                BccAddress  FROM  EmailMessage ];
                
                EmailMessage emailMessage = new  EmailMessage(
                        CcAddress=null,
                        FromName=null,
                        HtmlBody=null,
                        Subject=null,
                        TextBody=null,
                        ToAddress=null,
                        RelatedToId=null,
                        BccAddress=null,
                        ParentId=null);
                insert emailMessage;
                MailSentNotifyApexClass.EmailMessageWrapper emM = new MailSentNotifyApexClass.EmailMessageWrapper(emailMessage);
                emM.allegati='';
                emM.cf='';
                emM.cip='';
                emM.corpo='';
                emM.crmIncidentId='';
                emM.destinatariCC='';
                emM.destinatario='';
                emM.mailId='';
                emM.mittente='';
                emM.oggetto='';
                emM.pratica='';
                emM.template='';

                //ID thisEmailMess
                 //String crmIncidentId=caseObject.caseNumber;
                  String crmIncidentId=caseObject.CaseNumber;
                 System.debug('crmIncidentIdSetup after '+ crmIncidentId );   
                MailSentNotifyApexClass.MailSentNotifyResponse mailSentNotifyResponse = new MailSentNotifyApexClass.MailSentNotifyResponse(1L,'');
                mailSentNotifyResponse = MailSentNotifyApexClass.mailSentNotify(
                'allegati',
                '', 
                '',
                'corpo',
                crmIncidentId,
                '<html><body><b>Hello</b></body></html>',
                'mballosamba99@gmail.com',
                '20190725100459_mballosamba99@gmail.com_MBLSMB93T30Z343P___996161465',
                'richiesta@compass.it','Prestito Online Compass: SECCI e tracking pratica',
                '','template');
                // Verify new record was created
                System.assertEquals(mailSentNotifyResponse.resultCode, 0L);  
                System.assert(caseObject!=null, 'listCase.size()==1');
                Test.stopTest();
        }

         @IsTest
        static void mailSentNotifyErrorFormatMailTest(){
                Test.startTest();
                Id recordType=CGMWSUtils_1_0.getRecordTypeId('Case','CRM_RichiestaOnline');
                 Case caseObject = new Case (Stato_Pratica__c='20',
                Attributi_Pratica__c ='SD',stato_ocs__c='20SD',
                Status='Ricevuto',RecordTypeId=recordType,
                Subject='This is a test case for testCaseForForum');
                insert caseObject;
                caseObject = [SELECT CaseNumber FROM Case WHERE Id = :caseObject.Id];
                List<EmailMessage> listEmailMessage = 
                [SELECT Id, ParentId,RelatedToId,CcAddress,FromName,HtmlBody,Subject,TextBody,ToAddress,
                BccAddress  FROM  EmailMessage ];
                
                EmailMessage emailMessage = new  EmailMessage(
                        CcAddress=null,
                        FromName=null,
                        HtmlBody=null,
                        Subject=null,
                        TextBody=null,
                        ToAddress=null,
                        RelatedToId=null,
                        BccAddress=null,
                        ParentId=null);
                insert emailMessage;
                MailSentNotifyApexClass.EmailMessageWrapper emM = new MailSentNotifyApexClass.EmailMessageWrapper(emailMessage);
                emM.allegati='';
                emM.cf='';
                emM.cip='';
                emM.corpo='';
                emM.crmIncidentId='';
                emM.destinatariCC='';
                emM.destinatario='';
                emM.mailId='';
                emM.mittente='';
                emM.oggetto='';
                emM.pratica='';
                emM.template='';

                //ID thisEmailMess
                 //String crmIncidentId=caseObject.caseNumber;
                  String crmIncidentId=caseObject.CaseNumber;
                 System.debug('crmIncidentIdSetup after '+ crmIncidentId );   
                MailSentNotifyApexClass.MailSentNotifyResponse mailSentNotifyResponse = new MailSentNotifyApexClass.MailSentNotifyResponse(1L,'');
                mailSentNotifyResponse = MailSentNotifyApexClass.mailSentNotify(
                'allegati',
                '', 
                '',
                'corpo',
                crmIncidentId,
                '<html><body><b>Hello</b></body></html>',
                'mballosamba99@gmail.com',
                '20190725100459_mballosamba99@gmail.com_MBLSMB93T30Z343P___996161465',
                'richiestacompass.it','Prestito Online Compass: SECCI e tracking pratica',
                '','template');
                // Verify new record was created
                System.assertEquals(mailSentNotifyResponse.resultCode, 1L);  
                System.assert(caseObject!=null, 'listCase.size()==1');
                Test.stopTest();
        }
        */
}