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
        cmp.set("v.errorMessage", "");
        
		var rinvia = false;
		if(!$A.util.isUndefinedOrNull(cmp.find("checkboxRinviaAlMittente"))){
			rinvia = cmp.find("checkboxRinviaAlMittente").get('v.checked');
		}

        var action = cmp.get('c.saveCase');
        
        action.setParam('form',
            {
                "newStatus": cmp.get('v.newStatus'),
                "note": cmp.get("v.note"),
                "attachmentList" : cmp.get('v.allegati') ,
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
     

})