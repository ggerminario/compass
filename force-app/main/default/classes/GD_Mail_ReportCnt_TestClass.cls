/*
 * @Author:          Orlando S.
 * Descrizione:      Classe di Test creata per coprire il codice della classe: GD_Mail_ReportCnt
 * Funzionalità:     Classe di Test relativa al processo di IVASS Gestione Dealer
 * Complessità:      Medio - Alta
 * 
 * */

@isTest
public class GD_Mail_ReportCnt_TestClass {
    //Metodo di Setup
    @testSetup
    static void SetupMethod()
    {
        //Creazione Corso
        IVASS_Dealer_Courses__c CorsoObj = new IVASS_Dealer_Courses__c();
        CorsoObj.Attivo__c = true;
        CorsoObj.Anno_di_Riferimento__c = '2019';
        CorsoObj.Name = 'Scienze Applicate';
        insert CorsoObj;
        
        List<IVASS_Dealer_courses_Iscritti__c> ListaIscrittiToInsert = new List<IVASS_Dealer_courses_Iscritti__c>();
        for( Integer index = 0 ; index < 4 ; index++ )
        {
             IVASS_Dealer_courses_Iscritti__c ObjIstance = new IVASS_Dealer_courses_Iscritti__c();
             ObjIstance.Nome__c                          = 'Pippo'+index;
             ObjIstance.Cognome__c                       = 'Baudo'+index;
             if( index == 0 )ObjIstance.Regione__c       = 'RA';
             if( index == 1 )ObjIstance.Regione__c       = 'RA';
             if( index == 2 )ObjIstance.Regione__c       = 'RO';
             if( index == 3 )ObjIstance.Regione__c       = 'RT';
             ObjIstance.Area__c                          = 8;
             ObjIstance.Corso__c                         =  CorsoObj.Id;
             ListaIscrittiToInsert.add( ObjIstance );
        }
        if( ListaIscrittiToInsert != null && ListaIscrittiToInsert.size() > 0 )insert ListaIscrittiToInsert;
        
        
    }
    @isTest
    static void UnitTestMethod1()
    {
        List<Profile> ListaProfili = [ SELECT Id, Name, PermissionsEmailSingle 
                                       FROM Profile 
                                       WHERE Name in ('Branch Manager', 'Area Manager', 'Trainer') ];
        
        system.debug( '16_12_2019 ListaProfili >> '+ListaProfili );
        
        Map<String,Boolean> MappaCheckBox = new Map<String,Boolean>();
        MappaCheckBox.put('1',true);
        MappaCheckBox.put('2',true);
        MappaCheckBox.put('3',true);
        String listaFiliali = null;

         Test.startTest();
        GD_Mail_ReportCnt.getMappaProfiles();
        GD_Mail_ReportCnt.getProfiles();
        GD_Mail_ReportCnt.ElaborateFileCsvPerArea('RA', new Set<Integer>{8});
   
    }

    @isTest
    static void UnitTestMethod2()
    {
        
        Map<String,Boolean> MappaCheckBox = new Map<String,Boolean>();
        MappaCheckBox.put('1',true);
        MappaCheckBox.put('2',true);
        MappaCheckBox.put('3',true);
        String listaFiliali = null;

        Test.startTest();
        GD_Mail_ReportCnt.sendingMail('message', 'false' , 'false' , 'false' , 'false' , 'false' , 'false' , true , true , true , true , true, true, MappaCheckBox,listaFiliali);
        Test.stopTest();
    }

    @isTest
    static void UnitTestMethod3()
    {
        
        Map<String,Boolean> MappaCheckBox = new Map<String,Boolean>();
        MappaCheckBox.put('11',true);
        MappaCheckBox.put('12',true);
        MappaCheckBox.put('13',true);
        String listaFiliali = null;

         Test.startTest();
        GD_Mail_ReportCnt.sendingMail('message', 'true' , 'false' , 'false' , 'false' , 'false' , 'false' , true , true , true , true , true, true,MappaCheckBox,listaFiliali);
        Test.stopTest();
    }

    @isTest
    static void UnitTestMethod4()
    {
        
        Map<String,Boolean> MappaCheckBox = new Map<String,Boolean>();
        MappaCheckBox.put('1',true);
        MappaCheckBox.put('2',true);
        MappaCheckBox.put('3',true);
        String listaFiliali = null;

        Test.startTest(); 
        GD_Mail_ReportCnt.sendingMail('message', 'true' , 'true' , 'false' , 'false' , 'false' , 'false' , true , true , true , true , true,true, MappaCheckBox,listaFiliali);
        Test.stopTest();
    }

    @isTest
    static void UnitTestMethod5()
    {
        
        Map<String,Boolean> MappaCheckBox = new Map<String,Boolean>();
        MappaCheckBox.put('4',true);
        MappaCheckBox.put('5',true);
        MappaCheckBox.put('6',true);
        String listaFiliali = null;

         Test.startTest();
        GD_Mail_ReportCnt.sendingMail('message', 'true' , 'true' , 'true' , 'true' , 'true' , 'true' , true , true , true , true , true, true, MappaCheckBox,listaFiliali);
        Test.stopTest();
    }

  @isTest
    static void UnitTestMethod6()
    {
        
        Map<String,Boolean> MappaCheckBox = new Map<String,Boolean>();
        MappaCheckBox.put('10',true);
        MappaCheckBox.put('11',true);
        MappaCheckBox.put('12',true);
        String listaFiliali = '[{"id":"10","figli":[{"id":"00E0Q000000UqcLUAS"},{"id":"00E0Q000000UqdyUAC"},{"id":"00E0Q000000UqdpUAC"},{"id":"00E0Q000000UqfxUAC"},{"id":"00E0Q000000UqgcUAC"}]}]';

        Test.startTest(); 
        GD_Mail_ReportCnt.sendingMail('message', 'true' , 'true' , 'true' , 'true' , 'true' , 'true' , true , true , true , true , true, true, MappaCheckBox,listaFiliali);
        Test.stopTest();
    }

   @isTest
    static void UnitTestMethod7()
    {
        
        Map<String,Boolean> MappaCheckBox = new Map<String,Boolean>();
        MappaCheckBox.put('16',true);
        MappaCheckBox.put('17',true);
        MappaCheckBox.put('18',true);
        String listaFiliali = null;
        List<IVASS_Dealer_Courses_Iscritti__c> ListaIscrittiToElaborate = new List<IVASS_Dealer_Courses_Iscritti__c>();
        IVASS_Dealer_Courses_Iscritti__c iscritto = new IVASS_Dealer_Courses_Iscritti__c();
        iscritto.Regione__c = 'RA';
        iscritto.Area__c  = 16;
        IVASS_Dealer_Courses__c corso = new IVASS_Dealer_Courses__c();
        insert corso;
        iscritto.Corso__c = corso.id;
        ListaIscrittiToElaborate.add(iscritto);
        insert ListaIscrittiToElaborate;
        
        Test.startTest();
        GD_Mail_ReportCnt.sendingMail('message', 'true' , 'true' , 'true' , 'true' , 'true' , 'true' , true , true , true , true , true, true, MappaCheckBox,listaFiliali);
         Test.stopTest();
    }  


      @isTest
    static void listaRoleTest()
    {
        Test.startTest();
        GD_Mail_ReportCnt.listaFilialiUserRole();
        Test.stopTest();
    
    } 
}