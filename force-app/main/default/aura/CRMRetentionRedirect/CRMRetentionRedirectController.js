({
    redirectCarte : function(cmp, event, helper) {
        var navService = cmp.find("navService");   
        var spinner = cmp.find('spinnerComponent');
        spinner.incrementCounter();
        var action = cmp.get('c.initCarte');
        action.setParams({
            'accountid' : cmp.get('v.recordId') 
        });
        action.setCallback(this, function(response)
                           {
                               spinner.decreaseCounter();
                               if(response.getState() == 'SUCCESS' ) 
                               {
                                   var pageReference = response.getReturnValue();
                                   navService.navigate(pageReference);
                               }
                           });
        $A.enqueueAction(action);
    },
    redirectPrestiti : function(cmp, event , helper){
         var spinner = cmp.find('spinnerComponent');
        spinner.incrementCounter();
        var action = cmp.get('c.initPrestiti');
        action.setParams({
            'accountid' : cmp.get('v.recordId') 
        });
        action.setCallback(this, function(response)
                           {
                               spinner.decreaseCounter();
                               if(response.getState() == 'SUCCESS' ) 
                               {
                                   var params = response.getReturnValue();
                                   console.log('**********hola' + JSON.stringify(params));
                                   var evt = $A.get("e.force:navigateToComponent");
                                   evt.setParams(params);
                                   evt.fire();
                               }
                           });
        $A.enqueueAction(action);
    }
})