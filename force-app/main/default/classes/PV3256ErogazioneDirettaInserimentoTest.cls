/**
 * @File Name          : PV3256ErogazioneDirettaInserimentoTest.cls
 * @Description        :
 * @Author             : Lorenzo Marzocchi
 * @Group              :
 * @Last Modified By   : Federico Negro
 * @Last Modified On   : 5/12/2019, 14:49:47
 * @Modification Log   :
 *==============================================================================
 * Ver         Date                     Author                        Modification
 *==============================================================================
 * 1.0    2019-8-26 17:45:34   Lorenzo Marzocchi     Initial Version
 **/

@isTest (SeeAllData=true)
private class PV3256ErogazioneDirettaInserimentoTest {

	static boolean truefalse;
	static String Categoria='3256';
	static String response1='{"resultCode":0,"resultMessage":"Ok","datiAcquistiErogazioneDirettaResponse":{"emettitore":"0","protocollo":"1","autor":"0","as400Status":"OK","as400Errore":"5644 Stato carta/Azione incompatibili"}}';
	static String response2='{"resultCode":0,"resultMessage":"Ok","datiAcquistiErogazioneDirettaResponse":{"emettitore":"0","protocollo":"0","autor":"0","as400Status":"KO","as400Errore":"5644 Stato carta/Azione incompatibili"}}';
	static String response3='{"resultCode":0,"resultMessage":"Ok","datiCartaDatiFinanziariResponse":{"numeroPratica":"52181699858","filiale":"402","emettitore":"52","intestazione1":"OALLIAVOII YUNOU","as400Status":"OK"}}';
    static String response4='{"resultCode":0,"resultMessage":"Ok","pratiche":[{"numPratica":"52181699858","codCliente":"9099297","tipoPratica":"CA","codStatoPratica":"20","statoPratica":"20XU"}],"cliente":[{"cognome":"SAEOBZA","codCliente":"9099297","nome":"HISAYUKI"}]}';
	static String response5='{"resultCode":0,"resultMessage":"Ok","datiLiquidazioneAcquistiResponse":{"as400Status":"OK","as400Errore":""}}';

	@isTest static void testOK() {

		PVtestFactory pVtestFactory = new PVtestFactory();

		PV3256ErogazioneDirettaInserimento.PV3256ErogazioneDirettaForm form = new PV3256ErogazioneDirettaInserimento.PV3256ErogazioneDirettaForm();
		form = (PV3256ErogazioneDirettaInserimento.PV3256ErogazioneDirettaForm) pVtestFactory.initForm(Categoria, form);

		form.pratica.numPratica = '52181699858';

		form.importo= 1;
		form.codiceCampagna= '';
		form.numRate= '';
		form.modalitaErogazione= '';
		form.smsConsenso= 'true';
		form.iban= '';
		form.flagCommissioniErogazione= '';
		form.intermediario= '';
		form.destErogazione= '';
		form.canale= '';
		form.dataScadenza= '';
		form.codiceInternoBanca= '12';
		form.emettitore= '';
		form.testoSMS= '';
		form.numeroCliente= '';


		/*pVtestFactory.pushApiList(response1,'ocs.erogazioneDirok');
		pVtestFactory.finalizeApiList();*/

		Map<String,List<String>> serviceIdResMap = new Map<String,List<String>>(); //mappa con i nomi dei servizi e la lista di response

            //ocs.acquistiErogazioneDiretta
            List<String> res1=new List<String>();
                res1.add(response1); //res 1 chiamata

            //ocs.cartaDatiFinanziari
            List<String> res2=new List<String>();
                res2.add(response3); //res 1 chiamata
                
            //ocs.recuperaDatiPostvendita
            List<String> res3=new List<String>();
                res3.add(response4); 
			
			//ocs.liquidazioneAcquisti
            List<String> res4=new List<String>();
                res4.add(response5); 

        serviceIdResMap.put('cartaDatiFinanziari', res2);
        serviceIdResMap.put('recuperaDatiPostvendita', res3);
        serviceIdResMap.put('acquistiErogazioneDiretta', res1);
		serviceIdResMap.put('liquidazioneAcquisti', res4);

        UtilityMockResponseMultipleService UMR = new UtilityMockResponseMultipleService(serviceIdResMap);
		Test.setMock(HttpCalloutMock.class,UMR);

		Test.startTest();

		
		OCSCartaDatiFinanziariResponse.DatiCartaDatiFinanziariResponseDTO TEST3 =PV3256ErogazioneDirettaInserimento.recuperaDatiFinanziari(form.pratica.numPratica);
		String TEST2 = PV3256ErogazioneDirettaInserimento.getMinimoErogabile('3');
		boolean X1 = PV3256ErogazioneDirettaInserimento.isAccountPresente('1');

        Map<String,List<Object> >  TEST1 =PV3256ErogazioneDirettaInserimento.getCpayMatrix('1');
		PV3256ErogazioneDirettaInserimento.conferma(form);
        
		Test.stopTest();

	}

	@isTest static void testKO() {

		PVtestFactory pVtestFactory = new PVtestFactory();

		PV3256ErogazioneDirettaInserimento.PV3256ErogazioneDirettaForm form = new PV3256ErogazioneDirettaInserimento.PV3256ErogazioneDirettaForm();
		form = (PV3256ErogazioneDirettaInserimento.PV3256ErogazioneDirettaForm) pVtestFactory.initForm(Categoria, form);


		form.pratica.numPratica = '1';

		form.importo= 1;
		form.codiceCampagna= '';
		form.numRate= '';
		form.modalitaErogazione= '';
		form.smsConsenso= 'true';
		form.iban= '';
		form.flagCommissioniErogazione= '';
		form.intermediario= '';
		form.destErogazione= '';
		form.canale= '';
		form.dataScadenza= '';
		form.codiceInternoBanca= '12';
		form.emettitore= '';
		form.testoSMS= '';
		form.numeroCliente= '';
        
		pVtestFactory.pushApiList(response2,'ocs.erogaazioneDirko');
		pVtestFactory.finalizeApiList();

		Test.startTest();

		try{
			OCSGenericRecuperaDatiInvoker.GenericRecuperaDatiResponseDTO TEST4 =PV3256ErogazioneDirettaInserimento.verificaMandatoSDDAttivo('CA','1');
		} catch(Exception e) {
			System.assertNotEquals(e.getMessage(),'');
		}
		
		try{
			PV3256ErogazioneDirettaInserimento.conferma(form);
		} catch(Exception e) {
			System.assertNotEquals(e.getMessage(),'');
		}

		Test.stopTest();

	}

}