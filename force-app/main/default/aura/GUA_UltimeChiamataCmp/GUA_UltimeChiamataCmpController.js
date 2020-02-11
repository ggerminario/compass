({
    init: function(component, event, helper) {
        helper.showSpinner(component, event, helper);
        helper.getTaskById(component, event);
    },
    ShowHideAll: function(component, event) {
        helper.ShowHideAll(component, event);
    },

    // this function automatic call by aura:waiting event  
    showSpinner: function(component, event, helper) {
        // make Spinner attribute true for display loading spinner 
        helper.showSpinner(component, event, helper);
    },

    // this function automatic call by aura:doneWaiting event 
    hideSpinner: function(component, event, helper) {
        // make Spinner attribute to false for hide loading spinner  
        helper.hideSpinner(component, event, helper);
    },
})