/**
 * @File Name          : PV5866RichiestaConteggiEAController.js
 * @Description        : 
 * @Author             : Federica Forte
 * @Group              : 
 * @Last Modified By   : Federica Forte
 * @Last Modified On   : 17/1/2020, 14:53:05
 * @Modification Log   : 
 * Ver       Date            Author      		    Modification
 * 1.0    19/12/2019   Federica Forte     Initial Version
**/
({
    init : function(cmp, event, helper) {
        if ($A.util.isUndefinedOrNull(cmp.get("v.PVForm.isCheckFax"))) {
            cmp.set("v.PVForm.isCheckFax", false);
        }
    }
})