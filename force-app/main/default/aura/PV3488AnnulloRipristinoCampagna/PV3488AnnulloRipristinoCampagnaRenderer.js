({

// Your renderer method overrides go here
//All'onFocus della finestra viene associata una funzione.
//Il metodo richiamerà getAzioniCAN ogni volta che si accede alla pagina
// e solo se l'utente ha cliccato sul link del sistema esterno
afterRender: function (component, helper) {
    this.superAfterRender();
    // interact with the DOM here
    console.log('afterRender')

    window.onfocus=function(){ 

        var clickLinkEvo=component.get('v.clickLinkEvo');
        console.log('hi init '+clickLinkEvo)

        var message = helper.checkPraticaSelezionata(component);
        
        //verifica presenza azioni can valide effettuando una nuova chiamata
        if ($A.util.isEmpty(message) && clickLinkEvo){

            helper.getAzioniCAN(component)

            //reset del click sul pulsante
            component.set('v.clickLinkEvo', false)
        }
    }
},

unrender: function(){
    window.onfocus=function(){}
}

})