({
    doInit: function(component) {
        var action = component.get("c.getAllStatus");
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var data = response.getReturnValue();
                component.set("v.allStatus", data);
            } else {
                this.showToast("Errore durante il recupero dello stato", "ERROR");
            }
        });
        $A.enqueueAction(action);
    },
    search: function(component) {
        var action = component.get("c.searchByName");
        var text = component.get("v.searchText");
        console.log("searchText >>", text);
        if (text) {
            action.setParam("searchText", text);
            action.setCallback(this, function(response) {
                var state = response.getState();
                if (state === "SUCCESS") {
                    var data = response.getReturnValue();
                    console.log("data >>", data);
                    if (data.error) {
                        this.showToast(data.message, "ERROR");
                    } else {
                        /* var result = data.results.filter(function(a) {
                            var key = a.Name + '|' + a.Corso__c;
                            if (!this[key]) {
                                this[key] = true;
                                return true;
                            }
                        }, Object.create(null)); */

                        //console.log('dataFiltered >>', result);
                        var actives = data.results;
// MODIFICA PER LEGGERE I COLLEGAMENTI ATTIVI TRA CORSO E REFERENTE 13-12-2019
//                        actives = actives.filter(
//                            row =>
//                            (row.Corso__r.Attivo__c == true)
//                        );
                        actives = actives.filter(
                            row =>
                            (row.Attivo__c == true)
                        );
// FINE MODIFICA

                        component.set('v.results', actives);
                        component.set("v.allResults", data.results);
                        component.set("v.courses", data.courses);
                        component.set("v.listToProcess", []);
                        this.showToast(data.message, "SUCCESS");
                        this.toggleDisabled(component);
                        var btn = component.find("tutti");
                        var btnDel = component.find("eliminata");
                        btn.set('v.disabled', true);
                        btnDel.set('v.disabled', false);
                    }
                } else {
                    this.showToast("Salvataggio non effettuato!", "ERROR");
                }
            });
            $A.enqueueAction(action);
        } else {
            this.showToast("Campo di ricerca vuoto", "ERROR");
        }
    },
    showToast: function(message, type) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            message: message,
            type: type
        });
        toastEvent.fire();
    },
    selectAll: function(component, event) {
        var selectedRec = event.getSource().get("v.value");
        var allCheckBox = component.find("selectAll");
        if (selectedRec == true) {
            allCheckBox.forEach(function(element) {
                element.set("v.value", true);
            });
            component.set("v.listToProcess", component.get("v.results"));
        } else {
            allCheckBox.forEach(function(element) {
                element.set("v.value", false);
            });
            component.set("v.listToProcess", []);
        }
        this.toggleDisabled(component);

    },
    selectRow: function(component, event) {
        var rowPosition = event.getSource().get("v.text");
        var CurrentObj = component.get("v.results")[rowPosition];
        component.set('v.iscritto',CurrentObj);
        var listToProcess = component.get("v.listToProcess");
        var selectedRec = event.getSource().get("v.value");
        var checkAll = component.find("checkAll");
        checkAll.set("v.value", false);
        if (selectedRec == true) {
            listToProcess.push(CurrentObj);
        } else {
            var index = listToProcess.indexOf(CurrentObj);
            if (index > -1) {
                listToProcess.splice(index, 1);
            }
        }
        console.log('iscritto >> ', component.get("v.iscritto"))
// MODIFICA PASSO LA RIGA CORRENTE IN MODO DA VEDERE SE IL BOTTONE RIPRISTINA DEVE ESSERE ABILITATO 13-12-2019
//        this.toggleDisabled(component);
        this.toggleDisabled(component, CurrentObj);
// FINE MODIFICA
    },
