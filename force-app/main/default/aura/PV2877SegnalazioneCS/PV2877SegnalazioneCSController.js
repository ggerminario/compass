({
    doInit : function(component, event, helper) {
        helper.doInit(component,event,helper);
    },
    selectPratica: function (cmp, event, helper) {
        // AV TODO non dovremmo gestire la selezione multipla??
        cmp.set('v.praticaSelezionata', event.getParam('selectedRows')[0]);
    },
    rimuoviPratica: function (cmp, event, helper) {
        // AV TODO non dovremmo gestire la selezione multipla??
        var praticaSelezionata = cmp.get('v.praticaSelezionata');
        var listaPratiche = cmp.get("v.praticheList");
        var indexToRemove;
        for(var i=0;i<listaPratiche.length;i++){
            if(praticaSelezionata.numPratica == listaPratiche[i].numPratica){
                indexToRemove = i;
                break;
            }
        }
        listaPratiche.splice(indexToRemove,1);
        cmp.set("v.praticheList",listaPratiche);
        cmp.set("v.PVForm.selectedPratiche",listaPratiche);
        if(praticaSelezionata.numPratica = cmp.get("v.PVForm.pratica.numPratica")){
            cmp.set("v.PVForm.pratica",null);
        }
    },
    handleChangeArgomento : function (component,event,helper){
        helper.selectTemplate(component,event);
    }
})