({
	doInit : function(component,event,helper) {
		var ctiQueue = component.get('v.caseRecord.CTI_Queue__c');
		//nel caso in cui si passasse in input al componente semplicemente la coda
		if(component.get('v.queue')!='')
			ctiQueue = component.get('v.queue');
		//se non è stata passata la coda dal CTI
		if(ctiQueue == null || ctiQueue == '') {
			component.set('v.showComponent',true);
			this.decreaseCounter(component,event,helper);
			return;
		} 
		ctiQueue = ctiQueue.replace(/-/g,'_');
		ctiQueue = ctiQueue.split('.').join('_');
		ctiQueue = ctiQueue.toUpperCase();
		var method = component.get('c.getSelectedDisposition');
		method.setParams({
			queue : component.get('v.prefix') + ctiQueue
		});
		method.setCallback(this,function(response){
			var state = response.getState();
			if(state === 'SUCCESS'){
				var result = response.getReturnValue();
				/*component.set('v.disposition1Preselection','DP3766');
				component.set('v.disposition2Preselection','DP3770');*/
				this.setPreselection(component,result);
				component.set('v.showComponent',true);
				this.decreaseCounter(component,event,helper);
			}else{
				//errore
				this.showToast('Errore Generico Disposition','error');
			}
		});
		$A.enqueueAction(method);
		
	},
	incrementCounter: function(component,event,helper){
		var spinner = component.find('spinnerComponent');
		spinner.incrementCounter();
	},
	decreaseCounter: function(component,event,helper){
		var spinner = component.find('spinnerComponent');
		spinner.decreaseCounter();
	},
	showToast : function(message,type) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "message": message,
            "type" : type
        });
        toastEvent.fire();
	},
	setPreselection : function(component,map){
		if(map['rootExternalId'] != '')
			component.set('v.rootExternalId',map['rootExternalId']);
		component.set('v.disposition1Preselection',map['disposition1Preselection']);
		component.set('v.disposition2Preselection',map['disposition2Preselection']);
		component.set('v.disposition3Preselection',map['disposition3Preselection']);
		component.set('v.disposition4Preselection',map['disposition4Preselection']);
		component.set('v.disposition5Preselection',map['disposition5Preselection']);
		component.set('v.disposition6Preselection',map['disposition6Preselection']);
	}
})