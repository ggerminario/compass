({
	searchParent : function(component, event, helper) {
		var method = component.get('c.getParentEvent');
		method.setParams({
			'attendeeId' : component.get('v.recordId')
		});

		method.setCallback(this,function(response){
			var state = response.getState();
			if(state =='SUCCESS'){
				if(response.getReturnValue()==null){
					//per parent non trovato

				}else {
					var navEvt = $A.get("e.force:navigateToSObject");
					navEvt.setParams({
					"recordId": response.getReturnValue(),
					"slideDevName": "detail"
					});
					navEvt.fire();
				}
				
			}else{
				this.showToast('Errore Generico','error','Contattare l\'amministratore del sistema o riprovare più tardi.');
			}
		});

		$A.enqueueAction(method);

	},

	showToast : function(title,type,message){
		var toastEvent = $A.get("e.force:showToast");
		toastEvent.setParams({
				"title":title,
				"message":message,
				"type":type
			}
		);
		toastEvent.fire();

	}
})