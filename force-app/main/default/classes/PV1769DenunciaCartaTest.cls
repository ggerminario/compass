@ isTest(SeeAllData = true) public with sharing class PV1769DenunciaCartaTest {
	static String Categoria = '1769';

	@isTest static void testConferma() { 

		PV1769DenunciaCarta.PV1769DenunciaCartaForm form = creaForm();


        Test.startTest();
		PV1769DenunciaCarta.conferma(form);

		Test.stopTest();
	}

    public static PV1769DenunciaCarta.PV1769DenunciaCartaForm creaForm(){
        PVtestFactory pVtestFactory = new PVtestFactory();

		PV1769DenunciaCarta.PV1769DenunciaCartaForm form = new PV1769DenunciaCarta.PV1769DenunciaCartaForm();

		return (PV1769DenunciaCarta.PV1769DenunciaCartaForm) pVtestFactory.initForm(Categoria, form);
    }
}