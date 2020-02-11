@isTest
public  class AppuntomentoQueryTest {
        @TestSetup
        static void makeData(){
                    Datetime tempo = Datetime.newInstance(2019, 09, 10, 12, 59, 0);
                    XCS_CompassParameters__c cp = new XCS_CompassParameters__c(Name='Ora_Di_Fine', Intervallo_Di_Appuntamenti__c=tempo);
                    insert cp;
                    Datetime tempoIni = Datetime.newInstance(2019, 09, 10, 0, 0, 0);
                    XCS_CompassParameters__c cp2 = new XCS_CompassParameters__c(Name='Ora_Di_Inizio', Intervallo_Di_Appuntamenti__c=tempoIni);
                    insert cp2;

                    // ############################## Get recordType Client ###########################################
                    Id idRecordTypeAccount = CGMWSUtils_1_0.getRecordTypeId('Account', 'PersonAccount');
                    // Get recordType Branch
                    Id idRecordTypeAccountBranch = CGMWSUtils_1_0.getRecordTypeId('Account', 'Branch');
                    //################################ create client : Accout with recordType Customer #################
                    List<Account> listAccountCustomer = new List<Account>{
                    new Account (RecordTypeId = idRecordTypeAccount, LastName='BALDEmADICKE', PersonEmail='test@gmail.com', Codice_Fiscale__c ='RZZNNN69B25F158O'),
                    new Account (RecordTypeId = idRecordTypeAccount, LastName='BALDEMacky', PersonEmail='test@gmail.com', Codice_Fiscale__c ='447')
                    };
                    insert  listAccountCustomer;

                    //################################## create client : Accout with recordType Branch ##############
                    List<Account> listAccountBranch = new List<Account>{
                    new Account (RecordTypeId = idRecordTypeAccountBranch, Name='EMPOLI', OCS_External_Id__c='F18', ShippingCity='City',ShippingPostalCode='1245', ShippingStreet='zoulouka', Phone='332654123' ),
                    new Account (RecordTypeId = idRecordTypeAccountBranch, Name='Naple', OCS_External_Id__c='F19', ShippingCity='City',ShippingPostalCode='1245',Phone='332654123', ShippingStreet='zoulouka'),
                    new Account (RecordTypeId = idRecordTypeAccountBranch, Name='ROMA', OCS_External_Id__c='F212', ShippingCity='City',ShippingPostalCode='1245',Phone='332654123', ShippingStreet='zoulouka')
                    };
                    insert  listAccountBranch;

                    // #################################### Create XCS_Desk  Data ##################################
                    List<XCS_Desk__c> xcsDeskList = new  List<XCS_Desk__c>{
                    new XCS_Desk__c(Name ='Desk1', 	isActive__c=true, Branch__c=listAccountBranch[0].Id, DeskName__c='Desk1' ),
                    new XCS_Desk__c(Name ='Desk2', 	isActive__c = true, Branch__c=listAccountBranch[1].Id, DeskName__c='Desk1' ),
                    new XCS_Desk__c(Name ='Desk3',  isActive__c = true, Branch__c=listAccountBranch[0].Id, DeskName__c='Desk2' ),
                    new XCS_Desk__c(Name ='DeskR1', isActive__c = true, Branch__c=listAccountBranch[2].Id, DeskName__c='Desk1' ),
                    new XCS_Desk__c(Name ='DeskR2', isActive__c = true, Branch__c=listAccountBranch[1].Id, DeskName__c='Desk2' )
                    };
                    insert xcsDeskList;

                    // ######################################## Create XCS_DeskItem__c ############################
                    Datetime dt =getDateTime();

                    Datetime dt1 =  getDateTime();
                    Datetime dt2 = getDateTime();
                    Datetime dtt = dt.addHours(9);
                    Datetime dttE = dt1.addHours(9);
                    Integer duration = 9*60;
                    Integer dur = 9*60;
                    Datetime endApp = dt2.addMinutes(30);

                    Datetime dtEnd = Datetime.newInstance(2019, 08, 20, 08, 0, 0);
                    Datetime dEnd = dtEnd.addHours(2);
                    Integer dura = 2*60;

                    List<XCS_DeskItem__c> xcsDeskListItem = new  List<XCS_DeskItem__c>{
                    new XCS_DeskItem__c(Desk__c= xcsDeskList[0].Id,	StartTime__c= dt.time(),
                          EndTime__c= dt.addHours(4).time().addMinutes(30),Monday__c=true, Tuesday__c=true,Wednesday__c=true,
                          Thursday__c=true, Friday__c=true,Saturday__c=true,Sunday__c =true),

                    new XCS_DeskItem__c(Desk__c= xcsDeskList[0].Id,	StartTime__c=  dt1.time(),
                          EndTime__c= dt1.addHours(4).time().addMinutes(30) , Monday__c=true, Tuesday__c=true,Wednesday__c=true,
                          Thursday__c=true, 	Friday__c=true,Saturday__c=true,Sunday__c =true ),

                    new XCS_DeskItem__c(Desk__c= xcsDeskList[2].Id,	StartTime__c= dt2.time(),
                          EndTime__c=dt2.addHours(4).time().addMinutes(30), Monday__c=true, Tuesday__c= true,Wednesday__c= false,
                          Thursday__c=false, 	Friday__c=true,Saturday__c=false,Sunday__c =false ),

                    new XCS_DeskItem__c(Desk__c= xcsDeskList[3].Id,	StartTime__c= dt2.time(),
                      EndTime__c=dt2.addHours(9).time().addMinutes(30), Monday__c=true, Tuesday__c= true,Wednesday__c= true,
                      Thursday__c=true, 	Friday__c=true,Saturday__c=true,Sunday__c =true ),

                    new XCS_DeskItem__c(Desk__c= xcsDeskList[4].Id,	StartTime__c= dt2.time(),
                      EndTime__c=dt2.addHours(9).time().addMinutes(30), Monday__c=true, Tuesday__c= true,Wednesday__c= false,
                      Thursday__c=false, 	Friday__c=true,Saturday__c=true,Sunday__c =true )
                    };
                    insert xcsDeskListItem;

                    // ################################# Create Event Data test ####################################
                    Datetime dateAppStart = Datetime.newInstance(2019, 09, 20, 10, 0, 0);
                    Datetime dateAppEnd = Datetime.newInstance(2019, 09, 20, 11, 0, 0);
                    Datetime star = Datetime.newInstance(dt.year(), dt.month(), dt.day(), 8, 0, 0);
                    Datetime en = Datetime.newInstance(dt.year(), dt.month(), dt.day(), 12, 0, 0);
                    List<Event> listEvent = new List<Event>{
                    new Event(Desk__c=xcsDeskList[0].Id, ActivityDate=dtEnd.date() ,Type='Indisponibilità', startDateTime= dtEnd, DurationInMinutes= dura,endDateTime= dEnd, ActivityDateTime= dtEnd, Customer__c =listAccountCustomer[0].Id ),
                    new Event(Desk__c=xcsDeskList[1].Id, ActivityDate=dt1.date(),Type='Appuntamento',  startDateTime= dt, DurationInMinutes= duration, endDateTime= dtt, ActivityDateTime= dt, Customer__c= listAccountCustomer[1].Id, Stato_Azione__c ='Presentato' ),
                    new Event(Desk__c=xcsDeskList[0].Id, ActivityDate=dt1.date(),Type='Appuntamento',  startDateTime= dt1, DurationInMinutes= dur, endDateTime= dttE, ActivityDateTime= dt1, Customer__c= listAccountCustomer[0].Id, Stato_Azione__c ='Presentato' ),
                    new Event(Desk__c=xcsDeskList[2].Id, ActivityDate=dt2.date() , Type='Festività', DurationInMinutes= duration ,startDateTime= dt,  endDateTime= dtt, ActivityDateTime= dt, Customer__c=listAccountCustomer[1].Id, Stato_Azione__c ='Presentato' ),
                    new Event(Desk__c=xcsDeskList[2].Id, ActivityDate=dt2.date() , Type='Appuntamento', DurationInMinutes= duration ,startDateTime= dt,  endDateTime= dtt, ActivityDateTime= dt, Customer__c=listAccountCustomer[0].Id ),

                    new Event(Desk__c=xcsDeskList[3].Id, ActivityDate=dt2.date() , Type='Appuntamento', DurationInMinutes= duration ,startDateTime= dt,  endDateTime= dtt, ActivityDateTime= dt),
                    new Event(Desk__c=xcsDeskList[3].Id, ActivityDate=dt2.date() , Type='Appuntamento', DurationInMinutes= 30 ,startDateTime= dt,  endDateTime= endApp, ActivityDateTime= dt,Customer__c= listAccountCustomer[0].Id),
                    new Event(Desk__c=xcsDeskList[4].Id, ActivityDate=dt2.date() , Type='Appuntamento', DurationInMinutes= 30 ,startDateTime= dt,  endDateTime= endApp, ActivityDateTime= dt,Customer__c= listAccountCustomer[1].Id),
                    new Event(Desk__c=xcsDeskList[4].Id, ActivityDate=dateAppStart.date() , Type='Indisponibilità', DurationInMinutes= 60 ,startDateTime= dateAppStart,  endDateTime= dateAppEnd, ActivityDateTime= dateAppStart ),
                    new Event(Desk__c=xcsDeskList[4].Id, ActivityDate=dt2.date() , Type='Indisponibilità', DurationInMinutes= 240 ,startDateTime= star,  endDateTime= en, ActivityDateTime= star)
                    };

                    insert listEvent;

                    // ######################## Product2 Data #######################################################
                    Product2 prodotto = new Product2(Name='prodotto1',ProductCode='145',Livello__c = 2);
                    insert prodotto;
          }

