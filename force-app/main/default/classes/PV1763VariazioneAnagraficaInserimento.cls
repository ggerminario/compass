/**
 * @File Name          : PV1763VariazioneAnagraficaInserimento.cls    
 * @Description        :
 * @Author             : Andrea Vanelli
 * @Group              :
 * @Last Modified By   : sabrina vitali
 * @Last Modified On   : 14/1/2020, 17:20:30
 * @Modification Log   :
 *==============================================================================
 * Ver         Date                     Author      		      Modification
 *==============================================================================
 * 1.0    2019-6-19 17:10:59   Andrea Vanelli     Initial Version
 **/
public class PV1763VariazioneAnagraficaInserimento extends PVAction {

	public class PV1763VariazioneAnagraficaForm extends PVForm {
		@AuraEnabled public String variazioni {get; set;}
		@AuraEnabled public String modificheAUI {get; set;}
		@AuraEnabled public String ritiroCarte {get; set;}
        //aggiungo per capire se arriva da presidio processi complessi
        @AuraEnabled public String presidioProcessiComplessi {get; set;}
	}

    public class AccountCheckOutput{
        @AuraEnabled
        public String messaggiErrore;
        @AuraEnabled
        public Boolean isErroreBloccante;
    }   
    
	@AuraEnabled
	public static PVResponse conferma(PV1763VariazioneAnagraficaForm datiForm){

		/*******************************
			// esempio chiamata esterna
		/***********************************************/
/*		
		// prova inserimento PV esterna
		PV1763VariazioneAnagraficaInserimento.PV1763VariazioneAnagraficaForm datiForm = new PV1763VariazioneAnagraficaInserimento.PV1763VariazioneAnagraficaForm();

		// se si vuole usare l'utente collegato (deve essere correttamente configurato per l'inseimento PV altrimenti verrà ritornata un'eccezione)
		//datiForm = (PV1763VariazioneAnagraficaInserimento.PV1763VariazioneAnagraficaForm) PV1763VariazioneAnagraficaInserimento.prepareFormExternal(datiForm, '1763', null);
		// in alternativa è possibile parrare l'id specifico di un utente (es: simulare l'inserimento da parte di un ufficio specifico)    
		datiForm = (PV1763VariazioneAnagraficaInserimento.PV1763VariazioneAnagraficaForm)PV1763VariazioneAnagraficaInserimento.prepareFormExternal(datiForm, '1763', '0050Q000002NJkSQAW');
		//SELECT Id FROM Account WHERE RecordType.Name = 'Uffici e Altro' AND Codice_Ufficio__c = 'DCR/AV - PPC' --> DCRPPC
		
		//passo il valore ad 'S' perchè il PV deve skippare alcune cose
		datiForm.presidioProcessiComplessi = 'S';
		
		// i dati del cliente sono obbligatori
		// visto che potenzialmente potrebbe essere creata un'anagrafica sarebbe corretto passare tutti quelli a disposizione
		datiForm.cliente = new OCSCliente();
		datiForm.cliente.email = 'POSTVENDITA@EMAIL.TEST';
		datiForm.cliente.codCliente = '1';
		datiForm.cliente.cognome = 'COGNOME';
		datiForm.cliente.nome = 'NOME';
		datiForm.cliente.denominazioneAzienda = 'NOME COGNOME';
		datiForm.cliente.dataNascita = '20100101';

		// Pratica
		datiform.pratica = new OCSPratica();
		datiform.pratica.tipoPratica = 'CA';
		datiform.pratica.numPratica = '2106662676';

		//Pratica e oggetto della mail da inserire come nota
		datiform.note = 'Pratica: CA - 2106662676';
		datiform.note += '\n\nOggetto: 18444557 Poste 4855039 RI 5 S |55263|55262|55261| Variazione Anagrafica CAR\nMittente: Servizio F&T Poste Compass <ContractFlowPPT@eng.it>\nTO: presidioprocessi@mail-compass.riverstar.com\nCC: \n\nPratica: 18444557\n\nTipo Cliente: Richiedente\n\nCod. OCS: 4855039\n\nDenominazione: MAIELLO LUIGI\n\nCodice Fiscale: MLLLGU46H22H382P\n\nDataRilascioDocumento variato da 30/05/2008 a 22/10/2010\n\nNuova Data Scadenza Documento 22/10/2020\n\nLocalitaRilascioDocumento variato da CAPRIGLIA IRPINA a SERRARA  FONTANA\n\nNumeroDocumento1 variato da AR1548064 a AR 3059483\n\nTipo Anomalia : S\n\nCodice Anomalia : |55263|55262|55261|\n\n';

		//dati specifici PV
		//stringa già costruita con Pratica e Tipo Documento Patente o Carta d'Identità
		datiForm.variazioni = 'Tipo Documento : Patente\n';

		// esecuzione inserimento
		PV1763VariazioneAnagraficaInserimento.conferma(datiform);
		//se errore il metodo esegue "throw new AuraHandledException"
*/        
        PVResponse resp = new PV1763VariazioneAnagraficaInserimento().execute(datiForm);
		return resp;
	}

