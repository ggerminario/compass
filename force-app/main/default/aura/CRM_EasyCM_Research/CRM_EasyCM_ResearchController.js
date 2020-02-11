({
	searchAction : function(component, event, helper) {
		helper.searchAction(component, event, helper);
		helper.showMessage(component);
	},
	externalCallAction: function(component, event, helper) {
		helper.externalCallAction(component, event, helper);
		helper.showMessage(component);
	},

	selectCliente:function(cmp,event,helper){
        var selRow=event.getParam('selectedRows')[0];
		cmp.set('v.accountSelezionato', selRow);
		cmp.set('v.idAccSelezionato', selRow);
		helper.updateCase(cmp,event,helper,selRow);
	}
})