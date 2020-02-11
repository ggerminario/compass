({
	helperInit : function(cmp, event, helper) {
        var navService = cmp.find("navService");   
        var action = cmp.get('c.redirectToCase');
        action.setParams({
            'accountId' : cmp.get('v.recordId') 
        });
        action.setCallback(this, function(response)
                           {
                               if(response.getState() == 'SUCCESS' ) 
                               {
                                   var res = response.getReturnValue();
                                   console.log("*** res :: " + JSON.stringify(res));
                                   if (res && res.attributes) {
                                       if (res.attributes.isOK) {
                                           console.log('*** caso if');
                                           var pageReference = response.getReturnValue();
                                           navService.navigate(pageReference);
                                       }
                                       else {
                                           console.log('*** caso else');
                                           cmp.set('v.messaggio',res.attributes.errorMessage); 
                                           cmp.set('v.controllo', 'true');
                                       }
                                   }
                               }

                           });
        $A.enqueueAction(action);
    }
})