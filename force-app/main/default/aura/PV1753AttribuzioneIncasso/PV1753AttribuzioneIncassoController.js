({
    doInit : function(component, event, helper){
        var today = $A.localizationService.formatDate(new Date(), "YYYY-MM-DD");
        //var valoricc =component.get("c.querycc");
        component.set('v.today', today);


       
    }
})