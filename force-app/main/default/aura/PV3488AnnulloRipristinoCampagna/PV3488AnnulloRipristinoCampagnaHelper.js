({
  

    /*
    onPraticaSelected: function (cmp,event, helper) {

        var numeroPratica=cmp.get('v.PVForm.pratica.numPratica');
        console.log("PRATICA SEL: "+numeroPratica);
        console.log(cmp.getElements())
        if(numeroPratica!= null){
           
            console.log(cmp.get('v.PVForm.note'))
            cmp.set('v.PVForm.note',numeroPratica)
            console.log(cmp.get('v.PVForm.note'))
            this.getAzioniCAN(cmp)
        }
    },
*/
    getAzioniCAN: function(component) {

       // this.mostraClessidra(component);

        var numPratica = component.get("v.PVForm.pratica.numPratica");
        var message='';
        var action = component.get("c.doRecuperaAzioniCAN");
        action.setParams({
          numPratica: numPratica
        });
        
        action.setCallback(this, function(response) {
            console.log("getAzioniCAN "+ JSON.stringify(response.getReturnValue()))
            console.log("getAzioniCAN "+ response.getState())
            console.log("getAzioniCAN "+  response.getError())       
            if (response.getState() === "SUCCESS"){

              if(response.getReturnValue()["elencoAzioni"].length>0) {

                  var dataAzioni=response.getReturnValue()["elencoAzioni"]
                  /*
                  var dataAzioni = new Array();
                  for(var i=0;i<resp.length;i++){

                      dataAzioni.push({
                        Stato: resp[i].stato,
                        Blocco: resp[i].blocco,
                        Operazione: resp[i].operazione,
                        Campagna: resp[i].codCampagna,
                        DataAcquisto: resp[i].dataAcquisto,
                        Progressivo: resp[i].progressivo
                    });
                  }
                  */
                  component.set("v.azioniCAN", dataAzioni);
                  component.set("v.evoEsitoAzione",true)
              }
              //se non ci sono azioni CAN valide
              else{
                  message="Non ci sono azioni CAN valide";
                  this.mostraToast(component, '', message, 'error', '')
                  component.set("v.evoEsitoAzione",false)
              }
          }
          else {
                message="Errore durante il recupero delle azioni CAN "+response.getError()[0]['message'];
                this.mostraToast(component, '', message, 'error', '');
                component.set("v.evoEsitoAzione",false)
          }

         // this.nascondiClessidra(component);

        });
        $A.enqueueAction(action);
      },

      //metodo richiamato dal componente base prima dell'inserimento del case
      validateUserInput: function(component) {

        this.mostraClessidra(component);

        console.log('[PV3488AnnulloRipristinoCampagna - validateUserInput]');
        var message = this.checkPraticaSelezionata(component);

        //verifica presenza azioni can valide effettuando una nuova chiamata
        if ($A.util.isEmpty(message)) {
          
            var numPratica = component.get("v.PVForm.pratica.numPratica");
       
            var action = component.get("c.doRecuperaAzioniCAN");
            action.setParams({
              numPratica: numPratica
            });
        
            action.setCallback(this, function(response) {
                console.log("getAzioniCAN "+ response.getReturnValue())
                console.log("getAzioniCAN "+ response.getState())
                console.log("getAzioniCAN "+ response.getError())

              if (response.getState() === "SUCCESS"){

                  if(response.getReturnValue()["elencoAzioni"].length>0) {

                      var dataAzioni=response.getReturnValue()["elencoAzioni"]
                      component.set("v.azioniCAN", dataAzioni);
                      component.set("v.evoEsitoAzione",true)
                      this.conferma(component, event);

                  }
                  //se non ci sono azioni CAN valide
                  else{
                      message="Non ci sono azioni CAN valide";
                      this.mostraToast(component, '', message, 'error', '')
                      component.set("v.evoEsitoAzione",false)
                  }
              }
              else {
                    message="Errore durante il recupero delle azioni CAN "+response.getError();
                    this.mostraToast(component, '', message, 'error', '');
                    component.set("v.evoEsitoAzione",false)
              }

              this.nascondiClessidra(component);
       
            });
            $A.enqueueAction(action);

        }
        else{
          this.nascondiClessidra(component);
          this.mostraToast(component, '', message, 'error', '')
        }
      },

      inserisciCase: function (component, event) {
        console.log('[PV3488AnnulloRipristinoCampagna - inserisciCase]');
        this.validateUserInput(component, event)
      },

      completaPVForm: function (cmp, event, helper, PVForm) {
        // arricchisco il PVForm con dati specifici del PV
        PVForm.elencoAzioniCAN =cmp.get('v.azioniCAN')
        return PVForm;
       },

    
})