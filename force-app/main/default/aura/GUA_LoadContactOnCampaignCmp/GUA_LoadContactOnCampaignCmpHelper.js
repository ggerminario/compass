({
    readCSV: function(cmp, campaignId) {
        //var fileInput = cmp.find("file").get("v.value");
        //var campaignId = component.get("v.campaignId");
        console.log("campaignId  readCSV: " + campaignId);
        cmp.set("v.campaignId", campaignId);
        var fileInput = cmp.get("v.fileToBeUploaded");
        console.log('fileInput >> ', fileInput.length);
        if (fileInput.length > 0) {
            var spinner = cmp.find("csvSpinner");
            $A.util.toggleClass(spinner, "slds-hide");
            var file = fileInput[0][0];
            console.log('file.type >> ', file.type);
            if (file.type === 'text/csv' || file.type === 'application/vnd.ms-excel') {
                cmp.set("v.fileTypeError", false);
                var reader = new FileReader();
                reader.readAsText(file);
                reader.onload = loadHandler;
                reader.onerror = errorHandler;
                
            } else {
                cmp.set("v.fileTypeError", true);
                $A.util.toggleClass(spinner, "slds-hide");
            }
        }

        function loadHandler(event) {
            var csv = event.target.result;
            processData(csv);
        }

        function processData(csv) {
            var allLines = csv.split(/\r\n|\n/);
            console.log('le contenu du fichier ------ '+ allLines[0]);
            if (allLines.length < 2) {
                $A.util.toggleClass(spinner, "slds-hide");
                console.log("The file does not contain any records to insert!");
            } else {
                cmp.set("v.headers", allLines[0].split(/,|;/));
                allLines.splice(0, 1);
                var lines = [];
                var linesWithErrors = [];
                var lines = [],
                    existError = 0;
                for (var i = 0; i < allLines.length; i++) {
                    console.log('#############line---->> '+allLines.length);

                    var data = allLines[i].split(/,|;/);
                    console.log("data.length! ", data.length);
                    // if (data.length < 28) {
                    //     console.log("The line data " + (i + 2) + " is not correct. --> At least one column is missing.");
                    //     linesWithErrors.push(allLines[i]);
                    //     allLines.splice(i, 1);
                    //     i--;
                    // } else 
                    if (typeof data[15] != "undefined" && data[15] != "") {
                        console.log('test de la definition  '+ typeof data[27]);
                        var tarr = [];
                        for (var j = 0; j < 28; j++) {
                            if ( !data[j] || data[j] === null) {
                                data[j] = "''";
                                tarr.push("''");
                                console.log('condition verifier>>>> '+data[j]);
                            }else{
                                tarr.push(data[j].trim());
                            }
                        }
                        allLines[i] = tarr.join(';');
                        lines.push(tarr);
                        console.log('------ Not Error---- '+ data[27]);

                    } else {
                        if(data.length === 28){
                            console.log("The line " + (i + 2) + " is not correct. --> At least one column is missing.");
                            existError = 1;
                            //this.showToast("The line " + (i + 2) + " is not correct. --> At least one column is missing. !", "ERROR");
                            var errorLine = allLines[i] + ",Codice Dealer Mancante. Dato obbligatorio da inserire nel file di caricamento";
                            var errorLines = errorLine.split(',');
                            console.log('line error ++++ '+ errorLines.join(';'))
                            linesWithErrors.push(errorLines.join(';'));
                            allLines.splice(i, 1);
                            i--;
                        }
                        if(data.length === 29){
                            console.log("The line " + (i + 2) + " is not correct. --> At least one column is missing.");
                            existError = 1;
                            //this.showToast("The line " + (i + 2) + " is not correct. --> At least one column is missing. !", "ERROR");
                            var errorLine = allLines[i] ;
                            var errorLines = errorLine.split(',');
                            console.log('line error ++++ '+ errorLines.join(';'))
                            linesWithErrors.push(errorLines.join(';'));
                            allLines.splice(i, 1);
                            i--;
                        }
                    }
                }
                console.log('erroexist---->> '+existError);

                if(existError == 1){
                    var toastEvent = $A.get("e.force:showToast");
                        toastEvent.setParams({
                            message: "Ci sono errori nel file di caricamento. Clicca sul bottone Scarica File Errori",
                            type: "ERROR"
                        });
                        toastEvent.fire();
                        cmp.set('v.isSaved', true);
                }

                cmp.set("v.data", lines);
                //allLines.splice(0, 1);
                var uniqueArray = allLines.filter(function(item, pos) {
                    return allLines.indexOf(item) == pos && item;
                })
                if(uniqueArray.length != 0){
                    var btnEscluso = cmp.find("btn-escluso");
                    btnEscluso.set('v.disabled', false);
                }
                cmp.set("v.dataToSave", uniqueArray);
                var hed = cmp.get('v.headers');
                if(hed.length === 28){
                    var header = hed.join(';') + ";Error"
                    linesWithErrors.unshift(header);
                }else{
                   linesWithErrors.unshift(hed);
                }
                cmp.set("v.linesWithErrors", linesWithErrors);
                console.log("uniqueArray >>", uniqueArray);
                console.log("lines >>", lines);
                console.log("dataToSave >>", allLines);
                console.log("linesWithErrors >>", linesWithErrors);
                $A.util.toggleClass(spinner, "slds-hide");
            }
        }

        function errorHandler(evt) {
            if (evt.target.error.name == "NotReadableError") {
                this.showToast("Canno't read file !", "ERROR");
            }
        }
    },

    saveEscluso: function(component) {

        var data = component.get('v.dataToSave');
        var campaignId = component.get("v.campaignId");
        var linesWithErrors = component.get("v.linesWithErrors");
        console.log("campaignId to list contact", campaignId);
        if (data.length < 1) {
            console.log("data-- >> "+ data);
            console.log("campaignId is null-- >> ", campaignId);

        } else {

            var spinner = component.find("csvSpinner");
            $A.util.toggleClass(spinner, "slds-hide");
            console.log("data-- >> ", data);
            console.log("campaignId -- >> ", campaignId);
            var action = component.get("c.saveFile");
            action.setParams({
                data: data,
                campaignId: campaignId,
                linesWithErrors: linesWithErrors
            });
            action.setCallback(this, function(response) {
                var state = response.getState();
                var response = response.getReturnValue();
                if (state === "SUCCESS" && response != '') {
                    console.log(response);
                    console.log("response-- >> ", response);
                    this.showToast("Salvataggio effettuato!", "SUCCESS");
                    var spinner = component.find("csvSpinner");
                    $A.util.addClass(spinner, "slds-hide");
                    component.set('v.dataconvertToCsv',response.dataconvertToCsv);
                    /* component.set('v.isSaved', true); */
                    $A.get('e.force:refreshView').fire();
                } else {
                    this.showToast("Non è possibile inserire i record. Controllare che i campi obbligatori siano popolati ( es. codice dealer,ecc!", "ERROR");
                    var spinner = component.find("csvSpinner");
                    $A.util.addClass(spinner, "slds-hide");
                }
            });
            $A.enqueueAction(action);
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
    AnnullaHelper: function(component) {
        component.set("v.headers", null);
        component.set("v.data", null);
    },
    cancelField: function(component, event, helper) {
        $A.get('e.force:refreshView').fire();
    },

    convertArrayOfObjectsToCSV: function(component,objectRecords){
         
         var csvStringResult, counter, keys, columnDivider, lineDivider;
       if (objectRecords == null || !objectRecords.length) {
             return null;
          }
        columnDivider = ';';
         lineDivider =  '\n';
         keys = [objectRecords[0] ];
         console.log('entet----->> '+objectRecords[1]);
         csvStringResult = '';
         csvStringResult += keys.join(columnDivider);
         csvStringResult += lineDivider;
         for(var i=1; i < objectRecords.length; i++){   
             counter = 0;
             csvStringResult += [objectRecords[i]].join(columnDivider);
             csvStringResult += lineDivider;
         }
         return csvStringResult; 
    }
})