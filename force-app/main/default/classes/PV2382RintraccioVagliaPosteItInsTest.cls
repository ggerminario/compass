/**
 * @File Name          : PV2382RintraccioVagliaPosteItInsTest.cls
 * @Description        : 
 * @Author             : Cristiano
 * @Group              : 
 * @Last Modified By   : Cristiano
 * @Last Modified On   : 17/1/2020, 15:08:36
 * @Modification Log   : 
 * Ver       Date            Author      		    Modification
 * 1.0    17/1/2020   Cristiano     Initial Version
**/
@istest(SeeAllData=true)
class PV2382RintraccioVagliaPosteItInsTest {
    static String categoria = '2382';
    static testmethod void test1(){
        PVtestFactory pVtestFactory = new PVtestFactory();
        PV2382RintraccioVagliaPosteItalianeIns.PV2382RintraccioVagliaPosteItalianeInsForm form = new PV2382RintraccioVagliaPosteItalianeIns.PV2382RintraccioVagliaPosteItalianeInsForm();
        form = (PV2382RintraccioVagliaPosteItalianeIns.PV2382RintraccioVagliaPosteItalianeInsForm) pVtestFactory.initForm(categoria, form);
        form.codiceVaglia = '6595';
        form.importo = '55';
        form.provincia = '23';
        form.ufficio = '234';
        form.dataValuta = system.today();
        form.indirizzoMitt = 'indirizzomittente'; 
        form.nome = 'nome';
        form.CFPartitaIva = 'iva';
        form.indirizzoBen = 'indirizzobeneficiario';
        form.comunicazMitt = 'comunicazMitt';
        
        Test.startTest();
        PV2382RintraccioVagliaPosteItalianeIns.conferma(form);
        
        Test.stopTest();
    }   
}