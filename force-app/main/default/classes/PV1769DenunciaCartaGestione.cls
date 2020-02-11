public with sharing class PV1769DenunciaCartaGestione extends PVActionGestione{
    
	public class PV1769DenunciaCartaGestioneForm extends PVForm {

	}

    /***************************/
	/*   metodi Aura enabled   */
	/***************************/

    @AuraEnabled
	public static void saveCase(PV1769DenunciaCartaGestioneForm form, Case theCase){
		String messaggio_errore = '';

		try{
			system.debug('form: ' + form);
            system.debug('theCase: ' + theCase);

			String note = creaNote(form, theCase);
			saveUtil(form, theCase, note);
		}catch(Exception e) {  
            messaggio_errore = loggaException(e);          
        }finally{
            if(messaggio_errore != '') {
                gestisciException(messaggio_errore);
            }
        }
	}


	private static String creaNote(PVForm myform, Case theCase) {
		return myform.note;
	}

	//recupera circuito carta
    @AuraEnabled
	public static OCSRecuperaCircuitoCartaResponse.CircuitoPanCartaDTO RecuperaCircuitoCartaOCS(String numeroCarta){
		OCSRecuperaCircuitoCartaResponse recuperaCircuitoCarta = OCSRecuperaCircuitoCartaInvoker.callRecCircuitoCarta(numeroCarta);
        return recuperaCircuitoCarta.recuperaCircuitoCartaResponse;
	}

    //compila body automaticamente
    @AuraEnabled
    public static String doComponiEmail(String stopList, String circuito, String pan, String email, Case theCase){
        email='';
        if(stopList != 'no'){
            if(pan == ''){
                return 'errore pan';
            }
            else if((circuito == 'VIS') || (circuito == 'EMC')){
                email += 'Buongiorno, \nprego aggiungere carta in stoplist \n\n';
                email += 'PAN  ' + pan + '     ' + theCase.Account.FirstName;
                email += ' ' + theCase.Account.LastName + '     ';
                email += stopList;
                email += '\n\nSaluti\nCompass SpA\nUfficio Back Office';
                System.debug('body email: ' + email);
            }
            else{
                return 'errore circuito';
            }
        }
        return email; 
    }


    //in base al circuito carta sett gli indirizzi email per l'invio
    @AuraEnabled
    public static List<String> doImpostaIndirizzi(String circuito){
        List<String> indirizziInvioEmail = new List<String>();
        System.debug('imposta indirizzi circuito: ' + circuito); 
        /*if(circuito == 'VIS'){
            System.debug('imposta indirizzi circuito: ' + circuito); 
            indirizziInvioEmail.add('pasquale.varano@numeroblu.it');
            indirizziInvioEmail.add('cs_outsourcing@compass.it');
            indirizziInvioEmail.add('patrizia.carrieri@numberoblu.it');
            indirizziInvioEmail.add('laura.divito@numeroblu.it');
            indirizziInvioEmail.add('domenico.fiore@numeroblu.it');
        }
        else if(circuito == 'EMC'){
            System.debug('imposta indirizzi circuito: ' + circuito); 
            indirizziInvioEmail.add('cs_outsourcing@compass.it');
        }*/

        if(circuito == 'VIS'){
            indirizziInvioEmail = CompassParametersUtils.getListValues('inviomail.VIS');
            System.debug('Indirizzi VIS: ' + indirizziInvioEmail);
        }else if(circuito == 'EMC'){
            indirizziInvioEmail = CompassParametersUtils.getListValues('inviomail.EMC');
        }


        return indirizziInvioEmail;
    }

    //invia email quando richiamata dall'helper
    @AuraEnabled
    public static void InvioEmail(List<String> emailAddress, String body, String circuito){
        // manda email
		List<Messaging.SingleEmailMessage> emailToSend = new List<Messaging.SingleEmailMessage>();
		Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
        Collectors__c collector = new Collectors__c();
        for(String m : emailAddress){
            collector.Email__c = m;
        }
		String[] toAddresses = new String[] {collector.Email__c};
        //String[] toAddresses = new String[] {'adriana.lattanzi@exprivia.com'};
		mail.setToAddresses(toAddresses);
		mail.setSubject('Denuncia Carta');
		mail.setPlainTextBody(body);
		emailToSend.add(mail);
        
        system.debug(emailToSend);
        
        String mockName = 'inviomail.' + circuito;
        EmailUtils.sendEmail(emailToSend, mockName);
    }

}