// MODIFICA PASSO LA RIGA CORRENTE IN MODO DA VEDERE SE IL BOTTONE RIPRISTINA DEVE ESSERE ABILITATO 13-12-2019
//        toggleDisabled: function(component) {
    toggleDisabled: function(component, CurrentObj) {
// FINE MODIFICA
        var btnReport = component.find("btnReport");
        var select = component.find("select");
        var btnConferma = component.find("btnConferma");
        var btnConfermaNote = component.find("btnConfermaNote");
        var listToProcess = component.get("v.listToProcess");
        var btnDel = component.find("eliminata");
        var btnModifica = component.find("btnModifica");
        var btnRipristina = component.find("btnRipristina");
        btnDel.set('v.disabled', false);
        console.log('CurrentObj');
        console.log(CurrentObj);
//        console.log(CurrentObj.Attivo__c);
        if (listToProcess.length > 1) {
            btnModifica.set('v.disabled', true);
//            btnRipristina.set('v.disabled', false);
            btnRipristina.set('v.disabled', true);
            component.set("v.iscritto", {});
            component.set("v.showPopup", false);
        }else{
            if (listToProcess.length > 0) {
                console.log('listtoprocess>0');
                btnReport.set('v.disabled', false);
                select.set('v.disabled', false);
                btnConferma.set('v.disabled', false);
                //btnConfermaNote.set('v.disabled', false);
                btnModifica.set('v.disabled', false);
                component.set("v.showDetail", true);
                // MODIFICA ABILITA DISABILITA BUTTON RIPRISTINA 13-12-2019
                if(CurrentObj.Attivo__c==false){
                    btnRipristina.set('v.disabled', false);
                    btnModifica.set('v.disabled', true);
                }
            } else {
                console.log('listtoprocess=0');
                btnReport.set('v.disabled', true);
                select.set('v.disabled', true);
                btnConferma.set('v.disabled', true);
                //btnConfermaNote.set('v.disabled', true);
                component.set("v.iscritto", {});
                btnModifica.set('v.disabled', true);
                component.set("v.showPopup", false);
                component.set("v.showDetail", false);
                // MODIFICA ABILITA DISABILITA BUTTON RIPRISTINA 13-12-2019
                btnRipristina.set('v.disabled', true);
            }
        }

//        if (listToProcess.length > 1) {
//            btnModifica.set('v.disabled', true);
//            component.set("v.iscritto", {});
//            component.set("v.showPopup", false);
//        }
    },
    convertArrayOfObjectsToCSV: function(component, objectRecords) {
        try {
            this.parseToDateArrayFromMillisecond(objectRecords);
            // declare variables
            var csvStringResult,
                counter,
                keys,
                columnDivider,
                lineDivider,
                keysLabelName;
            // check if "objectRecords" parameter is null, then return from function
            if (objectRecords == null || !objectRecords.length) {
                return null;
            }
            // store ,[comma] in columnDivider variabel for sparate CSV values and
            // for start next line use '\n' [new line] in lineDivider varaible
            columnDivider = ",";
            lineDivider = "\n";
            // in the keys variable store fields API Names as a key
            // this labels use in CSV file header
            keys = [
                "Regione__c",
                "Area__c",
                "Filiale__c",
                "Codice_Intermediario__c",
                "Ragione_Sociale__c",
                "Name",
                "Cognome__c",
                "Nome__c",
                "Codice_Fiscale__c",
                "Corso__r.Name",
                "Corso__r.Codice_Assofin__c",
                "Data_Iscrizione__c",
                "Stato_Corso__c",
                "Note__c",
                "Esito_Outsourcer__c",
                "Note_x_Outsourcer__c",
                "Esito_Outsourcer__c",
            ];

            keysLabelName = [
                "Regione",
                "Area",
                "Filiale",
                "Cod. Intermediario",
                "Rag. Soc.",
                "Cod. Referente",
                "Cognome",
                "Nome",
                "CF",
                "Corso",
                "Cod. Assofin",
                "Data Iscrizione",
                "Stato Corso",
                "Note",
                "Esito Outsoucer",
                "Note x Outsoucer",
                "Tempo totale",
            ];

            csvStringResult = "";
            csvStringResult += keysLabelName.join(columnDivider);
            csvStringResult += lineDivider;

            for (var i = 0; i < objectRecords.length; i++) {
                counter = 0;
                var dateMod = objectRecords[i]["LastModifiedDate"];

                var dateLiquid = objectRecords[i]["Data_Iscrizione__c"];

                if (dateMod != null) {
                    dateMod = dateMod.split("T")[0];
                    dateMod = dateMod.split("-").join("/");
                } else if (dateMod == undefined) {
                    dateMod = " ";
                }
                if (dateLiquid != null) {
                    dateLiquid = dateLiquid.split("-").join("/");
                } else if (dateLiquid == undefined) {
                    dateLiquid = " ";
                }
                //console.log("dateMod type(" + typeof dateMod + ")", dateMod);
                //console.log("dateRich(" + typeof dateRich + ")", dateRich);

                for (var sTempkey in keys) {
                    var skey = keys[sTempkey];
                    // add , [comma] after every String value,. [except first]
                    if (counter > 0) {
                        csvStringResult += columnDivider;
                    }
                    if (skey.includes(".")) {
                        var sk = skey.split(".");
                        var sk1 = sk[0];
                        var sk2 = sk[1];
                        //check if value is undefined set empty
                        if (objectRecords[i][sk1] != undefined) {
                            if (objectRecords[i][sk1][sk2] == undefined) {
                                csvStringResult += "";
                                // console.log("Indirected Undifined", csvStringResult);
                            } else {
                                //console.log(
                                //  "11_03_2019 record[" + i + "]: " + sk1 + "." + sk2,
                                //  objectRecords[i][sk1][sk2]
                                // );
                                csvStringResult += '"' + objectRecords[i][sk1][sk2] + '"';
                                // console.log("Indirected", objectRecords[i][sk1][sk2]);
                            }
                        } else {
                            csvStringResult += "";
                        }
                    } else {
                        if (skey === "Data_Iscrizione__c")
                            csvStringResult += '"' + dateLiquid + '"';
                        else if (objectRecords[i][skey] == undefined)
                            csvStringResult += " ";
                        else csvStringResult += '"' + objectRecords[i][skey] + '"';

                        //console.log(
                        // "11_03_2019 record[" + i + "]: " + skey,
                        // objectRecords[i][skey]
                        // );
                    }

                    counter++;
                } // inner for loop close
                csvStringResult += lineDivider;
            } // outer main for loop close
            // return the CSV formate String
        } catch (err) {
            console.log(" error ->", err);
        }
        return csvStringResult;
    },
    parseToDateArrayFromMillisecond: function(data) {
        data.forEach(function(element, index) {
            if (element.Data_Iscrizione__c)
                element.Data_Iscrizione__c = new Date(
                    element.Data_Iscrizione__c
                ).toLocaleDateString();

            data[index] = element;
        });
        return data;
    },
    updateStatus: function(component) {
        var action = component.get("c.updateStato");
        var stato = component.get('v.stato');
        var listToProcess = component.get("v.listToProcess");
        if (stato) {
            listToProcess.forEach(function(element) {
                element.Stato_Corso__c = stato;
            });
            action.setParam("data", listToProcess);
            action.setCallback(this, function(response) {
                var state = response.getState();
                if (state === "SUCCESS") {
                    var data = response.getReturnValue();
                    console.log("data >>", data);
                    this.search(component);
                    if (data.error) {
                        this.showToast(data.message, "ERROR");
                    } else {
                        this.showToast("Salvataggio effettuato!", "SUCCESS");
                        //this.search(component);
                        //component.set('v.stato', '');
                    }
                } else {
                    this.showToast("Salvataggio non effettuato!", "ERROR");
                }
            });
            $A.enqueueAction(action);
        } else {
            this.showToast("Nessuno stato selezionato", "ERROR");
        }
    },
    updateNote: function(component) {
        var action = component.get("c.salvaNote");
        var note = component.get('v.note');
        var listToProcess = component.get("v.listToProcess");
        listToProcess.forEach(function(element) {
            element.Note__c = note;
        });
        action.setParam("data", listToProcess);
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var data = response.getReturnValue();
                console.log("data >>", data);
                //component.set("v.listToProcess", data);
                //component.set("v.results", data.data);
                this.search(component);
                if (data.error) {
                    this.showToast(data.message, "ERROR");
                } else {
                    this.showToast("Salvataggio effettuato!", "SUCCESS");
                    //this.search(component);
                    component.set('v.note', '');
                }
            } else {
                this.showToast("Salvataggio non effettuato!", "ERROR");
            }
        });
        $A.enqueueAction(action);
    },
    showDeleted: function(component) {
        var data = component.get('v.allResults');
// MODIFICA VISUALIZZARE COLLEGAMENTI ELIMINATI 13-12-2019
//      data = data.filter(
//          row =>
//          (row.Corso__r.Attivo__c == false)
//      );
        data = data.filter(
            row =>
            (row.Attivo__c == false)
        );
// FINE MODIFICA
        component.set('v.results', data);
        var btn = component.find("tutti");
        var btnDel = component.find("eliminata");
        btn.set('v.disabled', false);
        btnDel.set('v.disabled', true);
        console.log('data deleted : >>>> ', data);
    },
    showAll: function(component) {
        var btn = component.find("tutti");
        var btnDel = component.find("eliminata");
        btn.set('v.disabled', true);
        btnDel.set('v.disabled', false);
        component.set('v.results', component.get('v.allResults'));
    },
    elimina: function(component, iscritto) {
        var action = component.get("c.eliminaIscritto");
        action.setParam("iscritto", iscritto);
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var data = response.getReturnValue();
                console.log("data >>", data);
                this.search(component);
                if (data.error) {
                    this.showToast(data.message, "ERROR");
                } else {
                    this.showToast("Cancellato con successo!", "SUCCESS");
                    component.set('v.iscritto', {});
                }
            } else {
                this.showToast("Errore durante l'eliminazione!", "ERROR");
            }
        });
        $A.enqueueAction(action);
    },
    ripristina: function(component, iscritto) {
        var i = component.get('v.iscritto');
        console.log('i - ripristina');
        console.log(i);
        
        var action = component.get("c.ripristinaIscritto");
        console.log('vedo se iscritto');
        console.log(iscritto);
        action.setParam("iscritto", i);
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var data = response.getReturnValue();
                console.log("data >>", data);
                this.search(component);
                if (data.error) {
                    this.showToast(data.message, "ERROR");
                } else {
                    this.showToast("Collegamento ripristinato con successo!", "SUCCESS");
                    component.set('v.iscritto', {});
                }
            } else {
                this.showToast("Errore durante l'eliminazione!", "ERROR");
            }
        });
        $A.enqueueAction(action);
    },
    multiRipristina: function(component) {
        var listC = component.get('v.listToProcess');
        var action = component.get("c.mRipristinaIscritti");
        action.setParam("iscritti", listC);
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var data = response.getReturnValue();
                console.log("data >>", data);
                this.search(component);
                if (data.error) {
                    this.showToast(data.message, "ERROR");
                } else {
                    this.showToast("Collegamento ripristinato con successo!", "SUCCESS");
                    component.set('v.iscritto', {});
                }
            } else {
                this.showToast("Errore durante l'eliminazione!", "ERROR");
            }
        });
        $A.enqueueAction(action);
    },

    
    modificaPopup: function(component) {
        var iscritto = component.get('v.iscritto');
        var action = component.get("c.updateIscritto");
        action.setParam("iscritto", iscritto);
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var data = response.getReturnValue();
                console.log("data >>", data);
                //component.set("v.results", data.data);
                this.search(component);
                if (data.error) {
                    this.showToast(data.message, "ERROR");
                } else {
                    this.showToast("Modificato con successo!", "SUCCESS");
                    //this.search(component);
                    var data = response.getReturnValue();
                    component.set('v.iscritto', data.data);
                }
            } else {
                this.showToast("Errore durante la modifica!", "ERROR");
            }
        });
        $A.enqueueAction(action);
    },
});