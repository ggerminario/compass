@ isTest(SeeAllData = true) public with sharing class PV1761CopiaEstrattoContoTest {

	static String Categoria = '1761';

	@isTest static void testOKCliente() {

		PVtestFactory pVtestFactory = new PVtestFactory();

		PV1761CopiaEstrattoConto.PV1761CopiaEstrattoContoForm form = new PV1761CopiaEstrattoConto.PV1761CopiaEstrattoContoForm();

		form = (PV1761CopiaEstrattoConto.PV1761CopiaEstrattoContoForm) pVtestFactory.initForm(Categoria, form);


		List<PV1761CopiaEstrattoConto.ECDto> ecs = new List<PV1761CopiaEstrattoConto.ECDto>();
		PV1761CopiaEstrattoConto.ECDto ec = new PV1761CopiaEstrattoConto.ECDto();

		ec.loan_number = '123456';
		ec.ec_anno = '1234';
		ec.ec_mese = '12';
		ec.send_to = 'Cliente';
		ec.address = 'via di test';
		ec.city = 'TestingCity';
		ec.prov = 'BO';
		ec.cap = '12345';
		// ec.filiale è valorizzato solo nei casi in cui ec.send_to == 'Filiale'
		ec.cognome = 'cognomeTest';
		ec.nome = 'nomeTest';
		ec.ocs_anag = '123456';

        ecs.add(ec);
        form.ecs = ecs;
        
		Test.startTest();
		PV1761CopiaEstrattoConto.conferma(form);
		Test.stopTest();
	}

    
	@isTest static void testOKFiliale() {

		PVtestFactory pVtestFactory = new PVtestFactory();

		PV1761CopiaEstrattoConto.PV1761CopiaEstrattoContoForm form = new PV1761CopiaEstrattoConto.PV1761CopiaEstrattoContoForm();

		form = (PV1761CopiaEstrattoConto.PV1761CopiaEstrattoContoForm) pVtestFactory.initForm(Categoria, form);

        insert new Account(Type='FIL', OCS_External_Id__c='FTEST', Address_Abbr_Sms__c='AddressTest', Name='NameTest' );

		List<PV1761CopiaEstrattoConto.ECDto> ecs = new List<PV1761CopiaEstrattoConto.ECDto>();
		PV1761CopiaEstrattoConto.ECDto ec = new PV1761CopiaEstrattoConto.ECDto();

		ec.loan_number = '123456';
		ec.ec_anno = '1234';
		ec.ec_mese = '12';
		ec.send_to = 'Filiale';
		ec.address = 'via di test';
		ec.city = 'TestingCity';
		ec.prov = 'BO';
		ec.cap = '12345';
		ec.filiale = 'FTEST';
		ec.cognome = 'cognomeTest';
		ec.nome = 'nomeTest';
		ec.ocs_anag = '123456';

        ecs.add(ec);
        form.ecs = ecs;
        
		Test.startTest();
		PV1761CopiaEstrattoConto.conferma(form);
		Test.stopTest();
	}

    @isTest static void testKOFilialeNonTrovata() {

		PVtestFactory pVtestFactory = new PVtestFactory();

		PV1761CopiaEstrattoConto.PV1761CopiaEstrattoContoForm form = new PV1761CopiaEstrattoConto.PV1761CopiaEstrattoContoForm();

		form = (PV1761CopiaEstrattoConto.PV1761CopiaEstrattoContoForm) pVtestFactory.initForm(Categoria, form);


		List<PV1761CopiaEstrattoConto.ECDto> ecs = new List<PV1761CopiaEstrattoConto.ECDto>();
		PV1761CopiaEstrattoConto.ECDto ec = new PV1761CopiaEstrattoConto.ECDto();

		ec.loan_number = '123456';
		ec.ec_anno = '1234';
		ec.ec_mese = '12';
		ec.send_to = 'Filiale';
		ec.address = 'via di test';
		ec.city = 'TestingCity';
		ec.prov = 'BO';
		ec.cap = '12345';
		ec.filiale = 'FTEST';
		ec.cognome = 'cognomeTest';
		ec.nome = 'nomeTest';
		ec.ocs_anag = '123456';

        ecs.add(ec);
        form.ecs = ecs;
        
        Exception myException;

		Test.startTest();
        try{
		PV1761CopiaEstrattoConto.conferma(form);
        } catch (Exception e){
            myException = e;
        }
		Test.stopTest();

        System.assertNotEquals(null, myException);
        
	}
}