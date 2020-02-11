@isTest
public with sharing class SFACommodityUploadCSVControllerTest {

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
    public static void test1(){
        String csv='CARTA ;DIP;SOC ;CLIENTE ;COD_CV;CONVENZIONATO;COD_PV ;PUNTO_VENDITA;CATEGORIA;COD_ESITO ;DESCR_ESITO ;NOTA_SOC_ESTERNA ;DATA_NOTIFICA\n 803119275995;80;20;SCARCELLI CIRO;15588762;MILLENIA SRL;167442;MILLENIA SRL;ALTRO;C29;Altro:impossibilità di procedero, cliente deceduto, etc..;Cliente ci informa di non ricordare nulla del finanziamento in corso.;20/02/2017';
        String fileName = 'test.csv';
        Test.startTest();
        SFACommodityUploadCSVController.Result result = SFACommodityUploadCSVController.checkRecordsCSV(csv,'CARTA','Esiti Anomali',fileName);
         List<SFA_ComCheck__c> listsfacheck = null;
        if (result!=null)  {
            listsfacheck = SFACommodityUploadCSVController.listRecordsCompleted(fileName,result.timestamp);
        }
        Test.stopTest();
        System.assert(result!=null &&  String.isEmpty(result.error) && listsfacheck==null);
    }

    @isTest
    public static void test2(){
        Test.startTest();
        List<String> listTipiFile = SFACommodityUploadCSVController.listTipiFile();
        List<String> listProdotti  = SFACommodityUploadCSVController.listProdotti();
        Test.stopTest();
        System.assert(listTipiFile!=null && listProdotti!=null);
    }

    @isTest
    public static void test3(){
        Test.startTest();
        SFACommodityUploadCSVController.removeExistingLoading('filename','12345678');
        SFACommodityUploadCSVController.CacheCaricamento cache = SFACommodityUploadCSVController.checkExistingLoading();
        Test.stopTest();
        System.assert(cache==null);
    }

    @isTest
    public static void test4(){
         String fileName = 'test.csv';
         String timestamp = '12345678';
         String prodotto = 'CARTA';
         String tipoFile = 'Esiti Anomali';
         String row='803119275995;80;20;SCARCELLI CIRO;15588762;MILLENIA SRL;167442;MILLENIA SRL;ALTRO;C29;Altro:impossibilità di procedero, cliente deceduto, etc..;Cliente ci informa di non ricordare nulla del finanziamento in corso.;20/02/2017';
         Group coda = new Group();
         coda.Name = 'Name77';
         coda.DeveloperName = 'F77Test';
         coda.Type = 'queue';
         insert coda; 
        Account filialeRif = new Account(
            Name = 'Filiale',                        
            Data_Nascita__c = Date.valueOf('1944-08-23'),
            Customer_Type__c = 'Compass',
            Type = 'FIL',
			OCS_External_Id__c = coda.DeveloperName, 
			Codice_Cliente__c ='16');
		filialeRif.RecordTypeId = RecordTypeUtil.getBranchRecordType();
        insert filialeRif;
         Account dealer = TestDataFactory.insertDealer();
         SFA_ComCheck__c comcheck = new SFA_ComCheck__c(Index__c = 1,Row__c = row,Status__c = SFACommodityCheckUploadBatch.OK,FilialeId__c = filialeRif.Id,DealerId__c = dealer.Id,FilialeQueueName__c = coda.DeveloperName,FileName__c = fileName,Timestamp__c =timestamp );
         insert comcheck;
         Test.startTest();
         String result = null;
         try {
             // da aggiustare
             result = SFACommodityUploadCSVController.createCasesCommodity(fileName,timestamp,prodotto,tipoFile);
         } catch (Exception ex) {
            ex.getStackTraceString();
         }
         Test.stopTest();
         System.assert(result==null);
    }


}