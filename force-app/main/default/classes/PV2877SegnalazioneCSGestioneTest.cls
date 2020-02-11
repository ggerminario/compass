@isTest(seeAllData=true)
public  class PV2877SegnalazioneCSGestioneTest {
	@isTest static void test1() {
        string Categoria = '2877';

		PVtestFactory pVtestFactory = new PVtestFactory();

		PV2877SegnalazioneCSGestione.PV2877SegnalazioneCSGestioneForm form = new PV2877SegnalazioneCSGestione.PV2877SegnalazioneCSGestioneForm();
		form = (PV2877SegnalazioneCSGestione.PV2877SegnalazioneCSGestioneForm) pVtestFactory.initForm(Categoria, form);
		
/*
		pVtestFactory.pushApiList(response1,'ristampaCarnetBollettini');
		pVtestFactory.finalizeApiList();
*/
		Test.startTest();
        PV2877SegnalazioneCSGestione.ComunicazioniOCSListDTO com = new PV2877SegnalazioneCSGestione.ComunicazioniOCSListDTO();
        com.tipologia = 't';
        com.codice = 'c';
        PV2877SegnalazioneCSGestione.savecase(form,new case()); 
		//PV2877SegnalazioneCSGestione.conferma(form);
		Test.stopTest();

	}
}