public class SFA_PraticheIrregolari_BatchCrePrat implements Database.Batchable<String>, Database.Stateful, Database.AllowsCallouts {

    List<String> dtos;
    Map<String, Integer> fieldNumberMap = new Map<String, Integer>();
    String caseId;
    Integer fieldNumber;
    String fieldValue;
    String fieldValue2; 
    Boolean scartare;
    Boolean trovato;
    Boolean skip;
    Date dataScadenza;
    boolean errorCatch = false;
    String errorCatchMessage;
    public List<String> csvFieldNames;
    List<String> lstDealerId = new List<String>();
    Map<String, Id> dealerCodOCSIdMap = new Map<String, Id>();
    List<String> lstFieldNames = new List<String>();       
    List<String> lstCodiciPratiche = new List<String>(); 
    Case case1 = new Case();
    List<SFA_PraticaIrregolare__c> lstPraticheTutte = new List<SFA_PraticaIrregolare__c>();        
    List<SFA_PraticaIrregolare__c> lstPraticheOK = new List<SFA_PraticaIrregolare__c>();   
    List<SFA_PraticaIrregolare__c> lstPraticheDealerNotFound = new List<SFA_PraticaIrregolare__c>();
    List<SFA_PraticaIrregolare__c> lstPraticheBranchDealerNotFound = new List<SFA_PraticaIrregolare__c>(); 
    Map<String, String> dealerIdToBranchNameMap = new Map<String, String>();
    Map<String, String> dealerBranchMap = new Map<String, String>();
    List<Case> lstAttivita_by_dealer_e_irregolarita = new List<Case>();
    Map<String,Case> mapLstAttivita_by_dealer_e_irregolarita = new map<String,Case>();
    List<Account> lstDealer; 
    
    List<Account> lstBranch = [SELECT Id, Name, OCS_External_Id__c 
                               FROM Account 
                               WHERE RecordType.Name = 'Branch'];
    List<ContentVersion> conVer;
	List<String> lstBranchId = new List<String>();
	//conVer = [SELECT VersionData FROM ContentVersion WHERE Id = :fileId AND IsLatest = true];
    
	public SFA_PraticheIrregolari_BatchCrePrat(wrapBatchInit wrap) {
        try{
            List<String> csvFieldNames = wrap.csvFieldNames;
            this.csvFieldNames = csvFieldNames;
              for (Integer i = 0; i < csvFieldNames.size(); i++) {
                            fieldNumberMap.put(csvFieldNames[i], i);
                            lstFieldNames.add(csvFieldNames[i].trim());
                        }
            List<String> dealerOCSIdList = new List<String>();
            for (Integer i = 1; i < wrap.recordCSV.size(); i++) {
                        string[] csvRecordData = wrap.recordCSV[i].split(';');               
                        for (String fieldName: csvFieldNames) {
                            fieldNumber = fieldNumberMap.get(fieldName);
                            fieldValue2 = csvRecordData[fieldNumber];
                            if (fieldName == 'Cod Dealer'){
                                dealerOCSIdList.add('D'+fieldValue2);}
                            }
                   } 
 
        this.lstDealer = [SELECT Id, Name, RecordType.Name, OCS_External_Id__c, ParentId, Branch__r.OCS_External_Id__c 
                               FROM Account 
                               WHERE RecordType.Name = 'Dealer' and OCS_External_Id__c IN :dealerOCSIdList ]; 
            
        conVer = [SELECT VersionData FROM ContentVersion WHERE Id = :wrap.fileid AND IsLatest = true];
		this.caseId = wrap.caseId;
        dataScadenza = wrap.dataScadenza;
        this.dtos = wrap.recordCSV;
        case1 = [SELECT Id, Status, CaseNumber FROM Case WHERE Id = :caseId][0];
        
        for (Account branch:lstBranch){
                String branchId = branch.OCS_External_Id__c;
                lstBranchId.add(branchId);
            }
        for (Account deal : lstDealer) {
                lstDealerId.add(deal.OCS_External_Id__c);
                if (!String.isEmpty(deal.OCS_External_Id__c)){
                    dealerCodOCSIdMap.put(deal.OCS_External_Id__c.substring(1, deal.OCS_External_Id__c.length()),deal.Id);  
                }
                
                for (Account branch: lstBranch){
                    if(deal.Branch__r.OCS_External_Id__c==branch.OCS_External_Id__c){
                        dealerBranchMap.put(deal.Name,branch.Name);
                        dealerIdToBranchNameMap.put(deal.Id, branch.Name);
                    }
                }
            }
        }catch(Exception ex)
        {
        	errorCatch = true;
           	errorCatchMessage = ex.getMessage();
            
        } 
               }
	
