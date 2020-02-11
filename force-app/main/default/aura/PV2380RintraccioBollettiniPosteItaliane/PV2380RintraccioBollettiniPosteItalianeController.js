/**
 * @File Name          : PV2380RintraccioBollettiniPosteItalianeController.js
 * @Description        : 
 * @Author             : Federico
 * @Group              : 
 * @Last Modified By   : Federico
 * @Last Modified On   : 16/1/2020, 15:37:17
 * @Modification Log   : 
 * Ver       Date            Author      		    Modification
 * 1.0    16/1/2020   Federico     Initial Version
**/
({
    changeContoCorrente : function(component, event, helper) {
        var selectedValue =  component.find("contoCorrenteSelect").get("v.value");
        component.set("v.contoCorrente",selectedValue);
    },
    doInit : function(component, event, helper){
        var today = $A.localizationService.formatDate(new Date(), "YYYY-MM-DD");
        //var valoricc =component.get("c.querycc");
        component.set('v.today', today);
        //component.set('v.contoCorrenteList', valoricc);

        var action = component.get("c.querycc");
        action.setCallback(this, function(response){
            var state = response.getState();
            if(state === 'SUCCESS'){
                  component.set("v.contoCorrenteList",response.getReturnValue());
            }
        })
        $A.enqueueAction(action);
       
    }
})