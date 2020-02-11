/**
*  EmailMessage  WebService
*  @description  Handle Email Sent Notify
*  @author Sana Badji
*          
*  @date  13/05/2019
*
*/
@RestResource(UrlMapping = '/SentNotify')
global with sharing class MailSentNotifyApexClass extends CGMServiceWsr_1_0 {
    public static List<String> errorFields = new List<String>();

    /*
     * @author Sana BADJI
     * @modified by abdoulaye.diopdev3@compass.com.dev
     * @modified date 01/11/2019
     * @description class MailSentNotifyResponse 
     */
    @HttpPost
    global static MailSentNotifyResponse mailSentNotify(String allegati,
        String cf, String cip,String corpo,String crmIncidentId,String destinatariCC,
        String destinatario,String mailId, String mittente,String oggetto,
        String pratica, String template) {
        //FromAddress=mittente, 
        String title=oggetto+' '+mittente;
        Case caseObj =getCaseNumberAndId(crmIncidentId);
        if(caseObj==null){
            MailSentNotifyResponse mailSentNotifyResponse = new MailSentNotifyResponse();
            mailSentNotifyResponse.resultCode = 1L;
            mailSentNotifyResponse.resultMessage = 'CaseNumber: '+crmIncidentId+'! non esiste';
        return mailSentNotifyResponse;
        }
        ID caseId=caseObj.Id;
        System.debug('************* caseId   '+caseId);
        String roLinkbozza=caseObj.RO_Link_Bozza__c;
        String body='mail sent Notify';
        if(validateEmail(mittente)==true){
            EmailMessage thisEmailMessage= new EmailMessage(
            CcAddress=destinatariCC,
            FromAddress=mittente,
            HtmlBody=corpo,
            Subject=oggetto, 
            ToAddress=destinatario,
            BccAddress=mailId,
            ParentId=caseId);
            MailSentNotifyResponse mailSentNotifyResponse = new MailSentNotifyResponse();
            CallWebService.createNote(title,destinatariCC,roLinkbozza,body,caseId);
            try {
                upsert thisEmailMessage;
                System.debug('thisEmailMessage '+thisEmailMessage);
                mailSentNotifyResponse.resultCode = 0L;
                mailSentNotifyResponse.resultMessage = 'Success';
            } catch (Exception e) {
                mailSentNotifyResponse.resultCode = 1L;
                mailSentNotifyResponse.resultMessage = e.getMessage()+' '+e.getStackTraceString();
            }
            return mailSentNotifyResponse;
        }
        else{
                MailSentNotifyResponse mailSentNotifyResponse = new MailSentNotifyResponse();
                mailSentNotifyResponse.resultCode = 1L;
                mailSentNotifyResponse.resultMessage = 'Incorrect format mittente:'+mittente+'! best format is : richiesta@compass.it';
             return mailSentNotifyResponse;
        }
       
    }

    /*
     *  @description  Method return Case for retrieving IdCase and  numeroPratica
     *  @author Sana Badji         
     *  @date  27/05/2019
     *
     */
    public static Case getCaseNumberAndId(String crmIncidentId){
        List<String> errorFields = new List<String>(); 
        Case caseObj;
        Id recordType=CGMWSUtils_1_0.getRecordTypeId('Case','CRM_RichiestaOnline');
        try {  
        caseObj = [SELECT Id, CaseNumber,NumeroPratica__c,RO_Link_Bozza__c FROM Case WHERE CaseNumber = : crmIncidentId 
        AND Status!='Closed' AND  RecordTypeId = :recordType];
         System.debug('************* getCaseNumberAndId   '+caseObj);
        }catch (System.QueryException e) {
        caseObj=null;
        System.debug('************* NumeroPratica__c not exit   '+e.getMessage());
        }
        return caseObj;
    }

    // Add Email Message Relation for id of the sender
    // EmailMessageRelation emr = new EmailMessageRelation(
    // emailMessageId= thisEmailMessage.Id,
    // relationId = '005B0000003qHvOIAU', // user id of the sender
    // relationType = 'FromAddress'
    // );
    // insert emr;

    global class EmailMessageWrapper extends ObjectWrapper {
        global String allegati { get; set; }
        global String cf { get; set; }
        global String cip { get; set; }
        global String corpo { get; set; }
        global String crmIncidentId { get; set; }
        global String destinatariCC { get; set; }
        global String destinatario { get; set; }
        global String mailId { get; set; }
        global String mittente { get; set; }
        global String  oggetto { get; set; }
        global String  pratica { get; set; }
        global String  template { get; set; }

        global  EmailMessageWrapper(EmailMessage emailMessage) {
            super(emailMessage);
        }
    }

    public static Boolean validateEmail(String email) {
        Boolean res = true;
        String emailRegex = '^[a-zA-Z0-9._|\\\\%#~`=?&/$^*!}{+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,4}$'; // source: <a href="http://www.regular-expressions.info/email.html" target="_blank" rel="nofollow">http://www.regular-expressions.info/email.html</a>
        Pattern MyPattern = Pattern.compile(emailRegex);
        Matcher MyMatcher = MyPattern.matcher(email);
        if (!MyMatcher.matches())
            res = false;
        return res;	
	}

    /*
     * @author abdoulaye.diopdev3@compass.com.dev
     * @date  01/11/2019
     * @description class MailSentNotifyResponse 
     */
    global class MailSentNotifyResponse extends  GenericResponse {
        //public Long resultCode {get; set;}
       // public String resultMessage {get; set;}
        global MailSentNotifyResponse(){
            super( );

        }
    }
}