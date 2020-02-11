({
    init : function(component, event, helper){
       helper.init(component, event);
    },
    
    setDestinatarioNome : function(component, event){
        var idDestinatario =   event.getSource().get("v.value");
        var destinatarioLista = component.get('v.listaDestinatari');
        for(var i=0; i<destinatarioLista.length;i++){
            var temp = destinatarioLista[i];
            if(temp.Id == idDestinatario){
                component.set("v.destinatario", temp.Name);
                break;
            }
        }
    },
    
    cerca: function (cmp, event, helper) {
        var codPratica = cmp.get("v.codPratica");
        if(codPratica == undefined || codPratica.length == 0){
            helper.showToast(cmp, 'Errore', 'error', 'Il Codice pratica deve essere valorizzato');
            return;
        }
        helper.ricercaPratica(cmp, codPratica);
    },
    
    sendEmail : function(cmp, event, helper){
        if(!helper.checkEmail(cmp)) return;
        if(!cmp.get("v.destinatarioId") || cmp.get("v.destinatarioId").length==0){
             helper.showToast(cmp, 'Errore', 'error', 'Il campo destinatario deve essere valorizzato');
            return;
        }
         if(!cmp.get("v.categoria") || cmp.get("v.categoria").length==0){
             helper.showToast(cmp, 'Errore', 'error', 'Il campo categoria deve essere valorizzato');
            return;
        }
        
         if(!cmp.get("v.testo") || cmp.get("v.testo").length==0){
             helper.showToast(cmp, 'Errore', 'error', 'Il campo testo deve essere valorizzato');
            return;
        }
        helper.sendEmail(cmp);
        
    },
    
   
    
    
    
})