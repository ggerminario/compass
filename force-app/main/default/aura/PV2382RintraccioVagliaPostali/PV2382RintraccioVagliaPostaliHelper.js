/**
 * @File Name          : PV2382RintraccioVagliaPostaliHelper.js
 * @Description        : 
 * @Author             : Federico
 * @Group              : 
 * @Last Modified By   : Federico
 * @Last Modified On   : 10/1/2020, 13:04:20
 * @Modification Log   : 
 * Ver       Date            Author      		    Modification
 * 1.0    10/1/2020   Federico     Initial Version
**/
({
    validateUserInput: function(cmp, event, helper) {
        var messaggi = "";
        messaggi = this.checkClienteSelezionato(cmp);
        messaggi += this.checkPraticaSelezionata(cmp);
        messaggi += this.checkDatiVaglia(cmp);
        messaggi += this.checkAllegati(cmp);
		return messaggi;
    },
    checkAllegati: function(cmp){
        var attList = cmp.get("v.PVForm.attachmentList");
        var messaggi = "";
        if(attList.length<1){
            messaggi += 'Inserire almeno un allegato\n';
        }
        if(attList.length>1){
            messaggi += 'Inserire esclusivamente un allegato!\n';
        }
        return messaggi;
    },
    checkDatiVaglia : function(cmp){
        var messaggi = "";
        
        if(cmp.get("v.nome")==''){
            messaggi += 'Inserire Cognome o Rag.Soc/Nome Mittente \n';
        }
        if(cmp.get("v.indirizzoMitt")==''){
            messaggi += 'Inserire Indirizzo Mittente\n';
        }
        if(cmp.get("v.CFPartitaIva")==''){
            messaggi += 'Inserire Codice Fiscale o Partita Iva\n';
        }
        if(cmp.get("v.indirizzoBen")==''){
            messaggi += 'Inserire Indirizzo Beneficiario\n';
        }
        if(cmp.get("v.comunicazMitt")==''){
            messaggi += 'Inserire Comunicazione dal Mittente\n';
        }
        if(cmp.get("v.codiceVaglia")==''){
            messaggi += 'Inserire il codice vaglia \n';
        }
        if(cmp.get("v.importo")=='' || cmp.get("v.importo")=='0'){
            messaggi += 'Inserire l\'importo \n';
        }
        if(cmp.get("v.provincia")==''){
            messaggi += 'Inserire la provincia \n';
        }
        if(cmp.get("v.ufficio")==''){
            messaggi += 'Inserire l\'ufficio \n';
        }
        if(cmp.get("v.dataValuta") == null){
            messaggi += 'Inserire la data di valuta \n';
        }
        return messaggi;
    },
    
    completaPVForm: function(cmp, event, helper, PVForm) {
        // arricchisco il PVForm con dati specifici del PV
        PVForm.importo = cmp.get("v.importo");
        PVForm.nome = cmp.get("v.nome");
        PVForm.codiceVaglia = cmp.get("v.codiceVaglia");
        PVForm.dataValuta = cmp.get("v.dataValuta");
        PVForm.provincia = cmp.get("v.provincia");
        PVForm.ufficio = cmp.get("v.ufficio");
        PVForm.indirizzoMitt  = cmp.get("v.indirizzoMitt");
        PVForm.CFPartitaIva = cmp.get("v.CFPartitaIva");
        PVForm.indirizzoBen = cmp.get("v.indirizzoBen");
        PVForm.comunicazMitt = cmp.get("v.comunicazMitt");
        return PVForm;
    },
})