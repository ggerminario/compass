/**
 * @File Name          : PV6203RichiestaDettagliAssicurativiHelper.js
 * @Description        : 
 * @Author             : Adriana Lattanzi
 * @Group              : 
 * @Last Modified By   : Adriana Lattanzi
 * @Last Modified On   : 23/12/2019, 18:05:12
 * @Modification Log   : 
 * Ver       Date            Author      		    Modification
 * 1.0    23/12/2019   Adriana Lattanzi     Initial Version
**/
({
    onClienteSelected: function(component, event, helper){
        console.log("in cliente selected");
        //azzeramento colonna dettagli
        component.set("v.showpack", false);
        component.set("v.showquestion", false);
    },


    /*-----------------------------------------------------------------
    ###################################################################
                   CHIAMATA RETRIEVE PACCHETTI
    ###################################################################
    -----------------------------------------------------------------*/
    

    onPraticaSelected: function(component, event, helper){
        console.log("in pratica selected.");
        component.set("v.showpack", false); //--> cancella i pacchetti associati alla precedente pratica selezionata
        component.set("v.showquestion", false); //--> cancella la vista delle domande in caso di selezioni di pratiche successive alla prima 
        var action = component.get("c.recuperaDatiRimborsoPostEA");
        action.setParam(
            "numeroCarta", component.get("v.PVForm.pratica.numPratica")
        )
        this.mostraClessidra(component);
        action.setCallback(this, function(response){
            if(response.getState() == 'SUCCESS' && response.getReturnValue() != ''){
                //console.log("Response restituita dal servizio " + JSON.stringify(response.getReturnValue()));
                component.set("v.showpack", true);
                component.set("v.pack", response.getReturnValue());
                console.log("pacchetti caricati: " + JSON.stringify(component.get("v.pack")));
            }
            else if(response.getState() == 'ERROR'){
                this.mostraToast(component, '', response.getError(), 'error', '');
            }
            else{
                this.mostraToast(component, '', 'Nessun pacchetto associato', 'error', '');
            }
            this.nascondiClessidra(component);
        });
        $A.enqueueAction(action);
    },
    


    /*-----------------------------------------------------------------
    ###################################################################
                    METODI INTERNI AL COMPONENTE
    ###################################################################
    -----------------------------------------------------------------*/
    

    callQuestion : function(component, event, helper) {
        console.log("callQuestion");
        component.set("v.showquestion", true);
        var action = component.get("c.callQuestionToShow");
        action.setParam(
            "pacchetto", component.get("v.selectedpack")
        );
        action.setCallback(this, function(response){
            if(response.getState() == 'SUCCESS'){
                component.set("v.question", response.getReturnValue());
            }
            else if(response.getState() == 'ERROR'){
                this.mostraToast(component, '', response.getError(), 'error', '');
            }
        });
        $A.enqueueAction(action);
    },

    callResponse : function(component, event, helper) {
        //console.log("callResponse: " + JSON.stringify(event.getParam("selectedRows")[0]));
        console.log("callResponse: " + JSON.stringify(component.get("v.selectedquestion")));
        component.set("v.showResponse", true);
        component.set("v.responseToShow", "");
        var action = component.get("c.callResponseToShow");
        action.setParams({
            "idQuestion": component.get("v.selectedquestion"),
            "pacchetto": component.get("v.selectedpack")
        });
        action.setCallback(this, function(response){
            if(response.getState() == 'SUCCESS'){
                component.set("v.responseToShow", response.getReturnValue());
                //console.log("responseToShow" + component.get("v.responseToShow"));
                //console.log("storico domande selezioante " + component.get("v.questionHistory"));
                var action2 = component.get("c.saveHistory");
                action2.setParams({
                    "question": component.get("v.selectedquestion"),
                    "storico": component.get("v.questionHistory")
                });
                action2.setCallback(this, function(response){
                    if(response.getState() == 'SUCCESS'){
                        component.set("v.questionHistory", response.getReturnValue());
                        console.log("storico domande selezioante " + component.get("v.questionHistory"));
                    }
                });
                $A.enqueueAction(action2);
            }
            // else if(response.getState() == 'ERROR'){
            //     this.mostraToast(component, '', response.getError(), 'error', '');
            // }
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
        var praticaSelezionata = cmp.get("v.PVForm.pratica");
        if ($A.util.isUndefinedOrNull(praticaSelezionata)) {
            messaggi += "Selezionare una pratica.\n";
        }
        else if($A.util.isUndefinedOrNull(cmp.get("v.selectedpack"))){
            messaggi += "Selezionare un pacchetto. \n";
        }
        else if($A.util.isUndefinedOrNull(cmp.get("v.selectedquestion"))){
            messaggi += "Selezionare almeno una domanda. \n";
        }

        return messaggi;
    },


    completaPVForm: function(cmp, event, helper, PVForm) {
        //debugger;
        // arricchisco il PVForm con dettagli specifici del PV
        PVForm.codicePacchetto = cmp.get("v.selectedpack");
        PVForm.response = cmp.get("v.questionHistory");

        // completo con note specifiche
        PVForm.noteAggiornamentoCA = 'Pacchetto selezionato per richieste: ' + PVForm.codicePacchetto + '\n';
        PVForm.noteAggiornamentoCA += 'Richieste Dettagli effettuate: ' + PVForm.response;

        return PVForm;
    },
})