    @isTest
    static void getDeskItemByIdDesk(){
      //  XCS_Desk__c xcs = [SELECT Id FROM XCS_Desk__c LIMIT 1];
        Test.startTest();
        List<String> fields = new List<String>();
          List<String> fieldss = new List<String>();
        fields.add('Friday__c');
        fieldss.add('Monday__c');
      
        List<XCS_DeskItem__c> itemss = AppuntomentoQuery.getDeskItemByIdDesk('22',fieldss);
        List<XCS_DeskItem__c> items = AppuntomentoQuery.getDeskItemByIdDesk('22',fieldss);
        Test.stopTest();
    }

   /* @isTest
    static void checkDisponibilitaFilialetest(){

        Test.startTest();
         Datetime dt = Datetime.newInstance(2019, 08, 13, 08, 0, 0);
          Event ev = AppuntomentoQuery.checkDisponibilitaFiliale('22', dt.date());
          System.debug(' ############### ev '+ev);
        Test.stopTest();

    } */
    
    @isTest
    static void appuntomentoCercatest(){
        Test.startTest();
          List<Event> events = AppuntomentoQuery.appuntomentoCerca('RZZNNN69B25F158O');
          System.debug( ' ########### events'+events);
          System.assertEquals(4, events.size(), '#### pass');
        Test.stopTest();
    }
    
