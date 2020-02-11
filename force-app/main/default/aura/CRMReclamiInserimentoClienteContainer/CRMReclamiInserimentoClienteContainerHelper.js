({
    navigate:function(cmp,isNotEmpty){
        console.log(cmp.get('v.isSconosciuto'));
        if(isNotEmpty){
            if(
                cmp.get('v.aziendaSelezionata')!='MBCredit Solutions' &&
                !cmp.get('v.isSconosciuto')
            ){
                //cmp.set('v.stepInserimentoCliente',(cmp.get('v.stepInserimentoCliente')+1));
                var cont = cmp.get('v.stepInserimentoCliente');
                
                cont++;
                if(cont>=4)cont =4;
                cmp.set('v.stepInserimentoCliente', cont);
                
                console.log('Entro qui');
                
            }
            else{
                cmp.set('v.stepInserimentoCliente',4);
                console.log('Entro qui Settando 4');
                
            }
        }
        
    },
    
    ModificaAssociazioneReclamo : function (cmp,event){
        var action = cmp.get('c.modificaAssociazReclamo');
        var caseReclamo = cmp.get('v.case');
        var Precedente = cmp.get('v.reclamoSelezionato');
        console.log('ModificaAssociazioneReclamo_caseReclamo');
        console.log(caseReclamo);
        console.log(Precedente);
        action.setParams({
            caseReclamo: caseReclamo,
            Precedente: Precedente
        });
        action.setCallback(this,function(resp){
            if(resp.getState()=='SUCCESS'){
                
                console.log('ModificaAssociazioneReclamoReturn');
                console.log(resp.getReturnValue());
                console.log('PostLoG' + resp.getReturnValue().Numero_Reclamo__c);
                cmp.set('v.case',resp.getReturnValue());
            }   
        });        
        $A.enqueueAction(action);
        
    },
    
    alert : function(cmp) {
        cmp.find('notifLib').showNotice({
            "variant":"error",
            "header":"Attenzione!",
            "message":"Cliente non trovato"
        });
    },
    
    alert2 : function(cmp) {
        cmp.find('notifLib').showNotice({
            "variant":"error",
            "header":"Attenzione!",
            "message":"Compilare il form"
        });
    },
    
    
    settaDatiPraticaAggiuntivi: function(cmp, event){
        var societa = cmp.get("v.aziendaSelezionata");
        if(societa != 'Compass'){
            return;
        } 
        var action=cmp.get("c.praticaDatiAggiuntivi");
        action.setParams({
            societa: cmp.get("v.aziendaSelezionata"),
            pratica: cmp.get('v.praticaSelezionataContainer')
        });
        action.setCallback(this,function(resp){
            if(resp.getState()=='SUCCESS'){
                if(resp.getReturnValue() == null || resp.getReturnValue()== undefined){
                    
                }
                else{
                    
                    cmp.set('v.praticaSelezionataContainer', resp.getReturnValue());
                    this.recuperaAssicurazione(cmp, event);
                }
                
            }

            
            
            
        });
    
        $A.enqueueAction(action);
    },
    
    recuperaAssicurazione:  function(cmp,event){
        
        var societa = cmp.get("v.aziendaSelezionata");
        if(societa != 'Compass'){
           
            return;
        } 
        var action2=cmp.get("c.getInfoPraticaOutput");
        action2.setParams({
            
            pratica: cmp.get('v.praticaSelezionataContainer'),
            societa: cmp.get("v.aziendaSelezionata")
        });
        action2.setCallback(this,function(resp){
            if(resp.getState()=='SUCCESS'){
                
                cmp.set("v.infoPraticaSelezionata", resp.getReturnValue());  
                
            }
            
            cmp.set("v.spinner", false);
        });
        cmp.set("v.spinner", true);
        $A.enqueueAction(action2);
    }
    
})