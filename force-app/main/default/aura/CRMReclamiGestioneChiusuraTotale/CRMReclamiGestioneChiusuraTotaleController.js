({
    init : function(cmp,event,helper){
        cmp.set('v.isInit', true);
        cmp.set('v.tabChiusura',true);
        helper.setOption(cmp);
        helper.setInitValue(cmp);
        helper.checkDecisioneVisible(cmp);
        
    },
    handleChangeTipoReclamo  : function(cmp,event,helper){
        helper.checkDecisioneVisible(cmp);
    },
    refresh : function(cmp,event,helper){  
        var params = event.getParam('arguments');
        var status = null;
        if (params) {
            status = params.statusReclamo;
 //          console.log('refresh status:'+status)
        }
        var readOnly = (status=='Gestito' || status=='Stampa IDM');  
        var respvalue =  cmp.get('v.respSelected');
//        console.log('refresh respValue:'+ cmp.get('v.respValue')); 
//        console.log('refresh respSelected:'+ respvalue); 
  //      console.log('refresh responsabilitaList:'+ cmp.get('v.responsabilitaList')); 
        
        if (readOnly) {
            if (respvalue!=null && respvalue.length>0) {
                
                var str = [];
                
                var responsabilitaList = cmp.get('v.responsabilitaList');
                for (var k=0;k<respvalue.length;k++) {
                    console.log('refresh res:'+respvalue[k]);
                    if (responsabilitaList!=null) {
                        for (var j=0;j<responsabilitaList.length;j++) { 
                            if(responsabilitaList[j].value == respvalue[k]) {
                               
                                str.push(responsabilitaList[j]);
                            }
                        }
                    }
                }
                cmp.set('v.respSelected',str); 
            }
        }
       
        console.log('refresh respSelected:'+ cmp.get('v.respSelected')); 
        //cmp.set('v.readOnly2', readOnly); 
        console.log('refresh end');   
    },

    salvaReclamo : function(cmp, event, helper) {
        console.log('salvo il reclamo di chiusura totale!');
        // definisco tutti gli auramethod in modo tale da ritornare true se la response è andata a buon fine,
        // altrimenti false. con questo posso gestirmi la gestione degli errori dei vari aura method e controllare
        // dove avviene l'errore.
        var res = true;
        
        
        
        //Prendo le label delle picklist e le trasformo in API name prima di passarle al server
        var mapIntervento = cmp.get('v.interventoMap');
        var interventoDet = cmp.get('v.interventoAutDettagli');    
        //var decisioneDet = cmp.get('v.decisioneDettagli');        
        cmp.set('v.interventoInput',mapIntervento[interventoDet]);
        
        //controllo i valori per le datatable...se non controllo e l utente non cambia niente
        //viene selezionato null di default e ciò non va bene
        
        if(cmp.get('v.sicInput')  == -999){            
            cmp.set('v.sicInput',cmp.get('v.sicInit'));
        }
        
        if(cmp.get('v.socAssInput')  == -999){  
            cmp.set('v.socAssInput',cmp.get('v.socAssInit'));
        }
        
        if(cmp.get('v.socRecInput')  == -999){
            cmp.set('v.socRecInput',cmp.get('v.socRecInit'));
        }
        
        var action = cmp.get("c.salvaChiusuraReclamo");       
        action.setParams({
            'recordId' : cmp.get('v.recordId'),
            'isAbbuono' : cmp.get('v.abbuonoValue'),
            'abbuonoImporto' : cmp.get('v.abbuonoImportoValue'),
            'isRimborso' : cmp.get('v.rimborsoValue'),
            'rimborsoImporto' : cmp.get('v.rimborsoImportoValue'),
            'isRimborsoComm' : cmp.get('v.rimborsoCommValue'),
            'rimborsoImportoComm' : cmp.get('v.rimborsoImportoCommValue'),
            'isRimborsoProv' : cmp.get('v.rimborsoProvValue'),
            'rimborsoImportoProv' : cmp.get('v.rimborsoImportoProvValue'),
            'isRimborsoPrem' : cmp.get('v.rimborsoPremValue'),
            'rimborsoImportoPrem' : cmp.get('v.rimborsoImportoPremValue'),
            'isRimborsoVar' : cmp.get('v.rimborsoVarValue'),
            'rimborsoImportoVar' : cmp.get('v.rimborsoImportoVarValue'),
            'isRimborsoLeg' : cmp.get('v.rimborsoLegValue'),
            'rimborsoImportoLeg' : cmp.get('v.rimborsoImportoLegValue'),
            'isRisarcimento' : cmp.get('v.risarcimentoValue'),
            'risarcimentoImportoValue' : cmp.get('v.risarcimentoImportoValue'),
            'isFondato' : cmp.get('v.fondatoValue'),
            'accolto' : cmp.get('v.accoltoDettagli'),
            'isAllegatiCompleti' : cmp.get('v.allegatiCompletiValue'),
            'isSic' : cmp.get('v.sicValue'),
            'sic' : cmp.get('v.newSicValue'),
            'isSocAss' : cmp.get('v.socAssValue'),
            'socAss' : cmp.get('v.newSocAssValue'),
            'isSocRec' : cmp.get('v.socRecValue'),
            'socRec' : cmp.get('v.newSocRecValue'),
            'isIdm' : cmp.get('v.idmValue'),
            'isRiscontro' : cmp.get('v.riscontroValue'),
            'isAssegno' : cmp.get('v.attesaValue'),
            'decisione' : cmp.get('v.decisioneDettagli'),
            'autorita' : cmp.get('v.interventoInput')            
        });
        action.setCallback(this,function(resp){
            if(resp.getState()=='SUCCESS'){
                //alert('Salvataggio Chiusura Avvenuto');
                cmp.set("v.toastMsg", "Salvataggio Chiusura Avvenuto");
                helper.showToastSuccess(cmp);
                res = true;
            }
            else{
                //alert('Ci sono problemi con il salvataggio di chiusura');
                cmp.set("v.toastMsg", "Ci sono problemi con il salvataggio di chiusura");
                helper.showToastError(cmp);
            	res = false;
            }
        });
        
        $A.enqueueAction(action); 
        return res;
    },
    
    //trasformo in boolean tutti i valori dei RadioButton e setto a zero l'importo dei valori
    //numerici corrispondeni qualora si selezioni "No" 
    //(questo perchè non ha senso la casistica: Rimborso? "No", ImportoRimborso : 1000$)
    
    handleAbbuono: function(cmp,event,helper){
        cmp.set('v.abbuonoImportoValue',0);
        if(event.getParam("value") == 'false'){
            cmp.set('v.abbuonoValue', false);
            cmp.set('v.abbuonoValues', false);
            cmp.set('v.abbuonoImportoValue',0);
        }
        else if(event.getParam("value") == 'true'){
            cmp.set('v.abbuonoValue', true);
            cmp.set('v.abbuonoValues', true);
        }else{
            cmp.set('v.abbuonoValue', false);
            cmp.set('v.abbuonoValues', 'none');
            cmp.set('v.abbuonoImportoValue',0);
        }

        
    },
    
    handleRimborso: function(cmp,event,helper){
        cmp.set('v.rimborsoImportoValue',0);
        if(event.getParam("value") == 'false'){
            cmp.set('v.rimborsoValue', false);
            cmp.set('v.rimborsoValues', false);
            cmp.set('v.rimborsoImportoValue',0);
        }
        else if(event.getParam("value") == 'true'){
            cmp.set('v.rimborsoValue', true);
            cmp.set('v.rimborsoValues', true);
        }else{
            cmp.set('v.rimborsoValue', false);
            cmp.set('v.rimborsoValues', 'none');
            cmp.set('v.rimborsoImportoValue',0);
        }

        
    },
    
    handleRimborsoComm: function(cmp,event,helper){
        cmp.set('v.rimborsoImportoCommValue',0);
        if(event.getParam("value") == 'false'){
            cmp.set('v.rimborsoCommValue', false);
            cmp.set('v.rimborsoCommValues', false);
            cmp.set('v.rimborsoImportoCommValue',0);
        }
        else if(event.getParam("value") == 'true'){
            cmp.set('v.rimborsoCommValue', true);
            cmp.set('v.rimborsoCommValues', true);

        }else{
            cmp.set('v.rimborsoCommValue', false);
            cmp.set('v.rimborsoCommValues', 'none');
            cmp.set('v.rimborsoImportoCommValue',0);
        }

        

    },
    
    handleRimborsoProv: function(cmp,event,helper){
        cmp.set('v.rimborsoImportoProvValue',0);
        if(event.getParam("value") == 'false'){
            cmp.set('v.rimborsoProvValue', false);
            cmp.set('v.rimborsoProvValues', false);
            cmp.set('v.rimborsoImportoProvValue',0);
        }
        else if(event.getParam("value") == 'true'){
            cmp.set('v.rimborsoProvValue', true);
            cmp.set('v.rimborsoProvValues', true);

        }else{
            cmp.set('v.rimborsoProvValue', false);
            cmp.set('v.rimborsoProvValues', 'none');
            cmp.set('v.rimborsoImportoProvValue',0);
        }

        
    },
    
    handleRimborsoPrem: function(cmp,event,helper){
        cmp.set('v.rimborsoImportoPremValue',0);
        if(event.getParam("value") == 'false'){
            cmp.set('v.rimborsoPremValue', false);
            cmp.set('v.rimborsoPremValues', false);
            cmp.set('v.rimborsoImportoPremValue',0);
        }
        else if(event.getParam("value") == 'true'){
            cmp.set('v.rimborsoPremValue', true);
            cmp.set('v.rimborsoPremValues', true);

        }else{
            cmp.set('v.rimborsoPremValue', false);
            cmp.set('v.rimborsoPremValues', 'none');
            cmp.set('v.rimborsoImportoPremValue',0);
        }

        
    },
    
    handleRimborsoVar: function(cmp,event,helper){
        cmp.set('v.rimborsoImportoVarValue',0);
        if(event.getParam("value") == 'false'){
            cmp.set('v.rimborsoVarValue', false);
            cmp.set('v.rimborsoVarValues', false);
            cmp.set('v.rimborsoImportoVarValue',0);
        }
        else if(event.getParam("value") == 'true'){
            cmp.set('v.rimborsoVarValue', true);
            cmp.set('v.rimborsoVarValues', true);

        }else{
            cmp.set('v.rimborsoVarValue', false);
            cmp.set('v.rimborsoVarValues', 'none');
            cmp.set('v.rimborsoImportoVarValue',0);
        }

        
    },
    
    handleRimborsoLeg: function(cmp,event,helper){
        cmp.set('v.rimborsoImportoLegValue',0);
        if(event.getParam("value") == 'false'){
            cmp.set('v.rimborsoLegValue', false);
            cmp.set('v.rimborsoLegValues', false);
            cmp.set('v.rimborsoImportoLegValue',0);
        }
        else if(event.getParam("value") == 'true'){
            cmp.set('v.rimborsoLegValue', true);
            cmp.set('v.rimborsoLegValues', true);

        }else{
            cmp.set('v.rimborsoLegValue', false);
            cmp.set('v.rimborsoLegValues', 'none');
            cmp.set('v.rimborsoImportoLegValue',0);
        }

        
    },
    
    handleRisarcimento: function(cmp,event,helper){
        cmp.set('v.risarcimentoImportoValue',0);
        if(event.getParam("value") == 'false'){
            cmp.set('v.risarcimentoValue', false);
            cmp.set('v.risarcimentoValues', false);
            cmp.set('v.risarcimentoImportoValue',0);
        }
        else if(event.getParam("value") == 'true'){
            cmp.set('v.risarcimentoValue', true);
            cmp.set('v.risarcimentoValues', true);

        }else{
            cmp.set('v.risarcimentoValue', false);
            cmp.set('v.risarcimentoValues', 'none');
            cmp.set('v.risarcimentoImportoValue',0);
        }

        
    },
    
    handleFondato: function(cmp,event,helper){
        if(event.getParam("value") == 'false'){
            cmp.set('v.fondatoValue', false);
            cmp.set('v.fondatoValues', false);
        }   
        else if(event.getParam("value") == 'true'){
            cmp.set('v.fondatoValue', true);
            cmp.set('v.fondatoValues', true);

        }else{
            cmp.set('v.fondatoValue', false);
            cmp.set('v.fondatoValues', 'none');
        }

        
    },
    
    handleAllegatiCompleti : function(cmp,event,helper){
        if(event.getParam("value") == 'false'){
            cmp.set('v.allegatiCompletiValue', false); 
            cmp.set('v.allegatiCompletiValues', false);  
        }
        else if(event.getParam("value") == 'true'){
            cmp.set('v.allegatiCompletiValue', true);
            cmp.set('v.allegatiCompletiValues', true);
        }else{
            cmp.set('v.allegatiCompletiValue', false);
            cmp.set('v.allegatiCompletiValues', 'none');
        }

        
    },
    
    handleSic : function(cmp,event,helper){
        if(event.getParam("value") == 'false'){
            cmp.set('v.sicValue', false);  
            cmp.set('v.sicValues', false);
        } 
        else if(event.getParam("value") == 'true'){
            cmp.set('v.sicValue', true);
            cmp.set('v.sicValues', true);
        }else{
            cmp.set('v.sicValue', false);
            cmp.set('v.sicValue', 'none');
        }

        
    },
    
    handleSocAss : function(cmp,event,helper){
        if(event.getParam("value") == 'false'){
            cmp.set('v.socAssValue', false); 
            cmp.set('v.socAssValues', false);  
        }
        else if(event.getParam("value") == 'true'){
            cmp.set('v.socAssValue', true);
            cmp.set('v.socAssValues', true);

        }else{
            cmp.set('v.socAssValue', false);
            cmp.set('v.socAssValues', 'none');
        }

        
    },
    
    handleSocRec : function(cmp,event,helper){
        if(event.getParam("value") == 'false'){
            cmp.set('v.socRecValue', false);
            cmp.set('v.socRecValues', false); 
        }   
        else if(event.getParam("value") == 'true'){
            cmp.set('v.socRecValue', true);
            cmp.set('v.socRecValues', true);

        }else{
            cmp.set('v.socRecValue', false);
            cmp.set('v.socRecValues', 'none');
        }

        
    },
    
    handleIdmValue : function(cmp,event,helper){
        
        if(event.getParam("value") == 'false'){
            cmp.set('v.idmValue', false); 
            cmp.set('v.idmValues', false);
        }
        else if(event.getParam("value") == 'true'){
            cmp.set('v.idmValue', true);
            cmp.set('v.idmValues', true);

        }else{
            cmp.set('v.idmValue', false);
            cmp.set('v.idmValues', 'none');
        }

       
            
    },
    
    handleRiscontroValue : function(cmp,event,helper){
        if(event.getParam("value") == 'false'){
            cmp.set('v.riscontroValue', false);
            cmp.set('v.riscontroValues', false);   
        }
        else if(event.getParam("value") == 'true'){
            cmp.set('v.riscontroValue', true);
            cmp.set('v.riscontroValues', true);

        }else{
            cmp.set('v.riscontroValue', false);
            cmp.set('v.riscontroValues', 'none');
        }

        
    },
    
    handleAttesaValue : function(cmp,event,helper){
        if(event.getParam("value") == 'false'){
            cmp.set('v.attesaValue', false); 
            cmp.set('v.attesaValues', false);
        }  
        else if(event.getParam("value") == 'true'){
            cmp.set('v.attesaValue', true);
            cmp.set('v.attesaValues', true);

        }else{
            cmp.set('v.attesaValue', false);
            cmp.set('v.attesaValues', 'none');
        }

        
    },

    handleDecisione : function(cmp,event,helper){
        if(event.getParam("value") == 'false'){
            cmp.set('v.decisioneDettagli', false); 
            
        }  
        else if(event.getParam("value") == 'true'){
            cmp.set('v.decisioneDettagli', true);
           

        }else{
            cmp.set('v.decisioneDettagli', 'none');
        }
        
    },
    
    getSelectedSocRec : function(cmp,event){
        var selectedRows = event.getParam('selectedRows');
        var socRecApiMap = cmp.get('v.recuperoMap');
        var x = '';        
        selectedRows.forEach(function(item){
            x = x + cmp.get('v.recuperoMap')[item[Object.keys(item)]] + ';';
        });
        cmp.set('v.socRecInput',x);        
    },
    
    getSelectedSocAss : function(cmp,event){
        var selectedRows = event.getParam('selectedRows');
        var socAssApiMap = cmp.get('v.assicurazioniMap');        
        var x = '';
        selectedRows.forEach(function(item){
            x = x + cmp.get('v.assicurazioniMap')[item[Object.keys(item)]] + ';';
        });        
        cmp.set('v.socAssInput',x);        
    },
    
    getSelectedSic : function(cmp,event){
        var selectedRows = event.getParam('selectedRows');
        var socSicApiMap = cmp.get('v.sicMap');
        var x = '';        
        selectedRows.forEach(function(item){
            x = x + cmp.get('v.sicMap')[item[Object.keys(item)]] + ';';
        });        
        cmp.set('v.sicInput',x);              
    },    
    
    // funzioni per deselezionare il valore iniziale e non far apparire due volte lo stesso valore nella picklist    
    focusDecisione : function(cmp,event){
 //       cmp.set('v.decisioneForInit','Seleziona');        
    },
    
    focusAccolto : function(cmp,event){
 //       cmp.set('v.accoltoInitData','Seleziona');               
    },
    
    focusIntervento : function(cmp,event){
        cmp.set('v.interventoAutDettagliInit','Seleziona');
    },

    makeCaseChiusura : function(cmp, event, helper) {
        var res = {};
        
        //Prendo le label delle picklist e le trasformo in API name prima di passarle al server
        var mapIntervento = cmp.get('v.interventoMap');
        var interventoDet = cmp.get('v.interventoAutDettagli');    
        cmp.set('v.interventoInput',mapIntervento[interventoDet]);
        
        //controllo i valori per le datatable...se non controllo e l utente non cambia niente
        //viene selezionato null di default e ciò non va bene
        
        if(cmp.get('v.sicInput')  == -999){            
            cmp.set('v.sicInput',cmp.get('v.sicInit'));
        }
        
        if(cmp.get('v.socAssInput')  == -999){  
            cmp.set('v.socAssInput',cmp.get('v.socAssInit'));
        }
        
        if(cmp.get('v.socRecInput')  == -999){
            cmp.set('v.socRecInput',cmp.get('v.socRecInit'));
        }        
        
        res['isAbbuono'] = cmp.get('v.abbuonoValue');                   
        res['abbuonoImporto'] = cmp.get('v.abbuonoImportoValue');
            res['isRimborso'] = cmp.get('v.rimborsoValue');
            res['rimborsoImporto'] = cmp.get('v.rimborsoImportoValue');
            res['isRimborsoComm'] = cmp.get('v.rimborsoCommValue');
            res['rimborsoImportoComm'] = cmp.get('v.rimborsoImportoCommValue');
            res['isRimborsoProv'] = cmp.get('v.rimborsoProvValue');
            res['rimborsoImportoProv'] = cmp.get('v.rimborsoImportoProvValue');
            res['isRimborsoPrem'] = cmp.get('v.rimborsoPremValue');
            res['rimborsoImportoPrem'] = cmp.get('v.rimborsoImportoPremValue');
            res['isRimborsoVar'] = cmp.get('v.rimborsoVarValue');
            res['rimborsoImportoVar'] = cmp.get('v.rimborsoImportoVarValue');
            res['isRimborsoLeg'] = cmp.get('v.rimborsoLegValue');
            res['rimborsoImportoLeg'] = cmp.get('v.rimborsoImportoLegValue');
            res['isRisarcimento'] = cmp.get('v.risarcimentoValue');
            res['risarcimentoImportoValue'] = cmp.get('v.risarcimentoImportoValue');
            res['isFondato'] = cmp.get('v.fondatoValue');
            res['accolto'] = cmp.get('v.accoltoDettagli');
            res['isAllegatiCompleti'] = cmp.get('v.allegatiCompletiValue');
            res['isSic'] = cmp.get('v.sicValue');
            res['sic'] = cmp.get('v.newSicValue');
            res['isSocAss'] = cmp.get('v.socAssValue');
            res['socAss'] = cmp.get('v.newSocAssValue');
            res['isSocRec'] = cmp.get('v.socRecValue');
            res['socRec'] = cmp.get('v.newSocRecValue');
            res['isIdm'] = cmp.get('v.idmValue');
            res['isRiscontro'] = cmp.get('v.riscontroValue');
            res['isAssegno'] = cmp.get('v.attesaValue');
            res['decisione'] = cmp.get('v.decisioneDettagli');
            res['autorita'] = cmp.get('v.interventoInput');            
        
        return res;
    },   
    
    makeCaseChiusuraDouble : function(cmp, event, helper) {
        var res = {};
        
        res['abbuonoImporto'] = cmp.get('v.abbuonoImportoValue');
        res['rimborsoImporto'] = cmp.get('v.rimborsoImportoValue');       
        res['rimborsoImportoComm'] = cmp.get('v.rimborsoImportoCommValue');
        res['rimborsoImportoProv'] = cmp.get('v.rimborsoImportoProvValue');   
        res['rimborsoImportoPrem'] = cmp.get('v.rimborsoImportoPremValue');    
        res['rimborsoImportoVar'] = cmp.get('v.rimborsoImportoVarValue');
        res['rimborsoImportoLeg'] = cmp.get('v.rimborsoImportoLegValue');
        res['risarcimentoImportoValue'] = cmp.get('v.risarcimentoImportoValue');
        
        
        return res;
    },
    
    checkImporto :function(component, event){
        var importo = event.getSource().get("v.value")+'';
        if(importo.includes('.')){
            var intero = importo.split('.')[0];
            var decimale = importo.split('.')[1];
            if(decimale.length > 2) decimale = decimale.substring(0,2);
            event.getSource().set("v.value", intero+'.'+decimale);
        }
       
    },
    
    checkCompass : function(component, event, helper){

        var none = 'none';

        var abbuono = component.get("v.abbuonoValue");
        var abbuonoValues = component.get("v.abbuonoValues");
        if(abbuonoValues==none) return 'Completa il campo Abbuono';
        var abbuonoValue= component.get("v.abbuonoImportoValue");
        
        if(abbuono && (abbuonoValue == undefined || abbuonoValue == '' || abbuonoValue <= 0)) return 'Completa il campo Importo Abbuono con un valore positivo';
        
        var rimborso = component.get("v.rimborsoValue");
        var rimborsoValues = component.get("v.rimborsoValues");
        if(rimborsoValues==none) return 'Completa il campo Rimborso';
        var rimborsoValue= component.get("v.rimborsoImportoValue");
        if(rimborso && (rimborsoValue == undefined || rimborsoValue == '' || rimborsoValue <= 0)) return 'Completa il campo Importo Rimborso con un valore positivo';
        
        var commissioni = component.get("v.rimborsoCommValue");
        var commissioniValues = component.get("v.commissioniValues");
        if(commissioniValues==none) return 'Completa il campo Rimborso Commissioni';
        var commissioniValue= component.get("v.rimborsoImportoCommValue");
        if(commissioni && (commissioniValue == undefined || commissioniValue == '' || commissioniValue <= 0)) return 'Completa il campo Importo Rimborso Commissioni con un valore positivo';
        /* 
        var rimborsoProv = component.get("v.rimborsoProvValue");
        var rimborsoProvValues = component.get("v.rimborsoProvValues");
        if(rimborsoProvValues==none) return 'Completa il campo Rimborso provvigioni/accessorie';
        var rimborsoProvValue= component.get("v.rimborsoImportoProvValue");
        if(rimborsoProv && (rimborsoProvValue == undefined || rimborsoProvValue == '')) return 'Completa il campo Importo Rimborso provvigioni/accessorie';
        
        var rimborsoPrem= component.get("v.rimborsoPremValue");
        var rimborsoPremValues = component.get("v.rimborsoPremValues");
        if(rimborsoPremValues==none) return 'Completa il campo Rimborso premio assicurativo';
        var rimborsoPremValue= component.get("v.rimborsoImportoPremValue");
        if(rimborsoPrem && (rimborsoPremValue == undefined || rimborsoPremValue == '')) return 'Completa il campo Importo Rimborso premio assicurativo';
         
        var rimborsoVar= component.get("v.rimborsoVarValue");
        var rimborsoVarValues = component.get("v.rimborsoVarValues");
        if(rimborsoVarValues==none) return 'Completa il campo Rimborso varie';
        var rimborsoVarValue= component.get("v.rimborsoImportoVarValue");
        if(rimborsoVar && (rimborsoVarValue == undefined || rimborsoVarValue == '')) return 'Completa il campo Importo Rimborso varie';
         
        var rimborsoLeg= component.get("v.rimborsoLegValue");
        var rimborsoLegValues = component.get("v.rimborsoLegValues");
        if(rimborsoLegValues==none) return 'Completa il campo Rimborso spese legali';
        var rimborsoLegValue= component.get("v.rimborsoImportoLegValue");
        if(rimborsoLeg && (rimborsoLegValue == undefined || rimborsoLegValue == '')) return 'Completa il campo Importo Rimborso spese legali';
        */
        var risarcimento= component.get("v.risarcimentoValue");
        var risarcimentoValues = component.get("v.risarcimentoValues");
        if(risarcimentoValues==none) return 'Completa il campo Risarcimento';
        var risarcimentoValue= component.get("v.risarcimentoImportoValue");
        if(risarcimento && (risarcimentoValue == undefined || risarcimentoValue == '' || risarcimentoValue <= 0)) return 'Completa il campo Risarcimento con un valore positivo';

        var fondatoValues = component.get("v.fondatoValues");
        if(fondatoValues==none) return 'Completa il campo Fondato';

        var attesaValues = component.get("v.attesaValues");
        if(attesaValues==none) return 'Completa il campo Attesa assegno';

        var allegatiCompletiValues = component.get("v.allegatiCompletiValues");
        if(allegatiCompletiValues!=true) return 'Il campo Allegati completi deve essere impostato su \'Si\'';

        var sicValues = component.get("v.sicValues");
        if(sicValues==none) return 'Completa il campo Sic';
        var sicValue= component.get("v.sicValue");
        var sicSel = component.get("v.newSicValue");
        if(sicValue && (sicSel == undefined || sicSel == '')) return 'Selezionare un valore per Sic';

        var socAssValues = component.get("v.socAssValues");
        if(socAssValues==none) return 'Completa il campo Società assicurative';
        var socAssValue= component.get("v.socAssValue");
        var socSel = component.get("v.newSocAssValue");
        if(socAssValue && (socSel == undefined || socSel == '')) return 'Selezionare un valore per Società assicurative';

        var socRecValues = component.get("v.socRecValues");
        if(socRecValues==none) return 'Completa il campo Società di recupero';
        var socRecValue= component.get("v.socRecValue");
        var socRecSel = component.get("v.newSocRecValue");
        if(socRecValue && (socRecSel == undefined || socRecSel == '')) return 'Selezionare un valore per Società di recupero';

        var respValues = component.get("v.respValues");
        if(respValues==none) return 'Completa il campo Responsabilità';
        var respValue= component.get("v.respValue");
        var respSelected = component.get("v.respSelected");
        if(respValue && (respSelected == undefined || respSelected == '')) return 'Selezionare un valore per responsabilità';

        var idmValues = component.get("v.idmValues");
        if(idmValues==none) return 'Completa il campo Invia risposta IDM';
        var allegatiSelezionati = component.get('v.allegatiSelezionati');
        var selezionati = allegatiSelezionati.length > 0 ? true : false;
        if(idmValues && !selezionati) return 'Selezionare almeno un allegato';

        var accoltoValues = component.get("v.accoltoDettagli");
        console.log('accoltoValues:'+accoltoValues);
        if (accoltoValues==null || accoltoValues=='') {
            // con questa condizione il campo ancora non è mai stato selezionato
            return 'Il campo Accolto deve essere valorizzato';
        } 

        var decisioneValues = component.get("v.decisioneDettagli");
        console.log('decisioneValues:'+decisioneValues);
        var campiCase = component.get('v.campiCase');
        var isDecisionePresent = component.get('v.isDecisioneValue');
        console.log('isDecisionePresent:'+isDecisionePresent);
        if ((isDecisionePresent>0) && (typeof decisioneValues == 'undefined' || 'none' == decisioneValues || '' == decisioneValues)) {
            // con questa condizione il campo ancora non è mai stato selezionato
            return 'Il campo Decisione deve essere valorizzato';
        } 

        var isTipoReclamo5412 = campiCase.Tipo_Reclamo__c == '5412';
        
        if(isTipoReclamo5412){
            //var riscontroValues = component.get("v.riscontroValues");
            //if(riscontroValues==none) return 'Completa il campo Attesa riscontro';
        }        
		
        var codaSelezionata = component.get("v.codaSelezionata");
        var iscodaSelezionata57 = codaSelezionata.DeveloperName == 'DN_57';
        if(iscodaSelezionata57){
            var riscontroValues = component.get("v.riscontroValues");
            if(riscontroValues==none) return 'Completa il campo Attesa riscontro';
        }
        return 'ok';
        
    },

    checkFuturo : function(component, event, helper){

        var none = 'none';
 
        var rimborsoProv = component.get("v.rimborsoProvValue");
        var rimborsoProvValues = component.get("v.rimborsoProvValues");
        if(rimborsoProvValues==none) return 'Completa il campo Rimborso provvigioni/accessorie';
        var rimborsoProvValue= component.get("v.rimborsoImportoProvValue");
        if(rimborsoProv && (rimborsoProvValue == undefined || rimborsoProvValue == '' || rimborsoProvValue <= 0)) return 'Completa il campo Importo Rimborso provvigioni/accessorie con un valore positivo';

        var rimborsoComm= component.get("v.rimborsoCommValue");
        var rimborsoCommValues = component.get("v.rimborsoCommValues");
        if(rimborsoCommValues==none) return 'Completa il campo Rimborso commissioni';
        var rimborsoCommValue= component.get("v.rimborsoImportoCommValue");
        if(rimborsoComm && (rimborsoCommValue == undefined || rimborsoCommValue == '' || rimborsoCommValue <= 0)) return 'Completa il campo Importo Rimborso commissioni con un valore positivo';

        var risarcimento= component.get("v.risarcimentoValue");
        var risarcimentoValues = component.get("v.risarcimentoValues");
        if(risarcimentoValues==none) return 'Completa il campo Risarcimento';
        var risarcimentoValue= component.get("v.risarcimentoImportoValue");
        if(risarcimento && (risarcimentoValue == undefined || risarcimentoValue == '' || risarcimentoValue <= 0)) return 'Completa il campo Importo risarcimento con un valore positivo';

        var rimborsoPrem= component.get("v.rimborsoPremValue");
        var rimborsoPremValues = component.get("v.rimborsoPremValues");
        if(rimborsoPremValues==none) return 'Completa il campo Rimborso premio assicurativo';
        var rimborsoPremValue= component.get("v.rimborsoImportoPremValue");
        if(rimborsoPrem && (rimborsoPremValue == undefined || rimborsoPremValue == '' || rimborsoPremValue <= 0)) return 'Completa il campo Importo Rimborso premio assicurativo con un valore positivo';
         
        var rimborsoVar= component.get("v.rimborsoVarValue");
        var rimborsoVarValues = component.get("v.rimborsoVarValues");
        if(rimborsoVarValues==none) return 'Completa il campo Rimborso varie';
        var rimborsoVarValue= component.get("v.rimborsoImportoVarValue");
        if(rimborsoVar && (rimborsoVarValue == undefined || rimborsoVarValue == '' || rimborsoVarValue <= 0)) return 'Completa il campo Importo Rimborso varie con un valore positivo';
         
        var rimborsoLeg= component.get("v.rimborsoLegValue");
        var rimborsoLegValues = component.get("v.rimborsoLegValues");
        if(rimborsoLegValues==none) return 'Completa il campo Rimborso spese legali';
        var rimborsoLegValue= component.get("v.rimborsoImportoLegValue");
        if(rimborsoLeg && (rimborsoLegValue == undefined || rimborsoLegValue == '' || rimborsoLegValue <= 0)) return 'Completa il campo Importo Rimborso spese legali con un valore positivo';
        
        var fondatoValues = component.get("v.fondatoValues");
        if(fondatoValues==none) return 'Completa il campo Fondato';

        var attesaValues = component.get("v.attesaValues");
        if(attesaValues==none) return 'Completa il campo Attesa assegno';

        var allegatiCompletiValues = component.get("v.allegatiCompletiValues");
        if(allegatiCompletiValues!=true) return 'Il campo Allegati completi deve essere impostato su \'Si\'';

        var sicValues = component.get("v.sicValues");
        if(sicValues==none) return 'Completa il campo Sic';
        var sicValue= component.get("v.sicValue");
        var sicSel = component.get("v.newSicValue");
        if(sicValue && (sicSel == undefined || sicSel == '')) return 'Selezionare un valore per Sic';

        var socAssValues = component.get("v.socAssValues");
        if(socAssValues==none) return 'Completa il campo Società assicurative';
        var socAssValue= component.get("v.socAssValue");
        var socSel = component.get("v.newSocAssValue");
        if(socAssValue && (socSel == undefined || socSel == '')) return 'Selezionare un valore per Società assicurative';

        var socRecValues = component.get("v.socRecValues");
        if(socRecValues==none) return 'Completa il campo Società di recupero';
        var socRecValue= component.get("v.socRecValue");
        var socRecSel = component.get("v.newSocRecValue");
        if(socRecValue && (socRecSel == undefined || socRecSel == '')) return 'Selezionare un valore per Società di recupero';

        var respValues = component.get("v.respValues");
        if(respValues==none) return 'Completa il campo Responsabilità';
        var respValue= component.get("v.respValue");
        var respSelected = component.get("v.respSelected");
        if(respValue && (respSelected == undefined || respSelected == '')) return 'Selezionare un valore per responsabilità';

        var idmValues = component.get("v.idmValues");
        if(idmValues==none) return 'Completa il campo Invia risposta IDM';
        var allegatiSelezionati = component.get('v.allegatiSelezionati');
        var selezionati = allegatiSelezionati.length > 0 ? true : false;
        if(idmValues && !selezionati) return 'Selezionare almeno un allegato';

        var accoltoValues = component.get("v.accoltoDettagli");
        var accoltoList = component.get("v.accoltoList");
        if (accoltoValues==undefined || accoltoValues=="") {
            // con questa condizione il campo ancora non è mai stato selezionato
            return 'Il campo Accolto deve essere valorizzato';
        } 

        var campiCase = component.get('v.campiCase');
        var isTipoReclamo5412 = campiCase.Tipo_Reclamo__c == '5412';
        
        if(isTipoReclamo5412){
            //var riscontroValues = component.get("v.riscontroValues");
            //if(riscontroValues==none) return 'Completa il campo Attesa riscontro';
        }

        var codaSelezionata = component.get("v.codaSelezionata");
        var iscodaSelezionata57 = codaSelezionata!=null ? codaSelezionata.DeveloperName == 'DN_57' : false;
        if(iscodaSelezionata57){
            var riscontroValues = component.get("v.riscontroValues");
            if(riscontroValues==none) return 'Completa il campo Attesa riscontro';
        }
        
        return 'ok';
        
    },

    //RESPONSABILITA
    handleResp : function(component, event, helper){
        if(component.get('v.isInit')) return;
        var accId = component.get('v.campiCase');
        
        if(event.getParam("value") == 'false'){
            component.set('v.respValue', false);
            component.set('v.respValues', false);  
        } 
        else if(event.getParam("value") == 'true'){
            component.set('v.respValue', true);
            component.set('v.respValues', true);
            helper.getResponsabilitaValues2(component,event,helper);

        }else{
            component.set('v.respValue', false);
            component.set('v.respValues', 'none');
        }
       
    },

    setResponsabilita : function(component, event, helper){
        var respSelectedTemp = component.get("v.respSelectedTemp");
        
        if (component.find("searchResp")!=null) {
            var search = component.find("searchResp").get("v.value");
            if(search==null||search==undefined||search==''||search=='undefined'){
                component.set("v.respSelectedTemp",[]);
                        
            }
        }
        
        helper.setResponsabilita(component, event, helper);        
    },

    getResponsabilita : function(component, event, helper){
        var respSelectedTemp = component.get("v.respSelected");
        
        component.set("v.respSelectedTemp",respSelectedTemp);
        
        helper.getResponsabilitaValues2(component, event, helper);        
    },

    //CREATE CASE IDM   
    createCase : function(component, event, helper){
        helper.createCase(component, event, helper);
    },
    getResponsabilitaSel : function(cmp, event, helper) {       
        console.log('@@@ getResponsabilitaSel respSelectedTemp:'+cmp.get('v.respSelectedTemp'));
        console.log('@@@ getResponsabilitaSel respValues:'+cmp.get('v.respValues')+':');
        if (!cmp.get('v.respValues')) {
            // se la combo Responsabilita è messa a 'NO', nessuna responsabilità verra selezionata
            return null;
        }
        return cmp.get('v.respSelectedTemp');
    }
 


})