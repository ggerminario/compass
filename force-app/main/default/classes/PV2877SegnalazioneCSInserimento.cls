/**
 * @File Name          : PV2877SegnalazioneCSInserimento.cls
 * @Description        : 
 * @Author             : Marco Cutolo
 * @Group              : 
 * @Last Modified By   : Marco Cutolo
 * @Last Modified On   : 10/12/2019, 14:39:31
 * @Modification Log   : 
 * Ver       Date            Author      		    Modification
 * 1.0    10/12/2019   Marco Cutolo     Initial Version
**/
public class PV2877SegnalazioneCSInserimento extends PVAction{
	//Best solution: TO add a field on the Custom Metadata Type PostvenditaConfig_subtype__mdt that contains the desc_for_rnt field
	//Mappa Sottotipologie con Coda
	private static final Map<String, String> UFFICI_MAP_WITH_QUEUE = new Map<String, String>{
        '80' => 'INFOCREDIT', '81' => 'JKLRCL','82' => 'CREMO','83' => 'BACK','84' => 'BACK','85' => 'OPA',
		'88' => 'BDAT','89' => 'IDMRCL','94' => 'PHC','95' => 'POSTDT2877','98' => 'ANPRDTRAN',
		'101' => 'CCLI','103' => '','105' => 'CS','107' => 'Numero Blu','110' => 'RICHDEL',
		'113' => 'CRLEG','114' => 'CSI2877','122' => 'Visiant','137' => 'PREDBT','143' => 'NET','160' => 'CRH'
    };

	//Mappa Sottotipologie senza Coda
	private static final Map<String, String> UFFICI_MAP_WITH_EMAIL = new Map<String, String>{
		'86' => 'LEGALE','87' => 'FRO2877','90' => 'CRANAG','96' => 'COLLSTUDI','97' => 'STR',
		'99' => 'SUPPUTENTI','100' => 'HELPDESK','102' => 'FINA','104' => 'PSHIPPOSTE',
		'111' => 'Finanza CPAY','112' => 'AUTGIU','146' => 'Sospetta Truffa'
	};

    public class PV2877SegnalazioneCSInserimentoForm extends PVForm {
		@AuraEnabled
		public String categoria {get;set;}
		@AuraEnabled
		public String prodotto {get;set;}
		@AuraEnabled
		public String oggetto{get;set;}
		@AuraEnabled
		public String argomento{get;set;}
		@AuraEnabled
		public String selectedFiliale {get;set;}
		@AuraEnabled
		public List<OCSPratica> selectedPratiche {get;set;}
		@AuraEnabled
		public String templateBody {get;set;}
	}

    @AuraEnabled
	public static void conferma(PV2877SegnalazioneCSInserimentoForm datiForm){
		new PV2877SegnalazioneCSInserimento().execute(datiForm);
	}

