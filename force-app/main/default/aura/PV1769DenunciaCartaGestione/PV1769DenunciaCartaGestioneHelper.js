({
    init: function (cmp, event, helper) {
        this.recuperaCircuitoCartaOCS(cmp);
    },

    save: function (cmp, event, helper) {

        var parent = cmp.get("v.parent");
        parent.set('v.messaggiErrore','');

        // controllo di aver selezionato il nuovo stato
        var isValid = this.validateUserInput(cmp, event, helper);

        /*-------------------------------------
        ########################################
                    INVIO EMAIL
        ########################################
        ---------------------------------------*/


        if (isValid){
            var action = cmp.get("c.InvioEmail");
            action.setParams({
                "emailAddress" : cmp.get("v.address"),
                "body" : cmp.get("v.email"),
                "circuito" : cmp.get("v.dataList.circuito") 
            });
            action.setCallback(this, function(response){
                //console.log("invio mail callback");
                if (response.getState() === 'SUCCESS') {
                    cmp.get("v.parent").showToast(response,"","");
                }
                else if (response.getState() === "ERROR") {
                }
            });
            $A.enqueueAction(action);
        }



        /*-------------------------------------
        ########################################
               CREAZIONE NOTE GESTIONE PV
        ########################################
        ---------------------------------------*/

        var noteGestionePV="<br>";
        noteGestionePV = "Stato: " + cmp.get("v.newStatus") + "<br>";
        noteGestionePV = noteGestionePV + "Da inserire in stop list: " + cmp.get("v.resultStopList") + "<br>";
        noteGestionePV = noteGestionePV + "Circuito Carta: " + cmp.get("v.dataList.circuito") + "<br>";
        noteGestionePV = noteGestionePV + "PAN: " + cmp.get("v.dataList.pan") + "<br>";
        if(cmp.get("v.note") != ''){
            noteGestionePV = noteGestionePV + "Note: " + cmp.get("v.note") + "<br>";
        }

        /*-------------------------------------
        ########################################
            SALVATAGGIO E AGGIORNAMENTO CASE
        ########################################
        ---------------------------------------*/


        if (isValid) {
            console.log("is valid");
            console.log("esempio :" + parent.get('v.userData'));
            debugger;
            //cmp.set("v.errorMessage", "");
            parent.methodShowWaitComponent();
            var action = cmp.get('c.saveCase');
            action.setParam('form',
                {
                    "newStatus": cmp.get('v.newStatus'),
                    //"note": cmp.get("v.note"),
                    "note" : noteGestionePV,
                    "attachmentList": cmp.get('v.allegati'),
                    "userData": parent.get('v.userData')
                }
            );
            action.setParam('theCase', cmp.get("v.theCase"));
            // Imposto la Callback
            action.setCallback(this, function (response, helper) {
                if (response.getState() === 'SUCCESS') {
                    cmp.get("v.parent").showToast(response,"","");
                }
                else if (response.getState() === "ERROR") {
                }
                cmp.get("v.parent").showToast(response, "", "");
                cmp.get("v.parent").methodHideWaitComponent();
            });
            $A.enqueueAction(action);
        }else{
            if($A.util.isUndefinedOrNull(cmp.get("v.resultStopList"))){
                parent.set('v.messaggiErrore','Selezionare un\'opzione di stop list');
            }else if($A.util.isUndefinedOrNull(cmp.get("v.resultRicDisc"))){
                parent.set('v.messaggiErrore','Selezionare un\'opzione tra riconoscimento e disconoscimento');
            }
        }

    },

    
    validateUserInput: function (cmp, event, helper) {

        if(($A.util.isUndefinedOrNull(cmp.get("v.resultStopList"))) || ($A.util.isUndefinedOrNull(cmp.get("v.resultRicDisc")))){
            return false;
        }

        return true;

    },

    //Recupero circuito carta
    recuperaCircuitoCartaOCS: function (cmp) {
            console.log("recupera Circuito Carta OCS");
            var pratica = cmp.get("v.theCase.NumeroPratica__c");
            console.log("numpratica = " + pratica);
            var action = cmp.get('c.RecuperaCircuitoCartaOCS');
            action.setParams({
                "numeroCarta": pratica
            });
            // Imposto la Callback
            action.setCallback(this, function (response, helper) {
                console.log("recuperaCircuitoCartaOCS : result : " + JSON.stringify(response.getReturnValue()) + " - " + response.getState());
                if (response.getState() === "SUCCESS"  && response.getReturnValue()) {
                    cmp.set("v.dataList", response.getReturnValue());
                    console.log("dataList: " + JSON.stringify(cmp.get("v.dataList")));
                }else{
                    this.fireToast("Errore Gestione Post Vendita", "Errore nel processo di Recupera Circuito Carta", "error", 10000);
                }
            });
            $A.enqueueAction(action);


    },

    emailcomposerwithaddress: function(cmp, event, helper){
        this.componiEmail(cmp, event, helper);
        this.impostaIndirizzi(cmp, event, helper);
    },

    //componi email 
    componiEmail: function(cmp, event, helper) {
        var stopList = cmp.get("v.resultStopList");
        var circuito = cmp.get("v.dataList.circuito");
        var pan = cmp.get("v.dataList.pan");
        //var address = cmp.get("v.address");
        var email = cmp.get("v.email");
        var theCase = cmp.get("v.theCase");

        var parent = cmp.get("v.parent");
        parent.set('v.messaggiErrore','');
        //debugger;
        var action = cmp.get('c.doComponiEmail');
        action.setParams({
            "stopList": stopList,
            "circuito" : circuito,
            "pan" : pan,
            "email" : email,
            "theCase" : theCase
        });
        action.setCallback(this, function (response, helper){
            if(response.getReturnValue()){
                if(response.getReturnValue() === "errore circuito"){
                    parent.set('v.messaggiErrore','Circuito carta non valido. Valori ammessi VIS o EMC. Impossibile inserire in stop list.');
                    this.fireToast("Errore Gestione Post Vendita", "Circuito carta non valido. Valori ammessi VIS o EMC. Impossibile inserire in stop list.", "error", 10000);
                }
                else if (response.getReturnValue() === "errore pan"){
                    parent.set('v.messaggiErrore','PAN non valido. Impossibile inserire in stop list.');
                    this.fireToast("Errore Gestione Post Vendita", "PAN non valido. Impossibile inserire in stop list.", "error", 10000);
                }
                else{
                    cmp.set("v.email", response.getReturnValue());
                    //console.log("Campo email: " + cmp.get("v.email"));
                }
            }
        });
        $A.enqueueAction(action);

    },

    //imposta indirizzi di posta a cui inviare le mail
    impostaIndirizzi: function (cmp, event, helper) {
        var circuito = cmp.get("v.dataList.circuito");
        var action = cmp.get("c.doImpostaIndirizzi");
        action.setParams({
            "circuito" : circuito
        });
        action.setCallback(this, function(response, helper){
            if(response.getReturnValue()){
                cmp.set("v.address", response.getReturnValue());
                //console.log("Campo address: " + cmp.get("v.address"));
            }
        });
        $A.enqueueAction(action);
    },





    fireToast: function (header, message, type, duration) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            title: header,
            message: message,
            duration: duration,
            type: type,
            mode: 'dismissible'
        });
        toastEvent.fire();
    },

})