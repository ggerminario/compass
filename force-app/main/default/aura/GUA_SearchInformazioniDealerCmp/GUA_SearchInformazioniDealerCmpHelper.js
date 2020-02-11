({

    showModal: function(component, event) {
        console.log('############# running showModal');
        component.set("v.isOpenedModal", true);
    },
    closeModal: function(component, event) {
        component.set("v.isOpenedModal", false);
        component.set("v.nomeDealer", '');
        component.set("v.codiceOcsDealer", '');
        component.set("v.utenzaOrCFDealer", '');
        component.set("v.data", []);
        component.set("v.isFounded", false);
        component.set("v.showDetailDealer", false);
        //window.history.back();
    },

    recercaInformationDealer: function(component, event, helper, fromSearch) {

        var pageSize = component.get("v.pageSize").toString();
        var pageNumber;
        if(true == fromSearch){
            pageNumber = 1;
            component.set('v.pageNumber',1);
        } else {
            pageNumber = component.get("v.pageNumber").toString();
        }
         
        
        var nameDealer = component.get("v.nomeDealer");
        var codiceOcsDealer = component.get("v.codiceOcsDealer");
        var utenzaOrCFDealer = component.get("v.utenzaOrCFDealer");
        var action = component.get('c.filterCaseByNomeOcsCF');
        console.log('#################  nameDealer ' + nameDealer);
        console.log('#################  codiceOcsDealer ' + codiceOcsDealer);
        var resultat;
        action.setParams({
            "nome": nameDealer,
            "codiceOcs": codiceOcsDealer,
            "utenzoCF": utenzaOrCFDealer,
            'pageSize': pageSize,
            'pageNumber': pageNumber,
            'recordTypeNameCase': component.get("v.recordTypeName")
        });
        action.setCallback(this, function(response) {
            if (response.getState() === "SUCCESS") {
                resultat = response.getReturnValue();
                console.log('resultat  >> ', resultat);
                //console.log('############## cntactsCases size  json'+ JSON.stringify(resultat.cntactsCases));
                //    console.log('############## cntactsCases size ' + resultat.cntactsCases.length);
                //   console.log('############### liste ' + JSON.stringify(resultat.cntactsCases));
                if (resultat.cntactsCases != undefined) {
                    if (resultat.cntactsCases.length < component.get("v.pageSize")) {
                        component.set("v.isLastPage", true);
                    } else {
                        component.set("v.isLastPage", false);
                    }
                    component.set("v.dataSize", resultat.cntactsCases.length);
                    component.set("v.data", resultat.cntactsCases);
                    component.set("v.data", resultat.cntactsCases);
                }
                component.set("v.isFounded", true);
                this.displaye(component, event);

            } else {
                console.log('message', "Error");
            }
        });
        $A.enqueueAction(action);
    },

    displaye: function(component, event) {
        var actions = [
                { label: 'Show details', name: 'show_details' },
                { label: 'Delete', name: 'delete' }
            ],
            fetchData = {
                name: 'company.companyName',
                author: 'name.findName',
                published: 'address.state'
            };


        component.set('v.columns', [
            { label: 'Regione Sociale', fieldName: 'name', type: 'text' },
            { label: 'Cod OCS', fieldName: 'author', type: 'text' },
            { label: 'Tipo', fieldName: 'published', type: 'text' },
            { label: 'Stato', fieldName: 'published', type: 'text' },
            { label: 'Prov', fieldName: 'published', type: 'text' },
            { type: 'action', typeAttributes: { rowActions: actions } }
        ]);
    },
    showDetail: function(component, event) {
        var caseSelected = component.get("v.rowSelected");
        var searchEvent = $A.get("e.c:GUA_SearchByCodiceDealerEvt");
        searchEvent.setParams({
            "caseDealer": caseSelected
        });
        searchEvent.fire();
        component.set("v.isOpenedModal", false);
        this.closeModal(component, event);

    },
    dealerSelected: function(component, event, dSelected) {
        console.log('################# id Case ' + component.get("v.recordId"));
        var recordTypeName= component.get('v.recordTypeName');
        var isStandalone= component.get('v.isStandalone');
        // var action = component.get('c.assignCaseToDealer');
        var resultat;
        /*var caseObject = component.get("v.case");
        caseObject.Id = component.get("v.recordId");
        caseObject.AccountId = dSelected.Id;
        var resultat;
        if (caseObject.Id != undefined) {
            action.setParam("caseObject", caseObject);
            action.setCallback(this, function(response) {
                if (response.getState() === "SUCCESS") {
                    resultat = response.getReturnValue();
                    $A.get('e.force:refreshView').fire();
                    //  component.set('v.loaded', false);

                    var navEvt = $A.get("e.force:navigateToSObject");
                    navEvt.setParams({
                        "recordId": caseObject.Id
                    });
                    navEvt.fire();
                }
            });
            $A.enqueueAction(action);
            component.set('v.loaded', true);

        } else {*/
        console.log('################ test dealer  Case ' + JSON.stringify(dSelected));
        var caseObject = component.get("v.case")
        /*if (dSelected.Cases !== undefined && dSelected.Cases.length > 0) {
        if(recordTypeName='GUA_Contact'){
            console.log('################ is Ok ' + dSelected.Cases);
            //   var  caseObje = dSelected.Cases[0];
            caseObject.Id = dSelected.Cases[0].Id;
            caseObject.AccountId = dSelected.Id;
            var navEvt = $A.get("e.force:navigateToSObject");
            navEvt.setParams({
                "recordId": caseObject.Id
            });
            navEvt.fire();
        } else*/ 
        if(recordTypeName=='GUA_Contact'){
            if(isStandalone==true){
                var action = component.get('c.assignCaseToDealer');
                var recordTypecase = component.get("v.recordTypeName");
                console.log('################# isStandaloneTrue recordType test ' + recordTypeName);
                action.setParams({
                    "idAccount": dSelected.Id,
                    "developerName": recordTypeName
                });
                action.setCallback(this, function(response) {
                    if (response.getState() === "SUCCESS") {
                        resultat = response.getReturnValue();
                        $A.get('e.force:refreshView').fire();
                        //  component.set('v.loaded', false);
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
                
                var caseObject = component.get("v.case");
                caseObject.Id = component.get("v.recordId");
                caseObject.AccountId = dSelected.Id;
                var action = component.get('c.updateCaseToDealer');
                action.setParam("caseObject", caseObject);
                action.setCallback(this, function(response) {
                    if (response.getState() === "SUCCESS") {
                        resultat = response.getReturnValue();
                        console.log('result updtae outbound  '+resultat);
                        
                        //  component.set('v.loaded', false);
                        /*$A.get('e.force:refreshView').fire();
                        var navEvt = $A.get("e.force:navigateToSObject");
                        navEvt.setParams({
                            "recordId": resultat.case.Id
                        });
                        navEvt.fire();*/
                        this.refreshFocusedTab(component);
                        
                    }
                });
                $A.enqueueAction(action);
            }
            
            /* component.set('v.loaded', true);
             if (dSelected.Cases[0].UAF_DatiAggiuntiviFile__c !== undefined) {
                 console.log('dSelected.Cases[0].UAF_DatiAggiuntiviFile__c' + dSelected.Cases[0].UAF_DatiAggiuntiviFile__c);
                 var obj = dSelected.Cases[0].UAF_DatiAggiuntiviFile__c;
                 var regex = /&quot;/gi;
                 obj = obj.replace(regex, '"');
                 obj = obj.replace(/""""/gi, '""');
                 component.set('v.datiAggiuntivi', JSON.parse(obj));
                 console.log('############# dati Object' + component.get("v.datiAggiuntivi"));
             }
             component.set("v.contactDetail", dSelected.Cases[0]);*/

        }else{
            console.log('################# isStandaloneFalse recordType test inbound' + recordTypeName);
                
                var caseObject = component.get("v.case");
                caseObject.Id = component.get("v.recordId");
                caseObject.AccountId = dSelected.Id;
                console.log('param inbound MMMM '+JSON.stringify(caseObject));
                var action = component.get('c.updateCaseToDealer');
                action.setParam("caseObject", caseObject);
                action.setCallback(this, function(response) {
                    if (response.getState() === "SUCCESS") {
                        resultat = response.getReturnValue();
                        console.log('result updtae inbound '+JSON.stringify(resultat));
                        //  component.set('v.loaded', false);
                        /*$A.get('e.force:refreshView').fire();
                        var navEvt = $A.get("e.force:navigateToSObject");
                        navEvt.setParams({
                            "recordId": resultat.case.Id
                        });
                        navEvt.fire();*/
                        this.refreshFocusedTab(component);
                        //location.reload();
                    }else{
                        console.log('error inbound MMMM '+JSON.stringify(response));
                    }
                });
                $A.enqueueAction(action);
        }

        /*     var action = component.get('c.assignCaseToDealer');
             console.log('################ Case ' + dSelected.Cases);
             //  caseObject = dSelected.Cases[0];
             console.log('########### caseObject Id  ' + caseObject.Id);
             console.log('########### caseObject Account  ' + caseObject.AccountId);
             //  caseObject.Id = component.get("v.recordId");
             // caseObject.AccountId = dSelected.Id;
             action.setParam("caseObject", caseObject);
             action.setCallback(this, function(response) {
                 if (response.getState() === "SUCCESS") {
                     resultat = response.getReturnValue();
                     $A.get('e.force:refreshView').fire();
                     //  component.set('v.loaded', false);

                     var navEvt = $A.get("e.force:navigateToSObject");
                     navEvt.setParams({
                         "recordId": caseObject.Id
                     });
                     navEvt.fire();
                 }
             });
             $A.enqueueAction(action); */



        component.set("v.dealer", dSelected);
        component.set("v.isOpen", true);
        component.set("v.isOpenedModal", false);
        component.set("v.isNotSearchInformazioniDealer", false);
        console.log('############# Dealer Selected ### ' + component.get("v.dealer"));
        console.log('############# Case Detail ### ' + component.get("v.contactDetail"));








    },
    refreshFocusedTab : function(component) {
        /*var workspaceAPI = component.find("workspace");
        workspaceAPI.getFocusedTabInfo().then(function(response) {
            var focusedTabId = response.tabId;
            workspaceAPI.refreshTab({
                      tabId: focusedTabId,
                      includeAllSubtabs: true
             });
        })
        .catch(function(error) {
            console.log(error);
        });*/
        location.reload();
    }

})