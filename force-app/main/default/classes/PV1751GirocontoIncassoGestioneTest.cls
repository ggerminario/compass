/**
 * @File Name          : PV1751GirocontoIncassoGestioneTest.cls
 * @Description        : 
 * @Author             : Federico Negro
 * @Group              : 
 * @Last Modified By   : Federico Negro
 * @Last Modified On   : 22/11/2019, 17:07:26
 * @Modification Log   : 
 * Ver       Date            Author      		    Modification
 * 1.0    22/11/2019   Federico Negro     Initial Version
**/

@isTest (SeeAllData=true)
private class PV1751GirocontoIncassoGestioneTest {

    static String Categoria='1751';

	@isTest static void testOK() {

        PVtestFactory pVtestFactory = new PVtestFactory();

        PV1751GirocontoIncassoGestione.PV1751GirocontoIncassoGestioneForm form = new PV1751GirocontoIncassoGestione.PV1751GirocontoIncassoGestioneForm();

        form = (PV1751GirocontoIncassoGestione.PV1751GirocontoIncassoGestioneForm) pVtestFactory.initForm(Categoria, form);
        form.note = 'test';
        form.rinvia = true;
        form.newStatus = 'Closed';

        PV1751GirocontoIncassoGestione gir = new PV1751GirocontoIncassoGestione();

        // preparo un case
		Case caseObj = new Case(
			Categoria_Riferimento__c =  form.categoriaPV.Id,
			Step_PV__c = '2',
			Status = CaseUtils.APERTO
			);

		Test.startTest();

		    PV1751GirocontoIncassoGestione.saveCase( form,  caseObj);

		Test.stopTest();
	}

}