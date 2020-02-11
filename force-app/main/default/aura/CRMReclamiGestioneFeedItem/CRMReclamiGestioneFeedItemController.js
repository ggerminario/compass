({
    init : function(cmp, event, helper) {
      
       
        var action = cmp.get("c.getFeedItem");
        action.setParam('recordId',cmp.get('v.ident'));
        action.setCallback(this,function(resp){
            cmp.set("v.showSpinner", false);
            if(resp.getState()=='SUCCESS'){
                cmp.set('v.feedData',resp.getReturnValue());
            }
			
                
        });
        cmp.set("v.showSpinner", true);
        $A.enqueueAction(action);
    }    
    
})