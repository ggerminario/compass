/**
 * @File Name          : PV3824CpayCredenzialiGestioneController.js
 * @Description        : 
 * @Author             : Raffaele Prudenzano
 * @Group              : 
 * @Last Modified By   : Raffaele Prudenzano
 * @Last Modified On   : 8/1/2020, 11:53:07
 * @Modification Log   : 
 * Ver       Date            Author      		    Modification
 * 1.0    8/1/2020   Raffaele Prudenzano     Initial Version
**/
({
    doInit : function(cmp, event, helper) {
        helper.doInitHelper(cmp, event, helper);
    },

    //metodo richiamato dal bottone conferma del contenitore PVGestione
    save : function (cmp, event, helper) {
        helper.save(cmp, event, helper);
    }, 
})