    @isTest
    static void getFilialeInfornationByCodeFilialetest(){
        Test.startTest();
         List<XCS_DeskItem__c> items = AppuntomentoQuery.getFilialeInfornationByCodeFiliale('F18');
         System.debug(' ######### items '+items);
         System.assertNotEquals(0, items.size(), '######## pass ');
        Test.stopTest();
    }
    @isTest
    static void getFilialeByCodeFilialetest(){
        Test.startTest();
          Account acc = AppuntomentoQuery.getFilialeByCodeFiliale('F18');
          System.debug(' ############### Account size  '+acc.XCS_Desk__r.size());
        System.assertEquals('EMPOLI', acc.Name, '####### pass');
        Test.stopTest();
    }
    @isTest
    static void getFilialeByCodeFilialetestException(){
        Test.startTest();
          Account acc = AppuntomentoQuery.getFilialeByCodeFiliale('2452');
        System.assertEquals(null, acc.Id, '####### pass');
        Test.stopTest();
    }
    @isTest
    static void getDeskItemByIdDesktest(){
        List<String> fields = new List<String>{'Friday__c'};
        Test.startTest();
        List<XCS_DeskItem__c> items = AppuntomentoQuery.getDeskItemByIdDesk('F18', fields);
        System.debug(' ######### items '+items);
        System.assertEquals(3, items.size(), ' ##### pass');
        Test.stopTest();
    }
     @isTest
    static void getDeskItemByIdDesktestException(){
        List<String> fields = new List<String>{'Friday__c'};
        Test.startTest();
        List<XCS_DeskItem__c> items = AppuntomentoQuery.getDeskItemByIdDesk('222', fields);
        System.debug(' ######### items '+items);
        System.assertEquals(0, items.size(), ' ##### pass');
        Test.stopTest();
    }
    @isTest
    static void getClientByCodeFiscaletest(){
        Test.startTest();
        Account acc = AppuntomentoQuery.getClientByCodeFiscale('RZZNNN69B25F158O');
        System.assertEquals('BALDEmADICKE', acc.LastName, '######## pass');
        Test.stopTest();

    }
   // @isTest
    static void getClientByCodeFiscaletestException(){
        Test.startTest();
        Account acc = AppuntomentoQuery.getClientByCodeFiscale('RZZNNN69B2F158OXS');
        System.assertEquals(null, acc.LastName, '######## pass');
        Test.stopTest();

    }
    @isTest
    static void  getEventByDatetest(){
        Datetime dt = Datetime.newInstance(2019, 08, 13, 08, 0, 0);
        Test.startTest();
         List<Event>  events = AppuntomentoQuery.getEventByDate(new List<Date>{dt.date()});
         System.debug(' ############ events  '+events);
         Test.stopTest();
    }
     @isTest
    static void  getEventByDateExceptiontest(){
        Datetime dt = Datetime.newInstance(2019, 08, 20, 08, 0, 0);
        Test.startTest();
         List<Event>  events = AppuntomentoQuery.getEventByDate(new List<Date>{dt.date()});
         System.debug(' ############ events  '+events);
         System.assertEquals(1, events.size(), ' ######## pass');
         Test.stopTest();
    }
    
