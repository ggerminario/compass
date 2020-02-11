/**
 * @File Name          : PV3824CpayCredenzialiGestioneHelper.js
 * @Description        : 
 * @Author             : Raffaele Prudenzano
 * @Group              : 
 * @Last Modified By   : Raffaele Prudenzano
 * @Last Modified On   : 8/1/2020, 14:19:51
 * @Modification Log   : 
 * Ver       Date            Author      		    Modification
 * 1.0    8/1/2020   Raffaele Prudenzano     Initial Version
**/
({
    doInitHelper : function(cmp, event, helper) {
        var parent = cmp.get("v.parent");
        parent.set('v.messaggiErrore',""); 
        console.log("case: " + JSON.stringify(cmp.get('v.theCase')));
        cmp.set("v.userData",cmp.get("v.parent").get("v.userData"));
    },


    save: function (cmp, event, helper) {
        var parent = cmp.get("v.parent");
		parent.set('v.messaggiErrore','');
		var rinvia = false;
		if(!$A.util.isUndefinedOrNull(cmp.find("checkboxRinviaAlMittente"))){
			rinvia = cmp.find("checkboxRinviaAlMittente").get('v.checked');
		}
        
          cmp.get("v.parent").methodShowWaitComponent(); 
          var action = cmp.get('c.saveCase');
            action.setParam('form',
                {
                    "newStatus": cmp.get('v.newStatus'),
                    "note": cmp.get("v.note"),
                    "userData" : parent.get('v.userData'),
                    "rinvia" : rinvia
                }
            );
            action.setParam('theCase', cmp.get("v.theCase"));
            // Imposto la Callback
            action.setCallback(this, function (response, helper) {
                if (response.getState() == 'SUCCESS') {
                    //qui mettere codice se c'è altro da fare in caso di SUCCESS
                    cmp.get("v.parent").showToast(response,"","");                    
                }
                else if (response.getState() === "ERROR") {
                    cmp.get("v.parent").showToast(response,"","");                    
                }
                cmp.get("v.parent").methodHideWaitComponent();
            });
            $A.enqueueAction(action);
    },    
})