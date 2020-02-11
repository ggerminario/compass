({
    doInit: function(component, event, helper) { 
        helper.callGetInteseNomi(component, event); 
	},
    
    reInit: function(component, event, helper) { 
        helper.callGetInteseNomi(component, event); 
	}, 
    
    getPDF : function(component, event, helper) {
        var base64 = event.getSource().get("v.value");
        helper.parseBase64toFile(component, event,base64);
    },    

    getPDF_KO : function(component, event, helper) {
        var base64 = event.getSource().get("v.value");
        helper.showToast(component, event,"","error","Errore nel recupero dell'\intesa.","500");
    }, 
    
    actionButtonIDReferenti: function(component, event, helper) {
        var showSezioneDocIdentitaCollegati=component.get("v.showSezioneDocIdentitaCollegati");
        component.set("v.showSezioneDocIdentitaCollegati",!showSezioneDocIdentitaCollegati);
        var actionCollegati = [
            { label: 'Inserisci/Aggiorna documento','iconName': 'utility:edit', name: 'edit' }
        ]        
        component.set('v.columnsCollegati', [
            {label: 'Codice OCS', fieldName: 'OCS_External_Id__c', type: 'text'},
            {label: 'Cognome', fieldName: 'LastName', type: 'text'},
            {label: 'Nome', fieldName: 'FirstName', type: 'text'},
            {label: 'Sesso', fieldName: 'Sesso__c', type: 'text'},
            {label: 'Città di nascita', fieldName: 'Luogo_Nascita__c', type: 'text'},
            {label: 'Provincia di nascita', fieldName: 'Provincia_Nascita__c', type: 'text'},   
            {label: 'Data di nascita', fieldName: 'Birthdate', type: 'text'},
            {label: 'Codice Fiscale', fieldName: 'Codice_Fiscale__c', type: 'text'},
            {label: 'Indirizzo di residenza', fieldName: 'MailingAddress', type: 'text'},
            {label: 'Ruolo', fieldName: 'Roles', type: 'text'},
            {type: 'action', typeAttributes: { rowActions: actionCollegati } },
        ]);        
        helper.getCollegati(component,event);
	}, 
            
        
	handleRowActionCollegati: function(component, event, helper) {
        var action = event.getParam('action');
        var row = event.getParam('row');
        console.log("selectedRow-->"+row);
        component.set("v.selectedRow",row);
        component.set("v.isOpen",true);
        component.set("v.selectedCollegatoId",row.Id);
        component.set("v.provinciaRilascio",row.Provincia_Rilascio__c);
        component.set("v.luogoRilascio",row.Luogo_Rilascio__c);
        var provincePicklist=component.find("ProvincePicklist"); 
        provincePicklist.inizializza();
	},            
    
    closeModal : function(component,event, helper){
        component.set("v.isOpen",false);
        component.set("v.problemaChiamataOCS",false);
        component.set("v.messageProbemaOCS",""); 
        helper.getCollegati(component,event);
    },         

    salvaDatiIDCollegato: function(component, event, helper) {
        var tipoDocumento = component.find("Tipo_Documento__c").get("v.value");
        var numeroDocumento = component.find("Numero_Documento__c").get("v.value");
        var enteRilascio = component.find("Ente_Doc_ID__c").get("v.value");
        var provinciaRilascio = component.get("v.provinciaRilascio");
        var luogoRilascio = component.get("v.luogoRilascio");
        var dataRilascio = component.find("Data_Rilascio__c").get("v.value");
        var dataScadenza = component.find("Data_Scadenza__c").get("v.value");
            
        if (tipoDocumento && numeroDocumento && enteRilascio && provinciaRilascio && luogoRilascio && dataRilascio && dataScadenza) {
            helper.aggiornaDatiIDCollegato(component, event);
        }
        else {
        	helper.showToast(component,event,"","error","Per procedere è necessario popolare tutti i campi","500");    
        }
            
	},
            
    actionButtonProsegui: function(component, event, helper) { 
        helper.prosegui(component, event);    
	},                

	handleError: function(component, event, helper) {
        this.showToast(component,event,"","error","Si è verificato un errore durante il salvataggio","500");
    },                
    
})