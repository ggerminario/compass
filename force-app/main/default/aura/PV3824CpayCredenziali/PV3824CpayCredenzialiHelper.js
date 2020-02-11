/**
 * @File Name          : PV3824CpayCredenzialiHelper.js
 * @Description        :
 * @Author             : Raffaele Prudenzano
 * @Group              :
 * @Last Modified By   : Raffaele Prudenzano
 * @Last Modified On   : 18/12/2019, 11:40:40
 * @Modification Log   :
 * Ver       Date            Author      		    Modification
 * 1.0    17/12/2019   Raffaele Prudenzano     Initial Version
 **/
({
  validateUserInput: function(cmp, event, helper) {
    var messaggi = "";
    if ($A.util.isUndefinedOrNull(cmp.get("v.PVForm.cliente"))) {
      messaggi += "Selezionare un cliente\n";
    }

    return messaggi;
  },

  completaPVForm: function(cmp, event, helper, PVForm) {
    // arricchisco il PVForm con dati specifici del PV
    return PVForm;
  }
});