({
    isValid: function(component) {
        var PVForm = component.get("v.PVForm");
        return !$A.util.isEmpty(PVForm)
            && !$A.util.isEmpty(PVForm.sottotipologiaMdt)
            && !$A.util.isEmpty(PVForm.sottotipologiaMdt.uniqueId__c)
            && !$A.util.isEmpty(PVForm.cliente)
            && !$A.util.isEmpty(PVForm.cliente.codCliente)
            && !$A.util.isEmpty(PVForm.pratica)
            && !$A.util.isEmpty(PVForm.pratica.numPratica)
            && PVForm.cliente.codCliente === PVForm.pratica.codCliente;
    },

    onPraticaSelected: function (component) {
        console.log('[PV1754StornoAddebito - onPraticaSelected]');
        this.clearErrors(component);

        this.setDatiFinanziariCarta(component);
    },

    validateUserInput: function(component) {
        console.log('[PV1754StornoAddebito - validateUserInput]');
        var message = this.checkClienteSelezionato(component);

        if($A.util.isEmpty(message)) {
            message = this.checkPraticaSelezionata(component);
        }

        if($A.util.isEmpty(message)) {
            message = this.checkRimborso(component);
        }

        if($A.util.isEmpty(message)) {
            message = this.checkSommaStorni(component);
        }

        if($A.util.isEmpty(message)) {
            message = this.checkSelezioneModalitaRimborso(component);
        }

        if($A.util.isEmpty(message)) {
            message = this.checkIndirizzoSpedizione(component);
        }

        if($A.util.isEmpty(message)) {
            message = this.checkDatiBonifico(component);
        }

        return $A.util.isEmpty(message) ? "" : message;
    },

    clearErrors: function (component) {
        this.mostraErrori(component, "");
        this.showMarkup(component, true);
    },

    inserisciCase: function (component, event) {
        console.log('[PV1754StornoAddebito - inserisciCase]');
        var errorMessage = this.replaceNtoBR(this.validateUserInput(component, event));

        if ($A.util.isEmpty(errorMessage)) {
            this.conferma(component, event);
        }
        else {
            this.mostraErrori(component,errorMessage);
        }
    },

    completaPVForm: function (component, event, helper, PVForm) {
        console.log('[PV1754StornoAddebito - completaPVForm] PVForm:', PVForm);

        PVForm.numeroPratica = component.get("v.cartaDatiFinanziariData").numeroPratica;

        if(!$A.util.isEmpty(component.get("v.tipoRimborso"))) {
            PVForm.elencoRimborsi = component.get("v.tipoRimborso").filter(rimborso => rimborso.value > 0);
        }
        else {
            PVForm.elencoRimborsi = [];
        }

        PVForm.richiestaRimborso = component.get("v.valueRimborso");

        if(!$A.util.isEmpty(component.get("v.valueRimborso")) && component.get("v.valueRimborso").toUpperCase() === 'SI') {
            const PVModalitaRimborso = component.find("modRimborso");
            const modalitaPagamento = PVModalitaRimborso.get("v.modalitaPagamentoSelected");

            if(modalitaPagamento === 'Assegno') {
                //ASSEGNO
                PVForm.modalitaRimborso = {
                    modalitaPagamento: modalitaPagamento,
                    denominazioneAzienda: PVModalitaRimborso.get("v.OCSClienteSelezionato.denominazioneAzienda"),
                    indirizzoSpedizione: PVModalitaRimborso.find("address").get("v.value"),
                    cap: PVModalitaRimborso.find("cap").get("v.value"),
                    provincia: PVModalitaRimborso.find("provincia").get("v.provinciaSelection"),
                    citta: PVModalitaRimborso.find("comune").get("v.comuneSelection")
                };
            }
            else if(modalitaPagamento === 'Bonifico') {
                //BONIFICO
                PVForm.modalitaRimborso = {
                    modalitaPagamento: modalitaPagamento,
                    intestatario: PVModalitaRimborso.find("intestatario").get("v.value"),
                    abi: PVModalitaRimborso.find("ABI__c").get("v.value"),
                    cab: PVModalitaRimborso.find("CAB__c").get("v.value"),
                    cc: PVModalitaRimborso.find("ContoCorrente__c").get("v.value"),
                    iban: PVModalitaRimborso.find("IBAN__c").get("v.value")

                };
            }
        }

        return PVForm;
    },

    checkRimborso: function(component) {
        return component.get("v.options").findIndex(option => option.value === component.get("v.valueRimborso")) < 0 ? "Selezionare se rimborso o meno" : "";
    },

    checkSommaStorni: function(component) {
        return component.get("v.sommaStorni") > 0 ? '' : "Inserire almeno un importo relativo ad uno storno";
    },

    checkSelezioneModalitaRimborso: function(component) {
        var message = '';
        var valueRimborso = component.get("v.valueRimborso");
        var modalitaRimborso = component.get("v.modalitaRimborso");

        if(!$A.util.isEmpty(valueRimborso) && valueRimborso.toUpperCase() === 'SI') {
            message = $A.util.isEmpty(modalitaRimborso) ? 'Selezionare la modalità di rimborso' : '';
        }

        return message;
    },

    checkIndirizzoSpedizione: function(component) {
        var message = '';
        var valueRimborso = component.get("v.valueRimborso");
        var modalitaRimborso = component.get("v.modalitaRimborso");

        if(!$A.util.isEmpty(valueRimborso) && valueRimborso.toUpperCase() === 'SI' && modalitaRimborso === 'Assegno') {
            const PVModalitaRimborso = component.find("modRimborso");

            if($A.util.isEmpty(PVModalitaRimborso.get("v.OCSClienteSelezionato.denominazioneAzienda"))) {
                message = "Denominazione azienda assente";
            }
            else if($A.util.isEmpty(PVModalitaRimborso.find("address").get("v.value"))) {
                message = "Indicare l'indirizzo di spedizione";
            }
            else if($A.util.isEmpty(PVModalitaRimborso.find("provincia").get("v.provinciaSelection"))) {
                message = 'Indicare la provincia';
            }
            else if($A.util.isEmpty(PVModalitaRimborso.find("comune").get("v.comuneSelection"))) {
                message = 'Indicare la città';
            }
            else if($A.util.isEmpty(PVModalitaRimborso.find("cap").get("v.value"))) {
                message = "Indicare il CAP";
            }
            else if(!$A.util.isEmpty(PVModalitaRimborso.find("cap").get("v.value")) && PVModalitaRimborso.find("cap").get("v.value").length !== 5) {
                message = "Il CAP deve essere di 5 cifre";
            }
        }

        return message;
    },

    checkDatiBonifico: function(component) {
        var message = '';
        var valueRimborso = component.get("v.valueRimborso");
        var modalitaRimborso = component.get("v.modalitaRimborso");

        if(!$A.util.isEmpty(valueRimborso) && valueRimborso.toUpperCase() === 'SI' && modalitaRimborso === 'Bonifico') {
            const PVModalitaRimborso = component.find("modRimborso");

            if($A.util.isEmpty(PVModalitaRimborso.find("intestatario").get("v.value"))) {
                message = "Indicare l'intestatario del conto";
            }
            /*
            else if($A.util.isEmpty(PVModalitaRimborso.find("ABI__c").get("v.value"))) {
                message = "Indicare l'ABI";
            }
            else if($A.util.isEmpty(PVModalitaRimborso.find("CAB__c").get("v.value"))) {
                message = 'Indicare il CAB';
            }
            else if($A.util.isEmpty(PVModalitaRimborso.find("ContoCorrente__c").get("v.value"))) {
                message = 'Indicare il C/C';
            }
            else if($A.util.isEmpty(PVModalitaRimborso.find("IBAN__c").get("v.value"))) {
                message = "Indicare l'IBAN";
            }
            */
            else if(PVModalitaRimborso.get("v.isIBANvalido") !== true) {
                message = "Per procedere verificare l'IBAN";
            }
        }

        return message;
    },

    setDatiFinanziariCarta: function(component) {

        if (this.isValid(component)) {
            component.set("v.showDetails", true);
            this.mostraClessidra(component);

            var action = component.get("c.getDatiFinanziariCarta");
            var numeroCarta = component.get("v.PVForm.pratica.numPratica");

            action.setParams({
                numeroCarta: numeroCarta
            });

            action.setCallback(this, function(response) {
                if (component.isValid() && response.getState() === "SUCCESS" && response.getReturnValue()) {
                    var detail = response.getReturnValue();
                    component.set("v.cartaDatiFinanziariData", detail);
                    this.showCartaDatiFinanziari(component, true);
                }


                else {
                    this.handleErrors(component, response);
                }

                this.nascondiClessidra(component);
            });

            $A.enqueueAction(action);
        } else {
            component.set("v.showDetails", false);
        }
    },
    init: function(component, event) {
       
        component.set("v.tipoRimborso", 
        [{id:"086", descrizione: "storno comm. contante express", value: 0},
        {id:"095", descrizione: "storno premio assicurativo", value: 0},
        {id:"200", descrizione: "storno quota annua", value: 0},
        {id:"202", descrizione: "storno commiss. Riprod.", value: 0},
        {id:"216", descrizione: "storno comm. ritard. pagamento", value: 0},
        {id:"217", descrizione: "storno spese di esattoria", value: 0},
        {id:"220", descrizione: "storno spese notifica DT", value: 0},
        {id:"305", descrizione: "storno spese invio e/c", value: 0},
        {id:"405", descrizione: "storno imposte bollo", value: 0},
        {id:"505", descrizione: "storno interessi di competenza", value: 0}
         ] 
        );
        component.set("v.showDetails", this.isValid(component));
        component.set("v.sommaStorni", 0);

    },
    onSubtypeSelected: function (component) {

        this.clearErrors(component);
        this.init(component, event);
    },

    onReasonSelected: function (component) {
      
        this.clearErrors(component);
        this.init(component, event);
    },
    onClienteSelected: function (component) {
    
        this.clearErrors(component);
        this.init(component, event);
    },
    onPraticaSelected: function (component) {
    
        this.clearErrors(component);
        this.init(component, event);
    },



})