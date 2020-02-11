public with sharing class PV2790_2794ImportoDataOperazioneForm extends PVForm {
    @AuraEnabled
	public static CSEInterrogazioneSaldoLightInvoker.Response doCalcolaSaldo(String input){
		return CSEInterrogazioneSaldoLightInvoker.invoke(input);
	}

	@AuraEnabled
	public static Date add29days(String dataOperazione){
		 return Date.valueOf(dataOperazione).addDays(29);		
	}
}