    @isTest
    static void getEventByDatetestDeskException(){
        XCS_Desk__c desk = [SELECT Id FROM XCS_Desk__c LIMIT 1];
         Datetime dt = Datetime.newInstance(2019, 08, 13, 08, 0, 0);
        Test.startTest();
         Event ev = AppuntomentoQuery.getEventByDate(dt.date(), dt, desk.Id );
         System.debug('########### ev '+ev);
         System.assertEquals(null, ev.Id, '####### pass');
        Test.stopTest();
    }
    
    @isTest
    static void appuntamentoCercaByOcsFiscaletest(){
        Set<String> fields = new Set<String>{'RZZNNN69B25F158O',''};
        Test.startTest();
        List<Event> events = AppuntomentoQuery.appuntamentoCercaByOcsFiscale(fields);
        System.debug('############### events  size '+events.size());
        System.assertEquals(10, events.size(), ' ######### pass ');
        Test.stopTest();
    }
    @isTest
    static void appuntamentoCercaByOcsFiscaleExceptest(){
        Set<String> fields = new Set<String>{'xcxcsf','shshhs'};
        Test.startTest();
        List<Event> events = AppuntomentoQuery.appuntamentoCercaByOcsFiscale(fields);
        System.assertEquals(0, events.size(), ' ######## pass ');
        Test.stopTest();
    }
    @isTest
    static void appuntomentoCercaActivetest(){ 
        Test.startTest();
        Event event = AppuntomentoQuery.appuntomentoCercaActive('RZZNNN69B25F158O');
        System.debug(' ############# event '+event);
        System.assertNotEquals(null, event.Id, ' ####### pass ');
        Test.stopTest();

    }
     @isTest
    static void appuntomentoCercaActiveExceptiontest(){ 
        Test.startTest();
     /*   Event ev = [SELECT Id, ActivityDateTime FROM Event WHERE Customer__r.Codice_Fiscale__c ='RZZNNN69B25F158O' LIMIT 1 ];
        Datetime dt = Datetime.newInstance(2019, 11, 20, 8, 0, 0);
        ev.ActivityDateTime = dt;
        update ev;*/
        Event event = AppuntomentoQuery.appuntomentoCercaActive('RZZTNNN69B25F158O');
        System.debug(' ############# event '+event);
        System.assertEquals(null, event.Id, ' ####### pass ');
        Test.stopTest();
    }
    