    public void execute(PVForm form){

        PV2877SegnalazioneCSInserimentoForm myForm = (PV2877SegnalazioneCSInserimentoForm) form;
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

    //recupera filiali
    @AuraEnabled
    public static List<Account> recuperaFiliali(){
        List<Account> fil = [SELECT Name, OCS_External_Id__c FROM Account WHERE Type='FIL' ORDER BY Name ASC];
        return fil;
    }
	/*
	@AuraEnabled
	public static Map<String,List<PostVenditaConfig_Argomento__mdt>> recuperaMappaArgomenti(){
		Map<String,List<PostVenditaConfig_Argomento__mdt>> returnMap = new Map<String,List<PostVenditaConfig_Argomento__mdt>>();
		List<PostVenditaConfig_Argomento__mdt> argomentiList = [SELECT Descrizione__c,Label,uniqueId__c,Visibility__c,ReasonsIds__c from PostVenditaConfig_Argomento__mdt Order by SortOrder__c ASC]; 
		for(PostVenditaConfig_Argomento__mdt singleArgomento : argomentiList){
			if(returnMap.get(singleArgomento.ReasonsIds__c)==null){
				List<PostVenditaConfig_Argomento__mdt> newArgumentList = new List<PostVenditaConfig_Argomento__mdt> (); 
				newArgumentList.add(singleArgomento);
				returnMap.put(singleArgomento.ReasonsIds__c,newArgumentList); 
			}else{
				returnMap.get(singleArgomento.ReasonsIds__c).add(singleArgomento);
			}
		}
        return returnMap;
	}
	*/
	@AuraEnabled
	public static List<PostVenditaConfig_Argomento__mdt> recuperaListaArgomenti(String reasonId){
		String searchReason = '%'+reasonId+'%';
		List<PostVenditaConfig_Argomento__mdt> argomentiList = [SELECT Descrizione__c,Label,uniqueId__c,Visibility__c,ReasonsIds__c from PostVenditaConfig_Argomento__mdt where ReasonsIds__c like :searchReason Order by SortOrder__c ASC ]; 
        return argomentiList;
	}

	@AuraEnabled
	public static String recuperaTemplate(String argSelected){
		return XCS_TemplateUtils.getBody(argSelected);
	}

    public override Case completaCasePostVendita(Case casoPV,PVForm form){
		//continuare a valorizzare l'oggetto casoPV integrando i dati di questo post vendita
        PV2877SegnalazioneCSInserimentoForm myForm = (PV2877SegnalazioneCSInserimentoForm) form;
        casoPV.Subject += ' - '+myForm.categoria+ ' - '+myForm.prodotto;
		if(!String.isBlank(myForm.selectedFiliale)){
			Account ufficio = [Select Id, Name, Type from Account where Type='FIL' AND OCS_External_Id__c =: myForm.selectedFiliale LIMIT 1];
			casoPV.UfficioDestinazione__c = ufficio.id;
		}else{
			if(UFFICI_MAP_WITH_QUEUE.get(String.valueOf(myForm.sottotipologiaMdt.uniqueId__c))!= null)	
				casoPV.pv_send_to__c = UFFICI_MAP_WITH_QUEUE.get(String.valueOf(myForm.sottotipologiaMdt.uniqueId__c));
			else
				casoPV.pv_send_to__c = UFFICI_MAP_WITH_EMAIL.get(String.valueOf(myForm.sottotipologiaMdt.uniqueId__c));
		}
		return casoPV;
	}

	public override void insertTabelleExtra(PVForm pvForm,Case casoPV){
		PV2877SegnalazioneCSInserimentoForm myForm = (PV2877SegnalazioneCSInserimentoForm) pvForm;
		if(UFFICI_MAP_WITH_EMAIL.values().contains(casoPV.pv_send_to__c)){
			//InvioEmail(templateBody,casoPV);
					System.debug('insertTabelleExtra for Case:'+casoPV);
					List<String> indirizziInvioEmail = new List<String> (); 
					Map<String, String> addressMap = CompassParametersUtils.getParameterByGroup('subtypeEmailAddresses');
					if(addressMap.get(casoPV.pv_send_to__c) != null){
						indirizziInvioEmail = addressMap.get(casoPV.pv_send_to__c).split(';');
					}
					List<Messaging.SingleEmailMessage> emailToSend = new List<Messaging.SingleEmailMessage>();
					Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
					//String[] toAddresses = new String[] {'adriana.lattanzi@exprivia.com'};
					mail.setToAddresses(indirizziInvioEmail);
					mail.setSubject(casoPV.Subject);
					mail.setHtmlBody(myForm.templateBody);
					emailToSend.add(mail);
					system.debug(emailToSend);
					
					String mockName = 'inviomail.SegnalazioniCS';
					EmailUtils.sendEmail(emailToSend,mockName);
				}
	}
/*
	private static List<String> doImpostaIndirizzi(String userDescription){
		List<String> indirizziInvioEmail = new List<String> (); 
		Map<String, String> addressMap = CompassParametersUtils.getParameterByGroup('subtypeEmailAddresses');
		if(addressMap.get(userDescription) != null){
			indirizziInvioEmail = addressMap.get(userDescription).split(';');
		}
        return indirizziInvioEmail;
    }*/


    public override String recuperaNotaSpecificaPV(PVForm form, Case casoPV){
        // Il recupero della nota specifica è necessario per Segnalazioni CS, non viene selezionata alcuna pratica. 
		//preparazione nota
		PV2877SegnalazioneCSInserimentoForm myForm = (PV2877SegnalazioneCSInserimentoForm) form;
		//7 : Note specifiche PV
		String notaSpecificaPV = '';
        //To Add motivo
        if(myForm.selectedPratiche != null && myForm.selectedPratiche.size()>0){
			String selectedPraticheListString = '';
			for(OCSPratica singlePratica:myForm.selectedPratiche){
				selectedPraticheListString += singlePratica.numPratica +', ';
			}
		    notaSpecificaPV = 'Numero pratica/e: ' + selectedPraticheListString.trim().removeEnd(',') + '\n'
                            + 'Categoria: ' + myForm.categoria + '\n'
                            + 'Prodotto: ' + myForm.prodotto + '\n'
							+ 'Argomento: ' + myForm.argomento + '\n'
							+ myForm.templateBody + '\n';
		}
		return notaSpecificaPV;
	}

	public override XCS_Messaggio__c preparaMessaggioOCS(PVForm form, XCS_Messaggio__c xcs_messaggio){
		//preparazione XCS_Messaggio
		PV2877SegnalazioneCSInserimentoForm myForm = (PV2877SegnalazioneCSInserimentoForm) form; 
		xcs_messaggio.CodCliente__c = myForm.cliente.codCliente;
		xcs_messaggio.NumPratica__c = myForm.pratica.numPratica;
		xcs_messaggio.TipoPratica__c = myForm.pratica.tipoPratica;
		return xcs_messaggio;
	}

}