({
    /**
     * @Modified by Abdoulaye 19/06/2019
     * @param {*} component 
     * @param {*} event  
     * @param {*} helper 
     */
    doInit: function(component, event, helper) {
        component.set('v.loaded', true);
        var idCase = component.get('v.recordId');
        var pageSize = component.get("v.pageSize");
        component.set("v.doSwitch", false);
        var action = component.get('c.getCase');
        action.setParam('idCase', idCase);
        action.setCallback(this, function(response) {
            component.set('v.loaded', false);
            if (response.getState() == "SUCCESS") {
                var resultat = response.getReturnValue();

                if(resultat.recallDateEnabled)
                    component.set('v.recallDateEnabled',JSON.parse(resultat.recallDateEnabled));
                if(resultat.recallStartHoursEnabled)
                    component.set('v.recallStartHoursEnabled',resultat.recallStartHoursEnabled);
                if(resultat.recallEndHoursEnabled)
                    component.set('v.recallEndHoursEnabled',resultat.recallEndHoursEnabled);
                if(resultat.recallWorkingDays)
                    component.set('v.recallWorkingDays',resultat.recallWorkingDays);    
                    
                console.log('resultat', JSON.stringify(resultat));
                if (resultat.error == false) {
                    component.set("v.codeQueue", resultat.developerName);
                    var caseObject = resultat.case;
                    caseObject.Tentativo__c = caseObject.hasOwnProperty('Tentativo__c') ? caseObject.Tentativo__c : 0;
                    if (caseObject.Note__c == '-SELF-') {
                        $A.get('e.force:refreshView').fire();
                    }
                    component.set('v.case', caseObject);
                    var anomalies = resultat.anomalies; // caseObject.Anomalie_Doc__r;
                    var paginationList = [];
                    if (typeof anomalies != 'undefined') {
                        component.set('v.anomalies', anomalies);
                        component.set("v.totalSize", anomalies.length);
                        component.set("v.start", 0);
                        component.set("v.end", pageSize - 1);
                        for (var i = 0; i < pageSize; i++) {
                            paginationList.push(anomalies[i]);
                        }
                    }
                    component.set('v.paginationList', paginationList);
                    helper.helperGetValues1(component);
                    var listValues = component.get('v.listValues');
                    console.log('listValues: ' + listValues);
                    var showListValues = (listValues != null && listValues.length > 1);

                    if (!showListValues) {
                        console.log('NO ACTION');
                        component.set('v.case.Note__c', 'Nessuna azione disponibile');
                        component.set('v.showTitle', false);
                    }
                    component.set('v.showListValues1', showListValues);
                    helper.handleGetRichiamiLimiteTemporel(component);
                    //helper.handleQuestions(component);
                    helper.handleGetDatiPostVendita(component);
                } else {
                    console.log('message', resultat.message);
                }
            }
        });
        $A.enqueueAction(action);
    },

    onSelectChange: function(component, event, helper) {
        var selected = component.find("records").get("v.value");
        var paginationList = [];
        var anomalies = component.get("v.anomalies");
        for (var i = 0; i < selected; i++) {
            paginationList.push(anomalies[i]);
        }
        component.set('v.paginationList', paginationList);
    },

    /**
     * @Modified by Abdoulaye 19/06/2019
     * @param {*} component 
     * @param {*} event 
     * @param {*} helper 
     */
    searchGetValues2: function(component, event, helper) {
        console.log('### searchGetValues2 ###');
        var select = document.getElementById("categoryPicklist");
        var firstLevel = select.options[select.selectedIndex].value;
        component.set("v.firstLevel", firstLevel);
        var developerName = component.get('v.codeQueue');
        var caseObject = component.get('v.case');
        var listeValues2 = helper.helperGetValues2(component, firstLevel);
        var isRispostaValid = component.get('v.isRispostaValid');
        console.log('isRispostaValid', isRispostaValid);
        var linkBozza = '';
        if (caseObject.hasOwnProperty('RO_Link_Bozza__c')) {
            linkBozza = caseObject.RO_Link_Bozza__c;
        }
        listeValues2 = helper.removeInvioLinkRiprezaBozza(listeValues2, linkBozza);
        console.log('v.secondLevel ' + component.get("v.secondLevel"));
        console.log('listeValues2 0: ' + JSON.stringify(listeValues2[0]));

        component.set('v.listValues2', listeValues2);
        if (listeValues2.length > 0) {
            var defaultChoice = listeValues2[0];
            component.set("v.showListValues2", true);
            var secondLevel = defaultChoice.label;
            
            component.set("v.secondLevel", secondLevel);
            if (secondLevel.toUpperCase() == 'CHIEDE DI ESSERE RICHIAMATO') {
                component.set('v.openRichiami', true);
            } else if (secondLevel.toUpperCase() == 'CONFERMA NUOVO RECAPITO' && isRispostaValid) {
                component.set('v.showLinkEvo', true);
            }
            helper.handleOpenAppuntamento(component);
            //helper.handleOpenQuestions(component);

            var roVecchioCellulare = caseObject.hasOwnProperty('RO_Vecchio_Cellulare__c') ? caseObject.RO_Vecchio_Cellulare__c : null;

            var listValues3 = helper.helperGetValues3(component, defaultChoice.label);
            if (listValues3.length > 0) {
                var newOption = { "code": "[]", "label": "", "value": "", "stati": "[]", "families": [], "fea": true };
                listValues3.unshift(newOption);
                component.set('v.listValues3', listValues3);
                var defaultChoiceThirdLevel = listValues3[0];
                component.set("v.showListValues3", true);
                component.set("v.thirdLevel", defaultChoiceThirdLevel.label);
                component.set('v.dispositionName', defaultChoiceThirdLevel.value);
                component.set("v.listValues3", listValues3);
            } else {
                component.set("v.showListValues3", false);
                component.set("v.thirdLevel", "");
                component.set('v.dispositionName', defaultChoice.value);
                component.set("v.listValues3", []);
            }
            /*if (firstLevel.toUpperCase() == 'CONTATTO NON ESEGUITO' && defaultChoice.label.toUpperCase() == 'NUMERO INESISTENTE') {
                if (developerName == 'Q337' || developerName == 'Q338') {
                    component.set('v.isOpen', true);
                } else if ((developerName == 'Q339' || developerName == 'Q376') && roVecchioCellulare != null && roVecchioCellulare != '') {
                    component.set('v.isOpen', true);
                }
            }*/
        } else {
            component.set("v.showListValues2", false);
            component.set("v.secondLevel", "");
        }
    },

    /**
     * @Modified by Abdoulaye 19/06/2019
     * @param {*} component 
     * @param {*} event 
     * @param {*} helper 
     */
    searchGetValues3: function(component, event, helper) {
        console.log('### searchGetValues3 ###');
        var developerName = component.get('v.codeQueue');
        var select = document.getElementById("categoryPicklist2");
        var secondLevelArray = select.options[select.selectedIndex].value.split('-');
        var secondLevelVAlue = secondLevelArray[0];
        var secondLevelLabel = secondLevelArray[1];
        component.set("v.secondLevel", secondLevelLabel);
        helper.handleOpenAppuntamento(component);
        helper.handleGetDatiPostVendita(component);
        var caseObject = component.get('v.case');
        let tentativo = caseObject.hasOwnProperty('Tentativo__c') ? caseObject.Tentativo__c : 0;
        var roVecchioCellulare = caseObject.hasOwnProperty('RO_Vecchio_Cellulare__c') ? caseObject.RO_Vecchio_Cellulare__c : null;
        var isRispostaValid = component.get('v.isRispostaValid');

        console.log('selezionato ' + secondLevelLabel.toUpperCase());
        console.log('tentativo: ' + tentativo);
        console.log('discordanza: ' + caseObject.Is_Discordanza_Cellulare__c);
        console.log('switch: ' +  component.get('v.doSwitch'));

        if (caseObject.Is_Discordanza_Cellulare__c == true) {
            if (secondLevelLabel.toUpperCase() == 'NUMERO INESISTENTE') {
                if (tentativo < 3 && component.get('v.doSwitch') == false) {
                    console.log('sono al primo switch per numero inesistente');
                    //caseObject.Tentativo__c = 4;
                    component.set('v.case.Tentativo__c', component.get('v.case.Tentativo__c') + 1);
                    document.getElementById("categoryPicklist").value = '';
                    component.set("v.doSwitch", true);
                    helper.handleGetDatiPostVendita(component);
                    var element = document.getElementById('categoryPicklist2');
                    element.value = '';
                    element.label = '';

                    component.set("v.showListValues2", false);
                    component.set("v.secondLevel", "");
                }
                else {
                    console.log('no switch per numero inesistente');
                    component.set('v.showLinkEvo', true);
                    //let button = component.find('confermaButton');
                    //button.set('v.disabled',true);
                }
            }
            
            else if (secondLevelLabel.toUpperCase() == 'CLIENTE NON TROVATO') {
                console.log(component.get("v.doSwitch"));
                if (tentativo < 3 && component.get("v.doSwitch") == false) {
                    console.log('sono allo switch per cliente non trovato');
                    component.set("v.doSwitch", true);
                    helper.handleGetDatiPostVendita(component);
                    component.set('v.case.Tentativo__c', component.get('v.case.Tentativo__c') + 1);
                   // caseObject.Tentativo__c = 4;
                    document.getElementById("categoryPicklist").value = '';
                    var element = document.getElementById('categoryPicklist2');
                    element.value = '';
                    element.label = '';

                    component.set("v.showListValues2", false);
                    component.set("v.secondLevel", "");
                }
                if (tentativo < 5) {
                    component.set('v.showLinkEvo', false);
                }
                else {
                    component.set('v.showLinkEvo', true);
                }
            }
            
            else if (secondLevelLabel.toUpperCase() == 'CONFERMA VECCHIO RECAPITO' 
                    || secondLevelLabel.toUpperCase() == 'CONFERMA NUOVO RECAPITO'
                    || secondLevelLabel.toUpperCase() == 'NON INTERESSATO') {
                component.set('v.showLinkEvo', true);
            }
            else {
                component.set('v.showLinkEvo', false);
            }
        }
        

        /*if (secondLevelLabel.toUpperCase() == 'NUMERO INESISTENTE') {
            if (developerName == 'Q337' || developerName == 'Q338') {
                component.set('v.isOpen', true);
            } else if ((developerName == 'Q339' || developerName == 'Q376') && roVecchioCellulare != null && roVecchioCellulare != '') {
                component.set('v.isOpen', true);
            }
        } else*/
        if (secondLevelLabel.toUpperCase().toUpperCase() == 'CHIEDE DI ESSERE RICHIAMATO') {
            component.set('v.openRichiami', true);
        } else if (secondLevelLabel.toUpperCase() == 'CONFERMA NUOVO RECAPITO' && isRispostaValid) {
            component.set('v.showLinkEvo', true);
        }

        var listeValues3 = helper.helperGetValues3(component, secondLevelLabel);
        var linkBozza = '';
        if (caseObject.hasOwnProperty('RO_Link_Bozza__c')) {
            linkBozza = caseObject.RO_Link_Bozza__c;
        }
        listeValues3 = helper.removeInvioLinkRiprezaBozza(listeValues3, linkBozza);

        if (listeValues3.length > 0) {
            if (developerName == 'Q338' && secondLevelLabel.toUpperCase() == 'CONFERMA NUOVO RECAPITO') {
                listeValues3 = listeValues3.filter(item => item.label == '');
            }
            /*else if (developerName == 'Q338' && (secondLevelLabel.toUpperCase() == 'Caricherà la documentazione'.toUpperCase() ||
                               secondLevelLabel.toUpperCase() == 'Ha già caricato la documentazione'.toUpperCase())) {
                           listeValues3 = listeValues3.filter(item => item.label == '');
                       }*/
            var newOption = { "code": "[]", "label": "", "value": "", "stati": "[]", "families": [], "fea": true };
            listeValues3.unshift(newOption);
            component.set('v.listValues3', listeValues3);

            var defaultChoice = listeValues3[0];
            component.set("v.showListValues3", true);
            //component.set("v.thirdLevel", defaultChoice);            
            component.set("v.thirdLevel", defaultChoice.label);
            component.set('v.dispositionName', defaultChoice.value);
        } else {
            component.set('v.dispositionName', secondLevelVAlue);
            component.set("v.showListValues3", false);
            component.set("v.listValues3", []);
            component.set("v.thirdLevel", "");
        }
    },

    /**
     * @Modified by Abdoulaye 19/06/2019
     * @param {*} component 
     * @param {*} event 
     * @param {*} helper 
     */
    searchGetValues4: function(component, event, helper) {
        var select = document.getElementById("categoryPicklist3");
        //var categorie = select.options[select.selectedIndex].value;
        var thirdLevelArray = select.options[select.selectedIndex].value.split('-');
        var thirdLevelLabel = thirdLevelArray[1];
        var thirdLevelValue = thirdLevelArray[0];
        component.set('v.dispositionName', thirdLevelValue);
        component.set("v.thirdLevel", thirdLevelLabel);
    },

    /**
     * @author Abdoulaye AD
     * @param {*} component 
     * @param {*} event 
     * @param {*} helper 
     */
    rejectSecondNumero: function(component, event, helper) {
        component.set('v.isOpen', false);
    },

    /**
     * @author Abdoulaye AD
     * @param {*} component 
     * @param {*} event 
     * @param {*} helper 
     */
    confirmSecondNumero: function(component, event, helper) {
        component.set('v.showLink', true);
        component.set('v.isOpen', false);
    },

    /**
     * @author Abdoulaye
     * @param {*} component 
     * @param {*} event 
     * @param {*} helper 
     */
    navigateToLinkEvo: function(component, event, helper) {
        console.log('NAVIGATE TO LINK EVO');
        //let button = component.find('confermaButton');
        //button.set('v.disabled',false);

        try {
            var evt = $A.get("e.force:navigateToComponent");
            evt.setParams({
                componentDef: "c:LinkEvo",
                componentAttributes: {
                    task: 'TK000004B9',
                    infoPre: 'WFL',
                    infoPost: 'CO_DIS_CEL',
                    numeroPratica: 'CO'
                }
            });
            evt.fire();
        } catch (error) {
            console.error('error', error);
        }
    },

    /**
     * @Created by Abdoulaye 19/06/2019
     * @param {*} component 
     * @param {*} event 
     * @param {*} helper 
     */
    update: function(component, event, helper) {
        helper.update(component, event);
    },

    /**
     * @Created by Abdoulaye 29/07/2019
     * @param {*} component 
     * @param {*} event 
     * @param {*} helper 
     */
    closeAppuntamento: function(component) {
        component.set('v.isOpenAppuntamento', false);
        component.set('v.secondLevel', '');
        var element = document.getElementById('categoryPicklist2');
        element.value = '';
        element.label = '';
    },

    appuntamentoFissato: function(component, event, helper) {
        console.log('Dentro Richiesta Online - Appuntamento Fissato');
        if (event.getParam("caseId") != component.get('v.case').Id) return;
        console.log('Richiesta Online - Appuntamento Fissato!');
        helper.update(component, event, helper);
    },

    cancelRichiami: function(component, event, helper) {
        component.set('v.openRichiami', false);
        component.set('v.secondLevel', '');
        component.set("v.recallDate", null);
        component.set("v.dateValidationError", false);
        component.set('v.dateValidationErrorMessage', '');
        var element = document.getElementById('categoryPicklist2');
        element.value = '';
        element.label = '';
    },

    saveRichiami: function(component, event, helper) {
        var developerName = '';
        if (component.get('v.secondLevel').toUpperCase() == 'CONFERMA NUOVO RECAPITO') {
            developerName = 'Q524';
        }
        var caseObject = component.get('v.case');
        console.log('caseObject', JSON.stringify(caseObject));
        var recallDate = component.get('v.recallDate');
        var tentativoNonRicorda = caseObject.hasOwnProperty('TentativoNonRicorda__c') ? caseObject.TentativoNonRicorda__c : null;
        caseObject.TentativoNonRicorda__c = tentativoNonRicorda;
        caseObject.RecallDate__c = recallDate;
        caseObject.Priority = 'High';
        /*var action = component.get('c.updateNoteCase');
        var sendEmail = false;
        if (component.get('v.codeQueue') == 'Q338') {
            sendEmail = true;
        }
        action.setParams({ 'caseObject': caseObject, 'developerName': developerName, 'sendEmail': sendEmail });
        action.setCallback(this, function(response) {
            if (response.getState() == 'SUCCESS') {
                var result = response.getReturnValue();
                component.set('v.case', result.case);
                component.set('v.showLinkEvo', result.linkevo);
                helper.showToast('Successo!', 'Il record è stato aggiornato correttamente, ora puoi fare clic sul collegamento evo!', 'success', '');
            } else {
                helper.showToast('Error!', 'Si è verificato un errore, è possibile aggiornare la pagina!', 'error', '');
            }
        });
        $A.enqueueAction(action);*/
        component.set('v.case', caseObject);
        component.set('v.openRichiami', false);
        helper.update(component, event);
    },

    dateUpdate: function(component, event, helper) {

        var recallDate = component.get("v.recallDate");
        if (recallDate != null) {
            //var limit = component.get('v.richiamiTempLimit') * 1;

            if (helper.isRecallDateInPast(component, recallDate)) {
                return;
            }

            if (helper.isDateInWeekEndOrToday(component, recallDate)) {
                return;
            }

            if (helper.isTimeIsCorrect(component, recallDate)) {
                return;
            }
            helper.isRecallDateIsCorrect(component, recallDate);
        }
    },

    /**
     * @author Abdoulaye
     * @param {*} component 
     * @param {*} event 
     * @param {*} helper 
     */
    first: function(component, event, helper) {
        var anomalies = component.get("v.anomalies");
        var pageSize = component.get("v.pageSize");
        var paginationList = [];
        for (var i = 0; i < pageSize; i++) {
            paginationList.push(anomalies[i]);
        }
        component.set('v.paginationList', paginationList);
    },

    /**
     * @author Abdoulaye
     * @param {*} component 
     * @param {*} event 
     * @param {*} helper 
     */
    last: function(component, event, helper) {
        var anomalies = component.get("v.anomalies");
        var pageSize = component.get("v.pageSize");
        var totalSize = component.get("v.totalSize");
        var paginationList = [];
        for (var i = totalSize - pageSize + 1; i < totalSize; i++) {
            paginationList.push(anomalies[i]);
        }
        component.set('v.paginationList', paginationList);
    },

    /**
     * @author Abdoulaye
     * @param {*} component 
     * @param {*} event 
     * @param {*} helper 
     */
    next: function(component, event, helper) {
        var anomalies = component.get("v.anomalies");
        var end = component.get("v.end");
        var start = component.get("v.start");
        var pageSize = component.get("v.pageSize");
        var paginationList = [];
        var counter = 0;
        for (var i = end + 1; i < end + pageSize + 1; i++) {
            if (anomalies.length > end) {
                paginationList.push(anomalies[i]);
                counter++;
            }
        }
        start = start + counter;
        end = end + counter;
        component.set("v.start", start);
        component.set("v.end", end);
        component.set('v.paginationList', paginationList);
    },

    /**
     * @author Abdoulaye
     * @param {*} component 
     * @param {*} event 
     * @param {*} helper 
     */
    previous: function(component, event, helper) {
        var anomalies = component.get("v.anomalies");
        var end = component.get("v.end");
        var start = component.get("v.start");
        var pageSize = component.get("v.pageSize");
        var paginationList = [];
        var counter = 0;
        for (var i = start - pageSize; i < start; i++) {
            if (i > -1) {
                paginationList.push(anomalies[i]);
                counter++;
            } else {
                start++;
            }
        }
        start = start - counter;
        end = end - counter;
        component.set("v.start", start);
        component.set("v.end", end);
        component.set('v.paginationList', paginationList);
    },

    handleChange: function(component, event) {
        component.set('v.openConfermaRisposta', true);
    },

    handleChangeRisposta3: function(component, event) {
        component.set('v.openConfermaRisposta3', true);
        var value = event.getSource().get('v.value');
        console.log('value', value);
    },

    /**
     * @Created by Abdoulaye 31/07/2019
     * @param {*} component 
     * @param {*} event 
     * @param {*} helper 
     */
    cancelConfermaRisposta: function(component, event, helper) {
        component.set('v.openConfermaRisposta', false);
    },

    cancelConfermaRisposta3: function(component, event, helper) {
        component.set('v.openConfermaRisposta3', false);
    },

    /**
     * @Created by Abdoulaye 02/12/2019
     * @param {*} component 
     * @param {*} event 
     * @param {*} helper 
     */
    saveConfermaRisposta: function(component, event, helper) {
        var valueConfermaRisposta = component.get('v.valueConfermaRisposta');
        var importoCliente = component.get('v.importoCliente');
        if (valueConfermaRisposta == 'Conferma importo') {
            var tipoPratica = component.get('v.tipoPratica');
            var importo = Number(0);
            if (tipoPratica == 'CA') {
                var movimenti = component.get('v.movimenti');
                console.log('movimenti', JSON.stringify(movimenti));
                if (movimenti) {
                    importo = movimenti.importo;
                }
            } else if (tipoPratica == 'CO') {
                var mftcoecoElemento = component.get('v.mftcoecoElemento');
                console.log('mftcoecoElemento', JSON.stringify(mftcoecoElemento));
                importo = mftcoecoElemento.mftcoeco_IMPORTO;
            } else if (tipoPratica == 'CP') {
                /*var recuperaCpay = component.get('v.recuperaCpay');
                importo = mftcoecoElemento.importo;*/
            }
            var percentage = 0.2 * importo;
            console.log('typeof percentage', typeof percentage);
            var min = 1 * importo - percentage * 1;
            var max = 1 * importo + percentage * 1;
            console.log('min', min);
            console.log('max', max);
            console.log('importo', importo);
            console.log('importoCliente', importoCliente);
            if (min <= importoCliente && importoCliente <= max) {
                component.set('v.messagioCorettaRisposta', { 'value': 'Risposta del cliente corretta', 'class': 'slds-text-color_success' });
                component.set('v.isRispostaValid', true);
            } else {
                component.set('v.messagioCorettaRisposta', { 'value': 'Risposta del cliente non corretta', 'class': 'slds-text-color_error' });
                component.set('v.isRispostaValid', true);
            }
        } else if (valueConfermaRisposta == 'Non ricorda') {
            component.set('v.showDomanda3', true);
        } else {
            component.set('v.messagioCorettaRisposta', null);
        }
        component.set('v.openConfermaRisposta', false);
    },

    /**
     * @Created by Abdoulaye 02/12/2019
     * @param {*} component 
     * @param {*} event 
     * @param {*} helper 
     */
    saveConfermaRisposta3: function(component, event, helper) {
        var valueConfermaRisposta = component.get('v.valueConfermaRisposta3');
        var developerName = component.get('v.codeQueue');
        var caseObject = component.get('v.case');
        var tentativoNonRicorda = Number(0);
        tentativoNonRicorda = caseObject.hasOwnProperty('TentativoNonRicorda__c') ? caseObject.TentativoNonRicorda__c : 0;
        var sendEmail = false;
        var messagioCorettaRisposta = component.get('v.messagioCorettaRisposta').value;
        if (messagioCorettaRisposta == undefined) {
            messagioCorettaRisposta = 'non ricorda';
        }

        var questions = component.get('v.questions');
        var body = "";
        if (Array.isArray(questions)) {
            questions.forEach(function(question, index) {
                index = index * 1 + 1;
                if (question.num != 3) {
                    body += "domanda " + index + ": " + question.question + " risposta " + index + ": " + component.get('v.importoCliente') + ', esiti: ' + messagioCorettaRisposta + ' \n';
                } else {
                    body += " domanda " + index + ": " + question.question + ', esiti: ' + valueConfermaRisposta;
                }
            });
        }

        if (valueConfermaRisposta.toUpperCase() == 'Corretta'.toUpperCase()) {
            component.set('v.showLinkEvo', true);
        } else if (valueConfermaRisposta.toUpperCase() == 'Errata'.toUpperCase()) {
            component.set('v.showLinkEvo', false);
            sendEmail = true;
            // “IDENTITA’ NON CONFERMATA”
        } else if (valueConfermaRisposta.toUpperCase() == 'Non ricorda'.toUpperCase()) {
            component.set('v.showLinkEvo', false);
            tentativoNonRicorda++;
            if (tentativoNonRicorda == 2) {
                sendEmail = true;
                developerName = 'Q524';
            }
        }
        caseObject.TentativoNonRicorda__c = tentativoNonRicorda;
        var action = component.get('c.updateNoteCase');
        action.setParams({ 'caseObject': caseObject, 'developerName': developerName, 'sendEmail': sendEmail, 'title': 'Esiti Discordanwa Cellulare', 'body': body });
        action.setCallback(this, function(response) {
            if (response.getState() == 'SUCCESS') {
                var result = response.getReturnValue();
                if (valueConfermaRisposta.toUpperCase() == 'Non ricorda'.toUpperCase()) {
                    if (tentativoNonRicorda == 1) {
                        helper.showToast('Successo!', 'puoi scegliere chiedere di essere richiamato per impostare un richiamo!', 'success', '');
                    } else {
                        helper.showToast('Successo!', 'puoi andare su evo per risolvere la discordanza!', 'success', '');
                        component.set('v.showLinkEvo', true);
                    }
                }
                //helper.showToast('Successo!', 'Il record è stato aggiornato correttamente, ora puoi fare clic sul collegamento evo!', 'success', '');
            } else {
                helper.showToast('Error!', 'Si è verificato un errore, è possibile aggiornare la pagina!', 'error', '');
            }
        });
        $A.enqueueAction(action);
        component.set('v.openConfermaRisposta3', false);
    },

    setValueConfermaRisposta: function(component) {
        component.set('v.valueConfermaRisposta', '');
        component.set('v.messagioCorettaRisposta', null);
        component.set('v.isRispostaValid', false);
    },

    returnToListView : function (component, event, helper) {
        var developerName = component.get('v.codeQueue');
        helper.backToListView(component, developerName);
    }
})