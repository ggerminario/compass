/**
 * @File Name          : SaldiRossiOngoing.cls
 * @Description        : 
 * @Author             : sabrina vitali
 * @Group              : 
 * @Last Modified By   : sabrina vitali
 * @Last Modified On   : 4/12/2019, 13:53:08
 * @Modification Log   : 
 * Ver       Date            Author      		    Modification
 * 1.0    4/12/2019   sabrina vitali     Initial Version
**/
public class SaldiRossiOngoing implements Schedulable {
    
    public void execute(SchedulableContext ctx) {
        
        String destinatario = 'crm@compass.it';
        System.debug('Avviamento...');
        final String EMPTY_STRING = ''; 
        final String ZERO_VALUE = '0';
        String strFlagError = EMPTY_STRING; 
        List<Messaging.SingleEmailMessage> emailToSend = new List<Messaging.SingleEmailMessage>();
        
        OCSRecuperaSaldiRossiOngoingResponse data;
        
        try {
            data = OCSRecuperaSaldiRossiOngoingInvoker.recuperaSaldiRossiOngoing();
        } catch (exception e) {
            strFlagError = e.getMessage();
        }
        
        if (EMPTY_STRING.equals(strFlagError)) {
            List<OCSRecuperaSaldiRossiOngoingResponse.SaldoRossoOngoingDTO> saldiRossiOngoingJson = data.recuperaSaldiRossiOngoingResponse.elencoSaldiRossi;
            if ((saldiRossiOngoingJson != null) && (saldiRossiOngoingJson.size() > 0)) {
                //lo scope deve essere molto basso, stimate circa 27 SOQL per esecuzione
                Database.executeBatch(new BatchSaldiRossiOngoing(SaldiRossiUtils.preparePVRequests(saldiRossiOngoingJson)),7);
                
            } else {
                //il servizio soap è andato a buon fine ma non ci sono risultati
                strFlagError = 'Attenzione. Nessun saldo rosso ongoing presente.';
                Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                String[] toAddresses = new String[]{destinatario};
                mail.setToAddresses(toAddresses);
                mail.setSubject('Compass: Recupero Saldi Rossi Ongoing TERMINATO'); 
                mail.setPlainTextBody(strFlagError);
                emailToSend.add(mail); 
            }
            
        } else {
            
            //strFlagError valorizzato dal servizio soap iniziale andato in errore.
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            String[] toAddresses = new String[]{destinatario};
            mail.setToAddresses(toAddresses);
            mail.setSubject('Compass: Recupero Saldi Rossi Ongoing ERRORE');mail.setPlainTextBody('Errore lettura saldi:' + strFlagError);emailToSend.add(mail);
			
            emailToSend.add(mail);
        } 
        
        if ((emailToSend != null) && (emailToSend.size() > 0)) {
                EmailUtils.sendEmail(emailToSend);
        }
    }
}