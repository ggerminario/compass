/**
 * @File Name          : PV5866RichiestaConteggiEAGestioneHelper.js
 * @Description        :
 * @Author             : Federica Forte
 * @Group              :
 * @Last Modified By   : Raffaele Prudenzano
 * @Last Modified On   : 24/1/2020, 12:28:03
 * @Modification Log   :
 * Ver       Date            Author      		    Modification
 * 1.0    23/12/2019   Federica Forte     Initial Version
 **/
({
  helperMethod: function() {},

  doInit: function(cmp, event) {
    // Recupero la data di richiesta conteggio

    // retrieveDataRicCont(ID caseId)
    var action = cmp.get("c.retrieveDataRicCont");
    action.setParam("caseId", cmp.get("v.theCase.Id"));
    // Imposto la Callback
    action.setCallback(this, function(response, helper) {
      if (response.getState() === "SUCCESS") {
        cmp.set("v.dataCase", response.getReturnValue());
      }
    });
    $A.enqueueAction(action);

    console.log("theCase: " + JSON.stringify(cmp.get("v.theCase")));
    cmp.set("v.userData", cmp.get("v.parent").get("v.userData"));
    console.log("userData: " + JSON.stringify(cmp.get("v.userData")));
  },

  validateUserInput: function(cmp, event, helper) {
    var messaggi = "";
    var today = new Date();
    today.setHours(0, 0, 0, 0);
    var modificaData = new Date(cmp.get("v.modificaData"));
    modificaData.setHours(0, 0, 0, 0);

    if (modificaData.getTime() > today.getTime()) {
      messaggi +=
        "La Data ricezione richiesta conteggio può essere inferiore o uguale ad oggi.";
    }
    return messaggi;
  },

  save: function(cmp, event, helper) {
    var parent = cmp.get("v.parent");
    var rinvia = false;
    if (!$A.util.isUndefinedOrNull(cmp.find("checkboxRinviaAlMittente"))) {
      rinvia = cmp.find("checkboxRinviaAlMittente").get("v.checked");
    }
    var errori = "";
    if (errori == "") {
      parent.methodShowWaitComponent();
      var action = cmp.get("c.saveCase");
      action.setParam("form", {
        newStatus: cmp.get("v.newStatus"),
        note: cmp.get("v.note"),
        attachmentList: cmp.get("v.allegati"),
        userData: parent.get("v.userData"),
        rinvia: rinvia
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
    } else {
      parent.set("v.messaggiErrore", errori);
    }
  },

  variazioneMotivo: function(cmp, event, helper) {
    var evento = event.getSource();
    var motivoSelected = evento.get("v.value");
    if (motivoSelected == "") {
      cmp.set("v.modificaRispFilNote", "");
    } else {
      if (motivoSelected == "mail") {
        motivoSelected = "via " + motivoSelected;
      } else {
        motivoSelected = "a mezzo " + motivoSelected;
      }

      cmp.set(
        "v.modificaRispFilNote",
        "Vi informiamo d'aver inviato al cliente, " +
          motivoSelected +
          ", conteggio di e/a chiuso al XX/XX/20XX, di cui vi alleghiamo relativa copia. Restiamo a disposizione per chiarimenti. Cordiali Saluti."
      );
    }
    cmp.set("v.RispFilCase", motivoSelected);
  },

  confermaVariazioneMotivo: function(cmp, event, helper) {
    console.log("RispFilCase: " + cmp.get("v.RispFilCase"));
    console.log("modificaRispFilNote: " + cmp.get("v.modificaRispFilNote"));
    // TODO aggiustare if
    if (
      cmp.get("v.RispFilCase") != undefined &&
      cmp.get("v.RispFilCase") != ""
    ) {
      // cmp.set("v.note", cmp.get("v.modificaRispFilNote"));
      var parent = cmp.get("v.parent");

      parent.methodShowWaitComponent();

      var action = cmp.get("c.saveMotivo");
      action.setParam("theCase", cmp.get("v.theCase"));
      action.setParam("descMotivoCase", cmp.get("v.modificaRispFilNote"));

      // Imposto la Callback
      action.setCallback(this, function(response, helper) {
        if (response.getState() === "SUCCESS") {
          this.fireToast(
            "Postvendita",
            "Variazione motivo effettuata correttamente",
            "success",
            60000
          );
        } else if (response.getState() === "ERROR") {
          parent.showToast(response, "", "");
        }
        parent.methodHideWaitComponent();
      });
      $A.enqueueAction(action);
    }
  },

  variazioneData: function(cmp, event, helper) {
    // TODO aggiustare if
    if (
      cmp.get("v.modificaData") != undefined &&
      cmp.get("v.modificaData") != null
    ) {
      cmp.set("v.dataCase", cmp.get("v.modificaData"));
      var parent = cmp.get("v.parent");
      var errori = this.validateUserInput(cmp, event, helper);
      if (errori == "") {
        parent.methodShowWaitComponent();
        var action = cmp.get("c.saveData");
  
        action.setParam("theCase", cmp.get("v.theCase"));
        action.setParam("dataCase", cmp.get("v.dataCase"));

        // Imposto la Callback
        action.setCallback(this, function(response, helper) {
          if (response.getState() === "SUCCESS") {
            this.fireToast(
              "Postvendita",
              "Data richiesta conteggio aggiornata correttamente",
              "success",
              60000
            );
          } else if (response.getState() === "ERROR") {
            parent.showToast(response, "", "");
          }
          parent.methodHideWaitComponent();
        });
        $A.enqueueAction(action);
      } else {
        parent.set("v.messaggiErrore", errori);
      }
    }
  },

  fireToast: function(header, message, type, duration) {
    var toastEvent = $A.get("e.force:showToast");
    toastEvent.setParams({
      title: header,
      message: message,
      duration: duration,
      type: type,
      mode: "dismissible"
    });
    toastEvent.fire();
  }
});