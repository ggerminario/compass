({
	doInit : function(component, event, helper) {
        
		var action = component.get("c.getEvent");
        action.setParam('recordId',component.get('v.recordId'));
        action.setCallback(this, function(data) {
        	let retVal = data.getReturnValue();
            component.set("v.eventRecord", retVal);
            console.log('DP eventRecord: '+JSON.stringify(retVal))
            helper.getFiliale(component); 
            helper.getValuesProduct(component);
            
        });
        $A.enqueueAction(action);
        helper.setIconAndNameTab(component,event,helper); 
        
    },
    closeAction: function(component,event,helper){
        console.log("closeAction");
        var eventId=component.get("v.eventRecord.Id")
        var pageReference={    
            "type": "standard__recordPage",
            "attributes": {
                "recordId": eventId,
                "objectApiName": "Event",
                "actionName": "view"
            }
        }
        component.find("navService").navigate(pageReference);
       // $A.get("e.force:closeQuickAction").fire() 
    },
    saveEvent:function(component,event,helper){
        var dettaglio=component.find("DettaglioAppuntamento");
        if(!dettaglio) console.error("Dettaglio non trovato");
        else {
            var ModifyEvent=component.get("v.ModifyEvent");
            var saveEsitoSelected=component.get("v.showEsito");
            var showMotivazione=component.get("v.showMotivazione");
            //invoco i metodi sul componente dettaglio 
           
           
            if(showMotivazione){
                dettaglio.saveMotivazioneSelected(); // quando abbiamo motivazione
                console.log("--showMotivazione");
            }
            else if(saveEsitoSelected && !ModifyEvent){ //mostro esito
                dettaglio.saveEsitoSelected();
                console.log("--saveEsitoSelected");
            }
            else if(ModifyEvent){ //salvataggio evento con data/ora modificata
                dettaglio.confirmChangeEvent();
                console.log("--ModifyEvent");
            }
            else{
                dettaglio.saveEvent();
                console.log("--salvataggio normale");
            }
        }       
    }
})