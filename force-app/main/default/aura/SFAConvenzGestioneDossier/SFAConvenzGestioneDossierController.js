({
	doInit: function (component, event, helper) {
        console.log('SFAConvenzGestioneAccolloControllerDoInitcomponent :: ' + component);
        console.log('SFAConvenzGestioneAccolloControllerDoInitevent :: ' + event);
        var obj = component.get("v.sObjectName");     
     	console.log("*** sObjectName :: " + obj);   
        
  		if (obj != 'Case'){
        	helper.initVerifyContest(component, event, helper);
        }
        else{
			helper.initPageReference(component, event);
			helper.callGetDossier(component, event);
        }
	},

	handleRowSelectionObbligatori: function (component, event, helper) {
		var selectedRows = event.getParam('selectedRows');
		var selectedDocumentIds = [];
		for (var i=0; i<selectedRows.length; i++) {
			selectedDocumentIds.push(selectedRows[i].Id);
		}

		component.set("v.lstSelectedRowsObbligatori", selectedDocumentIds);

		console.log('*** component.set("v.lstSelectedRowsObbligatori") :: ' + component.get("v.lstSelectedRowsObbligatori"));
	},

	handleRowSelectionCollegati: function (component, event, helper) {
		var selectedRows = event.getParam('selectedRows');
		var selectedDocumentIds = [];
		for (var i=0; i<selectedRows.length; i++) {
			selectedDocumentIds.push(selectedRows[i].Id);
		}

		component.set("v.lstSelectedRowsCollegati", selectedDocumentIds);

		console.log('*** component.set("v.lstSelectedRowsCollegati") :: ' + component.get("v.lstSelectedRowsCollegati"));
	},

	handleSalvaSelezioneObbligatori: function (component, event, helper) {
		var selectedDocumentIds = component.get("v.lstSelectedRowsObbligatori");
		helper.handleSalvaSelezione(component, event, selectedDocumentIds);
	},

	handleSalvaSelezioneCollegati: function (component, event, helper) {
		var selectedDocumentIds = component.get("v.lstSelectedRowsCollegati");
		helper.handleSalvaSelezione(component, event, selectedDocumentIds);
	},

	handleProcedi: function (component, event, helper) {
		helper.handleProcedi(component, event);
	},

	handleRisposta: function(component, event, helper) {
		var recId = event.getParam('row').Id;
        var lstDossierDocumentoAddizionaliMutuamenteEsclusivi = component.get("v.lstDossierDocumentoAddizionaliMutuamenteEsclusivi");
		console.log("L'id della riga è :" +  recId);
        var actionName = event.getParam('action').name;
        if ( actionName == 'Si' || actionName == 'No' ) {
			var mapIdRispostaDocumentoAddizionali = component.get("v.mapIdRispostaDocumentoAddizionali");
			mapIdRispostaDocumentoAddizionali[recId] = actionName;
			var lstDossierDocumentoAddizionali = component.get("v.lstDossierDocumentoAddizionali");
            //console.log("*** lstDossierDocumentoAddizionali.length :: " + lstDossierDocumentoAddizionali.length);
			for (var i = 0; i < lstDossierDocumentoAddizionali.length; i++) { 
				if (lstDossierDocumentoAddizionali[i].Id == recId) {
					lstDossierDocumentoAddizionali[i].RispostaDocumentiAddizionali__c = mapIdRispostaDocumentoAddizionali[recId];
				}
			}
            
            if (mapIdRispostaDocumentoAddizionali[recId] == 'Si' && lstDossierDocumentoAddizionaliMutuamenteEsclusivi && lstDossierDocumentoAddizionaliMutuamenteEsclusivi.includes(recId)) {
                for (var i = 0; i < lstDossierDocumentoAddizionali.length; i++) { 
                    if ( lstDossierDocumentoAddizionaliMutuamenteEsclusivi.includes(lstDossierDocumentoAddizionali[i].Id) && 
                       	  lstDossierDocumentoAddizionali[i].Id != recId ) {
                        mapIdRispostaDocumentoAddizionali[ lstDossierDocumentoAddizionali[i].Id ] = 'No';
                        lstDossierDocumentoAddizionali[i].RispostaDocumentiAddizionali__c = mapIdRispostaDocumentoAddizionali[ lstDossierDocumentoAddizionali[i].Id ]
                    }
                }
            }
            
            component.set("v.mapIdRispostaDocumentoAddizionali", mapIdRispostaDocumentoAddizionali);
			console.log("*** mapIdRispostaDocumentoAddizionali :: " + JSON.stringify(mapIdRispostaDocumentoAddizionali));
            
			component.set("v.lstDossierDocumentoAddizionali", lstDossierDocumentoAddizionali);
            console.log("*** lstDossierDocumentoAddizionali :: " + JSON.stringify(lstDossierDocumentoAddizionali));
		}
	},
	
	handleSalvaRisposte: function (component, event, helper) {
		helper.handleSalvaRisposte(component, event);
	},

	handleAssignToIDM: function (component, event, helper) {
		helper.callAssignToIDM(component, event);
	},

	handleProcediToListaCase: function (component, event, helper) {
		helper.goToListaCase(component, event);
	}

})