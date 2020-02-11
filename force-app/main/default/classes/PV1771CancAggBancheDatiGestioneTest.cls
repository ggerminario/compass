/**
 * @File Name          : PV1771CancAggBancheDatiGestioneTest.cls
 * @Description        : 
 * @Author             : Nicola Musicco
 * @Group              : 
 * @Last Modified By   : Nicola Musicco
 * @Last Modified On   : 16/1/2020, 14:47:39
 * @Modification Log   : 
 * Ver       Date            Author      		    Modification
 * 1.0    15/1/2020   Nicola Musicco     Initial Version
**/
@IsTest(SeeAllData=true)
public  class PV1771CancAggBancheDatiGestioneTest {
   
   static String Categoria='1771';

   static PV1771CancAggBancheDati.PV1771CancAggBancheDatiForm form;
   static PV1771CancAggBancheDatiGestione.PV1771CancAggBancheDatiGestioneForm formGestione;
   
   private static void creaPostVendita() {
        
        form=new PV1771CancAggBancheDati.PV1771CancAggBancheDatiForm();
        //inserimento postvendita
        form.pratica = new OCSPratica();
		form.cliente = new OCSCliente();
        form.pratica.tipoPratica = 'CA';
		form.pratica.numPratica = '1';
		form.cliente.email = 'POSTVENDITA@EMAIL.TEST';

		form.cliente.codCliente = '1';
		form.cliente.cognome = 'COGNOME';
		form.cliente.nome = 'NOME';
		form.cliente.denominazioneAzienda = 'NOME COGNOME';
		form.cliente.dataNascita = '20100101';
		form.userData = new PVForm.UserData();

		form.userData.user = [SELECT Alias, Name, LastName, FirstName, UserRole.Name, Branch_Or_Office__c,  UserRole.DeveloperName, DefaultQueueId__c FROM User Where Branch_Or_Office__c = 'FIL' LIMIT 1];
		System.debug('### userData.user : '+form.userData.user);
        form.categoriaPV = [SELECT Id,Name,XCS_Template__c,XCS_Disposition__c,XCS_Template__r.Body__c,External_Id__c FROM XCS_Categoria__c WHERE External_Id__c = :categoria][0];
		form.userData.accountOffice = AccountUtils.getBranch(form.userData.user.DefaultQueueId__c.substring(1, form.userData.user.DefaultQueueId__c.length()))[0];


		form.motivazione = 'MOTIVAZIONE';

        form.dataEstinzione='2019-06-13';
        form.note='Test case 1';
        PV1771CancAggBancheDati.conferma(form);

        //Form gestione
        formGestione=new PV1771CancAggBancheDatiGestione.PV1771CancAggBancheDatiGestioneForm();
        
        formGestione.pratica=form.pratica;
        formGestione.cliente=form.cliente;
        formGestione.userData=form.userData;
        formGestione.categoriaPV=form.categoriaPV;
        formGestione.motivazione=form.motivazione;
        
   }
   
   @isTest
   public static void testReinvioRispostaMittenteOK(){
       creaPostVendita();
       
       Case casetest = [SELECT Id, Step_PV__c, Status FROM Case WHERE CategoriaExternalId__c = '1771' LIMIT 1];

       System.assert(casetest!=null);

       //reinvio al mittente
       
       formGestione.note='Reinvio test 1';
       formGestione.rinvia=true;
       formGestione.newStatus='Closed';
       
       PV1771CancAggBancheDatiGestione.saveCase(formGestione, casetest);
       casetest = [SELECT Id, Step_PV__c, Status FROM Case WHERE id=:casetest.Id];

       System.assert(casetest.Step_PV__c=='4');
       System.assert(casetest.Status=='Risposta ricevuta');
       //risposta del mittente
       
       formGestione.note='Risposta test 1';
       formGestione.rinvia=false;
       formGestione.newStatus='Closed';

       PV1771CancAggBancheDatiGestione.saveCase(formGestione, casetest);

       casetest = [SELECT Id, Step_PV__c, Status FROM Case WHERE id=:casetest.Id];

       System.assert(casetest.Step_PV__c=='2');
       System.assert(casetest.Status=='Risposta ricevuta');

       //chiusura del case
       formGestione.note='Chiusura test 1';
       formGestione.rinvia=false;
       formGestione.newStatus='Closed';

       PV1771CancAggBancheDatiGestione.saveCase(formGestione, casetest);

       casetest = [SELECT Id, Step_PV__c, Status FROM Case WHERE id=:casetest.Id];

       System.assert(casetest.Step_PV__c=='2');
       System.assert(casetest.Status=='Closed');

   }
}