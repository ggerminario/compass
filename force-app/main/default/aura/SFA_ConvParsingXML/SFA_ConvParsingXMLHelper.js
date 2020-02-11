({
	helperInit : function(cmp,event,helper) {
		//var spinner = cmp.find('spinnerComponent');
        //spinner.incrementCounter();
        var action = cmp.get('c.doInit');
        action.setParams({
            'dealerId' : cmp.get('v.recordId') 
        });
        action.setCallback(this, function(response){
                           
                               if(response.getState() == 'SUCCESS' ) 
                               {
                                   var res = response.getReturnValue();
                             	   cmp.set('v.messaggio',res.errorMessage);
                                   cmp.set('v.controllo',true);
                               }
          //                     spinner.decreaseCounter();
                           });
        $A.enqueueAction(action);
	}
})