	public Iterable<String> start(Database.BatchableContext context) {
        return this.dtos;
    }

	public void execute(Database.BatchableContext context, List<String> csvRows)
    {  
        try{
            
        
        Boolean skip = null;   
       // lstAttivita_by_dealer_e_irregolarita = new List<Case>();
        
        for (Integer i = 0; i < csvFieldNames.size(); i++) {
                            fieldNumberMap.put(csvFieldNames[i], i);
                            lstFieldNames.add(csvFieldNames[i].trim());
                        }
            
            Datetime today = Datetime.Now();
            Id dealerOCS;
            for (Integer i = 0; i < csvRows.size(); i++) {
                		skip=false;
                        string[] csvRecordData = csvRows[i].split(';');
                        SFA_PraticaIrregolare__c pratica = new SFA_PraticaIrregolare__c(); 
                        pratica.DataInserimento__c=today;
                		pratica.ActivityId__c=caseId;
                        pratica.DataTermineLavoro__c = dataScadenza;   
                        pratica.Subject__c = 'Pratiche Irregolari';  		                
                         
                        system.debug('########'+csvFieldNames);  
                              
                        for (String fieldName: csvFieldNames) {
                            fieldNumber = fieldNumberMap.get(fieldName);
                            fieldValue = csvRecordData[fieldNumber];
                            System.debug(fieldName + ' : ' + fieldValue);
                            if (fieldName == 'Cod Dealer'){
                                pratica.CodiceDealer__c = fieldValue;}
                            if (fieldName == 'Cod Punto vendita'){
                                pratica.CodicePv__c = fieldValue;}  
                            else if (fieldName == 'Stato Dealer'){
                                pratica.CodiceStatoDealer__c = fieldValue;}
                            else if (fieldName == 'Ragione Sociale'){
                                pratica.RagioneSociale__c = fieldValue;}
                            else if (fieldName == 'Codice Pratica') {
                                if(lstCodiciPratiche.contains(fieldValue)){
                                    skip=true;
                                } else {
                                    pratica.NumeroPratica__c = fieldValue;
                                    pratica.Name = fieldValue;   
                                    lstCodiciPratiche.add(fieldValue);
                                }

                            }
                            else if (fieldName == 'Stato Prat'){
                                pratica.CodiceStatoPratica__c = fieldValue;}
                            else if (fieldName == 'Saldo Totale'){
                                pratica.SaldoTotale__c = fieldValue;}
                            else if (fieldName == 'CURDEL'){
                                pratica.Curdel__c = fieldValue;}
                            else if (fieldName == 'Data Liquidaz'){
                                pratica.DataMandatoLiquidazione__c = fieldValue;}
                            else if (fieldName == 'Dipend'){
                                pratica.Dipendenza__c = fieldValue;}
                            else if (fieldName == 'Riscont Agenzia'){
                                pratica.RiscontroAgenziaItalia__c = fieldValue;}
                            else if (fieldName == 'Riscont Definit'){
                                pratica.RiscontroFinale__c = fieldValue;}
                            else if (fieldName == 'Data Estrazione'){
                                pratica.DataEstrazione__c = fieldValue;}
                            else if (fieldName == 'Data Ricezione'){
                                pratica.DataRicezione__c = fieldValue;}
                            else if (fieldName == 'Targa restituita'){
                                pratica.Targa__c = fieldValue;}
                            else if (fieldName == 'Telaio'){     
                                pratica.Telaio__c = fieldValue;}
                            else if (fieldName == 'Irregolarità')  {    
                                system.debug(fieldValue);
                                pratica.Irregolarita__c = fieldValue;}
                            else if (fieldName == 'NOTE AGENZIA ITALIA'){
                                pratica.NoteAgenziaItalia__c = fieldValue;}
                            else if (fieldName == 'WARNING'){
                                pratica.Warning__c = fieldValue;}
                        }
                        
                	    if(!skip){   //non skip, quindi la stessa pratica non è stata già censita nello stesso file CSV appena caricato 
                                //recupero il resto di dati necessari da OCS:
                                Map<String, String> fieldInputs = new Map<String, String>();
                                fieldInputs.put('numPratica', pratica.NumeroPratica__c);
                                fieldInputs.put('filtroTipoPratica', 'CO');
                                fieldInputs.put('flagInfoCliente', 'true');   
                                OCSRecuperaDatiPostvenditaResponse response = OCSRecuperaDatiPostvenditaInvoker.callRecDatiPV(fieldInputs);
                                //System.debug('°°°°°°°°°°°°°°°°°°°° DATI POST VENDITA RESPONSE'+JSON.serialize(response));
                            scartare=false;
                            if(response.cliente != null && response.cliente.size() > 0){
                                
                           
                            	pratica.ClienteNome__c=response.cliente[0].nome+' '+response.cliente[0].cognome;  
                                pratica.ClienteCodiceFiscale__c=response.cliente[0].codFiscale;
                                pratica.ClienteNatoIl__c=response.cliente[0].dataNascita;
                                pratica.ClienteNatoA__c=response.cliente[0].luogoNascita;             
                                pratica.ClienteNatoProvincia__c=response.cliente[0].provNascita;
                                pratica.ClienteResidenza__c=response.cliente[0].indirizzo+' '+ response.cliente[0].cap +' '+ response.cliente[0].localita  +' '+ response.cliente[0].provincia+' '+response.cliente[0].paeseEstero;  //mettere paese estero che eventualmente conterrà Italia nel caso in cui il clienete risieda in Italia?
                                if (response.pratiche != null && response.pratiche.size() > 0 && response.pratiche[0].elencoCoobbligati.size()>0){
                                    pratica.CoobbligatoNome__c=response.pratiche[0].elencoCoobbligati[0].nome+' '+response.pratiche[0].elencoCoobbligati[0].cognome;
                                    pratica.CoobbligatoNatoProvincia__c=response.pratiche[0].elencoCoobbligati[0].provNascita;
                                    pratica.CoobbligatoNatoIl__c=response.pratiche[0].elencoCoobbligati[0].dataNascita;
                                    pratica.CoobbligatoNatoA__c=response.pratiche[0].elencoCoobbligati[0].luogoNascita;
                                    pratica.CoobbligatoCodiceFiscale__c=response.pratiche[0].elencoCoobbligati[0].codFiscale;                   
                                }
 								
                                                
                                //recupero dati veicolo:
                                OCS_recuperaInfoPraticaResponse res = OCS_recuperaInfoPraticaInvoker.callAggiornaDati(pratica.NumeroPratica__c);
                                //System.debug('°°°°°°°°°°°°°°°°°°°° DATI INFO PRATICA RESPONSE'+JSON.serialize(res));
                            	pratica.targa__c=res.recuperaInfoPraticaResponse.targa;
                                pratica.telaio__c=res.recuperaInfoPraticaResponse.telaio;
                                pratica.VeicoloImmatricolazione__c=res.recuperaInfoPraticaResponse.annoMeseImmatricolazione;
                                pratica.VeicoloModello__c=res.recuperaInfoPraticaResponse.marcaModello;
                                pratica.VeicoloDescrizione__c=res.recuperaInfoPraticaResponse.descrizioneBene;
                                pratica.VeicoloProdotto__c=res.recuperaInfoPraticaResponse.prodotto;
                				
                            
                            	}
                            else{
                                scartare = true;
                                pratica.EsitoCaricamento__c='Nessun Informazione sul cliente trovato su OCS';
                            }
                                
                                
                                if (!lstDealerId.contains('D' + csvRecordData[fieldNumberMap.get('Cod Dealer')])) { 
                                    pratica.EsitoCaricamento__c='Dealer Non Censito';
                                    lstPraticheDealerNotFound.add(pratica);
                                    scartare=true;
                                } else {
                                    for (Account dealer : lstDealer) {
                                        if (dealer.OCS_External_Id__c == 'D' + pratica.CodiceDealer__c && (!lstBranchId.contains(dealer.Branch__r.OCS_External_Id__c) || dealer.Branch__r.OCS_External_Id__c==null) )
                                          { 
                                            pratica.EsitoCaricamento__c='Branch Dealer Non Censito';
                                            lstPraticheBranchDealerNotFound.add(pratica);
                                            scartare=true;
                                            break;  
                                          }                                       
                                    } 
                                }
                                if (!scartare){  
                                    pratica.EsitoCaricamento__c='Pratica caricata';
                                    pratica.Status__c='Pratica - da Gestire';   
                                    if (pratica.RiscontroAgenziaItalia__c.contains('E20')){        
                                        pratica.CodiceTipoPratica__c='E20';}
                                    else if (integer.valueOf(pratica.Curdel__c)> 2){    
                                        pratica.CodiceTipoPratica__c='REC';}
                                    else if (integer.valueOf(pratica.Curdel__c)<= 2){ 
                                        pratica.CodiceTipoPratica__c='IRR';}
                                    
                                    trovato=false;
                                    
                                    /// ?????? FINISH
                                    for (Case attivita:lstAttivita_by_dealer_e_irregolarita){
                                        System.debug('Attivita Dealer');
                                        if(attivita.CodiceDealer__c==pratica.CodiceDealer__c && attivita.Irregolarita__c==pratica.CodiceTipoPratica__c){
                                            System.debug('************SON DENTRO' + pratica.CodiceTipoPratica__c );
                                            trovato=true;  
                                            break;
                                        }
                                    }
                                    if (!trovato){  
                                        Case attivita = new Case(); 
                                        attivita.ActivityType__c = 'SFA_PRAIRR';  
                                        attivita.Status = 'Closed';
                                        attivita.Subject = 'Pratiche Irregolari';
                                        attivita.ParentId = caseId;                    
                                        attivita.Irregolarita__c=pratica.CodiceTipoPratica__c;     
                                        attivita.CodiceDealer__c=pratica.CodiceDealer__c;
                                        dealerOCS=dealerCodOCSIdMap.get(pratica.CodiceDealer__c);
                                        attivita.AccountId=dealerOCS;
                                        attivita.DataTermineLavoro__c=pratica.DataTermineLavoro__c;
                                        lstAttivita_by_dealer_e_irregolarita.add(attivita);
                                        if(mapLstAttivita_by_dealer_e_irregolarita.get(attivita.CodiceDealer__c+attivita.Irregolarita__c) == null)
                                        {
                                            mapLstAttivita_by_dealer_e_irregolarita.put(attivita.CodiceDealer__c+attivita.Irregolarita__c,attivita);
                                        }   
                                    }
                                    lstPraticheOK.add(pratica); 
                                 }        
                
                                lstPraticheTutte.add(pratica);
                      	}
                   } 
        }catch(Exception ex)
        {
        	errorCatch = true;
           	errorCatchMessage = ex.getMessage();
            
        } 
    }
    
