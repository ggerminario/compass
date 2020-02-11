({
    cercaDealer: function(component, event, helper) {
        /*var contactDetail = component.get('v.contactDetail');
        var idCase = component.get("v.recordId");
        var eventContact = $A.get("e.force:navigateToComponent");
        eventContact.setParams({
            componentDef: "c:GUA_SearchInformazioniDealerCmp",
            componentAttributes: {
                caseDealer: contactDetail,
                recordTypeName:'GUA_Contact',
                isStandalone:false,
                isOpenedModal: true,
                recordId: idCase
            }
        });
        eventContact.fire();*/
        component.set('v.isOpenModel', true);
    },
    chiudichiamata: function(component, event, helper) {
        component.set("v.isModalOpen", true);

    },

    creaTicketAltriUffici: function(component, event, helper) {},
    creaTicketFiliale: function(component, event) {},
    creaTicketCompassAffari: function(component, event, helper) {

    },
    getCaseByRecord: function(component) {
        var resultat;
        var recordId = component.get('v.recordId');
        console.log('caseDealer', JSON.stringify(recordId));
        var action = component.get('c.getCase');
        action.setParams({ "idCase": recordId });
        action.setCallback(this, function(response) {
            if (response.getState() === "SUCCESS") {
                resultat = response.getReturnValue();
                if (!resultat.erreur) {
                    component.set('v.contactDetail', resultat.resultat);
                    var caseDetail = resultat.resultat;
                    console.log('#l caseDetail', JSON.stringify(caseDetail));

                    var obj = caseDetail.UAF_DatiAggiuntiviFile__c;
                    if (obj != null) {
                        var regex = /&quot;/gi;
                        obj = obj.replace(regex, '"');
                        obj = obj.replace(/""""/gi, '""');
                        component.set('v.datiAggiuntivi', JSON.parse(obj));
                    }
                    this.getFilialeCase(component);
                    this.getUnitaAffari(component);
                } else {
                    console.log('message Error');
                }
            }
        });
        $A.enqueueAction(action);
    },
    getFilialeCase: function(component, event, helper) {
        //getFilialeById(String idAccount)
        var resultat;
        var caseDealer = component.get('v.contactDetail');
        if (caseDealer.hasOwnProperty('Account')) {
            var account = caseDealer.Account;
            if (account.hasOwnProperty('Branch__c')) {
                var filialeId = account.Branch__c;
                console.log('caseDealer', JSON.stringify(filialeId));
                var action = component.get('c.getFilialeById');
                action.setParams({ "idAccount": filialeId });
                action.setCallback(this, function(response) {
                    if (response.getState() === "SUCCESS") {
                        resultat = response.getReturnValue();
                        console.log('filiale ' + JSON.stringify(resultat));
                        if (!resultat.erreur) {
                            component.set('v.filialeCase', resultat.filiale);
                        } else {
                            console.log('message', "Error");
                        }
                    }
                });
                $A.enqueueAction(action);
                this.searchCapoFiliale(component);
            }
        }
    },
    searchCapoFiliale: function(component) {
        //getCapoFiliale(String idFiliale)
        var resultat;
        var caseDealer = component.get('v.contactDetail');
        if (caseDealer.hasOwnProperty('Account')) {
            var account = caseDealer.Account;
            if (account.hasOwnProperty('Branch__c')) {
                var filialeId = account.Branch__c;
                console.log('caseDealer', JSON.stringify(filialeId));
                var action = component.get('c.getCapoFiliale');
                action.setParams({ "idFiliale": filialeId });
                action.setCallback(this, function(response) {
                    if (response.getState() === "SUCCESS") {
                        resultat = response.getReturnValue();
                        console.log('capo DettaglioContact ' + JSON.stringify(resultat));
                        if (!resultat.erreur) {
                            var data = resultat.resultat;
                            if (data != null) {
                                component.set('v.capoFiliale', resultat.resultat);
                            } else {
                                console.log('non capo')
                            }

                        } else {
                            console.log('message', "Error");
                        }
                    }
                });
                $A.enqueueAction(action);
                this.gesDispositionDay(component);
            }
        }
    },
    gesDispositionDay: function(component) {
        var resultat;
        var caseDealer = component.get('v.contactDetail');
        if (caseDealer.hasOwnProperty('Account')) {
            var account = caseDealer.Account;
            if (account.hasOwnProperty('Branch__c')) {
                var filialeId = account.Branch__c;
                console.log('caseDealer', JSON.stringify(filialeId));
                var action = component.get('c.searchDisponibilitaFiliale');
                action.setParams({ "idFiliale": filialeId });
                action.setCallback(this, function(response) {
                    if (response.getState() === "SUCCESS") {
                        resultat = response.getReturnValue();
                        console.log('date disposition' + JSON.stringify(resultat));
                        if (!resultat.erreur) {
                            var data = resultat.date;
                            if (data != null) {
                                component.set('v.dispoDay', resultat.date);
                            } else {
                                console.log('non capo')
                            }
                        } else {
                            console.log('message', "Error");
                        }
                    }
                });
                $A.enqueueAction(action);
            }
        }
    },
    getUnitaAffari: function(component) {
        var caseDealer = component.get('v.contactDetail');
        var method = component.get('c.unitaAffari');
        method.setParams({
            'codiceCliente' : caseDealer.Account.getCodice_Cliente__c,
            'ocsAreaId'     : caseDealer.Account.OCSAreaId__c
        });

        method.setCallback(this, function(response){
            var state = response.getState();
            var result = response.getReturnValue();
            if(state==='SUCCESS' && result){
                component.set('v.unitaAffari',result);
            }else {
                console.log('unità affaari non presente');
            }
        });
        $A.enqueueAction(method);
    }
})