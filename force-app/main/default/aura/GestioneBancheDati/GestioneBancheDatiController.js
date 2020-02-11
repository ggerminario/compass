/**
 * @File Name          : GestioneBancheDatiController.js
 * @Description        : 
 * @Author             : Maurizio Longo
 * @Group              : 
 * @Last Modified By   : Maurizio Longo
 * @Last Modified On   : 6/2/2020, 10:36:34
 * @Modification Log   : 
 * Ver       Date            Author      		    Modification
 * 1.0    23/1/2020   Maurizio Longo     Initial Version
**/
({
    doInit: function (cmp, event, helper) {
        helper.init(cmp, event, helper);
    },

    //metodo richiamato dal bottone conferma del contenitore PVInserimento
    save: function (cmp, event, helper) {
        helper.save(cmp, event, helper);
    },

    associaEmailBancheDati: function (cmp, event, helper) {
        helper.associaEmailBancheDati(cmp, event, helper);
    },

    confermaMittente: function (cmp, event, helper){
        helper.confermaMittente(cmp, event, helper);
    },
    selezionaMittente: function (cmp, event, helper){
        helper.selezionaMittente(cmp, event, helper);
    },
    altraPratica: function (cmp, event){
        console.log('altra pratica da gestire');
        cmp.set("v.selezione", "altraPratica");
    }
/*
    handleChange: function (cmp, event) {
        var changeValue = event.getParam("value");
       if(changeValue=="gestisci"){

        //helper.controlliPreliminari(cmp,event,helper);
        cmp.set("v.selezione", "not found");
       }
       else {

        cmp.set(value,"reclami");
       }
    },*/

    
});