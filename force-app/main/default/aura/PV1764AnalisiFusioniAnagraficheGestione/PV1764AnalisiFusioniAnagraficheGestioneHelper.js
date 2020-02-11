({
  doInit: function(cmp, event) {
    var action = cmp.get("c.getClienti");
    var theCaseClient = cmp.get("v.theCase.PV_Info_Variazione_Anagrafica__c");
    var listCod = theCaseClient.split(",");

    action.setParams({ codiciCliente: listCod });
    action.setCallback(this, function(response) {
      var state = response.getState();
      if (state === "SUCCESS") {
        console.log("Success " + JSON.stringify(response.getReturnValue()));
        cmp.set("v.clientiMap", response.getReturnValue()["clienti"]);
      } else if (state === "INCOMPLETE") {
        console.log(
          "Risposta ws incomplete: " + JSON.stringify(response.getError())
        );
      } else if (state === "ERROR") {
        console.log(
          "Risposta ws errore " + JSON.stringify(response.getError())
        );
      }
    });
    $A.enqueueAction(action);

    var action2 = cmp.get("c.fetchUserDetail");

    action2.setCallback(this, function(response) {
      var state = response.getState();
      if (state === "SUCCESS") {
        var res = response.getReturnValue();
        cmp.set("v.currentUser", res);
      } else if (state === "INCOMPLETE") {
        // do something
      } else if (state === "ERROR") {
        var errors = response.getError();
        if (errors) {
          if (errors[0] && errors[0].message) {
            console.log("Error message: " + errors[0].message);
          }
        } else {
          console.log("Unknown error");
        }
      }
    });
    $A.enqueueAction(action2);
  },

  listaVariazioni: function(cmp, event) {
    var listaVariazioni = [];
    var Nome;
    var Cognome;

    if (cmp.find("nome") != undefined && cmp.find("nome").get("v.value")){
      Nome = cmp.find("nome").get("v.value");
    }

    if (cmp.find("cognome") != undefined && cmp.find("cognome").get("v.value")){
      Cognome = cmp.find("cognome").get("v.value");
    }

    console.log("Checkbox nome e congome: " + Nome + " " + Cognome);
    if (Nome && Cognome) {
      cmp.set("v.hasCarteAttive", true);
      cmp.set("v.columns", [
        { label: "Numero carta", fieldName: "numPratica", type: "text" },
        { label: "Carta attiva", fieldName: "desStatoPratica", type: "text" }
      ]);
      var praticheAttive = [];
      var pratiche = cmp.get("v.clienteSelezionato.pratiche");
      pratiche.forEach(function(item, index) {
        if (item.desStatoPratica == "SI") {
          praticheAttive.push(item);
        }
      });

      cmp.set("v.carteAttive", praticheAttive);
    } else {
      cmp.set("v.hasCarteAttive", false);
    }
  },
  caricaDatiAnagrafica: function(cmp, event) {
    cmp.set("v.clienteSelezionato", '');
    if (cmp.find("nome") != undefined && cmp.find("nome").get("v.value")) {
      cmp.find("nome").set("v.value", false);
    }
    if (cmp.find("cognome") != undefined && cmp.find("cognome").get("v.value")
    ) {
      cmp.find("cognome").set("v.value", false);
    }
    cmp.set("v.hasCarteAttive", false);
    cmp.set("v.carteAttive", null);
    console.log("Carica dati variazione anagrafica");
    var clienti = cmp.get("v.clientiMap");
    var codCliSel = cmp.get("v.codCliSel");

    clienti.forEach(function(item, index) {
      if (item.codCliente == codCliSel.trim()) {
        cmp.set("v.clienteSelezionato", item);
      }
    });
  },

  save: function(cmp, event, helper) {
    var parent = cmp.get("v.parent");
    parent.set("v.messaggiErrore", ""); 
    var  isValid = this.validateUserInput(cmp, event, helper);
    console.log('Is valid ' + isValid)
    if (isValid == "") {
        this.creaNote(cmp,event,parent);   
    } else {
      parent.set("v.messaggiErrore", isValid);
    }
  },

  doSave: function(cmp,event,parent){
    debugger;
    console.log('Nel metodo dosave');
    var noteGestionePV = this.getNote(cmp,event);

    console.log("Note complete: " + noteGestionePV);
    console.log("esempio :" + parent.get("v.userData"));
    console.log("clienti ndg :" + cmp.get('v.clientiNDG'));
    //cmp.set("v.errorMessage", "");
    parent.methodShowWaitComponent();
    var action = cmp.get("c.saveCase");
    action.setParam("form", {
      newStatus: cmp.get("v.newStatus"),
      note: noteGestionePV,
      attachmentList: cmp.get("v.allegati"),
      userData: parent.get("v.userData"),
      tipoAnnullamento: cmp.get('v.tipoAnnullamento'),
      flagRinvia: cmp.get("v.flagRinvia"),
      clientiNDG: cmp.get('v.clientiNDG'),
      clienteDaMantenere: cmp.get('v.codCliSel')
    });
    action.setParam("theCase", cmp.get("v.theCase"));
    // Imposto la Callback
    action.setCallback(this, function(response, helper) {
      if (response.getState() === "SUCCESS") {
        cmp.get("v.parent").showToast(response, "", "");
      } else if (response.getState() === "ERROR") {
      }
      cmp.get("v.parent").showToast(response, "", "");
      cmp.get("v.parent").methodHideWaitComponent();
    });
    $A.enqueueAction(action);
  },

  validateUserInput: function(cmp, event, helper) {
    console.log("Nel metodo validateuserinput");
    var usr =  cmp.get('v.currentUser');

    var messaggio = "";
    var stato =  cmp.get('v.newStatus');

    console.log('Stato: ' + stato);
    console.log('Flag rinvia: ' + cmp.get("v.flagRinvia"));

    if(stato == 'Closed' && !cmp.get("v.flagRinvia") && usr.Branch_Or_Office__c != 'Reclami' && usr.Branch_Or_Office__c != 'CCLI' &&  usr.Branch_Or_Office__c != 'ARIC' &&  usr.Branch_Or_Office__c != 'FIL'){
    if (cmp.get("v.tipoAnnullamento") == "") {
      messaggio += "Indicare la tipologia di annullamento.<br>";
    }
    if (cmp.get("v.codCliSel") == "") {
      messaggio += "Indicare il codice dell'anagrafica mantenuta.<br>";
    }
    if (cmp.get("v.codDaAnnullare") == "") {
      messaggio += "Indicare i codici delle anagrafiche cancellate.<br>";
    }
    if (cmp.find("cognome") != undefined && cmp.find("cognome").get("v.value") && cmp.find("nome") != undefined && cmp.find("nome").get("v.value") && cmp.get("v.carteAttive").length > 0) {
      if (cmp.get("v.riconsegna") == "" || cmp.get("v.riconsegna") == "SEL") {
        messaggio += "Indicare se deve essere creata la richiesta di riconsegna carte<br>";
      } else if (cmp.get("v.riconsegna") == "SI" && cmp.get("v.carteDaRiconsegnare").length == 0) {
        messaggio += "Seleziona almeno una carta<br>";
      } else if (cmp.get("v.riconsegna") == "NO" && cmp.get("v.carteDaRiconsegnare").length > 0) {
        messaggio += "Carte selezionate con flag a NO: deselezionare le carte o impostare il flag a Si.<br>";
      }
    }
  }else if(stato == 'Closed' && cmp.get("v.flagRinvia") ){
    console.log('Note: ' + cmp.get("v.note"));
    if (cmp.get("v.note") == "" || cmp.get("v.note") == undefined) {
      console.log('Nell if stato annullato');
      messaggio += "Specificare delle note.<br>";
    }
  }
  else if(stato == 'Annullato'){
    console.log('Note: ' + cmp.get("v.note"));
    if (cmp.get("v.note") == "" || cmp.get("v.note") == undefined) {
      console.log('Nell if stato annullato');
      messaggio += "Specificare delle note.<br>";
    }

  }else if(stato == 'Closed' && !cmp.get("v.flagRinvia") && (usr.Branch_Or_Office__c == 'Reclami' || usr.Branch_Or_Office__c == 'CCLI' ||  usr.Branch_Or_Office__c == 'ARIC' || usr.Branch_Or_Office__c == 'FIL')){
    if (cmp.get("v.note") == "" || cmp.get("v.note") == undefined) {
      messaggio += "Specificare delle note.<br>";
    }

  }
    return messaggio;
  },

  carteDaRiconsegnare: function(cmp, event) {
    var selectedRows = event.getParam("selectedRows");
    cmp.set("v.carteDaRiconsegnare", selectedRows);
  },
  
  creaNote: function(cmp,event,parent){
      //debugger;
    console.log('Nel metodo crea note');
    var stato = cmp.get('v.newStatus');
    var noteGestionePV = "<br>";
    var clienti = cmp.get('v.clientiMap');
    var clientiNDG = [];
    var codiciDaAnnullare = cmp.get('v.codDaAnnullare').split(",");
    noteGestionePV += "Back Office - " + cmp.get("v.currentUser.Name") + "<br>";
    noteGestionePV += "Stato: " + cmp.get("v.newStatus") + "<br>";
    noteGestionePV += "Annullamento:" + cmp.get("v.tipoAnnullamento") + "<br>";
    noteGestionePV += "Codice anagrafica mantenuta:" + cmp.get("v.codCliSel") + "<br><br>";
    noteGestionePV += "Elenco pratiche:" + "<br><br>";

    clienti.forEach(function(cli, index) {
        noteGestionePV += "Cliente: " + cli.codCliente + ' - ' + cli.nome + ' ' + cli.cognome + "<br>";
        if(cli.ndg != '' && cli.ndg != 0 && cli.codCliente != cmp.get("v.codCliSel") && codiciDaAnnullare.includes(cli.codCliente)){
            clientiNDG.push(cli);
        }
        cli.pratiche.forEach(function(prat, index) {
            noteGestionePV += prat.tipoPratica + ' ' + prat.numPratica + ' ' + prat.statoPratica + ' ' + prat.desAttributoPratica + "<br>";    
        });
      });

    noteGestionePV += "<br><br>" + "Lista variazioni:" + "<br>";

    var listaVariazioni = this.getListaVariazioni(cmp,event);
   
    listaVariazioni.forEach(function(lis, index) {
        noteGestionePV += " - " + lis + "<br>";
      });
  noteGestionePV += "<br><br>" +  "Codice anagrafiche cancellate: " + cmp.get('v.codDaAnnullare') + "<br><br>";
  

  //email clientiMap
  if(clientiNDG.length > 0 && stato == 'Closed'){
    cmp.set('v.clientiNDG',clientiNDG);
    console.log('Clienti NDG: ' + cmp.get('v.clientiNDG'));
    var bodyEmail = "";
    var action3 = cmp.get("c.recuperaTemplate");
    action3.setParams({
        "argSelected" : "Email Ufficio sistemi Fusione Anagrafica",
        "clientiNDG" : clientiNDG,
        "daMantenere" : cmp.get("v.codCliSel") 
    });
    action3.setCallback(this, function(response){
        //console.log("invio mail callback");
        if (response.getState() === 'SUCCESS') {
            bodyEmail = response.getReturnValue();
            console.log('BODYMAIL: ' + bodyEmail);
            noteGestionePV += "Comunicazione a ufficio sistemi per cancellazione anagrafiche con codice NDG:" + "<br>";
            noteGestionePV +=  bodyEmail;
            //A cura della filiale "v.carteDaRiconsegnare"
        var carteDaRiconsegnare = cmp.get("v.carteDaRiconsegnare");
        if(carteDaRiconsegnare.length > 0 ){
                noteGestionePV += '<br><br>A CURA DELLA FILIALE' + "<br>";
                noteGestionePV += 'A seguito il cambio intestazione, è necessario farsi consegnare le carte:'+ "<br>";
                carteDaRiconsegnare.forEach(function(ric, index) {
                noteGestionePV += ric.numPratica + "<br>";
          });
            
        noteGestionePV += "ed inserire in CRM (per l'Ufficio Customer Service) la richiesta di post-vendita di Duplicaro Carta per la remissione della tessera con il nominativo corretto." + "<br>";
       
    } 
        cmp.set("v.createdNote",noteGestionePV);
        console.log('Prima di dosave');
        this.doSave(cmp,event,parent);
  }
        else if (response.getState() === "ERROR") {
            console.log('Errore recupera template: ' + response.getError());
        }
    });
    $A.enqueueAction(action3);   
  } else if(clientiNDG.length == 0 && (stato == 'Annullato' || stato == 'Sospeso' || cmp.get("v.flagRinvia"))){
    this.doSave(cmp,event,parent);
  }else if(clientiNDG.length == 0 && stato == 'Closed'){
    var carteDaRiconsegnare = cmp.get("v.carteDaRiconsegnare");
    if(carteDaRiconsegnare.length > 0 ){
            noteGestionePV += '<br><br>A CURA DELLA FILIALE' + "<br>";
            noteGestionePV += 'A seguito il cambio intestazione, è necessario farsi consegnare le carte:'+ "<br>";
            carteDaRiconsegnare.forEach(function(ric, index) {
            noteGestionePV += ric.numPratica + "<br>";
      });
        
    noteGestionePV += "ed inserire in CRM (per l'Ufficio Customer Service) la richiesta di post-vendita di Duplicaro Carta per la remissione della tessera con il nominativo corretto." + "<br>";
    cmp.set("v.createdNote",noteGestionePV);
  }
  cmp.set("v.createdNote",noteGestionePV);
  this.doSave(cmp,event,parent);
}
  },

  getNote: function(cmp,event){
     return cmp.get("v.createdNote");
  },

  getListaVariazioni: function(cmp, event) {
    var listaVariazioni = [];
      //Salvo la lista delle variazioni spuntate
    if(cmp.find("denominazione") != undefined && cmp.find("denominazione").get("v.value")){
        listaVariazioni.push('Denominazione azienda')
    }
    if(cmp.find("forma") != undefined && cmp.find("forma").get("v.value")){
        listaVariazioni.push('Forma giuridica')
    }
    if(cmp.find("cognome") != undefined && cmp.find("cognome").get("v.value")){
        listaVariazioni.push('Cognome')
    }
    if(cmp.find("nome") != undefined && cmp.find("nome").get("v.value")){
        listaVariazioni.push('Nome')
    }
    if(cmp.find("codfiscale") != undefined && cmp.find("codfiscale").get("v.value")){
        listaVariazioni.push('Codice Fiscale')
    }
    if(cmp.find("sesso") != undefined && cmp.find("sesso").get("v.value")){
        listaVariazioni.push('Sesso')
    }
    if(cmp.find("datnascita") != undefined && cmp.find("datnascita").get("v.value")){
        listaVariazioni.push('Data di nascita')
    }
    if(cmp.find("provnascita") != undefined && cmp.find("provnascita").get("v.value")){
        listaVariazioni.push('Provincia nascita')
    }
    if(cmp.find("luogonascita") != undefined && cmp.find("luogonascita").get("v.value")){
        listaVariazioni.push('Luogo nascita')
    }
    if(cmp.find("tipoana") != undefined && cmp.find("tipoana").get("v.value")){
        listaVariazioni.push('Tipo anagrafica')
    }
    if(cmp.find("tipodoc") != undefined && cmp.find("tipodoc").get("v.value")){
        listaVariazioni.push('Tipo')
    }
    if(cmp.find("numerodoc") != undefined && cmp.find("numerodoc").get("v.value")){
        listaVariazioni.push('Numero')
    }
    if(cmp.find("dataril") != undefined && cmp.find("dataril").get("v.value")){
        listaVariazioni.push('Data rilascio')
    }
    if(cmp.find("datascad") != undefined && cmp.find("datascad").get("v.value")){
        listaVariazioni.push('Data scadenza')
    }
    if(cmp.find("provli") != undefined && cmp.find("provli").get("v.value")){
        listaVariazioni.push('Provincia rilacio')
    }
    if(cmp.find("luogoril") != undefined && cmp.find("luogoril").get("v.value")){
        listaVariazioni.push('Luogo rilacio')
    }
    return listaVariazioni;
  }
});