({
    isValid: function(component) {
        var PVForm = component.get("v.PVForm");
        return !$A.util.isEmpty(PVForm)
            && !$A.util.isEmpty(PVForm.sottotipologiaMdt)
            && !$A.util.isEmpty(PVForm.sottotipologiaMdt.uniqueId__c)
            && !$A.util.isEmpty(PVForm.cliente)
            && !$A.util.isEmpty(PVForm.cliente.codCliente)
            && !$A.util.isEmpty(PVForm.pratica)
            && !$A.util.isEmpty(PVForm.pratica.numPratica)
            && PVForm.cliente.codCliente === PVForm.pratica.codCliente;
    },
    
    inserisciCase: function (component, event) {
        console.log('[PV1759SbloccoCartaVIZD - inserisciCase]');
        var errorMessage = this.replaceNtoBR(this.validateUserInput(component, event));

        if ($A.util.isEmpty(errorMessage)) {
            this.conferma(component, event);
        }
        else {
            this.mostraErrori(component,errorMessage);
        }
    },
    validateUserInput: function(component) {
        console.log('[PV1759SbloccoCartaVIZD - validateUserInput]');
        var message = this.checkClienteSelezionato(component);

        if($A.util.isEmpty(message)) {
            message = this.checkPraticaSelezionata(component);
        }

        return $A.util.isEmpty(message) ? "" : message;
    },

    clearErrors: function (component) {
        this.mostraErrori(component, "");
        this.showMarkup(component, true);
    },

    completaPVForm: function (component, event, helper, PVForm) {
        console.log('[PV1759SbloccoCartaVIZD - completaPVForm] PVForm:', PVForm);
        

        return PVForm;
    },

    onPraticaSelected: function (component) {
        console.log('[PV1759SbloccoCartaVIZD - onPraticaSelected]');
        this.clearErrors(component);
       
        this.setDatiFinanziariCarta(component);
    },
    
    setDatiFinanziariCarta: function(component) {
            
        if (this.isValid(component)) {
          
          this.mostraClessidra(component);
    
          var action = component.get("c.getDatiFinanziariCarta");
          var numeroCarta = component.get("v.PVForm.pratica.numPratica");
    
          action.setParams({
            numeroCarta: numeroCarta
          });
    
          action.setCallback(this, function(response) {
            if (component.isValid() && response.getState() === "SUCCESS" && response.getReturnValue()) {
              var detail = response.getReturnValue();
              component.set("v.cartaDatiFinanziariData", detail);
              this.showCartaDatiFinanziari(component, true);
            }
            

            else {
                this.handleErrors(component, response);
            }

            this.nascondiClessidra(component);
          });
    
          $A.enqueueAction(action);
        } 
      }
      
})