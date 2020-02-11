/**
 * @File Name          : PV2380RintraccioBollPosteItalianeGest.cls
 * @Description        : 
 * @Author             : Matteo Gobbo
 * @Group              : 
 * @Last Modified By   : Matteo Gobbo
 * @Last Modified On   : 4/2/2020, 12:58:01
 * @Modification Log   : 
 * Ver       Date            Author      		    Modification
 * 1.0    10/1/2020   Matteo Gobbo     Initial Version
**/
public class PV2380RintraccioBollPosteItalianeGest extends PVActionGestione {

 public class PV2380RintraccioBollPosteItalianeGestForm extends PVForm {
  @AuraEnabled
  public Boolean flagRinvia {get;set;}
  @AuraEnabled
  public Boolean sbf {get;set;}
  @AuraEnabled
  public Boolean pi {get;set;}
  @AuraEnabled
  public String esitoSBF {get;set;}
  @AuraEnabled
  public String esitoPIT {get;set;}
  @AuraEnabled
  public String esitoSTO {get;set;}
  @AuraEnabled
  public String sceltaRate {get;set;}
 }

 @AuraEnabled
 public static void saveCase(PV2380RintraccioBollPosteItalianeGestForm form, Case theCase) {
  String messaggio_errore = '';
  try {
      List<String> indirizziEmailRintraccio = new List<String>();
      List<String> indirizziEmailCuas = new List<String>();

   system.debug('form PV2380RintraccioBollPosteItalianeGestForm: ' + form);
   system.debug('theCase PV2380RintraccioBollPosteItalianeGest: ' + theCase);

   if(String.isNotBlank(form.sceltaRate)){
        theCase.Risposte__c = form.sceltaRate;
    }
    
   //Rinvia al mittente
   if (form.newStatus == 'Closed' && form.flagRinvia == true) {
       theCase.pv_collector__c = 'SI';
   }
   if (form.sbf)
    theCase.pv_send_to__c = 'SBF';
   /*if (form.pi)
    theCase.pv_send_to__c = 'PI';*/
   if (form.esitoSBF != '')
    thecase.pv_esito_sbf__c = form.esitoSBF;
   if (form.esitoPIT != '')
    thecase.pv_esito_poste__c = form.esitoPIT;
   if (form.esitoSTO != '')
    thecase.pv_refund_flag__c = form.esitoSTO;

   //Recupero gli indirizzi email per le notifiche
    if(String.isNotBlank(thecase.pv_refund_flag__c) && String.isNotBlank(thecase.UfficioDestinazione__c)) {
        //Ufficio destinazione
        String emailUfficioDest = '';
        Account uffDest = [Select BusinessEmail__c from account where id =: thecase.UfficioDestinazione__c limit 1]; 
        if(uffDest != null) {
            emailUfficioDest =  uffDest.BusinessEmail__c;
            indirizziEmailRintraccio.add(emailUfficioDest);
        }

        //Ufficio rintraccio  pagamenti
        String emailUfficioRin = '';
        Account uffRin = [Select BusinessEmail__c from account where name = 'Rintraccio Pagamenti' limit 1]; 
        if(uffRin != null) {
            emailUfficioRin =  uffRin.BusinessEmail__c;
            indirizziEmailCuas.add(emailUfficioRin);
        }         
    }

    if((String.isBlank(theCase.pv_esito_poste__C) && String.isBlank(theCase.pv_esito_sbf__c) && String.isNotBlank(theCase.risposte__c)) || (String.isBlank(theCase.pv_send_to__c) && theCase.step_pv__c == '4')){
        System.debug('Nella sezione invio mail al cuas');
        String emailCuas = '';
        UffCuas__c ufficioCuas = [SELECT CodProvincia__c, provincia__c, cuas__c, email__c from UffCuas__c  where CodProvincia__c =: theCase.pv_prov_uffpost_boll__c limit 1];
        System.debug('Ufficio cuas: ' + ufficioCuas);
        if(ufficioCuas != null) {
            System.debug('Nell if ufficio cuas != null');
            emailCuas =  ufficioCuas.Email__c;
            indirizziEmailCuas.add(emailCuas);
        }
    }
    
    if(indirizziEmailRintraccio.size() > 0){
        sendEmail(creaNoteForEmail(theCase.Id), theCase, indirizziEmailRintraccio);
    }

    if(String.isNotBlank(thecase.risposte__c)) {
        if(indirizziEmailCuas.size() > 0){
            System.debug('Nell if indirizziEmailCuas > 0');
            sendEmail('TEST EMAIL CUAS F&T', theCase, indirizziEmailCuas);
            theCase.risposte__c = '';
        }    
    }
    
   String note = creaNote(form, theCase);

   saveUtil(form, theCase, note);
  } catch (Exception e) {
   messaggio_errore = loggaException(e);
  } finally {
   if (messaggio_errore != '') {
    gestisciException(messaggio_errore);
   }
  }
 }

 private static String creaNote(PVForm myform, Case theCase) {
  return myform.note;
 }

 private static String creaNoteForEmail(Id caseId){
     String template = '';
     List<FeedItem> itemList = [select body,createdDate from FeedItem WHERE type = 'TextPost' and ParentId =: caseId  order by CreatedDate desc];

     for(FeedItem currentFeed : itemList){
         template += currentFeed.Body + ' - ' + formatDate(currentFeed.createdDate) + '<br>';
     }

     return template;
     

 }

 private static String formatDate(DateTime d){
		return String.valueof(d.day()) + '/' + String.valueof(d.month()) + '/' + String.valueof(d.year());
	}

 @AuraEnabled 
    public static user fetchUserDetail(){
        return [Select id,Name,Profile.Name,Branch_Or_Office__c
                From User
                Where Id =: Userinfo.getUserId()];
    }

    //Creare un email template
    //1) Inviare email a ufficio rintraccio pagamenti e ufficio destinazione quando il case si chiud

    private static void sendEmail(String emailBody, Case theCase, List<String> indirizzi){
        List<String> indirizziDaInviare = new List<String>();
        indirizziDaInviare.addAll(indirizzi);
		List<Messaging.SingleEmailMessage> emailToSend = new List<Messaging.SingleEmailMessage>();
		Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
		mail.setToAddresses(indirizziDaInviare);
		mail.setSubject(theCase.Subject);
		mail.setHtmlBody(emailBody);
		emailToSend.add(mail);
		system.debug('Email to send: ' + emailToSend);		
		String mockName = 'Email - Ufficio Sistemi';
		EmailUtils.sendEmail(emailToSend,mockName);
    }
}