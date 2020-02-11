/**
 * @File Name          : batchPV2380RintraccioBollPitTest.cls
 * @Description        : 
 * @Author             : Cristiano
 * @Group              : 
 * @Last Modified By   : Cristiano
 * @Last Modified On   : 15/1/2020, 14:48:58
 * @Modification Log   : 
 * Ver       Date            Author      		    Modification
 * 1.0    15/1/2020   Cristiano     Initial Version
**/
@isTest(SeeAllData=true)
public class batchPV2380RintraccioBollPitTest{  
    static testMethod void test1(){
        case c = new case();
        c.pv_importo_boll__c = 25;
        insert c;
        String responseTest = '{"resultCode": 0,"resultMessage": "Ok","recuperaElencoMovimentiResponse": {"movimenti": [{ "dataValuta": "20200115","dataRegistrazione": "20180108","dataAcquisto": "20180103","causale": "10","importo": "25"}]}}';
        String CRON_EXP = '0 0 0 3 9 ? 2022';
        string Categoria = '2380';

        PVtestFactory pVtestFactory = new PVtestFactory();
		PV2380RintraccioBollPosteItalianeIns.PV2380RintraccioBollPosteItalianeInsForm form = new PV2380RintraccioBollPosteItalianeIns.PV2380RintraccioBollPosteItalianeInsForm();
		form = (PV2380RintraccioBollPosteItalianeIns.PV2380RintraccioBollPosteItalianeInsForm) pVtestFactory.initForm(Categoria, form);
		pVtestFactory.pushApiList(responseTest,'RintraccioBollPit');
		pVtestFactory.finalizeApiList();

        Test.startTest();

        String jobId = System.schedule('scheduleBatchPV2380RintraccioBollPit', CRON_EXP, new scheduleBatchPV2380RintraccioBollPit());
        
        CronTrigger ct = [SELECT Id, CronExpression, TimesTriggered, NextFireTime FROM CronTrigger WHERE id = :jobId];

        System.assertEquals(CRON_EXP, ct.CronExpression);
        System.assertEquals(0, ct.TimesTriggered);
        System.assertEquals('2022-09-03 00:00:00', String.valueOf(ct.NextFireTime));

        Test.stopTest();
    }
}