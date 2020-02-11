/*****************************************
 * ***************************************
 * @Author : Orlando S.
 * 
 * ***************************************
 * */
public with sharing class GD_Mail_ReportCnt {
   

    private static final String mockAddressIVASS = 'inviomailIVASS.mock';    

    public class Filiale{

        @AuraEnabled
        public String id {set;get;}

        @AuraEnabled
        public String name {set;get;}
        
        @AuraEnabled
        public List<Filiale> figli {set;get;} 

        public Filiale() {
            figli = new List<Filiale>();
        }
    }

    
    
    @AuraEnabled
    public static Map<String,object> getProfiles(){
        Map<String, Object> response = new Map<String, Object>();
        response.put('error',false);
        if (!Profile.sObjectType.getDescribe().isAccessible()) {
                throw new AuraHandledException('Non hai accesso');
        }else{
            try {
            List<Profile> profiles = [SELECT Id, Name, PermissionsEmailSingle FROM Profile  WHERE Name in ('Branch Manager', 'Area Manager', 'Trainer')];
            system.debug('04_12_2019 profiles->'+profiles);
            response.put('profiles', profiles);
            } catch (Exception e) {
                response.put('error',true);
                response.put('message',e.getMessage());
                response.put('cause',e.getCause());
                System.debug('message debug: '+e.getMessage());
                System.debug('Cause debug: '+e.getCause());
            }
        }
        return response;
    }




    @AuraEnabled
    public static Map<String,object> sendingMail( String message , String RA , String RC , String RE , String RO , String RS , String RT ,
                                                Boolean AreaManager , Boolean BranchManager , Boolean Trainer , Boolean RegionManager , Boolean BranchEmployer, Boolean Borg,
                                                Map<String,Boolean> MappaCheckBox , String listaFiliali)
    {

        Map<String, Object> response = new Map<String, Object>();
        response.put('error',false);

        try {

                system.debug('04_12_2019 RA+'+RA+'-RC-'+RC+'-RE-'+RE+'-RO-'+RO+'-RS-'+RS+'-RT-'+RT);
                system.debug('04_12_2019 AreaManager:'+AreaManager+'BranchManager:'+BranchManager+'Trainer:'+Trainer+'Region Manager:'+RegionManager+'BranchEmployer:'+BranchEmployer+'Borg:'+Borg);
                system.debug('10_12_2019 MappaCheckBox:'+MappaCheckBox);
                 system.debug('sendingMail listaFiliali:'+listaFiliali);               
            
                Map<String,List<String>> mappaFiliali= null;
                if (listaFiliali!=null && !String.isEmpty(listaFiliali)) {
                    mappaFiliali = new   Map<String,List<String>>();
                    List<Filiale> lisFiliali = (List<Filiale>) JSON.deserialize(listaFiliali, List<Filiale>.class);
                    for (Filiale filiale:lisFiliali){
                        List<Filiale> figli = filiale.figli;
                        mappaFiliali.put(filiale.id,new List<String>());
                        for (Filiale figlio:figli) {
                            List<String> idfigli = (List<String>) mappaFiliali.get(filiale.id);
                            idfigli.add(figlio.id);
                            mappaFiliali.put(filiale.id,idfigli);
                        }
                    }
                }
                system.debug('sendingMail mappaFiliali:'+mappaFiliali);               
            
                //Get della mappa dei Profili
                Map<Id,Profile> MappingProfiles                                               = getMappaProfiles();
                //Get Mappa Profili+Utenti
                Map<String,List<User>> MappingProfileUsers                                    = SelezioneUtentiDaInviareMail( MappingProfiles.Keyset() );
                //Get Mappa Regione/Iscritti    
                Map<String,List<IVASS_Dealer_Courses_Iscritti__c>>  MappingRegioneIscritti    = SuddivisionePerRegioneIscritti();
            
                Map<String,Set<Integer>> MappaCompletaCheckbox                                = ElaborazioneMappa( MappaCheckBox );
            
                system.debug( '11_12_2019 MappaCompletaCheckbox >>> '+MappaCompletaCheckbox );

                CheckCondizioni( Trainer , AreaManager , BranchManager , RegionManager , BranchEmployer, Borg,MappingProfileUsers, message , RA , RC , RE , RO , RS , RT ,
                                MappaCompletaCheckbox ,mappaFiliali);
                response.put('message','Email inviate con successo!');
            
            
            } catch ( Exception e ) {
                response.put('error',true);
                response.put('message',e.getMessage());
                response.put('cause',e.getCause());
                System.debug('message debug: '+e.getMessage());
                System.debug('Cause debug: '+e.getCause());
            }

        return response;
    }

/*************************************************************************************************************************
 *************************************************************************************************************************
 ************************************************ METODI HELPER **********************************************************/
    
    public static Map<Id,Profile> getMappaProfiles()
    {
        return new Map<Id,Profile>( [SELECT Id, Name, PermissionsEmailSingle 
                                        FROM Profile 
                                        WHERE Name in ('Branch Manager', 'Area Manager', 'Trainer','Branch Employee','Borg') ] );
    }

    public static Map<String,List<User>> SelezioneUtentiDaInviareMail( Set<Id> ProfilesId )
    {
        Map<String,List<User>> MapListUsers = new Map<String,List<User>>();
        List<User> ListUsersTotal = [ SELECT ID, Name, UserRoleId, UserRole.Name , UserRole.ParentRoleId, Profile.Name , Email
                                        FROM USER 
                                        WHERE ProfileId IN : ProfilesId AND isActive = true];
        
        for( User UserIstance : ListUsersTotal )
        {
                if( MapListUsers.containsKey( UserIstance.Profile.Name ) )
                {
                    List<User> ListUsr    = MapListUsers.get( UserIstance.Profile.Name );
                    ListUsr.add(UserIstance);
                    MapListUsers.put( UserIstance.Profile.Name , ListUsr );
                
                }else{
                    List<User> ListUsrNew = new List<User>{ UserIstance };    
                    MapListUsers.put( UserIstance.Profile.Name , ListUsrNew );
                }
        }
        
        return MapListUsers;
        
    }
        
    public static Map<String,List<IVASS_Dealer_Courses_Iscritti__c>> SuddivisionePerRegioneIscritti()
    {
            List<IVASS_Dealer_Courses_Iscritti__c> ListaIscritti = [ SELECT Id , Filiale__r.Name, Dipendenza__c , Area__c ,
                                                                            Regione__c , Dealer__r.getCodice_Cliente__c , 
                                                                            Ragione_Sociale__c , Referente__r.OCS_External_Id__c , 
                                                                            Cognome__c , Nome__c ,  Codice_Fiscale__c , Corso__r.Tipo_Corso__r.Name , 
                                                                            Stato_Corso__c , Utenza__c , Password__c , Invio_all_Outsourcer__c
                                                                    FROM IVASS_Dealer_courses_Iscritti__c ];
            
            Map<String,List<IVASS_Dealer_Courses_Iscritti__c>> MappNewRegioneListaIscritti = New Map<String,List<IVASS_Dealer_Courses_Iscritti__c>>();
            system.debug('04_12_2019 ListaIscritti -- '+ListaIscritti);
            
            if( ListaIscritti != null && ListaIscritti.size() > 0 )
            {
                for( IVASS_Dealer_Courses_Iscritti__c ObjIter : ListaIscritti )
                {
                    if( MappNewRegioneListaIscritti.containsKey( ObjIter.Regione__c ) )
                    {
                        List<IVASS_Dealer_courses_Iscritti__c> ListaEsistente = MappNewRegioneListaIscritti.get( ObjIter.Regione__c );
                        ListaEsistente.add( ObjIter );
                        MappNewRegioneListaIscritti.put( ObjIter.Regione__c , ListaEsistente );
                    }else{
                        List<IVASS_Dealer_courses_Iscritti__c> ListaNew = new List<IVASS_Dealer_Courses_Iscritti__c>{ ObjIter };
                        MappNewRegioneListaIscritti.put( ObjIter.Regione__c , ListaNew );        
                    }
                }
            }
        
            return MappNewRegioneListaIscritti;
    }    



 
    public static void CheckCondizioni( boolean TrainerFlag , boolean AreaManagerFlag , boolean BranchManagerFlag , boolean RegionManager , boolean BranchEmployerFlag, boolean Borg,
                                        Map<String,List<User>> MappProfUsers , String MessageInput ,
                                        String RA , String RC , String RE , String RO , String RS , String RT ,
                                        //Map<String,List<Integer>> MappaRegioneAree ,
                                        Map<String,Set<Integer>> MappaCompletaCheckbox ,
                                        Map<String,List<String>> mapFiliali)
    {
        boolean ALLFalse = false;
        String ListaIscritti_RegioneRA = '';
        String ListaIscritti_RegioneRC = '';
        String ListaIscritti_RegioneRE = '';
        String ListaIscritti_RegioneRO = '';
        String ListaIscritti_RegioneRS = '';
        String ListaIscritti_RegioneRT = '';
        Map<String,Messaging.EmailFileAttachment> MapEmailAttachments = new Map<String,Messaging.EmailFileAttachment>();
        // Create a master list to store the emails that we will send
        List<Messaging.SingleEmailMessage> masterListMails            = new List<Messaging.SingleEmailMessage>();
        //Lista Utenti
        List<User> ListaUsers                                         = MappProfUsers.get('Trainer');
        List<User> ListaUsersAreaManager                              = MappProfUsers.get('Area Manager');    
        List<User> ListaUserBranchManager                            = MappProfUsers.get('Branch Manager');    
        List<User> ListaUserBranchEmployer                            = MappProfUsers.get('Branch Employee');    
        List<User> ListaBorg                                           = MappProfUsers.get('Borg');    
        
        String subject                                                = 'Email Report';
        String body                                                   = MessageInput;  

        
        if( RA == 'false' && RC == 'false' && RE == 'false' && RO == 'false' &&
            RS == 'false' && RT == 'false' )ALLFalse = true;
        
        system.debug('ALLFalse->'+ALLFalse);

        
        //Caso Trainer
        if( TrainerFlag )
        {
            system.debug('06_12_2019 Trainer');
            if( ALLFalse == true )
            {
                system.debug('06_12_2019 Trainer ALLFalse');
                //Invio Verso tutti i Trainer
                ListaIscritti_RegioneRA         = ElaborateFileCsv('RA');
                ListaIscritti_RegioneRC         = ElaborateFileCsv('RC');
                ListaIscritti_RegioneRE         = ElaborateFileCsv('RE');
                ListaIscritti_RegioneRO         = ElaborateFileCsv('RO');
                ListaIscritti_RegioneRS         = ElaborateFileCsv('RS');
                ListaIscritti_RegioneRT         = ElaborateFileCsv('RT');
                
                MapEmailAttachments.put('RA',TemplateMailsReturnObject(ListaIscritti_RegioneRA,'RA'));
                MapEmailAttachments.put('RC',TemplateMailsReturnObject(ListaIscritti_RegioneRC,'RC'));
                MapEmailAttachments.put('RE',TemplateMailsReturnObject(ListaIscritti_RegioneRE,'RE'));
                MapEmailAttachments.put('RO',TemplateMailsReturnObject(ListaIscritti_RegioneRO,'RO'));
                MapEmailAttachments.put('RS',TemplateMailsReturnObject(ListaIscritti_RegioneRS,'RS'));
                MapEmailAttachments.put('RT',TemplateMailsReturnObject(ListaIscritti_RegioneRT,'RT'));
            
                for( User Usr : ListaUsers )
                {
                        Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage(); 
                        email.setSenderDisplayName('Ivass Mail Report');
                        email.setSubject( subject ); 
                        email.setPlainTextBody( body );
                        system.debug('(profile trainer) Usr.Name '+ Usr.Name+' Usr.UserRole.Name->'+Usr.UserRole.Name);              
                        if( Usr.UserRole.Name == 'Trainer_A')
                        {
                            email.setFileAttachments(new Messaging.EmailFileAttachment[]{ MapEmailAttachments.get('RA') });
                            List<String> sendTo = new List<String>();
                            sendTo.add(usr.Email);
                            email.setToAddresses(sendTo);
                            masterListMails.add(email);
                        }else if( Usr.UserRole.Name == 'Trainer_C' )
                        {
                            email.setFileAttachments(new Messaging.EmailFileAttachment[]{ MapEmailAttachments.get('RC') });
                            List<String> sendTo = new List<String>();
                            sendTo.add(usr.Email);
                            email.setToAddresses(sendTo);
                            masterListMails.add(email);
                        }else if( Usr.UserRole.Name == 'Trainer_E' )
                        {
                            email.setFileAttachments(new Messaging.EmailFileAttachment[]{ MapEmailAttachments.get('RE') });
                            List<String> sendTo = new List<String>();
                            sendTo.add(usr.Email);
                            email.setToAddresses(sendTo);
                            masterListMails.add(email);
                        }else if( Usr.UserRole.Name == 'Trainer_O' )
                        {
                            email.setFileAttachments(new Messaging.EmailFileAttachment[]{ MapEmailAttachments.get('RO') });
                            List<String> sendTo = new List<String>();
                            sendTo.add(usr.Email);
                            email.setToAddresses(sendTo);
                            masterListMails.add(email);
                        }else if( Usr.UserRole.Name == 'Trainer_S' )
                        {
                            email.setFileAttachments(new Messaging.EmailFileAttachment[]{ MapEmailAttachments.get('RS') });
                            List<String> sendTo = new List<String>();
                            sendTo.add(usr.Email);
                            email.setToAddresses(sendTo);
                            masterListMails.add(email);
                        }else if( Usr.UserRole.Name == 'Trainer_T')
                        {
                            email.setFileAttachments(new Messaging.EmailFileAttachment[]{ MapEmailAttachments.get('RT') });
                            List<String> sendTo = new List<String>();
                            sendTo.add(usr.Email);
                            email.setToAddresses(sendTo);
                            masterListMails.add(email);
                        }
                        // Add your email address into the master list
                    }
            
                // Sends mass emails
                //  // Sends mass emails
                system.debug('masterListMails->'+masterListMails.size());
                if( masterListMails != null && masterListMails.size() > 0 && !Test.isRunningTest())
                {
                    EmailUtils.sendEmail(masterListMails,mockAddressIVASS);
                }
                //response.put('message','Email inviato con successo!');
            }
            else{
                system.debug('06_12_2019 Trainer !ALLFalse');
                    //Invio Verso alcuni Trainer
                if( RA == 'true' )
                {
                    
                    if( MappaCompletaCheckbox.get('RA') != null && MappaCompletaCheckbox.get('RA').size() > 0 )
                    {
                        ListaIscritti_RegioneRA         = ElaborateFileCsvPerArea('RA', MappaCompletaCheckbox.get('RA') );
                    }else{
                        ListaIscritti_RegioneRA         = ElaborateFileCsv('RA');
                    }
                    MapEmailAttachments.put('RA',TemplateMailsReturnObject(ListaIscritti_RegioneRA,'RA'));
                }
                if( RC == 'true' )
                {
                    if( MappaCompletaCheckbox.get('RC') != null && MappaCompletaCheckbox.get('RC').size() > 0 )
                    {
                        ListaIscritti_RegioneRC = ElaborateFileCsvPerArea('RC', MappaCompletaCheckbox.get('RC') );
                    }else{   
                    ListaIscritti_RegioneRC         = ElaborateFileCsv('RC');
                    }
                    MapEmailAttachments.put('RC',TemplateMailsReturnObject(ListaIscritti_RegioneRC,'RC'));
                }
                if( RE == 'true' )
                {
                    if( MappaCompletaCheckbox.get('RE') != null && MappaCompletaCheckbox.get('RE').size() > 0 )
                    {
                        ListaIscritti_RegioneRE = ElaborateFileCsvPerArea('RE', MappaCompletaCheckbox.get('RE') );
                    }else{
                        ListaIscritti_RegioneRE         = ElaborateFileCsv('RE');
                    }
                    MapEmailAttachments.put('RE',TemplateMailsReturnObject(ListaIscritti_RegioneRE,'RE'));
                } 
                if( RO == 'true' )
                {
                    if( MappaCompletaCheckbox.get('RO') != null && MappaCompletaCheckbox.get('RO').size() > 0 )
                    {
                        ListaIscritti_RegioneRO         = ElaborateFileCsvPerArea('RO', MappaCompletaCheckbox.get('RO') );
                    }else{
                    ListaIscritti_RegioneRO         = ElaborateFileCsv('RO');
                    }
                    MapEmailAttachments.put('RO',TemplateMailsReturnObject(ListaIscritti_RegioneRO,'RO'));
                }
                if( RS == 'true' )
                {
                    if( MappaCompletaCheckbox.get('RO') != null && MappaCompletaCheckbox.get('RO').size() > 0 )
                    {
                        ListaIscritti_RegioneRS     = ElaborateFileCsvPerArea('RS', MappaCompletaCheckbox.get('RS'));
                    }else{
                        ListaIscritti_RegioneRS         = ElaborateFileCsv('RS');
                    }
                    MapEmailAttachments.put('RS',TemplateMailsReturnObject(ListaIscritti_RegioneRS,'RS'));
                }
                if( RT == 'true' )
                {
                    if( MappaCompletaCheckbox.get('RT') != null && MappaCompletaCheckbox.get('RT').size() > 0 )
                    {
                        ListaIscritti_RegioneRT     = ElaborateFileCsvPerArea('RT', MappaCompletaCheckbox.get('RT'));
                    }else{
                        ListaIscritti_RegioneRT         = ElaborateFileCsv('RT');
                    }
                    MapEmailAttachments.put('RT',TemplateMailsReturnObject(ListaIscritti_RegioneRT,'RT'));
                }
                    
                List<String> ListaEmailsToSend = new List<String>();
                for( User Usr : ListaUsers )
                {    
                        system.debug('(profile trainer) Usr.UserRole.Name '+ Usr.Name+' Usr.UserRole.Name->'+Usr.UserRole.Name);  
                        // Define the email
                        Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage(); 
                        email.setSenderDisplayName('Ivass Mail Report');
                        email.setSubject( subject ); 
                        email.setPlainTextBody( body );
                        if( Usr.UserRole.Name == 'Trainer_A' && RA == 'true' )
                        {
                            system.debug('---TRAINER_A---');
                            email.setFileAttachments(new Messaging.EmailFileAttachment[]{ MapEmailAttachments.get('RA') });
                            List<String> sendTo = new List<String>();
                            sendTo.add(usr.Email);ListaEmailsToSend.add(usr.Email);
                            email.setToAddresses(sendTo);
                            masterListMails.add(email);
                        }else if( Usr.UserRole.Name == 'Trainer_C' && RC == 'true' )
                        { 
                            system.debug('---TRAINER_C---');
                            email.setFileAttachments(new Messaging.EmailFileAttachment[]{ MapEmailAttachments.get('RC') });
                            List<String> sendTo = new List<String>();
                            sendTo.add(usr.Email);ListaEmailsToSend.add(usr.Email);
                            email.setToAddresses(sendTo);
                            masterListMails.add(email);
                        }else if( Usr.UserRole.Name == 'Trainer_E' && RE == 'true' )
                        {
                            system.debug('---TRAINER_E---');
                            email.setFileAttachments(new Messaging.EmailFileAttachment[]{ MapEmailAttachments.get('RE') });
                            List<String> sendTo = new List<String>();
                            sendTo.add(usr.Email);ListaEmailsToSend.add(usr.Email);
                            email.setToAddresses(sendTo);
                            masterListMails.add(email);
                        }else if( Usr.UserRole.Name == 'Trainer_O' && RO == 'true' )
                        {
                            system.debug('---TRAINER_O---');
                            email.setFileAttachments(new Messaging.EmailFileAttachment[]{ MapEmailAttachments.get('RO') });
                            List<String> sendTo = new List<String>();
                            sendTo.add(usr.Email);ListaEmailsToSend.add(usr.Email);
                            email.setToAddresses(sendTo);
                            masterListMails.add(email);
                        }else if( Usr.UserRole.Name == 'Trainer_S' && RS == 'true' )
                        {
                            system.debug('---TRAINER_S---');
                            email.setFileAttachments(new Messaging.EmailFileAttachment[]{ MapEmailAttachments.get('RS') });
                            List<String> sendTo = new List<String>();
                            sendTo.add(usr.Email);ListaEmailsToSend.add(usr.Email);
                            email.setToAddresses(sendTo);
                            masterListMails.add(email);
                        }else if( Usr.UserRole.Name == 'Trainer_T' && RT == 'true' )
                        {
                            system.debug('---TRAINER_T---');
                            email.setFileAttachments(new Messaging.EmailFileAttachment[]{ MapEmailAttachments.get('RT') });
                            List<String> sendTo = new List<String>();
                            sendTo.add(usr.Email);ListaEmailsToSend.add(usr.Email);
                            email.setToAddresses(sendTo);
                            masterListMails.add(email);
                        }
                }
            
                // Sends mass emails
                system.debug('masterListMails(trainer)->'+masterListMails.size()+ListaEmailsToSend);
                if( masterListMails != null && masterListMails.size() > 0 && !Test.isRunningTest() )
                {
                    EmailUtils.sendEmail(masterListMails,mockAddressIVASS);
                }
                
            }        
        }
        //Caso Region Manager
        masterListMails            = new List<Messaging.SingleEmailMessage>();   
        if( RegionManager )
        {
            system.debug('06_12_2019 Region Manager');
            if( ALLFalse == true )
            {
                //Invio Verso tutti i Region manager
                ListaIscritti_RegioneRA         = ElaborateFileCsv('RA');
                ListaIscritti_RegioneRC         = ElaborateFileCsv('RC');
                ListaIscritti_RegioneRE         = ElaborateFileCsv('RE');
                ListaIscritti_RegioneRO         = ElaborateFileCsv('RO');
                ListaIscritti_RegioneRS         = ElaborateFileCsv('RS');
                ListaIscritti_RegioneRT         = ElaborateFileCsv('RT');
                
                MapEmailAttachments.put('RA',TemplateMailsReturnObject(ListaIscritti_RegioneRA,'RA'));
                MapEmailAttachments.put('RC',TemplateMailsReturnObject(ListaIscritti_RegioneRC,'RC'));
                MapEmailAttachments.put('RE',TemplateMailsReturnObject(ListaIscritti_RegioneRE,'RE'));
                MapEmailAttachments.put('RO',TemplateMailsReturnObject(ListaIscritti_RegioneRO,'RO'));
                MapEmailAttachments.put('RS',TemplateMailsReturnObject(ListaIscritti_RegioneRS,'RS'));
                MapEmailAttachments.put('RT',TemplateMailsReturnObject(ListaIscritti_RegioneRT,'RT'));
                
                for( User Usr : ListaUsersAreaManager )
                {
                        Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage(); 
                        email.setSenderDisplayName('Ivass Mail Report');
                        email.setSubject( subject ); 
                        email.setPlainTextBody( body );
                        system.debug('(profile region manager) Usr.Name '+ Usr.Name+' Usr.UserRole.Name->'+Usr.UserRole.Name);              
                        if( Usr.UserRole.Name == 'REGIONE ADRIATICA')
                        {
                            email.setFileAttachments(new Messaging.EmailFileAttachment[]{ MapEmailAttachments.get('RA') });
                            List<String> sendTo = new List<String>();
                            sendTo.add(usr.Email);
                            email.setToAddresses(sendTo);
                            masterListMails.add(email);
                        }else if( Usr.UserRole.Name == 'REGIONE CENTRO' )
                        {
                            email.setFileAttachments(new Messaging.EmailFileAttachment[]{ MapEmailAttachments.get('RC') });
                            List<String> sendTo = new List<String>();
                            sendTo.add(usr.Email);
                            email.setToAddresses(sendTo);
                            masterListMails.add(email);
                        }else if( Usr.UserRole.Name == 'REGIONE NORD EST' )
                        {
                            email.setFileAttachments(new Messaging.EmailFileAttachment[]{ MapEmailAttachments.get('RE') });
                            List<String> sendTo = new List<String>();
                            sendTo.add(usr.Email);
                            email.setToAddresses(sendTo);
                            masterListMails.add(email);
                        }else if( Usr.UserRole.Name == 'REGIONE NORD OVEST' )
                        {
                            email.setFileAttachments(new Messaging.EmailFileAttachment[]{ MapEmailAttachments.get('RO') });
                            List<String> sendTo = new List<String>();
                            sendTo.add(usr.Email);
                            email.setToAddresses(sendTo);
                            masterListMails.add(email);
                        }else if( Usr.UserRole.Name == 'REGIONE SUD' )
                        {
                            email.setFileAttachments(new Messaging.EmailFileAttachment[]{ MapEmailAttachments.get('RS') });
                            List<String> sendTo = new List<String>();
                            sendTo.add(usr.Email);
                            email.setToAddresses(sendTo);
                            masterListMails.add(email);
                        }else if( Usr.UserRole.Name == 'REGIONE TIRRENICA')
                        {
                            email.setFileAttachments(new Messaging.EmailFileAttachment[]{ MapEmailAttachments.get('RT') });
                            List<String> sendTo = new List<String>();
                            sendTo.add(usr.Email);
                            email.setToAddresses(sendTo);				    
                            masterListMails.add(email);
                        }
                        // Add your email address into the master list
                    }
            
                // Sends mass emails
                if( masterListMails != null && masterListMails.size() > 0 && !Test.isRunningTest() )
                {
                    EmailUtils.sendEmail(masterListMails,mockAddressIVASS);
                }
            
            }
            else{
                if( RA == 'true' )
                {
                    if( MappaCompletaCheckbox.get('RA') != null && MappaCompletaCheckbox.get('RA').size() > 0 )
                    {
                        ListaIscritti_RegioneRA        = ElaborateFileCsvPerArea('RA', MappaCompletaCheckbox.get('RA'));
                    }else{
                        ListaIscritti_RegioneRA         = ElaborateFileCsv('RA');
                    }
                    MapEmailAttachments.put('RA',TemplateMailsReturnObject(ListaIscritti_RegioneRA,'RA'));
                }
                if( RC == 'true' )
                {  
                    if( MappaCompletaCheckbox.get('RC') != null && MappaCompletaCheckbox.get('RC').size() > 0 )
                    {
                        ListaIscritti_RegioneRC     = ElaborateFileCsvPerArea('RC', MappaCompletaCheckbox.get('RC'));
                    }else{
                        ListaIscritti_RegioneRC         = ElaborateFileCsv('RC');
                    }
                    MapEmailAttachments.put('RC',TemplateMailsReturnObject(ListaIscritti_RegioneRC,'RC'));
                }
                if( RE == 'true' )
                {
                    if( MappaCompletaCheckbox.get('RE') != null && MappaCompletaCheckbox.get('RE').size() > 0 )
                    {
                        ListaIscritti_RegioneRE         = ElaborateFileCsvPerArea('RE',  MappaCompletaCheckbox.get('RE')); 
                    }else{
                        ListaIscritti_RegioneRE         = ElaborateFileCsv('RE');
                    }
                    MapEmailAttachments.put('RE',TemplateMailsReturnObject(ListaIscritti_RegioneRE,'RE'));
                }
                if( RO == 'true' )
                {
                    if( MappaCompletaCheckbox.get('RO') != null && MappaCompletaCheckbox.get('RO').size() > 0 )
                    {
                        ListaIscritti_RegioneRO         = ElaborateFileCsvPerArea('RO', MappaCompletaCheckbox.get('RO'));
                    }else{
                        ListaIscritti_RegioneRO         = ElaborateFileCsv('RO');
                    }
                    MapEmailAttachments.put('RO',TemplateMailsReturnObject(ListaIscritti_RegioneRO,'RO'));
                }
                if( RS == 'true' )
                {
                    if( MappaCompletaCheckbox.get('RS') != null && MappaCompletaCheckbox.get('RS').size() > 0 )
                    {
                        ListaIscritti_RegioneRS         = ElaborateFileCsvPerArea('RS', MappaCompletaCheckbox.get('RS'));
                    }else{
                        ListaIscritti_RegioneRS         = ElaborateFileCsv('RS');
                    }
                    MapEmailAttachments.put('RS',TemplateMailsReturnObject(ListaIscritti_RegioneRS,'RS'));
                }
                if( RT == 'true' )
                {
                    if( MappaCompletaCheckbox.get('RT') != null && MappaCompletaCheckbox.get('RT').size() > 0 )
                    {
                        ListaIscritti_RegioneRT         = ElaborateFileCsvPerArea('RT', MappaCompletaCheckbox.get('RT'));
                    }else{
                        ListaIscritti_RegioneRT         = ElaborateFileCsv('RT');
                    }
                    MapEmailAttachments.put('RT',TemplateMailsReturnObject(ListaIscritti_RegioneRT,'RT'));
                }
                
                for( User Usr : ListaUsersAreaManager )
                {    
                        system.debug('(profile region manager) Usr.Name '+ Usr.Name+' Usr.UserRole.Name->'+Usr.UserRole.Name);    
                        // Define the email
                        Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage(); 
                        email.setSenderDisplayName('Ivass Mail Report');
                        email.setSubject( subject ); 
                        email.setPlainTextBody( body );
                        if( Usr.UserRole.Name == 'REGIONE ADRIATICA' && RA == 'true' )
                        {
                            system.debug('---REGIONE ADRIATICA---');
                            email.setFileAttachments(new Messaging.EmailFileAttachment[]{ MapEmailAttachments.get('RA') });
                            List<String> sendTo = new List<String>();
                            sendTo.add(usr.Email);
                            email.setToAddresses(sendTo);
                            masterListMails.add(email);
                        }else if( Usr.UserRole.Name == 'REGIONE CENTRO' && RC == 'true' )
                        { 
                            system.debug('---REGIONE CENTRO---');
                            email.setFileAttachments(new Messaging.EmailFileAttachment[]{ MapEmailAttachments.get('RC') });
                            List<String> sendTo = new List<String>();
                            sendTo.add(usr.Email);
                            email.setToAddresses(sendTo);
                            masterListMails.add(email);
                        }else if( Usr.UserRole.Name == 'REGIONE NORD EST' && RE == 'true' )
                        {
                            system.debug('---REGIONE NORD EST---');
                            email.setFileAttachments(new Messaging.EmailFileAttachment[]{ MapEmailAttachments.get('RE') });
                            List<String> sendTo = new List<String>();
                            sendTo.add(usr.Email);
                            email.setToAddresses(sendTo);
                            masterListMails.add(email);
                        }else if( Usr.UserRole.Name == 'REGIONE NORD OVEST' && RO == 'true' )
                        {
                            system.debug('---REGIONE NORD OVEST---');
                            email.setFileAttachments(new Messaging.EmailFileAttachment[]{ MapEmailAttachments.get('RO') });
                            List<String> sendTo = new List<String>();
                            sendTo.add(usr.Email);
                            email.setToAddresses(sendTo);
                            masterListMails.add(email);
                        }else if( Usr.UserRole.Name == 'REGIONE SUD' && RS == 'true' )
                        {
                            system.debug('---REGIONE SU---');
                            email.setFileAttachments(new Messaging.EmailFileAttachment[]{ MapEmailAttachments.get('RS') });
                            List<String> sendTo = new List<String>();
                            sendTo.add(usr.Email);
                            email.setToAddresses(sendTo);
                            masterListMails.add(email);
                        }else if( Usr.UserRole.Name == 'REGIONE TIRRENICA' && RT == 'true' )
                        {
                            system.debug('---REGIONE TIRRENICA---');
                            email.setFileAttachments(new Messaging.EmailFileAttachment[]{ MapEmailAttachments.get('RT') });
                            List<String> sendTo = new List<String>();
                            sendTo.add(usr.Email);
                            email.setToAddresses(sendTo);
                            masterListMails.add(email);
                        }
                }
            
                // Sends mass emails
                system.debug('masterListMails->'+masterListMails.size());
                if( masterListMails != null && masterListMails.size() > 0 && !Test.isRunningTest() )
                {
                   EmailUtils.sendEmail(masterListMails,mockAddressIVASS);
                }
            }             
        }
        //Caso Area Manager
        masterListMails            = new List<Messaging.SingleEmailMessage>();
        if( AreaManagerFlag )
        {
            system.debug('06_12_2019 Area Manager');
            if( ALLFalse == true )
            {
                system.debug('06_12_2019 Area Manager ALLFalse');

                //Invio Verso tutti i Area manager
                ListaIscritti_RegioneRA         = ElaborateFileCsv('RA');
                ListaIscritti_RegioneRC         = ElaborateFileCsv('RC');
                ListaIscritti_RegioneRE         = ElaborateFileCsv('RE');
                ListaIscritti_RegioneRO         = ElaborateFileCsv('RO');
                ListaIscritti_RegioneRS         = ElaborateFileCsv('RS');
                ListaIscritti_RegioneRT         = ElaborateFileCsv('RT');
                
                MapEmailAttachments.put('RA',TemplateMailsReturnObject(ListaIscritti_RegioneRA,'RA'));
                MapEmailAttachments.put('RC',TemplateMailsReturnObject(ListaIscritti_RegioneRC,'RC'));
                MapEmailAttachments.put('RE',TemplateMailsReturnObject(ListaIscritti_RegioneRE,'RE'));
                MapEmailAttachments.put('RO',TemplateMailsReturnObject(ListaIscritti_RegioneRO,'RO'));
                MapEmailAttachments.put('RS',TemplateMailsReturnObject(ListaIscritti_RegioneRS,'RS'));
                MapEmailAttachments.put('RT',TemplateMailsReturnObject(ListaIscritti_RegioneRT,'RT'));

                for( User Usr : ListaUsersAreaManager )
                {
                        Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage(); 
                        email.setSenderDisplayName('Ivass Mail Report');
                        email.setSubject( subject ); 
                        email.setPlainTextBody( body );
                        system.debug('(profile area manager) Usr.UserRole.Name '+ Usr.Name+' Usr.UserRole.Name->'+Usr.UserRole.Name);              
                        if( Usr.UserRole.Name == 'COORD. AREA 16' || Usr.UserRole.Name == 'COORD. AREA 17' || Usr.UserRole.Name == 'COORD. AREA 18' ||
                            Usr.UserRole.Name == 'COORD. AREA 19' || Usr.UserRole.Name == 'COORD. AREA 20')
                        {
                            email.setFileAttachments(new Messaging.EmailFileAttachment[]{ MapEmailAttachments.get('RA') });
                            List<String> sendTo = new List<String>();
                            sendTo.add(usr.Email);
                            email.setToAddresses(sendTo);
                            masterListMails.add(email);
                        }else if( Usr.UserRole.Name == 'COORD. AREA 11' || Usr.UserRole.Name == 'COORD. AREA 12' || Usr.UserRole.Name == 'COORD. AREA 13' ||
                                Usr.UserRole.Name == 'COORD. AREA 14' || Usr.UserRole.Name == 'COORD. AREA 15')
                        {
                            email.setFileAttachments(new Messaging.EmailFileAttachment[]{ MapEmailAttachments.get('RC') });
                            List<String> sendTo = new List<String>();
                            sendTo.add(usr.Email);
                            email.setToAddresses(sendTo);
                            masterListMails.add(email);
                        }else if( Usr.UserRole.Name == 'COORD. AREA 6' || Usr.UserRole.Name == 'COORD. AREA 7' || Usr.UserRole.Name == 'COORD. AREA 8' ||
                                Usr.UserRole.Name == 'COORD. AREA 9' || Usr.UserRole.Name == 'COORD. AREA 10')
                        {
                            email.setFileAttachments(new Messaging.EmailFileAttachment[]{ MapEmailAttachments.get('RE') });
                            List<String> sendTo = new List<String>();
                            sendTo.add(usr.Email);
                            email.setToAddresses(sendTo);
                            masterListMails.add(email);
                        }else if( Usr.UserRole.Name == 'COORD. AREA 1' || Usr.UserRole.Name == 'COORD. AREA 2' || Usr.UserRole.Name == 'COORD. AREA 3' ||
                                Usr.UserRole.Name == 'COORD. AREA 4' || Usr.UserRole.Name == 'COORD. AREA 5')
                        {
                            email.setFileAttachments(new Messaging.EmailFileAttachment[]{ MapEmailAttachments.get('RO') });
                            List<String> sendTo = new List<String>();
                            sendTo.add(usr.Email);
                            email.setToAddresses(sendTo);
                            masterListMails.add(email);
                        }else if( Usr.UserRole.Name == 'COORD. AREA 26' || Usr.UserRole.Name == 'COORD. AREA 27' || Usr.UserRole.Name == 'COORD. AREA 28' ||
                                Usr.UserRole.Name == 'COORD. AREA 29' || Usr.UserRole.Name == 'COORD. AREA 30' )
                        {
                            email.setFileAttachments(new Messaging.EmailFileAttachment[]{ MapEmailAttachments.get('RS') });
                            List<String> sendTo = new List<String>();
                            sendTo.add(usr.Email);
                            email.setToAddresses(sendTo);
                            masterListMails.add(email);
                        }else if( Usr.UserRole.Name == 'COORD. AREA 21' || Usr.UserRole.Name == 'COORD. AREA 22' || Usr.UserRole.Name == 'COORD. AREA 23' ||
                                Usr.UserRole.Name == 'COORD. AREA 24' || Usr.UserRole.Name == 'COORD. AREA 25' )
                        {
                            email.setFileAttachments(new Messaging.EmailFileAttachment[]{ MapEmailAttachments.get('RT') });
                            List<String> sendTo = new List<String>();
                            sendTo.add(usr.Email);
                            email.setToAddresses(sendTo);
                            masterListMails.add(email);
                        }
                        // Add your email address into the master list
                    }
                    
                // Sends mass emails
                system.debug('masterListMails->'+masterListMails.size());
                if( masterListMails != null && masterListMails.size() > 0 && !Test.isRunningTest() )
                {
                   EmailUtils.sendEmail(masterListMails,mockAddressIVASS);
                }
                
            }
            else{
                system.debug('06_12_2019 Area Manager !ALLFalse');
                //Invio Verso alcuni area Manager
                if( RA == 'true' )
                {
                    if( MappaCompletaCheckbox.get('RA') != null && MappaCompletaCheckbox.get('RA').size() > 0 )
                    {
                        ListaIscritti_RegioneRA         = ElaborateFileCsvPerArea('RA', MappaCompletaCheckbox.get('RA'));//ElaborateFileCsv('RA');
                    }else{
                        ListaIscritti_RegioneRA         = ElaborateFileCsv('RA');
                    }
                    MapEmailAttachments.put('RA',TemplateMailsReturnObject(ListaIscritti_RegioneRA,'RA'));
                }
                if( RC == 'true' )
                {
                    if( MappaCompletaCheckbox.get('RC') != null && MappaCompletaCheckbox.get('RC').size() > 0 )
                    {
                        ListaIscritti_RegioneRC         = ElaborateFileCsvPerArea('RC', MappaCompletaCheckbox.get('RC'));
                    }else{
                        ListaIscritti_RegioneRC         = ElaborateFileCsv('RC');
                    }
                    MapEmailAttachments.put('RC',TemplateMailsReturnObject(ListaIscritti_RegioneRC,'RC'));
                }
                if( RE == 'true' )
                {
                    if( MappaCompletaCheckbox.get('RE') != null && MappaCompletaCheckbox.get('RE').size() > 0 )
                    {
                        ListaIscritti_RegioneRE         = ElaborateFileCsvPerArea('RE', MappaCompletaCheckbox.get('RE'));
                    }else{
                        ListaIscritti_RegioneRE         = ElaborateFileCsv('RE');
                    }
                    MapEmailAttachments.put('RE',TemplateMailsReturnObject(ListaIscritti_RegioneRE,'RE'));
                } 
                if( RO == 'true' )
                {
                    if( MappaCompletaCheckbox.get('RO') != null && MappaCompletaCheckbox.get('RO').size() > 0 )
                    {
                        ListaIscritti_RegioneRO         = ElaborateFileCsvPerArea('RO', MappaCompletaCheckbox.get('RO'));
                    }else{
                        ListaIscritti_RegioneRO         = ElaborateFileCsv('RO');
                    }
                    MapEmailAttachments.put('RO',TemplateMailsReturnObject(ListaIscritti_RegioneRO,'RO'));
                }
                if( RS == 'true' )
                {
                    if( MappaCompletaCheckbox.get('RS') != null && MappaCompletaCheckbox.get('RS').size() > 0 )  
                    {
                        ListaIscritti_RegioneRS          = ElaborateFileCsvPerArea('RS', MappaCompletaCheckbox.get('RS'));
                    }else{
                        ListaIscritti_RegioneRS          = ElaborateFileCsv('RS');
                    }
                    MapEmailAttachments.put('RS',TemplateMailsReturnObject(ListaIscritti_RegioneRS,'RS'));
                }
                if( RT == 'true' )
                {
                    if( MappaCompletaCheckbox.get('RT') != null && MappaCompletaCheckbox.get('RT').size() > 0 )
                    {
                        ListaIscritti_RegioneRT          = ElaborateFileCsvPerArea('RT', MappaCompletaCheckbox.get('RT'));
                    }else{
                        ListaIscritti_RegioneRT          = ElaborateFileCsv('RT');
                    }
                    MapEmailAttachments.put('RT',TemplateMailsReturnObject(ListaIscritti_RegioneRT,'RT'));
                }
                    
                List<String> ToEmailLists = new List<String>();
                for( User Usr : ListaUsersAreaManager )
                {    
                        system.debug('(profile area manager) Usr.UserRole.Name '+ Usr.Name+' Usr.UserRole.Name->'+Usr.UserRole.Name);          
                        // Define the email
                        Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage(); 
                        email.setSenderDisplayName('Ivass Mail Report');
                        email.setSubject( subject ); 
                        email.setPlainTextBody( body );
                        if(( Usr.UserRole.Name == 'COORD. AREA 16' || Usr.UserRole.Name == 'COORD. AREA 17' || Usr.UserRole.Name == 'COORD. AREA 18' ||
                                    Usr.UserRole.Name == 'COORD. AREA 19' || Usr.UserRole.Name == 'COORD. AREA 20' )  && RA == 'true' && areaManagerInAreaSelezionata(Usr.UserRole.Name,'RA',MappaCompletaCheckbox))
                        {
                            system.debug('---COORD. AREA 16 ,17,18,18,20---');
                            email.setFileAttachments(new Messaging.EmailFileAttachment[]{ MapEmailAttachments.get('RA') });
                            List<String> sendTo = new List<String>();
                            sendTo.add(usr.Email);ToEmailLists.add(usr.Email);
                            email.setToAddresses(sendTo);
                            masterListMails.add(email);
                        }else if( ( Usr.UserRole.Name == 'COORD. AREA 11' || Usr.UserRole.Name == 'COORD. AREA 12' || Usr.UserRole.Name == 'COORD. AREA 13' ||
                                    Usr.UserRole.Name == 'COORD. AREA 14' || Usr.UserRole.Name == 'COORD. AREA 15' ) && RC == 'true' && areaManagerInAreaSelezionata(Usr.UserRole.Name,'RC',MappaCompletaCheckbox))
                        { 
                            system.debug('---COORD. AREA 11,12,13,14,15---');
                            email.setFileAttachments(new Messaging.EmailFileAttachment[]{ MapEmailAttachments.get('RC') });
                            List<String> sendTo = new List<String>();
                            sendTo.add(usr.Email);ToEmailLists.add(usr.Email);
                            email.setToAddresses(sendTo);
                            masterListMails.add(email);
                        }else if( ( Usr.UserRole.Name == 'COORD. AREA 6' || Usr.UserRole.Name == 'COORD. AREA 7' || Usr.UserRole.Name == 'COORD. AREA 8' ||
                                    Usr.UserRole.Name == 'COORD. AREA 9' || Usr.UserRole.Name == 'COORD. AREA 10' ) && RE == 'true' && areaManagerInAreaSelezionata(Usr.UserRole.Name,'RE',MappaCompletaCheckbox) )
                        {
                            system.debug('---Coord. AREA 6,7,8,9,10---');
                            email.setFileAttachments(new Messaging.EmailFileAttachment[]{ MapEmailAttachments.get('RE') });
                            List<String> sendTo = new List<String>();
                            sendTo.add(usr.Email);ToEmailLists.add(usr.Email);
                            email.setToAddresses(sendTo);
                            masterListMails.add(email);
                        }else if( ( Usr.UserRole.Name == 'COORD. AREA 1' || Usr.UserRole.Name == 'COORD. AREA 2' || Usr.UserRole.Name == 'COORD. AREA 3' ||
                                    Usr.UserRole.Name == 'COORD. AREA 4' || Usr.UserRole.Name == 'COORD. AREA 5' ) && RO == 'true' && areaManagerInAreaSelezionata(Usr.UserRole.Name,'RO',MappaCompletaCheckbox) )
                        {
                            system.debug('---Coord. AREA 1,2,3,4,5---');
                            email.setFileAttachments(new Messaging.EmailFileAttachment[]{ MapEmailAttachments.get('RO') });
                            List<String> sendTo = new List<String>();
                            sendTo.add(usr.Email);ToEmailLists.add(usr.Email);
                            email.setToAddresses(sendTo);
                            masterListMails.add(email);
                        }else if( ( Usr.UserRole.Name == 'COORD. AREA 26' || Usr.UserRole.Name == 'COORD. AREA 27' || Usr.UserRole.Name == 'COORD. AREA 28' ||
                                Usr.UserRole.Name == 'COORD. AREA 29' || Usr.UserRole.Name == 'COORD. AREA 30' ) && RS == 'true' && areaManagerInAreaSelezionata(Usr.UserRole.Name,'RS',MappaCompletaCheckbox))
                        {
                            system.debug('---Coord. AREA 26,27,28,29,30---');
                            email.setFileAttachments(new Messaging.EmailFileAttachment[]{ MapEmailAttachments.get('RS') });
                            List<String> sendTo = new List<String>();
                            sendTo.add(usr.Email);ToEmailLists.add(usr.Email);
                            email.setToAddresses(sendTo);
                            masterListMails.add(email);
                        }else if( ( Usr.UserRole.Name == 'COORD. AREA 21' || Usr.UserRole.Name == 'COORD. AREA 22' || Usr.UserRole.Name == 'COORD. AREA 23' ||
                                    Usr.UserRole.Name == 'COORD. AREA 24' || Usr.UserRole.Name == 'COORD. AREA 25' ) && RT == 'true'  && areaManagerInAreaSelezionata(Usr.UserRole.Name,'RT',MappaCompletaCheckbox) )
                        {
                            system.debug('---COORD. AREA 21,22,23,24,25---');
                            email.setFileAttachments(new Messaging.EmailFileAttachment[]{ MapEmailAttachments.get('RT') });
                            List<String> sendTo = new List<String>();
                            sendTo.add(usr.Email);ToEmailLists.add(usr.Email);
                            email.setToAddresses(sendTo);
                            masterListMails.add(email);
                        }
                }
            
                // Sends mass emails
                system.debug('masterListMails->'+masterListMails.size()+masterListMails+ToEmailLists);
                if( masterListMails != null && masterListMails.size() > 0 && !Test.isRunningTest() )
                {
                  EmailUtils.sendEmail(masterListMails,mockAddressIVASS);
                }
                
                
                
                
            }
        }
        //Caso Branch Manager
        masterListMails            = new List<Messaging.SingleEmailMessage>();
        if( BranchManagerFlag )
        {
            system.debug('BranchManagerFlag');
            List<String> listRoleName = new List<String>();
            for( User Usr : ListaUserBranchManager) {
                listRoleName.add(Usr.UserRole.Name);
            }              
            Map<String,String> mapFatherArea = getFather1Lev(listRoleName);

            if( ALLFalse == true )
            {
                system.debug('06_12_2019 BranchManager ALLFalse');

                //Invio Verso tutti i Branch Manager
                ListaIscritti_RegioneRA         = ElaborateFileCsv('RA');
                ListaIscritti_RegioneRC         = ElaborateFileCsv('RC');
                ListaIscritti_RegioneRE         = ElaborateFileCsv('RE');
                ListaIscritti_RegioneRO         = ElaborateFileCsv('RO');
                ListaIscritti_RegioneRS         = ElaborateFileCsv('RS');
                ListaIscritti_RegioneRT         = ElaborateFileCsv('RT');
                
                MapEmailAttachments.put('RA',TemplateMailsReturnObject(ListaIscritti_RegioneRA,'RA'));
                MapEmailAttachments.put('RC',TemplateMailsReturnObject(ListaIscritti_RegioneRC,'RC'));
                MapEmailAttachments.put('RE',TemplateMailsReturnObject(ListaIscritti_RegioneRE,'RE'));
                MapEmailAttachments.put('RO',TemplateMailsReturnObject(ListaIscritti_RegioneRO,'RO'));
                MapEmailAttachments.put('RS',TemplateMailsReturnObject(ListaIscritti_RegioneRS,'RS'));
                MapEmailAttachments.put('RT',TemplateMailsReturnObject(ListaIscritti_RegioneRT,'RT'));
                
                for( User Usr : ListaUserBranchManager )
                {
                        String fatherArea = mapFatherArea.get(Usr.UserRole.Name)==null?'': mapFatherArea.get(Usr.UserRole.Name);
                        system.debug('(profile branch manager) Usr.Name '+ Usr.Name+' Usr.UserRole.Name->'+Usr.UserRole.Name+' Usr.UserRoleId:'+Usr.UserRoleId+' fatherArea:'+fatherArea);              

                        Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage(); 
                        email.setSenderDisplayName('Ivass Mail Report');
                        email.setSubject( subject ); 
                        email.setPlainTextBody( body );
                        if( fatherArea == 'COORD. AREA 16' || fatherArea == 'COORD. AREA 17' || fatherArea == 'COORD. AREA 18' ||
                            fatherArea == 'COORD. AREA 19' || fatherArea == 'COORD. AREA 20')
                        {
                            email.setFileAttachments(new Messaging.EmailFileAttachment[]{ MapEmailAttachments.get('RA') });
                            List<String> sendTo = new List<String>();
                            sendTo.add(usr.Email);
                            email.setToAddresses(sendTo);
                            masterListMails.add(email);
                        }else if( fatherArea == 'COORD. AREA 11' || fatherArea == 'COORD. AREA 12' || fatherArea == 'COORD. AREA 13' ||
                               fatherArea == 'COORD. AREA 14' || fatherArea == 'COORD. AREA 15')
                        {
                            email.setFileAttachments(new Messaging.EmailFileAttachment[]{ MapEmailAttachments.get('RC') });
                            List<String> sendTo = new List<String>();
                            sendTo.add(usr.Email);
                            email.setToAddresses(sendTo);
                            masterListMails.add(email);
                        }else if( fatherArea == 'COORD. AREA 6' || fatherArea == 'COORD. AREA 7' || fatherArea == 'COORD. AREA 8' ||
                               fatherArea == 'COORD. AREA 9' || fatherArea == 'COORD. AREA 10')
                        {
                            email.setFileAttachments(new Messaging.EmailFileAttachment[]{ MapEmailAttachments.get('RE') });
                            List<String> sendTo = new List<String>();
                            sendTo.add(usr.Email);
                            email.setToAddresses(sendTo);
                            masterListMails.add(email);
                        }else if( fatherArea == 'COORD. AREA 1' || fatherArea == 'COORD. AREA 2' ||fatherArea == 'COORD. AREA 3' ||
                                fatherArea == 'COORD. AREA 4' || fatherArea == 'COORD. AREA 5')
                        {
                            email.setFileAttachments(new Messaging.EmailFileAttachment[]{ MapEmailAttachments.get('RO') });
                            List<String> sendTo = new List<String>();
                            sendTo.add(usr.Email);
                            email.setToAddresses(sendTo);
                            masterListMails.add(email);
                        }else if( fatherArea == 'COORD. AREA 26' || fatherArea == 'COORD. AREA 27' ||fatherArea == 'COORD. AREA 28' ||
                                fatherArea == 'COORD. AREA 29' || fatherArea == 'COORD. AREA 30' )
                        {
                            email.setFileAttachments(new Messaging.EmailFileAttachment[]{ MapEmailAttachments.get('RS') });
                            List<String> sendTo = new List<String>();
                            sendTo.add(usr.Email);
                            email.setToAddresses(sendTo);
                            masterListMails.add(email);
                        }else if( fatherArea == 'COORD. AREA 21' || fatherArea == 'COORD. AREA 22' ||fatherArea == 'COORD. AREA 23' ||
                                fatherArea == 'COORD. AREA 24' || fatherArea == 'COORD. AREA 25' )
                        {
                            email.setFileAttachments(new Messaging.EmailFileAttachment[]{ MapEmailAttachments.get('RT') });
                            List<String> sendTo = new List<String>();
                            sendTo.add(usr.Email);
                            email.setToAddresses(sendTo);
                            masterListMails.add(email);
                        }
                        // Add your email address into the master list
                    }
                
                    // Sends mass emails
                system.debug('masterListMails->'+masterListMails.size());
                if( masterListMails != null && masterListMails.size() > 0 && !Test.isRunningTest() )
                {
                   EmailUtils.sendEmail(masterListMails,mockAddressIVASS);
                }

            }
            else{
                system.debug('06_12_2019 Branch Manager !ALLFalse');
                //Invio Verso alcuni branch manager
                if( RA == 'true' )
                {
                    if( MappaCompletaCheckbox.get('RA') != null && MappaCompletaCheckbox.get('RA').size() > 0 )
                    {
                        ListaIscritti_RegioneRA         = ElaborateFileCsvPerArea('RA', MappaCompletaCheckbox.get('RA'),mapFiliali);
                    }else{
                        ListaIscritti_RegioneRA         = ElaborateFileCsv('RA');
                    }
                    MapEmailAttachments.put('RA',TemplateMailsReturnObject(ListaIscritti_RegioneRA,'RA'));
                }
                if( RC == 'true' )
                {
                    if( MappaCompletaCheckbox.get('RC') != null && MappaCompletaCheckbox.get('RC').size() > 0 )
                    {
                        ListaIscritti_RegioneRC         = ElaborateFileCsvPerArea('RC', MappaCompletaCheckbox.get('RC'),mapFiliali);//ElaborateFileCsv('RC');
                    }else{
                        ListaIscritti_RegioneRC         = ElaborateFileCsv('RC');
                    }
                    MapEmailAttachments.put('RC',TemplateMailsReturnObject(ListaIscritti_RegioneRC,'RC'));
                }
                if( RE == 'true' )
                {
                    if( MappaCompletaCheckbox.get('RE') != null && MappaCompletaCheckbox.get('RE').size() > 0 )
                    {
                        ListaIscritti_RegioneRE         = ElaborateFileCsvPerArea('RE', MappaCompletaCheckbox.get('RE'),mapFiliali);
                    }else{
                        ListaIscritti_RegioneRE         = ElaborateFileCsv('RE');
                    }
                    MapEmailAttachments.put('RE',TemplateMailsReturnObject(ListaIscritti_RegioneRE,'RE'));
                } 
                if( RO == 'true' )
                {
                    if( MappaCompletaCheckbox.get('RO') != null && MappaCompletaCheckbox.get('RO').size() > 0 )
                    {
                        ListaIscritti_RegioneRO         = ElaborateFileCsvPerArea('RO', MappaCompletaCheckbox.get('RO'),mapFiliali);
                    }else{
                        ListaIscritti_RegioneRO         = ElaborateFileCsv('RO');
                    }
                    MapEmailAttachments.put('RO',TemplateMailsReturnObject(ListaIscritti_RegioneRO,'RO'));
                }
                if( RS == 'true' )
                {
                    if( MappaCompletaCheckbox.get('RS') != null && MappaCompletaCheckbox.get('RS').size() > 0 )
                    {
                        ListaIscritti_RegioneRS         = ElaborateFileCsvPerArea('RS', MappaCompletaCheckbox.get('RS'),mapFiliali);
                    }else{
                        ListaIscritti_RegioneRS         = ElaborateFileCsv('RS');
                    }
                    MapEmailAttachments.put('RS',TemplateMailsReturnObject(ListaIscritti_RegioneRS,'RS'));
                }
                if( RT == 'true' )
                {
                    if( MappaCompletaCheckbox.get('RT') != null && MappaCompletaCheckbox.get('RT').size() > 0 )
                    {
                        ListaIscritti_RegioneRT         = ElaborateFileCsvPerArea('RT', MappaCompletaCheckbox.get('RT'),mapFiliali);
                    }else{
                        ListaIscritti_RegioneRT         = ElaborateFileCsv('RT');
                    }
                    MapEmailAttachments.put('RT',TemplateMailsReturnObject(ListaIscritti_RegioneRT,'RT'));
                }
                    
                List<String> ToEmailLists = new List<String>();
                for( User Usr : ListaUserBranchManager )
                {    
                        String fatherArea = mapFatherArea.get(Usr.UserRole.Name)==null?'': mapFatherArea.get(Usr.UserRole.Name);
                        system.debug('(profile branch manager) Usr.Name '+ Usr.Name+' Usr.UserRole.Name->'+Usr.UserRole.Name+' Usr.UserRoleId:'+Usr.UserRoleId+' fatherArea:'+fatherArea);              
                        // Define the email
                        Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage(); 
                        email.setSenderDisplayName('Ivass Mail Report');
                        email.setSubject( subject ); 
                        email.setPlainTextBody( body );
                        if( RA == 'true' && userAppartenenteAdArea(fatherArea,'RA',MappaCompletaCheckbox) && userAppartenenteAFiliale(fatherArea,Usr.UserRoleId,'RA',mapFiliali,MappaCompletaCheckbox))
                        {
                            system.debug('---COORD.AREA 16,17,18,19,20---');
                            email.setFileAttachments(new Messaging.EmailFileAttachment[]{ MapEmailAttachments.get('RA') });
                            List<String> sendTo = new List<String>();
                            sendTo.add(usr.Email);ToEmailLists.add(usr.Email);
                            email.setToAddresses(sendTo);
                            masterListMails.add(email);
                        }else if( RC == 'true' && userAppartenenteAdArea(fatherArea,'RC',MappaCompletaCheckbox) && userAppartenenteAFiliale(fatherArea,Usr.UserRoleId,'RC',mapFiliali,MappaCompletaCheckbox))
                        { 
                            system.debug('---COORD.AREA 11,12,13,14,15---');
                            email.setFileAttachments(new Messaging.EmailFileAttachment[]{ MapEmailAttachments.get('RC') });
                            List<String> sendTo = new List<String>();
                            sendTo.add(usr.Email);ToEmailLists.add(usr.Email);
                            email.setToAddresses(sendTo);
                            masterListMails.add(email);
                        }else if(RE == 'true' && userAppartenenteAdArea(fatherArea,'RE',MappaCompletaCheckbox) && userAppartenenteAFiliale(fatherArea,Usr.UserRoleId,'RE',mapFiliali,MappaCompletaCheckbox))
                        {
                            system.debug('---COORD.AREA 6,7,8,9,10---');
                            email.setFileAttachments(new Messaging.EmailFileAttachment[]{ MapEmailAttachments.get('RE') });
                            List<String> sendTo = new List<String>();
                            sendTo.add(usr.Email);ToEmailLists.add(usr.Email);
                            email.setToAddresses(sendTo);
                            masterListMails.add(email);
                        }else if(RO == 'true' && userAppartenenteAdArea(fatherArea,'RO',MappaCompletaCheckbox) && userAppartenenteAFiliale(fatherArea,Usr.UserRoleId,'RO',mapFiliali,MappaCompletaCheckbox))
                        {
                            system.debug('---COORD.AREA 1,2,3,4,5---');
                            email.setFileAttachments(new Messaging.EmailFileAttachment[]{ MapEmailAttachments.get('RO') });
                            List<String> sendTo = new List<String>();
                            sendTo.add(usr.Email);ToEmailLists.add(usr.Email);
                            email.setToAddresses(sendTo);
                            masterListMails.add(email);
                        }else if(RS == 'true' && userAppartenenteAdArea(fatherArea,'RS',MappaCompletaCheckbox) && userAppartenenteAFiliale(fatherArea,Usr.UserRoleId,'RS',mapFiliali,MappaCompletaCheckbox))
                        {
                            system.debug('---COORD.AREA 26,27,28,29,30---');
                            email.setFileAttachments(new Messaging.EmailFileAttachment[]{ MapEmailAttachments.get('RS') });
                            List<String> sendTo = new List<String>();
                            sendTo.add(usr.Email);ToEmailLists.add(usr.Email);
                            email.setToAddresses(sendTo);
                            masterListMails.add(email);
                        }else if(RT == 'true' && userAppartenenteAdArea(fatherArea,'RT',MappaCompletaCheckbox) && userAppartenenteAFiliale(fatherArea,Usr.UserRoleId,'RT',mapFiliali,MappaCompletaCheckbox))
                        {
                            system.debug('---COORD.AREA 21,22,23,24,25---');
                            email.setFileAttachments(new Messaging.EmailFileAttachment[]{ MapEmailAttachments.get('RT') });
                            List<String> sendTo = new List<String>();
                            sendTo.add(usr.Email);ToEmailLists.add(usr.Email);
                            email.setToAddresses(sendTo);
                            masterListMails.add(email);
                        }
                }
            
                // Sends mass emails
                system.debug('masterListMails->'+masterListMails.size()+masterListMails+ToEmailLists);
                if( masterListMails != null && masterListMails.size() > 0 && !Test.isRunningTest() )
                {
                  EmailUtils.sendEmail(masterListMails,mockAddressIVASS);
                }

            }
        }
            
        //Caso Branch Employer (Dotti 7-1-2020)
        masterListMails            = new List<Messaging.SingleEmailMessage>();
        if( BranchEmployerFlag ) {
                system.debug('Caso Branch Employer');
                List<String> listRoleName = new List<String>();
                for( User Usr : ListaUserBranchEmployer ) {
                    listRoleName.add(Usr.UserRole.Name);
                }
            if( ALLFalse == true )
            {
                Map<String,String> mapFatherRole = getFatherRole(listRoleName);
                system.debug('Branch Employer: Invio Verso tutti i Branch Employer');
                //Invio Verso tutti i Branch Employer
                ListaIscritti_RegioneRA         = ElaborateFileCsv('RA');
                ListaIscritti_RegioneRC         = ElaborateFileCsv('RC');
                ListaIscritti_RegioneRE         = ElaborateFileCsv('RE');
                ListaIscritti_RegioneRO         = ElaborateFileCsv('RO');
                ListaIscritti_RegioneRS         = ElaborateFileCsv('RS');
                ListaIscritti_RegioneRT         = ElaborateFileCsv('RT');
                
                MapEmailAttachments.put('RA',TemplateMailsReturnObject(ListaIscritti_RegioneRA,'RA'));
                MapEmailAttachments.put('RC',TemplateMailsReturnObject(ListaIscritti_RegioneRC,'RC'));
                MapEmailAttachments.put('RE',TemplateMailsReturnObject(ListaIscritti_RegioneRE,'RE'));
                MapEmailAttachments.put('RO',TemplateMailsReturnObject(ListaIscritti_RegioneRO,'RO'));
                MapEmailAttachments.put('RS',TemplateMailsReturnObject(ListaIscritti_RegioneRS,'RS'));
                MapEmailAttachments.put('RT',TemplateMailsReturnObject(ListaIscritti_RegioneRT,'RT'));
                for( User Usr : ListaUserBranchEmployer )
                {  
                        String fatherRole = mapFatherRole.get(Usr.UserRole.Name)==null?'': mapFatherRole.get(Usr.UserRole.Name);
                        Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage(); 
                        email.setSenderDisplayName('Ivass Mail Report');
                        email.setSubject( subject ); 
                        email.setPlainTextBody( body );
                        system.debug('(profile branch employee) Usr.Name '+ Usr.Name+' Usr.UserRole.Name->'+Usr.UserRole.Name+ ' father Role: '+fatherRole);    

                        if(fatherRole == 'REGIONE ADRIATICA')
                        {
                            email.setFileAttachments(new Messaging.EmailFileAttachment[]{ MapEmailAttachments.get('RA') });
                            List<String> sendTo = new List<String>();
                            sendTo.add(usr.Email);
                            email.setToAddresses(sendTo);
                            masterListMails.add(email);
                        }else if(fatherRole == 'REGIONE CENTRO' )
                        {
                            email.setFileAttachments(new Messaging.EmailFileAttachment[]{ MapEmailAttachments.get('RC') });
                            List<String> sendTo = new List<String>();
                            sendTo.add(usr.Email);
                            email.setToAddresses(sendTo);
                            masterListMails.add(email);
                        }else if( fatherRole == 'REGIONE NORD EST' )
                        {
                            email.setFileAttachments(new Messaging.EmailFileAttachment[]{ MapEmailAttachments.get('RE') });
                            List<String> sendTo = new List<String>();
                            sendTo.add(usr.Email);
                            email.setToAddresses(sendTo);
                            masterListMails.add(email);
                        }else if( fatherRole == 'REGIONE NORD OVEST' )
                        {
                            email.setFileAttachments(new Messaging.EmailFileAttachment[]{ MapEmailAttachments.get('RO') });
                            List<String> sendTo = new List<String>();
                            sendTo.add(usr.Email);
                            email.setToAddresses(sendTo);
                            masterListMails.add(email);
                        }else if( fatherRole == 'REGIONE SUD' )
                        {
                            email.setFileAttachments(new Messaging.EmailFileAttachment[]{ MapEmailAttachments.get('RS') });
                            List<String> sendTo = new List<String>();
                            sendTo.add(usr.Email);
                            email.setToAddresses(sendTo);
                            masterListMails.add(email);
                        }else if( fatherRole == 'REGIONE TIRRENICA')
                        {
                            email.setFileAttachments(new Messaging.EmailFileAttachment[]{ MapEmailAttachments.get('RT') });
                            List<String> sendTo = new List<String>();
                            sendTo.add(usr.Email);
                            email.setToAddresses(sendTo);				    
                            masterListMails.add(email);
                        }
                        // Add your email address into the master list
                    }
            
                // Sends mass emails
                if( masterListMails != null && masterListMails.size() > 0 && !Test.isRunningTest() )
                {
                  EmailUtils.sendEmail(masterListMails,mockAddressIVASS);
                }
            
            }
            else{

                Map<String,String> mapFatherArea = getFatherArea(listRoleName);
                if( RA == 'true' )
                {
                    if( MappaCompletaCheckbox.get('RA') != null && MappaCompletaCheckbox.get('RA').size() > 0 )
                    {
                        ListaIscritti_RegioneRA        = ElaborateFileCsvPerArea('RA', MappaCompletaCheckbox.get('RA'),mapFiliali);
                    }else{
                        ListaIscritti_RegioneRA         = ElaborateFileCsv('RA');
                    }
                    MapEmailAttachments.put('RA',TemplateMailsReturnObject(ListaIscritti_RegioneRA,'RA'));
                }
                if( RC == 'true' )
                {  
                    if( MappaCompletaCheckbox.get('RC') != null && MappaCompletaCheckbox.get('RC').size() > 0 )
                    {
                        ListaIscritti_RegioneRC     = ElaborateFileCsvPerArea('RC', MappaCompletaCheckbox.get('RC'),mapFiliali);
                    }else{
                        ListaIscritti_RegioneRC         = ElaborateFileCsv('RC');
                    }
                    MapEmailAttachments.put('RC',TemplateMailsReturnObject(ListaIscritti_RegioneRC,'RC'));
                }
                if( RE == 'true' )
                {
                    if( MappaCompletaCheckbox.get('RE') != null && MappaCompletaCheckbox.get('RE').size() > 0 )
                    {
                        ListaIscritti_RegioneRE         = ElaborateFileCsvPerArea('RE',  MappaCompletaCheckbox.get('RE'),mapFiliali); 
                    }else{
                        ListaIscritti_RegioneRE         = ElaborateFileCsv('RE');
                    }
                    MapEmailAttachments.put('RE',TemplateMailsReturnObject(ListaIscritti_RegioneRE,'RE'));
                }
                if( RO == 'true' )
                {
                    if( MappaCompletaCheckbox.get('RO') != null && MappaCompletaCheckbox.get('RO').size() > 0 )
                    {
                        ListaIscritti_RegioneRO         = ElaborateFileCsvPerArea('RO', MappaCompletaCheckbox.get('RO'),mapFiliali);
                    }else{
                        ListaIscritti_RegioneRO         = ElaborateFileCsv('RO');
                    }
                    MapEmailAttachments.put('RO',TemplateMailsReturnObject(ListaIscritti_RegioneRO,'RO'));
                }
                if( RS == 'true' )
                {
                    if( MappaCompletaCheckbox.get('RS') != null && MappaCompletaCheckbox.get('RS').size() > 0 )
                    {
                        ListaIscritti_RegioneRS         = ElaborateFileCsvPerArea('RS', MappaCompletaCheckbox.get('RS'),mapFiliali);
                    }else{
                        ListaIscritti_RegioneRS         = ElaborateFileCsv('RS');
                    }
                    MapEmailAttachments.put('RS',TemplateMailsReturnObject(ListaIscritti_RegioneRS,'RS'));
                }
                if( RT == 'true' )
                {
                    if( MappaCompletaCheckbox.get('RT') != null && MappaCompletaCheckbox.get('RT').size() > 0 )
                    {
                        ListaIscritti_RegioneRT         = ElaborateFileCsvPerArea('RT', MappaCompletaCheckbox.get('RT'),mapFiliali);
                    }else{
                        ListaIscritti_RegioneRT         = ElaborateFileCsv('RT');
                    }
                    MapEmailAttachments.put('RT',TemplateMailsReturnObject(ListaIscritti_RegioneRT,'RT'));
                }
                
                for( User Usr : ListaUserBranchEmployer )
                {    
                    
                        String fatherArea = mapFatherArea.get(Usr.UserRole.Name)==null?'': mapFatherArea.get(Usr.UserRole.Name);
                        // Define the email
                        Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage(); 
                        email.setSenderDisplayName('Ivass Mail Report');
                        email.setSubject( subject ); 
                        email.setPlainTextBody( body );
                        system.debug('(profile branch employee) Usr.UserRole.Name '+ Usr.Name+' Usr.UserRole.Name->'+Usr.UserRole.Name+ ' Usr.UserRole.ParentRoleId:'+Usr.UserRole.ParentRoleId+' fatherArea: '+fatherArea);    
                        if(RA == 'true'  && userAppartenenteAdArea(fatherArea,'RA',MappaCompletaCheckbox) && userAppartenenteAFiliale(fatherArea,Usr.UserRole.ParentRoleId,'RA',mapFiliali,MappaCompletaCheckbox))
                        {
                            system.debug('fatherArea:'+fatherArea);
                            email.setFileAttachments(new Messaging.EmailFileAttachment[]{ MapEmailAttachments.get('RA') });
                            List<String> sendTo = new List<String>();
                            sendTo.add(usr.Email);
                            email.setToAddresses(sendTo);
                            masterListMails.add(email);
                        }else if(RC == 'true' && userAppartenenteAdArea(fatherArea,'RC',MappaCompletaCheckbox) && userAppartenenteAFiliale(fatherArea,Usr.UserRole.ParentRoleId,'RC',mapFiliali,MappaCompletaCheckbox))
                        { 
                            system.debug('fatherArea:'+fatherArea);
                            email.setFileAttachments(new Messaging.EmailFileAttachment[]{ MapEmailAttachments.get('RC') });
                            List<String> sendTo = new List<String>();
                            sendTo.add(usr.Email);
                            email.setToAddresses(sendTo);
                            masterListMails.add(email);
                        }else if(RE == 'true' && userAppartenenteAdArea(fatherArea,'RE',MappaCompletaCheckbox) && userAppartenenteAFiliale(fatherArea,Usr.UserRole.ParentRoleId,'RE',mapFiliali,MappaCompletaCheckbox))
                        {
                            system.debug('fatherArea:'+fatherArea);
                            email.setFileAttachments(new Messaging.EmailFileAttachment[]{ MapEmailAttachments.get('RE') });
                            List<String> sendTo = new List<String>();
                            sendTo.add(usr.Email);
                            email.setToAddresses(sendTo);
                            masterListMails.add(email);
                        }else if(RO == 'true' && userAppartenenteAdArea(fatherArea,'RO',MappaCompletaCheckbox) && userAppartenenteAFiliale(fatherArea,Usr.UserRole.ParentRoleId,'RO',mapFiliali,MappaCompletaCheckbox))
                        {
                            system.debug('fatherArea:'+fatherArea);
                            email.setFileAttachments(new Messaging.EmailFileAttachment[]{ MapEmailAttachments.get('RO') });
                            List<String> sendTo = new List<String>();
                            sendTo.add(usr.Email);
                            email.setToAddresses(sendTo);
                            masterListMails.add(email);
                        }else if(RS == 'true' && userAppartenenteAdArea(fatherArea,'RS',MappaCompletaCheckbox) && userAppartenenteAFiliale(fatherArea,Usr.UserRole.ParentRoleId,'RS',mapFiliali,MappaCompletaCheckbox))
                        {
                            system.debug('fatherArea:'+fatherArea);
                            email.setFileAttachments(new Messaging.EmailFileAttachment[]{ MapEmailAttachments.get('RS') });
                            List<String> sendTo = new List<String>();
                            sendTo.add(usr.Email);
                            email.setToAddresses(sendTo);
                            masterListMails.add(email);
                        }else if(RT == 'true' && userAppartenenteAdArea(fatherArea,'RT',MappaCompletaCheckbox) && userAppartenenteAFiliale(fatherArea,Usr.UserRole.ParentRoleId,'RT',mapFiliali,MappaCompletaCheckbox))
                        {
                            system.debug('fatherArea:'+fatherArea);
                            email.setFileAttachments(new Messaging.EmailFileAttachment[]{ MapEmailAttachments.get('RT') });
                            List<String> sendTo = new List<String>();
                            sendTo.add(usr.Email);
                            email.setToAddresses(sendTo);
                            masterListMails.add(email);
                        }
                }
            
                // Sends mass emails
                system.debug('masterListMails->'+masterListMails.size());
                if( masterListMails != null && masterListMails.size() > 0 && !Test.isRunningTest() )
                {
                    EmailUtils.sendEmail(masterListMails,mockAddressIVASS);
                }
            } 
        }
        //Caso Borg (Dotti 20-1-2020)
        masterListMails            = new List<Messaging.SingleEmailMessage>();
        if( Borg ) {
            system.debug('Caso Borg');
            List<String> listRoleName = new List<String>();
            List<String> listUserRoleParent = new List<String>();
            for( User Usr : ListaBorg ) {
                listRoleName.add(Usr.UserRole.Name);
                listUserRoleParent.add(Usr.UserRole.ParentRoleId);
            }
            if( ALLFalse == true )
            {
                Map<String,String> mapFatheAreaBorg = getFatherAreaBorg(listRoleName);
                system.debug('Borg: Invio Verso tutti i Borg');
                //Invio Verso tutti i Borg
                ListaIscritti_RegioneRA         = ElaborateFileCsv('RA');
                ListaIscritti_RegioneRC         = ElaborateFileCsv('RC');
                ListaIscritti_RegioneRE         = ElaborateFileCsv('RE');
                ListaIscritti_RegioneRO         = ElaborateFileCsv('RO');
                ListaIscritti_RegioneRS         = ElaborateFileCsv('RS');
                ListaIscritti_RegioneRT         = ElaborateFileCsv('RT');
                
                MapEmailAttachments.put('RA',TemplateMailsReturnObject(ListaIscritti_RegioneRA,'RA'));
                MapEmailAttachments.put('RC',TemplateMailsReturnObject(ListaIscritti_RegioneRC,'RC'));
                MapEmailAttachments.put('RE',TemplateMailsReturnObject(ListaIscritti_RegioneRE,'RE'));
                MapEmailAttachments.put('RO',TemplateMailsReturnObject(ListaIscritti_RegioneRO,'RO'));
                MapEmailAttachments.put('RS',TemplateMailsReturnObject(ListaIscritti_RegioneRS,'RS'));
                MapEmailAttachments.put('RT',TemplateMailsReturnObject(ListaIscritti_RegioneRT,'RT'));
                for( User Usr : ListaBorg )
                {  
                        String fatherArea = mapFatheAreaBorg.get(Usr.UserRole.Name)==null?'': mapFatheAreaBorg.get(Usr.UserRole.Name);
                        Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage(); 
                        email.setSenderDisplayName('Ivass Mail Report');
                        email.setSubject( subject ); 
                        email.setPlainTextBody( body );
                        system.debug('(profile Borg) Usr.Name '+ Usr.Name+' Usr.UserRole.Name->'+Usr.UserRole.Name+ ' fatherArea: '+fatherArea);    

                        if(borgAppartieneARegione(fatherArea,'RA'))
                        {
                            email.setFileAttachments(new Messaging.EmailFileAttachment[]{ MapEmailAttachments.get('RA') });
                            List<String> sendTo = new List<String>();
                            sendTo.add(usr.Email);
                            email.setToAddresses(sendTo);
                            masterListMails.add(email);
                            system.debug('invio tutti borg attachment RA  fatherArea:'+fatherArea);
                        }else if(borgAppartieneARegione(fatherArea,'RC') )
                        {
                            email.setFileAttachments(new Messaging.EmailFileAttachment[]{ MapEmailAttachments.get('RC') });
                            List<String> sendTo = new List<String>();
                            sendTo.add(usr.Email);
                            email.setToAddresses(sendTo);
                            masterListMails.add(email);
                            system.debug('invio tutti borg attachment RC fatherArea:'+fatherArea);
                        }else if(borgAppartieneARegione(fatherArea,'RE'))
                        {
                            email.setFileAttachments(new Messaging.EmailFileAttachment[]{ MapEmailAttachments.get('RE') });
                            List<String> sendTo = new List<String>();
                            sendTo.add(usr.Email);
                            email.setToAddresses(sendTo);
                            masterListMails.add(email);
                             system.debug('invio tutti borg attachment RE  fatherArea:'+fatherArea);
                        }else if(borgAppartieneARegione(fatherArea,'RO'))
                        {
                            email.setFileAttachments(new Messaging.EmailFileAttachment[]{ MapEmailAttachments.get('RO') });
                            List<String> sendTo = new List<String>();
                            sendTo.add(usr.Email);
                            email.setToAddresses(sendTo);
                            masterListMails.add(email);
                            system.debug('invio tutti borg attachment RO fatherArea:'+fatherArea);
                        }else if(borgAppartieneARegione(fatherArea,'RS'))
                        {
                            email.setFileAttachments(new Messaging.EmailFileAttachment[]{ MapEmailAttachments.get('RS') });
                            List<String> sendTo = new List<String>();
                            sendTo.add(usr.Email);
                            email.setToAddresses(sendTo);
                            masterListMails.add(email);
                            system.debug('invio tutti borg attachment RS fatherArea:'+fatherArea);
                        }else if(borgAppartieneARegione(fatherArea,'RT'))
                        {
                            email.setFileAttachments(new Messaging.EmailFileAttachment[]{ MapEmailAttachments.get('RT') });
                            List<String> sendTo = new List<String>();
                            sendTo.add(usr.Email);
                            email.setToAddresses(sendTo);				    
                            masterListMails.add(email);
                            system.debug('invio tutti borg attachment RT fatherArea:'+fatherArea);
                        }
                        // Add your email address into the master list
                    }
            
                // Sends mass emails
                if( masterListMails != null && masterListMails.size() > 0 && !Test.isRunningTest() )
                {
                  EmailUtils.sendEmail(masterListMails,mockAddressIVASS);
                }
            
            }
            else{
                // invio verso alcuni borg
                Map<String,String> mapFatherArea = getFatherAreaBorg(listRoleName);
                Map<String,String> mapFatherBorgUserRoleFiliale = getFatherBorgUserRoleFiliale(listUserRoleParent);
                if( RA == 'true' )
                {
                    if( MappaCompletaCheckbox.get('RA') != null && MappaCompletaCheckbox.get('RA').size() > 0 )
                    {
                        ListaIscritti_RegioneRA        = ElaborateFileCsvPerArea('RA', MappaCompletaCheckbox.get('RA'),mapFiliali);
                    }else{
                        ListaIscritti_RegioneRA         = ElaborateFileCsv('RA');
                    }
                    MapEmailAttachments.put('RA',TemplateMailsReturnObject(ListaIscritti_RegioneRA,'RA'));
                }
                if( RC == 'true' )
                {  
                    if( MappaCompletaCheckbox.get('RC') != null && MappaCompletaCheckbox.get('RC').size() > 0 )
                    {
                        ListaIscritti_RegioneRC     = ElaborateFileCsvPerArea('RC', MappaCompletaCheckbox.get('RC'),mapFiliali);
                    }else{
                        ListaIscritti_RegioneRC         = ElaborateFileCsv('RC');
                    }
                    MapEmailAttachments.put('RC',TemplateMailsReturnObject(ListaIscritti_RegioneRC,'RC'));
                }
                if( RE == 'true' )
                {
                    if( MappaCompletaCheckbox.get('RE') != null && MappaCompletaCheckbox.get('RE').size() > 0 )
                    {
                        ListaIscritti_RegioneRE         = ElaborateFileCsvPerArea('RE',  MappaCompletaCheckbox.get('RE'),mapFiliali); 
                    }else{
                        ListaIscritti_RegioneRE         = ElaborateFileCsv('RE');
                    }
                    MapEmailAttachments.put('RE',TemplateMailsReturnObject(ListaIscritti_RegioneRE,'RE'));
                }
                if( RO == 'true' )
                {
                    if( MappaCompletaCheckbox.get('RO') != null && MappaCompletaCheckbox.get('RO').size() > 0 )
                    {
                        ListaIscritti_RegioneRO         = ElaborateFileCsvPerArea('RO', MappaCompletaCheckbox.get('RO'),mapFiliali);
                    }else{
                        ListaIscritti_RegioneRO         = ElaborateFileCsv('RO');
                    }
                    MapEmailAttachments.put('RO',TemplateMailsReturnObject(ListaIscritti_RegioneRO,'RO'));
                }
                if( RS == 'true' )
                {
                    if( MappaCompletaCheckbox.get('RS') != null && MappaCompletaCheckbox.get('RS').size() > 0 )
                    {
                        ListaIscritti_RegioneRS         = ElaborateFileCsvPerArea('RS', MappaCompletaCheckbox.get('RS'),mapFiliali);
                    }else{
                        ListaIscritti_RegioneRS         = ElaborateFileCsv('RS');
                    }
                    MapEmailAttachments.put('RS',TemplateMailsReturnObject(ListaIscritti_RegioneRS,'RS'));
                }
                if( RT == 'true' )
                {
                    if( MappaCompletaCheckbox.get('RT') != null && MappaCompletaCheckbox.get('RT').size() > 0 )
                    {
                        ListaIscritti_RegioneRT         = ElaborateFileCsvPerArea('RT', MappaCompletaCheckbox.get('RT'),mapFiliali);
                    }else{
                        ListaIscritti_RegioneRT         = ElaborateFileCsv('RT');
                    }
                    MapEmailAttachments.put('RT',TemplateMailsReturnObject(ListaIscritti_RegioneRT,'RT'));
                }
                
                for( User Usr : ListaBorg )
                {    
                    
                        String fatherArea = mapFatherArea.get(Usr.UserRole.Name)==null?'': mapFatherArea.get(Usr.UserRole.Name);
                        String filialeUserRoleBorg = mapFatherBorgUserRoleFiliale.get(Usr.UserRole.ParentRoleId)==null?'': mapFatherBorgUserRoleFiliale.get(Usr.UserRole.ParentRoleId);
                        // Define the email
                        Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage(); 
                        email.setSenderDisplayName('Ivass Mail Report');
                        email.setSubject( subject ); 
                        email.setPlainTextBody( body );
                        system.debug('(profile borg) Usr.UserRole.Name '+ Usr.Name+' Usr.UserRole.Name->'+Usr.UserRole.Name+ ' Usr.UserRole.ParentRoleId:'+Usr.UserRole.ParentRoleId+' fatherArea: '+fatherArea+ ' filialeUserRoleBorg:'+filialeUserRoleBorg);    

                        if(RA == 'true'  && userAppartenenteAdArea(fatherArea,'RA',MappaCompletaCheckbox) && userAppartenenteAFiliale(fatherArea,filialeUserRoleBorg,'RA',mapFiliali,MappaCompletaCheckbox))
                        {
                            system.debug('BORG invio email fatherArea:'+fatherArea);
                            email.setFileAttachments(new Messaging.EmailFileAttachment[]{ MapEmailAttachments.get('RA') });
                            List<String> sendTo = new List<String>();
                            sendTo.add(usr.Email);
                            email.setToAddresses(sendTo);
                            masterListMails.add(email);
                        }else if(RC == 'true' && userAppartenenteAdArea(fatherArea,'RC',MappaCompletaCheckbox) && userAppartenenteAFiliale(fatherArea,filialeUserRoleBorg,'RC',mapFiliali,MappaCompletaCheckbox))
                        { 
                            system.debug('BORG invio email fatherArea:'+fatherArea);
                            email.setFileAttachments(new Messaging.EmailFileAttachment[]{ MapEmailAttachments.get('RC') });
                            List<String> sendTo = new List<String>();
                            sendTo.add(usr.Email);
                            email.setToAddresses(sendTo);
                            masterListMails.add(email);
                        }else if(RE == 'true' && userAppartenenteAdArea(fatherArea,'RE',MappaCompletaCheckbox) && userAppartenenteAFiliale(fatherArea,filialeUserRoleBorg,'RE',mapFiliali,MappaCompletaCheckbox))
                        {
                            system.debug('BORG invio email fatherArea:'+fatherArea);
                            email.setFileAttachments(new Messaging.EmailFileAttachment[]{ MapEmailAttachments.get('RE') });
                            List<String> sendTo = new List<String>();
                            sendTo.add(usr.Email);
                            email.setToAddresses(sendTo);
                            masterListMails.add(email);
                        }else if(RO == 'true' && userAppartenenteAdArea(fatherArea,'RO',MappaCompletaCheckbox) && userAppartenenteAFiliale(fatherArea,filialeUserRoleBorg,'RO',mapFiliali,MappaCompletaCheckbox))
                        {
                            system.debug('BORG invio email fatherArea:'+fatherArea);
                            email.setFileAttachments(new Messaging.EmailFileAttachment[]{ MapEmailAttachments.get('RO') });
                            List<String> sendTo = new List<String>();
                            sendTo.add(usr.Email);
                            email.setToAddresses(sendTo);
                            masterListMails.add(email);
                        }else if(RS == 'true' && userAppartenenteAdArea(fatherArea,'RS',MappaCompletaCheckbox) && userAppartenenteAFiliale(fatherArea,filialeUserRoleBorg,'RS',mapFiliali,MappaCompletaCheckbox))
                        {
                            system.debug(' BORG invio email fatherArea:'+fatherArea);
                            email.setFileAttachments(new Messaging.EmailFileAttachment[]{ MapEmailAttachments.get('RS') });
                            List<String> sendTo = new List<String>();
                            sendTo.add(usr.Email);
                            email.setToAddresses(sendTo);
                            masterListMails.add(email);
                        }else if(RT == 'true' && userAppartenenteAdArea(fatherArea,'RT',MappaCompletaCheckbox) && userAppartenenteAFiliale(fatherArea,filialeUserRoleBorg,'RT',mapFiliali,MappaCompletaCheckbox))
                        {
                            system.debug('BORG invio email fatherArea:'+fatherArea);
                            email.setFileAttachments(new Messaging.EmailFileAttachment[]{ MapEmailAttachments.get('RT') });
                            List<String> sendTo = new List<String>();
                            sendTo.add(usr.Email);
                            email.setToAddresses(sendTo);
                            masterListMails.add(email);
                        }                     
                }
            
                // Sends mass emails
                system.debug('masterListMails->'+masterListMails.size());
                if( masterListMails != null && masterListMails.size() > 0 && !Test.isRunningTest() )
                {
                    EmailUtils.sendEmail(masterListMails,mockAddressIVASS);
                }

            }
        }
        
    }    

    private static boolean userAppartenenteAdArea(String fatherArea,String regione,Map<String,Set<Integer>> MappaCompletaCheckbox ){
        if (fatherArea!=null && MappaCompletaCheckbox!=null) {
            if (MappaCompletaCheckbox.get(regione)  != null &&   MappaCompletaCheckbox.get(regione).size() > 0 ) {
                Set<Integer> values =  MappaCompletaCheckbox.get(regione);
                for (Integer val:values) {
                    if (fatherArea.contains(String.valueOf(val))) {
                        return true;
                    }
                }
            }
        }
        return false;
    }

    private static boolean userAppartenenteAFiliale(String fatherArea,String filialeId,String regione,Map<String,List<String>> mapFiliali,Map<String,Set<Integer>> MappaCompletaCheckbox){
        if (mapFiliali==null || mapFiliali.isEmpty() || MappaCompletaCheckbox==null) {
            // non è stata creata la mappa di appartenenza alla filiale:
            // si salta il controllo 
            return true;
        }
        Set<Integer> areaIds =  MappaCompletaCheckbox.get(regione);
        if (areaIds==null || areaIds.isEmpty()) {
            // non sono stati selezionate le regioni territoriali (RA,RE...)
            // si salta il controllo 
            return true;
        }
        if (areaIds!=null && !areaIds.isEmpty()) {
            for (Integer areaId:areaIds) {
                List<String> listaFilialiId = mapFiliali.get(String.valueOf(areaId));
                String codArea = fatherArea==null?'':fatherArea.replace('COORD. AREA', '').trim();
                if (listaFilialiId==null && fatherArea!=null && codArea==(String.valueOf(areaId))) {
                    // non sono state espanse le filiali dell'area
                    // si salta il controllo 
                    System.debug(' non sono state espanse le filiali - controllo da saltare areaId:'+areaId);
                    return true;
                } 
                if (listaFilialiId!=null && !listaFilialiId.isEmpty()) {
                    for (String idFiliale:listaFilialiId) {
                        // si effettua il controllo
                        if (idFiliale.equalsIgnoreCase(filialeId)) {
                            return true;
                        }
                    }
                }
            }
        }
        return false;
    }

    private static boolean areaManagerInAreaSelezionata(String area,String regione,Map<String,Set<Integer>> MappaCompletaCheckbox ){
        if (MappaCompletaCheckbox.get(regione)  != null &&   MappaCompletaCheckbox.get(regione).size() > 0 ) {
            Set<Integer> values =  MappaCompletaCheckbox.get(regione);
            for (Integer val:values) {
                if (area.contains(String.valueOf(val))) {
                    return true;
                }
            }
        }
        return false;
    }


    // deve essere usato per profili branch employer
    // consente di risalire di 3 livelli al ruolo padre    
    private static Map<String,String> getFatherRole(List<String> rolechildren){
        Map<String,String> mappaRolesFather = new Map<String,String>();
        if (rolechildren!=null) {
            List<UserRole> listRole = [SELECT Id, Name, ParentRoleId FROM UserRole];
            if (listRole!=null) {
                for (UserRole rolechild:listRole) {
                    if (rolechildren!=null && rolechildren.contains(rolechild.Name)) {
                        for (UserRole rolefather1:listRole) {
                            if (rolefather1.Id == rolechild.ParentRoleId) {
                                for (UserRole rolefather2:listRole) {
                                    if (rolefather2.Id == rolefather1.ParentRoleId) {
                                        for (UserRole rolefather3:listRole) {
                                            if (rolefather3.Id == rolefather2.ParentRoleId) {
                                                mappaRolesFather.put(rolechild.Name,rolefather3.Name); 
                                            }
                                        }
                                    }
                                }
                            }
                        }                        
                    }
                }
            }
        }
        System.debug('getFatherRole mappaRolesFather:'+mappaRolesFather);
        return mappaRolesFather;
    }

    // deve essere usato per profili branch employer
    // consente di risalire di 2 livelli al ruolo padre    
    private static Map<String,String> getFatherArea(List<String> rolechildren){
        Map<String,String> mappaRolesFatherArea = new Map<String,String>();
        if (rolechildren!=null) {
            List<UserRole> listRole = [SELECT Id, Name, ParentRoleId FROM UserRole];
            if (listRole!=null) {
                for (UserRole rolechild:listRole) {
                    if (rolechildren!=null && rolechildren.contains(rolechild.Name)) {
                        for (UserRole rolefather1:listRole) {
                            if (rolefather1.Id == rolechild.ParentRoleId) {
                                for (UserRole rolefather2:listRole) {
                                    if (rolefather2.Id == rolefather1.ParentRoleId) {
                                        mappaRolesFatherArea.put(rolechild.Name,rolefather2.Name); 
                                    }
                                }
                            }
                        }                        
                    }
                }
            }
        }
        System.debug('getFatherArea mappaRolesFatherArea:'+mappaRolesFatherArea);
        return mappaRolesFatherArea;
    }

    // deve essere usato per profili branch manager
    // consente di risalire di 1 livelli al ruolo padre    
    private static Map<String,String> getFather1Lev(List<String> rolechildren){
        Map<String,String> mappaRolesFather1Lev = new Map<String,String>();
        if (rolechildren!=null) {
            List<UserRole> listRole = [SELECT Id, Name, ParentRoleId FROM UserRole];
            if (listRole!=null) {
                for (UserRole rolechild:listRole) {
                    if (rolechildren!=null && rolechildren.contains(rolechild.Name)) {
                        for (UserRole rolefather1:listRole) {
                            if (rolefather1.Id == rolechild.ParentRoleId) {
                                mappaRolesFather1Lev.put(rolechild.Name,rolefather1.Name); 
                            }
                        }                        
                    }
                }
            }
        }
        System.debug('getFather1Lev mappaRolesFather1Lev:'+mappaRolesFather1Lev);
        return mappaRolesFather1Lev;
    }


    private static List<String> regioneAdriatica = new List<String>{'16','17','18','19','20'}; 
    private static List<String> regioneCentrale = new List<String>{'11','12','13','14','15'}; 
    private static List<String> regioneEst = new List<String>{'10','6','7','8','9'}; 
    private static List<String> regioneOvest = new List<String>{'1','2','3','4','5'}; 
    private static List<String> regioneSud = new List<String>{'26','27','28','29','30'}; 
    private static List<String> regioneTirreno = new List<String>{'21','22','23','24','25'}; 

    // deve essere usato per profili borg
    private static Map<String,String> getFatherAreaBorg(List<String> rolechildren){
        // risale di 3 livelli (borg semplice)
        Map<String,String> mappaArea = getFatherRole(rolechildren);
        return mappaArea;
    }

    // deve essere usato per profili borg
    private static Boolean borgAppartieneARegione(string area,String regione){
        if (regione=='RA') {
           for (String codArea:regioneAdriatica) {
               if (area.contains(codArea)) {
                   return true;
               }
           }
        } else if (regione=='RC') {
           for (String codArea:regioneCentrale) {
               if (area.contains(codArea)) {
                   return true;
               }
           }
        } else if (regione=='RE') {
           for (String codArea:regioneEst) {
               if (area.contains(codArea)) {
                   return true;
               }
           }          
        } else if (regione=='RO') {
           for (String codArea:regioneOvest) {
               if (area.contains(codArea)) {
                   return true;
               }
           }           
        } else if (regione=='RS') {
           for (String codArea:regioneSud) {
               if (area.contains(codArea)) {
                   return true;
               }
           }
        } else if (regione=='RT') {
           for (String codArea:regioneTirreno) {
               if (area.contains(codArea)) {
                   return true;
               }
           }
        }
        return false;
    }

    // deve essere usato per profili borg
    // consente di risalire di 1 livelli per determinare la filiale di appartenenza di un borg    
    private static Map<String,String> getFatherBorgUserRoleFiliale(List<String> rolechildrenParentId){
        Map<String,String> mappaRolesFatherParentId = new Map<String,String>();
        if (rolechildrenParentId!=null) {
            List<UserRole> listRole = [SELECT Id, Name, ParentRoleId FROM UserRole];
            if (listRole!=null) {
                for (String rolechildParentId:rolechildrenParentId) {
                    for (UserRole rolefather1:listRole) {
                        if (rolefather1.Id == rolechildParentId) {
                            mappaRolesFatherParentId.put(rolechildParentId,rolefather1.ParentRoleId); 
                        }
                    }                        
               }
            }
        }
        System.debug('getFatherBorgUserRoleFiliale mappaRolesFatherParentId:'+mappaRolesFatherParentId);
        return mappaRolesFatherParentId;
    }



    public static String ElaborateFileCsv( String RegioneFilter )
    {
        
            List<IVASS_Dealer_Courses_Iscritti__c> ListaIscrittiToElaborate = [ SELECT Id , Filiale__r.Name, Dipendenza__c , Area__c ,
                                                                            Regione__c , Dealer__r.getCodice_Cliente__c , 
                                                                            Ragione_Sociale__c , Referente__r.OCS_External_Id__c , 
                                                                            Cognome__c , Nome__c ,  Codice_Fiscale__c , Corso__r.Tipo_Corso__r.Name , 
                                                                            Stato_Corso__c , Utenza__c , Password__c , Invio_all_Outsourcer__c
                                                                    FROM IVASS_Dealer_courses_Iscritti__c WHERE Regione__c =: RegioneFilter ];
            
        
        
        
        
            //CSV File Data
            String Header_CSV_File = 'Filiale,Dipendenza,Area,Regione,Codice Cliente,Ragione Sociale,Referente,Cognome,Nome,Codice Fiscale,'+
                                    'Tipo Corso,Stato Corso,Utenza,Password,Invio Outsourcer\n';
            String finalstr        = Header_CSV_File ;
            String Filiale         = '';
            String Dipendenza      = '';
            String Area            = '';
            String Regione         = '';
            String CodiceCliente   = '';
            String RagioneSociale  = '';
            String Referente       = '';
            String Cognome         = '';
            String Nome            = '';
            String CodiceFiscale   = '';
            String TipoCorso       = '';
            String StatoCorso      = '';
            String Utenza          = '';
            String Password        = '';
            String InvioOutsourcer = '';
                    
            for( IVASS_Dealer_courses_Iscritti__c Iscr: ListaIscrittiToElaborate )
            {
                if( Iscr.Filiale__c != null )Filiale = Iscr.Filiale__r.Name;
                if( Iscr.Dipendenza__c != null )Dipendenza = String.valueOf( Iscr.Dipendenza__c );
                if( Iscr.Area__c != null )Area = String.valueOf( Iscr.Area__c );
                if( Iscr.Regione__c != null )Regione = Iscr.Regione__c;
                if( Iscr.Dealer__r.getCodice_Cliente__c != null )CodiceCliente = Iscr.Dealer__r.getCodice_Cliente__c;
                if( Iscr.Ragione_Sociale__c != null )RagioneSociale = Iscr.Ragione_Sociale__c;
                if( Iscr.Referente__r.OCS_External_Id__c != null )Referente = Iscr.Referente__r.OCS_External_Id__c;
                if( Iscr.Cognome__c != null )Cognome = Iscr.Cognome__c;
                if( Iscr.Nome__c != null )Nome = Iscr.Nome__c;
                if( Iscr.Codice_Fiscale__c != null)CodiceFiscale = Iscr.Codice_Fiscale__c;
                if( Iscr.Corso__c != null && Iscr.Corso__r.Tipo_Corso__c != null )TipoCorso = Iscr.Corso__r.Tipo_Corso__r.Name;
                if( Iscr.Stato_Corso__c != null )StatoCorso = Iscr.Stato_Corso__c;
                if( Iscr.Utenza__c != null )Utenza = Iscr.Utenza__c;
                if( Iscr.Password__c != null )Password = Iscr.Password__c;
                if( Iscr.Invio_all_Outsourcer__c != null )InvioOutsourcer = Iscr.Invio_all_Outsourcer__c;
                
                
                String recordString = Filiale+','+Dipendenza+','+Area+','+Regione+','+CodiceCliente+','+RagioneSociale+','+Referente+','+
                                    Cognome+','+Nome+','+CodiceFiscale+','+TipoCorso+','+
                                    StatoCorso+','+Utenza+','+Password+','+InvioOutsourcer+'\n';
                                        
                finalstr            = finalstr +recordString;
            }
        
            return finalstr;
        
        
    }

    public static String ElaborateFileCsvPerArea( String RegioneFilter , Set<Integer> ListaAreeFilter)
    {
        return ElaborateFileCsvPerArea(RegioneFilter,ListaAreeFilter,null);
    }

    public static String ElaborateFileCsvPerArea( String RegioneFilter , Set<Integer> ListaAreeFilter ,  Map<String,List<String>> mappaFiliali)
    {
            
            List<String> listRoleDeveloperName = null;
            if (mappaFiliali!=null && RegioneFilter!=null && ListaAreeFilter!=null && ListaAreeFilter.size()>0) {
                List<String> listaIdRole = new List<String>();
                for (Integer area:ListaAreeFilter)  {
                    if (mappaFiliali.get(String.valueOf(area))!=null) {
                        listaIdRole.addAll(mappaFiliali.get(String.valueOf(area)));
                    }                 
                }
                List<UserRole> listUserRole = [SELECT Id, DeveloperName FROM UserRole WHERE Id IN :listaIdRole];
                if (listUserRole!=null) {
                    listRoleDeveloperName = new List<String>();
                    for (UserRole ur:listUserRole) {
                        listRoleDeveloperName.add(ur.DeveloperName);
                    }
                }
            }

            List<IVASS_Dealer_Courses_Iscritti__c> ListaIscrittiToElaborate = new List<IVASS_Dealer_Courses_Iscritti__c>();
            if (listRoleDeveloperName!=null) {
                System.debug('ElaborateFileCsvPerArea listRoleDeveloperName:'+listRoleDeveloperName);
                // query con filtro sulla regione, area, filiale
                List<IVASS_Dealer_Courses_Iscritti__c> ListaIscrittiToElaborateDaFiltare = [ SELECT Id , Filiale__r.Name, Filiale__r.NameParentRoleReference__c, Dipendenza__c , Area__c ,
                                                                                            Regione__c , Dealer__r.getCodice_Cliente__c , 
                                                                                            Ragione_Sociale__c , Referente__r.OCS_External_Id__c , 
                                                                                            Cognome__c , Nome__c ,  Codice_Fiscale__c , Corso__r.Tipo_Corso__r.Name , 
                                                                                            Stato_Corso__c , Utenza__c , Password__c , Invio_all_Outsourcer__c
                                                                                    FROM IVASS_Dealer_courses_Iscritti__c 
                                                                                    WHERE Regione__c =: RegioneFilter AND 
                                                                                        Area__c IN : ListaAreeFilter ];
                if (ListaIscrittiToElaborateDaFiltare!=null) {           
                    for (Integer i=0;i<ListaIscrittiToElaborateDaFiltare.size();i++) {
                        if (listRoleDeveloperName.contains(ListaIscrittiToElaborateDaFiltare[i].Filiale__r.NameParentRoleReference__c)) {
                            ListaIscrittiToElaborate.add(ListaIscrittiToElaborateDaFiltare[i]);
                        }
                    }                      
                }                                           
            } else {
                // query con filtro sulla regione, area
                ListaIscrittiToElaborate = [ SELECT Id , Filiale__r.Name, Dipendenza__c , Area__c ,
                                                                                            Regione__c , Dealer__r.getCodice_Cliente__c , 
                                                                                            Ragione_Sociale__c , Referente__r.OCS_External_Id__c , 
                                                                                            Cognome__c , Nome__c ,  Codice_Fiscale__c , Corso__r.Tipo_Corso__r.Name , 
                                                                                            Stato_Corso__c , Utenza__c , Password__c , Invio_all_Outsourcer__c
                                                                                    FROM IVASS_Dealer_courses_Iscritti__c 
                                                                                    WHERE Regione__c =: RegioneFilter AND 
                                                                                        Area__c IN : ListaAreeFilter];

            }

            //CSV File Data
            String Header_CSV_File  = 'Filiale,Dipendenza,Area,Regione,Codice Cliente,Ragione Sociale,Referente,Cognome,Nome,Codice Fiscale,'+
                                    'Tipo Corso,Stato Corso,Utenza,Password,Invio Outsourcer\n';
            String finalstr         = Header_CSV_File ;
            String Filiale          = '';
            String Dipendenza       = '';
            String Area             = '';
            String Regione          = '';
            String CodiceCliente    = '';
            String RagioneSociale   = '';
            String Referente        = '';
            String Cognome          = '';
            String Nome             = '';
            String CodiceFiscale    = '';
            String TipoCorso        = '';
            String StatoCorso       = '';
            String Utenza           = '';
            String Password         = '';
            String InvioOutsourcer  = '';
            
            for( IVASS_Dealer_courses_Iscritti__c Iscr: ListaIscrittiToElaborate )
            {
                if (Iscr.Filiale__r!=null) {
                    System.debug('ElaborateFileCsvPerArea Iscritto filiale name:'+Iscr.Filiale__r.Name);
                }
                if( Iscr.Filiale__c != null )Filiale = Iscr.Filiale__r.Name;
                if( Iscr.Dipendenza__c != null )Dipendenza = String.valueOf( Iscr.Dipendenza__c );
                if( Iscr.Area__c != null )Area = String.valueOf( Iscr.Area__c );
                if( Iscr.Regione__c != null )Regione = Iscr.Regione__c;
                if( Iscr.Dealer__r.getCodice_Cliente__c != null )CodiceCliente = Iscr.Dealer__r.getCodice_Cliente__c;
                if( Iscr.Ragione_Sociale__c != null )RagioneSociale = Iscr.Ragione_Sociale__c;
                if( Iscr.Referente__r.OCS_External_Id__c != null )Referente = Iscr.Referente__r.OCS_External_Id__c;
                if( Iscr.Cognome__c != null )Cognome = Iscr.Cognome__c;
                if( Iscr.Nome__c != null )Nome = Iscr.Nome__c;
                if( Iscr.Codice_Fiscale__c != null)CodiceFiscale = Iscr.Codice_Fiscale__c;
                if( Iscr.Corso__c != null && Iscr.Corso__r.Tipo_Corso__c != null )TipoCorso = Iscr.Corso__r.Tipo_Corso__r.Name;
                if( Iscr.Stato_Corso__c != null )StatoCorso = Iscr.Stato_Corso__c;
                if( Iscr.Utenza__c != null )Utenza = Iscr.Utenza__c;
                if( Iscr.Password__c != null )Password = Iscr.Password__c;
                if( Iscr.Invio_all_Outsourcer__c != null )InvioOutsourcer = Iscr.Invio_all_Outsourcer__c;
                
                
                String recordString = Filiale+','+Dipendenza+','+Area+','+Regione+','+CodiceCliente+','+RagioneSociale+','+Referente+','+
                                    Cognome+','+Nome+','+CodiceFiscale+','+TipoCorso+','+
                                    StatoCorso+','+Utenza+','+Password+','+InvioOutsourcer+'\n';
                                        
                finalstr            = finalstr +recordString;
            }
            
            return finalstr;
        
        
        
    }
        
    public static Messaging.EmailFileAttachment TemplateMailsReturnObject( String StringCsv , String Regione )
    {   
            Messaging.EmailFileAttachment csvAttc       = new Messaging.EmailFileAttachment();
                                    blob csvBlob       = Blob.valueOf(StringCsv);
                                    string csvname     = 'Elenco_Iscritti_Regione_'+Regione+'.csv';
                                    csvAttc.setFileName(csvname);
                                    csvAttc.setBody(csvBlob);
            return csvAttc;       
    }  
    //Metodo Gestione Mappa
    public static Map<String,Set<Integer>> ElaborazioneMappa( Map<String,Boolean> MappaInput )
    {
            
        //Map<CheckBoxElement,List<CheckBoxElement>> MappaInterna = new Map<CheckBoxElement,List<CheckBoxElement>>();
        
        Map<String,Set<Integer>> MappaXX = new Map<String,Set<Integer>>();
        
        Set<Integer> Aree_RA = new Set<Integer>();
        Set<Integer> Aree_RC = new Set<Integer>();
        Set<Integer> Aree_RE = new Set<Integer>();
        Set<Integer> Aree_RO = new Set<Integer>();
        Set<Integer> Aree_RS = new Set<Integer>();
        Set<Integer> Aree_RT = new Set<Integer>();
        
        for( String StrIterator : MappaInput.keyset() )
        { 
                
                if( ( StrIterator == 'Check_RA' && MappaInput.get( StrIterator ) == true ) ||
                    ( StrIterator == 'Check_RC' && MappaInput.get( StrIterator ) == true ) ||
                    ( StrIterator == 'Check_RE' && MappaInput.get( StrIterator ) == true ) ||
                    ( StrIterator == 'Check_RO' && MappaInput.get( StrIterator ) == true ) ||
                    ( StrIterator == 'Check_RS' && MappaInput.get( StrIterator ) == true ) ||
                    ( StrIterator == 'Check_RT' && MappaInput.get( StrIterator ) == true ) )
                {
                    MappaXX.put( StrIterator.right(2) , new Set<Integer>() );
                }
                
                //Area_RA
                if( StrIterator == 'Check_RA_16_b' && MappaInput.get( StrIterator ) == true )Aree_RA.add(16);
                if( StrIterator == 'Check_RA_17_b' && MappaInput.get( StrIterator ) == true )Aree_RA.add(17);
                if( StrIterator == 'Check_RA_18_b' && MappaInput.get( StrIterator ) == true )Aree_RA.add(18);
                if( StrIterator == 'Check_RA_19_b' && MappaInput.get( StrIterator ) == true )Aree_RA.add(19);
                if( StrIterator == 'Check_RA_20_b' && MappaInput.get( StrIterator ) == true )Aree_RA.add(20);
                //Area_RC
                if( StrIterator == 'Check_RC_11_b' && MappaInput.get( StrIterator ) == true )Aree_RC.add(11);
                if( StrIterator == 'Check_RC_12_b' && MappaInput.get( StrIterator ) == true )Aree_RC.add(12);
                if( StrIterator == 'Check_RC_13_b' && MappaInput.get( StrIterator ) == true )Aree_RC.add(13);
                if( StrIterator == 'Check_RC_14_b' && MappaInput.get( StrIterator ) == true )Aree_RC.add(14);
                if( StrIterator == 'Check_RC_15_b' && MappaInput.get( StrIterator ) == true )Aree_RC.add(15);
                //Area_RE
                if( StrIterator == 'Check_RE_6_b'  && MappaInput.get( StrIterator ) == true )Aree_RE.add(6);
                if( StrIterator == 'Check_RE_7_b'  && MappaInput.get( StrIterator ) == true )Aree_RE.add(7);
                if( StrIterator == 'Check_RE_8_b'  && MappaInput.get( StrIterator ) == true )Aree_RE.add(8);
                if( StrIterator == 'Check_RE_9_b'  && MappaInput.get( StrIterator ) == true )Aree_RE.add(9);
                if( StrIterator == 'Check_RE_10_b' && MappaInput.get( StrIterator ) == true )Aree_RE.add(10);
                //Area_RO
                if( StrIterator == 'Check_RO_1_b'  && MappaInput.get( StrIterator ) == true )Aree_RO.add(1);
                if( StrIterator == 'Check_RO_2_b'  && MappaInput.get( StrIterator ) == true )Aree_RO.add(2);
                if( StrIterator == 'Check_RO_3_b'  && MappaInput.get( StrIterator ) == true )Aree_RO.add(3);
                if( StrIterator == 'Check_RO_4_b'  && MappaInput.get( StrIterator ) == true )Aree_RO.add(4);
                if( StrIterator == 'Check_RO_5_b'  && MappaInput.get( StrIterator ) == true )Aree_RO.add(5);
                //Area_RS
                if( StrIterator == 'Check_RS_26_b' && MappaInput.get( StrIterator ) == true )Aree_RS.add(26);
                if( StrIterator == 'Check_RS_27_b' && MappaInput.get( StrIterator ) == true )Aree_RS.add(27);
                if( StrIterator == 'Check_RS_28_b' && MappaInput.get( StrIterator ) == true )Aree_RS.add(28);
                if( StrIterator == 'Check_RS_29_b' && MappaInput.get( StrIterator ) == true )Aree_RS.add(29);
                if( StrIterator == 'Check_RS_30_b' && MappaInput.get( StrIterator ) == true )Aree_RS.add(30);
                //Area_RT
                if( StrIterator == 'Check_RT_21_b' && MappaInput.get( StrIterator ) == true )Aree_RT.add(21);
                if( StrIterator == 'Check_RT_22_b' && MappaInput.get( StrIterator ) == true )Aree_RT.add(22);
                if( StrIterator == 'Check_RT_23_b' && MappaInput.get( StrIterator ) == true )Aree_RT.add(23);
                if( StrIterator == 'Check_RT_24_b' && MappaInput.get( StrIterator ) == true )Aree_RT.add(24);
                if( StrIterator == 'Check_RT_25_b' && MappaInput.get( StrIterator ) == true )Aree_RT.add(25);

        }
        
        if( Aree_RA != null && Aree_RA.size() > 0 )MappaXX.put('RA', Aree_RA );
        if( Aree_RC != null && Aree_RC.size() > 0 )MappaXX.put('RC', Aree_RC );
        if( Aree_RE != null && Aree_RE.size() > 0 )MappaXX.put('RE', Aree_RE );
        if( Aree_RO != null && Aree_RO.size() > 0 )MappaXX.put('RO', Aree_RO );
        if( Aree_RS != null && Aree_RS.size() > 0 )MappaXX.put('RS', Aree_RS );
        if( Aree_RT != null && Aree_RT.size() > 0 )MappaXX.put('RT', Aree_RT );
        
        if( MappaXX != null && MappaXX.size() > 0 )return MappaXX;
        else return new Map<String,Set<Integer>>();
        
    }    
    
    

    @AuraEnabled
    public static List<Filiale> listaFilialiUserRole() {
        List<Filiale> listaFiliale = new List<Filiale>();
        List<String> listaNomiArea = new List<String>();
        for (Integer i=1;i<=30;i++) {
            listaNomiArea.add('COORD. AREA '+i);            
        }
        List<UserRole> listAreaRoles = [SELECT Id,Name FROM UserRole WHERE Name IN:listaNomiArea];
        if (listAreaRoles!=null && listAreaRoles.size()>0) {
            List<Id> idAreaRole = new List<Id>();
            Map<Id,String> mappaArea = new Map<Id,String>();
            for (UserRole areaRole:listAreaRoles) {
                  idAreaRole.add(areaRole.Id); 
                  String areaName = areaRole.Name;
                  String codiceArea = areaRole.Name.substring(areaName.length()-2,areaName.length()).trim();
                  mappaArea.put(areaRole.Id,codiceArea); 
            }
            List<UserRole> listFiliali = [SELECT Id,Name,ParentRoleId FROM UserRole WHERE ParentRoleId IN:idAreaRole];
            if (listFiliali!=null && listFiliali.size()>0) {
                for (UserRole filiale:listFiliali) {
                    Filiale f;
                    for(Filiale temp:listaFiliale){
                        if(temp.id==mappaArea.get(filiale.ParentRoleId)){
                            f= temp;
                            break;
                        } 
                    }
                    if(f == null) { 
                        f= new Filiale();
                        listaFiliale.add(f);
                    }
                    f.Id = mappaArea.get(filiale.ParentRoleId);
                    List<Filiale> listValues =  f.figli;
                    if (listValues==null) {
                        f.figli = new List<Filiale>();
                    }       
                    Filiale fil = new Filiale();   
                    fil.id = filiale.Id;
                    fil.name = (filiale.Name==null)?'':filiale.Name.replace('Manager','');
                    f.figli.add(fil);
                }
            }
        }     
        System.debug('listaFilialiUserRole listaFiliale:'+listaFiliale);   
        return listaFiliale;
    }

        
}