({
    save: function (cmp, event, helper) {
        
            //cmp.set("v.errorMessage", "");
            cmp.get("v.parent").methodShowWaitComponent();
            var action = cmp.get('c.saveCase');
            action.setParam('form',
                {
                    "newStatus": cmp.get('v.newStatus'),
                    "note": cmp.get("v.note"),
                    "attachmentList": cmp.get('v.allegati'),
                    "userData": cmp.get("v.parent").get('v.userData'),

                }
            );
            action.setParam('theCase', cmp.get("v.theCase"));
            // Imposto la Callback
            action.setCallback(this, function (response, helper) {
                if (response.getState() == 'SUCCESS') {
                    //qui mettere Codice se c'è altro da fare in caso di SUCCESS
                }
                else if (response.getState() === "ERROR") {
                }
                cmp.get("v.parent").showToast(response, "", "");
                cmp.get("v.parent").methodHideWaitComponent();
            });
            $A.enqueueAction(action);
        
    },

})