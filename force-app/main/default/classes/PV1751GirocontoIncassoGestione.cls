/**
 * @File Name          : PV1751GirocontoIncassoGestione.cls
 * @Description        : 
 * @Author             : sabrina vitali
 * @Group              : 
 * @Last Modified By   : Federico Negro
 * @Last Modified On   : 22/11/2019, 17:07:13
 * @Modification Log   : 
 * Ver       Date            Author      		    Modification
 * 1.0    21/11/2019   sabrina vitali     Initial Version
**/
public class PV1751GirocontoIncassoGestione extends PVActionGestione{
	public class PV1751GirocontoIncassoGestioneForm extends PVForm {
        @AuraEnabled
        public Boolean rinvia{get;set;}
	}

	public PV1751GirocontoIncassoGestione() {
	}
    
    @AuraEnabled
	public static void saveCase(PV1751GirocontoIncassoGestioneForm form, Case theCase){
		String messaggio_errore = '';
        system.debug('theCase : ' + theCase);	//verificare quando scaarto da batch per filiale
        // modifico il case
        // se voglio forzare lo stato devo modificare form.newStatus
        system.debug('form' + form);        
        if (form.newStatus == 'Closed' && form.rinvia == true){
            //form.newStatus
            theCase.Step_PV__c = '3';
        }

		try{
		    saveUtil(form, theCase, creaNote(form,theCase));
		}catch(Exception e) {	messaggio_errore = e.getMessage();	}finally{	if(messaggio_errore != '') {	gestisciException(messaggio_errore);	}}
	}

	private static String creaNote(PV1751GirocontoIncassoGestioneForm form, Case theCase) {
        String nota = form.note + '\n';
		return nota; 
	}

}