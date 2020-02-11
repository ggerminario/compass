({
    doInit: function(cmp, event) {
        console.log('Nel do init helper.js');
        var currentCase = cmp.get("v.theCase");
        var action2 = cmp.get("c.fetchUserDetail");

    action2.setCallback(this, function(response) {
      var state = response.getState();
      if (state === "SUCCESS") {
        var res = response.getReturnValue();
        cmp.set("v.currentUser", res);
      } else if (state === "INCOMPLETE") {
        // do something
      } else if (state === "ERROR") {
        var errors = response.getError();
        if (errors) {
          if (errors[0] && errors[0].message) {
            console.log("Error message: " + errors[0].message);
          }
        } else {
          console.log("Unknown error");
        }
      }
    });
    $A.enqueueAction(action2);

    if(currentCase.Owner__c != undefined && currentCase.UfficioDestinazione__r != undefined && currentCase.Owner__c.toUpperCase().includes(currentCase.UfficioDestinazione__r.Name.toUpperCase())){
        cmp.set("v.piCondition", true);
    }

    if((currentCase.Step_PV__c == '3' && currentCase.Owner__c == 'PV Rintraccio Pagamenti') || (currentCase.Step_PV__c == '3' && cmp.get("v.piCondition"))){
        cmp.find("SBF").set("v.disabled", true);
        cmp.find("r0").set("v.value", true);
        cmp.find("r1").set("v.value", false);
        cmp.find("r2").set("v.value", false);

       
        var disableAnswer1 = cmp.find("r3");
        var disableAnswer2 = cmp.find("r4");
        var disableAnswer3 = cmp.find("r5");
        var PI = cmp.find("PI");

        //Setto a true la checkbox rintraccio
        PI.set("v.disabled", true);
        PI.set("v.value", true);

        console.log('Importo del case: ' + currentCase.pv_importo_boll__c);
        if (currentCase.pv_importo_boll__c <= 1500) {
            disableAnswer2.set("v.value", true);
            disableAnswer2.set("v.disabled", true);
            disableAnswer3.set("v.disabled", true);
            disableAnswer1.set("v.disabled", true);
        } else {
            cmp.find("SBF").set("v.disabled", true);
            cmp.find("SBF").set("v.value", false);
            disableAnswer3.set("v.value", true);
            disableAnswer2.set("v.disabled", true);
            disableAnswer3.set("v.disabled", true);
            disableAnswer1.set("v.disabled", true);
        }
     }
    },
    onSelectchoices: function(cmp, event) {
        //debugger;
        console.log('In onSelectchoices helper.js');
        var SBF = cmp.find("SBF").get("v.value");
        var PI = cmp.find("PI").get("v.value");

        if (event.getSource().getLocalId() == 'r0') {
            console.log('Cliccato r0');
            cmp.find("SBF").set("v.value", false);
            cmp.find("SBF").set("v.disabled", true);
            cmp.find("r1").set("v.value", false);
            cmp.find("r2").set("v.value", false);
            cmp.find("SBF").set("v.disabled", true);
            cmp.find("SBF").set("v.value", false);
            cmp.set("v.sceltaRate","");
        } else if (event.getSource().getLocalId() == 'r1') {
            console.log('Cliccato r1');
            cmp.find("SBF").set("v.disabled", false);
            cmp.find("r0").set("v.value", false);
            cmp.find("r2").set("v.value", false);
            cmp.find("SBF").set("v.disabled", false);
            cmp.set("v.sceltaRate","SI");
        } else if (event.getSource().getLocalId() == 'r2') {
            console.log('Cliccato r2');
            cmp.find("SBF").set("v.value", false);
            cmp.find("SBF").set("v.disabled", true);
            cmp.find("r1").set("v.value", false);
            cmp.find("r0").set("v.value", false);
            cmp.find("SBF").set("v.disabled", true);
            cmp.find("SBF").set("v.value", false);
            cmp.set("v.sceltaRate","NO");
        } 
        
        if (event.getSource().getLocalId() == 'r1' && cmp.find("r5").get("v.value")) {
            cmp.find("SBF").set("v.disabled", true);
            cmp.find("SBF").set("v.value", false);
        }

        if (SBF) {
            cmp.set("v.sbf", true);
        }
        if (PI) {
            cmp.set("v.pi", true);

        }
        console.log("R0: " + cmp.find("r0").get("v.value") + " R1: " + cmp.find("r1").get("v.value") + " R2: " + cmp.find("r2").get("v.value") + " R3: " + cmp.find("r3").get("v.value") + " R4: " + cmp.find("r4").get("v.value") + " R5: " + cmp.find("r5").get("v.value"));
    },
    save: function(cmp, event, helper) {
        var parent = cmp.get("v.parent");
        parent.set("v.messaggiErrore", "");
        var isValid = this.validateUserInput(cmp, event);
        console.log('Is valid: ' + isValid)
        if (isValid == "") {
            var noteGestionePV = this.creaNote(cmp,event);

            parent.methodShowWaitComponent();
            var action = cmp.get("c.saveCase");
            action.setParam("form", {
                newStatus: cmp.get("v.newStatus"),
                note: noteGestionePV,
                attachmentList: cmp.get("v.allegati"),
                userData: parent.get("v.userData"),
                flagRinvia: cmp.get("v.flagRinvia"),
                sbf: cmp.get("v.sbf"),
                pi: cmp.get("v.pi"),
                esitoSBF: cmp.get("v.esitoSBF"),
                esitoPIT: cmp.get("v.esitoPIT"),
                esitoSTO: cmp.get("v.esitoSTO"),
                sceltaRate: cmp.get("v.sceltaRate")
            });
            action.setParam("theCase", cmp.get("v.theCase"));
            // Imposto la Callback
            action.setCallback(this, function(response, helper) {
                if (response.getState() === "SUCCESS") {
                    cmp.get("v.parent").showToast(response, "", "");
                } else if (response.getState() === "ERROR") {}
                cmp.get("v.parent").showToast(response, "", "");
                cmp.get("v.parent").methodHideWaitComponent();
            });
            $A.enqueueAction(action);
        } else {
            parent.set("v.messaggiErrore", isValid);
        }
    },

    validateUserInput : function(cmp, event) {
        var messaggi = "";
        //Controllo se è stata selezionata una risposta alla domanda.
        if(cmp.find("r0") != undefined && cmp.find("r0").get("v.value") && !cmp.get("v.flagRinvia"))
            messaggi += 'Indicare se le rate sono minori uguali a 3';

        
        return messaggi;
    },

    creaNote : function(cmp,event){
        var note = '';
        var theCase = cmp.get("v.theCase");

        note += theCase.Owner__c != '' ? 'Richiesta inviata a ' + theCase.Owner__c + '\n' : '';

        if(cmp.find("SBF") != undefined && cmp.find("SBF").get("v.value")){
            note += 'Stato: Richiesto accredito SBF - Richiesta rintraccio inoltrata a PI\n';
        }

        if(cmp.get("v.esitoSBF") == 'OK'){
            note += 'Esito: Accredito SBF eseguito\n';

        }else if(cmp.get("v.esitoSBF") == 'KO'){
            note += 'Esito: Accredito SBF non eseguito\n';
        }

        if(cmp.get("v.esitoPIT") == 'OK'){
            note += 'Esito: Rintraccio positivo\n';
        }else if(cmp.get("v.esitoPIT") == 'KO'){
            note += 'Esito: Rintraccio negativo\n';
        }

        if(cmp.get("v.esitoSTO") == 'OK'){
            note += 'Esito: Storno effettuato\n';
        }else if(cmp.get("v.esitoSTO") == 'KO'){
            note += 'Esito: Storno non effettuato\n';
        }

        if(cmp.get("v.flagRinvia")){
            note += 'Rinviato al mittente\n'
        }
        return note;
    }
})