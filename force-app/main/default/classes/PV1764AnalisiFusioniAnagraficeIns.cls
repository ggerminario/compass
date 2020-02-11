/**
 * @File Name          : PV1764AnalisiFusioniAnagraficeIns.cls
 * @Description        : 
 * @Author             : ChangeMeIn@UserSettingsUnder.SFDoc
 * @Group              : 
 * @Last Modified By   : Marco Cutolo
 * @Last Modified On   : 18/12/2019, 16:52:11
 * @Modification Log   : 
 * Ver       Date            Author      		    Modification
 * 1.0    9/12/2019         Marco Cutolo           Initial Version
**/
public class PV1764AnalisiFusioniAnagraficeIns extends PVAction{
    
    public class PV1764AnalisiFusioniAnagraficeInsForm extends PVForm{
        @AuraEnabled
        public List<OCSCliente> clientiSelezionati{get;set;}
        @AuraEnabled
		public String selectedFiliale {get;set;}
    }

    public class AccountCheckOutput{
        @AuraEnabled
        public String messaggiErrore;
        @AuraEnabled
        public Boolean isErroreBloccante; 
    }

    @AuraEnabled
	public static void conferma(PV1764AnalisiFusioniAnagraficeInsForm datiForm){
		new PV1764AnalisiFusioniAnagraficeIns().execute(datiForm);
	}

    @AuraEnabled
    public static List<Account> getFilialiForBranchManager(String userId){
        User currentUser = [SELECT ID,Area__c FROM User where ID =:userId];
        String currentArea ='';
        if(currentUser != null){
            currentArea = currentUser.Area__c;
        }
        List<Account> currentFiliali = [SELECT Name, OCS_External_Id__c FROM Account WHERE Type='FIL' AND OCSAreaIdText__c =:currentArea ORDER BY Name ASC];
        return currentFiliali;
    }

    public void execute(PVForm form){

        PV1764AnalisiFusioniAnagraficeInsForm myForm = (PV1764AnalisiFusioniAnagraficeInsForm) form;
		String messaggio_errore = '';
		try{
            //Common di PVAction
            commonExecute(myForm);
		}catch(Exception e) {
			messaggio_errore = e.getMessage();
			System.debug('TEST EMAIL EXCEPTION ERRORE:' + messaggio_errore + e.getStackTraceString());
		}finally{
			if(messaggio_errore != '') {
				gestisciException(messaggio_errore);
			}
		}
	}

    public override Case completaCasePostVendita(Case casoPV,PVForm form){
		//continuare a valorizzare l'oggetto casoPV integrando i dati di questo post vendita
        String codiciClienti = '';
        PV1764AnalisiFusioniAnagraficeInsForm myForm = (PV1764AnalisiFusioniAnagraficeInsForm) form;
        if(myForm.clientiSelezionati != null && myForm.clientiSelezionati.size() > 0){
            Integer i = 0;
            for(OCSCliente cliente:myForm.clientiSelezionati) {
                if(i==myForm.clientiSelezionati.size()-1){
                    codiciClienti += cliente.codCliente;
                }else{
                    codiciClienti += cliente.codCliente+',';
                }
                i++;
            }
        }
        casoPV.PV_Info_Variazione_Anagrafica__c = codiciClienti;
        if(!String.isBlank(myForm.selectedFiliale)){
			Account ufficio = [Select Id, Name, Type from Account where Type='FIL' AND OCS_External_Id__c =: myForm.selectedFiliale LIMIT 1];
			casoPV.Branch__c = ufficio.id;
		}
		return casoPV;
	}

    
	public override XCS_Messaggio__c preparaMessaggioOCS(PVForm form, XCS_Messaggio__c xcs_messaggio){
		//preparazione XCS_Messaggio
		PV1764AnalisiFusioniAnagraficeInsForm myForm = (PV1764AnalisiFusioniAnagraficeInsForm) form; 
		/*xcs_messaggio.CodCliente__c = myForm.cliente.codCliente;
		xcs_messaggio.NumPratica__c = myForm.pratica.numPratica;
		xcs_messaggio.TipoPratica__c = myForm.pratica.tipoPratica;
        */
		return xcs_messaggio;
	}

