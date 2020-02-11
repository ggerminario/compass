({
	init:function(cmp, event, helper){
        helper.init(cmp,helper);
	},
    
    richiediAutorizzazione : function(cmp, event, helper){
        helper.richiediAutorizzazioneHelper(cmp);
    },
    
    handleClick : function(cmp,event,helper){
        var label=event.getSource().get('v.label');
        //helper.autorizzaRespingi(cmp,label);
        cmp.set('v.saveClick',label);
        
        var cmpEvent = cmp.getEvent("salvaLetteraRispostaEvent");
        cmpEvent.fire();
        
    },
    
    autorizzoMethod : function(cmp, event, helper){
     
        var label = cmp.get("v.saveClick");
           console.log('Autorizzo '+label);
        helper.autorizzaRespingi(cmp,label);
        
    }
    
})