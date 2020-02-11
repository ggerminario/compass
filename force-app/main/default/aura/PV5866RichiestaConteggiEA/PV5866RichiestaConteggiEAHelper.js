/**
 * @File Name          : PV5866RichiestaConteggiEAHelper.js
 * @Description        :
 * @Author             : Federica Forte
 * @Group              :
 * @Last Modified By   : Federica Forte
 * @Last Modified On   : 16/1/2020, 17:46:40
 * @Modification Log   :
 * Ver       Date            Author      		    Modification
 * 1.0    23/12/2019   Federica Forte     Initial Version
 **/
({
  onPraticaSelected: function (cmp) {
    console.log("[PV5866RichiestaConteggiEA - onPraticaSelected]");
  },

  validateUserInput: function (cmp, event, helper) {
    console.log(JSON.stringify(cmp.get("v.PVForm")));

    var messaggi = "";
    messaggi += this.checkClienteSelezionato(cmp);

    // Controllo che la pratica sia selezionata
    var praticaSelezionata = cmp.get("v.PVForm.pratica");
    if ($A.util.isUndefinedOrNull(praticaSelezionata)) {
      messaggi += "Selezionare una pratica.\n";
    }
    // Controllo che la data sia selezionata
    if (cmp.get("v.selectedData") == undefined) {
      messaggi += "Vi preghiamo di indicare la data in cui il cliente ha avanzato richiesta di e/a.\n";
    }
    // Controllo che la modalità sia selezionata
    if (JSON.stringify(cmp.get("v.selectedMod")) == "[]") {
      messaggi += "Selezionare la modalità di ricezione del conteggio da parte del cliente.\n";
    }
    // Controllo che la data non sia futura
    var today = new Date();
    today.setHours(0, 0, 0, 0);
    var selectedData = new Date(cmp.get("v.selectedData"));
    selectedData.setHours(0, 0, 0, 0);
    if (selectedData.getTime() > today.getTime()) {
      messaggi += "La Data ricezione richiesta conteggio può essere inferiore o uguale ad oggi.";
    }
    console.log("selectedData: " + cmp.get("v.selectedData"));
    return messaggi;
  },

  completaPVForm: function (cmp, event, helper, PVForm) {
    console.log("[PV5866RichiestaConteggiEA - completaPVForm]");
    PVForm.dataRicCont = cmp.get("v.selectedData");
    PVForm.modRicCont = cmp.get("v.selectedMod");
    PVForm.offProm = cmp.get("v.selectedOfferte");
    if (PVForm.userData.user.Branch_Or_Office__c == "FIL") {
      PVForm.notificaFil = cmp.get("v.selectedNotifica");
    }
    console.log("completaPVForm: " + JSON.stringify(cmp.get("v.PVForm")));
    return PVForm;
  }
});