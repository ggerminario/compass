({
    init : function(component, event) {
        var action = component.get('c.initDestinatario');
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                component.set('v.listaDestinatari', response.getReturnValue());
            }
            else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.log("Error message: " + 
                                    errors[0].message);
                    }
                }
            }
            this.hideSpinner(component, event);
        });
        this.showSpinner(component, event);
        $A.enqueueAction(action);
    },
    
    ricercaPratica: function(cmp, codicePratica){
        var action = cmp.get('c.cercaPratica');
        action.setParam("codPratica", codicePratica);
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var risposta = JSON.parse(response.getReturnValue());
                if(risposta.pratiche == null || risposta.pratiche.length == 0){
                    this.showToast(cmp, 'Errore', 'error', 'Pratica non trovata');
                }
                else  this.showToast(cmp, 'Messaggio', 'success', 'Pratica trovata');
            }
            else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        alert("Error message: " + 
                                    errors[0].message);
                    }
                }
            }
            this.hideSpinner(cmp, event);
        });
        this.showSpinner(cmp, event);
        $A.enqueueAction(action);
    },
    
    sendEmail : function(cmp){
        var action = cmp.get('c.inviaEmail');
        action.setParam("destinatarioId", cmp.get("v.destinatarioId"));
        action.setParam("categoria", cmp.get("v.categoria"));
        action.setParam("oggetto", 'Sospesi Banca '+cmp.get("v.destinatario")+' '+cmp.get("v.oggetto"));
        action.setParam("tipo", cmp.get("v.tipo"));
        action.setParam("codPratica", cmp.get("v.codPratica"));
        action.setParam("testo", cmp.get("v.testo"));
        action.setParam("cc", cmp.get("v.cc"));
        
        
         action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                this.showToast(cmp,'Messaggio Inviato', 'success', 'Email inviata correttamente');
                $A.get('e.force:refreshView').fire();
            }
            else if (state === "ERROR") {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        alert("Error message: " + 
                                    errors[0].message);
                    }
                }
            }
            this.hideSpinner(cmp, event);
        });
        this.showSpinner(cmp, event);
        $A.enqueueAction(action);
    },
    
    showSpinner: function(component, event){
        var spinner = component.get("v.spinner")+1;
        component.set("v.spinner", spinner);
    },
    
    hideSpinner: function(component, event){
        var spinner = component.get("v.spinner")-1;
        component.set("v.spinner", spinner);
    },
    
    showToast : function(component, title, type, message) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "title": title,
            "message": message,
            "type": type
        });
        toastEvent.fire();
    },
    
    checkEmail : function(cmp){
        var cc = cmp.get("v.cc");
        if(cc==null || cc.length==0) return true;
        if(!cc.includes(";")){
            return this.isValidEmail(cc);
        } 
        cc = cc.replace(/\s+/g, '');
        var ccList = cc.split(";");
        for(var i=0; i<ccList.length; i++){
            if(!this.isValidEmail(ccList[i])){
                this.showToast(cmp, 'Errore', 'error', 'CC: Email non valida');
                return false;
            } 
        }
        if(ccList.length > 8){
             this.showToast(cmp, 'Errore', 'error', 'CC: Puoi inserire fino a 8 indirizzi email');
        }
        return true;
    },
    
    isValidEmail: function(email){
        var reg = /^([A-Za-z0-9_\-\.])+\@([A-Za-z0-9_\-\.])+\.([A-Za-z]{2,4})$/;
        return reg.test(email);
    }
})