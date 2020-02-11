/**
 * @File Name          : PV2877SegnalazioneCSInserimentoTest.cls
 * @Description        : 
 * @Author             : Marco Cutolo
 * @Group              : 
 * @Last Modified By   : Marco Cutolo
 * @Last Modified On   : 10/12/2019, 14:53:05
 * @Modification Log   : 
 * Ver       Date            Author      		    Modification
 * 1.0    10/12/2019   Marco Cutolo     Initial Version
**/
@isTest(seeAllData=true)
public class PV2877SegnalazioneCSInserimentoTest {
	static String Categoria='2877';

	@isTest static void test1() {
        OCSPratica pratica = new OCSPratica();


		PVtestFactory pVtestFactory = new PVtestFactory();

		PV2877SegnalazioneCSInserimento.PV2877SegnalazioneCSInserimentoForm form = new PV2877SegnalazioneCSInserimento.PV2877SegnalazioneCSInserimentoForm();
		form = (PV2877SegnalazioneCSInserimento.PV2877SegnalazioneCSInserimentoForm) pVtestFactory.initForm(Categoria, form);
        form.categoria = 'c';
        form.prodotto = 'p';
        form.oggetto = 'o';
        form.argomento  = 'a';
        form.selectedFiliale = 'F189';
        form.selectedPratiche = new List<OCSPratica>();
        form.selectedPratiche.add(pratica);
        form.templateBody = 't';
        

		Test.startTest();
		PV2877SegnalazioneCSInserimento.conferma(form);
        PV2877SegnalazioneCSInserimento.recuperaFiliali();
        PV2877SegnalazioneCSInserimento.recuperaListaArgomenti('87');
        PV2877SegnalazioneCSInserimento.recuperaTemplate('CSE 14 - Chiusura stringa SEPA');
      
		Test.stopTest();

	}

@isTest static void test2() {
        OCSPratica pratica = new OCSPratica();


		PVtestFactory pVtestFactory = new PVtestFactory();

		PV2877SegnalazioneCSInserimento.PV2877SegnalazioneCSInserimentoForm form = new PV2877SegnalazioneCSInserimento.PV2877SegnalazioneCSInserimentoForm();
		form = (PV2877SegnalazioneCSInserimento.PV2877SegnalazioneCSInserimentoForm) pVtestFactory.initForm(Categoria, form);
        form.categoria = 'c';
        form.prodotto = 'p';
        form.oggetto = 'o';
        form.argomento  = 'a';
        form.selectedFiliale = '';
        form.selectedPratiche = new List<OCSPratica>();
        form.selectedPratiche.add(pratica);
        form.templateBody = 't';
        form.sottotipologiaMdt = new PostvenditaConfig_subtype__mdt();
        form.sottotipologiaMdt.uniqueId__c = 87;
        

		Test.startTest();
		PV2877SegnalazioneCSInserimento.conferma(form);
        PV2877SegnalazioneCSInserimento.recuperaFiliali();
        PV2877SegnalazioneCSInserimento.recuperaListaArgomenti('87');
        PV2877SegnalazioneCSInserimento.recuperaTemplate('CSE 14 - Chiusura stringa SEPA');
      
		Test.stopTest();

	}

}