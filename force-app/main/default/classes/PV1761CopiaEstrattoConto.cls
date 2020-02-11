/**
 * @File Name          : PV1761CopiaEstrattoConto.cls
 * @Description        :
 * @Author             : Riccardo Donato
 * @Group              :
 * @Last Modified By   : Raffaele Prudenzano
 * @Last Modified On   : 9/12/2019, 12:47:42
 * @Modification Log   :
 *==============================================================================
 * Ver         Date                     Author                    Modification
 *==============================================================================
 * 1.0    14/10/2019, 11:05:00   Riccardo Donato     Initial Version
 **/
public class PV1761CopiaEstrattoConto extends PVAction {

	public class PV1761CopiaEstrattoContoForm extends PVForm {
		@AuraEnabled public List<PV1761CopiaEstrattoConto.ECDto> ecs { get; set; }
		@Auraenabled public String send_to { get; set; }
	}


	@AuraEnabled
	public static void conferma(PV1761CopiaEstrattoContoForm datiForm) {
		new PV1761CopiaEstrattoConto().execute(datiForm);
	}

	public void execute(PVForm form) {
		PV1761CopiaEstrattoContoForm myForm = (PV1761CopiaEstrattoContoForm) form;
		String messaggio_errore = '';
		try{
			commonExecute(myForm);
		} catch(Exception e) {
			messaggio_errore = loggaException(e);
		}finally {
			if(messaggio_errore != '') {
				gestisciException(messaggio_errore);
			}
		}
	}


	public override Case completaCasePostVendita(Case casoPV, PVForm form) {
		//continuare a valorizzare l'oggetto casoPV integrando i dati di questo post vendita
		PV1761CopiaEstrattoContoForm myForm = (PV1761CopiaEstrattoContoForm) form;
		casoPV.pv_send_to__c = myForm.send_to;

		if(myForm.userData.user.Branch_Or_Office__c=='CCInterno' && casoPV.pv_send_to__c == 'Filiale'){
			casoPV.param_step__c= 'ToCCInterno';
		}

		return casoPV;
	}


	public override String recuperaNotaSpecificaPV(PVForm form, Case casoPV){
		//preparazione nota
		PV1761CopiaEstrattoContoForm myForm = (PV1761CopiaEstrattoContoForm) form;

		String notaSpecificaPV = ' ';
		notaSpecificaPV += 'Pratica: ' + myForm.pratica.tipoPratica + ' ' + myform.pratica.numPratica + '\n';
		notaSpecificaPV += 'Inviare a: ' + myForm.send_to + '\n';
		notaSpecificaPV += 'Elenco E/C:\n';

		// Formatto la lista FLAT List<PV1761CopiaEstrattoConto.ECDto> in Map per formulare più agevolemente la stringa delle note
		Map<Integer,List<Integer>> ecmap = new Map<Integer,List<Integer>>();
		for(PV1761CopiaEstrattoConto.ECDto ec : myForm.ecs){
				Integer a = Integer.valueOf(ec.ec_anno);
				Integer m = Integer.valueOf(ec.ec_mese);
			if(ecmap.containsKey(a)){
				List<Integer> mesi = ecmap.get(a);
				mesi.add(m);
				ecmap.put(a, mesi);
			} else{
				ecmap.put(a, new List<Integer>{m});
			}
		}

		// Formulo la stringa delle note per gli EC
		List<Integer> anni = new List<Integer>(ecmap.keySet());
		anni.sort();

		for(Integer anno : anni){
			String s = 'Anno: ' + anno + ' - Mesi: ';

			Boolean first = true;

			List<Integer> mesi = ecmap.get(anno);
			mesi.sort();
			for(Integer mese : mesi){
				if(first){
					s += mese;
					first=false;
				}else{
					s += ', '+ mese;
				}
			}
			notaSpecificaPV += s + '<br>';
		}

		return notaSpecificaPV;
	}