    @AuraEnabled
    public static AccountCheckOutput doCheck(OCSCliente cliente, String sottotipologiaInput){
        AccountCheckOutput accountCheckOutput = new AccountCheckOutput();
        
        String codCliente=cliente.codCliente;
        String tipoAnagrafica=cliente.tipoAnagrafica;
        Boolean isFirmatario = false;  

        System.debug('**************doCheck - codCliente: '+codCliente+' ***** tipoAnagrafica: '+cliente.tipoAnagrafica + ' ***** sottotipologiaInput: '+sottotipologiaInput);
        
        accountCheckOutput.messaggiErrore = '';
        accountCheckOutput.isErroreBloccante = false;
        
        //se cointestata mi fermo : bloccante
        if(!((OCSRecuperaSegnalazioniClienteResponse) OCSRecuperaSegnalazioniClienteInvoker.callRecSegnClien(codCliente)).isCointestata()){			
            OCSRecuperaTipoControparteResponse ocsRecuperaTipoControparteResponse=OCSRecuperaTipoControparteInvoker.callRecTipoContr(codCliente);
            //se agente o convenzionato mi fermo : bloccante
            if(!ocsRecuperaTipoControparteResponse.isAGEorCNV()){	
                Boolean prosegui = true;

                //se subtype Firmatario e tipo anagrafica <> P mi fermo : bloccante
                if(!tipoAnagrafica.equalsIgnoreCase('P') && sottotipologiaInput.equals('Documento Firmatario/Delegato/Rappresentante/Titolare')){
                    accountCheckOutput.messaggiErrore = 'Il cliente selezionato è Firmatario o Delegato ma non è un Privato. Rivolgersi a Monitoraggio Dealer\n';    
                    accountCheckOutput.isErroreBloccante = true;
                    prosegui = false;
                }

                //ricerco se firmatario da menu F8                    
                OCSRecuperaConvenzioniCollegatoResponse ocsRecuperaConvenzioniCollegatoResponse=OCSRecuperaConvenzioniCollegatoInvoker.callRecConvColl(codCliente);
                for(OCSRecuperaConvenzioniCollegatoResponse.ConvenzioniCollegatoDTO flagConvenzione : OCSRecuperaConvenzioniCollegatoResponse.recuperaConvenzioniCollegatoResponse.elenco){
                    //firmatario se flag : FIR – RAP - SOC
                    if(flagConvenzione.flagFirmatario.equalsIgnoreCase('S') || flagConvenzione.flagRappresentante.equalsIgnoreCase('S') || flagConvenzione.flagSocio.equalsIgnoreCase('S')){
                        isFirmatario = true;
                        break;
                    }
                }
                //se subtype standard Cliente e firmatario mi fermo : bloccante
                if(prosegui && sottotipologiaInput.equals('Cliente/Coobbligato/Garante/Delegato/Altro') && (ocsRecuperaTipoControparteResponse.isFIR() || isFirmatario)
                ){
                    accountCheckOutput.messaggiErrore = 'La SottoTipologia non è corretta per il cliente selezionato - modificare la scelta o rivolgersi a Monitoraggio Dealer\n';    
                    accountCheckOutput.isErroreBloccante = true;
                    prosegui = false;
                }
                if(prosegui && tipoAnagrafica.equalsIgnoreCase('A')){
                    //tipo anagrafica A senza indirizzo
                    if(String.isBlank(cliente.indirizzo)){                                    
                        accountCheckOutput.messaggiErrore = 'Attenzione: il cliente selezionato risulta privo di indirizzo associato.\n';    
                        //verifica delle pratiche non definitive : se ci sono pratiche è bloccante
                        System.debug('### PRIMA DI RECUPERARE DATI PV');
                        cliente=OCSObjectsFactory.makeClienti(OCSRecuperaDatiPostvenditaInvoker.callRecDatiPV(cliente.codCliente))[0];
                        if(cliente.hasPraticheInLavorazione()){    
                            accountCheckOutput.messaggiErrore += 'Si prega di inserire il nuovo indirizzo nelle note della richiesta prima di procedere.\n';        
                        }else{
                            accountCheckOutput.messaggiErrore += 'Prima procedere con l’inserimento dell’indirizzo e poi chiedere la variazione anagrafica.\n';        
                            accountCheckOutput.isErroreBloccante = true;
                        }
                    }
                }
            }else{
            	accountCheckOutput.messaggiErrore = 'Il cliente selezionato ha il flag CNV o AGE valorizzato, rivolgersi a Monitoraggio Dealer\n';    
                accountCheckOutput.isErroreBloccante = true;
        	} 
        }else{
            accountCheckOutput.messaggiErrore = 'Il cliente selezionato non può essere oggetto di variazione anagrafica poiché anagrafica -COI - Cointestata-\n';    
            accountCheckOutput.isErroreBloccante = true;
        }
        return accountCheckOutput;           
    }


