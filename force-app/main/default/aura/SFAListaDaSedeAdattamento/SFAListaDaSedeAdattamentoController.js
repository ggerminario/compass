({
	init : function(component, event, helper) {
		helper.doInit(component, event, helper);
	},
    getChild : function(component, event, helper) {
	},
    openModal : function(component, event, helper) {
	},
    goBack : function(component, event, helper) {
		helper.gotoList(component, event);
	},
	stampa : function(component, event, helper){
	},
	conferma : function(component, event, helper){
		component.set('v.showEsitazione',true);
	},
	reloadList : function(component, event, helper) {
	},
	goEsitaAttivita : function(component, event, helper){
	}
    
})