({
  isValid: function(component) {
    var PVForm = component.get("v.PVForm");
    return (
      !$A.util.isEmpty(PVForm) &&
      !$A.util.isEmpty(PVForm.cliente) &&
      !$A.util.isEmpty(PVForm.cliente.codCliente) &&
      !$A.util.isEmpty(PVForm.pratica) &&
      !$A.util.isEmpty(PVForm.pratica.numPratica) &&
      PVForm.cliente.codCliente === PVForm.pratica.codCliente
    );
  },

  onClienteSelected: function(component) {
    // Ripulisco il form
    this.mostraErrori(component, "");
    this.showMarkup(component, true);
    this.clearFields(component);
  },

  clearFields: function(component) {
    component.set("v.showDetails", false);
    component.set("v.cartaDatiFinanziariData", "");
    component.set("v.importo", "");
    component.set("v.campagnaSelezionata", null);
    component.set("v.rataSelezionata", "6");
    component.set("v.campagneAttivabili", null);
    component.set("v.elencoMovimenti", null);
    component.set("v.elencoAutorizzazioni", null);
  },

  onPraticaSelected: function(component) {
    this.setDatiFinanziariCarta(component);
  },

  setDatiFinanziariCarta: function(component) {
    component.set("v.spinnerCounter", 3);
    if (this.isValid(component)) {
      component.set("v.showDetails", true);
      this.mostraClessidra(component);

      var action = component.get("c.getDatiFinanziariCarta");
      var numeroCarta = component.get("v.PVForm.pratica.numPratica");

      action.setParams({
        numeroCarta: numeroCarta
      });

      action.setCallback(this, function(response) {
        if (component.isValid() && response.getState() === "SUCCESS" && response.getReturnValue()) {
          var detail = response.getReturnValue();
          component.set("v.cartaDatiFinanziariData", detail);
          this.showCartaDatiFinanziari(component, true);

          /*if(($A.util.isEmpty(detail.as400Errore)) && (detail.as400Status === 'OK')){
                            component.set('v.cartaDatiFinanziariData', detail);
                            console.log('[PV1769DenunciaCarta - setDatiFinanziariCarta] detail:', component.get('v.cartaDatiFinanziariData'));
                            this.showCartaDatiFinanziari(component, true);
                        }
                        else {
                            if(!$A.util.isEmpty(detail.as400Errore)) {
                                this.mostraToast(component, 'Attenzione', detail.as400Errore, 'warning', 10000);
                            }
                            else {
                                this.mostraToast(component, 'Attenzione', "E' stato riscontrato un problema con la funzionalità richiesta, contattare l'amministratore.", 'error', 10000);
                            }
                        }*/

          this.getCampagneAttivabili(component);
          this.getElencoAutorizzazioni(component);
          this.getElencoMovimenti(component);
        }
        // else {
        //   this.handleErrors(component, response);
        // }
      });

      $A.enqueueAction(action);
    } else {
      component.set("v.showDetails", false);
    }
  },

  getElencoAutorizzazioni: function(component, spinnerCounter) {
    var numPratica = component.get("v.PVForm.pratica.numPratica");
    var emettitore = component.get("v.cartaDatiFinanziariData.emettitore");

    var action = component.get("c.doRecuperaElencoAutorizzazioni");
    action.setParams({
      numPratica: numPratica,
      emettitore: emettitore
    });

    action.setCallback(this, function(response) {
      if (response.getState() === "SUCCESS" && response.getReturnValue()) {
        component.set("v.elencoAutorizzazioni", response.getReturnValue()["elencoAutorizzazioni"]);
      }
      //   else {
      //     this.handleErrors(component, response);
      //   }
      this.decreaseSpinnerCounter(component);
    });
    $A.enqueueAction(action);
  },

  getElencoMovimenti: function(component, spinnerCounter) {
    var numPratica = component.get("v.PVForm.pratica.numPratica");
    var emettitore = component.get("v.cartaDatiFinanziariData.emettitore");

    var action = component.get("c.doRecuperaElencoMovimenti");
    action.setParams({
      numPratica: numPratica,
      emettitore: emettitore
    });

    action.setCallback(this, function(response) {
      if (response.getState() === "SUCCESS" && response.getReturnValue()) {
        component.set("v.elencoMovimenti", response.getReturnValue()["elencoMovimenti"]);
      }
      //   else {
      //     this.handleErrors(component, response);
      //   }
      this.decreaseSpinnerCounter(component);
    });
    $A.enqueueAction(action);
  },

  getCampagneAttivabili: function(component, spinnerCounter) {
    var numPratica = component.get("v.PVForm.pratica.numPratica");
    var emettitore = component.get("v.cartaDatiFinanziariData.emettitore");
    var codProdotto = component.get("v.cartaDatiFinanziariData.codProdotto");

    var action = component.get("c.doRecuperaCampagneAttivabili");
    action.setParams({
      numPratica: numPratica,
      emettitore: emettitore,
      prodotto: codProdotto
    });

    action.setCallback(this, function(response) {
      if (response.getState() === "SUCCESS" && response.getReturnValue()) {
        component.set("v.campagneAttivabili", response.getReturnValue()["elencoCampagneAttivabli"]);
      }
      //   else {
      //     this.handleErrors(component, response);
      //   }
      this.decreaseSpinnerCounter(component);
    });
    $A.enqueueAction(action);
  },

  handleMovimentiSelection: function(component, event, helper) {
    var importo = parseFloat("0");
    event.getParam("selectedRows").forEach(function(mov) {
      importo += parseFloat(mov["importo"]);
    });
    component.set("v.importo", importo);
  },

  handleCampagnaSelection: function(component, event, helper) {
    component.set("v.campagnaSelezionata", event.getParam("selectedRows")[0]);
  },

  decreaseSpinnerCounter: function(component) {
    var spinnerCounter = component.get("v.spinnerCounter");
    spinnerCounter--;
    component.set("v.spinnerCounter", spinnerCounter);
    if (spinnerCounter == 0) {
      this.nascondiClessidra(component);
    }
  },

  validateUserInput: function(component, event, helper) {
    var messaggi = "";
    // Controllo che la pratica sia selezionata
    var thisPratica = component.get("v.PVForm.pratica");
    if ($A.util.isUndefinedOrNull(thisPratica)) {
      messaggi += "Selezionare una pratica.\n";
    }

    var thisCampagna = component.get("v.campagnaSelezionata");
    if ($A.util.isUndefinedOrNull(thisCampagna)) {
      messaggi += "Selezionare una campagna.\n";
    }

    var thisImporto = component.get("v.importo");
    if ($A.util.isUndefinedOrNull(thisImporto) || parseFloat(thisImporto)*100 == "0" ) {
      messaggi += "Inserire un importo o selezionare almeno un acquisto.\n";
    }

    console.log("v.PVForm: " + JSON.stringify(component.get("v.PVForm")));
    console.log("v.cartaDatiFinanziariData: " + JSON.stringify(component.get("v.cartaDatiFinanziariData")));
    return messaggi;
  },

  completaPVForm: function(cmp, event, helper, PVForm) {
    // arricchisco il PVForm con dati specifici del PV
    PVForm.importo = cmp.get("v.importo");
    PVForm.codCampagna = cmp.get("v.campagnaSelezionata.codCampagna");
    PVForm.dataScadenza = cmp.get("v.cartaDatiFinanziariData.dataScadenza");
    PVForm.numRate = cmp.get("v.rataSelezionata");
    PVForm.checkIntermediario = cmp.get("v.cartaDatiFinanziariData.checkIntermediario");

    return PVForm;
  }
});