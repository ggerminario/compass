({
	init : function(component, event, helper) {
		helper.initApex(component,event,helper);
        //CR Inizio
        helper.caricaListaModelli(component, event);
        //CR Fine
	},

    onChangeRegionSelect: function(component, event, helper) {
		helper.onChangeRegionSelect(component, event, helper);
	},

	onChangeAreaSelect: function(component, event, helper) {
		helper.onChangeAreaSelect(component, event, helper);
	},
    
	onChangeBranchSelect: function(component, event, helper) {
		helper.onChangeBranchSelect(component, event, helper);
	},

	submitNewTargetDate: function(component, event, helper) {
		helper.submitNewTargetDate(component, event, helper,false);
	},
    
	saveSlotList: function(component, event, helper) {
		helper.saveSlotList(component, event, helper);
	},
	
	cancelFun: function(component, event, helper){
		helper.submitNewTargetDate(component, event, helper);
	},
	
	sendMessageHandler: function(component, event, helper){
		helper.sendMessageHandler(component, event, helper);
	},
    //CR inizio
    applicaModello : function(component, event, helper){
        var idModello = component.get("v.selezioneModello");
        if(idModello == null || idModello == ''){
            helper.showToast("Devi selezionare un modello", 'error');
            return;
        } 
        helper.checkData(component, event);
     
    },
    
    test : function(component, event, helper){
        
        var cmp = component;
        var slotDraft = cmp.get("v.draftSlotList");
        console.log("DRAFT");
        console.log(slotDraft);
        var slotList = cmp.get("v.slotList");
        console.log("SLOT");
        console.log(slotList);
        
    },
    closeModal : function(component){
         component.set("v.showModal", false);
    },
    
    onchangeSettimana : function(cmp, event, helper){
        helper.onchangeSettimana(cmp, event);
    },
    
    applicaModelloDefinitivamente : function(cmp, event, helper){
        helper.applicaModelloDefinitivamente(cmp, event);
    }
    
    //CR fine
})