/**
 * @File Name          : PV1764AnalisiFusioniAnagraficeInsTest.cls
 * @Description        : 
 * @Author             : Marco Cutolo
 * @Group              : 
 * @Last Modified By   : Marco Cutolo
 * @Last Modified On   : 17/12/2019, 11:04:15
 * @Modification Log   : 
 * Ver       Date            Author      		    Modification
 * 1.0    17/12/2019   Marco Cutolo     Initial Version
**/
@isTest (SeeAllData=true)
public class PV1764AnalisiFusioniAnagraficeInsTest {

    static Boolean truefalse;
	static String Categoria='1764';
    
	//static List<OCSCliente> listaClient = new List<OCSCliente>();
    @isTest static void testConferma() {
		OCSCliente cliente = new OCSCliente();
        PVtestFactory pVtestFactory = new PVtestFactory();

        PV1764AnalisiFusioniAnagraficeIns.PV1764AnalisiFusioniAnagraficeInsForm form = new PV1764AnalisiFusioniAnagraficeIns.PV1764AnalisiFusioniAnagraficeInsForm();
        form = (PV1764AnalisiFusioniAnagraficeIns.PV1764AnalisiFusioniAnagraficeInsForm) pVtestFactory.initForm(Categoria, form);
        form.cliente = new OCSCliente();
		form.cliente.email = 'POSTVENDITA@EMAIL.TEST';
		form.cliente.codCliente = '1';
		form.cliente.cognome = 'COGNOM';
		form.cliente.nome = 'NOM';
		form.userData.user.Branch_Or_Office__c ='FIL';
		form.cliente.denominazioneAzienda = 'NOM COGNOM';
		form.cliente.dataNascita = '20100102';
        form.userData.accountOffice.Name='test';         
		form.clientiSelezionati= new List<OCSCliente>();
        form.clientiSelezionati.add(form.cliente);
        form.note = 'richiesta creata automaticamente';
        form.pratica = new OCSPratica();
		form.pratica.tipoPratica = 'CA';
		form.pratica.numPratica = '1';
		
        Test.startTest();
		PV1764AnalisiFusioniAnagraficeIns.conferma(form);
		try{
			PV1764AnalisiFusioniAnagraficeIns.conferma(null);
		} catch(Exception e) {
			System.assertNotEquals(e.getMessage(),'');
		}
		Test.stopTest();
    }
     @isTest static void testDoCheckAnagraficaA() {
		OCSCliente cliente = new OCSCliente();
        string response = '{ "resultCode": 0,"resultMessage": "Ok","recuperaSegnalazioniClienteResponse": { "causaleAnnullo":"test", "dataAnnullo":"20191010","elencoSegnalazioni": [{ "tipoSegnalazione": "H3C"}]}} ';
        PVtestFactory pVtestFactory = new PVtestFactory();
		//Form
        PV1764AnalisiFusioniAnagraficeIns.PV1764AnalisiFusioniAnagraficeInsForm form = new PV1764AnalisiFusioniAnagraficeIns.PV1764AnalisiFusioniAnagraficeInsForm();
        form = (PV1764AnalisiFusioniAnagraficeIns.PV1764AnalisiFusioniAnagraficeInsForm) pVtestFactory.initForm(Categoria, form);
        form.cliente = new OCSCliente();
		form.cliente.email = 'POSTVENDITA@EMAIL.TEST';
		form.cliente.codCliente = '1';
		form.cliente.cognome = 'COGNOM';
		form.cliente.nome = 'NOM';
		form.userData.user.Branch_Or_Office__c ='FIL';
		form.cliente.denominazioneAzienda = 'NOM COGNOM';
		form.cliente.dataNascita = '20100102';
		form.cliente.tipoAnagrafica ='A';
        form.userData.accountOffice.Name='test';         
		form.clientiSelezionati= new List<OCSCliente>();
        form.clientiSelezionati.add(form.cliente);
        form.note = 'richiesta creata automaticamente';
        form.pratica = new OCSPratica();
		form.pratica.tipoPratica = 'CA';
		form.pratica.numPratica = '1';
		//End form
		pVtestFactory.pushApiList(response,'recuperaSegnalazioniCliente');
        pVtestFactory.finalizeApiList(); 

        Test.startTest();
        PV1764AnalisiFusioniAnagraficeIns.doCheck(form.cliente);	
		Test.stopTest();
    }

