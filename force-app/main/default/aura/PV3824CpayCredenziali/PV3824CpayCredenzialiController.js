/**
 * @File Name          : PV3824CpayCredenzialiController.js
 * @Description        : 
 * @Author             : Raffaele Prudenzano
 * @Group              : 
 * @Last Modified By   : Raffaele Prudenzano
 * @Last Modified On   : 24/1/2020, 11:36:56
 * @Modification Log   : 
 * Ver       Date            Author      		    Modification
 * 1.0    17/12/2019   Raffaele Prudenzano     Initial Version
**/
({
    init : function(cmp, event, helper) {
        if ($A.util.isUndefinedOrNull(cmp.get("v.PVForm.isCheckFax"))) {
            cmp.set("v.PVForm.isCheckFax", false);
        }
    }
})