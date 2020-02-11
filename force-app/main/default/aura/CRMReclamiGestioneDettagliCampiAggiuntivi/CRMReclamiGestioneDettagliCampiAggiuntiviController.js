({
    init:function(cmp,event,helper){
        cmp.set('v.initAggiuntivi',true);
        var action=cmp.get('c.getInitValues');
        action.setCallback(this,function(resp){
            if(resp.getState()=='SUCCESS'){
                console.log('SUCCESS');
                console.log(resp.getReturnValue());
                cmp.set('v.listaTipoProdottoVita',resp.getReturnValue()['prodVita']);
                cmp.set('v.listaTipoProdottoDanni',resp.getReturnValue()['prodDanni']);
                cmp.set('v.listaAreaAziendale',resp.getReturnValue()['areaAz']);
                cmp.set('v.listaTipoProponente',resp.getReturnValue()['prop']);
                cmp.set('v.listaAreaGeograficaProponente',resp.getReturnValue()['areaProp']);
                cmp.set('v.listaTipoReclamante',resp.getReturnValue()['recl']);
                var cCase=cmp.get('v.campiCase');
                if(cCase){
                    helper.buildInitValues(cmp,cCase);
                }
            }
        });
        $A.enqueueAction(action);
        helper.handleChangeHelperAgg(cmp,helper);
        if(cmp.get('v.campiCase')['Id']){
          
            helper.initIfGestione(cmp);
        }
        
    },
    
    handleChangeAgg:function(cmp,event,helper){
        helper.handleChangeHelperAgg(cmp,helper);
    },
    
    selectValue : function(cmp,event,helper){    	
        
    },
    
    deselProdottoVita : function(cmp){
        cmp.set('v.tipoProdottoVitaInit','Selezionare');
    },
    
    deselProdottoDanni : function(cmp){
        cmp.set('v.tipoProdottoDanniInit','Selezionare');
    },
    
    deselProdottoArea : function(cmp){
        cmp.set('v.tipoProdottoAreaInit','Selezionare');
        
    },
    deselTipoReclamante : function(cmp){
        cmp.set('v.tipoReclamanteInit','Selezionare');
        
    },    
    deselareaGeograficaProponente : function(cmp){
        cmp.set('v.areaGeograficaProponenteInit','Selezionare');
        
    },
    deselTipoProponente : function(cmp){
        cmp.set('v.tipoProponenteInit','Selezionare');
        
    },
    
    salvaReclamoCampiAggiuntivi : function(cmp){
        var res = {};
        res['trattabile'] = cmp.get('v.trattabile');
        res['tipoProdottoVita'] = cmp.get('v.tipoProdottoVita');
        res['tipoProdottoDanni'] = cmp.get('v.tipoProdottoDanni');
        res['areaAziendale'] = cmp.get('v.areaAziendale');
        res['tipoProponente'] = cmp.get('v.tipoProponente');
        res['tipoReclamante'] = cmp.get('v.tipoReclamante');
        res['areaGeograficaProponente'] = cmp.get('v.areaGeograficaProponente');
        
        
        return res;
       
    }
    
})