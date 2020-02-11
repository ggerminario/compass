({
	doInit : function(component, event, helper) {
		helper.doInit(component, event);
		var x = component.get('v.isCloned');
		
	},
    
    reset : function(component, event, helper) {
		var x = component.find("xcsAllegati");
        if(x!=undefined) x.resetMethod();
        	console.log("Reset Figlio Lettera");
		
	}
    
    
})