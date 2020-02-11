({
    init:function(cmp,event,helper){
        console.log('***************************************************************************');
        console.log('-- - Controller JS : CRMReclamiInserimentoClienteContainerController.js '); 
        console.log('isSconosciuto ************************************ ' + cmp.get('v.isSconosciuto'));
        console.log(cmp.get('v.praticaSelezionataContainer')); 
        //console.log('Inserimento Cliente container init');
        if(cmp.get('v.clienteSelezionatoContainer')){
           // cmp.set('v.clienteSelezionato',cmp.get('v.clienteSelezionatoContainer'));
        }
        if(cmp.get('v.praticaSelezionataContainer')){
           // cmp.set('v.praticaSelezionata',cmp.get('v.praticaSelezionataContainer'));
        }
        
    },
    
    fireEvent : function(cmp,event,helper){
        var caseObj = cmp.get("v.case");
        if(caseObj== null || caseObj.Id == null) return;
        var step=cmp.get('v.stepInserimentoCliente');
        if(step == 4){
            var cliente = cmp.get("v.clienteSelezionato");
            var pratica = cmp.get("v.praticaSelezionata");
            var cmpEvent = cmp.getEvent("clientePratica");
            cmpEvent.setParams({
                "cliente" : cliente,
                "pratica": pratica
            });
            cmpEvent.fire();
            console.log("BAAANG");
        }
        
    },
    
    salvaGestione:function(cmp,event,helper){
        helper.ModificaAssociazioneReclamo(cmp,event);
        console.log('salvaGestione');
        console.log(cmp.get('v.case'));
    },
    
    onListaClientiChange:function(cmp,event,helper){
        console.log('sono in onListaClientiChange');
        var clienti = cmp.get('v.listaClienti');
        var showalert2 = cmp.get('v.showAlert2');
        
        if(showalert2){
            //helper.alert2(cmp);
            
        }else if(clienti){
            if(clienti.length==0){
                helper.alert(cmp);
            }
            else
                helper.navigate(cmp,clienti[0]);
            
        }
        
    },
    
    onClienteChange:function(cmp,event,helper){
        console.log('sono in onClienteChange');
        var source=event.getSource();
        var clienteSel=cmp.get('v.clienteSelezionato');
        cmp.set('v.clienteSelezionatoContainer',clienteSel);
        if(clienteSel){
            var listaPratiche=[];
            listaPratiche=cmp.get('v.aziendaSelezionata')!='Futuro'?clienteSel['pratiche']:clienteSel['praticheFuturo'];
            if((listaPratiche == null || listaPratiche.length == 0) && !cmp.get('v.isSconosciuto')) {
                cmp.find('notifLib').showNotice({
                    "variant":"error",
                    "header":"Attenzione!",
                    "message":"Nessuna pratica trovata"
                });
                 
                cmp.set('v.stepInserimentoCliente',1);
                   
            }
            else cmp.set('v.listaPratiche',listaPratiche);
              
           
        }
    },
    
    onListaPraticheChange:function(cmp,event,helper){   
        console.log('sono in onListaPraticheChange');
        var listaPratiche=cmp.get('v.listaPratiche');
        console.log('listaPratiche = ' + listaPratiche);
        var societa=cmp.get('v.aziendaSelezionata');
        if(societa!='MBCredit Solutions' && listaPratiche && listaPratiche.length>0){
            console.log('sono nell if');
            var action=cmp.get('c.getInfoPratiche');
            action.setParam('dataJSON',JSON.stringify(listaPratiche));
            action.setParam('societa',societa);
            cmp.set("v.spinner", true);
            action.setCallback(this,function(resp){
                if(resp.getState()=='SUCCESS'){
                    var listaInfo=resp.getReturnValue(); 
                    cmp.set('v.listaInfoPratiche',listaInfo);
                    helper.navigate(cmp,cmp.get('v.clienteSelezionato'));
                    
                }
                cmp.set("v.spinner", false);
            });
            $A.enqueueAction(action);
        }
        else if(listaPratiche){
            console.log('Setto lo step a 4');
            cmp.set('v.stepInserimentoCliente',4);
        }
    },
    
    onPraticaChange:function(cmp,event,helper){
        console.log('sono in onPraticaChange');
          
        var praticaSel=cmp.get('v.praticaSelezionata');
        
        var action=cmp.get('c.makeCoobbligati');
        action.setParam('pratica',praticaSel);
        action.setParam('societa','Compass');
		if(praticaSel == null)
			return;
        
        action.setCallback(this,function(resp){
            if(resp.getState()=='SUCCESS'){
                //var pratica = resp.getReturnValue();
                praticaSel =resp.getReturnValue();
                
                cmp.set('v.praticaSelezionataContainer',praticaSel);
                
                helper.navigate(cmp,cmp.get('v.praticaSelezionata'));
                
                if(cmp.get("v.isGestione")){
                    helper.recuperaAssicurazione(cmp,event);
                    
                }
                

            }
            
            cmp.set("v.spinner", false);
        });
        if(cmp.get('v.aziendaSelezionata')=='Compass'){
            cmp.set("v.spinner", true);
            $A.enqueueAction(action);
        }
        else{
               
            cmp.set('v.praticaSelezionataContainer',praticaSel);
            helper.navigate(cmp,cmp.get('v.praticaSelezionata'));
        }
    }
})