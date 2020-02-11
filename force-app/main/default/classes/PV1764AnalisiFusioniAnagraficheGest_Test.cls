/**
 * @File Name          : PV1764AnalisiFusioniAnagraficheGest_Test.cls
 * @Description        : 
 * @Author             : Matteo Gobbo
 * @Group              : 
 * @Last Modified By   : Matteo Gobbo
 * @Last Modified On   : 10/1/2020, 09:39:02
 * @Modification Log   : 
 * Ver       Date            Author      		    Modification
 * 1.0    17/12/2019   Matteo Gobbo     Initial Version
**/
@isTest(seeAllData=true)
public  class PV1764AnalisiFusioniAnagraficheGest_Test {
    @isTest static void test1() {
        List<String> ListaCodClienti= new List<String> {'12','9529151','9529124'};
		List<OCSCliente> clienti = new List<OCSCliente>();
		OCSCliente c = new OCSCliente();
		c.codCliente = '123456';
		c.ndg = '789';
		clienti.add(c);
        string Categoria = '1764';    
        String response = '{"resultCode":0,"resultMessage":"Ok","pratiche":[{"numPratica":"800000329783","codCliente":"9529124","tipoPratica":"CA","statoPratica":"CF"}],"cliente":[{"cognome":"UTMOBZE","codCliente":"9529124","nome":"LERRIO"}]}';
		PVtestFactory pVtestFactory = new PVtestFactory();

		PV1764AnalisiFusioniAnagraficheGestione.PV1764AnalisiFusioniAnagraficheGestioneForm form = new PV1764AnalisiFusioniAnagraficheGestione.PV1764AnalisiFusioniAnagraficheGestioneForm();
		form = (PV1764AnalisiFusioniAnagraficheGestione.PV1764AnalisiFusioniAnagraficheGestioneForm) pVtestFactory.initForm(Categoria, form);
        form.tipoannullamento='Fisico';
		form.clienteDaMantenere = '123456';
		form.clientiNDG = clienti;
		

		pVtestFactory.pushApiList(response,'RecuperoDatiPostVendita');
		pVtestFactory.finalizeApiList();
        
        Test.startTest();
        
        PV1764AnalisiFusioniAnagraficheGestione.getClienti(ListaCodClienti); 
		PV1764AnalisiFusioniAnagraficheGestione.recuperaTemplate('Email Ufficio sistemi Fusione Anagrafica',clienti,ListaCodClienti[0]);
		PV1764AnalisiFusioniAnagraficheGestione.fetchUserDetail();
		PV1764AnalisiFusioniAnagraficheGestione.saveCase(form, new Case());
		
		Test.stopTest();

	}
	@isTest static void test2() {
        List<String> ListaCodClienti= new List<String> {'12','9529151','9529124'};
		List<OCSCliente> clienti = new List<OCSCliente>();
		OCSCliente c = new OCSCliente();
		c.codCliente = '123456';
		c.ndg = '789';
		clienti.add(c);
        string Categoria = '1764';    
        String response = '{"resultCode":0,"resultMessage":"Ok","pratiche":[{"numPratica":"800000329783","codCliente":"9529124","tipoPratica":"CA","statoPratica":"CF"}],"cliente":[{"cognome":"UTMOBZE","codCliente":"9529124","nome":"LERRIO"}]}';
		PVtestFactory pVtestFactory = new PVtestFactory();

		PV1764AnalisiFusioniAnagraficheGestione.PV1764AnalisiFusioniAnagraficheGestioneForm form = new PV1764AnalisiFusioniAnagraficheGestione.PV1764AnalisiFusioniAnagraficheGestioneForm();
		form = (PV1764AnalisiFusioniAnagraficheGestione.PV1764AnalisiFusioniAnagraficheGestioneForm) pVtestFactory.initForm(Categoria, form);
        form.tipoannullamento='Logico';
		form.clienteDaMantenere = '123456';
		form.clientiNDG = clienti;
		
		pVtestFactory.pushApiList(response,'RecuperoDatiPostVendita');
		pVtestFactory.finalizeApiList();
        
        Test.startTest();
        
        PV1764AnalisiFusioniAnagraficheGestione.getClienti(ListaCodClienti); 
		PV1764AnalisiFusioniAnagraficheGestione.recuperaTemplate('Email Ufficio sistemi Fusione Anagrafica',clienti,ListaCodClienti[0]);
		PV1764AnalisiFusioniAnagraficheGestione.fetchUserDetail();
		PV1764AnalisiFusioniAnagraficheGestione.saveCase(form, new Case());
		
		Test.stopTest();

	}

   
}