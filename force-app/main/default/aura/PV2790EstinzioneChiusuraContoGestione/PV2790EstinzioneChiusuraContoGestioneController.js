({
    doInit: function(component, event, helper) {
        console.log("init Controller");
        helper.init(component, event, helper);
      },
    
      save: function(component, event, helper) {
        helper.save(component, event, helper);
      }
})