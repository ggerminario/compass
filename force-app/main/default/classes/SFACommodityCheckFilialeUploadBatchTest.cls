@isTest
public with sharing class SFACommodityCheckFilialeUploadBatchTest {

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
        String prodotto = 'CONSUMO';
        String tipoFile = 'Variazioni Anagrafich';
        String row='RS;28;PAPF;19502835;153;50;LA COMACCHIESE SOCIETACOOPER;15588762;ONLY CAR 1 SRL;VARIAZIONE RECAPITI prioritaassa;C40;Variazione di indirizzo o telefono comunicati dal cliente;yyyy;10/05/2019';
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
            OCSAreaId__c = 28,
            Region_Name__c = 'RS',
			Codice_Cliente__c ='16');
		filialeRif.RecordTypeId = RecordTypeUtil.getBranchRecordType();
        insert filialeRif;
         Account dealer = TestDataFactory.insertDealer();
         SFA_ComCheck__c comcheck = new SFA_ComCheck__c(Index__c = 1,Row__c = row,Status__c = '',FilialeId__c = filialeRif.Id,DealerId__c = dealer.Id,FilialeQueueName__c = coda.DeveloperName,FileName__c = fileName,Timestamp__c =timestamp );
         insert comcheck;
      Test.startTest();
      // caso corretto
      String[] colsHeader = SFACommodityUploadCSVController.headerVariazoniAnagraficaConsumo;
      SFACommodityCheckFilialeUploadBatch bat = new  SFACommodityCheckFilialeUploadBatch(colsHeader,fileName,timestamp);         
      Id batchJobId = Database.executeBatch(bat, 1);
      List<SFA_ComCheck__c> comChecks = [SELECT Id FROM SFA_ComCheck__c];
      System.assert(comChecks!=null && comChecks.size()>0);

     // caso con header sbagliato
      String[] colsHeadersbagliato = SFACommodityUploadCSVController.headerConsumoPP;
      SFACommodityCheckFilialeUploadBatch bat2 = new  SFACommodityCheckFilialeUploadBatch(colsHeadersbagliato,fileName,timestamp);         
      batchJobId = Database.executeBatch(bat2, 1);
      comChecks = [SELECT Id FROM SFA_ComCheck__c];
      System.assert(comChecks!=null && comChecks.size()>0);

      Test.stopTest();

      
    }
}