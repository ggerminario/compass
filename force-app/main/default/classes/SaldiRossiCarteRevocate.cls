/**
 * @File Name          : SaldiRossiCarteRevocate.cls
 * @Description        : 
 * @Author             : sabrina vitali
 * @Group              : 
 * @Last Modified By   : sabrina vitali
 * @Last Modified On   : 4/12/2019, 13:43:33
 * @Modification Log   : 
 * Ver       Date            Author      		    Modification
 * 1.0    3/12/2019   sabrina vitali     Initial Version
**/
public class SaldiRossiCarteRevocate implements Schedulable {
    
    public void execute(SchedulableContext ctx) {
        
        String destinatario = 'crm@compass.it';
        System.debug('Avviamento...');
        final String EMPTY_STRING = ''; 
        final String ZERO_VALUE = '0';
        final String NUM_PRATICA_003 = '003';
        String strFlagError = EMPTY_STRING;   
        List<Messaging.SingleEmailMessage> emailToSend = new List<Messaging.SingleEmailMessage>();
        
        OCSRecuperaSaldiRossiCarteRevocateRes data;
        
        try {
            data = OCSRecuperaSaldiRossiInvoker.recuperaSaldiRossiCarteRevocate();
        } catch (Exception e) {
            strFlagError = e.getMessage();
        }
        
        if (EMPTY_STRING.equals(strFlagError)) {
            
            Datetime executionDate = Datetime.now();
            Integer executionDay = executionDate.day();
            Boolean isFirstDay = (executionDay == 1) ? true : false;
            List<OCSRecuperaSaldiRossiCarteRevocateRes.SaldoRossoDTO> saldiRossiJson = data.recuperaSaldiRossiResponse.elencoSaldiRossi;
            if ((saldiRossiJson != null) && (saldiRossiJson.size() > 0)) {
                //sabry: solo per test elabolo solo 5 righe
                /*List<OCSRecuperaSaldiRossiCarteRevocateRes.SaldoRossoDTO> saldiRossiJson5 = new List<OCSRecuperaSaldiRossiCarteRevocateRes.SaldoRossoDTO>();
                Integer tot = 0;
                for(Integer i=0;i<saldiRossiJson.size();i++){
                    if(tot<5){
                        System.debug('saldiRossiJson[i].tipoPagamento : ' + saldiRossiJson[i].tipoPagamento);
                        if((saldiRossiJson[i].tipoPagamento.equalsIgnoreCase('RI') || saldiRossiJson[i].tipoPagamento.equalsIgnoreCase('BP'))
                            && !saldiRossiJson[i].importoSaldo.startsWithIgnoreCase('-')){
                            saldiRossiJson5.add(saldiRossiJson[i]);
                            tot++;
                        }
                    }
                }
                saldiRossiJson = saldiRossiJson5; 
                System.debug('saldiRossiJson : ' + saldiRossiJson.size());*/

                //lo scope deve essere molto basso, stimate circa 27 SOQL per esecuzione
                Database.executeBatch(new BatchSaldiRossi(saldiRossiJson), 6);
                                      
            } else {
                //il servizio soap è andato a buon fine ma non ci sono risultati
                strFlagError = 'Attenzione. Nessun saldo rosso carte revocate presente.';
                Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                String[] toAddresses = new String[]{destinatario};
                mail.setToAddresses(toAddresses);mail.setSubject('Compass: Recupero Saldi Rossi carte revocate TERMINATO');mail.setPlainTextBody(strFlagError);
                emailToSend.add(mail); 
            }
            
        } else {
            //strFlagError valorizzato dal servizio soap iniziale andato in errore.
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            String[] toAddresses = new String[]{destinatario};
            mail.setToAddresses(toAddresses);mail.setSubject('Compass: Recupero Saldi Rossi carte revocate ERRORE');mail.setPlainTextBody('Errore lettura saldi:' + strFlagError);
            emailToSend.add(mail);
        } 
        
        if ((emailToSend != null) && (emailToSend.size() > 0)) {
                EmailUtils.sendEmail(emailToSend);
        }
        
    }
    
}