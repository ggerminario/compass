({
    loadComuni : function (cmp,event,helper) {

        //In caso di provincia NON selezionata il valore del comune selezionato diventa vuoto
        if($A.util.isEmpty(cmp.get("v.provinciaSelection"))) {
            cmp.set('v.comuneSelection', '');
        }
        else {
            // console.log("INIT2 comuni: " + cmp.get("v.provinciaSelection"));
            var action = cmp.get('c.loadComuniApex');
            action.setParam('provincia', cmp.get("v.provinciaSelection"));
            action.setCallback(this, function (response) {
                var state = response.getState();
                if (state === 'SUCCESS') {
                    cmp.set('v.comuniList', response.getReturnValue());
                    // console.log('v.comuniList' + JSON.stringify(cmp.get("v.comuniList")));

                    //Se a seguito della modifica della provincia, il valore del comune selezionato precedentemente non è presente nella lista dei comuni recuperati, allora tale valore diventa vuoto
                    if(response.getReturnValue().findIndex(element => element.Comune__c === cmp.get('v.comuneSelection')) === -1) {
                        cmp.set('v.comuneSelection', '');
                    }
                }
            });
            $A.enqueueAction(action);
        }
    },
});