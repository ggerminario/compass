@isTest(seeAllData=true)
public class PV2133InadempimentoVerbaleFornGestTest {
    static String Categoria='2133';

   static PV2133InadempimentoVerbaleFornitore.PV2133InadempimentoVerbaleFornitoreForm form;
   static PV2133InadempimentoVerbaleFornitoreGest.PV2133InadempimentoVerbaleFornitoreGestioneForm formGestione;
   
   private static void creaPostVendita() {
        
        form=new PV2133InadempimentoVerbaleFornitore.PV2133InadempimentoVerbaleFornitoreForm();
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
        PV2133InadempimentoVerbaleFornitore.conferma(form);

        //Form gestione
        formGestione=new PV2133InadempimentoVerbaleFornitoreGest.PV2133InadempimentoVerbaleFornitoreGestioneForm();
        
        formGestione.pratica=form.pratica;
        formGestione.cliente=form.cliente;
        formGestione.userData=form.userData;
        formGestione.categoriaPV=form.categoriaPV;
        formGestione.motivazione=form.motivazione;
        
   }
   
   @isTest
   public static void testReinvioRispostaMittenteOK(){
       creaPostVendita();
       
       Case casetest = [SELECT Id, Step_PV__c, Status FROM Case WHERE CategoriaExternalId__c = '2133' LIMIT 1];

       System.assert(casetest!=null);

       //reinvio al mittente
       
       formGestione.note='Reinvio test 1';
       formGestione.rinvia=true;
       formGestione.newStatus='Closed';
       
       PV2133InadempimentoVerbaleFornitoreGest.saveCase(formGestione, casetest);
       casetest = [SELECT Id, Step_PV__c, Status FROM Case WHERE id=:casetest.Id];

       System.assert(casetest.Step_PV__c=='4');
       System.assert(casetest.Status=='Risposta ricevuta');
       //risposta del mittente
       
       formGestione.note='Risposta test 1';
       formGestione.rinvia=false;
       formGestione.newStatus='Closed';

       PV2133InadempimentoVerbaleFornitoreGest.saveCase(formGestione, casetest);

       casetest = [SELECT Id, Step_PV__c, Status FROM Case WHERE id=:casetest.Id];

       System.assert(casetest.Step_PV__c=='2');
       System.assert(casetest.Status=='Risposta ricevuta');

       //chiusura del case
       formGestione.note='Chiusura test 1';
       formGestione.rinvia=false;
       formGestione.newStatus='Closed';

       PV2133InadempimentoVerbaleFornitoreGest.saveCase(formGestione, casetest);

       casetest = [SELECT Id, Step_PV__c, Status FROM Case WHERE id=:casetest.Id];

       System.assert(casetest.Step_PV__c=='2');
       System.assert(casetest.Status=='Closed');

   }
}