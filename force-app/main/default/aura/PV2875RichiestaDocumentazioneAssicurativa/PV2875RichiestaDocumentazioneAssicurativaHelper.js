({
	onPraticaSelected: function (cmp) {
        this.loadPacchetti(cmp);
    },
    loadPacchetti: function(cmp){
        var pratica = cmp.get("v.PVForm.pratica");
        if(pratica){
            console.log('DocAssicurativa-Pratica:'+JSON.stringify(pratica));
            var action = cmp.get("c.recuperaPacchettiAssicurativi");
            action.setParams({  
                numPratica : pratica.numPratica
            });
            action.setCallback(this, function(response) {
                var state = response.getState();
                if (state === "SUCCESS") {
                    console.log('Response:'+response.getReturnValue());
                    cmp.set("v.pacchettiList", response.getReturnValue());
                }
                else if (state === "INCOMPLETE") {
                    console.log('INCOMPLETE');
                }
                else if (state === "ERROR") {
                    var errors = response.getError();
                    if (errors) {
                        if (errors[0] && errors[0].message) {
                            console.log("Error message: " + 
                                    errors[0].message);
                        }
                    } else {
                        console.log("Unknown error");
                    }
                }
            });
            $A.enqueueAction(action);
        }
    },
    selectPacchetto : function(component, event, helper) {
        var selectedRows = event.getParam('selectedRows');
        component.set("v.pacchettiSelezionati",selectedRows);
        //Aggiorno mappaPacchetti
        var pacchettiMap = component.get("v.pacchettiSelezionatiMap");
        var refreshedMap = {};
        for(var i=0;i<selectedRows.length;i++){
            refreshedMap[selectedRows[i].codServizio]=pacchettiMap[selectedRows[i].codServizio];
        }
        component.set("v.pacchettiSelezionatiMap",refreshedMap);

        console.log('Pacchetti Selezionati: '+JSON.stringify(component.get("v.pacchettiSelezionati")));
    },
    handleChangeFascicoliInformativi: function(component, event, helper){
        var codServizio = event.getSource().get("v.name");
        console.log('HandleChangeFascicoliInformativi Su Pacchetto: '+codServizio);
        var pacchettiMap = component.get("v.pacchettiSelezionatiMap");
        //1 Fascicoli Informativi
        //2 Vademecum
        //3 Entrambi 
        if(pacchettiMap[codServizio] == null){
            pacchettiMap[codServizio] = '1';
        }else if(pacchettiMap[codServizio]=='1'){
            pacchettiMap[codServizio] = null;
        }else if(pacchettiMap[codServizio]=='2'){
            pacchettiMap[codServizio] = '3';
        }else if(pacchettiMap[codServizio]=='3'){
            pacchettiMap[codServizio] = '2';
        }
        component.set("v.pacchettiSelezionatiMap",pacchettiMap);
        console.log("mappaPacchetti:"+JSON.stringify(pacchettiMap));
    },
    handleChangeVademecum: function(component,event,helper){
        var codServizio = event.getSource().get("v.name");
        console.log('HandleChangeFascicoliInformativi Su Pacchetto: '+codServizio);
        var pacchettiMap = component.get("v.pacchettiSelezionatiMap");
        //1 Fascicoli Informativi
        //2 Vademecum
        //3 Entrambi 
        if(pacchettiMap[codServizio] == null){
            pacchettiMap[codServizio] = '2';
        }else if(pacchettiMap[codServizio]=='2'){
            pacchettiMap[codServizio] = null;
        }else if(pacchettiMap[codServizio]=='1'){
            pacchettiMap[codServizio] = '3';
        }else if(pacchettiMap[codServizio]=='3'){
            pacchettiMap[codServizio] = '1';
        }
        component.set("v.pacchettiSelezionatiMap",pacchettiMap);
        console.log("mappaPacchetti:"+JSON.stringify(pacchettiMap));
    },
    validateUserInput: function(cmp, event, helper) {
        var messaggi = "";
        messaggi = this.checkClienteSelezionato(cmp);
        var pacchettiSelezionati = cmp.get("v.pacchettiSelezionati");
        if(pacchettiSelezionati.length==0){
            messaggi = 'Selezionare un\'assicurazione';
        }
        var pacchettiMap = cmp.get("v.pacchettiSelezionatiMap");
        for(var key in pacchettiMap){
            if(pacchettiMap[key]==null){
                messaggi += 'Selezionare una documentazione per il pacchetto: '+key +'\n';
            }
        }
		return messaggi;
	},

    completaPVForm: function(cmp, event, helper, PVForm) {
        // arricchisco il PVForm con dati specifici del PV
        PVForm.pacchettiSelezionati = cmp.get("v.pacchettiSelezionati");
        PVForm.mappaPacchettiSelezionati = cmp.get("v.pacchettiSelezionatiMap");
        console.log('CompletaPVForm pacchetti selezionati:'+JSON.stringify(cmp.get("v.PVForm.pacchettiSelezionati")));
        return PVForm;
    }
})