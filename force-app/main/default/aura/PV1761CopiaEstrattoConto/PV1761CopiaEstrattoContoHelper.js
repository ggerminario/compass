({
  validateUserInput: function(component, event, helper) {
    var messaggi = "";

    // Controllo che la pratica sia selezionata
    var thisPratica = component.get("v.PVForm.pratica");
    if ($A.util.isUndefinedOrNull(thisPratica)) {
      messaggi += "Selezionare una pratica.\n";
    }

    var meseAnnoList = component.get("v.MeseAnnoList");
    if ($A.util.isUndefinedOrNull(meseAnnoList) || meseAnnoList.length == 0) {
      messaggi += "Selezionare almeno un estratto conto da recuperare.\n";
    }

    var destinatario = component.get("v.selectedDestinatario");
    if ($A.util.isUndefinedOrNull(destinatario) || destinatario == "Selezionare") {
      messaggi += "Selezionare il destinatario dell'e/c.\n";
    } else if (destinatario == "Cliente") {
      //TODO: INDICARE IL COGNOME (???)
      if (this.isUndefinedNullOrEmpty(component.get("v.destProvincia"))) {
        messaggi += "Indicare la provincia\n";
      } else if (this.isUndefinedNullOrEmpty(component.get("v.destLocalita"))) {
        messaggi += "Indicare la località\n";
      } else if (this.isUndefinedNullOrEmpty(component.get("v.destCap"))) {
        messaggi += "Indicare il CAP\n";
      } else if (this.isUndefinedNullOrEmpty(component.get("v.destIndirizzo"))) {
        messaggi += "Indicare l'indirizzo\n";
      } else {
        if (component.get("v.destCap").length != 5) {
          messaggi += "Il CAP deve essere di 5 cifre\n";
        }
      }
    }

    return messaggi;
  },

  completaPVForm: function(cmp, event, helper, PVForm) {
    //   oggetto che contiene tutti i record che verranno scritti in tabella
    var ecs = new Array();

    var meseAnnoList = cmp.get("v.MeseAnnoList");

    meseAnnoList.forEach(function(ma) {
      var ec = new Object();
      ec.loan_number = cmp.get("v.PVForm.pratica.numPratica");
      ec.ec_anno = ma["anno"];
      ec.ec_mese = ma["mese"];
      ec.send_to = cmp.get("v.selectedDestinatario");

      // Se send_to==Cliente, allora i campi dell'indirizzo li prendo da form
      if (ec.send_to == "Cliente") {
        ec.address = cmp.get("v.destIndirizzo");
        ec.city = cmp.get("v.destLocalita");
        ec.prov = cmp.get("v.destProvincia");
        ec.cap = cmp.get("v.destCap");
      } else if (ec.send_to == "Filiale") {
        // Altrimenti valorizzo il campo codFiliale col codice della filiale
        ec.filiale = "F" + cmp.get("v.PVForm.pratica.filiale");
      }

      ec.cognome = cmp.get("v.PVForm.cliente.cognome");
      ec.nome = cmp.get("v.PVForm.cliente.nome");
      ec.ocs_anag = cmp.get("v.PVForm.cliente.codCliente");

      ecs.push(ec);
    });

    PVForm.ecs = ecs;
    PVForm.send_to = cmp.get("v.selectedDestinatario");
    return PVForm;
  },

  isUndefinedNullOrEmpty: function(s) {
    return $A.util.isUndefinedOrNull(s) || String(s).trim() == "";
  }
});