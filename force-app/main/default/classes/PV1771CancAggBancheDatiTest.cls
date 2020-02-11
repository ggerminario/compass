/**
 * @File Name          : PV1771CancAggBancheDatiTest.cls
 * @Description        : 
 * @Author             : Nicola Musicco
 * @Group              : 
 * @Last Modified By   : Nicola Musicco
 * @Last Modified On   : 16/1/2020, 11:16:24
 * @Modification Log   : 
 * Ver       Date            Author      		    Modification
 * 1.0    8/1/2020   Nicola Musicco     Initial Version
**/
@IsTest(SeeAllData=true)
public  class PV1771CancAggBancheDatiTest {
    
    static String Categoria='1771';

    @IsTest
    public static void testOK(){
        
        
        PV1771CancAggBancheDati.PV1771CancAggBancheDatiForm form=new PV1771CancAggBancheDati.PV1771CancAggBancheDatiForm();
        
        //inserimento postvendita
        form.pratica = new OCSPratica();
		form.cliente = new OCSCliente();
        form.cliente.codCliente = '1';
		form.cliente.cognome = 'COGNOME';
		form.cliente.nome = 'NOME';
		form.cliente.denominazioneAzienda = 'NOME COGNOME';
		form.cliente.dataNascita = '20100101';
        
        form.userData = new PVForm.UserData();
        
        form.userData.user = [SELECT Alias, Name, LastName, FirstName, UserRole.Name, Branch_Or_Office__c,  UserRole.DeveloperName, DefaultQueueId__c FROM User Where Branch_Or_Office__c = 'FIL' LIMIT 1];
		System.debug('### userData.user : '+form.userData.user);
        
        form.categoriaPV = [SELECT Id,Name,XCS_Template__c,XCS_Disposition__c,XCS_Template__r.Body__c,External_Id__c FROM XCS_Categoria__c WHERE External_Id__c = :categoria][0];
        form.userData.accountOffice =AccountUtils.getBranch(form.userData.user.DefaultQueueId__c.substring(1, form.userData.user.DefaultQueueId__c.length()))[0];
            
        //
		
    
        System.debug('### userData.accountOffice : '+form.userData.accountOffice);
        form.pratica.tipoPratica = 'CA';
		form.pratica.numPratica = '1';
        form.dataEstinzione='2019-06-13';
        form.note='Test';
        PV1771CancAggBancheDati.conferma(form);
    }

    @IsTest
    public static void testKO(){

        PV1771CancAggBancheDati.PV1771CancAggBancheDatiForm form=new PV1771CancAggBancheDati.PV1771CancAggBancheDatiForm();
        
        try {
            PV1771CancAggBancheDati.conferma(form);
        } catch (Exception e) {
            System.assert(e!=null);
        }
        
    }
}