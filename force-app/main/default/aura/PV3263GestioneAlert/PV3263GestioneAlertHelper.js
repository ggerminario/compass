({

    /*-----------------------------------------------------------------
    ###################################################################
                    STAMPA DATI FINANZIARI CARTA
    ###################################################################
    -----------------------------------------------------------------*/

    isValid: function(component) {
        var PVForm = component.get("v.PVForm");
        return (
          !$A.util.isEmpty(PVForm) &&
          !$A.util.isEmpty(PVForm.cliente) &&
          !$A.util.isEmpty(PVForm.cliente.codCliente) &&
          !$A.util.isEmpty(PVForm.pratica) &&
          !$A.util.isEmpty(PVForm.pratica.numPratica) &&
          PVForm.cliente.codCliente === PVForm.pratica.codCliente
        );
    },

    onPraticaSelected: function (component) {
        console.log('[PV3263GestioneAlert - onPraticaSelected]');
        this.infoSid(component);
        this.setCartaDatiFinanziari(component);
	},
	
	setCartaDatiFinanziari: function (component) {
        if (this.isValid(component)){
            console.log("in setCartaDatiFinanziari");
            this.mostraClessidra(component);
            var pratica = component.get("v.PVForm.pratica");
            var action = component.get('c.recuperaDatiFinanziari');
            action.setParams({
                "numeroCarta": pratica.numPratica
            });
            this.mostraClessidra(component);
            // Imposto la Callback
            action.setCallback(this, function (response) {
                console.log("recuperaInfoCarta : result : " + JSON.stringify(response.getReturnValue()) + " - " + response.getState());
                if (response.getState() === 'SUCCESS') {
                    var dati = response.getReturnValue();
                    component.set("v.cartaDatiFinanziariData", dati);
                    component.set("v.emettitore", dati.emettitore);



                    /*=======================================================
                           CONTROLLI SU INFOSID PER OPERATORE TELEFONICO
                    =========================================================*/
                    if(!($A.util.isUndefinedOrNull(component.get("v.infoSID")))){ //condizione principale: valori SID ritrovati
                        if(component.get("v.infoSID.operTelef")!= "    "){ //adeguamento campo operatore telefonico
                            var operTelef = JSON.stringify(JSON.parse(component.get("v.infoSID.operTelef")));
                            component.set("v.operTelefSel", operTelef);
                        }
                    }

                    this.showCartaDatiFinanziari(component, true);
                } else if (response.getState() === "ERROR") {
                    this.mostraToast(component, '', response.getError(), 'error', '');
                }
                this.nascondiClessidra(component);
            });
            $A.enqueueAction(action);
		}
    },
    


    /*-----------------------------------------------------------------
    ###################################################################
             RECUPERA INFOSID PER FORM GESTIONE ALERT 3263
    ###################################################################
    -----------------------------------------------------------------*/

    infoSid: function(component){
        console.log("in infoSID");
        if (this.isValid(component)){
            var pratica = component.get("v.PVForm.pratica");
            var action_2 = component.get('c.recuperaInfoSIDcmp');
            action_2.setParams({
                "numeroPratica": pratica.numPratica
            });

            action_2.setCallback(this, function (response) {
                console.log("recuperaInfoSID : result : " + JSON.stringify(response.getReturnValue()) + " - " + response.getState());
                if (response.getState() == 'SUCCESS' && (!($A.util.isUndefinedOrNull(response.getReturnValue())))) {
                    component.set("v.infoSID", response.getReturnValue());
                    component.set("v.newInfoSID", response.getReturnValue());
                    component.set("v.showAlert", true);
                    component.set("v.noAlert", false);
                } else if (response.getState() === "ERROR") {
                    this.mostraToast(component, '', 'Nessun alert precedentemente impostato.', 'error', 10000);
                    component.set("v.showAlert", true);
                    component.set("v.noAlert", true);
                }
                else {
                    this.mostraToast(component, '', 'Errore nella chiamata al servizio "RecuperaInfoSID"', 'error', 10000);
                    component.set("v.showAlert", false);
                }
                this.nascondiClessidra(component);

            });        
            $A.enqueueAction(action_2);
        }   
    },



    /*-----------------------------------------------------------------
    ###################################################################
                    METODI INTERNI AL COMPONENTE
    ###################################################################
    -----------------------------------------------------------------*/


    changeOpTel: function(component, event, helper){
        component.set("v.newInfoSID.operTelef", component.find("opTelef").get("v.value"));
    },


    /*-----------------------------------------------------------------
    ###################################################################
                        METODO DA PARENT
    ###################################################################
    -----------------------------------------------------------------*/

    validateUserInput: function(cmp, event, helper) {
        var messaggi = "";
        messaggi += this.checkClienteSelezionato(cmp);

        // Controllo che la pratica sia selezionata
        var praticaSelezionata = cmp.get("v.PVForm.pratica");
        if ($A.util.isUndefinedOrNull(praticaSelezionata)) {
            messaggi += "Selezionare una pratica.\n";
        }
        else if(cmp.get("v.newInfoSID.operTelef") == "    "){
            messaggi += "Selezionare un'operatore. \n";
        }

        return messaggi;
    },

    completaPVForm: function(cmp, event, helper, PVForm) {
        //debugger;
        // inserisco nel PVForm dati utili per l'elaborazione 
        PVForm.ot = cmp.get("v.newInfoSID.operTelef");
        PVForm.emettitore = cmp.get("v.emettitore");
        PVForm.attesaAtt = cmp.get("v.infoSID.attesaAttivazione");
        PVForm.info = cmp.get("v.newInfoSID");

        if(cmp.get("v.newInfoSID.avvisoAut")=='S'){
            cmp.set("v.newInfoSID.impSogliaAut", '180,0');
        }
        else{
            cmp.set("v.newInfoSID.impSogliaAut", '0');
        }

        if(cmp.get("v.newInfoSID.avvisoAut")=='N'){
            cmp.set("v.newInfoSID.impSogliaAutTot", '0');
        }

        // arricchisco il PVForm con note specifiche del PV
        PVForm.noteAggiornamentoCA = "Dati azione SID: \n";
        PVForm.noteAggiornamentoCA += "- Cellulare: " + cmp.get("v.newInfoSID.cellulare") + '\n';
        PVForm.noteAggiornamentoCA += "- Operatore Telefonico: " + cmp.get("v.newInfoSID.operTelef") + '\n';
        PVForm.noteAggiornamentoCA += "- Aggiornamento E/C: " + cmp.get("v.newInfoSID.servizioAggEc") + '\n';
        PVForm.noteAggiornamentoCA += "- Avvenuta Rateizzazione: " + cmp.get("v.newInfoSID.protCampServizio") + '\n';
        PVForm.noteAggiornamentoCA += "- Blocco/Sblocco: " + cmp.get("v.newInfoSID.bloccoServizio") + '\n';
        PVForm.noteAggiornamentoCA += "- Saldo Carta: " + cmp.get("v.newInfoSID.servizioSaldo");
        PVForm.noteAggiornamentoCA += " - Frequenza: " + cmp.get("v.newInfoSID.frequenzaSaldo") + '\n';
        PVForm.noteAggiornamentoCA += "- Super.Soglia Aut.Sing: " + cmp.get("v.newInfoSID.avvisoAut");
        PVForm.noteAggiornamentoCA += " - Imp.Soglia: " + cmp.get("v.newInfoSID.impSogliaAut") + '\n';
        PVForm.noteAggiornamentoCA += "- Presenza: " + cmp.get("v.newInfoSID.presSogliaAut") + '\n';
        PVForm.noteAggiornamentoCA += "- Super.Soglia Aut.Tot: " + cmp.get("v.newInfoSID.avvisoAutTot");
        PVForm.noteAggiornamentoCA += " - Imp.Soglia: " + cmp.get("v.newInfoSID.impSogliaAutTot") + '\n';
        PVForm.noteAggiornamentoCA += "- Superamento linea 1: " + cmp.get("v.newInfoSID.risPrincServizio") + '\n';
        

        return PVForm;
    },


})