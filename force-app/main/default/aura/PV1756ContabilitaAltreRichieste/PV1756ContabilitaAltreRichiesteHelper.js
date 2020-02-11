/**
 * @File Name          : PV1756ContabilitaAltreRichiesteHelper.js
 * @Description        :
 * @Author             : Federica Forte
 * @Group              :
 * @Last Modified By   : Raffaele Prudenzano
 * @Last Modified On   : 23/1/2020, 12:08:30
 * @Modification Log   :
 * Ver       Date            Author      		    Modification
 * 1.0    17/12/2019   Federica Forte     Initial Version
 **/
({
  onPraticaSelected: function(cmp) {
    console.log("[PV1756ContabilitaAltreRichieste - onPraticaSelected]");
  },

  validateUserInput: function(cmp, event, helper) {
    console.log(JSON.stringify(cmp.get("v.PVForm")));

    var messaggi = "";
    // Controllo che il cliente sia selezionato
    messaggi += this.checkClienteSelezionato(cmp);

    // Controllo che la pratica sia selezionata
    messaggi += this.checkPraticaSelezionata(cmp);

    // Controllo che le note siano state scritte
    var note = cmp.get("v.PVForm.note");
    if ($A.util.isUndefinedOrNull(note) || note.trim() == "") {
      messaggi += cmp.get("v.noteObbligatorieStr") + "<br>";
    }

    return messaggi;
  },

  completaPVForm: function(cmp, event, helper, PVForm) {
    console.log("[PV1756ContabilitaAltreRichieste - completaPVForm]");
    PVForm.importo = cmp.get("v.importoSel");
    return PVForm;
  }
});