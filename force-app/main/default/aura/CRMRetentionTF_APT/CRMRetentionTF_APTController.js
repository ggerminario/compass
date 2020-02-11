({
    init : function(cmp, event, helper) {
        var action = cmp.get("c.doInit");
        action.setParams({'recordId' : cmp.get('v.recordId')});
        action.setCallback(this,function(response){
            if(response.getState() == 'SUCCESS' ) 
            {
                cmp.set('v.currentCase',response.getReturnValue());
            }
        });
        $A.enqueueAction(action);
    },
    insertNote : function (cmp,event,helper)
    {
        var spinner = cmp.find('spinnerComponent');
        spinner.incrementCounter(); 
        var note = event.getParam('note');
        console.log("@@@@@@@@@@@ "+ cmp.get('v.recordId') +" ***********insertNote########## "+note);
        var action = cmp.get("c.insertContentNote");
        action.setParams({'note' : note,
                          'recordId' : cmp.get('v.recordId')});
        action.setCallback(this, function(response)
         {
            if(response.getState() == 'SUCCESS' ) 
            {
                console.log('Dentro Callback');
                
            }
             spinner.decreaseCounter();
         });
        $A.enqueueAction(action);
    },
    saveSelection : function(cmp,event,helper){
        cmp.set('v.dispositionSelected',event.getParam('disposition'));  
    },
    indietroAttivita : function(cmp,event,helper){
        window.history.back(); 
    },
    completa : function(cmp,event,helper){
        var action = cmp.get('c.completaAttivita');
        action.setParams({
            'recordId' : cmp.get('v.recordId'),
            'disposition' : cmp.get('v.dispositionSelected'),
            'noteValue' : cmp.get('v.noteValue')
        });
        action.setCallback(this,function(response){
            if(response.getState() == 'SUCCESS')
            {
                var toastEvent = $A.get("e.force:showToast");
                var wrapObj = response.getReturnValue();
                var check = wrapObj.res;
                var messToast = wrapObj.messToast;
                if(check)
                {
                    toastEvent.setParams({
                        "title": "Successo",
                        "message": messToast,
                        "type" : "Success"	
                    });
                    toastEvent.fire();
                    $A.get('e.force:refreshView').fire();
                }
                else
                {
                    toastEvent.setParams({
                        "title": "Attenzione",
                        "message": messToast,
                        "type" : "Warning"	
                    });
                    toastEvent.fire();
                }
                
            }
        });
        $A.enqueueAction(action);
    }
})