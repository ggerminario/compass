/**
 * @File Name          : GestioneBancheDatiHelper.js
 * @Description        : 
 * @Author             : Maurizio Longo
 * @Group              : 
 * @Last Modified By   : Maurizio Longo
 * @Last Modified On   : 6/2/2020, 10:26:21
 * @Modification Log   : 
 * Ver       Date            Author      		    Modification
 * 1.0    23/1/2020   Maurizio Longo     Initial Version
**/
({
    init: function (cmp, event, helper) {
        this.recuperaEmail(cmp, event, helper);

        

    },

    save: function (cmp, event, helper) {

        // controllo di aver selezionato il nuovo stato
        var isValid = this.validateUserInput(cmp, event, helper);

        if (isValid) {
            cmp.set("v.errorMessage", "");
            cmp.get("v.parent").methodShowWaitComponent();
            var action = cmp.get('c.saveCase');
            action.setParam('form',
                {
                    "newStatus": cmp.get('v.newStatus'),
                    "note": cmp.get("v.note"),
                    "attachmentList": cmp.get('v.allegati'),
                    "userData": cmp.get("v.parent").get('v.userData'),

                }
            );
            action.setParam('theCase', cmp.get("v.theCase"));
            // Imposto la Callback
            action.setCallback(this, function (response, helper) {
                if (response.getState() === 'SUCCESS') {
                    //qui mettere Codice se c'è altro da fare in caso di SUCCESS
                }
                else if (response.getState() === "ERROR") {
                }
                cmp.get("v.parent").showToast(response, "", "");
                cmp.get("v.parent").methodHideWaitComponent();
            });
            $A.enqueueAction(action);
        }
    },

        //recupero l'email del mittente
    recuperaEmail : function(cmp, event,helper) {
        console.log('Inizio associaEmailBancheDati: '); 
        var action = cmp.get("c.recuperaEmailJ");
        action.setParams({
            "currentCaseParentId": cmp.get("v.theCase.Id")
        });

        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                cmp.set("v.emailMittente", response.getReturnValue());
                console.log('Risposta SUCCESS: ');

                console.log(JSON.stringify(response.getReturnValue()));

            }
            else if (state === "ERROR") {
                cmp.set("v.selezione", "no email");
                var errors = response.getError();
                if (errors) {
                  if (errors[0] && errors[0].message) {
                    console.log("Error message: " + errors[0].message);
                  }
                } else {
                  console.log("Unknown error");
                }
              }
        
        });
        $A.enqueueAction(action);


        
    },
        //controllo se l'email è già censita in qualche banca dati
    associaEmailBancheDati : function(cmp, event, helper){
        var action2 = cmp.get('c.associaEmailBancheDatiJ');
        action2.setParams({
            "currentEmail": cmp.get("v.emailMittente.FromAddress")
        });
        action2.setCallback(this,function(response){
            var state = response.getState();
            if (state === "SUCCESS") {
                cmp.set("v.domain", response.getReturnValue());
                console.log('Risposta SUCCESS: ');

                console.log(JSON.stringify(response.getReturnValue()));

            }
            else if (state === "ERROR") {
                cmp.set("v.selezione", "not found");
                var errors = response.getError();
                if (errors) {
                  if (errors[0] && errors[0].message) {
                    console.log("Error message: " + errors[0].message);
                  }
                } else {
                  console.log("Unknown error");
                }
              }
        

        });
        $A.enqueueAction(action2);
    },
    //associazione manuale mittente
    confermaMittente: function (cmp, event, helper){
        var mittente = cmp.get("v.selezionaMittente");
       if(mittente=="Cessionaria"){
        cmp.set("v.selezione", "Cessionaria");
       }
       else {
        cmp.set("v.selezione","altroMittente");
       }
    },
    selezionaMittente: function (cmp, event, helper){
        var changeValue = event.getParam("value");
        console.log(changeValue);
        cmp.set("v.selezionaMittente",  changeValue);
    }



    
})