({
    init:function(cmp,event,helper){
        var p=cmp.get('v.praticaSelezionata');
        var c=cmp.get('v.clienteSelezionato');
        console.log('CRMReclamiRiepilogoCampiComuni');
        console.log(p);
        if((cmp.get('v.aziendaSelezionata')!='MBCredit Solutions') && p!=null){
            var Tipo='';
        
        if(p['tipoPratica']=='CO'){
            Tipo='Consumo';
        }
        else if(p['tipoPratica']=='CA'){
            Tipo='Carta';
        }
        else if (p['tipoPratica']=='CQ' || p['tipoPratica']=='C'){
            Tipo='CQS';
    	}
        else if (p['tipoPratica']=='CP'){
            Tipo='CPay';
    	}
        else if (p['tipoPratica']=='D'){
            Tipo='Delegazione';
    	}
             console.log('TIPO '+Tipo);
            cmp.set('v.numInterno', p['numPratica'] ? p['numPratica'] : '' );
            cmp.set('v.tipo', Tipo );
            if (p['codStatoPratica']!=null && p['codStatoPratica']!=undefined && p['desStatoPratica']!=null && p['desStatoPratica']!=undefined ) {
                cmp.set('v.stato', p['codStatoPratica']  +' '+ p['desStatoPratica']);
            } else {
                cmp.set('v.stato', '');
            }
            cmp.set('v.classifRec', p['classifRecupero'] ? p['classifRecupero'] : '' );
            if (p['desAttributoPratica']!=null && p['desAttributoPratica']!=undefined && p['codAttributoPratica']!=null && p['codAttributoPratica']!=undefined ) {
                cmp.set('v.attributo',  p['codAttributoPratica']  +' '+ p['desAttributoPratica']);
            }
            cmp.set('v.dataCarcamRichiesta', p['dataCaricamento'] ? p['dataCaricamento'] : '' );
            cmp.set('v.recuperatore', p['codRecuperatore'] ? (p['codRecuperatore'] +' '+ (p['desRecuperatore'] ? p['desRecuperatore'] : '' )) : '');
        }
        else if(c["pratiche"].length > 0){
            cmp.set('v.numInterno',c['pratiche'][0]['numPratica']);
        }
    }
})