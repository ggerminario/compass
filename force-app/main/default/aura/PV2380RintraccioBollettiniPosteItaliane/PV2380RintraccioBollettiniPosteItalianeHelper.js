/**
 * @File Name          : PV2380RintraccioBollettiniPosteItalianeHelper.js
 * @Description        : 
 * @Author             : Federico
 * @Group              : 
 * @Last Modified By   : Federico
 * @Last Modified On   : 20/1/2020, 14:33:17
 * @Modification Log   : 
 * Ver       Date            Author      		    Modification
 * 1.0    2/1/2020   Federico     Initial Version
**/
({
    validateUserInput: function(cmp, event, helper) {
        var messaggi = "";
        messaggi = this.checkClienteSelezionato(cmp);
        messaggi += this.checkDatiBollettino(cmp);
        messaggi += this.checkPraticaSelezionata(cmp);
        messaggi += this.checkAllegati(cmp);
		return messaggi;
    },
    checkAllegati: function(cmp){
        var attList = cmp.get("v.PVForm.attachmentList");
        var sottotipologiaDescription = cmp.get("v.descriptionSottotipologia");
        var messaggi = "";
        if(attList.length<1){
            messaggi += 'Inserire almeno un allegato\n';
        }
        if(attList.length>1 && sottotipologiaDescription=='Ordinario'){
            messaggi += 'Inserire esculsivamente un allegato!\n';
        }
        
        return messaggi;
    },
    checkDatiBollettino : function(cmp){
        var today= new Date();
        console.log("Today:"+today +"dataValuta"+cmp.get("v.dataValuta"));
        var messaggi = "";
        if(cmp.get("v.importo")=='' || cmp.get("v.importo")=='0'){
            messaggi = 'Inserire l\'importo \n';
        }
        if(cmp.get("v.contoCorrente")==''){
            messaggi += 'Selezionare il conto corrente \n';
        }
        if(cmp.get("v.bollettino")==''){
            messaggi += 'Inserire il codice bollettino \n';
        }else{
            if(cmp.get("v.bollettino").length!=4){
                messaggi += 'Il codice bollettino deve essere di 4 caratteri \n';
            }
        }
        if(cmp.get("v.dataValuta") == null){
            messaggi += 'Inserire la data di valuta \n';
        }
        if(cmp.get("v.provincia")==''){
            messaggi += 'Inserire la provincia \n';
        }
        if(cmp.get("v.ufficio")==''){
            messaggi += 'Inserire l\'ufficio \n';
        }
        if(cmp.get("v.sportello")==''){
            messaggi += 'Inserire lo sportello \n';
        }
        return messaggi;
    },
    
    completaPVForm: function(cmp, event, helper, PVForm) {
        // arricchisco il PVForm con dati specifici del PV
        PVForm.importo = cmp.get("v.importo");
        PVForm.contoCorrente = cmp.get("v.contoCorrente");
        PVForm.bollettino = cmp.get("v.bollettino");
        PVForm.dataValuta = cmp.get("v.dataValuta");
        PVForm.provincia = cmp.get("v.provincia");
        PVForm.ufficio = cmp.get("v.ufficio");
        PVForm.sportello  = cmp.get("v.sportello");
        return PVForm;
    },


})