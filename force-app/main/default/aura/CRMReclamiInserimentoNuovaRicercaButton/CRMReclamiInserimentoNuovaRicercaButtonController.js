({
	nuovaRicerca:function(cmp,event,helper){
        console.log('sono in inserimento nuova ricerca button');
        cmp.set('v.listaClienti',null);
        cmp.set('v.clienteSelezionato',null);
        cmp.set('v.clienteSelezionatoContainer',null);
        cmp.set('v.listaPratiche',null);
        cmp.set('v.praticaSelezionata',null);
        cmp.set('v.praticaSelezionataContainer',null);
        cmp.set('v.listaInfoPratiche',null);
        cmp.set('v.infoPraticaSelezionata',null);
		cmp.set('v.stepInserimentoCliente',1);
    }

})