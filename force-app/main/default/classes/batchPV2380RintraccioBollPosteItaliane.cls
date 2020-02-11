/**
 * @File Name          : batchPV2380RintraccioBollPosteItaliane.cls
 * @Description        : 
 * @Author             : Matteo Gobbo
 * @Group              : 
 * @Last Modified By   : Matteo Gobbo
 * @Last Modified On   : 14/1/2020, 09:44:30
 * @Modification Log   : 
 * Ver       Date            Author      		    Modification
 * 1.0    13/1/2020   Matteo Gobbo     Initial Version
**/
global class batchPV2380RintraccioBollPosteItaliane implements Database.Batchable <sObject> ,Database.Stateful, Database.AllowsCallouts  {

    global id idCoda = [select id from group where developerName = 'URPAG' limit 1].id;
    global Database.QueryLocator start(Database.BatchableContext bc) 
    {
        String query = 'Select Id,createdDate, pv_importo_boll__c, pv_datavaluta_boll__c, pv_prov_uffpost_boll__c, pv_uffpost_boll__C, pv_sport_uff_boll__C, pv_bollettino__c, pv_cc_boll__c, pv_esito_poste__c, Tipo_Pratica__c, numeroPratica__c ' +
                       'from case where Categoria_Riferimento__r.name = \'Rintraccio bollettini clienti\' and status = \'Sospeso\' and pv_subtype__c = \'Ordinario\'';

        System.debug(Database.getQueryLocator(query));
		return Database.getQueryLocator(query);
	}

	global void execute(Database.BatchableContext bc, List <Case> scope) 
    {
        system.debug('Scope ' + scope);
        Date today = system.today();
     
        for( Case currentCase : scope )
        {
            String todayString = String.valueof(today.year()) + String.valueof(today.month()) + String.valueof(today.day());
            RecuperaElencoMovimentiResponse movContabili = RecuperaElencoMovimentiService.buildRecuperaElencoMovimentiResponse(currentCase.Tipo_Pratica__c,currentCase.numeroPratica__c,'','','');
            system.debug('movContabili ' + movContabili);
            if(movContabili.recuperaElencoMovimentiResponse.movimenti != null && movContabili.recuperaElencoMovimentiResponse.movimenti.size() > 0){
            for(RecuperaElencoMovimentiResponse.MovimentiEstrattoContoDTO currentMovement : movContabili.recuperaElencoMovimentiResponse.movimenti ) {
                if(currentMovement.importo == String.valueof(currentCase.pv_importo_boll__c) && todayString == currentMovement.dataValuta && today <= currentCase.createdDate+7){
                    currentCase.status = 'Closed';
                }
                else if(currentMovement.importo != String.valueof(currentCase.pv_importo_boll__c) && todayString != currentMovement.dataValuta && today > currentCase.createdDate+7){
                    currentCase.status = 'New';
                    currentCase.Step_PV__c = '3';
                    currentCase.OwnerId = idCoda != null ? idCoda : currentCase.ownerId;
                }
            }
          }
        }
          update scope; 
	}

	global void finish(Database.BatchableContext bc) {

    }
  }