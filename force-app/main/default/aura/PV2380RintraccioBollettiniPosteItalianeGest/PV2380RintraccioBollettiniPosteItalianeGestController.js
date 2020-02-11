({
    doInit : function(cmp, event, helper) {
        console.log('Dentro do-init');
       helper.doInit(cmp, event);

    },
    onSelectchoices : function(cmp, event, helper){
        console.log('Dentro onSelectchoices');
        helper.onSelectchoices(cmp, event);

    }, 
    save : function (cmp, event, helper) {
        helper.save(cmp, event, helper);
    }
})