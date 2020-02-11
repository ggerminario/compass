({
    validateUserInput: function(cmp, event, helper) {
        var messaggi = "";
        messaggi += this.checkPraticaSelezionata(cmp);
		return messaggi;
    },
    completaPVForm: function(cmp, event, helper, PVForm) {
        // arricchisco il PVForm con dati specifici del PV
        PVForm.importo = cmp.get("v.importo");
        PVForm.dataOperazione = cmp.get("v.dataOperazione");
        return PVForm;
    }
})