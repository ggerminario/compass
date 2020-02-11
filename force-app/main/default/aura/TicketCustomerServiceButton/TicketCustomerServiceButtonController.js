({
	creaTicketCS : function(component, event, helper) {
		/*var actionAPI = component.find("quickActionAPI");
	    
			var fields = {relatedTo : {Id: "5005E000005qwJTQAY"}};
			var args = {actionName: "Case.New_TicketingCS", entityName: "Case", targetFields: fields};
			actionAPI.setActionFieldValues(args).then(function(result) {
				actionAPI.invokeAction(args);
				console.log('closeHelpTicket action called');
				//Action selected; show data and set field values
			}).catch(function(e) {
				if(e.errors) {
					console.log(e.errors);
				}
			});
			
			
			
			
			
			*/

			var actionAPI = component.find("quickActionAPI");
        var args = {actionName: "Case.New_TicketingCS"};
        actionAPI.selectAction(args).then(function(result){
			console.log('xxxx');
            //Action selected; show data and set field values
        }).catch(function(e){
            if(e.errors){
                //If the specified action isn't found on the page, show an error message in the my component
            }
        });
		}
		
		

	
	/*var fields = {Id : {value: component.get("v.recordId")} };
        var args = { actionName : "Account.New_TicketingCS", 
                     entityName : "Account",
                     targetFields : fields };
        actionAPI.setActionFieldValues(args).then(function() {
            actionAPI.invokeAction(args);
        }).catch(function(e) {
            console.error(e.errors);
        });
	}*/
	
})