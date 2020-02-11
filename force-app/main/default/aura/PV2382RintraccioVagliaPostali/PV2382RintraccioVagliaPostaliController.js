/**
 * @File Name          : PV2382RintraccioVagliaPostaliController.js
 * @Description        : 
 * @Author             : Federico
 * @Group              : 
 * @Last Modified By   : Federico
 * @Last Modified On   : 10/1/2020, 13:11:20
 * @Modification Log   : 
 * Ver       Date            Author      		    Modification
 * 1.0    10/1/2020   Federico     Initial Version
**/
({
    doInit : function(component, event, helper){
        var today = $A.localizationService.formatDate(new Date(), "YYYY-MM-DD");
        component.set('v.today', today);
    }
})