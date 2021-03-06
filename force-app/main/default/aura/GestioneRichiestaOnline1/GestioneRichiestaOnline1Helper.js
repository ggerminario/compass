({
    onInit: function(component) {
        var initialInBoundList = [{
                "code": "['Q525']",
                "label": "Link ripresa bozza via E-Mail",
                "value": "DP1346",
                "stati": "['05BT','10','20']",
                "families": ['PP_ONLINE_COMPASS_STANDARD'],
                "fea": true
            },
            {
                "code": "['Q525']",
                "label": "Richiesta info generiche sul carico",
                "value": "DP5632",
                "stati": "['','05BT','10','20','20SD','30','30CF']",
                "families": "['PF_ECOMMERCE_STANDARD']",
                "fea": true
            },
            {
                "code": "['Q525']",
                "label": "Invio link ripresa bozza",
                "value": "DP1346",
                "stati": "['','05BT','10','20','20SD','30','30CF']",
                "families": "['PP_ONLINE_COMPASS_DS','PF_ECOMMERCE_STANDARD','PP_ONLINE_PARTNER_DS']",
                "fea": true
            },
            {
                "code": "['Q525']",
                "label": "Non interessato",
                "value": "DP1349",
                "stati": "['','05BT','10','20','20SD','30','30CF']",
                "families": "['PP_ONLINE_COMPASS_DS','PF_ECOMMERCE_STANDARD','PP_ONLINE_PARTNER_DS']",
                "fea": true
            },
            {
                "code": "['Q525']",
                "label": "Disconosce la pratica",
                "value": "DP5228",
                "stati": "['05BT','10','20','20SD','30','30CF']",
                "families": "['PP_ONLINE_COMPASS_DS','PF_ECOMMERCE_STANDARD','PP_ONLINE_PARTNER_DS']",
                "fea": true
            }
        ];
        var initialNonEseguitoList = [{
                "code": "['Q330','Q331','Q332','Q333','Q336','Q375','Q337','Q376','Q338','Q339','Q340','Q341','Q377']",
                "label": "Cliente non trovato",
                "value": "DP1354",
                "stati": "['','05BT','10','20','20SD','30','30CF']",
                "families": ['PP_ONLINE_COMPASS_DS', 'PF_ECOMMERCE_STANDARD', 'PP_ONLINE_PARTNER_DS'],
                "fea": true
            },
            {
                "code": "['Q330','Q331','Q332','Q333','Q336','Q375','Q337','Q376','Q338','Q339','Q340','Q341','Q377']",
                "label": "Numero inesistente",
                "value": "DP1356",
                "stati": "['','05BT','10','20','20SD','30','30CF']",
                "families": ['PP_ONLINE_COMPASS_DS', 'PF_ECOMMERCE_STANDARD', 'PP_ONLINE_PARTNER_DS'],
                "fea": true
            },
        ];
        var initialEseguitoList = [{
                "code": "['Q330','Q331','Q332','Q333','Q375']",
                "label": "Invio link ripresa bozza",
                "value": "DP1346",
                "stati": "['','05BT','10','20','20SD','30','30CF']",
                "families": ['PP_ONLINE_COMPASS_DS', 'PP_ONLINE_PARTNER_DS'],
                "fea": true
            },
            {
                "code": "['Q330','Q331','Q332','Q333','Q336','Q338', Q339','Q340','Q375','Q376','Q341']",
                "label": "Non interessato",
                "value": "DP1349",
                "stati": "['','05BT','10','20','20SD','30','30CF']",
                "families": ['PP_ONLINE_COMPASS_DS', 'PF_ECOMMERCE_STANDARD', 'PP_ONLINE_PARTNER_DS'],
                "fea": true
            },
            {
                "code": "['Q330','Q331','Q332','Q333']",
                "label": "Fissa appuntamento",
                "value": "DP5920",
                "stati": "['','05BT','10','20','20SD','30','30CF']",
                "families": ['PP_ONLINE_COMPASS_DS'],
                "fea": true
            },
            {
                "code": "['Q336','Q376','Q338','Q339','Q340','Q377']",
                "label": "Caricherà la documentazione",
                "value": "DP1345",
                "stati": "['','05BT','10','20','20SD','30','30CF']",
                "families": ['PP_ONLINE_COMPASS_DS', 'PF_ECOMMERCE_STANDARD', 'PP_ONLINE_PARTNER_DS'],
                "fea": true
            },
            {
                "code": "['Q336','Q376','Q338','Q339','Q340','Q377']",
                "label": "Ha già caricato la documentazione",
                "value": "DP1344",
                "stati": "['','05BT','10','20','20SD','30','30CF']",
                "families": ['PP_ONLINE_COMPASS_DS', 'PF_ECOMMERCE_STANDARD', 'PP_ONLINE_PARTNER_DS'],
                "fea": true
            },
            {
                "code": "['Q337','Q336','Q376','Q338','Q339','Q340','Q377','Q341']",
                "label": "Disconosce la pratica",
                "value": "DP5228",
                "stati": "['05BT','10','20','20SD','30','30CF']",
                "families": ['PP_ONLINE_COMPASS_DS', 'PF_ECOMMERCE_STANDARD', 'PP_ONLINE_PARTNER_DS'],
                "fea": true
            },
            {
                "code": "['Q337','Q339','Q376', 'Q338',]",
                "label": "Conferma vecchio recapito",
                "value": "DP5155",
                "stati": "['05BT','10','20','20SD','30','30CF']",
                "families": ['PP_ONLINE_COMPASS_DS', 'PF_ECOMMERCE_STANDARD', 'PP_ONLINE_PARTNER_DS'],
                "fea": true
            },
            {
                "code": "['Q337','Q339','Q376', 'Q338',]",
                "label": "Conferma nuovo recapito",
                "value": "DP5154",
                "stati": "['05BT','10','20','20SD','30','30CF']",
                "families": ['PP_ONLINE_COMPASS_DS', 'PF_ECOMMERCE_STANDARD', 'PP_ONLINE_PARTNER_DS'],
                "fea": true
            },
            {
                "code": "['Q377','Q341']",
                "label": "Firmerà il contratto",
                "value": "DP5921",
                "stati": "['05BT','10','20','20SD','30','30CF']",
                "families": ['PP_ONLINE_COMPASS_DS', 'PP_ONLINE_PARTNER_DS'],
                "fea": true
            },
            {
                "code": "['Q377', 'Q341']",
                "label": "Ha già firmato il contratto",
                "value": "DP1344",
                "stati": "['05BT','10','20','20SD','30','30CF']",
                "families": ['PP_ONLINE_COMPASS_DS', 'PP_ONLINE_PARTNER_DS'],
                "fea": true
            },
            {
                "code": "['Q337','Q339','Q376','Q338']",
                "label": "Identità non confermata",
                "value": "DP5971",
                "stati": "['05BT','10','20','20SD','30','30CF']",
                "families": ['PP_ONLINE_COMPASS_DS', 'PF_ECOMMERCE_STANDARD', 'PP_ONLINE_PARTNER_DS'],
                "fea": true
            },
            
            {
                "code": "['Q337','Q339','Q376','Q338']",
                "label": "Non Ricorda",
                "value": "DP5972",
                "stati": "['05BT','10','20','20SD','30','30CF']",
                "families": ['PP_ONLINE_COMPASS_DS', 'PF_ECOMMERCE_STANDARD', 'PP_ONLINE_PARTNER_DS'],
                "fea": true
            },
            
            {
                "code": "['Q339','Q340','Q377','Q336','Q376','Q338','Q341']",
                "label": "Chiede di essere richiamato",
                "value": "DP1357",
                "stati": "['05BT','10','20','20SD','30','30CF']",
                "families": ['PP_ONLINE_COMPASS_DS', 'PF_ECOMMERCE_STANDARD', 'PP_ONLINE_PARTNER_DS'],
                "fea": true
            }
        ];
        var discordanzaCellulareEseguitaList = [{
            "code": "['Q337']",
            "label": "Identità non confermata",
            "value": "",
            "stati": "['05BT','10','20','40','50','30','30RT','30AN','60','70']",
            "families": ['PP_ONLINE_COMPASS_DS', 'PF_ECOMMERCE_STANDARD', 'PP_ONLINE_PARTNER_DS'],
            "fea": true
        }, ];
        var caricheraLaDocumentazione = [{
                "label": "Invio link ripresa bozza",
                "fea": true,
                "families": ['PP_ONLINE_COMPASS_DS', 'PF_ECOMMERCE_STANDARD', 'PP_ONLINE_PARTNER_DS'],
                "code": "['Q336','Q375','Q376','Q338','Q339','Q340','Q377']",
                "stati": "['05BT','10','20','20SD','30','30CF']",
                "value": "DP1346"
            },
            {
                "label": "Nessuna altra azione",
                "fea": true,
                "families": ['PP_ONLINE_COMPASS_DS', 'PF_ECOMMERCE_STANDARD', 'PP_ONLINE_PARTNER_DS'],
                "code": "['Q336','Q375','Q376','Q338','Q339','Q340','Q377']",
                "stati": "['','05BT','10','20','20SD','30','30CF']",
                "value": "DP1346"
            }
        ];
        var confermaVecchioRecapito = [{
                "label": "Invio link ripresa bozza",
                "fea": true,
                "families": ['PP_ONLINE_COMPASS_DS', 'PF_ECOMMERCE_STANDARD', 'PP_ONLINE_PARTNER_DS'],
                "code": "['Q337','Q339','Q340','Q376','Q338']",
                "stati": "['05BT','10','20','20SD','30','30CF']",
                "value": "DP5155"
            },
            {
                "label": "Nessuna altra azione",
                "fea": true,
                "families": ['PP_ONLINE_COMPASS_DS', 'PF_ECOMMERCE_STANDARD', 'PP_ONLINE_PARTNER_DS'],
                "code": "['Q337','Q339','Q340','Q376','Q338']",
                "stati": "['','05BT','10','20','20SD','30','30CF']",
                "value": "DP5155"
            },
        ];
        var confermaNuovoRecapito = [{
                "label": "Invio link ripresa bozza",
                "fea": true,
                "families": ['PP_ONLINE_COMPASS_DS', 'PF_ECOMMERCE_STANDARD', 'PP_ONLINE_PARTNER_DS'],
                "code": "['Q337','Q339','Q340','Q376','Q338']",
                "stati": "['05BT','10','20','20SD','30','30CF']",
                "value": "DP5154"
            },
            {
                "label": "Nessuna altra azione",
                "fea": true,
                "families": ['PP_ONLINE_COMPASS_DS', 'PF_ECOMMERCE_STANDARD', 'PP_ONLINE_PARTNER_DS'],
                "code": "['Q337','Q339','Q340','Q376','Q338']",
                "stati": "['','05BT','10','20','20SD','30','30CF']",
                "value": "DP5154"
            },
        ];
        var firmeraIlContratto = [{
                "label": "Invio link ripresa bozza",
                "fea": true,
                "families": ['PP_ONLINE_COMPASS_DS', 'PP_ONLINE_PARTNER_DS'],
                "code": "['Q377','Q341']",
                "stati": "['05BT','10','20','20SD','30','30CF']",
                "value": "DP1346"
            },
            {
                "label": "Nessuna altra azione",
                "fea": true,
                "families": ['PP_ONLINE_COMPASS_DS', 'PP_ONLINE_PARTNER_DS'],
                "code": "['Q377','Q341']",
                "stati": "['05BT','10','20','20SD','30','30CF']",
                "value": "DP1346"
            },
        ];
        var questions = [{
                "question": "ULTIMA RATA RIMBORSATA PAGATA",
                "response": "",
                "prodotto": "['CO']",
                "num": 1
            },
            {
                "question": "ULTIMI ACQUISTI EFFETTUATI",
                "response": "",
                "prodotto": "['CA','CP']",
                "num": 2
            },
            {
                "question": "modalià pagamento e IBAN collegato al prodotto",
                "response": "RID",
                "prodotto": "['CA','CO','CP']",
                "num": 3
            }
        ];
        var prodotti = [{
                "prodotto": "CO",
                "statoOcs": "['40']"
            },
            {
                "prodotto": "CA",
                "statoOcs": "['50','30','30RT','30AN','60','70']"
            },
            {
                "prodotto": "CP",
                "statoOcs": "['50']"
            }
        ];

        var listViews = [
            { "developerName": "Q524", "Name": "Coda Casi chiusi" },
            { "developerName": "Q525", "Name": "Richiesta Online-Non Contattare" },
            { "developerName": "Q330", "Name": "DS - Richieste Online - Abbandono Web" },
            { "developerName": "Q331", "Name": "DS - Richieste Online - Abbandono Non Fo" },
            { "developerName": "Q332", "Name": "DS - Richieste Online - Abbandono Forzos" },
            { "developerName": "Q333", "Name": "DS - Richieste Online - Richiamami" },
            { "developerName": "Q336", "Name": "Richieste Online - Abbandono E-commerce" },
            { "developerName": "Q337", "Name": "Richieste Online -Discord. Cell. E-comme" },
            { "developerName": "Q338", "Name": "Richieste Online - Anomalie Doc. E-comme" },
            { "developerName": "Q339", "Name": "DS - Richieste Online - Anomalie Pre Sic" },
            { "developerName": "Q340", "Name": "DS - Richieste Online - Anomalie Post Si" },
            { "developerName": "Q341", "Name": "DS - Richieste Online - Sollecito Contra" },
            { "developerName": "Q375", "Name": "DP - Abbandono" },
            { "developerName": "Q376", "Name": "DP - Anomalie" },
            { "developerName": "Q377", "Name": "DP - Sollecito Contratto" }
        ];

        component.set('v.listViews', listViews);
        component.set('v.initialInBoundList', initialInBoundList);
        component.set('v.initialNonEseguitoList', initialNonEseguitoList);
        component.set('v.initialEseguitoList', initialEseguitoList);
        //component.set('v.discordanzaCellulareEseguitaList', discordanzaCellulareEseguitaList);
        component.set('v.caricheraLaDocumentazione', caricheraLaDocumentazione);
        component.set('v.confermaVecchioRecapito', confermaVecchioRecapito);
        component.set('v.confermaNuovoRecapito', confermaNuovoRecapito);
        component.set('v.FirmeraIlContratto', firmeraIlContratto);
        component.set('v.questions', questions);
        component.set('v.prodotti', prodotti);

    },

    /**
     * @Author Abdoulaye DIOP
     * @date  24/05/2019
     * @Modified by Abdoulaye 18/06/2019
     * @description Method to get the firts list valus 
     **/
    helperGetValues1: function(component) {

        var listValues1 = [];
        var casex = component.get("v.case");
        //var fea = casex.RO_fea__c;
        var codeQueue = component.get("v.codeQueue");
        var stato_ocs = casex.hasOwnProperty('stato_ocs__c') ? casex.stato_ocs__c : '';
        var product = casex.hasOwnProperty('Product__r') ? casex.Product__r : null;
        var family = (product != null && product.hasOwnProperty('Family')) ? product.Family : null;

        /*if (fea == false && component.get("v.queues1").indexOf(codeQueue) != -1 && component.get("v.statiOcsList1").indexOf(stato_ocs) != -1) {
            listValues1.push("Inbound Assistenza");
        }*/
        // fea == true &&
        if (component.get("v.families1").indexOf(family) != -1 && component.get("v.queues2").indexOf(codeQueue) != -1 && component.get("v.statiOcsList2").indexOf(stato_ocs) != -1) {
            listValues1.push("Contatto Non Eseguito");
            listValues1.push("Contatto Eseguito");
        } // fea == true && 
        else if (component.get("v.families1").indexOf(family) != -1 && component.get("v.queues1").indexOf(codeQueue) != -1 && component.get("v.statiOcsList2").indexOf(stato_ocs) != -1) {
            listValues1.push("Inbound Assistenza");
        }
        //send list values 1
        listValues1.unshift("");
        component.set('v.listValues', listValues1);
        this.onInit(component);
    },

    /**
     * @Author Abdoulaye DIOP
     * @Modified by Abdoulaye 19/06/2019
     * @date  24/05/2019
     * @description Method to get the second list values 
     **/
    helperGetValues2: function(component, parent) {
        var listValues2 = [];
        var contattoEseguito = 'Contatto Eseguito';
        var inboundAssistenza = 'Inbound Assistenza';
        var contattoNonEseguito = 'Contatto Non Eseguito';

        if (parent.toUpperCase() == inboundAssistenza.toUpperCase()) {
            listValues2 = component.get('v.initialInBoundList');
        } else if (parent.toUpperCase() == contattoNonEseguito.toUpperCase()) {
            listValues2 = component.get('v.initialNonEseguitoList');
        } else if (parent.toUpperCase() == contattoEseguito.toUpperCase()) {
            listValues2 = component.get('v.initialEseguitoList');
        }

        listValues2 = this.filterList(component, listValues2);
        var newOption = { "code": "[]", "label": "", "value": "", "stati": "[]", "families": [], "fea": true };
        listValues2.unshift(newOption);
        //component.set('v.listValues2', listValues2);
        return listValues2;
    },

    /**
     * @Author Abdoulaye DIOP
     * @date  24/05/2019
     * @Modified by Abdoulaye 19/06/2019
     * @description Method to get the third list valus 
     **/
    helperGetValues3: function(component, parent) {
        var listValues3 = [];
        var caricheraLaDocumentazione = 'Caricherà la documentazione';
        var confermaVecchioRecapito = 'Conferma vecchio recapito';
        var confermaNuovoRecapito = 'Conferma nuovo recapito';
        var firmeraIlContratto = 'Firmerà il contratto';

        if (parent.toUpperCase() == caricheraLaDocumentazione.toUpperCase()) {
            listValues3 = component.get('v.caricheraLaDocumentazione');
        } else if (parent.toUpperCase() == confermaVecchioRecapito.toUpperCase()) {
            listValues3 = component.get('v.confermaVecchioRecapito');
        } else if (parent.toUpperCase() == confermaNuovoRecapito.toUpperCase()) {
            listValues3 = component.get('v.confermaNuovoRecapito');
        } else if (parent.toUpperCase() == firmeraIlContratto.toUpperCase()) {
            listValues3 = component.get('v.FirmeraIlContratto');
        }

        listValues3 = this.filterList(component, listValues3);
        //component.set('v.listValues3', listValues3);
        return listValues3;
    },

    /**
     * @author Abdoulaye
     * @date 19/06/2019
     * @param {*} component 
     * @param {*} listToFilter 
     */
    filterList: function(component, listToFilter) {
        if (Array.isArray(listToFilter)) {
            var caseInstance = component.get("v.case");
            //var fea = caseInstance.RO_fea__c;
            var codeQueue = component.get("v.codeQueue");
            var stato_ocs = caseInstance.hasOwnProperty('stato_ocs__c') ? caseInstance.stato_ocs__c : '';
            var product = caseInstance.hasOwnProperty('Product__r') ? caseInstance.Product__r : null;
            var family = (product != null && product.hasOwnProperty('Family')) ? product.Family : null;
            var disconosce = 'Disconosce la pratica';
            var confermaVecRec = 'CONFERMA VECCHIO RECAPITO';
            var confermaNuoRecap = 'CONFERMA NUOVO RECAPITO';
            var carDoc = 'Caricherà la documentazione';
            var haGiaCarDoc = 'Ha già caricato la documentazione';
            var numPratica = caseInstance.hasOwnProperty('NumeroPratica__c') ? caseInstance.NumeroPratica__c : null;
            var isDiscorCellulare = caseInstance.hasOwnProperty('Is_Discordanza_Cellulare__c') ? caseInstance.Is_Discordanza_Cellulare__c : false;

            listToFilter = listToFilter.filter(function(element) {
                // element.fea == fea && 
                if (element.families.indexOf(family) != -1) {
                    if (element.label.toUpperCase() == disconosce.toUpperCase()) {
                        if (codeQueue == 'Q525') {
                            if (numPratica != null) {
                                return element;
                            }
                        } else if (element.code.indexOf(codeQueue) != -1 && element.stati.indexOf(stato_ocs) != -1) {
                            return element;
                        }
                    } else if (element.label.toUpperCase() == confermaNuoRecap || element.label.toUpperCase() == confermaVecRec) {
                        // Pre Sic
                        if (codeQueue == 'Q339' || codeQueue == 'Q338') {
                            if (isDiscorCellulare) {
                                return element;
                            }
                        } // Post Sic
                        else if (codeQueue == 'Q340') {
                            // review delete element to list
                        } else if (element.code.indexOf(codeQueue) != -1 && element.stati.indexOf(stato_ocs) != -1) {
                            return element;
                        }
                    } else if (element.label.toUpperCase() == carDoc.toUpperCase() || element.label.toUpperCase() == haGiaCarDoc.toUpperCase()) {
                        if (codeQueue == 'Q339' || codeQueue == 'Q338' || codeQueue == 'Q376') {
                            if (!isDiscorCellulare) {
                                return element;
                            }
                        } else if (element.code.indexOf(codeQueue) != -1 && element.stati.indexOf(stato_ocs) != -1) {
                            return element;
                        }
                        //element.label.toUpperCase() == 'Identità non confermata'.toUpperCase() || 
                    } else if (element.label.toUpperCase() == 'Non Ricorda'.toUpperCase()) {
                        if (codeQueue == 'Q338') {
                            if (isDiscorCellulare) {
                                return element;
                            }
                        }
                        /* else if (codeQueue == 'Q339') {
                                                   if (isDiscorCellulare && element.label.toUpperCase() == 'Identità non confermata'.toUpperCase()) {
                                                       return element;
                                                   }
                                               }*/
                        else if (element.code.indexOf(codeQueue) != -1 && element.stati.indexOf(stato_ocs) != -1) {
                            return element;
                        }
                    } else if (element.label.toUpperCase() == 'Chiede di essere richiamato'.toUpperCase()) {
                        if (codeQueue == 'Q338') {
                            if (isDiscorCellulare) {
                                return element;
                            }
                        } else if (element.code.indexOf(codeQueue) != -1 && element.stati.indexOf(stato_ocs) != -1) {
                            return element;
                        }
                    } else {
                        if (element.code.indexOf(codeQueue) != -1 && element.stati.indexOf(stato_ocs) != -1) {
                            return element;
                        }
                    }
                }
            });
            return listToFilter;
        }
        return [];
        /* else if (element.code.indexOf(codeQueue) != -1 && codeQueue != 'Q525' && numPratica != null) {
            return element;
        }*/

    },

    handleOpenAppuntamento: function(component) {
        var secondLevel = component.get("v.secondLevel");
        if (secondLevel == 'Fissa appuntamento') {
            component.set('v.isOpenAppuntamento', true);
        }
    },

    handleSaveNote: function(component, title, body) {
        var caseObject = component.get('v.case');
        var action = component.get('c.createNote');
        action.setParams({ 'title': title, 'body': body, 'caseObject': caseObject });
        action.setCallback(this, function(response) {
            if (response.getState() == 'SUCCESS') {
                var resultat = response.getReturnValue();
                console.log('note', JSON.stringify(resultat));
            } else {
                console.log("note Some error was occurated, you may refresh the page");
            }
        });
        $A.enqueueAction(action);
    },

    handleGetRichiamiLimiteTemporel: function(component) {
        var developerName = component.get('v.codeQueue');
        var action = component.get('c.getRichiamiLimiteTemporel');
        action.setParam('developerName', developerName);
        action.setCallback(this, function(response) {
            if (response) {
                if (response.getState() == 'SUCCESS') {
                    var result = response.getReturnValue();
                    if (result.error == false) {
                        var richiami = result.richiamiTempLimit;
                        developerName = developerName.toLowerCase();
                        component.set('v.richiamiTempLimit', richiami.Limit__c);
                        console.log('limit', component.get('v.richiamiTempLimit'));
                    } else {
                        console.log('message', result.message);
                        component.set('v.richiamiTempLimit', 0);
                        console.log('limit error', component.get('v.richiamiTempLimit'));
                    }
                }
            }
        });
        $A.enqueueAction(action);
    },

    isRecallDateInPast: function(component, recallDate) {
        var today = new Date();
        var dd = today.getDate();
        var mm = today.getMonth() + 1; //January is 0!
        var yyyy = today.getFullYear();

        // if date is less then 10, then append 0 before date   
        if (dd < 10) {
            dd = '0' + dd;
        }
        // if month is less then 10, then append 0 before date    
        if (mm < 10) {
            mm = '0' + mm;
        }

        var todayFormattedDate = yyyy + '-' + mm + '-' + dd;
        if (recallDate <= todayFormattedDate) {
            component.set("v.dateValidationError", true);
            component.set("v.dateValidationErrorMessage", "Non puoi scegliere una data passata");
            return true;
        } else {
            component.set("v.dateValidationError", false);
            component.set('v.dateValidationErrorMessage', '');
        }
        return false;
    },

    isDateInWeekEndOrToday: function(component, recallDate) {
        var today = new Date();
        var dateTemp = '' + recallDate;
        dateTemp = dateTemp.split('-');
        var year = dateTemp[0];
        var month = dateTemp[1] * 1 - 1;
        var day = dateTemp[2].substring(0, 2);
        var recallDateTemp = new Date(year, month, day);

        //if (recallDateTemp.getDay() == 6 || recallDateTemp.getDay() == 0) {
        if (component.get('v.recallDateEnabled') && !component.get('v.recallDateEnabled').includes(recallDateTemp.getDay())) {
            component.set("v.dateValidationError", true);
            component.set('v.dateValidationErrorMessage', 'La data non è lavorativa');
            return true;
        }
        /*else if (recallDateTemp.getDate() == today.getDate()) {
                   component.set("v.dateValidationError", true);
                   component.set('v.dateValidationErrorMessage', 'La data deve essere impostata al giorno lavorativo successivo');
                  
                   return true;
               }*/
        else {
            component.set("v.dateValidationError", false);
            component.set('v.dateValidationErrorMessage', '');
        }
        return false;
    },

    isTimeIsCorrect: function(component, recallDate) {
        var hourTemp = ('' + recallDate).split('T')[1];
        var hour = hourTemp.split(':')[0] * 1 + 1;

        /******************************************* */
        var dateTemp = '' + recallDate;
        dateTemp = dateTemp.split('-');
        var year = dateTemp[0];
        var month = dateTemp[1] * 1 - 1;
        var day = dateTemp[2].substring(0, 2);
        // dateTemp ["2019","12","18T16:35:00.000Z"]
        dateTemp = dateTemp[2].split('T')[1];
        var timeRecall = dateTemp.split(':');

        //var recallDateTemp = new Date(year, month, day);
        var recallDateTemp = new Date(year, month, day, timeRecall[0], timeRecall[1], 0, 0);
        recallDateTemp.setHours(hour);
        var hourStart = component.get('v.recallStartHoursEnabled');
        var recallstart;
        if(hourStart){
            recallstart = new Date(year, month, day, timeRecall[0], timeRecall[1], 0, 0);
            recallstart.setHours(hourStart.split(':')[0]);
            recallstart.setMinutes(hourStart.split(':')[1]);
        }
        
        var hourEnd = component.get('v.recallEndHoursEnabled');
        var recallend;
        if(hourEnd){
            recallend = new Date(year, month, day, timeRecall[0], timeRecall[1], 0, 0);
            recallend.setHours(hourEnd.split(':')[0]);
            recallend.setMinutes(hourEnd.split(':')[1]);
        } 
        

        var time = new Date().getTime();
        /******************************************* */
        console.log('type of ' + typeof hour, 'hour ' + hour);
        /*if (8 > hour || hour >= 18) {
            component.set("v.dateValidationError", true);
            component.set('v.dateValidationErrorMessage', 'la data deve essere dalle 8h alle 17h');
            return true;
        } else if (time >= recallDateTemp.getTime()) {
            component.set("v.dateValidationError", true);
            component.set('v.dateValidationErrorMessage', "L'orario scelta non valida");
            return true;
        } else {
            component.set("v.dateValidationError", false);
            component.set('v.dateValidationErrorMessage', '');
        }*/
        if (time >= recallDateTemp.getTime()) {
            component.set("v.dateValidationError", true);
            component.set('v.dateValidationErrorMessage', "Inserire un orario futuro");
            return true;
        } else {
            if(recallend && recallstart && !(recallstart<recallDateTemp) || !(recallend> recallDateTemp)){
                component.set("v.dateValidationError", true);
                component.set('v.dateValidationErrorMessage', 'La data deve essere dalle '+hourStart+ ' alle '+hourEnd);
                return true;
            } else {
                component.set("v.dateValidationError", false);
                component.set('v.dateValidationErrorMessage', '');
            }
        }
         
        return false;
    },

    isRecallDateIsCorrect: function(component, recallDate) {
        var limit = component.get('v.richiamiTempLimit') * 1;
        var dateTemp = '' + recallDate;
        dateTemp = dateTemp.split('-');
        var year = dateTemp[0];
        var month = dateTemp[1] * 1 - 1;
        var day = dateTemp[2].substring(0, 2);
        var recallDateTemp = new Date(year, month, day);
        console.log('recallDateTemp', recallDateTemp);

        var today = new Date();
        var yyyy = today.getFullYear();
        var dd = today.getDate(); //+ limit
        console.log('today.getMonth()', today.getMonth());
        var mm = today.getMonth();
        var todayFormattedDate = new Date(yyyy, mm, dd);
        console.log('todayFormattedDate', todayFormattedDate);
        var isCorrectDate = false;

        // this.isFullWeekend(recallDateTemp, todayFormattedDate)
        /*if (this.isFullWeekend(todayFormattedDate, recallDateTemp,component)) {
            limit = limit + 2;
            isCorrectDate = this.hadleIsRecallDateIsCorrect(component, recallDateTemp, todayFormattedDate, limit);
            return isCorrectDate;
        }
        isCorrectDate = this.hadleIsRecallDateIsCorrect(component, recallDateTemp, todayFormattedDate, limit);*/
        var limitWorkingDays = component.get('v.recallWorkingDays');
        var intlimit = limitWorkingDays*1;
        if (this.workingDays(todayFormattedDate, recallDateTemp,component)<=intlimit) {
            return true
        } else {
            component.set("v.dateValidationError", true);
            component.set("v.dateValidationErrorMessage", "La data di richiamo non deve superare i seguenti giorni lavorativi : "+intlimit);
        }

        return false;
    },

    hadleIsRecallDateIsCorrect: function(component, recallDateTemp, todayFormattedDate, limit) {
        if (recallDateTemp.getDate() > todayFormattedDate.getDate() + limit) {
            component.set("v.dateValidationError", true);
            component.set("v.dateValidationErrorMessage", "La data di richiamo non deve superare " + component.get('v.richiamiTempLimit') + " giorno lavorativo da oggi");
            return true;
        }
        component.set("v.dateValidationError", false);
        component.set('v.dateValidationErrorMessage', '');
        return false;
    },

    workingDays: function(date1, date2,component) {
        var d1 = new Date(date1),
            d2 = new Date(date2);
        var cont = 0;
        while (d1 < d2) {
            var day = d1.getDay();
            //if ((day == 6) || (day == 0)) {
            if(component.get('v.recallDateEnabled') && component.get('v.recallDateEnabled').includes(day)){
                
                cont = cont +1;
            }
            d1.setDate(d1.getDate() + 1);
        }
        return cont;
    },

    removeInvioLinkRiprezaBozza: function(listValues, linkBozza) {
        var inviolLink = "Invio link ripresa bozza";
        if (linkBozza == '') {
            listValues = listValues.filter(item => item.label.toUpperCase() != inviolLink.toUpperCase());
        }
        return listValues;
    },

    backToListView: function(component, devName) {
        var listViews = component.get('v.listViews');
        listViews = listViews.filter(item => item.developerName == devName);
        var actionListView = component.get('c.getListViews');
        actionListView.setParam('listViewName', listViews[0].Name);
        actionListView.setCallback(this, function(resp) {
            if (resp.getState() == 'SUCCESS') {
                var resultat = resp.getReturnValue();
                if (resultat.error == false) {
                    var navEvent = $A.get("e.force:navigateToList");
                    navEvent.setParams({
                        "listViewId": resultat.listview.Id,
                        "listViewName": null,
                        "scope": "Case"
                    });
                    navEvent.fire();
                }
            }
        });
        $A.enqueueAction(actionListView);
    },

    showToast: function(title, message, type, mode) {
        mode = (mode == '') ? 'dismissible' : mode;
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "title": title,
            "message": message,
            "type": type,
            "mode": mode
        });
        toastEvent.fire();
    },

    handleGetDatiPostVendita: function(component) {

        var self = this;
        var caseObject = component.get('v.case');
        var developerName = component.get('v.codeQueue');
        var isDiscorDanzaCellulare = caseObject.hasOwnProperty('Is_Discordanza_Cellulare__c') ? caseObject.Is_Discordanza_Cellulare__c : false;
        if (developerName == 'Q337' || (developerName == 'Q339' && isDiscorDanzaCellulare)) {
            var secondLevel = component.get("v.secondLevel");
            if (caseObject.Tentativo__c >= 3 || component.get("v.doSwitch") == true) {
                var runOnce = component.get('v.runOnce');
                if (runOnce) {
                    var action = component.get('c.getDatiPostVendita');
                    action.setParam('idCase', caseObject.Id);
                    action.setCallback(this, function(response) {
                        component.set('v.loaded', true);
                        if (response.getState() == 'SUCCESS') {
                            var result = response.getReturnValue();
                            console.log('#l ### result dati post vendita ' + JSON.stringify(result));
                            if (result.error == false) {
                                var data = result.data;
                                var isPraticaOk = data.isPraticaOK;
                                console.log('isPraticaOk', isPraticaOk);
                                component.set('v.isPraticaOk', isPraticaOk);
                                if (isPraticaOk) {
                                    /*if (secondLevel.toUpperCase() != "Numero inesistente".toUpperCase()) {
                                        component.set("v.firstLevel", "Contatto Non Eseguito");
                                        component.set("v.secondLevel", "Cliente non trovato");
                                    }*/
                                    var tipoPratica = data.tipoPratica;
                                    console.log('tipoPratica', tipoPratica);
                                    component.set('v.tipoPratica', tipoPratica);
                                    if (tipoPratica == 'CA') {
                                        console.log('in CA');
                                        if (data.hasOwnProperty('movimenti')) {
                                            component.set('v.movimenti', data.movimenti);
                                        } 
                                        /*
                                        else {
                                            self.showToast('Warning', 'nessun movimento negli ultimi 30 giorni', 'warning', 'sticky');
                                        }
                                        */
                                        self.handleQuestions(component);
                                    } else if (tipoPratica == 'CO') {
                                        console.log('in CO');
                                        if (data.hasOwnProperty('mftcoecoElemento')) {
                                            component.set('v.mftcoecoElemento', data.mftcoecoElemento);
                                            self.handleQuestions(component);
                                        }
                                    } else if (tipoPratica == 'CP') {
                                        if (data.hasOwnProperty('recuperaCpay')) {
                                            component.set('v.recuperaCpay', data.recuperaCpay);
                                            self.handleQuestions(component);
                                        } else {
                                            importo = 0;
                                        }
                                    }
                                    var iban = data.hasOwnProperty('iban') ? data.iban : '';
                                    component.set('v.iban', iban);
                                } else {}
                            } else {
                                console.log('message', JSON.stringify(result.message));
                            }
                        }
                        component.set('v.loaded', false);
                        component.set('v.runOnce', false);
                    });
                    $A.enqueueAction(action);
                }
            }
        }
    },

    handleQuestions: function(component) {
        var tipoPratica = component.get('v.tipoPratica');
        var questions = component.get('v.questions');
        console.log('questions', JSON.stringify(questions));
        if (tipoPratica == null) {
            questions = [];
        } else {
            questions = questions.filter(function(item) {
                if (item.prodotto.indexOf(tipoPratica) != -1) {
                    return item;
                }
            });
        }
        if (questions.length > 0) {
            component.set('v.isOpenDomanda', true);
        } else {
            this.showToast('Warning', 'Nessun Prodotto Attivo', 'warning', 'sticky');
        }
        component.set('v.questions', questions);
        console.log('questions', JSON.stringify(questions));
    },

    handleOpenQuestions: function(component) {
        var developerName = component.get('v.codeQueue');
        var caseObj = component.get('v.case');
        if (developerName == 'Q337' || developerName == 'Q338' || developerName == 'Q339') {
            if ((component.get("v.secondLevel").toUpperCase() == "Cliente non trovato".toUpperCase() && caseObj.Tentativo__c >= 3) ||
                component.get("v.secondLevel").toUpperCase() == "Numero inesistente".toUpperCase()) {

                var isPraticaOk = component.get('v.isPraticaOk');
                console.log('isPraticaOk on handleOpenQuestions', isPraticaOk);
                if (isPraticaOk) {
                    console.log('isPraticaOk run isPratica ok');
                    self.handleQuestions(component);
                    var questions = component.get('v.questions');
                    var isDiscorDanzaCellulare = caseObj.hasOwnProperty('Is_Discordanza_Cellulare__c') ? caseObj.Is_Discordanza_Cellulare__c : false;
                    if (isDiscorDanzaCellulare) {
                        if (questions.length > 0) {
                            component.set('v.isOpenDomanda', true);
                        } else {
                            self.showToast('Warning', 'Nessun Prodotto Attivo', 'warning', 'sticky');
                        }
                    }
                }

            }
        }
    },
    update: function(component, event) {

        component.set('v.loaded', true);
        var caseObject = component.get('v.case');
        var dispositionName = component.get('v.dispositionName');
        var firstLevel = component.get('v.firstLevel');
        var secondLevel = component.get('v.secondLevel');
        var thirdLevel = component.get('v.thirdLevel');
        //caseObject.Note__c = note;
        console.log('levels', firstLevel + ' ' + secondLevel + ' ' + thirdLevel);

        var nuovoCellulare = caseObject.hasOwnProperty('RO_Nuovo_Cellulare__c') ? caseObject.RO_Nuovo_Cellulare__c : null;
        var vecchioCellulare = caseObject.hasOwnProperty('RO_Vecchio_Cellulare__c') ? caseObject.RO_Vecchio_Cellulare__c : null;
        caseObject.RO_Nuovo_Cellulare__c = nuovoCellulare;
        caseObject.RO_Vecchio_Cellulare__c = vecchioCellulare;

        if (secondLevel.toUpperCase() == 'CHIEDE DI ESSERE RICHIAMATO' || thirdLevel.toUpperCase() == 'CHIEDE DI ESSERE RICHIAMATO') {
            caseObject.RecallDate__c = component.get('v.recallDate');
        }

        var action = component.get('c.updateCase');
        action.setParams({
            'caseObject': caseObject,
            'code': dispositionName,
            'firstLevel': firstLevel,
            'secondLevel': secondLevel,
            'thirdLevel': thirdLevel,
            'showLinkEvo': component.get('v.showLink')
        });
        action.setCallback(this, function(response) {
            component.set('v.loaded', false);
            if (response.getState() == 'SUCCESS') {
                var data = response.getReturnValue();
                console.log('#l data ', JSON.stringify(data));
                var showLinkEvo = data.linkevo;
                component.set('v.case', data.case);
                component.set('v.isOpenDomanda', data.isOpenDomanda);
                this.showToast('Successo!', 'Il record è stato aggiornato con successo.', 'success', '');
                var codeQueue = component.get("v.codeQueue");
                /*
                if (firstLevel.toUpperCase() == 'CONTATTO ESEGUITO' &&
                    secondLevel.toUpperCase() == 'INVIO LINK RIPRESA BOZZA') {
                    showLinkEvo = true;
                }
                */
               console.log('/////////// showLinkEvo ' + showLinkEvo);
               this.backToListView(component, data.devName);
                if (!showLinkEvo) {
                } else {
                    component.set('v.codeQueue', data.devName);
                }
                component.set('v.showLinkEvo', showLinkEvo);
                if(data.case && !data.case.Tentativo__c){
                    data.case.Tentativo__c = 0;
                }
            } else {
                console.log('response', JSON.stringify(response));
                this.showToast('Error!', 'Si è verificato un errore, è possibile aggiornare la pagina', 'error', '');
            }
        });
        $A.enqueueAction(action);
    }
})