public without sharing class BarraTelefonicaPrintParameter {
    public Map<String,String> mapParameters {get;set;}
    
    public BarraTelefonicaPrintParameter(){
        mapParameters=ApexPages.currentPage().getParameters();
        System.debug('mapParameters-->'+mapParameters);
        //PARAMETRI DI RILIEVO
        //CTI_ANI 
        //CTI_CODICECLIENTE 
        //CTI_CODA  
        
        
        
    }
    public void printParameter(){
        
    }
    public Pagereference createCase(){
        System.debug('******chiamataInbound*******START-->'+System.now());
        for(String key : mapParameters.keySet()){
            System.debug('key-->'+key);
            System.debug('value-->'+mapParameters.get(key));
        }

        final String categoriaExternal = '1035';
        final String categoriaExternalAffari = '4723';
        //get coda parameter
        String queue=mapParameters.get('cti_CODA');
        System.debug('------queue----->'+queue);
        String entita=mapParameters.get('cti_ENTITA');
        System.debug('------entita----->'+entita);
        String callId=mapParameters.get('cti_CALLID');
        System.debug('------callId----->'+callId);

        System.debug('****chiamataInbound*******Controllo presenza se ID già presente---START-->'+System.now());
        //Case con trasferimento di chiamata --> stesso call id
        if(callId!=null && !String.isBlank(callId)){
            Case trasferimento = checkCallId(callId);
            System.debug('****createCase*******Controllo presenza se ID già presente---DONE-->'+System.now());
            if(trasferimento!=null) return redirectPage(trasferimento.Id);
        }
        

        if(queue==null || queue.indexOf('AFFARI')<0 || queue.toUpperCase()=='AFFARI-ECOMMERCE') { // CASO EASYCM
            System.debug('**chiamataInbound*****CASO EASY CM****** START***'+System.now());
            
            Group queueGroup = [SELECT ID FROM GROUP WHERE DeveloperName = 'CTI_Inbound' LIMIT 1];
            //creo case e dirigo all'easyCM
            Map<String,String> mapCTI=new Map<String,String> ();
            String codCliente=mapParameters.get('cti_CODICECLIENTE');
            if(codCliente!=null && codCliente!='' ){
                String toTransformCliente=String.valueOf(Integer.valueOf(codCliente)); //'000000000'+codCliente;                
                //mapCTI.put('ocsCode',toTransformCliente.substring(toTransformCliente.length()-9));
                mapCTI.put('ocsCode',toTransformCliente);
            }
            mapCTI.put('telephoneNumber',mapParameters.get('cti_ANI'));
            Id recordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('Inbound_Call').getRecordTypeId();
            List<XCS_Categoria__c> categorie = [SELECT ID FROM XCS_Categoria__c where External_Id__c = :categoriaExternal];
            Case theCase2 = new Case(
                //Subject = 'IO',
                //Esito__c = 'TEST',
                //Description = '{"ocsCode" : "229370","telephoneNumber" : "334 3355026","esitoSurvey" : "ok"}',
                Description=JSON.serialize(mapCTI),
                RecordTypeId = recordTypeId,
                Categoria_Riferimento__c = categorie.size()>0? categorie[0].ID : null,
                Subject = 'Acquisizione Inbound',
                CTI_ANI__c=mapParameters.get('ANI'),
                CTI_Queue__c=queue,
                CTI_DNIS__c=mapParameters.get('DNIS'),
                CTI_CALL_ID__c=callId,
                ownerId = queueGroup.Id,
                CTI_Code__c = codCliente

            );
            System.debug('**chiamataInbound*****CASO EASY CM****** INSERISCO CASE'+System.now());
            insert theCase2;
            System.debug('**chiamataInbound*****CASO EASY CM****** CASE INSERITO'+System.now());
            //sforce.one.navigateToSObject(theCase2.id,);
            /*PageReference pg = new PageReference('/lightning/r/Case/'+theCase2.Id+'/view');
            pg.setRedirect(true);
            return pg;*/
            return redirectPage(theCase2.Id);
        }// EEASY CM
        /**
        else if(queue.toUpperCase()=='AFFARI-ECOMMERCE'){
            String codCliente=mapParameters.get('cti_CODICECLIENTE'); //case number mi aspetto idIncident da CTI
            
            Case theCase2=[select id from case where CaseNumber=:codCliente];           
            PageReference pg = new PageReference('/lightning/r/Case/'+theCase2.Id+'/view');
            pg.setRedirect(true);
            return pg;
        }
        ****/
        else if(queue.indexOf('AFFARI')>=0 && entita.toUpperCase()=='AFFARIHDFILIALI'){ // AFFARI FILIALI    
            Group queueGroup = [SELECT ID FROM GROUP WHERE DeveloperName = 'AFFARI_Inbound' LIMIT 1];
            String codFiliale=mapParameters.get('cti_CodiceUtente'); //identificativo filiale           
            System.debug('--- AFFARI HDFLIALI CODUTENTE '+codFiliale); 
            List<XCS_Categoria__c> categorie = [SELECT ID FROM XCS_Categoria__c where External_Id__c = :categoriaExternalAffari];
             if(codFiliale!=null && !codFiliale.equals('')){
                 System.debug('*******CASO AFFARIHDFILIALI CON CODICE FILIALE******');
                String toTransformFiliale='F'+String.valueOf(Integer.valueOf(codFiliale));
                Id recordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('GUA_Inbound').getRecordTypeId();
                //List<XCS_Categoria__c> categorie = [SELECT ID FROM XCS_Categoria__c where External_Id__c = :categoriaExternal];
                List<Account> objFiliale=[select id from account where OCS_External_Id__c=:toTransformFiliale AND Customer_Type__c ='Compass'];
                Case theCase2 = new Case(
                    //Subject = 'IO',
                    //Esito__c = 'TEST',
                    //Description = '{"ocsCode" : "229370","telephoneNumber" : "334 3355026","esitoSurvey" : "ok"}',
                //  Description=JSON.serialize(mapCTI),
                    branch__c= objFiliale.size()>0 ? objFiliale[0].id : null,
                    accountId=objFiliale.size()>0 ? objFiliale[0].id : null,
                    RecordTypeId = recordTypeId,
                    CTI_Entita__c=entita,
                    CTI_ANI__c=mapParameters.get('ANI'),
                    CTI_Queue__c=queue,
                    CTI_DNIS__c=mapParameters.get('cti_DNIS'),
                    CTI_CALL_ID__c=callId,
                    Categoria_Riferimento__c = categorie.size()>0? categorie[0].ID : null,
                    ownerId = queueGroup.Id,
                    CTI_Code__c = codFiliale
                    //Subject = 'Acquisizione Inbound'
                );
                 insert theCase2;
                //Case theCase2=[select id from case where recordtype.developername='GUA_Contact' and status='Ricevuto' and branch__r.OCS_External_Id__c=:codCliente LIMIT 1];           
                /*PageReference pg = new PageReference('/lightning/r/Case/'+theCase2.Id+'/view');
                pg.setRedirect(true);
                return pg;*/
                return redirectPage(theCase2.Id);
             } else{
                   System.debug('*******CASO AFFARIHDFILIALI SENZA CODICE FILIALE******');
                Id recordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('GUA_Inbound').getRecordTypeId();
                Case theCase2 = new Case(
                    //Subject = 'IO',                                                                            
                    RecordTypeId = recordTypeId,
                    CTI_Entita__c=entita,
                    CTI_CALL_ID__c=callId,
                    CTI_Queue__c=queue,
                    CTI_DNIS__c=mapParameters.get('cti_DNIS'),
                    CTI_ANI__c=mapParameters.get('ANI'),
                    ownerId = queueGroup.Id,
                    CTI_Code__c = codFiliale,
                    Categoria_Riferimento__c = categorie.size()>0? categorie[0].ID : null
                    //Subject = 'Acquisizione Inbound'
                );
                 insert theCase2;
                //Case theCase2=[select id from case where recordtype.developername='GUA_Contact' and status='Ricevuto' and branch__r.OCS_External_Id__c=:codCliente LIMIT 1];           
                /*PageReference pg = new PageReference('/lightning/r/Case/'+theCase2.Id+'/view');
                pg.setRedirect(true);
                return pg;*/
                return redirectPage(theCase2.Id);
             }                                  
        }
        else if(queue.indexOf('AFFARI')>=0 && entita.toUpperCase()!='AFFARIHDFILIALI'){ // AFFARI DEALER
            Group queueGroup = [SELECT ID FROM GROUP WHERE DeveloperName = 'AFFARI_Inbound' LIMIT 1];
            String codDealer=mapParameters.get('cti_CodiceUtente'); //identificativo dealer
            List<XCS_Categoria__c> categorie = [SELECT ID FROM XCS_Categoria__c where External_Id__c = :categoriaExternalAffari];
            if(codDealer!=null && !codDealer.equals('')){
                 System.debug('*******CASO AFFARI DEALER CON CODICE FILIALE******');
                String toTransformDealer='D'+String.valueOf(Integer.valueOf(codDealer));
                Id recordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('GUA_Inbound').getRecordTypeId();
                //List<XCS_Categoria__c> categorie = [SELECT ID FROM XCS_Categoria__c where External_Id__c = :categoriaExternal];
                
                List<Account> lstDealer=[select id from account where OCS_External_Id__c=:toTransformDealer];                
                Account objDealer = null;
                //if(lstDealer.size()==0) throw new BarraException('Dealer '+toTransformDealer+' not found');
                if(lstDealer.size()>0)
                    objDealer=lstDealer[0];
                Case theCase2 = new Case(
                    //Subject = 'IO',
                    //Esito__c = 'TEST',
                    //Description = '{"ocsCode" : "229370","telephoneNumber" : "334 3355026","esitoSurvey" : "ok"}',
                //  Description=JSON.serialize(mapCTI),
                    accountid= objDealer != null ? objDealer.Id:null,
                    RecordTypeId = recordTypeId,
                    CTI_Entita__c=entita,
                    CTI_CALL_ID__c=callId,
                    CTI_Queue__c=queue,
                    CTI_DNIS__c=mapParameters.get('cti_DNIS'),
                    CTI_ANI__c=mapParameters.get('ANI'),
                    ownerId = queueGroup.Id,
                    CTI_Code__c = codDealer,
                    
                    
                    Categoria_Riferimento__c = categorie.size()>0? categorie[0].ID : null
                    //Subject = 'Acquisizione Inbound'
                );
                insert theCase2;
                //Case theCase2=[select id from case where recordtype.developername='GUA_Contact' and status='Ricevuto' and Account.OCS_External_Id__c=:codCliente LIMIT 1];           
                /*PageReference pg = new PageReference('/lightning/r/Case/'+theCase2.Id+'/view');
                pg.setRedirect(true);
                return pg;*/
                return redirectPage(theCase2.Id);
            } else  {
                System.debug('*******CASO AFFARI DEALER SENZA CODICE FILIALE******');
                Id recordTypeId = Schema.SObjectType.Case.getRecordTypeInfosByDeveloperName().get('GUA_Inbound').getRecordTypeId();
                 Case theCase2 = new Case(
                    //Subject = 'IO',                                                                            
                    RecordTypeId = recordTypeId,
                    CTI_Entita__c=entita,
                     CTI_CALL_ID__c=callId,
                     CTI_Queue__c=queue,
                     CTI_DNIS__c=mapParameters.get('cti_DNIS'),
                     CTI_ANI__c=mapParameters.get('ANI'),
                     ownerId = queueGroup.Id,
                     CTI_Code__c = codDealer,
                     Categoria_Riferimento__c = categorie.size()>0? categorie[0].ID : null
                    //Subject = 'Acquisizione Inbound'
                );
                 insert theCase2;
                //Case theCase2=[select id from case where recordtype.developername='GUA_Contact' and status='Ricevuto' and Account.OCS_External_Id__c=:codCliente LIMIT 1];           
                /*PageReference pg = new PageReference('/lightning/r/Case/'+theCase2.Id+'/view');
                pg.setRedirect(true);
                return pg;*/
                return redirectPage(theCase2.Id);
            }           
        }
        //throw new BarraException('valori passati ENTITA: '+entita+' CLIENTE '+mapParameters.get('cti_CODICECLIENTE'));
        System.debug('--- NO rami '); 
        return null;
    }

    public Pagereference redirectPage(String caseId){
        PageReference pg = new PageReference('/lightning/r/Case/'+caseId+'/view');
        pg.setRedirect(true);
        System.debug('**chiamataInbound*****REDIRECT VERSO IL CASE******'+System.now());
        return pg;
    }

    public Case checkCallId (String callId){
        List<Case> cases = [SELECT Id FROM Case WHERE CTI_CALL_ID__c=:callId];
        if(cases.size()==0) return null;
        System.debug('---Trasferimento di chiamata--');
        return cases[0];
    }

    class BarraException extends Exception{}
}