/**
 * @File Name          : PV2790_2794ImportoDataOperazioneFormHelper.js
 * @Description        : 
 * @Author             : GdL Exprivia
 * @Group              : 
 * @Last Modified By   : GdL Exprivia
 * @Last Modified On   : 10/2/2020, 14:46:53
 * @Modification Log   : 
 * Ver       Date            Author      		    Modification
 * 1.0    6/2/2020   GdL Exprivia     Initial Version
**/
({
  calcolaSaldo: function(cmp, event, helper) {
    var numPratica = cmp.get("v.numPratica");

    if ($A.util.isUndefinedOrNull(numPratica)) {
      helper.showToast("Selezionare una pratica.", "Error");
      return;
    }
    var action = cmp.get("c.doCalcolaSaldo");
    action.setParams({
      input: numPratica
    });
    action.setCallback(this, function(response, helper) {
      try{
        var saldo = response.getReturnValue()["cseInterrogazioneSaldoLightResponse"]["saldo"];

        if (!$A.util.isUndefinedOrNull(saldo)) {
          cmp.set("v.importo", saldo);
        }
      }catch (err){
        this.showToast("Errore durante il calcolo del saldo.", "Error");
      }
    });
    $A.enqueueAction(action);
  },

  doValidityCheck: function(cmp, event, helper) {
    var messaggi = "";
    var dataOperazioneCmp = cmp.find("dataOperazione");
    if (!cmp.find("dataOperazione").checkValidity()) {
      if (dataOperazioneCmp.get("v.validity")["badInput"]) {
        messaggi += "Data Estinzione errata.\n";
      } else if (dataOperazioneCmp.get("v.validity")["valueMissing"]) {
        messaggi += "Indicare la data di operazione.\n";
      }
      cmp.find("dataOperazione").showHelpMessageIfInvalid();
    } else {
      var today = new Date();
      today.setHours(0, 0, 0, 0);
      var dataOperazione = new Date(cmp.get("v.dataOperazione"));
      dataOperazione.setHours(0, 0, 0, 0);
      if (dataOperazione.getTime() > today.getTime()) {
        messaggi += "La data operazione non può essere futura";
      }
    }
    cmp.set("v.errori", messaggi);
  },

  showToast: function(message, type) {
    var toastEvent = $A.get("e.force:showToast");
    toastEvent.setParams({
      message: message,
      type: type,
      mode: "dismissible"
    });
    toastEvent.fire();
  }
});