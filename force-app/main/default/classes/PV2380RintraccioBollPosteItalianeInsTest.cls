/**
 * @File Name          : PV2380RintraccioBollPosteItalianeInsTest.cls
 * @Description        : 
 * @Author             : Cristiano
 * @Group              : 
 * @Last Modified By   : Federico
 * @Last Modified On   : 17/1/2020, 15:26:11
 * @Modification Log   : 
 * Ver       Date            Author      		    Modification
 * 1.0    10/1/2020   Cristiano     Initial Version
**/
@isTest(SeeAllData=true)
public class PV2380RintraccioBollPosteItalianeInsTest{
    static String categoria='2380';
    static testMethod void test1(){
        
        PVtestFactory pVtestFactory = new PVtestFactory();
        PV2380RintraccioBollPosteItalianeIns.PV2380RintraccioBollPosteItalianeInsForm form = new PV2380RintraccioBollPosteItalianeIns.PV2380RintraccioBollPosteItalianeInsForm();
        form = (PV2380RintraccioBollPosteItalianeIns.PV2380RintraccioBollPosteItalianeInsForm) pVtestFactory.initForm(categoria, form);
        form.bollettino = '6595';
        form.importo = '55';
        form.provincia = 'rm';
        form.sportello = '01';
        form.ufficio = '23';
        form.dataValuta = Date.newInstance(2020,01,01);
        form.contoCorrente = '79646';

        PV2380RintraccioBollPosteItalianeIns.PV2380RintraccioBollPosteItalianeInsForm form1 = new PV2380RintraccioBollPosteItalianeIns.PV2380RintraccioBollPosteItalianeInsForm();
        form1 = (PV2380RintraccioBollPosteItalianeIns.PV2380RintraccioBollPosteItalianeInsForm) pVtestFactory.initForm(categoria, form1);
        form1.bollettino = '6595';
        form1.importo = '55';
        form1.provincia = 'rm';
        form1.sportello = '01';
        form1.ufficio = '23';
        form1.dataValuta = Date.newInstance(2020,01,01);
        form1.contoCorrente = '79646';

        String messaggio_errore = '';
        String errorMessage = '';
        


        Test.startTest();
        PV2380RintraccioBollPosteItalianeIns.conferma(form);
        PV2380RintraccioBollPosteItalianeIns.querycc();
        try{
            PV2380RintraccioBollPosteItalianeIns.conferma(form1);
        }catch(Exception e) {
			messaggio_errore = errorMessage;
			//System.debug('TEST EMAIL EXCEPTION ERRORE:' + messaggio_errore);
		}finally{
			if(messaggio_errore != '') {
				PV2380RintraccioBollPosteItalianeIns.gestisciException(messaggio_errore);
			}
		}
        Test.stopTest();
    }
}