	public override XCS_Messaggio__c preparaMessaggioOCS(PVForm form, XCS_Messaggio__c xcs_messaggio) {
		//preparazione XCS_Messaggio
		PV1761CopiaEstrattoContoForm myForm = (PV1761CopiaEstrattoContoForm) form;
		xcs_messaggio.NumPratica__c = myForm.pratica.numPratica;
		xcs_messaggio.TipoPratica__c = myForm.pratica.tipoPratica;
		xcs_messaggio.CodCliente__c = myForm.pratica.codCliente;
		return xcs_messaggio;
	}


	public override void insertTabelleExtra(PVForm pvForm, Case casoPV) {
		PV1761CopiaEstrattoContoForm myForm = (PV1761CopiaEstrattoContoForm) pvForm;


		List<RichiestaEC__c> richiesteToInsert = new List<RichiestaEC__c>();

		String address = '\\N';
		String cap = '\\N';
		String prov = '\\N';
		String city = '\\N';

		List<Case> cases = [SELECT caseNumber FROM Case WHERE id = :casoPV.Id];
		String caseNumber = cases [0].caseNumber;

		// Recupero una sola volta l'indirizzo della filiale, se send_to=filiale

		if(myForm.ecs.size()>0){

			if(myForm.ecs[0].send_to == 'Cliente') {
				address = myForm.ecs[0].address;
				cap = myForm.ecs[0].cap;
				prov = myForm.ecs[0].prov;
				city = myForm.ecs[0].city;
			} else {
				// Siamo nel caso (myForm.ecs[0].filiale == 'Filiale')
				// Recupero l'indirizzo da Account

				List<Account> filiali = [SELECT Address_Abbr_Sms__c FROM Account WHERE Type = 'FIL' AND OCS_External_Id__c = :myForm.ecs[0].filiale ORDER BY Name ASC];
				if(filiali == null || filiali.size() == 0) {
					gestisciException('Filiale non trovata');
				} else {
					address = filiali [0].Address_Abbr_Sms__c;
				}
			}
		}

		Integer addressMaxLength = 100;
		Integer textMaxLength = 40;
		for(ECDto ec :myForm.ecs) {
			RichiestaEC__c ecRic = new RichiestaEC__c();
			ecRic.case_no__c = casoPV.Id;
			ecRic.loan_number__c = ec.loan_number;
			ecRic.ec_anno__c = ec.ec_anno;
			ecRic.ec_mese__c = ec.ec_mese;
			ecRic.send_to__c = ec.send_to;

			ecRic.address__c = abbreviateIfExceeds(address, addressMaxLength);
			ecRic.cap__c = cap; // gestito da frontend
			ecRic.city__c = abbreviateIfExceeds(city, textMaxLength);
			ecRic.prov__c = prov; // gestito da frontend

			ecRic.cognome__c = abbreviateIfExceeds(ec.cognome, textMaxLength);
			ecRic.nome__c = abbreviateIfExceeds(ec.nome, textMaxLength);
			ecRic.ocs_anag__c = ec.ocs_anag;
			richiesteToInsert.add(ecRic);
		}

		insert richiesteToInsert;

	}

	private String abbreviateIfExceeds(String s, Integer n) {
		if(s.length() > n) {
			return s.substring(0, n);
		} else {
			return s;
		}
	}

	public class ECDto {
		@AuraEnabled public String loan_number { get; set; }
		@AuraEnabled public String ec_anno { get; set; }
		@AuraEnabled public String ec_mese { get; set; }
		@AuraEnabled public String send_to { get; set; }
		@AuraEnabled public String address { get; set; }
		@AuraEnabled public String city { get; set; }
		@AuraEnabled public String prov { get; set; }
		@AuraEnabled public String cap { get; set; }
		@AuraEnabled public String filiale { get; set; }
		@AuraEnabled public String cognome { get; set; }
		@AuraEnabled public String nome { get; set; }
		@AuraEnabled public String ocs_anag { get; set; }
	}





}