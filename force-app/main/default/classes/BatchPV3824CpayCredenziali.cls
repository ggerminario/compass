/**
 * @File Name          : BatchPV3824CpayCredenziali.cls
 * @Description        :
 * @Author             : Raffaele Prudenzano
 * @Group              :
 * @Last Modified By   : Raffaele Prudenzano
 * @Last Modified On   : 16/1/2020, 10:36:03
 * @Modification Log   :
 * Ver       Date            Author                  Modification
 * 1.0    23/12/2019   Raffaele Prudenzano     Initial Version
 **/
global class BatchPV3824CpayCredenziali implements Database.Batchable<sObject>, Database.AllowsCallouts {

	/*
	 Funzioni create a scopo di test.
	 Il batch fa callouts, quindi non posso prima inserire altrimenti mi dà eccezione "uncommitted work pending".
	 Per questo motivo ho bisogno di poter impostare manualmente nel batch i campi c.Cip_Cliente__c (che è un campo formula) e c.CreatedDate senza inserire il case
	 */

	@TestVisible
	public DateTime now;

	public DateTime now() {
		return now == null ? DateTime.now() :now;
	}

	@TestVisible
	public String codCliente;

	public String getCodCliente(Case c) {
		return codCliente == null ? c.Cip_Cliente__c :codCliente;
	}

	public Boolean isCodClienteCustom() {
		return codCliente != null;
	}

	@TestVisible
	public Date createdDate;

	public Date getCreatedDate(Case c) {
		return createdDate == null ? c.CreatedDate.date() :createdDate;
	}

	// Costruttore

	global BatchPV3824CpayCredenziali() {
	}

	global Database.QueryLocator start(Database.BatchableContext BC) {
		// TODO decommentare
		// DateTime d2hAgo = now().addHours(-2);
		DateTime d2hAgo = now().addMinutes(-2);

		System.debug('Searching for cases (cat 3824) where LastModifiedDate < ' + d2hAgo);

		if(Test.isRunningTest() && isCodClienteCustom()) {
			// Nei test spesso imposto un codCliente inesistente, quindi per non entrare in conflitto con case già esistenti applico la regola:
			// Se sto facendo un test e ho settato il cliente custom, devo tenere in considerazione solo i case che riguardano quello specifico cliente
			// Sono costretto a usare seeAllData=true altrimenti non posso inserire tramite PV3824CpayCredenziali.conferma(..) il case su cui poi farò passare il batch
			return Database.getQueryLocator([Select id, caseNumber, CategoriaExternalId__c, Cip_Cliente__c, Esito__c, CreatedDate from Case where CategoriaExternalId__c = '3824' AND param_step__c = 'SYS' and Status = 'Sospeso' and Step_PV__c = '1' and LastModifiedDate < :d2hAgo and Cip_Cliente__c = :codCliente]);

		} else {
			return Database.getQueryLocator([Select id, caseNumber, CategoriaExternalId__c, Cip_Cliente__c, Esito__c, CreatedDate from Case where CategoriaExternalId__c = '3824' AND param_step__c = 'SYS' and Status = 'Sospeso' and Step_PV__c = '1' and LastModifiedDate < :d2hAgo]);
		}
	}

	global void execute(Database.BatchableContext BC, List<Case> caseList) {
		List<List<PV3824CpayCredenzialiContext>> ctxListList = new List<List<PV3824CpayCredenzialiContext>>();

		Integer i = 0;
		for(Case c :caseList) {
			i++;
			System.debug('### CONTATORE: ' + i + ', caseNumber: ' + c.caseNumber);
			List<PV3824CpayCredenzialiContext> ctxList = PV3824CpayCredenzialiContext.deserializeString(c.Esito__c);
			System.debug('ctxList: ' + ctxList);

			System.debug('getCodCliente(c): ' + getCodCliente(c));
			System.debug('getCreatedDate(c): ' + getCreatedDate(c));

			ctxList = PV3824CpayCredenzialiContext.makeCalloutsFromContext(ctxList, getCodCliente(c), getCreatedDate(c));

			c = PV3824CpayCredenzialiContext.aggiornaCasoPV(c, ctxList);
			ctxListList.add(ctxList);
		}
		if(!Test.isRunningTest())
			update caseList;

		i= 0;
		for(Case c :caseList) {
			// l ultimo parametro caseNumberChiusi non serve nel batch
			String thisNote = PV3824CpayCredenzialiContext.buildNote(ctxListList.get(i), false, null);
			System.debug('i: ' + i + ', thisNote: ' + thisNote);
			System.debug('c.id: ' + c.id);

			if(c.id != null && thisNote != null && thisNote.trim() != '') {
				System.debug('Posting note...');

				XCSChatterUtils.postMessagePV(c.id, thisNote);
			}
			i++;
		}
	}

	global void finish(Database.BatchableContext BC) {
		System.debug('### BatchPV3824CpayCredenziali finito');
	}
}