	/* metodi NON aura enabled */
    
    public PVResponse execute(PVForm form){
        String messaggio_errore = '';
        try{
            PV1763VariazioneAnagraficaForm myForm = (PV1763VariazioneAnagraficaForm) form;
            System.debug('###Variazioni : '+myForm.variazioni);
            System.debug('###modificheAUI : '+myForm.modificheAUI);
            System.debug('###ritiroCarte : '+myForm.ritiroCarte);
            //Common di PVAction
        
            commonExecute(myForm);
            
        }catch(Exception e) {
            messaggio_errore = loggaException(e);
        }finally{
            if(messaggio_errore != ''){
                gestisciException(messaggio_errore); 
            }
        }
        return risposta;
    }

    public override Case completaCasePostVendita(Case casoPV,PVForm form){
       
        //continuare a valorizzare l'oggetto casoPV integrando i dati di questo post vendita
        PV1763VariazioneAnagraficaForm myForm = (PV1763VariazioneAnagraficaForm) form;

        //le variazioni inserite come Presidio Processi Complessi non hanno disposition, ritiro carte o modifiche AUI
        if(String.isEmpty(myForm.presidioProcessiComplessi)){
            casoPV.Disposition__c = XCS_DispositionUtils.findDispositionByExternalID('DP'+String.valueOf(myForm.reasonMdt.dispositionId__c)).Id;
            System.debug('## casoPV.Disposition__c : ' + casoPV.Disposition__c);

            if(myForm.ritiroCarte.equals('S')){
                casoPV.FlagCarteDaRitirare__c = true;    
            }
            System.debug('## casoPV.FlagCarteDaRitirare__c : ' + casoPV.FlagCarteDaRitirare__c);
            //prima di inserire il Case di PV: verifico se deve essere variato in attività 'AUI_FAX_MAIL_RICEVUTE' da inviare ad IDM
            System.debug('## myForm.modificheAUI : ' + myForm.modificheAUI);
            if(myForm.modificheAUI.equals('S')){
                //verifico se si tratta di cliente AUI    
                if([select Id from Case where AccountId=:casoPV.AccountId
                                and ActivityType__c='CRM_POSTVENDITA'
                                and Categoria_Riferimento__r.External_Id__c=:XCS_CategoriaUtil.AUI_RECUPERO_DOCUMENTI_SCADUTI //5616
                                and Status='New'].size()>0){
                    System.debug('AUI! Inserisco il Case come AUI_FAX_MAIL_RICEVUTE');
                    casoPV.Type='CRM';
                    casoPV.ActivityType__c = 'AUI_FAX_MAIL_RICEVUTE';
                    casoPV.Status = 'New'; // o lascio da processare?
                    casoPV.OwnerId = CaseUtils.assignToQueue(casoPV,'Q334').Id;
                    casoPV.RecordTypeId = [select Id from RecordType where Name='CRM Master'].Id;
                    casoPV.Categoria_Riferimento__r=XCS_CategoriaUtil.getCategoryForExternalId(XCS_CategoriaUtil.AUI_GESTIONE_FAX_MAIL); //5622
                    casoPV.Disposition__c = null;
                }
            }
        }

        return casoPV;
    }

    //metodo override di alertMessaggi in PVAction - mostra alert per specifici messaggi
    public override void alertMessaggi(PVForm form, Case casoPV){

        PV1763VariazioneAnagraficaForm myForm = (PV1763VariazioneAnagraficaForm) form;

        System.debug('*#* numero case : '+CaseUtils.getCaseNumber(casoPV.Id));
        if(myForm.isCheckFax==true){
            risposta.insMessage('info','Invia quanto richiesto al fax 02.721325337 riportando sui documenti il numero di richiesta CRM '+CaseUtils.getCaseNumber(casoPV.Id),'20000');
        }
        
    }

    public override String recuperaNotaSpecificaPV(PVForm form, Case casoPV){
        
        //preparazione nota 
        PV1763VariazioneAnagraficaForm myForm = (PV1763VariazioneAnagraficaForm) form;

        // : Note specifiche PV
        String notaAui = '\nVariazione Anagrafica in gestione IDM per AUI recupero Documento';
        return casoPV.ActivityType__c.equals('AUI_FAX_MAIL_RICEVUTE')?myForm.variazioni + notaAui:myForm.variazioni;
    }
    
    public override XCS_Messaggio__c preparaMessaggioOCS(PVForm form, XCS_Messaggio__c xcs_messaggio){
        //preparazione XCS_Messaggio
        PV1763VariazioneAnagraficaForm myForm = (PV1763VariazioneAnagraficaForm) form;
        xcs_messaggio.CodCliente__c = myForm.cliente.codCliente;
        return xcs_messaggio;
    }

 

}