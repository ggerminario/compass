({
    handleManageContact: function(component, event, helper) {
        console.log(' ############### ' + component.get('v.CaseDealer'));
        //  helper.handleManageContact(component, event, helper);
    },
    callCampagna: function(component, event, helper) {
        helper.callCampagna(component, event, helper);
    },
    closeScriptCampagna: function(component) {
        component.set("v.showScript", false);
    }



})