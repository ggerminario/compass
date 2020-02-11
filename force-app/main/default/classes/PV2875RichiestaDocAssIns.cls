/**
 * @File Name          : PV2875RichiestaDocumentazioneAssicurativaIns.cls
 * @Description        : 
 * @Author             : Marco Cutolo
 * @Group              : 
 * @Last Modified By   : Marco Cutolo
 * @Last Modified On   : 19/12/2019, 10:03:44
 * @Modification Log   : 
 * Ver       Date            Author      		    Modification
 * 1.0    11/12/2019   Marco Cutolo     Initial Version
**/
public class PV2875RichiestaDocAssIns extends PVAction {
    
    public class PV2875RichiestaDocAssInsForm extends PVForm {
		@AuraEnabled
		public List<OCSRecuperaDatiRimborsoPostEAInvoker.PacchettoServizioDTO> pacchettiSelezionati {get;set;}

		@AuraEnabled
		public Map<String,String> mappaPacchettiSelezionati {get;set;} 
	
	}

    @AuraEnabled
	public static void conferma(PV2875RichiestaDocAssInsForm datiForm){
		new PV2875RichiestaDocAssIns().execute(datiForm);
	}

    public void execute(PVForm form){
		// TO DO EXECUTE con chiamata a VariazioneModalCalcoloRata
		PV2875RichiestaDocAssInsForm myForm = (PV2875RichiestaDocAssInsForm) form;
		String messaggio_errore = '';
		try{
            //Common di PVAction
            commonExecute(myForm);
		}catch(Exception e) {
			messaggio_errore = e.getMessage();
			System.debug('TEST EMAIL EXCEPTION ERRORE:' + messaggio_errore);
		}finally{
			if(messaggio_errore != '') {
				gestisciException(messaggio_errore);
			}
		}
	}
    
    @AuraEnabled 
    public static List<OCSRecuperaDatiRimborsoPostEAInvoker.PacchettoServizioDTO> recuperaPacchettiAssicurativi(String numPratica) {
        // TO DO EXECUTE con chiamata a VariazioneModalCalcoloRata
		String messaggio_errore = '';
        OCSRecuperaDatiRimborsoPostEAInvoker.Response res;
		try{
			OCSRecuperaDatiRimborsoPostEAInvoker.Request req = new OCSRecuperaDatiRimborsoPostEAInvoker.Request();
			req.recuperaDatiRimborsoPostEARequest.numPratica = numPratica;
			System.debug('Dati provenienti dal form: ' + numPratica);
			System.debug('Dati request: ' + req.recuperaDatiRimborsoPostEARequest);
			res = OCSRecuperaDatiRimborsoPostEAInvoker.invoke(req.recuperaDatiRimborsoPostEARequest);
			System.debug('Response OCSRecuperaDatiRimborsoPostEA:'+ res.getMessage());
			if(!res.isOK()) {
				messaggio_errore = res.getMessage();
			}
		}catch(Exception e) {
			System.debug('Exception:'+ e.getMessage() +'\n'+e.getStackTraceString());
			messaggio_errore = e.getMessage();
		}finally{
			if(messaggio_errore != '') {
				gestisciException(messaggio_errore);
			}
            
		}
        return res.recuperaDatiRimborsoPostEAResponse.elencoPacchettiServizi;
    }

