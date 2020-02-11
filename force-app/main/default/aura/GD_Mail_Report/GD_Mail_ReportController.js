({
    doInit: function(component, event, helper) {
        
        var myMap = new Map();
        //Regione RA
        myMap.set('Check_RA',false);
        myMap.set('Check_RA_16_a',false);
        myMap.set('Check_RA_16_b',false);
        myMap.set('Check_RA_17_a',false);
        myMap.set('Check_RA_17_b',false);
        myMap.set('Check_RA_18_a',false);
        myMap.set('Check_RA_18_b',false);
        myMap.set('Check_RA_19_a',false);
        myMap.set('Check_RA_19_b',false);
        myMap.set('Check_RA_20_a',false);
        myMap.set('Check_RA_20_b',false);
        //Regione RC
        myMap.set('Check_RC',false);
        myMap.set('Check_RC_11_a',false);
        myMap.set('Check_RC_11_b',false);
        myMap.set('Check_RC_12_a',false);
        myMap.set('Check_RC_12_b',false);
        myMap.set('Check_RC_13_a',false);
        myMap.set('Check_RC_13_b',false);
        myMap.set('Check_RC_14_a',false);
        myMap.set('Check_RC_14_b',false);
        myMap.set('Check_RC_15_a',false);
        myMap.set('Check_RC_15_b',false);
        //Regione RE
        myMap.set('Check_RE',false);
        myMap.set('Check_RE_6_a',false);
        myMap.set('Check_RE_6_b',false);
        myMap.set('Check_RE_7_a',false);
        myMap.set('Check_RE_7_b',false);
        myMap.set('Check_RE_8_a',false);
        myMap.set('Check_RE_8_b',false);
        myMap.set('Check_RE_9_a',false);
        myMap.set('Check_RE_9_b',false);
        myMap.set('Check_RE_10_a',false);
        myMap.set('Check_RE_10_b',false);
        //Regione RO
        myMap.set('Check_RO',false);
        myMap.set('Check_RO_1_a',false);
        myMap.set('Check_RO_1_b',false);
        myMap.set('Check_RO_2_a',false);
        myMap.set('Check_RO_2_b',false);
        myMap.set('Check_RO_3_a',false);
        myMap.set('Check_RO_3_b',false);
        myMap.set('Check_RO_4_a',false);
        myMap.set('Check_RO_4_b',false);
        myMap.set('Check_RO_5_a',false);
        myMap.set('Check_RO_5_b',false);
        //Regione RS
        myMap.set('Check_RS',false);
        myMap.set('Check_RS_26_a',false);
        myMap.set('Check_RS_26_b',false);
        myMap.set('Check_RS_27_a',false);
        myMap.set('Check_RS_27_b',false);
        myMap.set('Check_RS_28_a',false);
        myMap.set('Check_RS_28_b',false);
        myMap.set('Check_RS_29_a',false);
        myMap.set('Check_RS_29_b',false);
        myMap.set('Check_RS_30_a',false);
        myMap.set('Check_RS_30_b',false);
        //Regione RT
        myMap.set('Check_RT',false);
        myMap.set('Check_RT_21_a',false);
        myMap.set('Check_RT_21_b',false);
        myMap.set('Check_RT_22_a',false);
        myMap.set('Check_RT_22_b',false);
        myMap.set('Check_RT_23_a',false);
        myMap.set('Check_RT_23_b',false);
        myMap.set('Check_RT_24_a',false);
        myMap.set('Check_RT_24_b',false);
        myMap.set('Check_RT_25_a',false);
        myMap.set('Check_RT_25_b',false);
        
        function mapToObj( map )
        {
            const obj = {}
            for( let [k,v] of map )
                obj[k] = v
                return obj
        }
        
        var mappa = mapToObj(myMap);
        component.set('v.Parent',mappa);
        var action2 = component.get("c.listaFilialiUserRole");
        action2.setCallback(this, function(response) {
            let state = response.getState();
            if (state === "SUCCESS") {
                var listaFiliali =response.getReturnValue();
                console.log('listaFiliali '+listaFiliali);
                component.set('v.listFiliali',listaFiliali);
            }
        });
        $A.enqueueAction(action2);
   
     
    },
    handleSectionToggle: function (cmp, event) {
        
    },
    CheckInputCheckBoxValue : function(component,event,helper){
      alert('selectedRec:'+component.get("v.Check_RA"));
    },
    handleChange: function(component, event){
        var value = event.getParam('value');
        console.log('value selected', value);
    },
    send: function(component, event, helper){
        helper.sendMail(component);
    },
    annulla: function(component, event, helper){

        var spinner = component.find("csvSpinner");
        $A.util.toggleClass(spinner, "slds-hide");
        window.setTimeout(
              $A.getCallback( 
                  function(){
                     $A.get('e.force:refreshView').fire();
                     //cmp.set("v.visible", true);
                  }), 1500
        );         
       
    },
    handleSelect: function(component, event){
        event.preventDefault();
        var mapping = {
            '1': 'User',
            '2': 'Standard User',
            '3': 'Chatter User',
            '4': 'Administrator',
            '5': 'System Administrator',
            '6': 'Chatter Administrator',
            '7': 'Community User',
            '8': 'Community Login User',
            '9': 'Community Plus Login User'
        };
        component.set('v.selected', '4');
        console.log('Selected item', mapping[event.getParam('name')])
    },
    handleClickTree: function(component, event){
        event.preventDefault();
        let triangle = this.className.indexOf("checkTree-open") + 1;
        this.className = triangle ? "checkTree-close" : "checkTree-open";
        let ul = this.parentNode.getElementsByTagName("ul")[0];
        ul.style.display = triangle ? "none" : "block";
    },
    manageClass: function( component,event){
          event.preventDefault();
          let triangle = this.className.indexOf("checkTree-open") + 1;
          this.className = triangle ? "checkTree-close" : "checkTree-open";
    },
    printState : function (cmp, event,helper){
		
        console.log('PArent '+JSON.stringify(cmp.get('v.Parent')));
        console.log('child '+JSON.stringify(cmp.get('v.Child')));
        var item = event.getSource().getLocalId();
        helper.clearView(cmp, event, item);
        helper.openSection(cmp, event);
    
    },
    cancel : function (cmp, event,helper){
        console.log(JSON.stringify(cmp.get('v.Child')));
        $A.get("e.force:closeQuickAction").fire();
            location.reload();
    },
    onchangeEvent_RA : function(component,event,helper){
        var OnchangeRA_Checkbox = component.get("v.Parent.Check_RA");
        //alert('OnchangeRA_CheckBox>>>'+OnchangeRA_Checkbox);
        //component.set("v.Parent.Check_RA",true);
        component.set("v.Parent.Check_RA_16_a",OnchangeRA_Checkbox);
        component.set("v.Parent.Check_RA_16_b",OnchangeRA_Checkbox);
        
        component.set("v.Parent.Check_RA_17_a",OnchangeRA_Checkbox);
        component.set("v.Parent.Check_RA_17_b",OnchangeRA_Checkbox);
        
        component.set("v.Parent.Check_RA_18_a",OnchangeRA_Checkbox);
        component.set("v.Parent.Check_RA_18_b",OnchangeRA_Checkbox);
        
        
        component.set("v.Parent.Check_RA_19_a",OnchangeRA_Checkbox);
        component.set("v.Parent.Check_RA_19_b",OnchangeRA_Checkbox);
        
        
        component.set("v.Parent.Check_RA_20_a",OnchangeRA_Checkbox);
        component.set("v.Parent.Check_RA_20_b",OnchangeRA_Checkbox);
        
        //alert('OnchangeRA_Checkbox>>>'+OnchangeRA_Checkbox );    
    },
    onchangeEvent_RC: function(component,event,helper){
        var OnchangeRC_Checkbox = component.get("v.Parent.Check_RC");
        //alert('OnchangeRC_CheckBox>>>'+OnchangeRC_Checkbox);
        //component.set("v.Parent.Check_RA",true);
        component.set("v.Parent.Check_RC_11_a",OnchangeRC_Checkbox);
        component.set("v.Parent.Check_RC_11_b",OnchangeRC_Checkbox);
        
        component.set("v.Parent.Check_RC_12_a",OnchangeRC_Checkbox);
        component.set("v.Parent.Check_RC_12_b",OnchangeRC_Checkbox);
        
        component.set("v.Parent.Check_RC_13_a",OnchangeRC_Checkbox);
        component.set("v.Parent.Check_RC_13_b",OnchangeRC_Checkbox);
        
        
        component.set("v.Parent.Check_RC_14_a",OnchangeRC_Checkbox);
        component.set("v.Parent.Check_RC_14_b",OnchangeRC_Checkbox);
        
        
        component.set("v.Parent.Check_RC_15_a",OnchangeRC_Checkbox);
        component.set("v.Parent.Check_RC_15_b",OnchangeRC_Checkbox);
        
        //alert('OnchangeRC_Checkbox>>>'+OnchangeRC_Checkbox );    
         
    },
    onchangeEvent_RE: function(component,event,helper){
        var OnchangeRE_Checkbox = component.get("v.Parent.Check_RE");
        //alert('OnchangeRE_CheckBox>>>'+OnchangeRE_Checkbox);
        //component.set("v.Parent.Check_RA",true);
        component.set("v.Parent.Check_RE_6_a",OnchangeRE_Checkbox);
        component.set("v.Parent.Check_RE_6_b",OnchangeRE_Checkbox);
        
        component.set("v.Parent.Check_RE_7_a",OnchangeRE_Checkbox);
        component.set("v.Parent.Check_RE_7_b",OnchangeRE_Checkbox);
        
        component.set("v.Parent.Check_RE_8_a",OnchangeRE_Checkbox);
        component.set("v.Parent.Check_RE_8_b",OnchangeRE_Checkbox);
        
        
        component.set("v.Parent.Check_RE_9_a",OnchangeRE_Checkbox);
        component.set("v.Parent.Check_RE_9_b",OnchangeRE_Checkbox);
        
        
        component.set("v.Parent.Check_RE_10_a",OnchangeRE_Checkbox);
        component.set("v.Parent.Check_RE_10_b",OnchangeRE_Checkbox);
        
        //alert('OnchangeRE_Checkbox>>>'+OnchangeRE_Checkbox );    
    },
    onchangeEvent_RO: function(component,event,helper){
        var OnchangeRO_Checkbox = component.get("v.Parent.Check_RO");
        //alert('OnchangeRO_CheckBox>>>'+OnchangeRO_Checkbox);
        //component.set("v.Parent.Check_RA",true);
        component.set("v.Parent.Check_RO_1_a",OnchangeRO_Checkbox);
        component.set("v.Parent.Check_RO_1_b",OnchangeRO_Checkbox);
        
        component.set("v.Parent.Check_RO_2_a",OnchangeRO_Checkbox);
        component.set("v.Parent.Check_RO_2_b",OnchangeRO_Checkbox);
        
        component.set("v.Parent.Check_RO_3_a",OnchangeRO_Checkbox);
        component.set("v.Parent.Check_RO_3_b",OnchangeRO_Checkbox);
        
        
        component.set("v.Parent.Check_RO_4_a",OnchangeRO_Checkbox);
        component.set("v.Parent.Check_RO_4_b",OnchangeRO_Checkbox);
        
        
        component.set("v.Parent.Check_RO_5_a",OnchangeRO_Checkbox);
        component.set("v.Parent.Check_RO_5_b",OnchangeRO_Checkbox);
        
        //alert('OnchangeRO_Checkbox>>>'+OnchangeRO_Checkbox ); 
    },
    onchangeEvent_RS: function(component,event,helper){
        var OnchangeRS_Checkbox = component.get("v.Parent.Check_RS");
        //alert('OnchangeRS_CheckBox>>>'+OnchangeRS_Checkbox);
        //component.set("v.Parent.Check_RA",true);
        component.set("v.Parent.Check_RS_26_a",OnchangeRS_Checkbox);
        component.set("v.Parent.Check_RS_26_b",OnchangeRS_Checkbox);
        
        component.set("v.Parent.Check_RS_27_a",OnchangeRS_Checkbox);
        component.set("v.Parent.Check_RS_27_b",OnchangeRS_Checkbox);
        
        component.set("v.Parent.Check_RS_28_a",OnchangeRS_Checkbox);
        component.set("v.Parent.Check_RS_28_b",OnchangeRS_Checkbox);
        
        
        component.set("v.Parent.Check_RS_29_a",OnchangeRS_Checkbox);
        component.set("v.Parent.Check_RS_29_b",OnchangeRS_Checkbox);
        
        
        component.set("v.Parent.Check_RS_30_a",OnchangeRS_Checkbox);
        component.set("v.Parent.Check_RS_30_b",OnchangeRS_Checkbox);
        
        //alert('OnchangeRS_Checkbox>>>'+OnchangeRS_Checkbox ); 
    },
    onchangeEvent_RT: function(component,event,helper){
        var OnchangeRT_Checkbox = component.get("v.Parent.Check_RT");
        //alert('OnchangeRT_CheckBox>>>'+OnchangeRT_Checkbox);
        //component.set("v.Parent.Check_RA",true);
        component.set("v.Parent.Check_RT_21_a",OnchangeRT_Checkbox);
        component.set("v.Parent.Check_RT_21_b",OnchangeRT_Checkbox);
        
        component.set("v.Parent.Check_RT_22_a",OnchangeRT_Checkbox);
        component.set("v.Parent.Check_RT_22_b",OnchangeRT_Checkbox);
        
        component.set("v.Parent.Check_RT_23_a",OnchangeRT_Checkbox);
        component.set("v.Parent.Check_RT_23_b",OnchangeRT_Checkbox);
        
        
        component.set("v.Parent.Check_RT_24_a",OnchangeRT_Checkbox);
        component.set("v.Parent.Check_RT_24_b",OnchangeRT_Checkbox);
        
        
        component.set("v.Parent.Check_RT_25_a",OnchangeRT_Checkbox);
        component.set("v.Parent.Check_RT_25_b",OnchangeRT_Checkbox);
        
        //alert('OnchangeRT_Checkbox>>>'+OnchangeRT_Checkbox ); 
    }
})