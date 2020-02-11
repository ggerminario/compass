({
    rimuoviCliente: function (cmp, event, helper) {
        // AV TODO non dovremmo gestire la selezione multipla??
        helper.doRimuoviCliente(cmp,event,helper);
    },
    selectCliente: function (cmp, event, helper) {
        // AV TODO non dovremmo gestire la selezione multipla??
        cmp.set('v.clienteSelezionato', event.getParam('selectedRows')[0]);
    },
    inserisciRichiesta: function(cmp,event,helper){
        helper.inserisciRichiesta(cmp,event,helper);
    },
    closeModal: function(cmp,event,helper){
        helper.closeModel(cmp,event,helper);
    },
    doInit: function (cmp,event,helper){
        helper.doInit(cmp,event,helper);
    }
    
})