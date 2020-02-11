/**
 * @File Name          : PV3707EstinzioneAnticipataTest.cls
 * @Description        : 
 * @Author             : Federico Negro
 * @Group              : 
 * @Last Modified By   : Federico Negro
 * @Last Modified On   : 21/11/2019, 17:11:06
 * @Modification Log   : 
 * Ver       Date            Author      		    Modification
 * 1.0    21/11/2019   Federico Negro     Initial Version
**/

@isTest (SeeAllData=true)

public class PV3707EstinzioneAnticipataTest {

    static boolean truefalse;
	static String Categoria='3707';
	static String response1='{"resultCode":0,"resultMessage":"Ok","recuperaStatoRichiestePSVResponse":{"elencoStatiRichieste":[{"progressivo":"89328431","stato":"30","blocco":"AC","dataAzione":"20191121","codAzione":"EST"}]}}';
    static String response2='{"resultCode":0,"resultMessage":"Ok","recuperaStatoRichiestePSVResponse":{"elencoStatiRichieste":[]}}';

    @isTest static void testOK() {

		PVtestFactory pVtestFactory = new PVtestFactory();

		PV3707EstinzioneAnticipataInserimento.PV3707EstinzioneAnticipataInserimentoForm form = new PV3707EstinzioneAnticipataInserimento.PV3707EstinzioneAnticipataInserimentoForm();
		form = (PV3707EstinzioneAnticipataInserimento.PV3707EstinzioneAnticipataInserimentoForm) pVtestFactory.initForm(Categoria, form);
        
        List<OCSRecuperaStatoRichiestePSVResponse.ResponseClass> listaProva = new List<OCSRecuperaStatoRichiestePSVResponse.ResponseClass>();

		form.pratica.numPratica = '1';
        form.pratica.tipoPratica = 'CO';

        form.progressivo = '';
        form.stato = '';
        form.blocco = '';

        Map<String,List<String>> serviceIdResMap = new Map<String,List<String>>(); //mappa con i nomi dei servizi e la lista di response

            //ocs.recuperaStatoRichiestePSV 
            List<String> res1=new List<String>();
                res1.add(response1); //res 1 chiamata
                res1.add(response2); //res 2 chiamata
                
        serviceIdResMap.put('recuperaStatoRichiestePSV', res1);
        
        UtilityMockResponseMultipleService UMR = new UtilityMockResponseMultipleService(serviceIdResMap);
		Test.setMock(HttpCalloutMock.class,UMR);

		Test.startTest();

        listaProva = PV3707EstinzioneAnticipataInserimento.getPSVService(form.pratica.numPratica, form.pratica.tipoPratica, 'EST');
        listaProva = PV3707EstinzioneAnticipataInserimento.getPSVService(form.pratica.numPratica, form.pratica.tipoPratica, 'EST');
		PV3707EstinzioneAnticipataInserimento.conferma(form);

		//caso con form null per testare eccezione
		try{
			PV3707EstinzioneAnticipataInserimento.conferma(null);
		} catch(Exception e) {
			System.assertNotEquals(e.getMessage(),'');
		}

		Test.stopTest();

	}

}