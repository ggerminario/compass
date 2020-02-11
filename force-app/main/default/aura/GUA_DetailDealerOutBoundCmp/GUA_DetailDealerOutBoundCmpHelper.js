({
    handleManageContact: function(component, event, helper) {
        console.log('###################  handleManageContact ');
        this.searchCapoFiliale(component);
        this.verificaRequisitiDematerializzazioneDealer(component);
        /* var resultat;
         var recordId= component.get('v.recordId');
         console.log('recordId', JSON.stringify(recordId));
         var action = component.get('c.getDealerByCase');
         action.setParams({"idCase":recordId}); 
         action.setCallback(this, function (response) {
             if (response.getState() === "SUCCESS") {
                 resultat = response.getReturnValue();
                 if (!resultat.erreur) {
                     //console.log('getDealerByCase', JSON.stringify(resultat));
                    	component.set('v.caseDealer',resultat.resultat);
                 } else {
                     console.log('message', "Error");
                 }
             }
         });
         $A.enqueueAction(action); 
         */
    },
    callCampagna: function(component, event, helper) {
        /* var contact = component.get('v.caseDealer');
         var navEvt = $A.get("e.force:navigateToSObject");
         navEvt.setParams({
             "recordId": contact.Id,
             "slideDevName": "detail"
         });
         navEvt.fire(); */
        component.set("v.showScript", true);
    },
    searchCapoFiliale: function(component) {
        //getCapoFiliale(String idFiliale)
        var resultat;
        console.log('################# filiale ' + component.get('v.dealer'));
        var filialeId = component.get('v.dealer.Branch__c');
        console.log('################# filialeId  ' + filialeId);
        console.log('caseDealer', JSON.stringify(filialeId));
        var action = component.get('c.getCapoFiliale');
        action.setParams({ "idFiliale": filialeId });
        action.setCallback(this, function(response) {
            if (response.getState() === "SUCCESS") {
                resultat = response.getReturnValue();
                console.log('capo ' + JSON.stringify(resultat));
                if (!resultat.erreur) {
                    if (resultat.filiale == true) {
                        console.log('capo yes ' + JSON.stringify(resultat));
                        var capo = resultat.resultat;
                        component.set("v.capoFiliale", resultat.resultat);
                        console.log('capo yes yesy ' + JSON.stringify(capo));
                        component.set("v.usercapoFilialeName", capo.Name);
                        console.log('capo yes yesy Name ' + capo.Name);
                    }
                } else {
                    console.log('message', "Error");
                }
            }
        });
        $A.enqueueAction(action);

    },

    searchDisponibilitaFiliale: function(component, event) {
        var resultat;
        var filialeId = component.get('v.dealer.Branch__c');
        var action = component.get('c.searchDisponibilitaFiliale');
        action.setParams({ "idFiliale": filialeId });
        action.setCallback(this, function(response) {
            if (response.getState() === "SUCCESS") {
                resultat = response.getReturnValue();
                console.log(' ########## resultat test ' + JSON.stringify(resultat));

                if (!resultat.error) {
                    //  component.set("v.capoFiliale", resultat.resultat);
                    console.log(' ########## resultat test sabato ' + resultat.date);
                    component.set("v.disponibilitaDateSabato", resultat.date);

                } else {
                    console.log('message', "Error");
                }
            }
        });
        $A.enqueueAction(action);

    },

    verificaRequisitiDematerializzazioneDealer: function(component, event) {
        console.log('###### ##### verificaRequisitiDematerializzazioneDealer running  ');
        var resultat;
        var dealer = component.get("v.dealer");
        console.log('###### ##### verifica  ' + JSON.stringify(dealer));
        var action = component.get('c.verificaRequisitiDematerializzazioneDealer');
        console.log('###### ##### tipoIntermediario  ' + dealer.Tipo_Intermediario__c);
        console.log('###### ##### codIntermediario  ' + dealer.getCodice_Cliente__c);
        action.setParams({
            "tipoIntermediario": dealer.Tipo_Intermediario__c,
            "codIntermediario": dealer.getCodice_Cliente__c
        });
        action.setCallback(this, function(response) {
            if (response.getState() === "SUCCESS") {
                resultat = response.getReturnValue();
                if (!resultat.error) {
                    var demPasscom = resultat.demPasscom.desErrore;
                    component.set("v.dematerialization", demPasscom);

                }
                console.log('####### ######## DEMATERIA ' + JSON.stringify(resultat));

            }
        });
        $A.enqueueAction(action);
    }

})