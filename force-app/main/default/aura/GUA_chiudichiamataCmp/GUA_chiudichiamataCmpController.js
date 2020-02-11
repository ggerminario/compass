({
    doInit: function(component, event, helper) {
        helper.getRelatedXCSDispositions(component, event, helper);
    },

    openModel: function(component, event, helper) {
        helper.openModel(component, event, helper);
    },

    closeModel: function(component, event, helper) {
        helper.closeModel(component, event, helper);
    },

    submitDetails: function(component, event, helper) {
        helper.submitDetails(component, event, helper);
    },
    onXCSSelectChange: function(component, event, helper) {
        var xcsValue = component.find("selectedDisposition").get("v.value");
        var dispoList = component.get('v.dispositionValues');

        var specialDispo = dispoList.filter(e => e.Name == 'Attività richiesta eseguita');
        console.log('#l specialDispo', JSON.stringify(specialDispo));
        if (specialDispo.length > 0) {
            if (xcsValue === specialDispo[0].Id) {
                helper.showDatiAggiuntiviDynamic(component, event, helper)
            } else {
                component.set("v.datiAggiuntivi", []);
                component.set("v.attivitaRichiestaEseguida", false);
                var idChiamato = component.get("v.idChiamato");
                //Chiudi Chiamata
                if(idChiamato && xcsValue == idChiamato){
                    component.set('v.openRichiami', true);
                }
            }
        }
    },

    closeCaseStatus: function(component, event, helper) {
        var checked = event.getSource().get('v.checked');
        component.set('v.closedCase', checked)
    }
});