    public override Case completaCasePostVendita(Case casoPV,PVForm form){
		//continuare a valorizzare l'oggetto casoPV integrando i dati di questo post vendita
		String messaggio_errore = '';
		Integer fascicoliRequired = 0;
		Integer vademecumRequired = 0;
		Boolean isSomethingMissing = false;
		PV2875RichiestaDocAssInsForm myForm = (PV2875RichiestaDocAssInsForm) form;
		for (String codiceServizio : myForm.mappaPacchettiSelezionati.keySet()) {
			//myForm.mappaPacchettiSelezionati.get(codiceServizio)=='2' Vademecum
			//myForm.mappaPacchettiSelezionati.get(codiceServizio)=='1' Fascicolo
			//myForm.mappaPacchettiSelezionati.get(codiceServizio)=='3' Entrambi
			if(myForm.mappaPacchettiSelezionati.get(codiceServizio)=='3'){
				fascicoliRequired += 1;
				vademecumRequired += 1;
			}else if(myForm.mappaPacchettiSelezionati.get(codiceServizio)=='1'){
				fascicoliRequired += 1;
			}else if(myForm.mappaPacchettiSelezionati.get(codiceServizio)=='2'){
				vademecumRequired += 1;
			}
		}
		Set<String> setCodiciServizio = new Set<String>();
		Set<Id> idFascicoli = new Set<Id> ();
		System.debug('completaCasePostVendita Pacchetti Selezionati:'+myform.pacchettiSelezionati);
		try{
			if(myform.pacchettiSelezionati != null && !myform.pacchettiSelezionati.isEmpty()){
				for(OCSRecuperaDatiRimborsoPostEAInvoker.PacchettoServizioDTO singlePacchetto : myForm.pacchettiSelezionati){
					setCodiciServizio.add(singlePacchetto.codServizio);
				}
				List<Fascicolo_Informativo__c> fascicoliAssociati = [SELECT ID,Codice_servizio__c,Tipologia__c FROM Fascicolo_Informativo__c WHERE Codice_servizio__c IN: setCodiciServizio];
				if(fascicoliAssociati != null && !fascicoliAssociati.isEmpty()){
					Integer fascicoliFound = 0;
					Integer vademecumFound = 0;
					for(Fascicolo_Informativo__c singleFascicolo: fascicoliAssociati){
						if(singleFascicolo.Tipologia__c == 'Fascicolo Informativo'){
							fascicoliFound += 1;
						}else if(singleFascicolo.Tipologia__c == 'Vademecum'){
							vademecumFound += 1;
						}
					}
					
					if(fascicoliFound < fascicoliRequired || vademecumFound < vademecumRequired){
						isSomethingMissing = true;
					}
				}else{
					isSomethingMissing = true;
				}
			}
			if(isSomethingMissing){
				casoPV.pv_send_to__c = 'UOPA';
			}

		}catch(Exception e) {
			messaggio_errore = e.getMessage();
		}finally{
			if(messaggio_errore != '') {
				gestisciException(messaggio_errore);
			}
            
		} 	
        //Eseguire logica ricerca allegato dai fascicoli
		return casoPV;
	}

	public override void insertTabelleExtra(PVForm pvForm,Case casoPV){
		String messaggio_errore = '';
		PV2875RichiestaDocAssInsForm myForm = (PV2875RichiestaDocAssInsForm) pvForm;
		Set<String> setCodiciServizio = new Set<String>();
		Set<Id> idFascicoli = new Set<Id> ();
		System.debug('insertTabelleExtra Pacchetti Selezionati:'+myform.pacchettiSelezionati);
		try{
			if(myform.pacchettiSelezionati != null && !myform.pacchettiSelezionati.isEmpty()){
				for(OCSRecuperaDatiRimborsoPostEAInvoker.PacchettoServizioDTO singlePacchetto : myForm.pacchettiSelezionati){
					setCodiciServizio.add(singlePacchetto.codServizio);
				}
				System.debug('SetCodiciServizio:'+setCodiciServizio);
				List<Fascicolo_Informativo__c> fascicoliAssociati = [SELECT ID,Codice_servizio__c,Tipologia__c FROM Fascicolo_Informativo__c WHERE Codice_servizio__c IN: setCodiciServizio];
				System.debug('FascicoliAssociati:'+fascicoliAssociati);
				if(fascicoliAssociati != null && !fascicoliAssociati.isEmpty()){
					for(Fascicolo_Informativo__c singleFascicolo : fascicoliAssociati){
						if(myForm.mappaPacchettiSelezionati.get(singleFascicolo.Codice_servizio__c)=='3'){
							idFascicoli.add(singleFascicolo.Id);
						}else if(myForm.mappaPacchettiSelezionati.get(singleFascicolo.Codice_servizio__c)=='1' && singleFascicolo.Tipologia__c=='Fascicolo Informativo'){
							idFascicoli.add(singleFascicolo.Id);
						}else if(myForm.mappaPacchettiSelezionati.get(singleFascicolo.Codice_servizio__c)=='2' && singleFascicolo.Tipologia__c=='Vademecum'){
							idFascicoli.add(singleFascicolo.Id);
						}
					}
				}
				//Set<Id> idFascicoliFilter = idFascicoli;
				/*String idFascicoliFilterString ='(';
				for(Id singleId : idFascicoliFilter){
					idFascicoliFilterString += '\''+singleId+'\',';
				}
				idFascicoliFilterString = idFascicoliFilterString.removeEnd(',');
				idFascicoliFilterString +=')';
				System.debug('idFascicoliFilterString'+idFascicoliFilterString);
				String queryString = 'SELECT ContentDocumentId from ContentDocumentLink where LinkedEntityId IN '+idFascicoliFilterString;
				System.debug('queryString: '+queryString);
				*/
				System.debug('IdFascicoli:'+idFascicoli);
				if(!idFascicoli.isEmpty()){
					List<ContentDocumentLink> cdFiles = [SELECT ContentDocumentId from ContentDocumentLink where LinkedEntityId IN :idFascicoli];
					System.debug('CdFiles found:'+cdFiles);
					//List<ContentDocumentLink> cdFiles = Database.Query(queryString);
					if(cdFiles != null && !cdFiles.isEmpty()){
						List<ContentDocumentLink> cdFilesToInsert = new List<ContentDocumentLink> ();
						for(ContentDocumentLink originalFile : cdFiles){
							ContentDocumentLink newCdFile = new ContentDocumentLink();
							newCdFile.ContentDocumentId = originalFile.ContentDocumentId;
							newCdFile.LinkedEntityId = casoPV.Id;
							newCdFile.shareType = 'V';
							newCdFile.visibility = 'AllUsers';
							cdFilesToInsert.add(newCdFile);
						}
						insert cdFilesToInsert;
					}
				}
			}
		}catch(Exception e) {
			messaggio_errore = e.getMessage();
		}finally{
			if(messaggio_errore != '') {
				gestisciException(messaggio_errore);
			}
            
		} 
	}

