({
  /*-----------------------------------------------------------------
    ###################################################################
                    STAMPA DATI FINANZIARI CARTA
    ###################################################################
    -----------------------------------------------------------------*/

  //controllo per la valorizzazione di tutti gli input di postvendita

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

  onPraticaSelected: function(component) {
    console.log("[PV1769DenunciaCarta - onPraticaSelected]");
    this.setDatiFinanziariCarta(component);
  },

  setDatiFinanziariCarta: function(component) {
    var PVForm = component.get("v.PVForm");
    console.log("PVForm numero pratica: " + component.get("v.PVForm.pratica.numPratica"));

    if (this.isValid(component)) {
      component.set("v.showDetails", true);
      this.mostraClessidra(component);

      var action = component.get("c.getDatiFinanziariCarta");
      var numeroCarta = component.get("v.PVForm.pratica.numPratica");

      action.setParams({
        numeroCarta: numeroCarta
      });

      action.setCallback(this, function(response) {
        console.log("[PV1769DenunciaCarta - setDatiFinanziariCarta] action state:", response.getState());
        console.log("[PV1769DenunciaCarta - setDatiFinanziariCarta] return value:", response.getReturnValue());

        if (component.isValid() && response.getState() === "SUCCESS" && response.getReturnValue()) {
          var detail = response.getReturnValue();
          component.set("v.cartaDatiFinanziariData", detail);
          this.showCartaDatiFinanziari(component, true);
          console.log("[PV1769DenunciaCarta - setDatiFinanziariCarta] detail:", response.getReturnValue());

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
        } else {
          this.handleErrors(component, response);
        }

        this.nascondiClessidra(component);
      });

      $A.enqueueAction(action);
    } else {
      component.set("v.showDetails", false);
    }
  },

  /*-----------------------------------------------------------------
    ###################################################################
                           METODO DA PARENT
    ###################################################################
    -----------------------------------------------------------------*/

  validateUserInput: function(cmp, event, helper) {
    var messaggi = "";
    messaggi += this.checkClienteSelezionato(cmp);

    // Controllo che la pratica sia selezionata
    var praticaSelezionata = cmp.get("v.PVForm.pratica");
    if ($A.util.isUndefinedOrNull(praticaSelezionata)) {
      messaggi += "Selezionare una pratica.\n";
    }

    if (messaggi == "") {
      var dest = cmp.get("v.value");
      if ($A.util.isUndefinedOrNull(dest)) {
        messaggi += "Selezionare un'opzione di carta sostitutiva";
        return messaggi;
      }
      messaggi = "";
      // if(($A.util.isUndefinedOrNull(cmp.get('v.PVForm.isCheckFax'))) || (cmp.get('v.PVForm.isCheckFax') === 'false')){
      //     console.log(cmp.get('v.PVForm.isCheckFax'));
      //     messaggi += "Inserire un allegato";
      // }

    }
    return messaggi;
  },

  completaPVForm: function(cmp, event, helper, PVForm) {
    //debugger;
    // arricchisco il PVForm con dati specifici del PV
    var carta_sost = cmp.get("v.value");
    if (carta_sost === "revoca") {
      PVForm.noteAggiornamentoCA = "Cliente chiede revoca";
    } else if (carta_sost === "duplicato") {
      PVForm.noteAggiornamentoCA = "Cliente chiede duplicato";
    }
    console.log("[PV1769DenunciaCarta - completaPVForm] PVForm:", PVForm);
    return PVForm;
  }
});