	 @isTest static void testDoCheckAnagraficaP() {
		OCSCliente cliente = new OCSCliente();
        string response = '{ "resultCode": 0,"resultMessage": "Ok","recuperaSegnalazioniClienteResponse": { "causaleAnnullo":"test", "dataAnnullo":"20191010","elencoSegnalazioni": [{ "tipoSegnalazione": "H3C"}]}} ';
        PVtestFactory pVtestFactory = new PVtestFactory();
		//Form
        PV1764AnalisiFusioniAnagraficeIns.PV1764AnalisiFusioniAnagraficeInsForm form = new PV1764AnalisiFusioniAnagraficeIns.PV1764AnalisiFusioniAnagraficeInsForm();
        form = (PV1764AnalisiFusioniAnagraficeIns.PV1764AnalisiFusioniAnagraficeInsForm) pVtestFactory.initForm(Categoria, form);
        form.cliente = new OCSCliente();
		form.cliente.email = 'POSTVENDITA@EMAIL.TEST';
		form.cliente.codCliente = '1';
		form.cliente.cognome = 'COGNOM';
		form.cliente.nome = 'NOM';
		form.userData.user.Branch_Or_Office__c ='FIL';
		form.cliente.denominazioneAzienda = 'NOM COGNOM';
		form.cliente.dataNascita = '20100102';
		form.cliente.tipoAnagrafica ='P';
        form.userData.accountOffice.Name='test';         
		form.clientiSelezionati= new List<OCSCliente>();
        form.clientiSelezionati.add(form.cliente);
        form.note = 'richiesta creata automaticamente';
        form.pratica = new OCSPratica();
		form.pratica.tipoPratica = 'CA';
		form.pratica.numPratica = '1';
		//End form
		pVtestFactory.pushApiList(response,'recuperaSegnalazioniCliente');
        pVtestFactory.finalizeApiList(); 

        Test.startTest();
        PV1764AnalisiFusioniAnagraficeIns.doCheck(form.cliente);	
		Test.stopTest();
    }

	@isTest static void testDoCheckDocumenti() {
		OCSCliente cliente = new OCSCliente();
        PVtestFactory pVtestFactory = new PVtestFactory();
        PV1764AnalisiFusioniAnagraficeIns.PV1764AnalisiFusioniAnagraficeInsForm form = new PV1764AnalisiFusioniAnagraficeIns.PV1764AnalisiFusioniAnagraficeInsForm();

        form = (PV1764AnalisiFusioniAnagraficeIns.PV1764AnalisiFusioniAnagraficeInsForm) pVtestFactory.initForm(Categoria, form);

        form.cliente = new OCSCliente();
		form.cliente.email = 'POSTVENDITA@EMAIL.TEST';
		form.cliente.codCliente = '1';
		form.cliente.cognome = 'COGNOM';
		form.cliente.nome = 'NOM';
		form.userData.user.Branch_Or_Office__c ='FIL';
		form.cliente.denominazioneAzienda = 'NOM COGNOM';
		form.cliente.dataNascita = '20100102';
		form.cliente.tipoAnagrafica ='A';
        form.userData.accountOffice.Name='test';         
		form.clientiSelezionati= new List<OCSCliente>();
        form.clientiSelezionati.add(form.cliente);
        form.note = 'richiesta creata automaticamente';
        form.pratica = new OCSPratica();
		form.pratica.tipoPratica = 'CA';
		form.pratica.numPratica = '1';
       
	    Test.startTest();
        PV1764AnalisiFusioniAnagraficeIns.doCheckDocumenti(form.clientiSelezionati);
		Test.stopTest();
    } 
 @isTest static void testMultipleClient() {
		OCSCliente cliente1 = new OCSCliente();
        PVtestFactory pVtestFactory = new PVtestFactory();

        PV1764AnalisiFusioniAnagraficeIns.PV1764AnalisiFusioniAnagraficeInsForm form = new PV1764AnalisiFusioniAnagraficeIns.PV1764AnalisiFusioniAnagraficeInsForm();
        form = (PV1764AnalisiFusioniAnagraficeIns.PV1764AnalisiFusioniAnagraficeInsForm) pVtestFactory.initForm(Categoria, form);
        form.cliente = new OCSCliente();
		form.cliente.email = 'POSTVENDITA@EMAIL.TEST';
		form.cliente.codCliente = '1';
		form.cliente.cognome = 'COGNOM';
		form.cliente.nome = 'NOM';
		form.userData.user.Branch_Or_Office__c ='FIL';
		form.cliente.denominazioneAzienda = 'NOM COGNOM';
		form.cliente.dataNascita = '20100102';
        form.userData.accountOffice.Name='test';         
		form.clientiSelezionati= new List<OCSCliente>();
     	cliente1.email = 'POSTVENDITA1@EMAIL.TEST';
		cliente1.codCliente = '2';
		cliente1.cognome = 'COGNOME';
		cliente1.nome = 'NOME';
		cliente1.denominazioneAzienda = 'NOME COGNOME';
		cliente1.dataNascita = '20100103';
     
        form.clientiSelezionati.add(form.cliente);
     	form.clientiSelezionati.add(cliente1);
     
        form.note = 'richiesta creata automaticamente';
        form.pratica = new OCSPratica();
		form.pratica.tipoPratica = 'CA';
		form.pratica.numPratica = '1';
		
        Test.startTest();
		PV1764AnalisiFusioniAnagraficeIns.conferma(form);
		try{
			PV1764AnalisiFusioniAnagraficeIns.conferma(null);
		} catch(Exception e) {
			System.assertNotEquals(e.getMessage(),'');
		}
		Test.stopTest();
    }
}