({
    setColumns:function(cmp){
        cmp.set('v.columns', [{'label': 'N° Reclamo', 'fieldName': 'Url', 'type':'url',typeAttributes: { label: { fieldName: 'Numero_Reclamo_Calc__c' }, target:'_blank'}},
                            //  {'label': 'N° Reclamo', 'fieldName': 'Numero_Reclamo_Calc__c', 'type': 'text'},
                              {'label': 'Categoria', 'fieldName': 'categoryName', 'type': 'text'}, //20190716: anomalie 0001226,0001227 
                              {'label': 'N° Pratica', 'fieldName': 'NumeroPratica__c', 'type': 'text'},
                              {'label': 'Creato il', 'fieldName': 'CreatedDate', 'type': 'date' },
                              //{'label': 'Coda', 'fieldName': 'Owner.Name', 'type': 'text'},
                              {'label': 'Coda', 'fieldName': 'OwnerName', 'type': 'text'}, //20190716: anomalie 0001226,0001227 
                              {'label': 'Stato', 'fieldName': 'Status', 'type': 'text'}]);
        
    },
    
    prepareURL : function(idSalesforce) {
        var finalPath = '';
        var index = window.location.pathname.indexOf('lightning/');
        if(index!=-1) {
            finalPath = window.location.pathname.substring(0,index); 
            console.debug('prepareURL:'+finalPath);
        }
        return finalPath+idSalesforce;
    },
    initHelper:function(cmp){
        var praticaCode=cmp.get('v.praticaSelezionata')?cmp.get('v.praticaSelezionata')['numPratica']:null;
        var clienteCode=cmp.get('v.clienteSelezionato')['SFId'];
        
        var c=cmp.get('v.clienteSelezionato');
        
        var nReclamo=cmp.get('v.numeroReclamo');
        
        var Azienda = cmp.get('v.aziendaSelezionata');
        console.log('aziendaselezionata:::::: '+Azienda);
        if (Azienda=='Compass'){ 
        	var action=cmp.get('c.getReclami');
             action.setParam('praticaCode',praticaCode);
        }
        else if(Azienda=='Futuro'){
            var action=cmp.get('c.getReclamiMB_Futuro');
            
             action.setParam('praticaCode',praticaCode);
        }
        else {
            var action=cmp.get('c.getReclamiMB_Credit');
            console.log('PraticaSconosciuto:::::: '+ c['pratiche'][0]['numPratica']);
             action.setParam('praticaCode',c['pratiche'][0]['numPratica']);
        }
        action.setParam('nReclamo',nReclamo);
        action.setParam('clienteCode',clienteCode);
       
        action.setCallback(this,function(resp){
            if(resp.getState()=='SUCCESS'){
                //20190716: anomalie 0001226,0001227 
                var reclami = resp.getReturnValue();
                for (var i=0; i<reclami.length; i++) {
                    reclami[i].OwnerName = reclami[i].Owner.Name;
                    reclami[i].categoryName = reclami[i].Categoria_Riferimento__r.Name;
                    reclami[i].Url = this.prepareURL(reclami[i].Id);
                }
                cmp.set('v.listaReclamiPrecedenti',reclami);
            }
        });
        $A.enqueueAction(action);
    }
})