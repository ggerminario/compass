/**
 * @File Name          : PV3706VariazioneScadenzaRataController.js
 * @Description        : 
 * @Author             : Federico Negro
 * @Group              : 
 * @Last Modified By   : Federico Negro
 * @Last Modified On   : 3/12/2019, 10:39:40
 * @Modification Log   : 
 * Ver       Date            Author      		    Modification
 * 1.0    3/12/2019   Federico Negro     Initial Version
**/
({
    
    verifica : function(cmp, event, helper) {
        helper.verificaEVO(cmp, event, helper);
        //cmp.set("v.disabler", true);
    },

    handleRowAction: function (cmp, event, helper) {
        helper.handleRowAction(cmp, event, helper);
    },

})