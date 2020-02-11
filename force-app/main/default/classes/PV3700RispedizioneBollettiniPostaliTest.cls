/**
 * @File Name          : PV3700RispedizioneBollettiniPostaliTest.cls
 * @Description        : 
 * @Author             : Matteo Gobbo
 * @Group              : 
 * @Last Modified By   : Matteo Gobbo
 * @Last Modified On   : 9/12/2019, 14:26:54
 * @Modification Log   : 
 * Ver       Date            Author      		    Modification
 * 1.0    9/12/2019   Matteo Gobbo     Initial Version
**/
@isTest (SeeAllData=true) 
public class PV3700RispedizioneBollettiniPostaliTest {
    static boolean truefalse;
	static String Categoria='3700';
	static String response1='{"resultCode":0,"resultMessage":"Ok","RistampaCarnetBollettiniResponseDTO": {"dataElaborazione":"20191203","oraElaborazione":"14254837","utenteElaborazione":"WB","flagErrore":"0","desErrore":"","esito":"OK","dataUltimoInvio":"20190612"}}';

	@isTest static void test1() {

		PVtestFactory pVtestFactory = new PVtestFactory();

		PV3700RispedizioneBollettiniPostaliCnt.PV3700RispedizioneBollettiniPostaliInsForm form = new PV3700RispedizioneBollettiniPostaliCnt.PV3700RispedizioneBollettiniPostaliInsForm();
		form = (PV3700RispedizioneBollettiniPostaliCnt.PV3700RispedizioneBollettiniPostaliInsForm) pVtestFactory.initForm(Categoria, form);
		

		pVtestFactory.pushApiList(response1,'ristampaCarnetBollettini');
		pVtestFactory.finalizeApiList();

		Test.startTest();
        OCSRistampaCarnetBollettiniInvoker.RistampaCarnetBollettiniResponseDTO res = new OCSRistampaCarnetBollettiniInvoker.RistampaCarnetBollettiniResponseDTO();
        res.esito = 'OK';
        res.dataElaborazione = '2019';
        res.desErrore = 'desc';
        res.flagErrore = 'flag';
        res.oraElaborazione = 'ora';
        res.utenteElaborazione = 'ut';
        res.dataUltimoInvio = '2019';
        PV3700RispedizioneBollettiniPostaliCnt.recuperaInfoBollettini(form); 


		PV3700RispedizioneBollettiniPostaliCnt.conferma(form);
       

		Test.stopTest();

	}
   
}