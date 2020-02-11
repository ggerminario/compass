({
    init: function(component, event, helper) {
        helper.getCases(component, event, helper);
    },
    getUtente: function(component, event, helper) {
        //helper.getUtenteHandler(component, event, helper);
    },
    refreshViewDetail: function(component, event, helper) {
        component.set('v.modalActif', false);
        console.log('lodalA ' + component.get('v.modalActif'));

    },
    cercaDealer: function(component) {
        var idCase = component.get("v.recordId");
        console.log('################## idCase ' + idCase);
        component.set("v.idCase", component.get("v.recordId"));
        component.set('v.isOpenModel', true);

    },




})