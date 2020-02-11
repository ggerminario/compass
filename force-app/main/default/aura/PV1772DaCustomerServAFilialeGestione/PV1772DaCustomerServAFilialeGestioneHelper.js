/**
 * @File Name          : PV1772DaCustomerServAFilialeGestioneHelper.js
 * @Description        : 
 * @Author             : Federico Negro
 * @Group              : 
 * @Last Modified By   : Federico Negro
 * @Last Modified On   : 23/1/2020, 17:13:31
 * @Modification Log   : 
 * Ver       Date            Author      		    Modification
 * 1.0    28/10/2019   Federico Negro     Initial Version
**/
({
    doInitHelper : function(cmp, event, helper) {
        
        var parent = cmp.get("v.parent");
        parent.set('v.messaggiErrore',"");
    },

    save: function (cmp, event, helper) {
        var parent = cmp.get("v.parent");
        //15100013971
        parent.set('v.messaggiErrore','');
        console.log("2");

        var rinvia = false;
		if(!$A.util.isUndefinedOrNull(cmp.find("checkboxRinviaAlMittente"))){
			rinvia = cmp.find("checkboxRinviaAlMittente").get('v.checked');
		}
        
        if(parent.get("v.messaggiErrore") == ""){
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
        }
    },
   
})