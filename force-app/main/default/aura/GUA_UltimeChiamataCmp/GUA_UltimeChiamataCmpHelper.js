({

    getTaskById: function(component) {
        var accountId = component.get("v.accountId");
        if(!accountId) return;
        console.log('accountId', accountId);
        var action = component.get("c.getTaskByID");
        action.setParams({
            "accountId": accountId
        });
        action.setCallback(this, function(resp) {
            if (resp.getState() == 'SUCCESS') {
                var data = resp.getReturnValue();
                var UltimeChimataDealerList = data.ultimeChiamateDealer;
                UltimeChimataDealerList = UltimeChimataDealerList.map(function(ultime) {
                    console.log('created date ', ultime.Tasks[0].CreatedDate);
                    if(!ultime.Tasks ||  !ultime.Tasks[0].CreatedDate) return;
                    var createdDateTempList = ultime.Tasks[0].CreatedDate.split('T');
                    var hourTempList = createdDateTempList[1].split(':');
                    ultime.Tasks[0].CreatedDate = createdDateTempList[0] + ' ' + hourTempList[0] + ':' + hourTempList[1] + ':' + hourTempList[2].split('.')[0];

                    
                    return ultime;
                });
                console.log('UltimeChimataDealerList ', JSON.stringify(UltimeChimataDealerList));
                component.set("v.UltimeChimataDealerList", data.ultimeChiamateDealer);
                //component.set('v.case', data.case);
                console.log('data', JSON.stringify(data));
                component.set('v.operatore', data.operatore);
            }
            this.hideSpinner(component,null,null);
        });
        $A.enqueueAction(action);
    },
    ShowHideAll: function(component, event) {
        let activeSections = component.get("v.activeSections");
        if (activeSections.length === 0) {
            component.set("v.activeSections", ["A", "B", "C"]);
        } else {
            component.set("v.activeSections", []);
        }
    },

    // this function automatic call by aura:waiting event  
    showSpinner: function(component, event, helper) {
        // make Spinner attribute true for display loading spinner 
        component.set("v.Spinner", true);
    },

    // this function automatic call by aura:doneWaiting event 
    hideSpinner: function(component, event, helper) {
        // make Spinner attribute to false for hide loading spinner    
        component.set("v.Spinner", false);
    },
})