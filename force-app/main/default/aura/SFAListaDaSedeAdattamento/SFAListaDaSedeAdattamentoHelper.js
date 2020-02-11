({
    doInit : function(component, event, helper) {
        
        var action = component.get('c.getCase'); 
        var idr = component.get("v.recordId");

        action.setParams({
            idCase: idr
        });
        
        action.setCallback(this, $A.getCallback(function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
              component.set('v.case',response.getReturnValue());
              var cCase = component.get('v.case');
              if(cCase.SFA_ListeCaricate__r.Tipo_Attivita__r.RSS_External_Id_act_code__c === '50'){
                component.set('v.showUtenzeNominative',true);
                component.set('v.showEsitazione',false);
              }else{
                component.set('v.showUtenzeNominative',false);
                component.set('v.showEsitazione',true);
              }
            }
            
        }));
        
        $A.enqueueAction(action);

//        this.getChildCase();
    },
    
    getfiliale : function(caseownerId) {

        var action = component.get('c.getfilialeFromOwnerId');
        action.setParams({
            ownerId : caseownerId
        });
        
        action.setCallback(this, $A.getCallback(function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var filiale = response.getReturnValue();
                if(filiale!=null){
                    return filiale;
                }else{
                    return null;
                }
            }
        }));
        $A.enqueueAction(action);

    },
    
   
    setHeaderColumns: function(component, event, helper) {
        
        component.set("v.headerColumns", [
            //{label: 'Case Number', fieldName: 'number', type: 'text'},
            {label: 'Nome Lista', fieldName: 'tipoLista', type: 'text'},
            {label: 'Filiale', fieldName: 'filiale', type: 'text'},
            {label: '# Totale', fieldName: 'totale', type: 'number', cellAttributes: { alignment: 'left' }}, 
            {label: '# Da Esitare', fieldName: 'daEsitare', type: 'number', cellAttributes: { alignment: 'left' }}, 
            {label: '# Sospesi Da Esitare', fieldName: 'sospesiDaEsitare', type: 'number', cellAttributes: { alignment: 'left' }}  
            //{label: '# Da Convenzionare', fieldName: 'daConvenzionare', type: 'Number'}, 
            //{label: '# Accolli Da Gestire', fieldName: 'accolli', type: 'Number'}
        ]);
    },
    
    getChildCase: function(component, idCase) {
//        var editedRecords =  component.find("table").getSelectedRows();
//        var idr =  component.get("v.recordId"); //5005E0000064UqwQAE
        var idr =  idCase; //5005E0000064UqwQAE
        alert("idrchild"+idr);
//        if(editedRecords.length > 0){

            var action = component.get('c.getCaseChildList');
            
            action.setParams({
//                parentCaseId : editedRecords[0].Id
                parentCaseId : idr

            });
            
            action.setCallback(this, $A.getCallback(function (response) {
                
                var state = response.getState();
                
                if (state === "SUCCESS") {
                    
                    var caseChildList = response.getReturnValue();
                    console.log('caseChildList'+caseChildList.length);
                    if(caseChildList.length > 0){
                        component.set("v.caseChildList",caseChildList);
                        component.set("v.selectedItem",true);
                    }else{
                        component.set("v.selectedItem",false);
                    }
                }
            }));
            $A.enqueueAction(action);
//        }
        
    },
    /*
    getTotal : function(component, event, helper){

        var editedRecords =  component.find("table").getSelectedRows();
        var action = component.get('c.getTotalCase');
            
            action.setParams({
                parentCaseId : editedRecords[0].Id
            });
            
            action.setCallback(this, $A.getCallback(function (response) {
                
                var state = response.getState();
                
                if (state === "SUCCESS") {
                    var totalCase = response.getReturnValue();
                    
                }
            }));
            $A.enqueueAction(action);
    },

    daEsitare : function(component, event, helper){

        var editedRecords =  component.find("table").getSelectedRows();
        var action = component.get('c.getCaseDaEsitare');
            
            action.setParams({
                parentCaseId : editedRecords[0].Id
            });
            
            action.setCallback(this, $A.getCallback(function (response) {
                
                var state = response.getState();
                
                if (state === "SUCCESS") {


                }
            }));
            $A.enqueueAction(action);
    },

    sospesiDaEsitare : function(component, event, helper){

        var editedRecords =  component.find("table").getSelectedRows();
        var action = component.get('c.getCaseSospesiDaEsitare');
            
            action.setParams({
                parentCaseId : editedRecords[0].Id
            });
            
            action.setCallback(this, $A.getCallback(function (response) {
                
                var state = response.getState();
                
                if (state === "SUCCESS") {


                }
            }));
            $A.enqueueAction(action);
    },

    */

    openModal : function(component, event, helper){

        var buttonPressed = event.currentTarget.getAttribute("name");
        var index = event.currentTarget.getAttribute("data-index");
        var caseList = component.get('v.caseChildList');
        
        var childSelected = caseList[index];

        component.set('v.caseChildSelected',childSelected);

        
        console.log('buttonPressed: '+buttonPressed);
        if(buttonPressed === 'rivedi'){
            component.set('v.showRivediAttivita',true);
        }else if(buttonPressed === 'dettaglio'){
            component.set('v.showDettaglioDealer',true);
        }else{
            if(childSelected.SFA_ListeCaricate__r.Tipo_Attivita__r.RSS_External_Id_act_code__c === '50'){
                component.set('v.showUtenzeNominative',true);
            }else{
                component.set('v.showEsitazioneAttivita',true);
            }
        }
        component.set('v.showModal',true);
    },
    goEsitaAttivita : function(component, event, helper){
        component.set('v.showUtenzeNominative',false);
        component.set('v.showEsitazioneAttivita',true);
    },

    gotoList : function (component, event) {
        var action = component.get("c.getListViews");
//        var cat = "Liste da Sede";
        var cat = "All Cases";
        var sUser = component.get('v.userIsBO');
        var sCat;
            sCat = cat;

        action.setParams({ 
//            sName : sCat
        });
        action.setCallback(this, function(response){
            var state = response.getState();
            if (state === "SUCCESS") {
                var listviews = response.getReturnValue();
                console.log('*****************');
                console.log(listviews);
                console.log(listviews[0].Id);
                console.log(listviews[0].Name);
                
                var navEvent = $A.get("e.force:navigateToList");
                navEvent.setParams({
                    "listViewId": listviews[0].Id,
                    "listViewName": null,
                    "scope": "Case"
                });
                navEvent.fire();
            }
        });
        $A.enqueueAction(action);
    }    
})