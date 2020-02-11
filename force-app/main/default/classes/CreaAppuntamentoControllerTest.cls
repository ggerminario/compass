@isTest
public with sharing class CreaAppuntamentoControllerTest {
    
    @testSetup 
    static void testSetup() {
        Date myDate = Date.newInstance(1960, 2, 17);
        List<Account> accounts= new List<Account>();
        Account acct= new Account(FirstName='mame', LastName='kane', Sesso__pc='F', Data_Nascita__c=myDate);
        Account acct3= new Account(FirstName='mame Diarra', LastName='kane', Sesso__pc='F', Data_Nascita__c=myDate);
        accounts.add(acct);
        accounts.add(acct3);
        insert accounts;
        
        Id recordTypeId = Schema.SObjectType.Account.getRecordTypeInfosByName()
                  .get('Branch').getRecordTypeId();
        Account acct2= new Account(Name='ROMA', OCS_External_Id__c='18', RecordTypeId = recordTypeId);
        insert acct2;
        
        List<Product2> listproduit = new List<Product2>{
            new Product2(Name='P1', ProductCode='145', Family='PP_ONLINE_COMPASS_DS' , Livello__c = 0 ),
            new Product2(Name='P2', ProductCode='146', Family='PP_ONLINE_PARTNER_DS' , Livello__c = 0 ),
            new Product2(Name='P3', ProductCode='147', Family='PP_ONLINE_PARTNER_DS' , Livello__c = 1 )
        };
      insert listproduit;
        Product2 product1= new Product2(Name='test');
        insert product1;
        Datetime dataT =getDateTime();
        XCS_Desk__c desk = new XCS_Desk__c(Name ='Desk1',isActive__c=true, Branch__c=acct2.Id, DeskName__c='Desk1' );
        insert desk;
        XCS_DeskItem__c deskItem = new XCS_DeskItem__c(Desk__c= desk.Id,	StartTime__c= dataT.time(),
                            EndTime__c= dataT.addHours(4).time().addMinutes(30),Monday__c=true, Tuesday__c=true,Wednesday__c=true,
                            Thursday__c=true, Friday__c=true,Saturday__c=false,Sunday__c =false);
        insert deskItem;
        String inpputString='2020-01-03T11:30:00.000Z';
        DateTime resultDateTime = DateTime.ValueofGmt(inpputString.replace('T', ' ')); 
        
        List<Event> events= new List<Event>();
        Event event= new Event(Telefono_Cellulare__c='0238323',Product__c=product1.Id, Desk__c=desk.Id,Customer__c=acct.Id, Stato_Azione__c ='Presentato',
                               Tipo_Occupazione__c='Autonomo',DurationInMinutes=30,Type='Festività',
                              ActivityDateTime=resultDateTime,ActivityDate=resultDateTime.date());
        
        Event event2= new Event(Telefono_Cellulare__c='0238323',Product__c=product1.Id,Stato_Azione__c ='Non presentato/Annullato',
                               Tipo_Occupazione__c='Autonomo',DurationInMinutes=30,
                          ActivityDateTime=Datetime.newInstance(2020, 01, 07,11,0,0),ActivityDate= Date.newInstance(2020, 01, 07));
		events.add(event);
        events.add(event2);
		insert events;        
         
        // ######################## Product2 Data #######################################################
        Product2 prodotto = new Product2(Name='prodotto1',ProductCode='145',Livello__c = 2);
        insert prodotto;
        XCS_Template__c tempSMS = new XCS_Template__c(Body__c='test',Name='SMSFISSAPT – Conferma',ExternalCode__c='SMS7');
        insert tempSMS;
        
	}
    
    @isTest
    public static void testGetAllProductInteressato(){
         Map<String ,Object>  result=CreaAppuntamentoController.getAllProductInteressato();
    }
        
    @isTest
    public static void testGetProvince(){
        Map<String ,Object> result = CreaAppuntamentoController.getProvince();
    }
    
    @isTest
    public static void testGetAllProductDettaglio(){
         Product2 product = [select Name,Livello__c from Product2 limit 1];
         Map<String ,Object>  result=CreaAppuntamentoController.getAllProductDettaglio(product.Id);
         Map<String ,Object>  result2=CreaAppuntamentoController.getAllProductDettaglio('#v');
    }
    
    @isTest
    public static void testGetCommuneByProvinceOK(){
        Map<String ,Object>  result=CreaAppuntamentoController.getCommuneByProvince('');
    }
    
    @isTest
    public static void testGetCommuneByProvinceKO(){
        XCS_Town__c town = new XCS_Town__c(Provincia_Desc__c='dakar',Catastale__c='A003',Comune__c='dakar plateau');
        insert town;
        Map<String ,Object>  result=CreaAppuntamentoController.getCommuneByProvince(town.Provincia_Desc__c);
    }
    
    @isTest
    public static void testControlleDateEvent(){
        Event event= [select Id,ActivityDateTime, ActivityDate  from Event limit 1];
         Map<String ,Object>  result=CreaAppuntamentoController.controlleDateEvent(event.ActivityDate);
    }
    
    @isTest
    public static void testCreateEvent(){
        Product2 product = [select Name,Livello__c from Product2 limit 1];
        Map<Id ,Object> slotMap = new Map<Id ,Object>();
        Account account=[select Id from Account where RecordType.Name!='Branch' limit 1];
        Account account2=[select Id from Account where FirstName='mame Diarra' limit 1];
        String inpputString='2020-01-07T11:30:00.000Z';
        DateTime resultDateTime = DateTime.ValueofGmt(inpputString.replace('T', ' ')); 
        Event event= new Event(Telefono_Cellulare__c='0238323',Product__c=product.Id,
                               Tipo_Occupazione__c='Autonomo',DurationInMinutes=30,
                              ActivityDateTime=resultDateTime,ActivityDate=resultDateTime.date());
        
        Event event2= new Event(Telefono_Cellulare__c='0238323',Product__c=product.Id,Stato_Azione__c ='Non presentato/Annullato',
                               Tipo_Occupazione__c='Autonomo',DurationInMinutes=30, Customer__c=account.Id,
                          ActivityDateTime=Datetime.newInstance(2020, 01, 07,11,0,0),ActivityDate= Date.newInstance(2020, 01, 07));
        
        //
        Account act= new Account(Phone='77898934',FirstName='mame',LastName='kane');
        Account act2= new Account(Phone='77858454',FirstName='opqrs',LastName='tuvwxyz');
        Account filiale=[select Id,Name from Account where RecordType.Name='Branch' limit 1];
       // Map<String ,Object> result2 =CreaAppuntamentoController.createEvent(event,act2,filiale.Name,'11:00',slotMap);
       // Map<String ,Object> result3 =CreaAppuntamentoController.createEvent(event,account2,filiale.Name,'11:00',slotMap);
    }
    
    @isTest
    public static void testCalcolaCodiceFiscale(){
        Account cliente=[select Id, FirstName, LastName, Sesso__pc, Data_Nascita__c
                         from Account limit 1];
        String catastale='A003';
        Map<String ,Object> result = CreaAppuntamentoController.CalcolaCodiceFiscale(cliente,catastale);
        Map<String ,Object> result2 = CreaAppuntamentoController.CalcolaCodiceFiscale(cliente,'');
        
        cliente.FirstName='opqv'; 
        cliente.LastName='rstk';
        update cliente;
        Map<String ,Object> result3 = CreaAppuntamentoController.CalcolaCodiceFiscale(cliente,'');
        
        cliente.FirstName='uvw'; 
        cliente.LastName='xyz';
        update cliente;
        Map<String ,Object> result4 = CreaAppuntamentoController.CalcolaCodiceFiscale(cliente,'');
        System.debug('codice '+result);
    }
    
    @isTest
    static void controleDateEventTest(){
        Test.startTest();
            Event event= [select Id,ActivityDateTime, ActivityDate  from Event limit 1];
            Map<String ,Object> result =CreaAppuntamentoController.controleDateEvent(event.ActivityDate,'',null);
            Map<String ,Object> result2 =CreaAppuntamentoController.controleDateEvent(event.ActivityDate,null,null);

        Test.stopTest();
    }
	
    @isTest
    static void controlDateNascitaClienteTest(){
        Test.startTest();
            Account account=[select Id, Data_Nascita__c from Account limit 1];
            Map<String ,Object> result =CreaAppuntamentoController.controlDateNascitaCliente(account.Data_Nascita__c);
            Map<String ,Object> result2 =CreaAppuntamentoController.controlDateNascitaCliente(null);

        Test.stopTest();
    }

    //chekDisponibleDeskByFiliale
    @isTest
    static void chekDisponibleDeskByFilialeTest(){
        Test.startTest();
        Event event= [select Id,ActivityDateTime,Customer__c, ActivityDate  from Event limit 1];// where Customer__c!=null
        Account filiale=[select Id,Name from Account where RecordType.Name='Branch' limit 1];
        Map<String ,Object> result =CreaAppuntamentoController.chekDisponibleDeskByFiliale(filiale.Name, ''+event.Customer__c);
        
        Test.stopTest();
    }

    @isTest
    static void mailDemTest(){
        Test.startTest();
        Event event= [select Id,ActivityDateTime,Customer__c, ActivityDate  from Event limit 1];// where Customer__c!=null
        Account filiale=[select Id,Name,ShippingStreet,ShippingCity,ShippingPostalCode,Phone from Account where RecordType.Name='Branch' limit 1];
        Map<String ,Object> result =CreaAppuntamentoController.mailDem(event.Id,'test','test','02652','021588962',null);
        //        Map<String ,Object> result =CreaAppuntamentoController.mailDem(event.Id,filiale.ShippingStreet,filiale.ShippingCity,filiale.ShippingPostalCode,filiale.Phone);

        Test.stopTest();
    }

    @isTest
    static void smsDemTest(){
        Test.startTest();
        Event event= [select Id,ActivityDateTime,Customer__c, ActivityDate  from Event limit 1];// where Customer__c!=null
        Account filiale=[select Id,Name,ShippingStreet,ShippingCity,ShippingPostalCode,Phone from Account where RecordType.Name='Branch' limit 1];
        Map<String ,Object> result =CreaAppuntamentoController.smsDem(event.ActivityDateTime, '0215855','test');
        
        Test.stopTest();
    }

    @isTest
    static void getAccountByIdClienteTest(){
        Test.startTest();
        Account account=[select Id, Data_Nascita__c from Account limit 1];
        Map<String ,Object> result =CreaAppuntamentoController.getAccountByIdCliente(account.Id);
        Map<String ,Object> result2 =CreaAppuntamentoController.getAccountByIdCliente(null);
        Test.stopTest();
    }
    
    @isTest
    static void getCatastalByComuneTestOK(){
        Test.startTest();
        XCS_Town__c town = new XCS_Town__c(Provincia_Desc__c='dakar',Catastale__c='A003',Comune__c='dakar plateau');
        insert town;
        Map<String ,Object> result =CreaAppuntamentoController.getCatastalByComune(town.Comune__c);
        Test.stopTest();
    }
    
    @isTest
    static void getCatastalByComuneTestKO(){
        Test.startTest();
        Map<String ,Object> result =CreaAppuntamentoController.getCatastalByComune('town');
        Test.stopTest();
    }

    /**
     * @Author ADIOP
     * @date  08/08/2019
     * @description 
     **/
    @isTest
    static void getFilialesTest(){
        Test.startTest();
        CreaAppuntamentoController.getFiliales('MILANO', 'Via Torino 10',  'MI','Jump Diamante');
        Test.stopTest();
    }

    /**
     * @Author ADIOP
     * @date  08/08/2019
     * @description 
     **/
    @isTest
    static void getDataLocationTest(){
        List<AppuntamentoListaFilialiResponse.FilialeOCS> filiales = new List<AppuntamentoListaFilialiResponse.FilialeOCS> ();
        AppuntamentoListaFilialiResponse.FilialeOCS filialeOCS = new AppuntamentoListaFilialiResponse.FilialeOCS();
        AppuntamentoListaFilialiResponse response = new AppuntamentoListaFilialiResponse();
        AppuntamentoListaFilialiResponse.XMLWrapper xml = new AppuntamentoListaFilialiResponse.XMLWrapper();
        AppuntamentoListaFilialiResponse.Result result = new AppuntamentoListaFilialiResponse.Result();
        AppuntamentoListaFilialiResponse.PuntoRicercatoOCS ptr= new AppuntamentoListaFilialiResponse.PuntoRicercatoOCS();
        
        ptr.addressGeoCode='test';
        ptr.coordinates='test';
        ptr.postalCodeNumber='test';
        result.puntoRicercato= ptr;
        xml.result=result;
        response.xml=xml;
        filialeOCS.id = 'dfghjklò';
        filialeOCS.idL = 'idl';
        filiales.add(filialeOCS);
        result.Filiali=filiales;
        Test.startTest();
            CreaAppuntamentoController.getDataLocation(response.xml.result);
        Test.stopTest();
    }
    //
     @isTest
    static void getFilialeByIdTest(){
        Account filiale=[select Id,Name from Account where RecordType.Name='Branch' limit 1];
        Test.startTest();
		CreaAppuntamentoController.getFilialeById(filiale.Id);
		CreaAppuntamentoController.getFilialeById(null);
        Test.stopTest();
    }

    @isTest
    static void checkOperatorTest(){
        Account filiale=[select Id,Name from Account where RecordType.Name='Branch' limit 1];
        Account client =[select Id,Name from Account limit 1];
        Test.startTest();
		CreaAppuntamentoController.checkOperator(''+client.Id);
        //KO
        CreaAppuntamentoController.checkOperator('null');
        Test.stopTest();
    }
    
     static Datetime getDateTime(){
        Datetime dt = Datetime.now();
        dt = dt.addDays(3);
        Datetime dtnew = Datetime.newInstance(dt.year(), dt.month(), dt.day(), 8, 0, 0);
        System.debug(' ################# dtnew'+dtnew);
        return dtnew ;
    }

    
    
}