     public override String recuperaNotaSpecificaPV(PVForm form, Case casoPV){
        // Il recupero della nota specifica è necessario per Segnalazioni CS, non viene selezionata alcuna pratica. 
		//preparazione nota
		PV1764AnalisiFusioniAnagraficeInsForm myForm = (PV1764AnalisiFusioniAnagraficeInsForm) form;
		//7 : Note specifiche PV
        //System.debug('myForm.clientiSelezionati:'+myForm.clientiSelezionati);
		String notaSpecificaPV = '';
        notaSpecificaPV = 'Filiale di ' +myForm.userData.accountOffice.Name +'-'+myForm.userData.user.LastName+'\n';
        Integer i = 0;
        if(myForm.clientiSelezionati != null && myForm.clientiSelezionati.size() > 0){
            System.debug('Creo Nota Specifica con clienti scelti per la fusione');
            for(OCSCliente cliente:myForm.clientiSelezionati) {
                if(i==0){
                    notaSpecificaPV += 'Da mantenere \n' +
                    'Cliente: '+cliente.codCliente+'-'+cliente.cognome + '\n';
                }else{
                    notaSpecificaPV += 'Da annullare \n' +
                    'Cliente: '+cliente.codCliente+'-'+cliente.cognome + '\n';
                }
                i++;
            }
        }
		return notaSpecificaPV;
	}

    @AuraEnabled
    public static AccountCheckOutput doCheck(OCSCliente cliente){
        AccountCheckOutput accountCheckOutput = new AccountCheckOutput();
        
        String codCliente=cliente.codCliente;
        String tipoAnagrafica=cliente.tipoAnagrafica;
        Boolean isFirmatario = false;  

        System.debug('**************doCheck - codCliente: '+codCliente+' ***** tipoAnagrafica: '+cliente.tipoAnagrafica);
        System.debug('**************doCheck - pratiche:'+cliente.pratiche);        
        accountCheckOutput.messaggiErrore = '';
        accountCheckOutput.isErroreBloccante = false;
        
        //se cointestata mi fermo : bloccante
        if(!((OCSRecuperaSegnalazioniClienteResponse) OCSRecuperaSegnalazioniClienteInvoker.callRecSegnClien(codCliente)).isCointestata()){			
            OCSRecuperaTipoControparteResponse ocsRecuperaTipoControparteResponse=OCSRecuperaTipoControparteInvoker.callRecTipoContr(codCliente);
            //se agente o convenzionato mi fermo : bloccante
            if(Test.isRunningTest() || !ocsRecuperaTipoControparteResponse.isAGEorCNV()){
                //se anagrafica A mi fermo 	
                if(tipoAnagrafica.equalsIgnoreCase('A')){
                    accountCheckOutput.messaggiErrore += 'L\'anagrafica selezionata non può essere oggetto di fusione anagrafica poiché di tipologia \'A - Altro\'. Se necessario, inserire una richiesta di variazione anagrafica selezionando tra i motivi \'Richiesta ANNULLAMENTO / CANCELLAZIONE anagrafica';
                    accountCheckOutput.isErroreBloccante = true;
                }else if(cliente.pratiche == null || cliente.pratiche.size() == 0){
                    accountCheckOutput.messaggiErrore += 'L\'anagrafica selezionata non può essere oggetto di fusione anagrafica poiché non ha posizioni collegate. Se necessario, inserire una richiesta di variazione anagrafica selezionando tra i motivi \'Richiesta ANNULLAMENTO / CANCELLAZIONE anagrafica';
                    accountCheckOutput.isErroreBloccante = true;
                }
            }else{
            	accountCheckOutput.messaggiErrore = 'L\'anagrafica selezionata non può essere oggetto di fusione anagrafica poiché relativa ad un AGENTE o CONVENZIONATO. Rivolgersi all\'ufficio monitoraggio dealer per eventuali approfondimenti \n';    
                accountCheckOutput.isErroreBloccante = true;
        	} 
        }else{
            accountCheckOutput.messaggiErrore = 'L\'anagrafica selezionata non può essere oggetto di fusione poiché anagrafica \'COI - Cointestata. Non verrà inclusa nell’elenco delle anagrafiche. Proseguire con le altre anagrafiche \n';    
            accountCheckOutput.isErroreBloccante = true;
        }
        return accountCheckOutput;           
    }

    @AuraEnabled
    public static Boolean doCheckDocumenti(List<OCSCliente> clienti){
        Boolean checkReturn = false;
        for(OCSCliente singleCliente : clienti){
            System.debug('*******doCheckDocumenti***********: numDocumento + '+singleCliente.numDocumento +'dataScadenzaDate:'+singleCliente.dataScadenzaDate);
            if(singleCliente.numDocumento != null && singleCliente.dataScadenzaDate != null){
                if(singleCliente.dataScadenzaDate > Date.Today()) checkReturn = true;
            }
        }
        return checkReturn;
    }
}