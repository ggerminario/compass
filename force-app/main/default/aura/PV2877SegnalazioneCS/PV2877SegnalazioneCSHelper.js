({
    doInit : function(cmp,event,helper) {
        this.recuperaFilialiHelper(cmp,event,helper);
    },
    recuperaFilialiHelper: function(cmp,event,helper){
        var action = cmp.get("c.recuperaFiliali");
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                cmp.set("v.options",response.getReturnValue());
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
    },
    recuperaListaArgomentiHelper: function(cmp){
        var motivoSelezionato = cmp.get("v.PVForm.reasonMdt.uniqueId__c");
        var action = cmp.get("c.recuperaListaArgomenti");
        action.setParams({
            reasonId: motivoSelezionato
        })
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                console.log('Mappa Argomenti Caricata');
                cmp.set("v.argomentiList",response.getReturnValue());
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
    },
    validateUserInput: function(cmp, event, helper) {
        var messaggi = "";
        messaggi += this.checkClienteSelezionato(cmp);
        messaggi += this.checkPraticaSelezionata(cmp);
        if(cmp.get("v.PVForm.note") == null || cmp.get("v.PVForm.note") == ''){
            messaggi += 'Specificare una motivazione nel campo note!\n';
        }
		return messaggi;
	},

    completaPVForm: function(cmp, event, helper, PVForm) {
        // arricchisco il PVForm con dati specifici del PV
        return PVForm;
    },
    
    onClienteSelected: function (cmp) {
    },
    onReasonSelected : function (cmp){
        this.recuperaListaArgomentiHelper(cmp);
        cmp.set("v.PVForm.templateBody","");
    },
	onPraticaSelected: function (cmp) {
        this.clearFields(cmp);
        this.showMarkup(cmp,true);
        this.addPratica(cmp);
    },
    onSubtypeSelected: function(cmp){
        var codiceSottotipologia = cmp.get("v.PVForm.sottotipologiaMdt.uniqueId__c");
        if(codiceSottotipologia == cmp.get("v.codiceSottotipologiaFiliale")){
            cmp.set("v.showFiliali",true);
        }else{
            cmp.set("v.showFiliali",false);
        }
    },
    addPratica : function(cmp){
        var errorMessage = "";
        var toInsert = true;
        var pratica = cmp.get("v.PVForm.pratica");
        console.log('CS-Pratica:'+JSON.stringify(pratica));
        if(pratica){
            var listaPratiche = cmp.get("v.praticheList");
            for(var i=0;i<listaPratiche.length;i++){
                if(pratica.numPratica == listaPratiche[i].numPratica){
                    toInsert = false;
                } 
            }
            if(toInsert){
                listaPratiche.push(pratica);
                cmp.set("v.praticheList",listaPratiche);
                cmp.set("v.PVForm.selectedPratiche",listaPratiche);
            }else{
                errorMessage = 'Pratica già inserita!';
            }
            this.mostraErrori(cmp,errorMessage); 
        }
    },
    clearFields: function (cmp) {
		this.mostraErrori(cmp, "");
		cmp.set("v.cartaDatiFinanziariData", null);
    },
    selectTemplate: function (component,event){
        var argSelezionato = component.get("v.PVForm.argomento");
        console.log('argomentoSelezionato:'+argSelezionato);
        //var argomento = component.get("v.PVForm.argomento");
        if(argSelezionato==""){
            component.set("v.PVForm.templateBody","");
        }else{
            var action = component.get("c.recuperaTemplate");
            action.setParams({  
                argSelected : argSelezionato
            });
            action.setCallback(this, function(response) {
                var state = response.getState();
                if (state === "SUCCESS") {
                    console.log('Response:'+response.getReturnValue());
                    component.set("v.PVForm.templateBody", this.htmlDecode(response.getReturnValue()));
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
    htmlDecode: function(input){
        var doc = new DOMParser().parseFromString(input, "text/html");
        return doc.documentElement.textContent;
    }
})