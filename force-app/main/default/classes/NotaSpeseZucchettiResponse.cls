public with sharing class NotaSpeseZucchettiResponse extends OCSResponse {
	
	@AuraEnabled
	public Integer resultCode{get;set;}
	@AuraEnabled
	public String resultMessage{get;set;}
	@AuraEnabled 
	public creaNotaSpeseZucchettiResponse creaNotaSpeseZucchettiResponse {get;set;}

	public class creaNotaSpeseZucchettiResponse {
		@AuraEnabled
 		public String idcompany {get;set;}
		@AuraEnabled
 		public String anno {get;set;}
		@AuraEnabled
 		public String nrnotaspese {get;set;}
 		@AuraEnabled
		public String nrtrasferta {get;set;}
		@AuraEnabled
 		public String esito {get;set;}
		@AuraEnabled
 		public String descerr {get;set;}
	}
}