/**
 * @File Name          : ScheduleBatchPV3824CpayCredenzialiTest.cls
 * @Description        :
 * @Author             : Raffaele Prudenzano
 * @Group              :
 * @Last Modified By   : Raffaele Prudenzano
 * @Last Modified On   : 16/1/2020, 10:22:45
 * @Modification Log   :
 * Ver       Date            Author                  Modification
 * 1.0    15/1/2020   Raffaele Prudenzano     Initial Version
 **/
@isTest
public with sharing class ScheduleBatchPV3824CpayCredenzialiTest {
	// Copiato da ScheduleBatchAnomalieDocTest
	public ScheduleBatchPV3824CpayCredenzialiTest() {
	}

	/*
	Ho bisogno di due schedulazioni, una per il minuto 0 e l'altra per il minuto 30
	Questo perchè se metto 0,30 o * /30 mi restituisce System.StringException: Seconds and minutes must be specified as integers:  0 0/30 9-17 ? * MON-SAT *
	 */

	// Dal lunedì al sabato, ogni mezzora, dalle 9 alle 17

	@isTest
	static void executeBatch1() {

		Test.startTest();
		// Dal lunedì al sabato, al minuto 00, dalle 9 alle 17
		String sch = ' 0 0 9-17 ? * MON-SAT *';
		System.schedule('test', sch, new ScheduleBatchPV3824CpayCredenziali());
		Test.stopTest();
	}

	@isTest
	static void executeBatch2() {

		Test.startTest();
		// Dal lunedì al sabato, al minuto 30, dalle 9 alle 17
		String sch = ' 0 30 9-17 ? * MON-SAT *';
		System.schedule('test', sch, new ScheduleBatchPV3824CpayCredenziali());
		Test.stopTest();
	}
}