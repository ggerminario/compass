/**
 * @File Name          : PV1772DaCustomerServAFilialeGestione.cls
 * @Description        : 
 * @Author             : Federico Negro
 * @Group              : 
 * @Last Modified By   : Federico Negro
 * @Last Modified On   : 24/1/2020, 14:43:12
 * @Modification Log   : 
 * Ver       Date            Author      		    Modification
 * 1.0    29/10/2019   Federico Negro     Initial Version
**/
//PV1772DaCustomerServAFilialeGestione 
public without sharing class PV1772DaCustomerServAFilialeGestione extends PVActionGestione {

	public class PV1772DaCustomerServAFilialeGestioneForm extends PVForm {
		 @AuraEnabled
        public Boolean rinvia{get;set;}
	}

	@AuraEnabled
	public static void saveCase(PV1772DaCustomerServAFilialeGestioneForm form, Case theCase){
		String messaggio_errore = '';
        system.debug('form' + form);        
		if (form.newStatus == 'Closed' && form.rinvia == true && theCase.Step_PV__c == '2'){
            //form.newStatus
            theCase.Step_PV__c = '5';
        }
		if (form.newStatus == 'Closed' && form.rinvia == true && theCase.Step_PV__c == '6'){
            //form.newStatus
            theCase.Step_PV__c = '1';
        }
		try{
		    saveUtil(form, theCase, creaNote(form,theCase));
		}catch(Exception e) {
			messaggio_errore = e.getMessage();
		}finally{
			if(messaggio_errore != '') {
				gestisciException(messaggio_errore);
			}
		}
	}

	private static String creaNote(PVForm myform, Case theCase) {
		return myForm.note;
	}

    /*

    Se la richiesta viene effettuata da CS il campo codFiliale viene popolato con  il codice dell'ufficio di destinazione.
    Quando la richiesta viene fatta da batch il campo codFiliale rimane vuoto e il motore di regole reindirizza la richiesta a NumeroBlu.

    */

}