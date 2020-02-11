({
    validateUserInput: function(component) {
        console.log('[PV2871DuplicatoCarta - validateUserInput]');
        var message = this.checkClienteSelezionato(component);

        if($A.util.isEmpty(message)) {
            message = this.checkPraticaSelezionata(component);
        }

        if($A.util.isEmpty(message)) {
            message = this.checkIndirizzo(component);
        }

        return $A.util.isEmpty(message) ? "" : message;
    },

    onSubtypeSelected: function (component) {
        console.log('[PV2871DuplicatoCarta - onSubtypeSelected]');
        this.clearErrors(component);
        this.setIndirizzoCliente(component);
        this.setDatiDuplicatoCarta(component);
    },

    onReasonSelected: function (component) {
        console.log('[PV2871DuplicatoCarta - onReasonSelected]');
        this.clearErrors(component);
        this.setIndirizzoCliente(component);
        this.setDatiDuplicatoCarta(component);
    },

    onClienteSelected: function (component) {
        console.log('[PV2871DuplicatoCarta - onClienteSelected]');
        this.clearErrors(component);
        this.setIndirizzoCliente(component);
        this.setDatiDuplicatoCarta(component);
    },

    onPraticaSelected: function (component) {
        console.log('[PV2871DuplicatoCarta - onPraticaSelected]');
        this.clearErrors(component);
        this.setIndirizzoCliente(component);
        this.setDatiDuplicatoCarta(component);
        
        
    },

    inserisciCase: function (component, event) {
        console.log('[PV2871DuplicatoCarta - inserisciCase]');
        var errorMessage = this.replaceNtoBR(this.validateUserInput(component, event));

        if ($A.util.isEmpty(errorMessage)) {
            //TODO sblocco carta, operazione pre furto, inserisci Case
            this.bloccoSbloccoCarta(component, event);
           
        }
        else {
            this.mostraErrori(component,errorMessage);
        }
    },

    completaPVForm: function (component, event, helper, PVForm) {
        console.log('[PV2871DuplicatoCarta - completaPVForm] PVForm:', PVForm);

        if(!$A.util.isEmpty(component.get("v.bloccoCarta"))) {

            PVForm.bloccoCarta = {
                keyCode: component.get("v.bloccoCarta"),
                descrizione: ''
            };
        }
        else {
            PVForm.bloccoCarta = '';
        }

        if(!$A.util.isEmpty(component.get("v.nuovoPan"))) {

            PVForm.nuovoPan = component.get("v.nuovoPan");
        }
        else {
            PVForm.nuovoPan = '';
        }

        return PVForm;
    },

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

    checkIndirizzo: function(component) {
        var isValidAddress = component.find("isValidAddress");
        return ($A.util.isEmpty(isValidAddress) || isValidAddress.get("v.value") !== 'YES') ? "Verificare l'indirizzo" : "";
    },

    setIndirizzoCliente: function (component) {
        console.log('[PV2871DuplicatoCarta - setIndirizzoCliente]');

        if (this.isValid(component))
        {
            component.set("v.showDetails", true);
            this.mostraClessidra(component);

            var action = component.get("c.getIndirizziCliente");
            var codCliente = component.get("v.PVForm.cliente.codCliente");

            action.setParams({
                'codiceCliente': codCliente
            });

            action.setCallback(this, function(response) {
                console.log('[PV2871DuplicatoCarta - setIndirizzoCliente] action state:', response.getState());

                if (component.isValid() && response.getState() === "SUCCESS" && response.getReturnValue()) {

                    if(!$A.util.isEmpty(response.getReturnValue())) {
                        var indirizzo = response.getReturnValue().find(function (item) {
                            return !$A.util.isEmpty(item) && item.tipoIndirizzo === 'D' && !$A.util.isEmpty(item.indirizzo);
                        });

                        if($A.util.isEmpty(indirizzo)) {
                            indirizzo = response.getReturnValue().find(function (item) {
                                return !$A.util.isEmpty(item) && item.tipoIndirizzo === 'R' && !$A.util.isEmpty(item.indirizzo);
                            });
                        }

                        console.log('[PV2871DuplicatoCarta - setIndirizzoCliente] indirizzoCliente:', indirizzo);
                        component.set("v.indirizzoCliente", indirizzo);
                    }
                }
                else {
                    this.handleErrors(component, response);
                }

                this.nascondiClessidra(component);
            });

            $A.enqueueAction(action);
        }
        else {
            component.set("v.showDetails", false);
        }
    },

    setDatiDuplicatoCarta: function (component) {
        console.log('[PV2871DuplicatoCarta - setDatiDuplicatoCarta]');

        if (this.isValid(component))
        {
            component.set("v.showDetails", true);
            this.mostraClessidra(component);

            var action = component.get("c.getDatiDuplicatoCarta");
            var numeroCarta = component.get("v.PVForm.pratica.numPratica");

            action.setParams({
                'numeroCarta': numeroCarta
            });

            action.setCallback(this, function(response) {
                console.log('[PV2871DuplicatoCarta - setDatiDuplicatoCarta] action state:', response.getState());

                if (component.isValid() && response.getState() === "SUCCESS" && response.getReturnValue()) {
                    var datiDuplicatoCarta = response.getReturnValue();
                    
                    console.log('[PV2871DuplicatoCarta - setDatiDuplicatoCarta] datiDuplicatoCarta:', datiDuplicatoCarta);

                    if(datiDuplicatoCarta.errore !== true && $A.util.isEmpty(datiDuplicatoCarta.as400Errore) && datiDuplicatoCarta.as400Status === 'OK') {
                        component.set("v.datiDuplicatoCarta", datiDuplicatoCarta);
                        component.set('v.cartaDatiFinanziariData', datiDuplicatoCarta);
                        console.log(datiDuplicatoCarta);
                        this.showCartaDatiFinanziari(component, true);
                    }
                    else {
                        if(!$A.util.isEmpty(datiDuplicatoCarta.as400Errore)) {
                            this.mostraToast(component, 'Attenzione', datiDuplicatoCarta.as400Errore, 'warning', 10000);
                        }
                        else {
                            this.mostraToast(component, 'Attenzione', "E' stato riscontrato un problema con la funzionalità richiesta, contattare l'amministratore.", 'error', 10000);
                        }
                    }
                }
                else {
                    this.handleErrors(component, response);
                }

                this.nascondiClessidra(component);
            });

            $A.enqueueAction(action);
        }
        else {
            component.set("v.showDetails", false);
        }
    },

    clearErrors: function (component) {
        this.mostraErrori(component, "");
        this.showMarkup(component, true);
    },

    handleErrors: function(component, response) {
        if (response && response.getState() === "ERROR") {
            if (response.getError() && Array.isArray(response.getError()) && response.getError().length > 0) {
                console.error(response.getError()[0].message);
            }
        }

        this.mostraErrori(component, "E' stato riscontrato un problema con la funzionalità richiesta, contattare l'amministratore.");
    },

    calcoloComm: function (component) {
        console.log('[PV2871DuplicatoCarta - calcoloComm]');


            var action = component.get("c.calcolaCommissioni");
            var numeroCarta = component.get("v.PVForm.pratica.numPratica");

            action.setParams({
                'numeroCarta': numeroCarta
            });

            action.setCallback(this, function(response) {
                console.log('[PV2871DuplicatoCarta - calcoloComm] action state:', response.getState());

                if (component.isValid() && response.getState() === "SUCCESS" && response.getReturnValue()) {
                    var datiDuplicatoCarta = response.getReturnValue();
                    
                    console.log('[PV2871DuplicatoCarta - calcoloComm] datiDuplicatoCarta:', datiDuplicatoCarta);

                    if(datiDuplicatoCarta.errore !== true && $A.util.isEmpty(datiDuplicatoCarta.as400Errore) && datiDuplicatoCarta.as400Status === 'OK') {
                        component.set("v.datiDuplicatoCarta", datiDuplicatoCarta);
                       
                    }
                    else {
                        if(!$A.util.isEmpty(datiDuplicatoCarta.as400Errore)) {
                            this.mostraToast(component, 'Attenzione', datiDuplicatoCarta.as400Errore, 'warning', 10000);
                        }
                        else {
                            this.mostraToast(component, 'Attenzione', "E' stato riscontrato un problema con la funzionalità richiesta, contattare l'amministratore.", 'error', 10000);
                        }
                    }
                }
                else {
                    this.handleErrors(component, response);
                }

                this.nascondiClessidra(component);
            });

            $A.enqueueAction(action);
        },
        bloccoSbloccoCarta: function (component, event) {
            console.log('[PV2871DuplicatoCarta - bloccoSbloccoCarta]');
            this.mostraClessidra(component);
    
            var action = component.get("c.bloccoSbloccoCarta");
            var numeroCarta = component.get("v.PVForm.pratica.numPratica");
            var tipoOperazione = 'I';
            var bloccoCarta = component.get('v.PVForm.sottotipologiaMdt.uniqueId__c') === 123 ? 'SX' : component.get('v.PVForm.sottotipologiaMdt.uniqueId__c') === 126 ? 'PE' : component.get('v.PVForm.sottotipologiaMdt.uniqueId__c') === 124 ? 'PT': component.get('v.PVForm.sottotipologiaMdt.uniqueId__c') === 125 ? 'LL' : null;
           
            var utente = '';
    
            action.setParams({
                'numeroCarta': numeroCarta,
                'tipoOperazione': tipoOperazione,
                'bloccoCarta': bloccoCarta,
                'utente': utente
            });
    
            action.setCallback(this, function(response) {
                console.log('[PV2871DuplicatoCarta - bloccoSbloccoCarta] action state:', response.getState());
    
                if (component.isValid() && response.getState() === "SUCCESS" && response.getReturnValue()) {
                    var result = response.getReturnValue();
                    console.log('[PV2871DuplicatoCarta - bloccoSbloccoCarta] result:', result);
                    console.log('errore',result.as400Errore=='8002 Conto già in blocco di pre-sostituzione');
                        console.log('Status',result.as400Status == 'KO');
                        console.log('res',result);

                        component.set('v.bloccoCarta', result.bloccoCarta);

                    if((result && $A.util.isEmpty(result.as400Errore) && result.as400Status !== 'KO') || (result && (result.as400Errore=='8002 Conto già in blocco di pre-sostituzione') && result.as400Status == 'KO' )) {
                        //this.mostraToast(component, tipoOperazione === 'I' ? ('Inserimento blocco ' + result.bloccoCarta) : 'Annullo blocco', 'Operazione completata', 'success', 10000);
                        //this.getBlocchiCarte(component);
                        this.azionePreFurtoFurto(component, event);
                        
                    }
                    
                    else {
                        this.mostraToast(component, 'Attenzione', result.as400Errore, 'warning', 10000);
                    }
                }
                else {
                    this.handleErrors(component, response);
                }
    
                this.nascondiClessidra(component);
            });
    
            $A.enqueueAction(action);
        },

     azionePreFurtoFurto: function (component, event) {
            console.log('[PV2871DuplicatoCarta - azionePreFurtoFurto]');
            this.mostraClessidra(component);
    
            var action = component.get("c.azionePreFurtoFurto");
            var numeroCarta = component.get("v.PVForm.pratica.numPratica");
            var addebitoCommissioni = component.get('v.datiDuplicatoCarta.applicaCommissioni') ? 'S': 'N';
            var importoCommissioni =component.get('v.datiDuplicatoCarta.commissioni');
            var provenienza = component.get("v.PVForm.pratica.tipoPratica");
            var utente = null;
           
            var tipoIntermediario ='AG';
            var intermediario='12';
            var operazione = 'F';
            var modEmissione = 'S';
            var dataValidita = '0';
            var mesiValidita = '0';



    
            action.setParams({
                'numCarta': numeroCarta,
                'addebitoCommissioni': addebitoCommissioni,
                'importoCommissioni': importoCommissioni,
                'utente': utente,
                'provenienza': provenienza,
                'tipoIntermediario': tipoIntermediario,
                'intermediario': intermediario,
                'operazione': operazione,
                'modEmissione': modEmissione,
                'dataValidita': dataValidita,
                'mesiValidita': mesiValidita


            });
    
            action.setCallback(this, function(response) {
                console.log('[PV2871DuplicatoCarta - azionePreFurtoFurto] action state:', response.getState());
                console.log('Addebito si o no:', addebitoCommissioni);
                console.log('Importo:', importoCommissioni);
                console.log('Tipo intermediario', tipoIntermediario);
                console.log('Data validità:', dataValidita);
                console.log('response:', JSON.stringify(response));
                console.log('Return Value:', response.getReturnValue());
                console.log('component.isValid:', component.isValid());
               
                if (component.isValid() && response.getState() === "SUCCESS" && response.getReturnValue()) {
                    var result = response.getReturnValue();
                    console.log('[PV2871DuplicatoCarta - azionePreFurtoFurto] result:', result);
                    component.set("v.nuovoPan", response.getReturnValue().panNuovo);
    
                    if ((result && $A.util.isEmpty(result.as400Errore) && result.as400Status !== 'KO') || (result && (result.as400Errore=='5145 Importo commissioni nullo') && result.as400Status == 'KO' )) {
                        
                        this.conferma(component, event);
                        
                    }
                    else {
                        this.mostraToast(component, 'Attenzione', result.as400Errore, 'warning', 10000);
                    }
                }
                else {
                    this.handleErrors(component, response);
                }
    
                this.nascondiClessidra(component);
            });
    
            $A.enqueueAction(action);
        }

        
    
        
    
});