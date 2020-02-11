({
	init: function(component, event, helper) {
		helper.setHeaderColumns(component,event, helper);
		helper.getAllNote(component,event,helper);
		helper.setfileList(component,event,helper);
	},

	openInternalModal : function(component, event, helper) {
		component.set('v.showInternalModal',true);
	},

	insertNewNote : function(component, event, helper) {
		helper.insertNewNote(component, event, helper);
	},

	goBack : function(component, event, helper) {
		component.set('v.showInternalModal',false);
	},
    
    downloadFile : function(component, event, helper) {
        var dato =  event.target.id;
		var link = dato.split('=')[1];
        window.open(link);
	},
    
})