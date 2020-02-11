@isTest
public  class CaseTriggerHandlerAssegnazioneTest {
    @TestSetup
    static void makeData(){
        FObject objCase=new FObject('Case',10);
        //objCase.setDefinition();
        objCase.insertRecords(true);
        /****
        FObject objUser=new FObject('User',1);
        objUser.setDefinition('username','static value(user1@test1.com)');
        objUser.setDefinition('UserRoleId','random lookup(UserRole) source(salesforce)');
        List<Database.SaveResult> lstUserResult=objUser.insertRecords(true);
        for (Database.SaveResult sr : lstUserResult) {
            if (sr.isSuccess()) {
                // Operation was successful, so get the ID of the record that was processed
                System.debug('Successfully inserted account. Account ID: ' + sr.getId());
            }
            else {
                // Operation failed, so get all errors                
                for(Database.Error err : sr.getErrors()) {
                    System.debug('The following error has occurred.');                    
                    System.debug(err.getStatusCode() + ': ' + err.getMessage());
                    System.debug('Account fields that affected this error: ' + err.getFields());
                    System.assert(false,'ERROR inserted user'+ err.getMessage());
                }
            }
        }            
        ***/    
    }

    @isTest
    public static void assign2Me(){
        User thisUser = [SELECT Id FROM User WHERE Id = :UserInfo.getUserId()];
       // Insert account as current user
        System.runAs (thisUser) {
            FObject objUser=new FObject('User',1);
            objUser.setDefinition('username','static value(user1@test1.com)');
            objUser.setDefinition('UserRoleId','random lookup(UserRole) source(salesforce)');
            List<Database.SaveResult> lstUserResult=objUser.insertRecords(true);
        }
        User u=[select id,userRoleId from user where username='user1@test1.com'];
        Test.startTest();
        List<Case> lstCase=[select id from case];
        for(Case c : lstCase){
            c.OwnerId=u.id;
        }
        update lstCase;
       
        System.runAs(u){
            lstCase=[select id from case];
            System.assert(lstCase.size()>0);
            for(Case c : lstCase)
                c.Owner_User__c=u.id;
            update lstCase;
        }
        Test.stopTest();
       for (Case c: [select id,Owner_User__c from case]){
           System.assertEquals(u.id, c.Owner_User__c,'ASSIGN NOT CORRECT');
       }        

    }


    @isTest
    public static void assign2MySubordinates(){
        User thisUser = [SELECT Id FROM User WHERE Id = :UserInfo.getUserId()];
       // Insert account as current user
        System.runAs (thisUser) {
            FObject objUser=new FObject('User',1);
            objUser.setDefinition('username','static value(ccmanager@test1.com)');
            objUser.setDefinition('UserRoleId','random lookup(UserRole)  field(Name) value(Call Center Interno Manager) source(salesforce)');
            List<Database.SaveResult> lstUserResult=objUser.insertRecords(true);
             FObject objUser2=new FObject('User',1);
            objUser2.setDefinition('username','static value(cc@test1.com)');
            objUser2.setDefinition('UserRoleId','random lookup(UserRole)  field(Name) value(Call Center Interno) source(salesforce)');
            List<Database.SaveResult> lstUserResult2=objUser2.insertRecords(true);
        }
        User manager=[select id,userRoleId from user where username='ccmanager@test1.com'];
        User u=[select id,userRoleId from user where username='cc@test1.com'];
        Test.startTest();
        List<Case> lstCase=[select id from case];
        for(Case c : lstCase){
            c.OwnerId=manager.id;
        }
        update lstCase;
       
        System.runAs(manager){
            lstCase=[select id from case];
            System.assert(lstCase.size()>0);
            for(Case c : lstCase)
                c.Owner_User__c=u.id;
            update lstCase;
        }
        Test.stopTest();
       for (Case c: [select id,Owner_User__c from case]){
           System.assertEquals(u.id, c.Owner_User__c,'ASSIGN NOT CORRECT');
       }        

    }

     @isTest
    public static void assign2MyRole(){
        User thisUser = [SELECT Id FROM User WHERE Id = :UserInfo.getUserId()];
       // Insert account as current user
        System.runAs (thisUser) {
            FObject objUser=new FObject('User',1);
            objUser.setDefinition('username','static value(cc1@test1.com)');
            objUser.setDefinition('UserRoleId','random lookup(UserRole)  field(Name) value(Call Center Interno) source(salesforce)');
            List<Database.SaveResult> lstUserResult=objUser.insertRecords(true);
             FObject objUser2=new FObject('User',1);
            objUser2.setDefinition('username','static value(cc2@test1.com)');
            objUser2.setDefinition('UserRoleId','random lookup(UserRole)  field(Name) value(Call Center Interno) source(salesforce)');
            List<Database.SaveResult> lstUserResult2=objUser2.insertRecords(true);
        }
        User u1=[select id,userRoleId from user where username='cc1@test1.com'];
        User u2=[select id,userRoleId from user where username='cc2@test1.com'];
        Test.startTest();
        List<Case> lstCase=[select id from case];
        for(Case c : lstCase){
            c.OwnerId=u1.id;
        }
        update lstCase;
       
        System.runAs(u1){
            lstCase=[select id from case];
            System.assert(lstCase.size()>0);
            for(Case c : lstCase)
                c.Owner_User__c=u2.id;
            update lstCase;               
        }
        Test.stopTest();
        for (Case c: [select id,Owner_User__c from case])         System.assertEquals(u2.id, c.Owner_User__c,'ASSIGN NOT CORRECT');
    }

     @isTest
    public static void assign2MyBoss(){
        User thisUser = [SELECT Id FROM User WHERE Id = :UserInfo.getUserId()];
       // Insert account as current user
        System.runAs (thisUser) {
            FObject objUser=new FObject('User',1);
            objUser.setDefinition('username','static value(ccmanager@test1.com)');
            objUser.setDefinition('UserRoleId','random lookup(UserRole)  field(Name) value(Call Center Interno Manager) source(salesforce)');
            List<Database.SaveResult> lstUserResult=objUser.insertRecords(true);
             FObject objUser2=new FObject('User',1);
            objUser2.setDefinition('username','static value(cc@test1.com)');
            objUser2.setDefinition('UserRoleId','random lookup(UserRole)  field(Name) value(Call Center Interno) source(salesforce)');
            List<Database.SaveResult> lstUserResult2=objUser2.insertRecords(true);
        }
        User manager=[select id,userRoleId from user where username='ccmanager@test1.com'];
        User u=[select id,userRoleId from user where username='cc@test1.com'];
        Test.startTest();
        List<Case> lstCase=[select id from case];
        for(Case c : lstCase){
            c.OwnerId=u.id;
        }
        update lstCase;
       
        System.runAs(u){
            lstCase=[select id from case];
            System.assert(lstCase.size()>0);
            for(Case c : lstCase)
                c.Owner_User__c=manager.id;
            try{   update lstCase; system.assertEquals(1, 2, 'TEST FAIL');} catch(Exception e ){
                system.assert(e.getMessage().contains('Il ruolo dell\'utente selezionato Call Center Interno Manager non è nella gerarchia di Call Center Interno'),'MESSAGE NOT CONFORME');
            }

        }
        Test.stopTest();
          

    }
}