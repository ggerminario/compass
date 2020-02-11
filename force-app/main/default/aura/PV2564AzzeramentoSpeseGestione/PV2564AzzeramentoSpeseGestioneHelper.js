/**
 * @File Name          : PV2564AzzeramentoSpeseGestioneHelper.js
 * @Description        : 
 * @Author             : Andrea Vanelli
 * @Group              : 
 * @Last Modified By   : Federico Negro
 * @Last Modified On   : 17/1/2020, 17:58:51
 * @Modification Log   : 
 *==============================================================================
 * Ver         Date                     Author      		      Modification
 *==============================================================================
 * 1.0    3/8/2019, 17:41:24   Andrea Vanelli     Initial Version
**/
({
    
    totUltimaScadenzaRata: function (cmp, event, helper) {

    var action = cmp.get('c.totaleIncassoUltimaScadenza');
        var pratica = cmp.get("v.praticaSelezionata");

        if (!$A.util.isUndefinedOrNull(pratica) && pratica.numPratica != '') {
            action.setParams({
                "numPratica": pratica.numPratica,
                "tipoPratica": pratica.tipoPratica,
                "caseId": cmp.get("v.theCase.Id")
            });
            // Imposto la Callback
            action.setCallback(this, function (response, helper) {
                console.log("totaleIncassoUltimaScadenza : result : " + JSON.stringify(response.getReturnValue()));
                if (response.getState() == 'SUCCESS') {
                    var result = response.getReturnValue();
                    //console.log("totitit:"+result);
                    cmp.set('v.totUltScadRata', result);
                }
                else if (response.getState() === "ERROR") {
                    this.showToast('Errore chiamata totaleIncassoUltimaScadenza', 'error');
                }
                //cmp.get("v.parent").nascondiClessidra();
            });
            $A.enqueueAction(action);
        }
    },

    getCollectorDataJ: function (cmp,event,helper){
        var action = cmp.get('c.getCollectorData');
        var pratica = cmp.get("v.praticaSelezionata");
        console.log("### COD RECUPERATORE: "+pratica.codRecuperatore);
        if (!$A.util.isUndefinedOrNull(pratica) && pratica.numPratica != '') {
            action.setParams({
                "codRecuperatore": pratica.codRecuperatore
            });
            // Imposto la Callback
            action.setCallback(this, function (response, helper) {
                console.log("data collector : result : " + JSON.stringify(response.getReturnValue()));
                if (response.getState() == 'SUCCESS') {
                    var result = response.getReturnValue();
                    cmp.set('v.collectorName', result[0]); //Collector Name
                    cmp.set('v.collectorDesc', result[1]); //Collector Desc
                }
                else if (response.getState() === "ERROR") {
                    this.showToast('Errore chiamata totaleIncassoUltimaScadenza', 'error');
                }
                //cmp.get("v.parent").nascondiClessidra();
            });
            $A.enqueueAction(action);
        }
    },

    init: function (cmp, event, helper) {
        var numPratica = cmp.get("v.theCase.NumeroPratica__c");
        var tipoPratica = cmp.get("v.theCase.Tipo_Pratica__c");
        var codRecuperatore = cmp.get("v.theCase.Codice_Recuperatore__c");
        var caseId = cmp.get("v.theCase.Id");

        var theCase = cmp.get("v.theCase");
        console.log("v.theCase : " + JSON.stringify(theCase));
        /*
        var pratica = cmp.get('v.praticaSelezionata');
        pratica.numPratica = numPratica;
        pratica.tipoPratica = tipoPratica;
        cmp.set('v.praticaSelezionata', pratica);
*/
        var pratica = {sobjectType:"OCSPratica", 
        numPratica: numPratica,
        tipoPratica: tipoPratica,
        codRecuperatore: codRecuperatore
            };         
            cmp.set('v.praticaSelezionata', pratica);

            console.log("v.praticaSelezionata : " + JSON.stringify(pratica.numPratica));
            
        var childComponent = cmp.find('cmpListaSpese');
        if (!$A.util.isUndefinedOrNull(childComponent)) {
            childComponent.set('v.praticaSelezionata', pratica);

            childComponent.loadSpese();
            this.totUltimaScadenzaRata(cmp,event,helper);
            this.getCollectorDataJ(cmp,event,helper);
        }
     
    },

    save: function (cmp, event, helper) {

        // controllo di aver selezionato il nuovo stato
        var isValid = this.validateUserInput(cmp, event, helper);
        //cmp.find('newStatus').checkValidity();
       // cmp.find('newStatus').showHelpMessageIfInvalid();


        

        // modale
        /*
        helper.showPopupHelper(cmp, 'modaldialog', 'slds-fade-in-');
        helper.showPopupHelper(cmp,'backdrop','slds-backdrop--');*/
        /*
        helper.hidePopupHelper(component, 'modaldialog', 'slds-fade-in-');
helper.hidePopupHelper(component, 'backdrop', 'slds-backdrop--');*/


        if (isValid) {
            cmp.set("v.errorMessage", "");
            cmp.get("v.parent").methodShowWaitComponent();
            var action = cmp.get('c.saveCase');
            action.setParam('form',
                {
                    "newStatus": cmp.get('v.newStatus'),
                    "note": cmp.get("v.note"),
                    "attachmentList" : cmp.get('v.allegati'),
                    "userData" : cmp.get("v.parent").get('v.userData'),
                    "speseList": cmp.get('v.speseListSelezionate'),
                    "pratica": cmp.get('v.praticaSelezionata'),
                    "accettarifiuta": cmp.get('v.accettarifiutaValue')
                }
            );
            action.setParam('theCase', cmp.get("v.theCase"));
            // Imposto la Callback
            action.setCallback(this, function (response, helper) {
                if (response.getState() == 'SUCCESS') {
                    //qui mettere codice se c'è altro da fare in caso di SUCCESS
                }
                else if (response.getState() === "ERROR") {
                }
                cmp.get("v.parent").showToast(response,"","");                    
                cmp.get("v.parent").methodHideWaitComponent();
            });
            $A.enqueueAction(action);
        }
    },

    validateUserInput: function(cmp, event, helper) {

/*in base allo step 
1==rifiutata ora in rilavorazione filiale/ufficio
2== in gestione recupero*/
        if (cmp.get("v.theCase.Step_PV__c") == '2') {

            // AV TODO controllare la selezione riga per riga 
            // fare testo con buone e scartate
            if (cmp.get("v.accettarifiutaValue") == '') {
                cmp.get("v.parent").set("v.messaggiErrore","Accettare o rifiutare l'azzeramento");       
                /*cmp.find('newStatus').checkValidity();
                cmp.find('newStatus').showHelpMessageIfInvalid();  */           
                return false; 
            } else if (cmp.get("v.accettarifiutaValue") == 'accetta') {
                if (cmp.get("v.speseListSelezionate").length == 0) {
                    cmp.get("v.parent").set("v.messaggiErrore","Nessuna spesa selezionata");       
                    return false;       
                }
                
            }         
        }
        cmp.get("v.parent").set("v.messaggiErrore","");       

        return true;       
    },


    showPopupHelper: function(component, componentId, className){
        var modal = component.find(componentId);
        $A.util.removeClass(modal, className + 'hide');
        $A.util.addClass(modal, className + 'open');
    },
    hidePopupHelper: function(component, componentId, className){
        var modal = component.find(componentId);
        $A.util.addClass(modal, className+'hide');
        $A.util.removeClass(modal, className+'open');
        component.set("v.body", "");
    },    

})