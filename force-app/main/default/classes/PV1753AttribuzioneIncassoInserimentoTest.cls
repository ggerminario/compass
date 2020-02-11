@isTest(seeAllData=true)
public class PV1753AttribuzioneIncassoInserimentoTest {
    @isTest static void test() {

        string Categoria = '1753';    
		PVtestFactory pVtestFactory = new PVtestFactory();

		PV1753AttribuzioneIncassoInserimento.PV1753AttribuzioneIncassoInserimentoForm form = new PV1753AttribuzioneIncassoInserimento.PV1753AttribuzioneIncassoInserimentoForm();
		form = (PV1753AttribuzioneIncassoInserimento.PV1753AttribuzioneIncassoInserimentoForm) pVtestFactory.initForm(Categoria, form);
        form.importoIncasso = '55';
        form.dataIncasso = Date.newInstance(2020,01,01);
		
        
        PV1753AttribuzioneIncassoInserimento.PV1753AttribuzioneIncassoInserimentoForm form1 = new PV1753AttribuzioneIncassoInserimento.PV1753AttribuzioneIncassoInserimentoForm();
        form1 = (PV1753AttribuzioneIncassoInserimento.PV1753AttribuzioneIncassoInserimentoForm) pVtestFactory.initForm(categoria, form1);
        form1.importoIncasso = '55';
        form1.userData.accountOffice = null;
        form1.dataIncasso = Date.newInstance(2020,01,01);

        String messaggio_errore = '';
        String errorMessage = '';
        
        Test.startTest();
        PV1753AttribuzioneIncassoInserimento.conferma(form);
        try{
            PV1753AttribuzioneIncassoInserimento.conferma(form1);
        }catch(Exception e) {
			messaggio_errore = errorMessage;
			//System.debug('TEST EMAIL EXCEPTION ERRORE:' + messaggio_errore);
		}finally{
			if(messaggio_errore != '') {
				PV1753AttribuzioneIncassoInserimento.gestisciException(messaggio_errore);
			}
		}
        Test.stopTest();
        
    }
}