    public void finish(Database.BatchableContext context) {
        try{
            
        
        
         insert lstAttivita_by_dealer_e_irregolarita;
              
          
            //vedere se nel nuovo csv caricato ci sono cariche già presenti su salesforce, se si aggiornarle altrimenti inserirle come pratiche nuove
			List<SFA_PraticaIrregolare__c> lstpraticheToUpdate = new List<SFA_PraticaIrregolare__c>();
            List<SFA_PraticaIrregolare__c> lstpraticheToInsert = new List<SFA_PraticaIrregolare__c>(); 
            List<String> lstPraticheGiaPresentiCodici = new List<String>(); 
             
            List<SFA_PraticaIrregolare__c> praticheGiaPresenti = [SELECT Id, CoobbligatoNome__c,ActivityId__c,CoobbligatoCodiceFiscale__c,CoobbligatoNatoA__c,CoobbligatoNatoIl__c,CoobbligatoNatoProvincia__c,
                                                                  NumeroPratica__c,NomeBranch__c,NomeDealer__c,DataTermineLavoro__c,CodicePv__c,CodiceStatoDealer__c,
                                                                  RagioneSociale__c,CreatedById,CodiceStatoPratica__c,SaldoTotale__c,Curdel__c,DataMandatoLiquidazione__c,Dipendenza__c,
                                                                  RiscontroAgenziaItalia__c, RiscontroFinale__c, DataEstrazione__c, DataRicezione__c, Targa__c, Telaio__c, 
                                                                  Irregolarita__c, NoteAgenziaItalia__c,Warning__c,EsitoCaricamento__c, Status__c,
                                                                  FlagModuloInterazioneVeicoliMI__c, FlagPosticipoRichiesto__c,FlagSospensioneAttivitaTemporaneaGDV__c,
                                                                  FlagTargaTelaioDiversi__c,DataPosticipoRichiestadaFiliale__c,FlagEscludiAttivita__c,DataAggiornamentoOCS__c,CodiceTipoPratica__c FROM SFA_PraticaIrregolare__c 
                                                                  WHERE SFA_PraticaIrregolare__c.NumeroPratica__c IN :lstCodiciPratiche];  
            Map<String,SFA_PraticaIrregolare__c> mapPraticaIrregolareGiaPresente = new map<String,SFA_PraticaIrregolare__c>();  
            if (praticheGiaPresenti.size()<1){                
                insert lstPraticheTutte;
            } else {
                    for (SFA_PraticaIrregolare__c praticaGiaPresente : praticheGiaPresenti) {
                          //  lstPraticheGiaPresentiCodici.add(praticaGiaPresente.NumeroPratica__c);
                        if(mapPraticaIrregolareGiaPresente.get(praticaGiaPresente.NumeroPratica__c) == null)
                        {
                           mapPraticaIrregolareGiaPresente.put(praticaGiaPresente.NumeroPratica__c,praticaGiaPresente);
                        }
                    }
                    for(SFA_PraticaIrregolare__c pratica:lstPraticheTutte){                            
                       // for (SFA_PraticaIrregolare__c praticaGiaPresente : praticheGiaPresenti) {
                        if (mapPraticaIrregolareGiaPresente.get(pratica.NumeroPratica__c)!= null){//pratica.NumeroPratica__c==praticaGiaPresente.NumeroPratica__c){
                            	SFA_PraticaIrregolare__c praticaGiaPresente = mapPraticaIrregolareGiaPresente.get(pratica.NumeroPratica__c);
                                praticaGiaPresente.DataPosticipoRichiestadaFiliale__c=pratica.DataPosticipoRichiestadaFiliale__c;
                                praticaGiaPresente.FlagEscludiAttivita__c=pratica.FlagEscludiAttivita__c;
                                praticaGiaPresente.Irregolarita__c=pratica.Irregolarita__c;
                                praticaGiaPresente.CodiceTipoPratica__c=pratica.CodiceTipoPratica__c;
                                praticaGiaPresente.DataPosticipo__c=pratica.DataPosticipo__c;
                                praticaGiaPresente.DataAggiornamentoOCS__c=pratica.DataAggiornamentoOCS__c;
                                praticaGiaPresente.DataInserimento__c=pratica.DataInserimento__c; 
                                praticaGiaPresente.DataTermineLavoro__c=pratica.DataTermineLavoro__c;                                  
                                praticaGiaPresente.CodicePv__c=pratica.CodicePv__c;  
                                praticaGiaPresente.ActivityId__c =pratica.ActivityId__c; 
                                //praticaGiaPresente.IdElaborazione__c =pratica.IdElaborazione__c;
                                praticaGiaPresente.CodiceDealer__c=pratica.CodiceDealer__c;
                                praticaGiaPresente.CodiceStatoDealer__c=pratica.CodiceStatoDealer__c;
                                praticaGiaPresente.RagioneSociale__c=pratica.RagioneSociale__c;
                                praticaGiaPresente.CodiceStatoPratica__c=pratica.CodiceStatoPratica__c;
                                praticaGiaPresente.SaldoTotale__c=pratica.SaldoTotale__c;
                                praticaGiaPresente.Curdel__c=pratica.Curdel__c;
                                praticaGiaPresente.DataMandatoLiquidazione__c=pratica.DataMandatoLiquidazione__c;
                                praticaGiaPresente.Dipendenza__c=pratica.Dipendenza__c;
                                praticaGiaPresente.RiscontroAgenziaItalia__c=pratica.RiscontroAgenziaItalia__c;
                                praticaGiaPresente.RiscontroFinale__c=pratica.RiscontroFinale__c;
                                praticaGiaPresente.DataEstrazione__c=pratica.DataEstrazione__c;
                                praticaGiaPresente.DataRicezione__c=pratica.DataRicezione__c;
                                praticaGiaPresente.Targa__c=pratica.Targa__c;
                                praticaGiaPresente.Telaio__c=pratica.Telaio__c;
                                praticaGiaPresente.NoteAgenziaItalia__c=pratica.NoteAgenziaItalia__c;
                                praticaGiaPresente.Warning__c=pratica.Warning__c;
                                praticaGiaPresente.EsitoCaricamento__c=pratica.EsitoCaricamento__c;
                                praticaGiaPresente.Status__c=pratica.Status__c;
                                praticaGiaPresente.FlagModuloInterazioneVeicoliMI__c=false;
                                praticaGiaPresente.FlagPosticipoRichiesto__c=false;
                                praticaGiaPresente.FlagSospensioneAttivitaTemporaneaGDV__c=false;
                                praticaGiaPresente.FlagTargaTelaioDiversi__c=false;
                                praticaGiaPresente.targa__c=pratica.targa__c;
                                praticaGiaPresente.telaio__c=pratica.telaio__c;
                                praticaGiaPresente.VeicoloImmatricolazione__c=pratica.VeicoloImmatricolazione__c;
                                praticaGiaPresente.VeicoloModello__c=pratica.VeicoloModello__c;
                                praticaGiaPresente.VeicoloDescrizione__c=pratica.VeicoloDescrizione__c;
                                praticaGiaPresente.VeicoloProdotto__c=pratica.VeicoloProdotto__c;
                                praticaGiaPresente.ClienteCodiceFiscale__c=pratica.ClienteCodiceFiscale__c;
                                praticaGiaPresente.ClienteNatoIl__c=pratica.ClienteNatoIl__c;
                                praticaGiaPresente.ClienteNatoA__c=pratica.ClienteNatoA__c;
                                praticaGiaPresente.ClienteNatoProvincia__c=pratica.ClienteNatoProvincia__c;
                                praticaGiaPresente.ClienteResidenza__c=pratica.ClienteResidenza__c;  
                                praticaGiaPresente.ClienteNome__c=pratica.ClienteNome__c;
                                praticaGiaPresente.CoobbligatoNome__c=pratica.CoobbligatoNome__c;
                                praticaGiaPresente.CoobbligatoNatoProvincia__c=pratica.CoobbligatoNatoProvincia__c;
                                praticaGiaPresente.CoobbligatoNatoIl__c=pratica.CoobbligatoNatoIl__c;
                                praticaGiaPresente.CoobbligatoNatoA__c=pratica.CoobbligatoNatoA__c;
                                praticaGiaPresente.CoobbligatoCodiceFiscale__c=pratica.CoobbligatoCodiceFiscale__c;                                
                              	lstpraticheToUpdate.add(pratica);
                            // break;
                        }
                        else{
                             lstpraticheToInsert.add(pratica);
                        }
                    	//}
                      //  if (lstPraticheGiaPresentiCodici.contains(pratica.NumeroPratica__c)){
                     //       lstpraticheToUpdate.add(pratica);
                     //   } else {
                     //       lstpraticheToInsert.add(pratica);
                     //   }                         
                    }
                insert lstpraticheToInsert;
            	update praticheGiaPresenti;
                }            
            
            
            
            //associazione delle pratiche alle relative attività
			List<SFA_PraticaIrregolare__c> lstPraticheOKinserite = [SELECT Id, NumeroPratica__c, CodiceDealer__c, Irregolarita__c,CodiceTipoPratica__c,
                                                                    ActivityId__c, NomeFiliale__c FROM SFA_PraticaIrregolare__c 
                                                                  WHERE ActivityId__c=:caseId AND EsitoCaricamento__c=:'Pratica caricata'];                        
            //// FIX APEX TIMEOUT
           // Map<String,Case> mapLstAttivita_by_dealer_e_irregolarita = new map<String,Case>();
   //         for (Case attivita:lstAttivita_by_dealer_e_irregolarita){
     //           if(mapLstAttivita_by_dealer_e_irregolarita.get(attivita.CodiceDealer__c+attivita.Irregolarita__c) == null)
     //           {
      //              mapLstAttivita_by_dealer_e_irregolarita.put(attivita.CodiceDealer__c+attivita.Irregolarita__c,attivita);
      //          }
                
     //       }
            
            for (SFA_PraticaIrregolare__c pratica:lstPraticheOKinserite){ 
                    //for (Case attivita:lstAttivita_by_dealer_e_irregolarita){  
                        //if(attivita.CodiceDealer__c==pratica.CodiceDealer__c && attivita.Irregolarita__c==pratica.Irregolarita__c){
                if(mapLstAttivita_by_dealer_e_irregolarita.get(pratica.CodiceDealer__c+pratica.CodiceTipoPratica__c) != null){
                    Case c = mapLstAttivita_by_dealer_e_irregolarita.get(pratica.CodiceDealer__c+pratica.CodiceTipoPratica__c);
                    pratica.ActivityId__c=c.Id;
                    pratica.NomeFiliale__c = dealerIdToBranchNameMap.get(c.AccountId);
                    //pratica.ActivityId__c=attivita.Id;
                    //pratica.NomeFiliale__c = dealerIdToBranchNameMap.get(attivita.AccountId);
                    /*System.debug('*** attivita.AccountId :: ' + attivita.AccountId);
					System.debug('*** attivita.Account.Branch__c :: ' + attivita.Account.Branch__c);
					System.debug('*** attivita.Account.Branch__r.Name :: ' + attivita.Account.Branch__r.Name);*/
                   // break;
                }
                    //}
            }
            update lstPraticheOKinserite;   
        
        
         //Chiusura da ufficio di massa delle attività pratiche irregolari precedenti:
            List<Case> casePadreElaborazionePrecedente = [SELECT Id FROM Case 
                                WHERE ActivityType__c = 'SFA_PRAIRRPARENT' AND Status !='Errore nella creazione dell\'attività'
                                ORDER BY CreatedDate DESC];

            if(casePadreElaborazionePrecedente.size()>1){
                List<Case> attivitaElaborazionePrecedente = [SELECT Id, ParentId,Status FROM Case 
                                    WHERE ParentId = :casePadreElaborazionePrecedente[1].Id AND isClosed=false];   
                for (Case attivitaPrecedente:attivitaElaborazionePrecedente){
                    attivitaPrecedente.Status='Chiuso da ufficio';                            
                }                                    
				update attivitaElaborazionePrecedente;                 
            }            
    
        	            //chiusura d'ufficio delle targhe mancanti:
            List<SFATargaMancante__c> praticheTargheMancanti = [SELECT Id, IdAttivita__c FROM SFATargaMancante__c 
                                                                  WHERE SFATargaMancante__c.NumeroPratica__c IN :lstCodiciPratiche];
            List<Id> lstCaseTargheMancantiId = new List<Id>();
            for(SFATargaMancante__c praticaTargaMancante:praticheTargheMancanti){
                lstCaseTargheMancantiId.add(praticaTargaMancante.IdAttivita__c);                
            }
            List<Case> caseTargheMancanti = [SELECT Id, Status FROM Case 
                                                                  WHERE Id IN :lstCaseTargheMancantiId];
            for (Case caseTargaMancante:caseTargheMancanti){
                if (caseTargaMancante.Status=='New'){
                   caseTargaMancante.Status='Chiuso da ufficio'; 
                }                
            }
            update caseTargheMancanti;
        
         	case1.Status = 'Closed';  
       
        }catch(Exception ex)
        {
        	errorCatch = true;
            errorCatchMessage = ex.getMessage();
        }
        if(errorCatch){
         	String n = case1.CaseNumber;
            String exceptionMessage = errorCatchMessage;
            String caseDescription;
            //System.debug('*** Case Number :: ' + n);
            //System.debug('*** caseDescription :: ' + caseDescription);
            if (exceptionMessage != null && exceptionMessage.contains('DUPLICATE_VALUE'))
                caseDescription = 'Errore durante il caricamento del caso ' + n +': numero pratica duplicato.\n Rivolgersi all\'amministratore del sistema comunicando il numero del caso.\n';
            else
                caseDescription = 'Errore durante il caricamento del caso ' + n +'.\n Rivolgersi all\'amministratore del sistema comunicando il numero del caso.\n';
            caseDescription += exceptionMessage;
            
            //System.debug('*** exceptionMessage :: ' + exceptionMessage);
                
            case1.Description = caseDescription;
        	case1.Status = CaseUtils.ERROREATTIVITA;
        }
        	update case1;

    }
    Public class wrapBatchInit
    {
     	public List<String> recordCSV {get;set;}
        public String fileid {get;set;}
        public String caseId {get;set;}
        public date dataScadenza {get;set;}
        public List<String> csvFieldNames {get;set;}
    }
}