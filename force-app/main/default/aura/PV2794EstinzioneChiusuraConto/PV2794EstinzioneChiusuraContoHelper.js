/**
 * @File Name          : PV2794EstinzioneChiusuraContoHelper.js
 * @Description        : 
 * @Author             : Adriana Lattanzi
 * @Group              : 
 * @Last Modified By   : GdL Exprivia
 * @Last Modified On   : 10/2/2020, 14:55:41
 * @Modification Log   : 
 * Ver       Date            Author      		    Modification
 * 1.0    10/1/2020   Adriana Lattanzi     Initial Version
**/
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
        console.log("in callback servizio hb: " + JSON.stringify(component.get("v.rapportohb")));


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

    // Controlli esclusivi del 2794
    // Controllo che i radiobutton siano stati messi tutti a SI
    var value1 = cmp.get("v.value1");
    var value2 = cmp.get("v.value2");
    var value3 = cmp.get("v.value3");
    var value4 = cmp.get("v.value4");
    var value5 = cmp.get("v.value5");

    if (value1 != "SI" || value2 != "SI" || value3 != "SI" || value4 != "SI" || value5 != "SI") {
      messaggi += "Nell'allegato devono essere presenti tutti i dati richiesti.\n";
    }

    // Eventualmente modifico di rosso i radio non inseriti
    var radio1 = cmp.find("radio1");
    var radio2 = cmp.find("radio2");
    var radio3 = cmp.find("radio3");
    var radio4 = cmp.find("radio4");
    var radio5 = cmp.find("radio5");

    radio1.showHelpMessageIfInvalid();
    radio2.showHelpMessageIfInvalid();
    radio3.showHelpMessageIfInvalid();
    radio4.showHelpMessageIfInvalid();
    radio5.showHelpMessageIfInvalid();


    // Obbligatorietà campo note
    var note = cmp.get("v.PVForm.note");
    if ($A.util.isUndefinedOrNull(note) || note.trim() == "") {
      messaggi += 'Inserire delle note\n';
    }

    return messaggi;
  },

  completaPVForm: function(cmp, event, helper, PVForm) {
    // arricchisco il PVForm con dati specifici del PV
    
 

    return PVForm;
  },
});