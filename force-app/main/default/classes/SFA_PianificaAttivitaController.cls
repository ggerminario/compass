public class SFA_PianificaAttivitaController {
	@Auraenabled
    public static InitWrapper initApex(SFA_Slot__c theSlot){
        
        List<Account> dealers = getDealers(theSlot);
        List<Account> dealersPianificati = getDealersPianificati(theSlot, dealers);
        List<Account> dealersDisabilitati = getDisabledDealers(theSlot, dealersPianificati);
        List<SFA_Slot__c> otherSlots = getOtherSlots(theSlot);
        InitWrapper iw = new InitWrapper(dealers,dealersPianificati,dealersDisabilitati,otherSlots);
        return iw;
    }
    
    @Auraenabled
    public static void PianificaAttivita(SFA_Slot__c theSlot, List<Account> dealers){
        List<SFA_PianificaAttivita__c> pianificaAttivitaList = new List<SFA_PianificaAttivita__c>();
        SFA_NotaSpese__c notaSpese = getNotaSpese(theSlot);
        for(Account dealer : dealers){
            pianificaAttivitaList.add(new SFA_PianificaAttivita__c(Dealer__c=dealer.Id,SFA_Slot__c= theSlot.Id,SFA_Nota_Spese__c = notaSpese.Id));
        }
        upsert pianificaAttivitaList;
    }
    
    @Auraenabled
    public static void RemovePianificaAttivita(List<SFA_PianificaAttivita__c> pianificaAttivitaToRemoveList,SFA_Slot__c theSlot){
        delete pianificaAttivitaToRemoveList;
        evaluateRemoveNotaSpese(theSlot);
    }
/***RICERCA SOSL tentativo
    @Auraenabled
     public static List<Account> searchDealer(SFA_Slot__c theSlot, String search){
        return [FIND :search IN ALL FIELDS RETURNING Account(Name,OCS_External_Id__c,getCodice_Cliente__c,CodiceClienteFilled__c,ShippingStreet,ShippingCity 
        WHERE Zone__c =: theSlot.XCS_Zone__c)  ][0];
     }
*****/
       @AuraEnabled
      public static List<Account> searchDealers(SFA_Slot__c theSlot,String CIP_CF_PIVA, String ragioneSociale){
       // User manager = getCurrentUser();
        String likeExpressionRagioneSociale='%'+ragioneSociale+'%';
        String dealString='Dealer';        
        Id zoneId=theSlot.XCS_Zone__c;
       // String branchOCSCode = manager.DefaultQueueId__c;
        //String query='SELECT Id, Name, Zone__r.Name , ShippingStreet,ShippingCity, CodiceClienteFilled__c, OCS_External_Id__c, Vat_Code__c, FiscalCode__c FROM Account WHERE RecordType.Name =:dealString AND Branch__r.OCS_External_Id__c =: branchOCSCode AND ';

         String query='SELECT Id, Name , OCS_External_Id__c ,getCodice_Cliente__c,CodiceClienteFilled__c, ShippingStreet,ShippingCity, (SELECT Id , Priority FROM Cases WHERE isClosed = false) , (SELECT Id , SFA_Slot__c , SFA_Slot__r.Date__c , SFA_Slot__r.Time__c , SFA_Nota_Spese__r.Status__c  FROM Attivita_Pianificate__r ORDER BY CreatedDate DESC) FROM Account WHERE  Zone__c = :zoneId AND RecordType.DeveloperName = :dealString ';

        if(String.isNotBlank(CIP_CF_PIVA)){
            //query=query+'(OCS_External_Id__c =:CIP_CF_PIVA OR Vat_Code__c =:CIP_CF_PIVA OR FiscalCode__c =:CIP_CF_PIVA)';
            query=query+' AND (CodiceClienteFilled__c =:CIP_CF_PIVA OR Vat_Code__c =:CIP_CF_PIVA OR FiscalCode__c =:CIP_CF_PIVA)';
        }
        if(String.isNotBlank(ragioneSociale)){
            /***
            if(String.isNotBlank(CIP_CF_PIVA)){
                query=query+' AND '; 
            }
            ***/
            query=query+'AND Name LIKE :likeExpressionRagioneSociale';
        }
        //List<Account> accounts= [SELECT Id, Name, Zone__c, BillingAddress, CIP__c, Vat_Code__c, FiscalCode__c 
        //FROM Account
        //WHERE CIP__c =:CIP_CF_PIVA OR Vat_Code__c =:CIP_CF_PIVA OR FiscalCode__c =:CIP_CF_PIVA Name LIKE : %ragioneSociale%];
        List<Account> accounts = Database.query(String.escapeSingleQuotes(query));

        return accounts;
    }
/***NOT USED
     private static User getCurrentUser(){
        String utenteId = UserInfo.getUserId();
        return [SELECT FirstName, LastName,Id,Name,DefaultQueueId__c FROM User WHERE Id =: utenteId];
    }
****/
    private static List<Account> getDealers(SFA_Slot__c theSlot){
        return [SELECT Id, Name , OCS_External_Id__c ,getCodice_Cliente__c,CodiceClienteFilled__c, ShippingStreet,ShippingCity, 
               (SELECT Id , Priority FROM Cases WHERE Status != 'Closed') , 
               (SELECT Id , SFA_Slot__c , SFA_Slot__r.Date__c , SFA_Slot__r.Time__c , SFA_Nota_Spese__r.Status__c  FROM Attivita_Pianificate__r ORDER BY CreatedDate DESC) 
                  FROM Account 
                 WHERE  Zone__c =: theSlot.XCS_Zone__c 
                              AND RecordType.DeveloperName = 'Dealer'];
                              /***20191219 MC Replaced query removed filter on case closed
                 Id IN (SELECT AccountId FROM Case WHERE Status != 'Closed'
                              AND Account.Zone__c =: theSlot.XCS_Zone__c 
                              AND Account.RecordType.DeveloperName = 'Dealer')];
                              ***/
    }
    private static List<SFA_Slot__c> getOtherSlots(SFA_Slot__c theSlot){
        return [SELECT Id,Date__c,Time__c,Branch__c,Status__c,User__c,(SELECT Id , Dealer__c FROM Attivita_Pianificate__r ORDER BY CreatedDate DESC)   FROM SFA_Slot__c WHERE XCS_Zone__c =: theSlot.XCS_Zone__c AND User__c =: theSlot.User__c AND Date__c >= TODAY AND ( Date__c !=: theSlot.Date__c OR Time__c !=: theSlot.Time__c) ORDER BY Date__c ASC];
    }
    private static List<Account> getDealersPianificati(SFA_Slot__c theSlot, List<Account> dealers){
        List<Account> dealersPianificati = new List<Account>();
            
        for(Integer j = 0; j < dealers.size(); j++){
            for(SFA_PianificaAttivita__c pianificaAttivita : dealers[j].Attivita_Pianificate__r){
                if(pianificaAttivita.SFA_Slot__c ==theSlot.Id ){
                    dealersPianificati.add( dealers.remove(dealers.indexOf(dealers[j])) );
                    j--;
                    break;
                }
            }
        }
        return dealersPianificati;
    }
    
    private static List<Account> getDisabledDealers(SFA_Slot__c theSlot, List<Account> dealers){
        List<Account> disabledDealers = new List<Account>();
            
        for(Integer j = 0; j < dealers.size(); j++){
            for(SFA_PianificaAttivita__c pianificaAttivita : dealers[j].Attivita_Pianificate__r){
                if(pianificaAttivita.SFA_Slot__c ==theSlot.Id && pianificaAttivita.SFA_Nota_Spese__r.Status__c != 'Aperta'){
                    disabledDealers.add(dealers[j]);
                    break;
                }
            }
        }
        return disabledDealers;
    }

    public static SFA_NotaSpese__c getNotaSpese(SFA_Slot__c theSlot){

        List<SFA_NotaSpese__c> notaSpeseList = [SELECT Id,Date__c,Time__c,Branch__c,Status__c,User__c FROM SFA_NotaSpese__c WHERE Branch__c =: theSlot.Branch__c AND User__c =: theSlot.User__c AND Date__c =: theSlot.Date__c AND Time__c =: theSlot.Time__c AND Status__c = 'Aperta' ORDER BY CreatedDate DESC];

        if(notaSpeseList.isEmpty()){
            SFA_NotaSpese__c newNotaSpese = new SFA_NotaSpese__c(Date__c = theSlot.Date__c,Time__c = theSlot.Time__c,Branch__c  = theSlot.Branch__c,Status__c = 'Aperta',User__c = theSlot.User__c);     
            insert newNotaSpese;
            return newNotaSpese;
        }else{
            return notaSpeseList[0];
        }

    }

    private static void evaluateRemoveNotaSpese(SFA_Slot__c theSlot){

        List<SFA_NotaSpese__c> notaSpeseList = [SELECT Id,Date__c,Time__c,Branch__c,Status__c,User__c,(SELECT Id FROM Pianifica_Attivita__r) FROM SFA_NotaSpese__c WHERE Branch__c =: theSlot.Branch__c AND User__c =: theSlot.User__c AND Date__c =: theSlot.Date__c AND Time__c =: theSlot.Time__c AND Status__c = 'Aperta' ORDER BY CreatedDate DESC];
        List<SFA_NotaSpese__c> toDeleteList = new List<SFA_NotaSpese__c>();

        for(SFA_NotaSpese__c notaSpese : notaSpeseList){
            if(notaSpese.Pianifica_Attivita__r.isEmpty()){
                toDeleteList.add(notaSpese);
            }
        }
        
        delete toDeleteList;
        
    }
    
    public class InitWrapper{
		@AuraEnabled
		public List<Account> dealers;
        @AuraEnabled
		public List<Account> dealersPianificati;
        @AuraEnabled
		public List<Account> dealersDisabilitati;
        @AuraEnabled
		public List<SFA_Slot__c> otherSlots;

		public InitWrapper(List<Account> dealers, List<Account> dealersPianificati,List<Account> dealersDisabilitati, List<SFA_Slot__c> otherSlots){
			this.dealers= dealers;
			this.dealersPianificati= dealersPianificati;
            this.dealersDisabilitati= dealersDisabilitati;
            this.otherSlots= otherSlots;
		}

	}
}