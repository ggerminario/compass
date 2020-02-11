({
	init : function(component, event, helper) {
		console.log('on init');
		helper.searchParent(component, event, helper);
	}
})