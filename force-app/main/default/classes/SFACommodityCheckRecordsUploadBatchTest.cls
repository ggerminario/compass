@Istest
public with sharing class SFACommodityCheckRecordsUploadBatchTest {

    @TestSetup
    static void makeData(){
        XCS_Categoria__c cat =  new  XCS_Categoria__c(External_Id__c = XCS_CategoriaUtil.COMMODITY_CHECK_ANOMALY);
        insert cat;
        XCS_Categoria__c cat2 =  new  XCS_Categoria__c(External_Id__c = XCS_CategoriaUtil.COMMODITY_CHECK_CRITICAL);
        insert cat2;
        XCS_Categoria__c cat3 =  new  XCS_Categoria__c(External_Id__c = XCS_CategoriaUtil.COMMODITY_CHECK_VARIAZIONE_ANAGRAFICA);
        insert cat3;

    }

    
    @isTest
    public static void runBatchTest() {
        String fileName = 'test.csv';
        String timestamp = '12345678';
        String prodotto = 'CARTA';
        String tipoFile = 'Esiti Anomali';
        String row='803119275995;80;20;SCARCELLI CIRO;15588762;MILLENIA SRL;167442;MILLENIA SRL;ALTRO;C29;Altro:impossibilità di procedero, cliente deceduto, etc..;Cliente ci informa di non ricordare nulla del finanziamento in corso.;20/02/2017';
        String row_err='803119275995;80;20;SCARCELLI CIRO;15588762;MILLENIA SRL;167442;MILLENIA SRL;ALTRO;C29;Altro:impossibilità di procedero, cliente deceduto, etc..;Cliente ci informa di non ricordare nulla del finanziamento in corso.;202/2017';
        String row_err2='803119275995;80;20;SCARCELLI CIRO;15588762;MILLENIA SRL;167442;MILLENIA SRL;ALTRO;;Altro:impossibilità di procedero, cliente deceduto, etc..;Cliente ci informa di non ricordare nulla del finanziamento in corso.;20/02/2017';
         Group coda = new Group();
         coda.Name = 'Name77';
         coda.DeveloperName = 'F77Test';
         coda.Type = 'queue';
         insert coda; 
        Account filialeRif = new Account(
            Name = 'Filiale',                        
            Data_Nascita__c = Date.valueOf('1944-08-23'),
            Customer_Type__c = 'Compass',
			OCS_External_Id__c = coda.DeveloperName, 
			Codice_Cliente__c ='16');
		filialeRif.RecordTypeId = RecordTypeUtil.getBranchRecordType();
        insert filialeRif;
         Account dealer = TestDataFactory.insertDealer();
         SFA_ComCheck__c comcheck = new SFA_ComCheck__c(Index__c = 1,Row__c = row,Status__c = '',FilialeId__c = filialeRif.Id,DealerId__c = dealer.Id,FilialeQueueName__c = coda.DeveloperName,FileName__c = fileName,Timestamp__c =timestamp );
         insert comcheck;
         SFA_ComCheck__c comcheck_err = new SFA_ComCheck__c(Index__c = 2,Row__c = row_err,Status__c = '',FilialeId__c = filialeRif.Id,DealerId__c = dealer.Id,FilialeQueueName__c = coda.DeveloperName,FileName__c = fileName,Timestamp__c =timestamp );
         insert comcheck_err;
         SFA_ComCheck__c comcheck_err2 = new SFA_ComCheck__c(Index__c = 3,Row__c = row_err2,Status__c = '',FilialeId__c = filialeRif.Id,DealerId__c = dealer.Id,FilialeQueueName__c = coda.DeveloperName,FileName__c = fileName,Timestamp__c =timestamp );
         insert comcheck_err2;
      Test.startTest();
      String[] colsHeader = SFACommodityUploadCSVController.headerCarta;
      SFACommodityCheckRecordsUploadBatch bat = new  SFACommodityCheckRecordsUploadBatch(colsHeader,fileName,timestamp);         
      Id batchJobId = Database.executeBatch(bat, 3);
      Test.stopTest();
      List<SFA_ComCheck__c> comChecks = [SELECT Id FROM SFA_ComCheck__c];
      System.assert(comChecks!=null && comChecks.size()>0);


      
    }
}