//----------------------------------------------------------------------
//-- - Class Name   : CRMReclamiInserimentoContainerController
//-- - Autor        : 
//-- - Date         : 
//-- - Description  : Controller per il component CRMReclamiInserimentoContainer
//-- - Version      : 1.0
//----------------------------------------------------------------------

public without sharing class CRMReclamiInserimentoContainerController {  
    @AuraEnabled
    public static Case creaReclamo(String inputJson,String societa,List<Attachment> fileList,Case reclamoSelezionato, String coda, String codCategoria, Boolean delegaPresente,
                                   String comunicazione, String email, String tel)
    {
         
        String societaTxt = societa;
        System.debug('creaReclamo inputJson:'+inputJson);
        XCSReclamiInput data=XCSReclamiUtils.getInputObj(inputJson,societa);
        Case res =XCSReclamiUtils.creaReclamo(data,societa,fileList,reclamoSelezionato, coda, codCategoria, delegaPresente);
        System.debug('creaReclamo societa:'+societa+':comunicazione:'+comunicazione+':accessodati:'+res.Has_Acceso_Dati__c+':RecordTypeUtil.STANDARD_EMAIL:'+RecordTypeUtil.STANDARD_EMAIL);
        //CR
        if(comunicazione.equals('EMAIL_CLIENTE_APERTURA') || comunicazione.equals('EMAIL_TERZO_APERTURA')){
            OrgWideEmailAddress mittente;
            if(societa == 'Compass') mittente =[Select id from OrgWideEmailAddress where displayName = 'Compass S.p.A. Reclami'];
            if(societa == 'Futuro') mittente = [Select id from OrgWideEmailAddress where displayName = 'Futuro S.p.A. Reclami'];
            if(societa == 'MBCredit Solutions') mittente = [Select id from OrgWideEmailAddress where displayName = 'Creditech S.p.A. Reclami'];
           String testo='';
            
         
            if(societa == 'MBCredit Solutions') societaTxt = 'Creditech';
            List<Testo_Standard__c> testostandard = [SELECT Testo__c FROM Testo_Standard__c WHERE  Societa__c=:societaTxt AND Titolo__c =:comunicazione AND  Accesso_Dati_c__c =:res.Has_Acceso_Dati__c AND Recordtype.DeveloperName =: RecordTypeUtil.STANDARD_EMAIL LIMIT 1];
            System.debug(testoStandard);
            System.debug(societaTxt);
            System.debug(comunicazione);
            System.debug(RecordTypeUtil.STANDARD_TEXT);
           
            
            if (!testostandard.isEmpty()) {
                testo = testostandard[0].Testo__c;
            }

            Messaging.SingleEmailMessage emailMessage = new Messaging.SingleEmailMessage();
            List<String> toList = new List<String> {email};
            emailMessage.setToAddresses(toList);
            emailMessage.setOrgWideEmailAddressId(mittente.id);
            emailMessage.setSubject('Reclamo inserito');
            emailMessage.setHtmlBody(testo);
            Messaging.sendEmail(new List<Messaging.SingleEmailMessage> { emailMessage });
            String body='Destinatario: ' + email + '\n';
            body+='--------------------------------------------\n';
            body+=testo;
            body=body.replaceAll('<BR>', '\n');
            body=body.replaceAll('<br>', '\n');
            XCSReclamiUtils.creaCorrispondenza(res, body, new List<Attachment>());
        }
        
        else if(comunicazione.equals('SMS_CLIENTE_APERTURA')  || comunicazione.equals('SMS_TERZO_APERTURA')){
            XCS_Messaggio__c messaggio = new XCS_Messaggio__c();
            messaggio.RecordtypeId = [Select id from RecordType where DeveloperName = 'SMS' and SobjectType = 'XCS_Messaggio__c' limit 1].Id;
            messaggio.Numero__c = tel;
            messaggio.CompanyType__c = 'COMPASS';
            messaggio.tipo__c = 'WEB2';
            String testo='';        
           
            List<Testo_Standard__c> testostandard = [SELECT Testo__c FROM Testo_Standard__c WHERE  Societa__c=:societaTxt AND Titolo__c =:comunicazione AND  Accesso_Dati_c__c =:res.Has_Acceso_Dati__c AND Titolo__c =:comunicazione AND Recordtype.DeveloperName =: RecordTypeUtil.STANDARD_EMAIL LIMIT 1];
            if (!testostandard.isEmpty()) {
                testo = testostandard[0].Testo__c;
            }

            
            
            messaggio.testo__c = testo;
            insert messaggio;
            String body = 'SMS inviato a: '+tel;
            body+='\n--------------------------------------------\n';
            body+=testo;
            body=body.replaceAll('<BR>', '\n');
            body=body.replaceAll('<br>', '\n');
            XCSReclamiUtils.creaCorrispondenza(res, body, new List<Attachment>());
            
        }
        
        //CR
        
        
        XCS_Categoria__c cat = [Select id, External_id__c from XCS_Categoria__c where external_id__c = :codCategoria limit 1];
        //Frode
        CRMReclamiGestioneContainerController.isFrodeCTRL(cat.External_id__c, societa, res.id);
        
        //Inadempimento
        List<Case> listaCase = new List<Case>();
        Boolean isInadempimento = XCSReclamiUtils.isGrave(cat.External_Id__c, societa);
        if(isInadempimento){
              System.debug('creaReclamo res.Branch__c:'+res.Branch__c);
            Account filialeAcc = [Select id, Ocs_external_id__c from Account where id = :res.Branch__c];
            Group codaFiliale = [Select id from Group Where developerName =: filialeAcc.Ocs_external_id__c];
            res.stage_Inadempimento__c = '4165';
            //Creazione 2 incident
            Case primoCase = new Case();
          //Case secondoCase = new Case();
            primoCase.Subject = 'Apertura reclamo';
            primoCase.Disposition__c = res.Disposition__c;
            primoCase.Numero_Progressivo_Reclamo__c = res.Numero_Progressivo_Reclamo__c;
            primoCase.AccountId	= res.AccountId;
            primoCase.Tipo_Pratica__c = res.Tipo_Pratica__c;
            primoCase.categoria_riferimento__c  = res.categoria_riferimento__c ;
            primoCase.tipo_reclamo__c = res.tipo_reclamo__c;
            primoCase.Inadempimento_Grave__c = true;
            primoCase.tipo_pratica__c = res.Tipo_Pratica__c;
            primoCase.Numero_reclamo__c = res.Numero_reclamo__c;
            primoCase.NumeroPratica__c = res.NumeroPratica__c;
            primoCase.Data_Ricezione__c = res.data_ricezione__c;
            primoCase.Status = 'Ricevuto';
            primoCase.parentId=res.Id;
            primoCase.recordtypeid=res.recordtypeid;
            primoCase.Referenced_Company__c = res.Referenced_Company__c;
            primoCase.ownerId = codaFiliale.id; 
            primoCase.parentId = res.id;
            //primoCase.ActivityType__c = 'Verifica Inadempimento';
         	listaCase.add(primoCase);
            listaCase.add(res);
            //secondoCase = primoCase.clone();
            //secondoCase.ownerId = CODA MONITORAGGIO;
           // listaCase.add(secondoCase);
            upsert listaCase;
 			
        }
        

        
        return res;  
    }
    
    
    
    public static void getNomeFiliale(String SFId){
        
        Boolean isNomeFilialePresente = false;
        Boolean isInadempimento = false;
        //Case reclamoSelezionato = [SELECT Id, Branch__c, Branch__r.Name FROM Case WHERE Branch__c = : SFId LIMIT 1];
        String nomeFiliale = [SELECT Id, Branch__c, Branch__r.Name FROM Case WHERE Branch__c = : SFId LIMIT 1].Branch__r.Name;
        
        if (nomeFiliale != null){
            isNomeFilialePresente = true;
        } else
            nomeFiliale = '';
         
       /* isInadempimento = CRMReclamiInserimentoContainerController.isInadempimentoSelected(categoriaDettagli);
        
        if(isInadempimento){
            XCSChatterUtils.postMessageWithMention(nomeFiliale, reclamoSelezionato.Id, message, isNomeFilialePresente);
            XCSChatterUtils.postMessageWithMention('Monitoraggio Dealer', reclamoSelezionato.Id, message, isNomeFilialePresente);


        }*/
       
    }
    
    @AuraEnabled
    public static Boolean isInadempimentoSelected(XCS_Categoria__c categoriaDettagli){
        System.debug('categoria dettagli = ' + categoriaDettagli);
        categoriaDettagli = [Select id, name,External_Id__c, Livello__c, Parent__c FROM XCS_Categoria__c Where id = :categoriaDettagli.Id];
        List<XCS_Categoria__c> allCategories = [SELECT Id, Name, External_Id__c, Livello__c, Parent__c FROM XCS_Categoria__c ];
        Double livelloCategoria = categoriaDettagli.Livello__c; 
        String parentId = categoriaDettagli.Parent__c != null ? categoriaDettagli.Parent__c : '' ;
        String categoriaName = categoriaDettagli.Name;
        Boolean isInadempimentoSelected = false;
		System.debug('parentId = '+parentId);        
        if (categoriaName.equalsIgnoreCase('Inadempimento')){
            isInadempimentoSelected = true;
            return isInadempimentoSelected;
        }
        
        for (Double i = livelloCategoria; i > 0; i-- ) {
            if (parentId != null || parentId != '' ){
                for(XCS_Categoria__c cat : allCategories){
                    if ((cat.Id).equals(parentId)){
                        System.debug('sono nell if');
                        System.debug('cat.Parent__c if = ' + cat.Parent__c);
                        parentId = cat.Parent__c;
                        categoriaName = cat.Name;
                        if (categoriaName.equalsIgnoreCase('Inadempimento')){
                            isInadempimentoSelected = true;
                            return isInadempimentoSelected;
                        }
                        else
                            break; //se la categoria non presenta il campo "Inadempimento", allora si esce dal ciclo e si verifica la presenza di Inadempimento ad un altro livello (tramite ParentId)
                    }
                    //fine ciclo for interno
                }
            }
            else
            {
                if(categoriaName != null){
                    return isInadempimentoSelected;
                }//se parentId è null vuol dire che siamo arrivati in cima alla gerarchia, dunque se nemmeno all'ultimo livello della gerarchia la categoria presenta il nome "inadempimento", significherà che tale categoria non è associata al valore "Inadempimento"
            }
            //fine ciclo for esterno
        }
        return isInadempimentoSelected;
    }
    
    @AuraEnabled
    public static void sendEmailForwardAndTrackFrode(String recordId){
        

    }
    
 
    
    @AuraEnabled
    public static void postOnChatterInadempimento(String recordId){   
        String fAndTbaseUrl = [SELECT Id, Value__c FROM XCS_CompassParameters__c WHERE Name = 'forwardandtrack.baseurl'][0].Value__c;
        String urlFAndT = fAndTbaseUrl+'?token='+SitesTokenUtil.generateToken(Id.valueOf(recordId),datetime.now().addMinutes(400),'c:CRMReclamiInadempimentoForwardAndTrack','c:CRMReclamiInadempimentoForwardAndTrackApp');
        String message = 'Aggiornamento inadempimento scritto' + '\n' + urlFAndT;
        
        
        if (!Test.isRunningTest()) {XCSChatterUtils.postMessageWithMention('Monitoraggio Dealer', recordId, message, true);}
        
    }
    
    @AuraEnabled
    public static void insertFeedItem(String recordId){
        Case c = [Select id, Owner.Name, DataSegnalazione__c, Data_Ricezione__c, Data_Ricezione_IDM__c, OwnerId FROM Case Where id = :recordId];
        List<Reclami_Timestamp__c> lista = new List<Reclami_Timestamp__c>();
       
// MODIFICA PER INSERIRE UN TIME A 00:00 

        
        Time t = Time.newInstance(0, 0, 0, 0);
        dateTime dt;

        dt = Datetime.newInstance(c.DataSegnalazione__c, t);
//        lista.add(XCSReclamiUtils.createFeedItem(recordId, c.DataSegnalazione__c, 'complaint dated',  UserInfo.getName(), false));
        lista.add(XCSReclamiUtils.createFeedItem(recordId, dt, 'complaint dated',  UserInfo.getName(), false));

        dt = Datetime.newInstance(c.Data_Ricezione__c, t);
//        lista.add(XCSReclamiUtils.createFeedItem(recordId, c.Data_Ricezione__c, 'complaint received',  UserInfo.getName(), false));
        lista.add(XCSReclamiUtils.createFeedItem(recordId, dt, 'complaint received',  UserInfo.getName(), false));

        dt = Datetime.newInstance(c.Data_Ricezione_IDM__c, t);
//        lista.add(XCSReclamiUtils.createFeedItem(recordId, c.Data_Ricezione_IDM__c, 'ricezione idm',  UserInfo.getName(), false));
        lista.add(XCSReclamiUtils.createFeedItem(recordId, dt, 'ricezione idm',  UserInfo.getName(), false));

        lista.add(XCSReclamiUtils.createFeedItem(recordId, System.now(), 'complaint entered',  UserInfo.getName(), true));
        if((c.OwnerId+'').startsWith('00G'))lista.add(XCSReclamiUtils.createFeedItem(recordId, System.now(), 'assigned to queue', c.Owner.Name, true));
        insert lista;
     }


    @AuraEnabled
    public static string pathOrg(){
        system.debug('---------------------------------------------------------------------------------------');
        system.debug('-- Class Name: CRMReclamiInserimentoContainerController - Method Name: pathOrg'); 
        
        String urlInstance = String.valueOf(System.Url.getSalesforceBaseUrl().getHost());
        String s2=urlInstance.removeEndIgnoreCase('.my.salesforce.com');
        return s2;
    }
//--------------------------------------------------------------------
//-- - FINE MODIFICA
//--------------------------------------------------------------------
    
}