({
    init:function(cmp, event, helper){
        var x = cmp.get('v.clienteSelezionato');
		console.log('CLIENTE SELEZIONATO');
        console.log(JSON.stringify(x));
        if(cmp.get('v.clienteSelezionato')['dataNascita'] &&
           cmp.get('v.clienteSelezionato')['dataNascita']!='null'){
            var dn = cmp.get('v.clienteSelezionato')['dataNascita']+'';
            if(dn.includes('-')){
               var anno = dn.substring(0,4);
           		var mese = dn.substring(5,7);
           		var gg = dn.substring(8,10); 
               
            }
            else{
                var anno = dn.substring(0,4);
           		var mese = dn.substring(4,6);
           		var gg = dn.substring(6,8);
                
            }
           
            cmp.set('v.dataNascita',gg+'/'+mese+'/'+anno);
            
        }
        else  cmp.set('v.dataNascita', '');
       
    }
})