	public override String recuperaNotaSpecificaPV(PVForm form, Case casoPV){
		//preparazione nota
		PV2875RichiestaDocAssInsForm myForm = (PV2875RichiestaDocAssInsForm) form;
		//7 : Note specifiche PV
		String notaSpecificaPV;
		notaSpecificaPV = 'Numero pratica: ' + myForm.pratica.numPratica + '\n';
		Set<String> codiciServizioLavorati = new Set<String>(); 
		for(OCSRecuperaDatiRimborsoPostEAInvoker.PacchettoServizioDTO singlePacchetto : myForm.pacchettiSelezionati){
			if(!codiciServizioLavorati.contains(singlePacchetto.codServizio)){
				notaSpecificaPV += '\n';
				notaSpecificaPV += 'Assicurazione Selezionata:' +'\n';
				notaSpecificaPV += 'Codice Servizio: '+ singlePacchetto.codServizio +'\n';
				notaSpecificaPV += 'Fornitore: '+ singlePacchetto.desFornitore +'\n';
				notaSpecificaPV += 'Data delibera pratica: '+singlePacchetto.dataFineCoperturaSlashed +'\n';
				if(myForm.mappaPacchettiSelezionati.get(singlePacchetto.codServizio) == '3'){
					notaSpecificaPV += 'Documento Inviato: Fascicolo Informativo'+ '\n';
					notaSpecificaPV += 'Documento Inviato: Vademecum' + '\n';
				}else if(myForm.mappaPacchettiSelezionati.get(singlePacchetto.codServizio) == '1'){
					notaSpecificaPV += 'Documento Inviato: Fascicolo Informativo'+ '\n';
				}else if(myForm.mappaPacchettiSelezionati.get(singlePacchetto.codServizio) == '2'){
					notaSpecificaPV += 'Documento Inviato: Vademecum' + '\n';
				}
				notaSpecificaPV += '\n';
				codiciServizioLavorati.add(singlePacchetto.codServizio);
			}	
		}
		return notaSpecificaPV;
	}

	public override XCS_Messaggio__c preparaMessaggioOCS(PVForm form, XCS_Messaggio__c xcs_messaggio){
		//preparazione XCS_Messaggio
		PV2875RichiestaDocAssInsForm myForm = (PV2875RichiestaDocAssInsForm) form; 
		xcs_messaggio.CodCliente__c = myForm.cliente.codCliente;
		xcs_messaggio.NumPratica__c = myForm.pratica.numPratica;
		xcs_messaggio.TipoPratica__c = myForm.pratica.tipoPratica;
		return xcs_messaggio;
	}
}