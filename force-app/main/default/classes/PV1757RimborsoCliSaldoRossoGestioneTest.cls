/**
 * @File Name          : PV1757RimborsoCliSaldoRossoGestioneTest.cls
 * @Description        : 
 * @Author             : Federico Negro
 * @Group              : 
 * @Last Modified By   : Federico Negro
 * @Last Modified On   : 22/11/2019, 17:04:23
 * @Modification Log   : 
 * Ver       Date            Author      		    Modification
 * 1.0    22/11/2019   Federico Negro     Initial Version
**/

@isTest (SeeAllData=true)
private class PV1757RimborsoCliSaldoRossoGestioneTest {

    static String Categoria='1757';

	@isTest static void testOK() {

        PVtestFactory pVtestFactory = new PVtestFactory();

        PV1757RimborsoCliSaldoRossoGestione.PV1757RimborsoCliSaldoRossoGestioneForm form = new PV1757RimborsoCliSaldoRossoGestione.PV1757RimborsoCliSaldoRossoGestioneForm();

        form = (PV1757RimborsoCliSaldoRossoGestione.PV1757RimborsoCliSaldoRossoGestioneForm) pVtestFactory.initForm(Categoria, form);
        form.note = 'test';
        form.rinvia = true;
        form.newStatus = 'Closed';

        PV1757RimborsoCliSaldoRossoGestione gir = new PV1757RimborsoCliSaldoRossoGestione();

        // preparo un case
		Case caseObj = new Case(
			Categoria_Riferimento__c =  form.categoriaPV.Id,
			Step_PV__c = '2',
			Status = CaseUtils.APERTO
			);

		Test.startTest();
		PV1757RimborsoCliSaldoRossoGestione.saveCase( form,  caseObj);
       /*try{
        // secondo caso con form null e che manda in errore
            
		    PV1757RimborsoCliSaldoRossoGestione.saveCase(form,caseObj);
		}
		catch(Exception e)
		{
			System.assertNotEquals(e.getMessage(),'');
		}*/

		Test.stopTest();
	}

}