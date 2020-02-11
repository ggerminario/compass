({
	init : function(component, event, helper) {
        var evt = $A.get("e.force:navigateToComponent");
        evt.setParams({
            componentDef : "c:CRMRetentionPrestitiPrework",
            /*componentAttributes: {
                'pvRequest' : pvRequest
			}*/
			componentAttributes : {
                'idCliente' : component.get('v.recordId')
            }
        });
		evt.fire();

        
	}
})