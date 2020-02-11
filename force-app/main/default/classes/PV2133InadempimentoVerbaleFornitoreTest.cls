@isTest(seeAllData=true)
public  class PV2133InadempimentoVerbaleFornitoreTest {
    @isTest static void test() {

        string Categoria = '2133';    
		PVtestFactory pVtestFactory = new PVtestFactory();

		PV2133InadempimentoVerbaleFornitore.PV2133InadempimentoVerbaleFornitoreForm form = new PV2133InadempimentoVerbaleFornitore.PV2133InadempimentoVerbaleFornitoreForm();
		form = (PV2133InadempimentoVerbaleFornitore.PV2133InadempimentoVerbaleFornitoreForm) pVtestFactory.initForm(Categoria, form);
		
        
        PV2133InadempimentoVerbaleFornitore.PV2133InadempimentoVerbaleFornitoreForm form1 = new PV2133InadempimentoVerbaleFornitore.PV2133InadempimentoVerbaleFornitoreForm();
        form1 = (PV2133InadempimentoVerbaleFornitore.PV2133InadempimentoVerbaleFornitoreForm) pVtestFactory.initForm(categoria, form1);
        form1.userData.accountOffice = null;


        String messaggio_errore = '';
        String errorMessage = '';
        
        Test.startTest();
        PV2133InadempimentoVerbaleFornitore.conferma(form);
        try{
            PV2133InadempimentoVerbaleFornitore.conferma(form1);
        }catch(Exception e) {
			messaggio_errore = errorMessage;
			//System.debug('TEST EMAIL EXCEPTION ERRORE:' + messaggio_errore);
		}finally{
			if(messaggio_errore != '') {
				PV2133InadempimentoVerbaleFornitore.gestisciException(messaggio_errore);
			}
		}
        Test.stopTest();
        
    }
}