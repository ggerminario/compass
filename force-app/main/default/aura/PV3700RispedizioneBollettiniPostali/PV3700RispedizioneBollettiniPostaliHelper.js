({
    
    onPraticaSelected: function (cmp, event, helper) {
        var messaggi = ''; 
        console.log('Ho Selezionato la pratica su Rispedizione bollettini postali');   
        
        var selectedPratica = cmp.get("v.PVForm.pratica.tipoPagamento"); 
        if(selectedPratica != null) {
                messaggi = this.checkPraticaSelezionata(cmp); 
            if (messaggi == "") {
                cmp.set('v.isBp',true);
                console.log('Pratica selezionata in RispBp: ' +selectedPratica); 
            if(selectedPratica != 'BP'){
                messaggi += 'La modalità di pagamento non è Bollettini Postali';
                this.mostraErrori(cmp, messaggi);
                this.showMarkup(cmp,false);
            }
            else {
                messaggi = '';
                this.mostraErrori(cmp, messaggi);
                this.showMarkup(cmp,true);


        var action = cmp.get("c.recuperaInfoBollettini");
        var pvForm = cmp.get("v.PVForm");
        //console.log('Numero pratica in helper js: ' + nPratica);
        action.setParams({ "myForm": pvForm });

        
        action.setCallback(this, function(response) {
            debugger;
            var state = response.getState();

            console.log('Response state: ' + state);

            var dataUltimoINvio = response.getReturnValue().dataUltimoInvio;
            var dataUltimoInvioFormatted = '';
            var today = new Date();

            if (state === "SUCCESS") {
                if(dataUltimoINvio){               
                    dataUltimoInvioFormatted = dataUltimoINvio.substring(6,8) + '/' + dataUltimoINvio.substring(4,6) + '/' + dataUltimoINvio.substring(0,4);
                    var lastInvioCheck = new Date(
                        parseInt(dataUltimoINvio.substring(0,4),10),        
                        parseInt(dataUltimoINvio.substring(4,6),10),        
                        parseInt(dataUltimoINvio.substring(6,8),10)+14     
                        );    
                    if(today <= lastInvioCheck){
                            messaggi += 'L\'ultimo invio è stato effettuato il ' + dataUltimoInvioFormatted + '. É possibile eseguire un nuovo invio 2 settimane dopo tale data.';
                            this.mostraErrori(cmp, messaggi);
                            this.showMarkup(cmp,false);
                    }
                } else {
                        dataUltimoInvioFormatted = 'N/D';
                    }
                console.log('Risposta ws: ' + JSON.stringify(response.getReturnValue()));
                cmp.set("v.dataUltimoInvio",dataUltimoInvioFormatted);
            }
            else if (state === "INCOMPLETE") {
                console.log('Risposta ws incomplete: ' + JSON.stringify(response.getError()));
                this.mostraToast(cmp, '', response.getError(), 'error', '');
            }
            else if (state === "ERROR") {
                console.log('Risposta ws errore ' + JSON.stringify(response.getError()));
                this.mostraToast(cmp, '', response.getError(), 'error', '');
            }
        });

        $A.enqueueAction(action);

                }
            }
        }
        else {
                this.mostraErrori(cmp, messaggi);
                this.showMarkup(cmp,false);
                cmp.set('v.isBp',false);
            }
        
    },
    completaPVForm: function(cmp, event, helper, PVForm) {
        PVForm.dataUltimoInvio = cmp.get("v.dataUltimoInvio");
        return PVForm;
    },
    validateUserInput: function(cmp, event, helper) {
        return '';
	}

    
})