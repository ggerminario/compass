({
  onClienteSelected: function (component) {
    console.log('[PV2790 - onClienteSelected]');
    /*----------------------------------------
      Chiamata al servizio di home Bancking
    ------------------------------------------*/
    var action = component.get("c.RapportoHB");
    action.setParam(
      "cliente" , component.get("v.PVForm.cliente.codCliente")
    )
    action.setCallback(this, function(response){
      if(response.getReturnValue()){
        component.set("v.rapportohb", response.getReturnValue());
        //console.log("in callback servizio hb: " + component.get("v.rapportohb"));


        /*--------------------------------------------------------------------
        ######################################################################
              chiamata innestata per visibilità button e creazione link
        ######################################################################
        --------------------------------------------------------------------*/

        var action2 = component.get("c.CostruisciLink");
        //console.log('Cosa arriva ad invocazione controlli: ' + component.get("v.rapportohb") + component.get("v.PVForm.userData.user.Branch_Or_Office__c") + component.get("v.PVForm.userData.user.RSS_Username__c"));
        action2.setParam(
          'rapportoHB', component.get("v.rapportohb")
        )
        action2.setCallback(this, function(response){
          if(response.getReturnValue()){
            component.set("v.viewLink", response.getReturnValue());
            console.log("address: " + component.get("v.viewLink"));
            /*----------------------------------------
                  Controllo visibilità button HB
            ------------------------------------------*/
            this.ShowButtonLink(component);
          }
        })
        $A.enqueueAction(action2);

      }
    })
    $A.enqueueAction(action);

  },

  // if true -> mostra i button HOME BANKING
  ShowButtonLink : function(component){
    console.log("in showbuttonlink");
    var action = component.get("c.ControllButton");
    action.setParams({
      'rapportoHB': component.get("v.rapportohb"),
      'office':  component.get("v.PVForm.userData.user.Branch_Or_Office__c"),
      'username': component.get("v.PVForm.userData.user.RSS_Username__c")
    })
    action.setCallback(this, function(response){
      if(response.getReturnValue()){
        component.set("v.showLink", response.getReturnValue());
        console.log("value in showlink: " + component.get("v.showLink"));
      }
    })
    $A.enqueueAction(action);
  },



  /*----------------------------------------
  ##########################################
    Reindirizzamento link home banking
  ##########################################
  ----------------------------------------*/


  gotoURLotp : function (component, event, helper) {
    var address = component.get("v.viewLink.linkOTP");
    var urlEvent = $A.get("e.force:navigateToURL");
    urlEvent.setParams({
      "url": address
    });
    urlEvent.fire();
  },


  gotoURL : function (component, event, helper) {
    var address = component.get("v.viewLink.linkNoOTP");
    var urlEvent = $A.get("e.force:navigateToURL");
    urlEvent.setParams({
      "url": address
    });
    urlEvent.fire();
  },


  /*----------------------------------------
  ##########################################
        Metodi comuni agli inserimenti
  ##########################################
  ----------------------------------------*/

  validateUserInput: function(cmp, event, helper) {
    var messaggi = "";

    // Controlli in comune tra 2790 e 2794
    // Controllo che la pratica sia selezionata e che non sia già stata chiusa
    var praticaSelezionata = cmp.get("v.PVForm.pratica");
    if ($A.util.isUndefinedOrNull(praticaSelezionata)) {
      messaggi += "Selezionare una pratica.\n";
    } else {
      if (praticaSelezionata["statoPratica"] == "70") {
        messaggi += "La pratica risulta essere già stata chiusa. Non è possibile inserirla.\n";
      }
    }

    // Controllo la validità del componente importoDataForm
    var child = cmp.find("importoDataForm");
    child.doValidityCheck();
    messaggi += cmp.get("v.erroriImportoDataForm");

    console.log("messaggi: " + messaggi);
    return messaggi;
  },

  completaPVForm: function(cmp, event, helper, PVForm) {
    // arricchisco il PVForm con dati specifici del PV
    
 

    return PVForm;
  },

  showToast: function(message, type) {
    var toastEvent = $A.get("e.force:showToast");
    toastEvent.setParams({
      message: message,
      type: type
    });
    toastEvent.fire();
  }
});