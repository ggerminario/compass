({
  /*
   * Funzione : recuperaIndirizziCliente
   * Funzione che recupera tutti gli indirizzi associati al cliente
   * Viene chiamata al cambiamento della variabile v.PVForm.cliente.codCliente
   *
   */

  recuperaIndirizziCliente: function(cmp, event, helper) {
    var codCliente = cmp.get("v.PVForm.cliente.codCliente");
    if (codCliente != null) {
      var action = cmp.get("c.doRecuperaIndirizziCliente");

      action.setParams({
        codCliente: codCliente
      });

      action.setCallback(this, function(response, helper) {
        if (response.getState() == "SUCCESS" && response.getReturnValue()) {
          // Conversione CAP 00000 ---> ""
          // Conversione TipoIndirizzo: D --> Domicilio, R --> Residenza, P --> Precedente
          var indirizzi = response.getReturnValue();

          indirizzi.forEach(function(indirizzo) {
            switch (indirizzo["tipoIndirizzo"]) {
              case "D":
                indirizzo["tipoIndirizzo"] = "Domicilio";
                break;
              case "R":
                indirizzo["tipoIndirizzo"] = "Residenza";
                break;
              case "P":
                indirizzo["tipoIndirizzo"] = "Precedente";
                break;
            }
            if (indirizzo["cap"] == "00000") {
              indirizzo["cap"] = "";
            }
          });

          cmp.set("v.OCSIndirizzi", response.getReturnValue());

          // deep clone dell'elenco degli indirizzi per gestire il riepilogo
          cmp.set("v.OCSIndirizziRiep", JSON.parse(JSON.stringify(response.getReturnValue())));
        }
      });
      $A.enqueueAction(action);
    }
  },

  /*
   * Funzione : normalizza
   * Funzione che normalizza l'indirizzo immesso nel form
   * Viene chiamata al click del pulsante normalizza
   *
   */

  normalizza: function(cmp, event, helper) {
    // svuoto i campi successivi
    cmp.set("v.normResponse", null);
    cmp.set("v.normalizzaIsClicked", false);
    cmp.set("v.OCSIndirizziNorm", null);

    var action = cmp.get("c.doNormalizzaIndirizzo");

    var thisIndirizzo = cmp.get("v.thisIndirizzoSelected");

    var indirizzo = thisIndirizzo["indirizzo"];
    var cap = thisIndirizzo["cap"];
    var localita = thisIndirizzo["localita"];
    var provincia = thisIndirizzo["provincia"];

    if ($A.util.isUndefinedOrNull(indirizzo) || indirizzo.trim() == "") {
      this.showToast("Inserire l'indirizzo", "Error");
    } else if ($A.util.isUndefinedOrNull(cap) || cap.trim() == "") {
      this.showToast("Inserire il CAP", "Error");
    } else if ($A.util.isUndefinedOrNull(localita) || localita.trim() == "") {
      this.showToast("Inserire la provincia", "Error");
    } else if ($A.util.isUndefinedOrNull(provincia) || provincia.trim() == "") {
      this.showToast("Inserire la località", "Error");
    }

    action.setParams({
      indirizzo: indirizzo,
      cap: cap,
      localita: localita,
      provincia: provincia
    });

    action.setCallback(this, function(response, helper) {
      cmp.set("v.normResponse", response.getReturnValue());

      var elencoIndirizzi = response.getReturnValue()["normalizzaIndirizzoResponse"]["elencoIndirizzi"];

      cmp.set("v.normalizzaIsClicked", true);
      if (elencoIndirizzi.length > 0) {
        // Controllo per vedere se l'utente ha settato il civico nell'indirizzo
        if ($A.util.isUndefinedOrNull(elencoIndirizzi[0]["civico"]) || elencoIndirizzi[0]["civico"].trim() == "") {
          this.showToast("Inserire il numero civico nel campo indirizzo", "Error");
        } else {
          cmp.set("v.OCSIndirizziNorm", elencoIndirizzi);
        }
      }
    });
    $A.enqueueAction(action);
  },

  /*
   * Funzione: cancella
   * Funzione che cancella l'indirizzo selezionato
   * Viene chiamata al click del pulsante Cancella
   *
   * Mostra alert se:
   *  1 - L'indirizzo selezionato è Residenza o Precedente ["Solo il domicilio può essere cancellato"]
   *  2 - Il cliente non aveva quel tipo di indirizzo ["Indirizzo non presente. Impossibile cancellarlo"]
   *
   * Al termine, cancella l'indirizzo corrispondente nel riepilogo
   */

  cancella: function(cmp, event, helper) {
    var tipoIndirizzoSelected = cmp.get("v.thisTipoIndirizzoSelected");

    // è possibile cancellare solo il domicilio
    if (tipoIndirizzoSelected == "Residenza" || tipoIndirizzoSelected == "Precedente") {
      this.showToast("Solo il domicilio può essere cancellato", "Error");
      return;
    }

    var indirizziUtente = cmp.get("v.OCSIndirizzi");
    var indirizziRiepilogo = cmp.get("v.OCSIndirizziRiep");

    indirizziUtente.forEach(function(indirizzo) {
      if (indirizzo["tipoIndirizzo"] == tipoIndirizzoSelected) {
        if (indirizzo["indirizzo"] == null || indirizzo["indirizzo"].trim() == "") {
          this.showToast("Indirizzo non presente. Impossibile cancellarlo", "Error");
          return;
        }

        var indirizzoCancellato = new Object();

        indirizzoCancellato["azione"] = "Cancellato";

        indirizzoCancellato["tipoIndirizzo"] = tipoIndirizzoSelected;

        var index = indirizziUtente.indexOf(indirizzo);
        indirizziRiepilogo[index] = indirizzoCancellato;
      }
    });
    cmp.set("v.OCSIndirizziRiep", indirizziRiepilogo);
  },

  /*
   * Funzione: processaIndirizzoNorm
   * Funzione che processa l'indirizzo normalizzato selezionato
   * Viene chiamata alla selezione di un indirizzo normalizzato
   *
   * Al termine, modifica o inserisce l'indirizzo corrispondente nel riepilogo
   */

  processaIndirizzoNorm: function(cmp, event, helper) {
    var action = cmp.get("c.doProcessaResponse");
    var normResponse = cmp.get("v.normResponse");
    action.setParams({
      res: JSON.stringify(normResponse)
    });

    action.setCallback(this, function(response, helper) {
      var indirizziUtente = cmp.get("v.OCSIndirizzi");

      var tipoIndirizzoSelected = cmp.get("v.thisTipoIndirizzoSelected");

      var indirizziRiepilogo = cmp.get("v.OCSIndirizziRiep");

      indirizziUtente.forEach(function(indirizzo) {
        if (indirizzo["tipoIndirizzo"] == tipoIndirizzoSelected) {
          var indirizzoModificato = response.getReturnValue()["indirizziElenco"][0];
          indirizzoModificato = JSON.parse(JSON.stringify(indirizzoModificato));

          // Se l'indirizzo già esisteva allora l'ho modificato, altrimenti l'ho inserito
          if (indirizzo["indirizzo"] == null || indirizzo["indirizzo"].trim() == "") {
            indirizzoModificato["azione"] = "Inserito";
          } else {
            indirizzoModificato["azione"] = "Modificato";
          }
          indirizzoModificato["tipoIndirizzo"] = tipoIndirizzoSelected;

          var index = indirizziUtente.indexOf(indirizzo);
          indirizziRiepilogo[index] = indirizzoModificato;
        }
      });
      cmp.set("v.OCSIndirizziRiep", indirizziRiepilogo);
    });
    $A.enqueueAction(action);
  },

  /*
   * Funzione: annullaVariazioneIndirizzo
   * Funzione che annulla la variazione dell'indirizzo selezionato nel riepilogo
   * Viene chiamata al click del pulsante Annulla variazione indirizzo
   *
   * Mostra alert se:
   *  1 - Nessun indirizzo è stato selezionato dal riepilogo ["Selezionare una variazione da annullare"]
   * Al termine, ripristina l'indirizzo corrispondente nel riepilogo
   */

  annullaVariazioneIndirizzo: function(cmp, event, helper) {
    var tipoIndirizzoRiepSelected = cmp.get("v.thisTipoIndirizzoRiepSelected");
    var thisActionIndirizzoRiepSelected = cmp.get("v.thisActionIndirizzoRiepSelected");

    if ($A.util.isUndefinedOrNull(tipoIndirizzoRiepSelected)) {
      this.showToast("Selezionare una variazione da annullare", "Error");
      return;
    } else if ($A.util.isUndefinedOrNull(thisActionIndirizzoRiepSelected) || thisActionIndirizzoRiepSelected == "") {
      this.showToast("Nessuna variazione da annullare", "Error");
      return;
    }

    var indirizziUtente = cmp.get("v.OCSIndirizzi");
    var indirizziRiepilogo = cmp.get("v.OCSIndirizziRiep");

    indirizziUtente.forEach(function(indirizzo) {
      if (indirizzo["tipoIndirizzo"] == tipoIndirizzoRiepSelected) {
        var index = indirizziUtente.indexOf(indirizzo);
        indirizziRiepilogo[index] = indirizzo;
      }
    });
    cmp.set("v.OCSIndirizziRiep", indirizziRiepilogo);
  },

  /*
   * Funzione: gestisciAlertSuPratiche
   * Funzione si occupa di gestire gli alert che bloccano l'inserimento del case
   *
   *
   */

  gestisciAlertSuPratiche: function(cmp, event, helper) {
    // rdpvListaPratiche: lista pratiche ritornata dal servizio recuperaDatiPostVendita
    var rdpvListaPratiche = cmp.get("v.PVForm.cliente.pratiche");

    var codCliente = cmp.get("v.PVForm.cliente.codCliente");

    // Logica spostata lato server per ridurre il numero di chiamate client/server
    var action = cmp.get("c.doGestisciAlertSuPratiche");

    action.setParams({
      pratiche: rdpvListaPratiche,
      codCliente: codCliente
    });

    action.setCallback(this, function(response, helper) {
      cmp.set("v.checkResponse", response.getReturnValue());
      console.log("v.checkResponse: " + JSON.stringify(response.getReturnValue()));
    });
    $A.enqueueAction(action);
  },

  buildNoteVariazioni: function(ocsIndirizzi, ocsIndirizziRiep, helper) {
    var variazioni = "<br>Dati precedenti:";
    ocsIndirizzi.forEach(function(ind) {
      variazioni += helper.printIndirizzo(ind, true);
    });

    variazioni += "<br>Variazioni:";
    ocsIndirizziRiep.forEach(function(ind) {
      variazioni += helper.printIndirizzo(ind, false);
    });

    return variazioni + "<br>";
  },

  printIndirizzo: function(ind, showNulls) {
    var prefix = "";
    if ($A.util.isUndefinedOrNull(ind["azione"])) {
      if (showNulls == false) {
        return "";
      } else {
        prefix = "<br>- " + ind["tipoIndirizzo"] + ": ";
      }
    } else {
      prefix = "<br>- " + ind["azione"] + " " + ind["tipoIndirizzo"] + ": ";
    }

    if (ind["indirizzo"] != null) {
      return prefix + ind["indirizzo"] + " " + ind["cap"] + " " + ind["localita"] + " " + ind["provincia"];
    } else {
      return prefix;
    }
  },

  validateUserInput: function(cmp, event, helper) {
    var messaggi = "";
    return messaggi;
  },

  completaPVForm: function(cmp, event, helper, PVForm) {
    // arricchisco il PVForm con dati specifici del PV

    // Gestione noteOCS
    var ocsIndirizziRiep = cmp.get("v.OCSIndirizziRiep");
    PVForm.variazioneIndirizzi = ocsIndirizziRiep;

    var ocsIndirizzi = cmp.get("v.OCSIndirizzi");

    // Creo le note riguardanti le variazioni effettuate
    var variazioni = helper.buildNoteVariazioni(ocsIndirizzi, ocsIndirizziRiep, helper);

    if ($A.util.isUndefinedOrNull(PVForm.note)) {
      PVForm.note = variazioni;
    } else {
      PVForm.note = PVForm.note + variazioni;
    }

    // Gestione caso annullamento (cliente in errore + il fax non è stato ricevuto)
    var checkResponse = cmp.get("v.checkResponse");
    var isFaxRicevuto = cmp.get("v.isFaxRicevuto");

    console.log("checkResponse: " + JSON.stringify(checkResponse["resultCode"]));
    console.log("isFaxRicevuto: " + isFaxRicevuto);

    if (checkResponse["resultCode"] != "0" && isFaxRicevuto != true) {
      PVForm.annulla = "S";
      console.log("PVForm.annulla SI");
    } else {
      PVForm.annulla = "N";
      console.log("PVForm.annulla NO");
    }

    return PVForm;
  },

  showToast: function(message, type) {
    var toastEvent = $A.get("e.force:showToast");
    toastEvent.setParams({
      message: message,
      type: type
    });
    toastEvent.fire();
  }
});