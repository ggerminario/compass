@isTest(seeAllData=true)
public class PV2786CpayStorniTest {
    @isTest static void test() {

        string Categoria = '2786';    
		PVtestFactory pVtestFactory = new PVtestFactory();

		PV2786CpayStorni.PV2786CpayStorniForm form = new PV2786CpayStorni.PV2786CpayStorniForm();
		form = (PV2786CpayStorni.PV2786CpayStorniForm) pVtestFactory.initForm(Categoria, form);
		
        
        PV2786CpayStorni.PV2786CpayStorniForm form1 = new PV2786CpayStorni.PV2786CpayStorniForm();
        form1 = (PV2786CpayStorni.PV2786CpayStorniForm) pVtestFactory.initForm(categoria, form1);
        form1.userData.accountOffice = null;


        String messaggio_errore = '';
        String errorMessage = '';
        
        Test.startTest();
        PV2786CpayStorni.conferma(form);
        try{
            PV2786CpayStorni.conferma(form1);
        }catch(Exception e) {
			messaggio_errore = errorMessage;
			//System.debug('TEST EMAIL EXCEPTION ERRORE:' + messaggio_errore);
		}finally{
			if(messaggio_errore != '') {
				PV2786CpayStorni.gestisciException(messaggio_errore);
			}
		}
        Test.stopTest();
       
    }
}