    @isTest
    static void appuntomentoCercaActiveSetTest(){
        Test.startTest();
        Set<String> setCF = new Set<String>{'RZZNNN69B25F158O'};
        List<Event> event = AppuntomentoQuery.appuntomentoCercaActive(setCF);
        System.debug(' ############# event '+event);
        System.assertNotEquals(0, event.size(), ' ####### pass ');
        Test.stopTest();
    }
    @isTest
    static void appuntomentoCercaActiveSetTestException(){
        Test.startTest();
        Set<String> setCF = new Set<String>{'RZZNNN69B25G158O'};
         List<Event> event = AppuntomentoQuery.appuntomentoCercaActive(setCF);
        System.debug(' ############# event '+event);
        System.assertEquals(0, event.size(), ' ####### pass ');
        Test.stopTest();
    }

    @isTest
    static void getEventCodeFilialeDatetest(){
      // Datetime dt = Datetime.newInstance(2019, 08, 13, 08, 0, 0);
     //  Datetime dt1 = Datetime.newInstance(2019, 08, 13, 09, 30, 20);
        Datetime dt =getDateTime();
        List<Date> dates = new List<Date>{dt.date()};
        Test.startTest();   
        List<Event>  events = AppuntomentoQuery.getEventCodeFilialeDate('F19', dates);
        System.debug(' ########## events'+ events);
        System.assertNotEquals(0, events.size(), ' ########## pass ');
        Test.stopTest();
    }

     @isTest
    static void getEventCodeFilialeDateExceptiontest(){
       Datetime dt = Datetime.newInstance(2019, 08, 13, 08, 0, 0);
       Datetime dt1 = Datetime.newInstance(2019, 08, 13, 09, 30, 20);
        List<Date> dates = new List<Date>{dt.date(), dt1.date()};
        Test.startTest();
        List<Event>  events = AppuntomentoQuery.getEventCodeFilialeDate('25', dates);
        System.debug(' ########## events'+ events);
        System.assertEquals(0, events.size(), ' ########## pass ');
        Test.stopTest();

    }
    @isTest
    static void getXCSDeskItemByIdDesktest(){
        Test.startTest();
        List<XCS_Desk__c> desks = [SELECT id FROM XCS_Desk__c]; 
        List<XCS_DeskItem__c> items = AppuntomentoQuery.getXCSDeskItemByIdDesk(desks);
        System.debug(' ########## items '+items);
        System.assertNotEquals(0, items.size(), ' ####### pass ');
        Test.stopTest();
    }
    @isTest
    static void getXCSDeskItemByIdDeskExceptiontest(){
        XCS_Desk__c desk = new XCS_Desk__c();
        insert desk;
        Test.startTest();
        List<XCS_Desk__c> desks = new List<XCS_Desk__c>{desk}; 
        List<XCS_DeskItem__c> items = AppuntomentoQuery.getXCSDeskItemByIdDesk(desks);
        System.debug(' ########## items '+items);
        System.assertEquals(0, items.size(), ' ####### pass ');
        Test.stopTest();
    }
    
    @isTest
    public static void getEventByIdtest(){
        Event event = [SELECT Id FROM Event Limit 1];
       Test.startTest();
        Event  ev = AppuntomentoQuery.getEventById(event.Id);
        System.assertNotEquals(null, ev.Id, ' ######### message ');
       Test.stopTest();
    }
     @isTest
     public static void getEventByIdExceptiontest(){
      //  Event ev = [SELECT Id FROM Event];
       Test.startTest();
        Event  ev = AppuntomentoQuery.getEventById('a0w5E000003RekCQAS');
        System.assertEquals(null, ev.Id, ' ######### message ');
       Test.stopTest();
    }
    
