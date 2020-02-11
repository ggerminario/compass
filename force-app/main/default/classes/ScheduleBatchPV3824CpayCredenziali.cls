/**
 * @File Name          : ScheduleBatchPV3824CpayCredenziali.cls
 * @Description        :
 * @Author             : Raffaele Prudenzano
 * @Group              :
 * @Last Modified By   : Raffaele Prudenzano
 * @Last Modified On   : 16/1/2020, 15:56:57
 * @Modification Log   :
 * Ver       Date            Author                  Modification
 * 1.0    15/1/2020   Raffaele Prudenzano     Initial Version
 **/
global with sharing class ScheduleBatchPV3824CpayCredenziali implements Schedulable {
	// Copiato da ScheduleBatchAnomalieDoc

	public ScheduleBatchPV3824CpayCredenziali() {
	}

	global void execute(SchedulableContext ctx) {
		Id idjob = Database.executeBatch(new BatchPV3824CpayCredenziali(), 20);
	}
}