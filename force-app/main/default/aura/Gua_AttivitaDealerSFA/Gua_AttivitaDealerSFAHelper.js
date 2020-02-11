({
    getAllCasesByAccountId: function (component, pageSize) {
        var myCase = component.get('v.case');
        if (myCase.hasOwnProperty('Account')) {
            var idAccount = myCase.Account.Id;
            console.log('#y' + JSON.stringify(idAccount));
            var action = component.get('c.getCasesByAccount');
            action.setParams({
                'idAccount': idAccount
            });
            action.setCallback(this, function (response) {
                console.log('response', JSON.stringify(response));
                if (response.getState() == "SUCCESS") {
                    var resultat = response.getReturnValue();
                    console.log('response >>', JSON.stringify(resultat));
                    if (!resultat.erreur) {
                        component.set('v.cases', resultat.resultat);
                        var caseList = component.get('v.cases');
                        console.log(JSON.stringify(caseList));
                        component.set("v.totalSize", component.get("v.cases").length);
                        component.set("v.start", 0);
                        component.set("v.end", pageSize - 1);
                        var numberOfCasesToDisplay = [];
                        if (component.get('v.totalSize') < pageSize) {
                            for (var i = 0; i < component.get('v.totalSize'); i++) {
                                numberOfCasesToDisplay.push(caseList[i]);
                            }
                        } else {
                            for (var i = 0; i < pageSize; i++) {
                                numberOfCasesToDisplay.push(caseList[i]);
                            }
                        }
                        component.set('v.numberOfCasesToDisplay', numberOfCasesToDisplay);
                    } else {

                    }
                }
            });
            $A.enqueueAction(action);

        } else {
            console.log('accountId is undefined');
            component.set('v.cases', []);
        }
    }
})