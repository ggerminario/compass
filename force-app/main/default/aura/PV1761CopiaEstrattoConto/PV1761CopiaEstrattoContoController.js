({
    handleChange: function (component, event) {
        event.getParam("value");
    },

    selectAll : function(component, event, helper) {
        component.set("v.selectedMese",['Gennaio','Febbraio','Marzo','Aprile','Maggio','Giugno','Luglio','Agosto','Settembre','Ottobre','Novembre','Dicembre']);
        component.get("v.selectedMese");
    },

    insertEC : function(component, event, helper) {
        if (component.find("annoInput").get("v.validity").valid == true) {
            var data = new Date();
            var dataMese = data.getMonth();
            var dataAnno = data.getFullYear();
            var MeseSelected = component.get("v.selectedMese");
            for (var i = 0; i < MeseSelected.length; i ++) {
                if (MeseSelected[i] == "Gennaio") {
                    MeseSelected[i] = 1;
                } else if (MeseSelected[i] == "Febbraio") {
                    MeseSelected[i] = 2;
                } else if (MeseSelected[i] == "Marzo") {
                    MeseSelected[i] = 3;
                } else if (MeseSelected[i] == "Aprile") {
                    MeseSelected[i] = 4;
                } else if (MeseSelected[i] == "Maggio") {
                    MeseSelected[i] = 5;
                } else if (MeseSelected[i] == "Giugno") {
                    MeseSelected[i] = 6;
                } else if (MeseSelected[i] == "Luglio") {
                    MeseSelected[i] = 7;
                } else if (MeseSelected[i] == "Agosto") {
                    MeseSelected[i] = 8;
                } else if (MeseSelected[i] == "Settembre") {
                    MeseSelected[i] = 9;
                } else if (MeseSelected[i] == "Ottobre") {
                    MeseSelected[i] = 10;
                } else if (MeseSelected[i] == "Novembre") {
                    MeseSelected[i] = 11;
                } else if (MeseSelected[i] == "Dicembre") {
                    MeseSelected[i] = 12;
                }
            }
            console.log("mese: "+MeseSelected);
            console.log("anno: "+component.get("v.selectedAnno"));

            if (helper.isUndefinedNullOrEmpty(MeseSelected) || helper.isUndefinedNullOrEmpty(component.get("v.selectedAnno"))) {
                alert("Selezionare almeno un mese e inserire l'anno.");
            } else if (component.get("v.selectedAnno") > dataAnno) {
                alert("Anno " + component.get("v.selectedAnno") + " futuro.");
                component.set("v.selectedMese", []);
                component.set("v.selectedAnno", "");
            } else if (component.get("v.selectedAnno") < 1900) {
                alert("Anno " + component.get("v.selectedAnno") + " troppo vecchio.");
                component.set("v.selectedMese", []);
                component.set("v.selectedAnno", "");
            } else {
                if (component.get("v.selectedAnno") == dataAnno) {
                    for(var i = MeseSelected.length - 1; i > -1; i --) {
                        if (MeseSelected[i] > dataMese) {
                            alert("Mese " + MeseSelected[i] + " futuro.");
                            MeseSelected.splice(i,1);
                        }
                    }
                }
                
                var listaI;
                var listaF;
                var found = false;
                var j = 0;
                var first = true;
                listaI = component.get("v.MeseAnnoList");

                if (listaI == undefined) {
                    listaI = [];
                }

                if (component.get("v.MeseAnnoList") != undefined) {
                    if (component.get("v.MeseAnnoList").length > 0) {
                        listaF = component.get("v.MeseAnnoList");
                        listaI = [];
                        j = component.get("v.MeseAnnoList").length;
                        first = false;
                    }
                }  
                
                for(var i = 0; i < MeseSelected.length; i ++) {
                    listaI.push(JSON.stringify([{
                        id : j ++,
                        mese : String(MeseSelected.slice(i, i+1)),
                        anno : component.get("v.selectedAnno")
                    }]));
                    
                    if (listaF == undefined) {
                        listaF = JSON.parse(listaI[i]);
                    } else {

                        if (first == true) {
                            listaF = listaF.concat(JSON.parse(listaI[i]));
                        } else {
                            for(var l = 0; l < component.get("v.MeseAnnoList").length; l ++) {
                                found = false;
                                if((component.get("v.MeseAnnoList")[l]).mese + (component.get("v.MeseAnnoList")[l]).anno == JSON.parse((listaI)[i])[0].mese + JSON.parse((listaI)[i])[0].anno) {    
                                    found = true;
                                    break;
                                }
                            }
                            
                            if (found == false) {
                                listaF = listaF.concat(JSON.parse(listaI[i]));
                            }
                        }
                    }
                }
                
                component.set("v.MeseAnnoList", listaF);
                component.set("v.selectedMese", []);
                component.set("v.selectedAnno", "");
            }    
        }
    },

    deleteRow: function(component, event, helper) {
        var line = [];
        var ListaAgg;
        line = component.find("linesTable").getSelectedRows();
        ListaAgg = component.get("v.MeseAnnoList");

        for(var i = 0; i < ListaAgg.length; i ++) {
            if("[" + JSON.stringify(ListaAgg[i]) + "]" == JSON.stringify(line)) {
                ListaAgg.splice(i,1);
                break;
            }
        }

        component.set("v.MeseAnnoList", ListaAgg);
    }

})