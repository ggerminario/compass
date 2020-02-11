({

  
     //metodo richiamato dal componente base prima dell'inserimento del case
     validateUserInput: function(component) {

        this.mostraClessidra(component);

        console.log('[PV1771CancAggBancheDati - validateUserInput]');
        return this.checkPraticaSelezionata(component);
/*
        //verifica presenza azioni can valide effettuando una nuova chiamata
        if ($A.util.isEmpty(message)) {
          
            this.conferma(component, event);
            this.nascondiClessidra(component)
        }
        else{
          this.mostraToast(cmp, '', message, 'error', '')
          this.nascondiClessidra(component)
        }
*/
      },
/*
      inserisciCase: function (component, event) {
        console.log('[PV1771CancAggBancheDati - inserisciCase]');
        this.validateUserInput(component, event)
      },
*/
      completaPVForm: function (cmp, event, helper, PVForm) {
        // arricchisco il PVForm con dati specifici del PV
        PVForm.dataEstinzione =cmp.get('v.dataEstinzione')
        return PVForm;
       },
})