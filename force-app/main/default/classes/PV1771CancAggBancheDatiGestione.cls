/**
 * @File Name          : PV1771CancAggBancheDatiGestione.cls
 * @Description        : 
 * @Author             : Nicola Musicco
 * @Group              : 
 * @Last Modified By   : Nicola Musicco
 * @Last Modified On   : 16/1/2020, 12:13:38
 * @Modification Log   : 
 * Ver       Date            Author      		    Modification
 * 1.0    13/1/2020   Nicola Musicco     Initial Version
**/
public class PV1771CancAggBancheDatiGestione extends PVActionGestione{
    

    public class PV1771CancAggBancheDatiGestioneForm extends PVForm {
     
        @AuraEnabled
        public Boolean rinvia{get;set;}
     
	}

    @AuraEnabled
	public static void saveCase(PV1771CancAggBancheDatiGestioneForm form, Case theCase){
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


    private static String creaNote(PV1771CancAggBancheDatiGestioneForm form) {
       
		return form.note; 
	}
}