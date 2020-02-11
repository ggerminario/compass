({
    validateUserInput: function(cmp, event, helper) {
        var messaggi = "";
        messaggi += this.checkPraticaSelezionata(cmp);
        messaggi += this.checkNoteInseriteSeFiliale(cmp);
        //messaggi += this.checkAllegati(cmp);
		return messaggi;
    },

    
    checkNoteInseriteSeFiliale : function(cmp){
        var messaggi = "";

        var userBranchOffice = cmp.get("v.PVForm.userData.user.Branch_Or_Office__c");
        
        if(userBranchOffice == 'FIL'){
            var note = cmp.get('v.PVForm.note');
            if ($A.util.isUndefinedOrNull(note) ||  note == ''){
                messaggi += "Prima di procedere inserire delle note\n";
            }
        }
        return messaggi;
    },


    completaPVForm: function(cmp, event, helper, PVForm) {
        // arricchisco il PVForm con dati specifici del PV
        return PVForm;
    }
})