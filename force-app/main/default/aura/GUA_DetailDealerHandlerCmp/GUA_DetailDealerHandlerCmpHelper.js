({
	handleManageContact : function(component, event, helper) {
         /*var resultat;
        var recordId= component.get('v.recordId');
        console.log('recordId v', JSON.stringify(recordId));
        var action = component.get('c.getDealerByCase');
        action.setParams({"idCase":recordId}); 
        action.setCallback(this, function (response) {
            if (response.getState() === "SUCCESS") {
                resultat = response.getReturnValue();
                if (!resultat.erreur) {
                    var caseDealer=resultat.resultat;
                    console.log('getDealerByCase', JSON.stringify(caseDealer));
                       component.set('v.caseDealer',resultat.resultat);
                       this.getFilialeCase(component, event, caseDealer);
                } else {
                    console.log('message', "Error");
                }
            }
        });
        $A.enqueueAction(action); 
        */
    },
    callCampagna: function(component, event, helper) {
        component.set("v.showScript",true);
    },
    init: function(component, event, helper){
        this.verificaRequisitiDematerializzazioneDealer(component, event);
    },
    verificaRequisitiDematerializzazioneDealer: function(component, event) {
        console.log('###### ##### verificaRequisitiDematerializzazioneDealer running  ');
        var resultat;
        var caseDealer = component.get("v.caseDealer");
        if(!caseDealer || !caseDealer.AccountId) return;
        console.log('###### ##### verifica  ' + JSON.stringify(caseDealer));
        var action = component.get('c.verificaRequisitiDematerializzazioneDealer');
        console.log('###### ##### tipoIntermediario  ' + caseDealer.Account.Tipo_Intermediario__c);
        console.log('###### ##### codIntermediario  ' + caseDealer.Account.getCodice_Cliente__c);
        action.setParams({
            "tipoIntermediario": caseDealer.Account.Tipo_Intermediario__c,
            "codIntermediario": caseDealer.Account.getCodice_Cliente__c
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