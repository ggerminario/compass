/**
 * @File Name          : PV5865CancellazioneAnagraficaGestioneHelper.js
 * @Description        : 
 * @Author             : Adriana Lattanzi
 * @Group              : 
 * @Last Modified By   : Adriana Lattanzi
 * @Last Modified On   : 21/1/2020, 10:53:37
 * @Modification Log   : 
 * Ver       Date            Author      		    Modification
 * 1.0    15/1/2020   Adriana Lattanzi     Initial Version
**/
({
    init : function(cmp, event, helper) {
        var parent = cmp.get("v.parent");
        parent.set('v.messaggiErrore',""); 
        console.log("case: " + JSON.stringify(cmp.get('v.theCase')));
        cmp.set("v.userData",cmp.get("v.parent").get("v.userData"));
    },


    save: function (cmp, event, helper) {
        var parent = cmp.get("v.parent");
		parent.set('v.messaggiErrore','');
		var rinvia = false;
		if(!$A.util.isUndefinedOrNull(cmp.find("checkboxRinviaAlMittente"))){
			rinvia = cmp.find("checkboxRinviaAlMittente").get('v.checked');
		}
        
        cmp.get("v.parent").methodShowWaitComponent(); 
        var action = cmp.get('c.saveCase');
        action.setParam('form',
            {
                "newStatus": cmp.get('v.newStatus'),
                "note": cmp.get("v.note"),
                "userData" : parent.get('v.userData'),
                "rinvia" : rinvia
            }
        );
        action.setParam('theCase', cmp.get("v.theCase"));
        // Imposto la Callback
        action.setCallback(this, function (response, helper) {
            if (response.getState() == 'SUCCESS') {
                //qui mettere codice se c'è altro da fare in caso di SUCCESS
                cmp.get("v.parent").showToast(response,"","");                    
            }
            else if (response.getState() === "ERROR") {
                cmp.get("v.parent").showToast(response,"","");          
            }
            cmp.get("v.parent").methodHideWaitComponent();
        });
        $A.enqueueAction(action);
    },    



    // ####################################################
    //             METODI INTERNI AL COMPONENTE
    // ####################################################

    controlloAnagrafica: function(cmp,event, helper){
        // chiamata al servizio di cancellazione anagrafica come verifica
        console.log("in controllo anagrafica");
        var thisCodCliente = cmp.get("v.theCase.Account.getCodice_Cliente__c");
        console.log("codice cliente da verificare: " + thisCodCliente);
        cmp.get("v.parent").methodShowWaitComponent();
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
                    console.log("cancellazione anagrafiche in risposta: " + JSON.stringify(resp.cancellazioneAnagraficaResponse));
                    //console.log("utente che sta inserendo: " + cmp.get("v.PVForm.userData.user.Branch_Or_Office__c"));
                    
                    //##########################################
                    //          caso di status KO
                    //##########################################
                    if(resp.cancellazioneAnagraficaResponse.as400Status == 'KO'){
                        this.fireToast('L\'anagrafica selezionata non può essere cancellata : ' + resp.cancellazioneAnagraficaResponse.as400Errore, 'Verificare o annullare la richiesta premendo sull\'apposito pulsante "Annulla Richiesta".', 'error', '');

                    }
                    else{
                        this.fireToast('L\'anagrafica può essere cancellata', 'Impostare lo stato della richiesta a "Gestita" per procedere con la cancellazione.', 'success', '');
                    }
                }
                else{
                    this.fireToast('Impossibile cancellare l\'anagrafica', 'L\'anagrafica selezionata non può essere cancellata: Errore nel servizio CancellazioneAnagrafica.', 'error', '');
                }
            }
            cmp.get("v.parent").methodHideWaitComponent();
        });
        $A.enqueueAction(action);
    },




    
    mostraClessidra: function (cmp) {
        var compEvent = cmp.getEvent("PVSubComponentEvents");
        compEvent.setParams({
            "method": "mostraClessidra"
        });
        compEvent.fire();
    },

    fireToast: function (header, message, type, duration) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            title: header,
            message: message,
            duration: duration,
            type: type,
            mode: 'dismissible'
        });
        toastEvent.fire();
    },
})