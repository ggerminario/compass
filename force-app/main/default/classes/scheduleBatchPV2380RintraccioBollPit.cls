/**
 * @File Name          : scheduleBatchPV2380RintraccioBollPit.cls
 * @Description        : 
 * @Author             : Matteo Gobbo
 * @Group              : 
 * @Last Modified By   : Matteo Gobbo
 * @Last Modified On   : 13/1/2020, 15:58:51
 * @Modification Log   : 
 * Ver       Date            Author      		    Modification
 * 1.0    13/1/2020   Matteo Gobbo     Initial Version
**/
global class scheduleBatchPV2380RintraccioBollPit implements schedulable {
      global void execute(SchedulableContext SC){
        batchPV2380RintraccioBollPosteItaliane BatchIstance = new batchPV2380RintraccioBollPosteItaliane();
        Database.executeBatch( BatchIstance, 100 );    
    }
}