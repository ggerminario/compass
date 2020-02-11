@isTest(seeAllData=true)
public class PV2786CpayStorniGestioneTest {
    static String Categoria='2786';

   static PV2786CpayStorni.PV2786CpayStorniForm form;
   static PV2786CpayStorniGestione.PV2786CpayStorniGestioneForm formGestione;
   
   private static void creaPostVendita() {
        
        form=new PV2786CpayStorni.PV2786CpayStorniForm();
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

        form.note='Test case 1';
        PV2786CpayStorni.conferma(form);

        //Form gestione
        formGestione=new PV2786CpayStorniGestione.PV2786CpayStorniGestioneForm();
        
        formGestione.pratica=form.pratica;
        formGestione.cliente=form.cliente;
        formGestione.userData=form.userData;
        formGestione.categoriaPV=form.categoriaPV;
        formGestione.motivazione=form.motivazione;
        
   }
   
   @isTest
   public static void testReinvioRispostaMittenteOK(){
       creaPostVendita();
       
       Case casetest = [SELECT Id, Step_PV__c, Status FROM Case WHERE CategoriaExternalId__c = '2786' LIMIT 1];

       System.assert(casetest!=null);

       //reinvio al mittente
       
       formGestione.note='Reinvio test 1';
       formGestione.rinvia=true;
       formGestione.newStatus='Closed';
       
       PV2786CpayStorniGestione.saveCase(formGestione, casetest);
       casetest = [SELECT Id, Step_PV__c, Status FROM Case WHERE id=:casetest.Id];

       System.assert(casetest.Step_PV__c=='4');
       System.assert(casetest.Status=='Risposta ricevuta');
       //risposta del mittente
       
       formGestione.note='Risposta test 1';
       formGestione.rinvia=false;
       formGestione.newStatus='Closed';

       PV2786CpayStorniGestione.saveCase(formGestione, casetest);

       casetest = [SELECT Id, Step_PV__c, Status FROM Case WHERE id=:casetest.Id];

       System.assert(casetest.Step_PV__c=='2');
       System.assert(casetest.Status=='Risposta ricevuta');

       //chiusura del case
       formGestione.note='Chiusura test 1';
       formGestione.rinvia=false;
       formGestione.newStatus='Closed';

       PV2786CpayStorniGestione.saveCase(formGestione, casetest);

       casetest = [SELECT Id, Step_PV__c, Status FROM Case WHERE id=:casetest.Id];

       System.assert(casetest.Step_PV__c=='2');
       System.assert(casetest.Status=='Closed');

   }
}