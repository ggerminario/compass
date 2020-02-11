({
    init:function(cmp,event,helper){
        console.log('2-B -------> INIT');
        helper.initHelper(cmp,helper);
        helper.buildSalutiValues(cmp);        
        helper.buildIndirizziValues(cmp); 
    },
    
    rebuildSalutoValues:function(cmp,event,helper){
        helper.buildSalutiValues(cmp);
    },
     
    salva:function(cmp,event,helper){
        console.log(cmp.get('v.mittentiList'));
        cmp.set('v.isOk',helper.checkIfok(cmp,helper));
        if(cmp.get('v.isOk')){
       	console.log("OK");
            if(cmp.get('v.isPrincipale')){
                 	console.log("Principale true");
                var listaMittente = cmp.get('v.mittentiList');
                for(var i=0; i <listaMittente.length; i++){
                    listaMittente[i].Principale__c = false;
                    console.log("Metto a false il MP");
                }
                cmp.set('v.mittentiList', listaMittente);
                 console.log("Aggiorno MittentiList");
            }

            if(!cmp.get('v.mittenteSelezionatoListaMitt')){
                 console.log("MittenteSelezionatoListaMitt false");
                if(cmp.get('v.indirizzoPredefinitoMittente')){
                    helper.salvaIndPred(cmp);
                    console.log("salvo ind pred");
                }
                else{
                    helper.salvaMittente(cmp);
                    console.log("salvoMitt");
                    
                }
            }
            else{
                console.log("salvoMod");
                
                helper.salvaModifiche(cmp);
            }
        }
        else{
            alert('Compilare i campi obbligatori prima di salvare');
        }
    },
    
    annulla:function(cmp,event,helper){
        cmp.set('v.mittenteSelezionatoListaMitt',null);
        cmp.set('v.stepInserimentoMittenti','main');
    },
    
    selectIndirizzo:function(cmp,event,helper){
        helper.selectIndirizzoHelper(cmp);
        helper.initHelper(cmp,helper);
        cmp.set('v.isOk',helper.checkIfok(cmp,helper));
    },
    
    checkValues:function(cmp,event,helper){
        console.log('2-a CHECK VALUES');
        cmp.set('v.isOk',helper.checkIfok(cmp,helper));
        console.log('CHECKVALUEEE : '+cmp.get('v.isOk'));
    },
    checkLength : function(component, event, helper) {

        var change = event.getSource().get("v.name");
        if(change==='cap'){
            var val = component.find("cap").get('v.value');
            if(val.length > 5){
                console.log('CAP SBAGLIATOOOO');
                var comp = component.find("cap");
                comp.set('v.value',val.substring(0,5));
            }
        }
    }
})