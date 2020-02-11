/**
 * @File Name          : PV5865CancellazioneAnagraficaGestioneController.js
 * @Description        : 
 * @Author             : Adriana Lattanzi
 * @Group              : 
 * @Last Modified By   : Adriana Lattanzi
 * @Last Modified On   : 21/1/2020, 09:55:12
 * @Modification Log   : 
 * Ver       Date            Author      		    Modification
 * 1.0    15/1/2020   Adriana Lattanzi     Initial Version
**/
({
    doInit: function (component, event, helper) {
        helper.init(component, event, helper);
    },

    //metodo richiamato dal bottone conferma del contenitore PVInserimento
    save: function (component, event, helper) {
        helper.save(component, event, helper);
    },

    controlloAnagrafica: function (component, event, helper) {
        helper.controlloAnagrafica(component, event, helper);
    }
})