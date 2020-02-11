({
    validateUserInput: function(cmp, event, helper) {
        var messaggi = "";
        messaggi = this.checkClienteSelezionato(cmp);
        messaggi += this.checkPraticaSelezionata(cmp);
        messaggi += this.checkDatiAttrIncasso(cmp);
        //messaggi += this.checkAllegati(cmp);
		return messaggi;
    },
    checkDatiAttrIncasso : function(cmp){

        var messaggi = "";
        if(cmp.get("v.dataIncasso") == null){
            messaggi += 'Indicare la data d\'incasso \n';
        }else{
            var today = $A.localizationService.formatDate(new Date(), "YYYY-MM-DD");
            if(cmp.get("v.dataIncasso")>today){
                messaggi += 'La data d\'incasso non può essere futura \n';
            }
        }
        if(cmp.get("v.importoIncasso")=='' || cmp.get("v.importoIncasso")=='0'){
            messaggi = 'Inserire un importo \n';
        }
        return messaggi;
    },
    completaPVForm: function(cmp, event, helper, PVForm) {
        // arricchisco il PVForm con dati specifici del PV
        PVForm.importoIncasso = cmp.get("v.importoIncasso");
        PVForm.dataIncasso = cmp.get("v.dataIncasso");
        return PVForm;
    }
})