/**
 * @File Name          : PV3707EstinzioneAnticipataController.js
 * @Description        : 
 * @Author             : Federico Negro
 * @Group              : 
 * @Last Modified By   : Federico Negro
 * @Last Modified On   : 15/11/2019, 17:40:14
 * @Modification Log   : 
 * Ver       Date            Author      		    Modification
 * 1.0    14/11/2019   Federico Negro     Initial Version
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