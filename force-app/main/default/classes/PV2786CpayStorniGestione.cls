public class PV2786CpayStorniGestione extends PVActionGestione{

    public class PV2786CpayStorniGestioneForm extends PVForm {
     
        @AuraEnabled
        public Boolean rinvia{get;set;}
    
	}

    @AuraEnabled
	public static void saveCase(PV2786CpayStorniGestioneForm form, Case theCase){
		String messaggio_errore = '';
        system.debug('form' + form);        
        
		try{
            //closed equivale allo stato Gestito
            //se l'operatore seleziona il rinvio al mittente e lo stato 'Gestito'
            //il case torna nella coda del mittente
            if (form.newStatus == 'Closed' && form.rinvia == true){
                theCase.Step_PV__c = '3';
            }

		    saveUtil(form, theCase, creaNote(form));
		}catch(Exception e) {   messaggio_errore = e.getMessage();  }finally{
               if(messaggio_errore != '') {
                       gestisciException(messaggio_errore);   
         }}
	}

    private static String creaNote(PV2786CpayStorniGestioneForm form) {
       
		return form.note; 
	}

}