    @isTest
    public static void getEventByDeskDatetest(){
        List<XCS_Desk__c> desks = [SELECT id FROM XCS_Desk__c]; 
        //Datetime dt = Datetime.newInstance(2019, 08, 13, 08, 0, 0);
        Datetime dt =  getDateTime();
        Test.startTest();
        List<Event> events = AppuntomentoQuery.getEventByDeskDate(desks, dt.date());
        System.assertNotEquals(0, events.size(), ' ###### pass ');
        Test.stopTest();
    }
    @isTest
    public static void getDeskByIdstest(){
        List<XCS_Desk__c> desks = [SELECT id FROM XCS_Desk__c]; 
        Datetime dt = Datetime.newInstance(2019, 8, 13, 08, 0, 0);
        Set<Id> idSets = new Set<Id>();
        idSets.add(desks[0].Id);  idSets.add(desks[1].Id); 
        Test.startTest();
        List<Event> events = AppuntomentoQuery.getDeskByIds(idSets, dt.date());
        System.assertEquals(0, events.size(), ' ###### pass ');
        Test.stopTest();
    }
    @isTest
    public static void getDeskByIdsExceptiontest(){
        List<XCS_Desk__c> desks = [SELECT id FROM XCS_Desk__c]; 
        Datetime dt = Datetime.newInstance(2019, 10, 14, 08, 0, 0);
        Set<Id> idSets = new Set<Id>();
        idSets.add(desks[0].Id);  idSets.add(desks[1].Id);
        Test.startTest();
        List<Event> events = AppuntomentoQuery.getDeskByIds(idSets, dt.date());
        System.assertEquals(0, events.size(), ' ###### pass ');
        Test.stopTest();
    }
    
    @isTest
    static void getSlotOccupatoQuerytest(){
       // Datetime dt = Datetime.newInstance(2019, 8, 13, 08, 0, 0);
        Datetime dt =getDateTime();
        Test.startTest();
        List<Event> events = AppuntomentoQuery.getSlotOccupatoQuery('F18',dt.date());
        System.assertNotEquals(0, events.size(), ' ####### pass ');
        Test.stopTest();
    }
     @isTest
    static void getSlotOccupatoQueryExceptiontest(){
        Datetime dt = Datetime.newInstance(2019, 10, 14, 08, 0, 0);
        Test.startTest();
        List<Event> events = AppuntomentoQuery.getSlotOccupatoQuery('224',dt.date());
        System.assertEquals(0, events.size(), ' ####### pass ');
        Test.stopTest();
    }
    
    @isTest
    static void getCustomertest(){
        Set<String> fields = new Set<String>();
        fields.add('RZZNNN69B25F158O');
        Test.startTest();
        Account acc = AppuntomentoQuery.getCustomer(fields);
        // System.debug(' ################## ')
        System.assertEquals('BALDEmADICKE', acc.LastName, '###### pass ');
        Test.stopTest();
    }

      @isTest
    static void getCustomerExceptiontest(){
        Set<String> fields = new Set<String>();
        fields.add('RZZNNN69B25F1');
        Test.startTest();
        Account acc = AppuntomentoQuery.getCustomer(fields);
        // System.debug(' ################## ')
        System.assertEquals(null , acc.Id, '###### pass ');
        Test.stopTest();
    }
    @isTest
    static void getCalendartest(){
        Test.startTest();
         Calendar  calendar = AppuntomentoQuery.getCalendar('18');
         System.assertNotEquals(null, calendar.Id, ' ###### pass ');
        Test.stopTest();
    }

     @isTest
    static void getCalendartestException(){
        Test.startTest();
         Calendar  calendar = AppuntomentoQuery.getCalendar('188');
         System.assertEquals(null, calendar.Id, ' ###### pass ');
        Test.stopTest();
    }
    
    @isTest
    static void getDeskByDatestest(){
        List<XCS_Desk__c> desks = [SELECT Id FROM  XCS_Desk__c];
        System.debug('################### desks '+desks);
      /*  Set<Id> setId = new Set<Id>();
        for(XCS_Desk__c desk : desks){
            setId.add(desk.Id);
        } */
        List<String> datest = new  List<String>{'Monday__c','Friday__c','Saturday__c'}; 
        Test.startTest();
         List<XCS_DeskItem__c> xdesk =  AppuntomentoQuery.getDeskByDates(desks, datest);
         System.debug('############# xdesk  '+xdesk);
         System.assertNotEquals(0, xdesk.size(),'########## pass ########## ');
        Test.stopTest();
    }
    
    @isTest
    static void getDeskIndisponiblatest(){
        List<XCS_Desk__c> desks = [SELECT Id FROM XCS_Desk__c WHERE Name='Desk3'];
         Datetime dt = Datetime.newInstance(2019, 08, 13, 08, 0, 0);
        List<Date> appuntamentoDates = new List<Date>{ dt.date()};
         
        Test.startTest();
         List<Event> events =  AppuntomentoQuery.getDeskIndisponibla(desks, appuntamentoDates);
         System.debug('######################## events  '+events);
        Test.stopTest();
    }

