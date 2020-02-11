({
  recuperaIndirizziCliente: function(cmp, event, helper) {
    var thisCodCliente = cmp.get("v.PVForm.cliente.codCliente");
    var lastCodCliente = cmp.get("v.lastCodCliente");

    if (!$A.util.isUndefinedOrNull(thisCodCliente) && thisCodCliente != lastCodCliente) {
      console.log("v.PVForm: " + JSON.stringify(cmp.get("v.PVForm")));
      cmp.set("v.OCSIndirizziNorm",null);
      cmp.set("v.normalizzaIsClicked",false);
      cmp.set("v.checkResponse",null);
      cmp.set("v.thisIndirizzoSelected",null);

      helper.gestisciAlertSuPratiche(cmp, event, helper);
      helper.recuperaIndirizziCliente(cmp, event, helper);
      cmp.set("v.lastCodCliente", thisCodCliente);
    }
  },

  selectIndirizzo: function(cmp, event, helper) {
    // Creo una copia profonda dell'indirizzo che sto modificando
    cmp.set("v.thisIndirizzoSelected", JSON.parse(JSON.stringify(event.getParam("selectedRows")[0])));
    cmp.set("v.thisTipoIndirizzoSelected", event.getParam("selectedRows")[0]["tipoIndirizzo"]);
  },

  normalizza: function(cmp, event, helper) {
    helper.normalizza(cmp, event, helper);
  },
  cancella: function(cmp, event, helper) {
    helper.cancella(cmp, event, helper);
  },

  processaIndirizzoNorm: function(cmp, event, helper) {
    if (event.getParam("selectedRows")[0]) {
      helper.processaIndirizzoNorm(cmp, event, helper);
    }
  },

  selectIndirizzoRiep: function(cmp, event, helper) {
    cmp.set("v.thisTipoIndirizzoRiepSelected", event.getParam("selectedRows")[0]["tipoIndirizzo"]);
    cmp.set("v.thisActionIndirizzoRiepSelected", event.getParam("selectedRows")[0]["azione"]);
  },

  annullaVariazioneIndirizzo: function(cmp, event, helper) {
    helper.annullaVariazioneIndirizzo(cmp, event, helper);
  }
});