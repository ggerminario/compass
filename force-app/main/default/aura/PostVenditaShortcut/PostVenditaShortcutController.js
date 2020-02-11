({

	clickNewPostVendita : function(cmp, event, helper) {
		helper.clickNewPostVendita(cmp, event, helper);
	},

	clickPostVendita : function(cmp, event, helper) {
		helper.clickPostVendita(cmp, event, helper);
	},

	checkModify : function(cmp, event, helper) {
		helper.checkModify(cmp, event, helper);
	},

	closeModal: function(cmp, event, helper){ 
        helper.closeModal(cmp, event, helper);
	},
	retention: function(cmp, event, helper){
		helper.doRetention(cmp, event, helper, 'Retention_Consolidamento_Richiesto');
	},
	retentionCarte: function(cmp, event, helper){
		helper.doRetention(cmp, event, helper, 'Retention_Carte');
	}

})