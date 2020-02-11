/**
 * @File Name          : PV2380RintraccioBollPitGest_Test.cls
 * @Description        : 
 * @Author             : Matteo Gobbo
 * @Group              : 
 * @Last Modified By   : Matteo Gobbo
 * @Last Modified On   : 20/1/2020, 16:56:27
 * @Modification Log   : 
 * Ver       Date            Author      		    Modification
 * 1.0    17/1/2020   Matteo Gobbo     Initial Version
**/
@isTest(seeAllData=true)
public class PV2380RintraccioBollPitGest_Test {
    @isTest static void test1() {

        string Categoria = '2380';    
		PVtestFactory pVtestFactory = new PVtestFactory();

		PV2380RintraccioBollPosteItalianeGest.PV2380RintraccioBollPosteItalianeGestForm form = new PV2380RintraccioBollPosteItalianeGest.PV2380RintraccioBollPosteItalianeGestForm();
		form = (PV2380RintraccioBollPosteItalianeGest.PV2380RintraccioBollPosteItalianeGestForm) pVtestFactory.initForm(Categoria, form);
        form.flagRinvia = true;
        form.sbf = true;
        form.pi = true;
        form.esitoSBF = 'OK';
        form.esitoPIT = 'OK';
        form.esitoSTO = 'OK';
        form.newStatus = 'Closed';

        Account a = new Account();
        a.Name =  'test';
        a.BusinessEmail__c = 'aaa@aaaa.it';
        insert a;

        Case c = new Case(pv_send_to__c = 'SBF');
        c.UfficioDestinazione__c = a.id;
        Insert c;

        FeedItem fItem = new FeedItem();
        fItem.Type = 'TextPost';
        fItem.ParentId = c.Id;
        fItem.Body = 'Body<br>';
        Insert fItem;

		
        
        Test.startTest();
		PV2380RintraccioBollPosteItalianeGest.saveCase(form, c);
		PV2380RintraccioBollPosteItalianeGest.fetchUserDetail();
		Test.stopTest();
        
    }
}