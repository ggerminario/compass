({
    setOption : function(cmp,event) {
        cmp.set('v.radioOptions', [
            {label: '-None-', value: 'none'},
            {label: 'Si', value: true},           
            {label: 'No', value: false}
        ]);  

        cmp.set('v.columns', [
            { label: 'Selezionate', fieldName: 'label', type: 'text' }
        ]);

    },

    checkDecisioneVisible : function(cmp){
        console.log('checkDecisioneVisible');  
        var action=cmp.get('c.isDecisioneVisible');        
        var tipoReclamo = cmp.get('v.tipo');
        action.setParam('tipoReclamo_id',tipoReclamo);       
        action.setCallback(this,function(resp){
            if(resp.getState()=='SUCCESS'){ 
                var value = resp.getReturnValue();
                cmp.set('v.isDecisioneValue',value);
                console.log('checkDecisioneVisible value:'+value);  
            }
        });
        $A.enqueueAction(action); 
    },
    
    setInitValue : function(cmp,event,helper){
        console.log('init di chiusura');  
        var action=cmp.get('c.getInitValues');        
        var tipoReclamo = cmp.get('v.campiCase.Tipo_Reclamo__c');
        action.setParam('idcase',cmp.get('v.campiCase'));       
        action.setCallback(this,function(resp){
            if(resp.getState()=='SUCCESS'){ 
                var json = JSON.parse(resp.getReturnValue());
                console.log('json di risposta');
                console.log(json);  
                const mapAccolto = new Map(Object.entries(json.accolto));
                var obj = [];
                for (const [key, value] of mapAccolto.entries()) {
                    var item={
                        "label" : key,
                        "value" : value
                     }
                    obj.push(item);
                }
                cmp.set('v.accoltoList',obj);
 
                console.log('list accolto = ' + cmp.get('v.accoltoList'));
                
               
               
                const mapDecisione = new Map(Object.entries(json.decisione));
                var obj_dec = [];
                for (const [key, value] of mapDecisione.entries()) {
                    var item={
                        "label" : key,
                        "value" : value
                     }
//                     console.log('value:'+value+':isNan:'+isNaN(value))
                     if (tipoReclamo=='5412') {
                        // reclamo di tipo 'decisione'
                        if (isNaN(value)) {
                            // prendo solo i campi NON numerici ( ACCOLTO, PARZIALMENTE ACCOLTO....)
                             obj_dec.push(item);
                        }
                     } else {
                        //  reclamo di tipo DIVERSO da  'decisione'
                        if (!isNaN(value)) {
                            // prendo solo i campi numerici ( 0 -> NO , 1  -> SI)
                            obj_dec.push(item);
                        }
                     }
                    
                }

                cmp.set('v.decisioneList',obj_dec);
                 
                cmp.set('v.interventoMap',json.intervento);
                cmp.set('v.interventoAutList',Object.keys(cmp.get('v.interventoMap')));
                
                cmp.set('v.assicurazioniMap',json.assicurazioni);
                cmp.set('v.socAssList',Object.keys(cmp.get('v.assicurazioniMap')));
                
                cmp.set('v.recuperoMap',json.recupero);
                cmp.set('v.socRecList',Object.keys(cmp.get('v.recuperoMap')));
                
                cmp.set('v.sicMap',json.sic);
                cmp.set('v.sicList',Object.keys(cmp.get('v.sicMap')));
                
                this.setDataTable(cmp,event,helper);   
                // !!! dopo il caricamento delle map
                this.isClosed(cmp,event,helper);     
            }
        });
        
        $A.enqueueAction(action); 
    },
    setnewSicValueReadOnly : function(component, event, helper){

        var socRecValue = component.get('v.newSicValue');
        var map = component.get('v.sicList');
        var newSicValueReadOnly = component.get('v.newSicValueReadOnly');
        
        
        var s = '';
        if(socRecValue!=null && socRecValue!=undefined){
            socRecValue.split(';').forEach(function(item){
                var element = map[item];
                if(element!=undefined){
                    newSicValueReadOnly.push(element);
                }
            });
            var obj = [];
            for(var i = 0; i<newSicValueReadOnly.length;i++){
                var item = {
                    "label" : newSicValueReadOnly[i]
                }
                obj.push(item);
            }

            component.set('v.newSicValueReadOnly',obj);
        }

    },

    setnewSocAssValueReadOnly : function(component, event, helper){

        var socRecValue = component.get('v.newSocAssValue');
        var map = component.get('v.socAssList');
        var newSocAssValueReadOnly = component.get('v.newSocAssValueReadOnly');
        
        
        var s = '';
        console.log("socRecValue:"+socRecValue);
        if(socRecValue!=null && socRecValue!=undefined){
            socRecValue.split(';').forEach(function(item){
                var element = map[item];
                console.log("element:"+element);
                if(element!=undefined){
                    newSocAssValueReadOnly.push(element);
                }
            });
            var obj = [];
            for(var i = 0; i<newSocAssValueReadOnly.length;i++){
                var item = {
                    "label" : newSocAssValueReadOnly[i]
                }
                console.log("push item:"+item);
                obj.push(item);
            }

            component.set('v.newSocAssValueReadOnly',obj);
        }

    },
    setnewSocRecValueReadOnly : function(component, event, helper){

        var socRecValue = component.get('v.newSocRecValue');
        var map = component.get('v.socRecList');
        var newSocRecValueReadOnly = component.get('v.newSocRecValueReadOnly');
        
        
        var s = '';
        if(socRecValue!=null && socRecValue!=undefined){
            socRecValue.split(';').forEach(function(item){
                var element = map[item];
                if(element!=undefined){
                    newSocRecValueReadOnly.push(element);
                }
            });
            var obj = [];
            for(var i = 0; i<newSocRecValueReadOnly.length;i++){
                var item = {
                    "label" : newSocRecValueReadOnly[i]
                }
                obj.push(item);
            }

            component.set('v.newSocRecValueReadOnly',obj);
        }

    },
    
    setDataTable : function(cmp,event,helper){

        
        var arraySic = [];
        cmp.get('v.sicList').forEach(function(item){
            arraySic.push({'column1':item});            
        });                
        cmp.set('v.sicData',arraySic);
        cmp.set('v.sicColumns',[
            {label:'SIC',fieldName:'column1',type:'text'}
        ]); 
        
        var arraySocAss = [];
        cmp.get('v.socAssList').forEach(function(item){
            arraySocAss.push({'column1':item});            
        });                
        cmp.set('v.socAssData',arraySocAss);
        cmp.set('v.socAssColumns',[
            {label:'Società assicurazione',fieldName:'column1',type:'text'}
        ]);
        
        var arraySocRec = [];
        cmp.get('v.socRecList').forEach(function(item){
            arraySocRec.push({'column1':item});            
        });                
        cmp.set('v.socRecData',arraySocRec);
        cmp.set('v.socRecColumns',[
            {label:'Società di recupero',fieldName:'column1',type:'text'}
        ]);        
    },

    getCaseResponsabilita : function(component, event, helper){

        console.log('getCaseResponsabilita START');
        var idCase = component.get('v.recordId');
        var action2 = component.get('c.getHasResponsabilita');
//        var statoIniziale = component.get('v.statoIniziale');
//        var statoAttuale = component.get('v.statoAttuale');
        var risarcimentoValues =  component.get('v.risarcimentoValues');
        action2.setParams({
            idCase : idCase
        });

        action2.setCallback(this,function(response2){

            
            if(response2.getState() === 'SUCCESS'){
                var resp2 = response2.getReturnValue();
                console.log('getReclamoResponsabilita:'+resp2);
                // serve a gestire un default di NONE sulla combo responsabilita
                console.log('getCaseResponsabilita risarcimentoValues:'+risarcimentoValues);
                if(risarcimentoValues!=null && risarcimentoValues != 'none') {
                    component.set("v.respValue",resp2);
                    component.set("v.respValues",resp2);
                }
                if(resp2!=null){
     
                    this.getResponsabilitaValues(component,event,helper);
                    this.setResponsabilitaValues(component,event,helper);
   
                }

            }
            
        });
        $A.enqueueAction(action2);



    },

    setResponsabilitaValues : function(component, event, helper){

        console.log('setResponsabilitaValues START');
        var societa = component.get('v.campiCase.Referenced_Company__c');
        var idCase = component.get('v.recordId');
        var action = component.get('c.setValoriResponsabilita');
        
        action.setParams({
            societa : societa,
            idCase : idCase
        });

        action.setCallback(this,function(response){

            var respList = response.getReturnValue();
            
            if(response.getState() === 'SUCCESS'){
                var str=[];
                var str2=[];
                var itemSelezionati=[];
                var readOnly = component.get('v.readOnly2');

                if(readOnly){
                    console.log('setResponsabilitaValues readOnly');
                    for(var j=0; j<respList.length; j++){

                        var s = respList[j].Name__c;
                        var lngth = [];
                        lngth = s.split(' ');

                        if(lngth.length>3){

                            var finalStr = '';
                            var ptint = parseInt((lngth.length/2));
                            
                            for(var i = 0; i < lngth.length; i++){
                            
                                if(i < ptint){
                                    finalStr+= lngth[i] +' ';
                                }else if(i == ptint){
                                    finalStr+= lngth[i] +'\n';
                                }else{
                                    finalStr+= lngth[i] +' ';
                                }
                            }

                            respList[j].Name__c = finalStr;

                        }

                        var item = {
                            "label": respList[j].Name__c,
                            "value": respList[j].Id
                        };
                        str.push(item);
                        itemSelezionati.push(item);
                        str2.push(item.Name__c);
                    }

                }else{
                    console.log('setResponsabilitaValues NOT readOnly');
                    for(var j=0; j<respList.length; j++){
                        var item = respList[j].Id;
                        var itemSelezionato = respList[j];
                        str.push(item);
                        itemSelezionati.push(itemSelezionato);
                    }
                }
                component.set('v.respSelected',str);
                component.set('v.respSelectedReadOnly',str2);
                component.set('v.itemSelezionati',itemSelezionati);
                console.log('v.respSelected:'+str);
                console.log('v.respSelectedReadOnly:'+str2);
                console.log('v.itemSelezionati'+itemSelezionati);

            }

        });
        $A.enqueueAction(action);

    },

    getResponsabilitaValues : function(component, event, helper){
        //  partendo da una lista di responsabilità in input , decodifica label (name__c) / value (ID) delle responsabilità
        console.log('@@@ take responsabilities');
        var respSelected = component.get('v.respSelected');
        var societa = component.get('v.campiCase.Referenced_Company__c');
        
        
        var action3 = component.get('c.getResponsabilita');
        
        action3.setParams({
            societa : societa,
            respSelected : respSelected
        });

        action3.setCallback(this,function(response3){

            var respList = response3.getReturnValue();
            
            if(response3.getState() === 'SUCCESS'){
                var obj = [];

                for(var j=0; j<respList.length; j++){

                    var s = respList[j].Name__c;
                    var lngth = [];
                    lngth = s.split(' ');
                    
                    if(lngth.length>3){

                        var finalStr = '';
                        var ptint = parseInt((lngth.length/2));
                        
                        for(var i = 0; i < lngth.length; i++){
                        
                            if(i < ptint){
                                finalStr+= lngth[i] +' ';
                            }else if(i == ptint){
                                finalStr+= lngth[i] +'\n';
                            }else{
                                finalStr+= lngth[i] +' ';
                            }
                        }

                        respList[j].Name__c = finalStr;

                    }

                    var item = {
                        "label": respList[i].Name__c,
                        "value": respList[i].Id,
                    };
                    obj.push(item);

                }


                component.set('v.responsabilitaList',obj);
                
                component.set('v.respSelected',null);
                component.set('v.respSelected',respSelected);
                var g = component.get('v.respSelected');
                
                
                var str = [];
                var readOnly = component.get('v.readOnly2');

                if(readOnly){

                    for(var j=0; j<respSelected.length; j++){

                        var s = respSelected[j].Name__c;
                        var lngth = [];
                        lngth = s.split(' ');

                        if(lngth.length>3){
                            var finalStr = '';
                            var ptint = parseInt((lngth.length/2));
                            
                            for(var i = 0; i < lngth.length; i++){
                            
                                if(i < ptint){
                                    finalStr+= lngth[i] +' ';
                                }else if(i == ptint){
                                    finalStr+= lngth[i] +'\n';
                                }else{
                                    finalStr+= lngth[i] +' ';
                                }
                            }

                            respSelected[j].Name__c = finalStr;

                        }

                        var item = {
                            "label": respSelected[j].Name__c,
                            "value": respSelected[j].Id,
                        };
                        str.push(item);
                    }

                }else{

                    for(var j=0; j<respSelected.length; j++){
                        var item = respSelected[j].Id;
                       
                        str.push(item);
                    }
                }
                
                component.set('v.respSelected',str);
                component.set('v.respSelected',str);
                console.log('@@@ take  respSelected:'+ component.get('v.respSelected'));
                
            }


        });
        $A.enqueueAction(action3);


    },
    
    setResponsabilita : function(component, event, helper){
        // evento di selezione delle responsabilità
        console.log('@@@ setResponsabilita START');
        var selectedOptionValue = event.getParam("value");
        

  
        component.set('v.respSelectedTemp',selectedOptionValue);
        //component.set("v.respSelected",selectedOptionValue);
        console.log('@@@ setResponsabilita respSelectedTemp:'+selectedOptionValue);

        

        var responsabilitaList = component.get('v.responsabilitaList');
        var itemSelezionati = [];
        console.log('@@@ setResponsabilita selectedOptionValue:'+selectedOptionValue);
        if (selectedOptionValue!=null) {
            for(var j=0; j<selectedOptionValue.length; j++){
                var trovato = false;
                for(var i=0; i<responsabilitaList.length; i++){
                    trovato = true;
                    if(responsabilitaList[i].value==selectedOptionValue[j]){
//                          console.log('@@@ setResponsabilita found:'+responsabilitaList[i].value+'::'+responsabilitaList[i].label);
                        trovato = true; 
                        var item = {};
                        item.Name__c = responsabilitaList[i].label;
                        item.Id = responsabilitaList[i].value;                          
                        itemSelezionati.push(item);                            
                    } 
                }
            }
        }
        component.set('v.itemSelezionati',itemSelezionati);
    },

    getResponsabilitaValues2 : function(component, event, helper){
        // funzione di ricerca di tutti i valori delle responsabilità in base a filtro di ricerca
        console.log('@@@ getResponsabilitaValues2 START');
   
           // filtro per la ricerca delle responsabilità
           var respValueToFound = component.find("searchResp").get("v.value");
           //var respValueToFound = '';

            var societa = component.get('v.campiCase.Referenced_Company__c');
                    
            var action = component.get('c.getResponsabilitaSearched');

            action.setParams({
                societa : societa,
                respValueToFound : respValueToFound
            });

            action.setCallback(this,function(response){

                var respList = response.getReturnValue();
                
                if(response.getState() === 'SUCCESS'){
                    var obj = [];
 
                    for(var j=0; j<respList.length; j++){

                        var s = respList[j].Name__c;
                        var lngth = [];
                        lngth = s.split(' ');

                        if(lngth.length>3){
                            var finalStr = '';
                            var ptint = parseInt((lngth.length/2));
                            
                            for(var i = 0; i < lngth.length; i++){
                            
                                if(i < ptint){
                                    finalStr+= lngth[i] +' ';
                                }else if(i == ptint){
                                    finalStr+= lngth[i] +'\n';
                                }else{
                                    finalStr+= lngth[i] +' ';
                                }
                            }

                            respList[j].Name__c =  finalStr; 
                        }
                        var item = {
                            "label": respList[j].Name__c,
                            "value": respList[j].Id
                        };
                        obj.push(item);
                        
                    }

 
                    var itemSelezionati = component.get('v.itemSelezionati');
                    console.log('@@@ getResponsabilitaValues2 itemSelezionati:'+itemSelezionati);
                    if (itemSelezionati!=null) {
                        for(var j=0; j<itemSelezionati.length; j++){
                            var item = itemSelezionati[j];
                            var option =  {
                                "label": item.Name__c,
                                "value": item.Id
                            };
 //                           console.log('@@@ getResponsabilitaValues2 itemSelezionati item:'+item.Name__c);
 //                           console.log('@@@ getResponsabilitaValues2 itemSelezionati item:'+item.Id);
                            obj.push(option);
                        }
                    }
                    component.set('v.responsabilitaList',obj);
                }


            });
            $A.enqueueAction(action);
 
    },

    //CREATE CASE IDM 
    createCase : function(component, event, helper){

        var idCase = component.get('v.recordId');
        var selectedFile = component.get('v.allegatiSelezionati');
        var action = component.get('c.createRecordCaseIDM');
        
        action.setParams({
            idCase : idCase,
            selectedFile : selectedFile
        });

        action.setCallback(this,function(response){
            var resp = response.getState();
            if(resp === 'SUCCESS'){
                var status = response.getReturnValue();
                if(status!=null){
                    component.set('v.status',status);
                }
                console.log('case copied successfully');
            }else{
                console.log('error on copy case');
            }

        });
        $A.enqueueAction(action);
    },
    
    showToastSuccess: function(component) {
        component.find('notifLib').showToast({
            "title": "Success",
            "message": component.get("v.toastMsg"),
            "variant": "success"
        });
    },
    
    showToastError: function(component) {
        component.find('notifLib').showToast({
            "title": "Error",
            "message": component.get("v.toastMsg"),
            "variant": "error"
        });
    },
    
    isClosed: function(cmp,event,helper){
        var action = cmp.get("c.getCase");
        var tipoReclamo = cmp.get('v.campiCase.Tipo_Reclamo__c');
        action.setParam('recordId',cmp.get('v.recordId'));
        action.setCallback(this,function(resp){
            if(resp.getState()=='SUCCESS'){
                var status = resp.getReturnValue()['Status'];
                var readOnly = (status=='Gestito' || status=='Stampa IDM');

                var esistePrevalorizzazione = (resp.getReturnValue()['Accolto__c']!=null?true:false)
                if(readOnly || esistePrevalorizzazione){
                    
                    var abbuonoValue = resp.getReturnValue()['Abbuono_Chiusura__c'];
                    if(abbuonoValue){
                        cmp.set('v.abbuonoValue',resp.getReturnValue()['Abbuono_Chiusura__c']);
                        cmp.set('v.abbuonoImportoValue',resp.getReturnValue()['Importo_Abbouno_Chiusura__c']);
                    }
                    cmp.set('v.abbuonoValues',abbuonoValue);
                    var rimborsoValue = resp.getReturnValue()['Has_Rimborso_Accordato__c'];
                    if(rimborsoValue){
                        cmp.set('v.rimborsoValue',resp.getReturnValue()['Has_Rimborso_Accordato__c']);
                        cmp.set('v.rimborsoImportoValue',resp.getReturnValue()['Rimborso_Accordato_Importo__c']); 
                    }
                    cmp.set('v.rimborsoValues',rimborsoValue);
                    
                    var rimborsoCommValue = resp.getReturnValue()['F_Has_Rimborso_Commissioni_Out__c'];
                    if(rimborsoCommValue){
                        cmp.set('v.rimborsoCommValue',resp.getReturnValue()['F_Has_Rimborso_Commissioni_Out__c']);
                        cmp.set('v.rimborsoImportoCommValue',resp.getReturnValue()['F_Rimborso_Commissioni_Importo_Out__c']);
                    }
                    cmp.set('v.rimborsoCommValues',rimborsoCommValue);
                    var rimborsoProvValue = resp.getReturnValue()['F_Has_Rimborso_Provvigioni_Out__c'];
                    if(rimborsoProvValue){
                        cmp.set('v.rimborsoProvValue',resp.getReturnValue()['F_Has_Rimborso_Provvigioni_Out__c']);
                        cmp.set('v.rimborsoImportoProvValue',resp.getReturnValue()['F_Rimborso_Provvigioni_Importo_Out__c']);
                    }
                    cmp.set('v.rimborsoProvValues',rimborsoProvValue);
                    
                    var rimborsoVarValue = resp.getReturnValue()['F_Has_Rimborso_Varie_Out__c'];
                    if(rimborsoVarValue){
                        cmp.set('v.rimborsoVarValue',resp.getReturnValue()['F_Has_Rimborso_Varie_Out__c']);
                        cmp.set('v.rimborsoImportoVarValue',resp.getReturnValue()['F_Rimborso_Varie_Importo_Out__c']);
                    }
                    cmp.set('v.rimborsoVarValues',rimborsoVarValue);
                    
                    var rimborsoPremValue = resp.getReturnValue()['F_Has_Rimborso_Assicurativo_Out__c'];
                    if(rimborsoPremValue){
                        cmp.set('v.rimborsoPremValue',resp.getReturnValue()['F_Has_Rimborso_Assicurativo_Out__c']);
                        cmp.set('v.rimborsoImportoPremValue',resp.getReturnValue()['F_Rimborso_Assicurativo_Importo_Out__c']);
                    }
                    cmp.set('v.rimborsoPremValues',rimborsoPremValue);
                    
                    var rimborsoLegValue = resp.getReturnValue()['F_Has_Rimborso_Spese_Legali_Out__c'];
                    if(rimborsoLegValue){
                        cmp.set('v.rimborsoLegValue',resp.getReturnValue()['F_Has_Rimborso_Spese_Legali_Out__c']);
                        cmp.set('v.rimborsoImportoLegValue',resp.getReturnValue()['F_Rimborso_Spese_Legali_Importo_Out__c']);
                    }
                    cmp.set('v.rimborsoLegValues',rimborsoLegValue);
                    
                    var risarcimentoValue = resp.getReturnValue()['Has_Risarcimento_accordato__c'];
                    if(risarcimentoValue){
                        cmp.set('v.risarcimentoValue',resp.getReturnValue()['Has_Risarcimento_accordato__c']);
                        cmp.set('v.risarcimentoImportoValue',resp.getReturnValue()['Risarcimento_Accordato_Importo__c']);
                    }
                    cmp.set('v.risarcimentoValues',risarcimentoValue);
                    cmp.set('v.fondatoValue',resp.getReturnValue()['Has_Fondato__c']);  
                    cmp.set('v.fondatoValues',resp.getReturnValue()['Has_Fondato__c']); 
                    cmp.set('v.allegatiCompletiValue',resp.getReturnValue()['Has_Allegati_Completi__c']);
                    cmp.set('v.allegatiCompletiValues',resp.getReturnValue()['Has_Allegati_Completi__c']);
                    cmp.set('v.sicValue',resp.getReturnValue()['Has_SIC__c']);
                    cmp.set('v.sicValues',resp.getReturnValue()['Has_SIC__c']);
                    
                    cmp.set('v.socAssValue',resp.getReturnValue()['Has_Assicurative__c']);
                    cmp.set('v.socAssValues',resp.getReturnValue()['Has_Assicurative__c']);
                    
                    cmp.set('v.socRecValue',resp.getReturnValue()['Has_Recupero__c']);
                    cmp.set('v.socRecValues',resp.getReturnValue()['Has_Recupero__c']); 
                    
                    cmp.set('v.riscontroValue',resp.getReturnValue()['Attesa_Riscontro_Cliente__c']);
                    cmp.set('v.riscontroValues',resp.getReturnValue()['Attesa_Riscontro_Cliente__c']);
                    
                    cmp.set('v.idmValue',resp.getReturnValue()['Has_Invio_Risposta_IDM__c']);
                    cmp.set('v.idmValues',resp.getReturnValue()['Has_Invio_Risposta_IDM__c']);
                    
                    cmp.set('v.attesaValue',resp.getReturnValue()['Attesa_Assegno__c']);
                    cmp.set('v.attesaValues',resp.getReturnValue()['Attesa_Assegno__c']);
                    //cmp.set('v.readOnly2', true);
                    
                }
                // Mi prendo i valori delle picklist (accolto, decisione, interventoAutorita) in  questo modo: l'init mi ritorna il developer name delle picklist,
                // vado a crearmi una mappa dove inverto chiave e valore (della mappa iniziale), e mostro la label
                
                //- - - - - -ACCOLTO -- - - - - -
                var mapds = cmp.get('v.accoltoList');    
//                console.log('mapds :'+mapds); 
                for (var i=0;i<mapds.length;i++) {
                    var item =  mapds[i];
                    var label = item.label;
                    var value = item.value;
                    if (value!=null && value == resp.getReturnValue()['Accolto__c']) {
                        cmp.set('v.accoltoDettagli', value); 
                    }
                }
 
                console.log('resp.getReturnValue()[Accolto__c}:'+resp.getReturnValue()['Accolto__c']);             
                console.log(' accoltoDettagli:'+ cmp.get('v.accoltoDettagli'));  
                // - - - - -FINE ACCOLTO - - - - 
                //- - - - - - DECISIONE    - - - - -                
                var map_dec = cmp.get('v.decisioneList');    
//                console.log('mapds :'+map_dec); 
                for (var i=0;i<map_dec.length;i++) {
                    var item =  map_dec[i];
                    var label = item.label;
                    var value = item.value;
                    if (value!=null && value == resp.getReturnValue()['Decisione__c']) {
                        cmp.set('v.decisioneDettagli', value); 
                    }
                }
                console.log('resp.getReturnValue()[Decisione__c]:'+resp.getReturnValue()['Decisione__c']);             
                console.log('decisioneDettagli:'+ cmp.get('v.decisioneDettagli'));  
 
                // - - - - FINE DECISIONE- - - - -
                
                // - - - - -INTERVENTO - - - - -
                var mapIntervento = cmp.get('v.interventoMap');                                          
                var reversedMapIntervento = {};
                var listIntervento = cmp.get('v.interventoAutList');
                
                listIntervento.forEach(function(item){                  
                    reversedMapIntervento[mapIntervento[item]] = item;
                });
                
                cmp.set('v.interventoReversedMap', reversedMapIntervento);                
                cmp.set('v.interventoAutDettagli', reversedMapIntervento[resp.getReturnValue()['Intervento_Autorita__c']]);    
                
                if(reversedMapIntervento[resp.getReturnValue()['Intervento_Autorita__c']])
                    cmp.set('v.interventoAutDettagliInit', reversedMapIntervento[resp.getReturnValue()['Intervento_Autorita__c']]);
                else
                    cmp.set('v.interventoAutDettagliInit', 'Seleziona'); 
                //- - - -FINE INTERVENTO - - - - -
                
                cmp.set('v.newSocRecValue',resp.getReturnValue()['Societa_di_Recupero__c']);
                cmp.set('v.newSocAssValue',resp.getReturnValue()['Societa_Assicurative__c']);                
                cmp.set('v.newSicValue',resp.getReturnValue()['SIC__c']); 
                
                this.setnewSicValueReadOnly(cmp,event,helper);
                this.setnewSocAssValueReadOnly(cmp,event,helper);
                this.setnewSocRecValueReadOnly(cmp,event,helper);
                
                //controllo il tipo reclamo (ripreso codice precedente)
                if(tipoReclamo =='5446' ||tipoReclamo =='5409' || tipoReclamo =='5445'|| tipoReclamo =='5410'){
                    cmp.set('v.isInterventoAutorita',true);
                }
                console.log('success');
                
                //RESPONSABILITA
                this.getCaseResponsabilita(cmp,event,helper);
                
            }
            else
                console.log('error');
            cmp.set('v.isInit', false);
        });
        $A.enqueueAction(action);
    }

    
})