    static Datetime getDateTime(){
        Datetime dt = Datetime.now();
        dt = dt.addDays(2);
        Datetime dtnew = Datetime.newInstance(dt.year(), dt.month(), dt.day(), 8, 0, 0);
        System.debug(' ################# dtnew'+dtnew);
        return dtnew ;
    }
   static String convertDateToString(Date d){
      String year = (d.year() < 10) ?0+''+String.valueOf(d.year()):String.valueOf(d.year());
      String month = (d.month()< 10)?0+''+String.valueOf(d.month()):String.valueOf(d.month());
      String day = (d.day()< 10)?0+''+String.valueOf(d.day()):String.valueOf(d.day());
      String dayString = year+''+month+''+day;
      return dayString;
   }
   @isTest
   static void getFilialetest(){
        Test.startTest();
        Account account = AppuntomentoQuery.getFiliale('18');
        System.debug('################ account '+account.Id);
        System.assertNotEquals(null, account.Id, '######## passs');
        Test.stopTest();
   }
    @isTest
   static void getFilialeExceptkiontest(){
        Test.startTest();
        Account account = AppuntomentoQuery.getFiliale('F18');
        System.debug('################ account '+account.Id);
        System.assertEquals(null, account.Id, '######## passs');
        Test.stopTest();
   }
   
   @isTest
   static void getPersonContactIdtest(){
       Account account = [SELECT Id FROM Account LIMIT 1];
       Test.startTest();
       Account acc = AppuntomentoQuery.getPersonContactId(account.Id);
       System.assertNotEquals(null, acc.Id, '######## pass');
       Test.stopTest();
   }
    @isTest
   static void getPersonContactIdExceptiontest(){
       XCS_DeskItem__c c = [SELECT Id FROM XCS_DeskItem__c LIMIT 1];
       Test.startTest();
       Account acc = AppuntomentoQuery.getPersonContactId(c.Id);
       System.assertEquals(null, acc.Id, '######## pass');
       Test.stopTest();
   }
   
   @isTest
   static void getDeskIndispotest(){
       List<XCS_Desk__c> desks = [SELECT Id FROM XCS_Desk__c];
       Set<Id> setDesks = new Set<Id>();
       for(XCS_Desk__c d : desks){
           setDesks.add(d.Id);
       }
       Test.startTest();
       Datetime dt = getDateTime();
       List<Date> dates = new List<Date>{dt.date()};
       List<Event> events = AppuntomentoQuery.getDeskIndispo(setDesks, dates);
       System.debug('################## events '+events);
       System.assertNotEquals(0, events.size(), 'msg');
       Test.stopTest();
   }

    @isTest
   static void getDeskIndispoExceptiontest(){
       List<XCS_Desk__c> desks = [SELECT Id FROM XCS_Desk__c];
       Set<Id> setDesks = new Set<Id>();
       for(XCS_Desk__c d : desks){
           setDesks.add(d.Id);
       }
       Test.startTest();
       Datetime dt = Datetime.newInstance(2017, 12, 12);
       List<Date> dates = new List<Date>{dt.date()};
       List<Event> events = AppuntomentoQuery.getDeskIndispo(setDesks, dates);
       System.debug('################## events '+events);
       System.assertEquals(0, events.size(), 'msg');
       Test.stopTest();

   }
   
   @isTest
   static void chekDisponibleDeskByFilialetest(){
       Test.startTest();
       Map<String ,Object> returnValue = AppuntomentoQuery.chekDisponibleDeskByFiliale('EMPOLI');
       System.debug('################# returnValue '+returnValue);

       Test.stopTest();

   }

@isTest
static void getDeskOccupatotest(){
     List<XCS_Desk__c> desks = [SELECT Id FROM XCS_Desk__c];
       Set<Id> setDesks = new Set<Id>();
       for(XCS_Desk__c d : desks){
           setDesks.add(d.Id);
       }
       Test.startTest();
       Datetime dt = getDateTime();
       List<Date> dates = new List<Date>{dt.date()};
       List<Event> events = AppuntomentoQuery.getDeskOccupato(setDesks, dates);
       System.debug('################## events '+events);
     //  System.assertNotEquals(0, events.size(), 'msg');
       Test.stopTest();
}

}