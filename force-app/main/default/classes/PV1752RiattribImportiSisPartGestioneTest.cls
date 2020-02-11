/**
 * @File Name          : PV1752RiattribImportiSisPartGestioneTest.cls
 * @Description        : 
 * @Author             : Federico Negro
 * @Group              : 
 * @Last Modified By   : Federico Negro
 * @Last Modified On   : 22/11/2019, 17:06:57
 * @Modification Log   : 
 * Ver       Date            Author      		    Modification
 * 1.0    22/11/2019   Federico Negro     Initial Version
**/

@isTest (SeeAllData=true)
private class PV1752RiattribImportiSisPartGestioneTest {

    static String Categoria='1752';

	@isTest static void testOK() {

        PVtestFactory pVtestFactory = new PVtestFactory();

        PV1752RiattribImportiSistemaPartGestione.PV1752RiattribImportiSistemaPartGestioneForm form = new PV1752RiattribImportiSistemaPartGestione.PV1752RiattribImportiSistemaPartGestioneForm();

        form = (PV1752RiattribImportiSistemaPartGestione.PV1752RiattribImportiSistemaPartGestioneForm) pVtestFactory.initForm(Categoria, form);
        form.note = 'test';
        form.rinvia = true;
        form.newStatus = 'Closed';

        PV1752RiattribImportiSistemaPartGestione gir = new PV1752RiattribImportiSistemaPartGestione();

        // preparo un case
		Case caseObj = new Case(
			Categoria_Riferimento__c =  form.categoriaPV.Id,
			Step_PV__c = '2',
			Status = CaseUtils.APERTO
			);

		Test.startTest();

			PV1752RiattribImportiSistemaPartGestione.saveCase( form,  caseObj);

		Test.stopTest();
	}

}