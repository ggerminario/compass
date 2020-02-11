({
    handleManageContact: function(component, event, helper) {
        console.log('message ################' + JSON.stringify(component.get('v.filiale')));
    },
    actionUltimeChiama: function(component, event, helper) {

    },
    actionComponenti: function(component, event, helper) {

    },
    actionFaq: function(component, event, helper) {

    },
    closeModel: function(component, event, helper) {
        component.set('v.isOpenModel', false);
        component.set('v.showDetailFiliale', false);
        console.log('closed++++++++ ' + component.get('v.showDetailFiliale'));
    },
    cercaFiliale: function(component, event, helper) {
        component.set('v.listFiliales', '');
        var valueNameCF = component.get('v.valueCerca');
        var action = component.get('c.getFilialeByNameOrCodiceFiliale');
        var resultat;
        action.setParams({ "valueNameCF": valueNameCF });
        action.setCallback(this, function(response) {
            if (response.getState() === "SUCCESS") {
                resultat = response.getReturnValue();
                console.log('resultat ' + JSON.stringify(resultat));
                if (!resultat.erreur) {
                    component.set('v.listFiliales', resultat.resultat);
                } else {
                    console.log('message', "Error");
                }
            }
        });
        $A.enqueueAction(action);
    },
    filialeSelected: function(component, event, helper) {
        var recordTypeName= component.get('v.recordTypeName');
        var isStandalone= component.get('v.isStandalone');
        var fSelected = event.getSource().get('v.value');
        console.log('message' + JSON.stringify(fSelected));
        component.set("v.filiale", fSelected);
        console.log('vhjdgkgfhg' + component.get('v.filiale').Id);
        var caseObject = component.get("v.case");
        caseObject.Id = component.get("v.recordId");
        console.log('################ caseObject ' + JSON.stringify(caseObject));
        console.log('################ caseObject.Id ' + caseObject.Id);
        caseObject.AccountId = fSelected.Id;
        var resultat;
        if(recordTypeName=='GUA_Contact'){
            if(isStandalone==true){
                var action = component.get('c.assignCaseToDealer');
                console.log('################# isStandaloneTrue recordType test ' + recordTypeName);
                action.setParams({
                    "idAccount": fSelected.Id,
                    "developerName": recordTypeName
                });
                action.setCallback(this, function(response) {
                    if (response.getState() === "SUCCESS") {
                        resultat = response.getReturnValue();
                        console.log('####### Case Ceated ' + JSON.stringify(resultat));
                        var navEvt = $A.get("e.force:navigateToSObject");
                        navEvt.setParams({
                            "recordId": resultat.case.Id
                        });
                        navEvt.fire();
                    }
                });
                $A.enqueueAction(action);
            }else{
                console.log('################# isStandaloneFalse recordType test ' + recordTypeName);
                caseObject.Id = component.get("v.recordId");
                caseObject.AccountId = fSelected.Id;
                var action = component.get('c.updateCaseToDealer');
                action.setParam("caseObject", caseObject);
                action.setCallback(this, function(response) {
                    if (response.getState() === "SUCCESS") {
                        resultat = response.getReturnValue();
                        /*$A.get('e.force:refreshView').fire();
                        var navEvt = $A.get("e.force:navigateToSObject");
                        navEvt.setParams({
                            "recordId": resultat.case.Id
                        });
                        navEvt.fire();*/
                        location.reload();
                    }
                });
                $A.enqueueAction(action);
                component.set('v.isOpenModel',false);
                component.set('v.isNotInformazioniFilialeRecapiti',false);
            }
        }else{
            console.log('################# isStandaloneFalse recordType test ' + recordTypeName);
                caseObject.Id = component.get("v.recordId");
                caseObject.AccountId = fSelected.Id;
                var action = component.get('c.updateCaseToDealer');
                action.setParam("caseObject", caseObject);
                action.setCallback(this, function(response) {
                    if (response.getState() === "SUCCESS") {
                        resultat = response.getReturnValue();
                        /*$A.get('e.force:refreshView').fire();
                        var navEvt = $A.get("e.force:navigateToSObject");
                        navEvt.setParams({
                            "recordId": resultat.case.Id
                        });
                        navEvt.fire();*/
                        location.reload();
                    }
                });
                $A.enqueueAction(action);
                component.set('v.isOpenModel',false);
                component.set('v.isNotInformazioniFilialeRecapiti',false);
        }
    
        this.getCoordinatoreHandler(component);
    },
    getUtente: function(component, event, helper) {
        //component.set('v.showUtenzaPasscom', true);
        var action = component.get('c.getRecuperaUtenzeIntermediario');
        var resultat;
        var codiceIntermediario = '60757';
        var codiceUtenza = '';
        action.setParams({
            "codiceIntermediario": codiceIntermediario,
            "codiceUtenza": codiceUtenza
        });
        action.setCallback(this, function(response) {
            if (response.getState() === "SUCCESS") {
                resultat = response.getReturnValue();
                console.log('resultat ' + JSON.stringify(resultat));
                if (!resultat.erreur) {
                    component.set('v.userDealerList', resultat.resultat);
                } else {
                    console.log('message', "Error");
                }
            }
        });
        $A.enqueueAction(action);
    },

    getUtenteHandler: function(component, event, helper) {
        var caseObject = component.get("v.case");
        var resultat;
        var account = component.get('v.filiale');
        console.log('account '+JSON.stringify(account));
        if (caseObject.hasOwnProperty('NameParentRoleReference__c')) {
            var action = component.get('c.getRecuperaUtenzeIntermediario');
            action.setParams({
                "role": caseObject.Account.NameParentRoleReference__c,
                /* "role": 'Alessandria', */
            });
            action.setCallback(this, function(response) {
                if (response.getState() === "SUCCESS") {
                    resultat = response.getReturnValue();
                    console.log('response >>', resultat);
                    if (!resultat.erreur) {
                        component.set('v.userDealerList', resultat.utentente);
                        var filialeList = component.get('v.userDealerList');
                        this.initializePagination(component, filialeList);
                    } else {

                    }
                }
            });
            $A.enqueueAction(action);
        } else {
            console.log('NameRoleReference__c is undefined');
            component.set('v.userDealerList', []);
        }
    },

    initializePagination: function(component, datas) {
        var pageSize = component.get("v.pageSize");
        component.set("v.start", 0);
        component.set("v.end", pageSize - 1);
        var totalPage = Math.ceil(datas.length / pageSize);
        component.set("v.totalPage", totalPage);
        var pages = [];
        for (var i = 1; i <= totalPage; i++) {
            pages.push(i);
        }
        component.set("v.pages", pages);
        var paginationList = [];
        for (var i = 0; i < pageSize; i++) {
            if (datas.length > i) paginationList.push(datas[i]);
        }
        component.set("v.totalRecord", datas.length);
        component.set("v.objectList", datas);
        component.set("v.paginationList", paginationList);
        component.set("v.currentPage", 1);
        this.PageDetails(component, paginationList)
    },

    PageDetails: function(component, recs) {
        var paginationList = [];
        for (var i = 0; i < recs.length; i++) {
            paginationList.push(recs[i]);
        }
        component.set("v.paginationList", paginationList);

    },
    getCoordinatoreHandler: function(component, event, helper) {
        var caseObject = component.get("v.case");
        var resultat;
        var account = component.get('v.filiale');
        if (account.hasOwnProperty('Id')) {
                var action = component.get('c.getCoordinatore');
                action.setParams({
                    "idFiliale": caseObject.AccountId
                });
                action.setCallback(this, function(response) {
                    if (response.getState() === "SUCCESS") {
                        resultat = response.getReturnValue();
                        console.log('response coordFiliale >>', resultat);
                        if (!resultat.erreur) {
                            component.set('v.coordFiliale', resultat.resultat);
                        } else {
                            
                        }
                    }
                });
                $A.enqueueAction(action);
        } else {
        }
    },

})