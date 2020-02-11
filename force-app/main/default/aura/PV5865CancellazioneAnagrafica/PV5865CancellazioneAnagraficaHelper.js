/**
 * @File Name          : PV5865CancellazioneAnagraficaHelper.js
 * @Description        : 
 * @Author             : Adriana Lattanzi
 * @Group              : 
 * @Last Modified By   : Adriana Lattanzi
 * @Last Modified On   : 21/1/2020, 13:04:26
 * @Modification Log   : 
 * Ver       Date            Author      		    Modification
 * 1.0    10/1/2020   Adriana Lattanzi     Initial Version
**/
({
    onClienteSelected : function(cmp, event, helper) {
        console.log("in cliente selected");
        //console.log("pvform: " + JSON.stringify(cmp.get("v.PVForm")));
        if(!$A.util.isEmpty(cmp.get("v.PVForm.cliente"))){
            var thisPratiche = cmp.get("v.PVForm.cliente.pratiche");
            //console.log("pratiche assegnate: " + JSON.stringify(thisPratiche));
            if($A.util.isEmpty(thisPratiche)){
                this.controlloAnagrafica(cmp);
            }
            else{
                this.mostraToast(cmp, '', 'Non è possibile richiedere la cancellazione di un\'anagrafica su cui siano presenti pratiche.', 'error', '');
            }
        }
    },

    controlloAnagrafica : function(cmp) {
        console.log("in controllo anagrafica");
        var thisCodCliente = cmp.get("v.PVForm.cliente.codCliente");
        this.mostraClessidra(cmp);
        var action = cmp.get("c.cancellaAnagrafica");
        action.setParams({
            'cliente': thisCodCliente,
            'esecuzione': 'V'
        });
        action.setCallback(this, function(response){
            if(!$A.util.isUndefinedOrNull(response.getReturnValue())){
                if(response.getState() === 'SUCCESS'){
                    //console.log("risposta dalla chiamata: " + JSON.stringify(response.getReturnValue()));
                    var resp = response.getReturnValue();
                    cmp.set("v.respDTO", resp.cancellazioneAnagraficaResponse);
                    cmp.set("v.bloccoInsert", false);
                    console.log("cancellazione anagrafiche in risposta: " + JSON.stringify(cmp.get("v.respDTO")));
                    console.log("utente che sta inserendo: " + cmp.get("v.PVForm.userData.user.Branch_Or_Office__c"));
                    
                    //##########################################
                    //  caso di soggetto delegato di pagamento
                    //##########################################
                    if(resp.cancellazioneAnagraficaResponse.as400Errore == 'Soggetto delegato di pagamento'){
                        if(cmp.get("v.PVForm.userData.user.Branch_Or_Office__c") != 'FIL'){ //se BO l'operazione di inserimento non sarà possibile
                            console.log("soggetto delegato di pagamento NON per filiale"); 
                            this.mostraToast(cmp, '', 'L\'anagrafica selezionata non può essere cancellata: ' + resp.cancellazioneAnagraficaResponse.as400Errore, 'error', '');
                            cmp.set("v.bloccoInsert", true);
                        }
                    }
                    else{

                        // #######################################################################################
                        //          caso di status KO e errore diverso da soggetto delegato di pagamento
                        // #######################################################################################

                        if(resp.cancellazioneAnagraficaResponse.as400Status != 'OK'){
                            this.mostraToast(cmp, '', 'L\'anagrafica selezionata non può essere cancellata: ' + resp.cancellazioneAnagraficaResponse.as400Errore, 'error', '');
                            cmp.set("v.bloccoInsert", true);
                        }
                    }


                }
                else{
                    this.mostraToast(cmp, '', 'L\'anagrafica selezionata non può essere cancellata: Errore nel servizio CancellazioneAnagrafica.', 'error', '');
                    cmp.set("v.bloccoInsert", true);
                }
            }
            this.nascondiClessidra(cmp);
        });
        $A.enqueueAction(action);
    },

    
    
    
    /*-----------------------------------------------------------------
    ###################################################################
                        METODI DA PARENT
    ###################################################################
    -----------------------------------------------------------------*/


    validateUserInput : function(cmp, event, helper) {
        var messaggi = "";
        messaggi += this.checkClienteSelezionato(cmp);

        // Controllo che la pratica sia selezionata
        //var clienteSelezionato = cmp.get("v.PVForm.cliente");
        if ($A.util.isEmpty(cmp.get("v.PVForm.cliente"))) {
            messaggi += "Selezionare un cliente.\n";
        }
        else if(!$A.util.isEmpty(cmp.get("v.PVForm.cliente.pratiche"))){
            messaggi += "Selezionare un cliente che non abbia pratiche aperte. \n";
        }
        else if(cmp.get("v.bloccoInsert") == true){
            messaggi += "Impossibile proseguire con l\'inserimento. \n Utente non abilitato o errore nel servizio. \n";
        }

        return messaggi;
    },


    completaPVForm: function(cmp, event, helper, PVForm) {
        //debugger;
        // arricchisco il PVForm con dettagli specifici del PV
        PVForm.codiceCliente = cmp.get("v.PVForm.cliente.codCliente");
        PVForm.esito = '';
        PVForm.errore = '';

        // completo con note specifiche

        return PVForm;
    }
})