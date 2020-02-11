({
    initHelper:function(cmp,helper){
        console.log('2-B -----> Init Helper');
        
        var m=cmp.get('v.mittenteSelezionatoListaMitt');
        console.log('2-B ----> Il cliente è ' + JSON.stringify(m));
        if(m){
            cmp.set('v.tipoMittente',m['Tipologia__c']);
            cmp.set('v.isPrincipale',m['Principale__c']);
            cmp.set('v.nomeCognomeMittente',m['Name__c']);
            cmp.set('v.indirizzoMittente',m['Via__c']);
            cmp.set('v.cittaMittente',m['Citta__c']);
            cmp.set('v.provinciaMittente',m['Provincia__c']);
            cmp.set('v.capMittente',m['Codice_Postale__c']);
            cmp.set('v.salutoMittente',m['Salutation__c']);
            console.log('2-B ---> imposto saluto mittente con ' + JSON.stringify(m['Salutation__c']));
        }
    },
    
    buildSalutiValues:function(cmp){
        console.log('2-B ----> Build Saluti');
        var salutiAvvocato=['EGREGIO SIGNOR AVV.','EGREGI SIGNORI AVV.','GENTILE SIGNORA AVV.','GENTILI SIGNORE AVV.'];
        var salutiDottore=['EGREGIO SIGNOR DOTT.','EGREGI SIGNORI DOTT.','GENTILE SIGNORA DOTT.SSA','GENTILI SIGNORE DOTT.SSE'];
        var salutiAltro=['EGREGIO SIGNORE','EGREGI SIGNORI','GENTILE SIGNORA','GENTILI SIGNORE'];
        var salutiGenerico=['SPETTABILE'];
        var salutiMap={
            'AVVOCATO':salutiAvvocato,
            'DOTTORE':salutiDottore,
            'ALTRO':salutiGenerico.concat(salutiAltro).concat(salutiAvvocato).concat(salutiDottore),
            'AUTORITA':salutiGenerico,
            'SOCIETA':salutiGenerico,
            'INDIRIZZI PREDEFINITI':salutiGenerico
        };
        cmp.set('v.salutiValues',salutiMap[cmp.get('v.tipoMittente')]);
        console.log('2-B ----> Build Saluti ----> v.salutiValues = '+ salutiMap[cmp.get('v.tipoMittente')]);
        if(cmp.get('v.mittenteSelezionatoListaMitt')){
            console.log('2-B ----> Build Saluti ----> If');
            var saluto=cmp.get('v.mittenteSelezionatoListaMitt')['Salutation__c'];
            console.log('2-B ----> Build Saluti ----> If ----> saluto = ' + saluto);
            cmp.set('v.salutoMittente',null);
            cmp.set('v.salutoMittente',saluto);
        }
        
    },
    
    buildIndirizziValues:function(cmp){
        var action=cmp.get('c.buildIndirizzi');
        action.setParam('societa',cmp.get('v.aziendaSelezionata'));
        action.setCallback(this,function(resp){
            if(resp.getState()=='SUCCESS'){
                var list=[];
                cmp.set('v.indirizziValues',resp.getReturnValue());
                resp.getReturnValue().forEach(function(temp){
                    list.push(temp['Name__c']);
                });
                cmp.set('v.indirizziPredefiniti',list);
            }
        });
        $A.enqueueAction(action);
    },
    
    salvaMittente:function(cmp){
        console.log('2-B ----> Salva mittente'+ cmp.get('v.mittenteSelezionatoListaMitt'));
        console.log('2-B ----> Salva mittenteList'+ cmp.get('v.mittentiList'));
        var MittenteList = cmp.get('v.mittentiList');
 
        var action=cmp.get('c.makeMittente');
        action.setParams({
            'da':cmp.get('v.isPrincipale'),
            'tipo':cmp.get('v.tipoMittente'),
            'autorita':cmp.get('v.tipoMittente')=='AUTORITA',
            'nomeCognomeMittente':cmp.get('v.nomeCognomeMittente'),
            'indirizzoMittente':cmp.get('v.indirizzoMittente'),
            'cittaMittente':cmp.get('v.cittaMittente'),
            'provinciaMittente':cmp.get('v.provinciaMittente'),
            'capMittente':cmp.get('v.capMittente'),
            'saluti':cmp.get('v.salutoMittente')
        });
        action.setCallback(this,function(resp){
            if(resp.getState()=='SUCCESS'){
                var mittentiList=cmp.get('v.mittentiList');
                mittentiList.push(resp.getReturnValue());
                
                for(var i =0; i< mittentiList.length; i++){
                    mittentiList[i].Name = i+'';
                }
                
                cmp.set('v.mittentiList',mittentiList);
                cmp.set('v.stepInserimentoMittenti','main');
                console.log('2-B ----> Salva mittente if Call back');
            }
        });
        $A.enqueueAction(action);
    },
    
    salvaIndPred:function(cmp){
        var action=cmp.get('c.makeMittenteFromIndPred');
        action.setParam('ip',cmp.get('v.indirizzoPredefinitoMittente'));
        action.setParam('principale',cmp.get('v.isPrincipale'));
        action.setCallback(this,function(resp){
            if(resp.getState()=='SUCCESS'){
                var mitList=cmp.get('v.mittentiList');
                mitList.push(resp.getReturnValue());
                cmp.set('v.mittentiList',mitList);
                cmp.set('v.stepInserimentoMittenti','main');
            }
        });
        $A.enqueueAction(action);
    },
    
    salvaModifiche:function(cmp){
        console.log('2-B ---> Salva modifiche');
        var mittente=cmp.get('v.mittenteSelezionatoListaMitt');
        console.log('2-B ---> Salva modifiche mittente = ' + JSON.stringify(mittente));
        
        mittente['Principale__c']=cmp.get('v.isPrincipale');
         console.log('Provo Principale');
        console.log(cmp.get('v.isPrincipale'));
        mittente['Tipologia__c']=cmp.get('v.tipoMittente');
        mittente['Predefinito__c']=cmp.get('v.tipoMittente')=='INDIRIZZI PREDEFINITI';
        mittente['Autorita__c']=cmp.get('v.tipoMittente')=='AUTORITA';
        mittente['Name__c']=cmp.get('v.nomeCognomeMittente');
      
        mittente['Via__c']=cmp.get('v.indirizzoMittente');
        mittente['Citta__c']=cmp.get('v.cittaMittente');
        mittente['Provincia__c']=cmp.get('v.provinciaMittente');
        mittente['Codice_Postale__c']=cmp.get('v.capMittente');
        mittente['Salutation__c']=cmp.get('v.salutoMittente');
       
        console.log(mittente);
        console.log("******");
        var listaMittenti = cmp.get("v.mittentiList");
        for(var i=0; mittente.Name != null &&  i<listaMittenti.length; i++){
            if( listaMittenti[i].Name == mittente.Name){
                listaMittenti[i] = mittente;
                break;
            }
        }
      
        cmp.set('v.mittenteSelezionatoListaMitt',null);
        cmp.set('v.mittentiList',listaMittenti);
        cmp.set('v.stepInserimentoMittenti','main');
         console.log('Stampo lista mittenti alla fine');
        console.log(listaMittenti);
      
    },
    
    selectIndirizzoHelper:function(cmp){
        var indList=cmp.get('v.indirizziValues');
        var indSel=null;
        indList.forEach(function(temp){
            if(temp['Name__c']==cmp.get('v.indirizzoPredefinito')){
                indSel=temp;
                cmp.set('v.tipoMittente','INDIRIZZI PREDEFINITI');
                cmp.set('v.isPrincipale',indSel['Principale__c']);
                cmp.set('v.nomeCognomeMittente',indSel['Name__c']);
                cmp.set('v.indirizzoMittente',indSel['Indirizzo__c']);
                cmp.set('v.cittaMittente',indSel['Citta__c']);
                cmp.set('v.provinciaMittente',indSel['Provincia__c']);
                cmp.set('v.capMittente',indSel['Cap__c']);
                cmp.set('v.salutoMittente',indSel['Saluto__c']);                
                return;
            }
        });
        cmp.set('v.indirizzoPredefinitoMittente',indSel);
    },
    
    checkIfok:function(cmp){
        console.log('checkIfok START ');
        var attrList=['tipoMittente'];
        if(cmp.get('v.tipoMittente')=='INDIRIZZI PREDEFINITI'){
            attrList.push('indirizzoPredefinito');
        }
        for (let temp of attrList) {
            console.log('TempNAme: '+temp);
            console.log('valori f: ' + cmp.get('v.'+temp));

            
            
           if(cmp.get('v.'+temp)=="undefined" || cmp.get('v.'+temp)==null || cmp.get('v.'+temp)==''){               
                return false;
            }
           if (temp=='provinciaMittente' || temp=='indirizzoMittente') {
                if (cmp.get('v.'+temp).length<=1) {
                    return false;
                }
           }
            
        };
        var cmpCap = cmp.find("cap");
        var res= cmpCap.checkValidity();
        console.log('res capMittente: '+res);
        if (!res) {
            return false;
        }
        return true;
    },
})