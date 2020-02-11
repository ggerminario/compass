({
	clickNewPostVendita: function(cmp, event, helper) {
		cmp.set("v.checkPop","false");
		if(cmp.get("v.datiCliente.codCliente"))
		{
			cmp.set("v.wrapperButton",undefined);
			helper.invokePV(cmp,event,helper);
			
		}
		else{
			helper.showToast('Impossibile avviare post vendità poichè l\'anagrafica non ha il cip','error')
		}
	},
	
	
	clickPostVendita: function(cmp, event, helper) {
		cmp.set("v.checkPop","false");
		if(cmp.get("v.datiCliente.codCliente"))
		{
			var labelClicked = event.getSource().get("v.label");
			var wrapperButton = cmp.get("v.buttonWrapperList").find(x => {
				return x.buttonLabel === labelClicked;
			})
			cmp.set("v.wrapperButton",wrapperButton);
			if(wrapperButton.checkIncomingCall){
				helper.checkIncomingCall(cmp,event,helper);
			}else{
				helper.invokePV(cmp,event,helper);
			}
		}
		else{
			helper.showToast('Impossibile avviare post vendità poichè l\'anagrafica non ha il cip','error')
		}
	},

	invokePV : function(cmp, event, helper) {
		// to-do da invocare il processo di post vendita passandogli pv category ed il cliente in sessione
		var wrapperButton = cmp.get("v.wrapperButton");
		var account = cmp.get("v.account");
        /*var pvRequest = { 	 'parentCaseId' : cmp.get("v.recordId"),
                             'OCSId' : account.OCS_External_Id__c,
                             'pvCategory': wrapperButton ? wrapperButton.pvCategory : null
                            };*/
		var evt = $A.get("e.force:navigateToComponent");
        evt.setParams({
            componentDef : "c:PVInserimento",
            /*componentAttributes: {
                'pvRequest' : pvRequest
			}*/
			componentAttributes : {
                parametriEsterni : { 
					"codClienteOCS" : account.OCS_External_Id__c ? account.OCS_External_Id__c.replace('C','') : '',
					"codCategoria"  : wrapperButton ? wrapperButton.pvCategory : null,
                    //"codPraticaOCS" : mappa.codPraticaOCS,
                    "parentId" : cmp.get("v.recordId")
                }
            }
        });
        evt.fire();
	},

	closeModal: function(cmp, event, helper){ 
        cmp.find("theStaticModal").closeModal();
    },

	checkModify : function(cmp, event, helper) {
		if(cmp.get("v.checkPop") === "true"){
			helper.invokePV(cmp, event, helper);
			cmp.set("v.checkPop","false");
			cmp.find("theStaticModal").closeModal();

		}else{
			cmp.set("v.checkPop","true");
			cmp.find("theStaticModal").closeModal();
			cmp.find("theStaticModal").openModal();
		}
	},

	checkIncomingCall : function(cmp, event, helper) {			
		var incomingPhone = cmp.get("v.numTelefono");
		var account = cmp.get("v.account");
		if(incomingPhone &&(incomingPhone === account.Telefono_Casa__c || incomingPhone === account.Telefono_Cellulare__c || incomingPhone === account.Phone)){
			helper.invokePV(cmp,event,helper);
		}else{
			cmp.find("theStaticModal").openModal();
		}
	},

	showToast : function(message,type) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "message": message,
			"type" : type,
			"mode": "sticky"
        });
        toastEvent.fire();
	},   
	doRetention: function(cmp, event, helper, tipoRetention){
		var spinner = cmp.find('spinnerComponent');
        spinner.incrementCounter();
		var navService = cmp.find("navService"); 
		var method = cmp.get('c.doRetention');
		method.setParams({
			'account' 		: cmp.get('v.account'),
			'tipoRetention' : tipoRetention
		});

		method.setCallback(this,function(response){
			var state = response.getState();
			if(state === 'SUCCESS'){
				var res = response.getReturnValue();
				if(tipoRetention=='Retention_Carte'){
					var pageReference = response.getReturnValue();
                    navService.navigate(pageReference);
				} else{
					var evt = $A.get("e.force:navigateToComponent");
					evt.setParams(res);
					evt.fire();
				}
				/*if (res && res.attributes) {
                    if (res.attributes.isOK) {
                        console.log('*** caso if');
                        var pageReference = response.getReturnValue();
                        navService.navigate(pageReference);
                    }
                    else {
						console.log('*** caso else');
						this.showToast(res.attributes.errorMessage,'error');          
                    }
				}*/
				
			} else{
				console.log(tipoRetention);
				console.log(response);
				this.showToast('Errore Generico Retention','error');
			}
			spinner.decreaseCounter(); 
		});

		$A.enqueueAction(method);
	}
})