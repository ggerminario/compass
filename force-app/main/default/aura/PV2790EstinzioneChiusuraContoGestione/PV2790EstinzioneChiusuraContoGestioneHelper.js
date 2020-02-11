({
  init: function(cmp, event, helper) {
    console.log("init helper");

    // Recupero la data di estinzione dal case

    // retrieveDataEstinzione(ID caseId)
    var action = cmp.get("c.retrieveDataEstinzione");
    action.setParam("caseId", cmp.get("v.theCase.Id"));
    // Imposto la Callback
    action.setCallback(this, function(response, helper) {
      if (response.getState() === "SUCCESS") {
        cmp.set("v.dataEstinzione",response.getReturnValue());
      } 
 
    });
    $A.enqueueAction(action);
  },

  save: function(cmp, event, helper) {
    var parent = cmp.get("v.parent");
    var errori = this.validateUserInput(cmp, event, helper);
    if (errori == "") {
        //cmp.set("v.errorMessage", "");
        parent.methodShowWaitComponent();
        var action = cmp.get('c.saveCase');
        action.setParam('form',
            {
                "newStatus": cmp.get('v.newStatus'),
                "note": cmp.get("v.note"),
                // "note" : noteGestionePV,
                "attachmentList": cmp.get('v.allegati'),
                "userData": parent.get('v.userData'),
                "dataOperazione": cmp.get('v.dataOperazione')
            }
        );
        action.setParam('theCase', cmp.get("v.theCase"));
        // Imposto la Callback
        action.setCallback(this, function (response, helper) {
            if (response.getState() === 'SUCCESS') {
                cmp.get("v.parent").showToast(response,"","");
            }
            else if (response.getState() === "ERROR") {
            }
            cmp.get("v.parent").showToast(response, "", "");
            cmp.get("v.parent").methodHideWaitComponent();
        });
        $A.enqueueAction(action);
    } else {
      parent.set("v.messaggiErrore", errori);
    }
  },

  validateUserInput: function(cmp, event, helper) {
    var messaggi = "";
    return messaggi;
  }
});