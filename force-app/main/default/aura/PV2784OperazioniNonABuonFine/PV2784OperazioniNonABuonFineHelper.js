/**
 * @File Name          : PV2784OperazioniNonABuonFineHelper.js
 * @Description        : 
 * @Author             : Federica Forte
 * @Group              : 
 * @Last Modified By   : Federica Forte
 * @Last Modified On   : 24/1/2020, 14:57:37
 * @Modification Log   : 
 * Ver       Date            Author      		    Modification
 * 1.0    21/1/2020   Federica Forte     Initial Version
**/
({
    onPraticaSelected: function (cmp) {
        console.log("[PV2784OperazioneNonABuonFine - onPraticaSelected]");
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
        return messaggi;
    },

    completaPVForm: function (cmp, event, helper, PVForm) {
        console.log("[PV2784OperazioneNonABuonFine - completaPVForm]");
        PVForm.data = cmp.get("v.selectedData");
        PVForm.importo = cmp.get("v.selectedImp");
        
        console.log("completaPVForm: " + JSON.stringify(cmp.get("v.PVForm")));
        return PVForm;
    }
});