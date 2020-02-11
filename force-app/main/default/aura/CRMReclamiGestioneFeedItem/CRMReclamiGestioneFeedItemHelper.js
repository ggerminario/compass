({
    setOptions : function(cmp) {     
        cmp.set('v.feedColumns', [
            {label: 'Data Creazione', fieldName: 'data', type: 'Text'},   
            {label: 'Evento', fieldName: 'evento', type: 'Text'},
            {label: 'Utente', fieldName: 'utente', type: 'Text'}
        ]);               
    }
})