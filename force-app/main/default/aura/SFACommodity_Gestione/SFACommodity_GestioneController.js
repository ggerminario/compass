({
	init : function(component, event, helper) {
		
//		helper.doInit(component, nPratica);
		var idr = component.get('v.recordId');
		helper.doUser(component);
//		helper.doInit(component, idr);
		console.log('idr -> '+idr);
		console.log('Activity_Id__c -> '+ component.get('v.selectedActivity[0].Activity_Id__c'));
//		helper.handleGetFile(component, event, component.get('v.selectedActivity[0].Activity_Id__c'));
		helper.handleGetFile(component, event, idr);
//		component.set('v.tipoPAPF',true);
        
	},
	handleQ1 : function(component, event, helper) {
		//		alert('q1' + component.get('v.question1Value'))	;
	},
	handleQ2 : function(component, event, helper) {
	},
	handleQ3	 : function(component, event, helper) {
	},
	handleSospendi	 : function(component, event, helper) {
		console.log('-----------------------------------------------------');
		console.log('-- SFACommodity_GestioneController Method : handleSospendi');
		helper.handleSospendi(component, event);
	
	},
	handleCompleta	 : function(component, event, helper) {
		console.log('-----------------------------------------------------');
		console.log('-- SFACommodity_GestioneController Method : handleCompleta');
		helper.handleCompleta(component, event);
	
	},
	handleUploadFinished : function(component, event, helper) {
        var uploadedFiles = event.getParam("files");
//        alert("Files uploaded : " + uploadedFiles.length);
        helper.handleUploadFinished(component, event);
	},
	downloadfile: function (component, event, helper){                 
		helper.handleDownloadFile(component, event);
	},
	cancellafile: function (component, event, helper){                 
		helper.handleCancellaFile(component, event);
        var sCaseId = component.get('v.selectedActivity[0].Activity_id__c');
        helper.handleGetFile(component, event, sCaseId);
	},
	handleChange: function (component, event) {
			// This will contain the string of the "value" attribute of the selected option
			var selectedOptionValue = event.getParam("value");
//			alert("Option selected with value: '" + selectedOptionValue + "'");
//			component.set('v.opzioneChiusura',selectedOptionValue);
	},
	handleChangeEsito: function (cmp, event) {
        var selectedOptionValue = event.getParam("value");
//        alert("Option selected with value: '" + selectedOptionValue + "'");
	},
	handleChangeCombo: function (component, event) {
		component.set('v.opzioneChiusura', event.getParam("value"));
	},
	handleChiudi	 : function(component, event, helper) {
		console.log('-----------------------------------------------------');
		console.log('-- SFACommodity_GestioneController Method : handleCompleta');
		helper.gotoList(component, event);

	},
	activeButton	 : function(component, event, helper) {
		console.log('-----------------------------------------------------');
		console.log('-- SFACommodity_GestioneController Method : activeButton');
		let inputText = component.get("v.descAll");
//		alert(inputText);
        if(inputText != null){
            component.set('v.isButtonActive',false);
        }       
	}
		
})