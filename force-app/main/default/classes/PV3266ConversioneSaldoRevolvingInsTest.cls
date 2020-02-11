@isTest(SeeAllData=true)
public class PV3266ConversioneSaldoRevolvingInsTest {
     static boolean truefalse;
	static String Categoria='3266';
	static String response1='{"resultCode":0,"resultMessage":"Ok","variazioneModalCalcoloRataResponse":{"as400Status":"KO","as400Errore":"1890 Nessuna variazione effettuata"}}';
	static String response2='{"resultCode":0,"resultMessage":"Ok","variazioneModalCalcoloRataResponse":{"as400Status":"OK","as400Errore":""}}';

    @isTest static void test1() {

		PVtestFactory pVtestFactory = new PVtestFactory();

		PV3266ConversioneSaldoRevolvingIns.PV3266ConversioneSaldoRevolvingInsForm form = new PV3266ConversioneSaldoRevolvingIns.PV3266ConversioneSaldoRevolvingInsForm();
		form = (PV3266ConversioneSaldoRevolvingIns.PV3266ConversioneSaldoRevolvingInsForm) pVtestFactory.initForm(Categoria, form);
        form.modCalcRata = 'm';
        form.pagMinImporto = '0,5';
        form.pagMinPerc = '60,5';
        form.modCalcRataOrig = 'T';
		

		pVtestFactory.pushApiList(response2,'variazioneModalCalcoloRata');
		pVtestFactory.finalizeApiList();

		Test.startTest();
       // PV3700RispedizioneBollettiniPostaliCnt.recuperaInfoBollettini(form); 
        
        PV3266ConversioneSaldoRevolvingIns.getModalitaCalcoloRata();
        PV3266ConversioneSaldoRevolvingIns.recuperaDatiFinanziari('123456');
        PV3266ConversioneSaldoRevolvingIns.recuperaInfoCarta('123456');
		PV3266ConversioneSaldoRevolvingIns.conferma(form);
        

       

		Test.stopTest();

	}
}