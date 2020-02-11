({
    doInit: function(cmp,event,helper){
        var userId = cmp.get("v.PVForm.userData.user.Id");
        var action=cmp.get('c.getFilialiForBranchManager');
        action.setParams({
            "userId" : userId
        });
        action.setCallback(this,function(response){
            if(response.getState()=='SUCCESS'){
                cmp.set("v.filiali",response.getReturnValue());
            }else{
                this.mostraToast(cmp, '', response.getError(), 'error', '');
                esitoCheck = false;
            }
        });
        $A.enqueueAction(action);
    },
    onClienteSelected: function (cmp, event, helper) {
        console.log('onClienteSelected');
        var listaClienti = cmp.get("v.OCSClientiSelezionati");
        var cliente = cmp.get("v.PVForm.cliente");
        if(cliente){
            this.checkClienteSelezionatoForFusione(cmp,cliente,helper);
        }
    },
    checkClienteSelezionatoForFusione: function(cmp,cliente,helper){
        var esitoCheck = true;
        var action=cmp.get('c.doCheck');
        action.setParams({
            "cliente" : cliente
        }); 
        action.setCallback(this,function(response){
            if(response.getState()=='SUCCESS'){
                this.mostraErrori(cmp, response.getReturnValue().messaggiErrore);
                if(response.getReturnValue().isErroreBloccante){
                    esitoCheck = false;
                }
                if(esitoCheck)
                    this.addCliente(cmp);
            }else{
                this.mostraToast(cmp, '', response.getError(), 'error', '');
                esitoCheck = false;
            }
        });
        $A.enqueueAction(action);
    },
    doRimuoviCliente: function(cmp,event,helper){
        var errorMessage = "";
        var clienteSelezionato = cmp.get('v.clienteSelezionato');
        var listaClienti = cmp.get("v.OCSClientiSelezionati");
        var indexToRemove;
        for(var i=0;i<listaClienti.length;i++){
            if(clienteSelezionato.codCliente == listaClienti[i].codCliente){
                indexToRemove = i;
                break;
            }
        }
        if(indexToRemove == 0 && listaClienti.length>1){
            errorMessage = "Non è possibile rimuovere l'anagrafica da mantenere, eliminare prima quelle da annulare";
        }else{
            listaClienti.splice(indexToRemove,1);
            if(indexToRemove == 0){
                cmp.set("v.clienteSelezionatoDaMantenere",null);
            }
            cmp.set("v.isCheckDocumentiNecessary",true);
            cmp.set("v.isAllegatoNecessary",false);
        }
        cmp.set("v.OCSClientiSelezionati",listaClienti);
        cmp.set("v.PVForm.clientiSelezionati",listaClienti);
        this.mostraErrori(cmp,errorMessage);
    },
    addCliente : function(cmp){
        var errorMessage = "";
        var toInsert = true;
        var cliente = cmp.get("v.PVForm.cliente");
        console.log('CS-cliente:'+JSON.stringify(cliente));
        if(cliente){
            var listaClienti = cmp.get("v.OCSClientiSelezionati");

            if(this.isListFull(listaClienti,4)) toInsert = false;

            for(var i=0;i<listaClienti.length;i++){
                if(cliente.codCliente == listaClienti[i].codCliente){
                    toInsert = false;
                } 
            }
            if(toInsert){
                if(listaClienti.length == 0){
                    cliente.tipoForFusione = 'Da mantenere';
                    cmp.set("v.clienteSelezionatoDaMantenere",cliente);
                }else{
                    cliente.tipoForFusione = 'Da annullare';
                }
                listaClienti.push(cliente);
                cmp.set("v.isCheckDocumentiNecessary",true);
                cmp.set("v.isAllegatoNecessary",false);
                cmp.set("v.OCSClientiSelezionati",listaClienti);
                cmp.set("v.PVForm.clientiSelezionati",listaClienti);
            }else{
                if(this.isListFull(listaClienti,4))
                    errorMessage = 'Sono stati già selezionati quattro clienti';
                else
                    errorMessage = 'Cliente già inserito!';
            }
            this.mostraErrori(cmp,errorMessage); 
        }
    },
    isListFull : function(inputList,maxLength){
        if(inputList.length == maxLength) return true;
        else return false;
    },    
    validateUserInput: function(cmp, event, helper) {
        var messaggi = "";
        var listaClienti = cmp.get("v.OCSClientiSelezionati");
        var numDaMantenere = 0;
        var stessaTipologia = true;
        var clienteSelezionatoDaMantenere = cmp.get("v.clienteSelezionatoDaMantenere");
        var isCheckDocumentiNecessary = cmp.get("v.isCheckDocumentiNecessary");
        var isAllegatoNecessary = cmp.get("v.isAllegatoNecessary");
        for(var i=0;i<listaClienti.length;i++){
            if(listaClienti[i].tipoForFusione == 'Da mantenere'){
                numDaMantenere += 1;
            }
            if(listaClienti[i].tipoAnagrafica != clienteSelezionatoDaMantenere.tipoAnagrafica){
                stessaTipologia = false;
            }
        }
        var motivo = cmp.get("v.PVForm.reasonMdt");
        if(motivo == null || motivo.Descrizione__c == '') {
            messaggi += 'Selezionare un motivo. \n';
        }
        if(listaClienti.length < 2){
            messaggi += "Selezionare almeno 2 clienti oggetto della fusione. \n";
        }
        if(numDaMantenere > 1){
            messaggi += 'Solo 1 anagrafica può essere mantenuta. \n';
        }else if(numDaMantenere == 0){
            messaggi += 'Un\'anagrafica deve essere mantenuta. \n';
        }
        if(!stessaTipologia){
            messaggi += 'Le anagrafiche selezionate non sono coerenti. Non è possibile effettuare fusioni anagrafiche aventi tipologia differente \n';
        }

        if(isAllegatoNecessary){
            if(cmp.get("v.PVForm.attachmentList").length == 0){
                messaggi += 'E\' necessario allegare un documento!';
            }
        }

        if(messaggi == '' && isCheckDocumentiNecessary){
            this.doCheckDocumenti(cmp,event,helper);
        }

        
		return messaggi;
    },
    doCheckDocumenti: function(cmp,event,helper){
        var listaClienti = cmp.get("v.OCSClientiSelezionati");
        var action=cmp.get('c.doCheckDocumenti');
        action.setParams({
            "clienti" : listaClienti
        }); 
        action.setCallback(this,function(response){
            if(response.getState()=='SUCCESS'){
                if(response.getReturnValue() == 'false'){
                    cmp.set("v.isModalOpen",true);
                }
            }else{
                this.mostraToast(cmp, '', response.getError(), 'error', '');
            }
        });
        $A.enqueueAction(action);
    },
    completaPVForm: function(cmp, event, helper, PVForm) {
        // arricchisco il PVForm con dati specifici del PV
        cmp.set("v.PVForm.clientiSelezionati",cmp.get("v.OCSClientiSelezionati"));
        return PVForm;
    },
    inserisciRichiesta: function(cmp,event,helper){
        cmp.set("v.isModalOpen",false);
        cmp.set("v.isCheckDocumentiNecessary",false);
        this.inserisciCase(cmp, event, helper);
    },
    closeModel: function(cmp,event,helper){
        cmp.set("v.isModalOpen",false);
        cmp.set("v.isCheckDocumentiNecessary",false);
        cmp.set("v.isAllegatoNecessary",true);
    }

})