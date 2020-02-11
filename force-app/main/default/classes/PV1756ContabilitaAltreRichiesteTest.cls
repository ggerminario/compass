/**
 * @File Name          : PV1756ContabilitaAltreRichiesteTest.cls
 * @Description        : 
 * @Author             : Federica Forte
 * @Group              : 
 * @Last Modified By   : Federica Forte
 * @Last Modified On   : 18/12/2019, 12:02:00
 * @Modification Log   : 
 * Ver       Date            Author      		    Modification
 * 1.0    18/12/2019   Federica Forte     Initial Version
**/
@isTest(SeeAllData = true) public with sharing class PV1756ContabilitaAltreRichiesteTest {
	static String Categoria = '1756';

    @isTest static void testConfermaOK() {

		PV1756ContabilitaAltreRichieste.PV1756ContabilitaAltreRichiesteForm form = creaForm();
		PV1756ContabilitaAltreRichieste.conferma(form);
	}

    @isTest static void testConfermaKO() {

		PV1756ContabilitaAltreRichieste.PV1756ContabilitaAltreRichiesteForm form = creaForm();
        form.pratica.numPratica='12345678901234567890123456789';

        Exception myException;
        try{
		PV1756ContabilitaAltreRichieste.conferma(form);
        } catch (Exception e){
            myException = e;
        }
        System.assertNotEquals(null, myException);
	}

    

    private static PV1756ContabilitaAltreRichieste.PV1756ContabilitaAltreRichiesteForm creaForm() {
		PVtestFactory pVtestFactory = new PVtestFactory();

		PV1756ContabilitaAltreRichieste.PV1756ContabilitaAltreRichiesteForm form = new PV1756ContabilitaAltreRichieste.PV1756ContabilitaAltreRichiesteForm();

		form = (PV1756ContabilitaAltreRichieste.PV1756ContabilitaAltreRichiesteForm) pVtestFactory.initForm(Categoria, form);

		form.importo = '123';
		form.pratica.numPratica = '12345';
		
		return form;
	}
}