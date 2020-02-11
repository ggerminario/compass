({
    doInit : function(component) {
        console.log("INIZIO DO INIT");
//
//        console.log('idCase -> '+ idCase);
        this.showSpinner(component);
        var idr = component.get('v.recordId');
        var action = component.get("c.getActivity");

        action.setParams({
            idCase: idr
        });

        action.setCallback(this, function(response) {
            var state = response.getState();
            
//       		alert('state activity ->' + state);
            if (state === "SUCCESS") {
                console.log('state -> '+ state);
                component.set("v.selectedActivity", response.getReturnValue());
                console.log('selectedActivity -> ' + component.get('v.selectedActivity[0].Categoria__c'));
                console.log('selected -> ' + component.get('v.selectedActivity[0].Activity_id__c'));
                console.log('selectedDueDate -> ' + component.get('v.selectedActivity[0].Activity_id__r.DueDate__c'));
                console.log('CATEGORIA -> ' + component.get('v.selectedActivity[0].Activity_id__r.Categoria_Riferimento__r.Name'));
                var tipoProdotto = component.get('v.selectedActivity[0].Tipo_prodotto__c');
                var sCategoria = component.get('v.selectedActivity[0].Categoria__c');
                var testoNotaS = component.get('v.selectedActivity[0].Nota_sospesa__c');
                var testoNotaC = component.get('v.selectedActivity[0].Nota_compass__c');
                var globalNota = testoNotaC;
                var sData = component.get('v.selectedActivity[0].Activity_id__r.DueDate__c');
                var sEsito = component.get('v.selectedActivity[0].Esito__c');
                var sEsitoMD = component.get('v.selectedActivity[0].Esito_finale_md__c');
                component.set('v.nuovaData',sData);
                component.set('v.valueEsito',sEsito);
                console.log('sEsitoMD-> '+sEsitoMD);
                component.set('v.opzioneChiusura',sEsitoMD);

//                component.set('v.nuovaData',component.get('v.selectedActivity[0].Activity_id__r.DueDate__c'));
                console.log('tipo prodotto -> ' + tipoProdotto);
                console.log('global nota -> ' + globalNota);
                component.set('v.vNota',globalNota);
//                testoNotaS = testoNotaS.replace("<br/>","");
                component.set('v.sNota',testoNotaS);

                var q1 = component.get('v.selectedActivity[0].question1__c');
                var q2 = component.get('v.selectedActivity[0].question2__c');
                var q3 = component.get('v.selectedActivity[0].question3__c');
				var b=sCategoria.includes('IRREPERIBILIT');
				if(b==true){
                    console.log('irreper');
                    console.log(q1);
                    console.log(q2);
                    console.log(q3);
                    component.set('v.categoria',true);
                    component.set('v.question1Value',q1);
                    component.set('v.question2Value',q2);
                    component.set('v.question3Value',q3);
				}else{
                    var i=sCategoria.includes('INADEMPIMENTO');
                    if(i==true){
                        component.set('v.inadempimento',true);
                        var vRit = component.get('v.selectedActivity[0].Ritardo_dealer__c');
                        if(vRit=='VERO'){
                            component.set('v.myBool',true);
                        }else{
                            component.set('v.myBool',false);
                        }
                    }
					component.set('v.categoria',false);
				}
                console.log(tipoProdotto);
                switch(tipoProdotto){
                    case 'PP':
                        component.set('v.tipoPAPF',false);
                        component.set('v.tipoPP',true);
                        component.set('v.tipoCARTA',false);
                        component.set('v.tipoVA',false);
                        break;
                    case 'PAPF':
                        component.set('v.tipoPAPF',true);
                        component.set('v.tipoPP',false);
                        component.set('v.tipoCARTA',false);
                        component.set('v.tipoVA',false);
                        break;
                    case 'PA-PF':
                        component.set('v.tipoPAPF',true);
                        component.set('v.tipoPP',false);
                        component.set('v.tipoCARTA',false);
                        component.set('v.tipoVA',false);
                        break;
    
                        case 'CONSUMO':
                        component.set('v.tipoPAPF',false);
                        component.set('v.tipoPP',false);
                        component.set('v.tipoCARTA',false);
                        component.set('v.tipoVA',true);
                        break;
                    case 'CARTA':
                        component.set('v.tipoPAPF',false);
                        component.set('v.tipoPP',false);
                        component.set('v.tipoCARTA',true);
                        component.set('v.tipoVA',false);
                        break;
                }
                this.caricaChiusura(component, tipoProdotto);
                this.recDatiCarta(component,component.get('v.selectedActivity[0].Num_Pratica__c'));
                this.recDatiPratica(component,component.get('v.selectedActivity[0].Num_Pratica__c'));
            }
            else if (state === 'ERROR') {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        component.set('v.msg', errors[0].message);
                        this.showErrorToast(component);
                    }
                } else {
                    component.set('v.msg', 'Unknown error');
                    this.showErrorToast(component);
                }
            }
            this.hideSpinner(component);
        })
        $A.enqueueAction(action);
	},

    doUser : function(component) {

        console.log('DO USER');
        
        this.showSpinner(component);
        var action = component.get("c.getUserMap");
        
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                console.log('state doUser ->'+ state);
                component.set("v.mapUser", response.getReturnValue());
                var mappa = component.get('v.mapUser');

                component.set('v.userId',mappa.idUser);
                component.set('v.userProfile',mappa.Profile);
                component.set('v.userFiliale',mappa.Filiale);
                var vProfile = component.get('v.userProfile');
            
// DA ATTIVARE QUANDO SONO PRONTI I PROFILI FABIO
                if (vProfile=='Branch Employee'||vProfile=='Branch Manager'){
                    component.set('v.userIsBO', true);
                }else if(vProfile=='Monitoraggio Dealer'){
                    component.set('v.userIsBO', false);
                }else{
                    component.set('v.userIsBO', true);
                    component.set('v.userAdm', true);
                }
                this.doInit(component);

            }
            else if (state === 'ERROR') {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        component.set('v.msg', errors[0].message);
                        this.showErrorToast(component);
                    }
                } else {
                    component.set('v.msg', 'Unknown error');
                    this.showErrorToast(component);
                }
            }
            this.hideSpinner(component);
        })
        
        $A.enqueueAction(action);
    },
    
    recDatiPratica : function(component, numPratica) {
        console.log("---------------------------------------------------");
        console.log("--Controller JS: SFACommodity_GestioneHelper - Method: recDatiPratica --");
//        alert('pratica -> '+ numPratica);
        this.showSpinner(component);
        var action = component.get("c.getDatiPratica");


        action.setParams({
            numPratica: numPratica,
            b : true
        });

        action.setCallback(this, function(response) {
            var state = response.getState();
       
            if (state === "SUCCESS") {
//                if(response.getReturnValue){
                    console.log('response dati pratica');
//                }else{
                    component.set("v.recDatiPratica", response.getReturnValue());
                    console.log(component.get('v.recDatiPratica'));
                    var rdp = component.get('v.recDatiPratica');
                    console.log('rdp' + rdp);
                    console.log(rdp.canale);

                    var dataL = component.get('v.recDatiPratica.dataLiquidazione')
//                    var vGiorno = dataL.substring(6,8);
//                    var vMese = dataL.substring(4,6);
//                    var vAnno = dataL.substring(0,4);
                    if(dataL != undefined && dataL != null && dataL.length==8 ){
                        component.set('v.dataLiquidazione', dataL.substring(6,8)+'/'+dataL.substring(4,6)+'/'+dataL.substring(0,4));
                    }else{
                        component.set('v.dataLiquidazione', '');
                    }
//                }
//                alert(dataL);
            }
            else if (state === 'ERROR') {
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        component.set('v.msg', errors[0].message);
                        this.showErrorToast(component);
                    }
                } else {
                    component.set('v.msg', 'Unknown error');
                    this.showErrorToast(component);
                }
            }
            this.hideSpinner(component);
        })
        $A.enqueueAction(action);
	},

    recDatiCarta : function(component, numPratica) {
        console.log("---------------------------------------------------");
        console.log("--Controller JS: SFACommodity_GestioneHelper - Method: recDatiCarta --");
        
        this.showSpinner(component);
        var action = component.get("c.getDatiCarta");

        action.setParams({
            numPratica: numPratica,
            b : true
        });

        action.setCallback(this, function(response) {
            var state = response.getState();
       
            if (state === "SUCCESS") {
                console.log('SUCCESS');
                console.log(response.getReturnValue());
//                if(response.getReturnValue()){
//                    console.log('RITORNO NULL');
//                }else{
                    component.set("v.recDatiCarta", response.getReturnValue());
                    console.log(component.get('v.recDatiCarta'));
                    var dataR = component.get('v.recDatiCarta.dataRichiesta')
                    if(dataR != undefined && dataR != null ){
                        component.set('v.dataRichiesta', dataR.substring(6,8)+'/'+dataR.substring(4,6)+'/'+dataR.substring(0,4));
                    }else{
                        component.set('v.dataRichiesta', '');
                    }
//                }
//                alert(dataR);
            }
            else if (state === 'ERROR') {
//                alert('errore');
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        component.set('v.msg', errors[0].message);
                        this.showErrorToast(component);
                    }
                } else {
                    component.set('v.msg', 'Unknown error');
                    this.showErrorToast(component);
                }
            }
            this.hideSpinner(component);
        })
        $A.enqueueAction(action);
	},

    showSuccessToast : function(component) {

        component.find('notifLib').showToast({
            "variant": "success",
            "title": "Success!",
            "message": component.get('v.msg')
        });
    },
    
    showErrorToast : function(component) {

        component.find('notifLib').showToast({
            "variant": "error",
            "title": "Error!",
            "message": component.get('v.msg')
        });
    },
    
    showInfoToast : function(component) {

        component.find('notifLib').showToast({
            "variant": "info",
            "title": "Info",
            "message": component.get('v.msg')
        });
    },
    
    showWarningToast : function(component) {

        component.find('notifLib').showToast({
            "variant": "warning",
            "title": "Warning!",
            "message": component.get('v.msg')
        });
    },
    
    showNotice : function(component) {

        component.find('notifLib').showNotice({
            "variant": "info",
            "header": "Info",
            "message": component.get("v.notifMsg"),
            closeCallback: function() {
                
            }
        });
    },
    
    showSpinner: function(component) {

        var x = component.get('v.showSpinner')+1;
        component.set('v.showSpinner', x);
    },

    hideSpinner: function(component) {

        var x = component.get('v.showSpinner')-1;
        component.set('v.showSpinner', x);
    },

    aumentaData: function(s, h) {
        console.log('---------------------------------------------------------------');
        console.log('-- Controller JS: CRMDinieghiSDDHelper.js - Method: aumentaData'); 
        
		var mm = h*3600000;        
        var msec = Date.parse(s);
        var d = new Date(msec+mm);
        
		return d;
    },

    caricaChiusura : function(component, sTipo){
        console.log('-------------------------------------------------------');
        console.log('-- Controller JS: SFACommodity_GestioneHelper - Method: caricaChiusura');
        console.log('sTipo -> '+sTipo);         

        var action = component.get("c.getChiusura");

//        alert('b-> '+b);
        action.setParams({ 
            sTipo : sTipo
        });
        
        action.setCallback(this, function(resp) {
            var state = resp.getState();
            if(state=='SUCCESS'){
                console.log('response');
                console.log(resp.getReturnValue());
                let items = [];
                let lChi = resp.getReturnValue();
                for(let i of lChi){
                    var item = {
                        "label":i.Esito_Chiusura__c + " - "+i.Descrizione_Esito__c,
                        "value":i.Esito_Chiusura__c + " - "+i.Descrizione_Esito__c
                    };
//                    console.log('value--> '+i.Esito_Chiusura__c + " - "+i.Descrizione_Esito__c);
                    items.push(item);
                }
//                component.set("v.optionsChiusura", resp.getReturnValue());
                component.set("v.optionsChiusura", items);
            }else if (state === 'ERROR') {
                var errors = resp.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        component.set('v.msg', errors[0].message);
                        this.showErrorToast(component);
                    }
                } else {
                    component.set('v.msg', 'Unknown error');
                    this.showErrorToast(component);
                }
            }
            this.hideSpinner(component);
                 
        });
        $A.enqueueAction(action);
    },

    handleSospendi : function(component, event){
        console.log('-------------------------------------------------------');
        console.log('-- Controller JS: SFACommodity_GestioneHelper - Method: handleSospendi');         

        var action = component.get("c.getSospendi");

        var notaSospesa = component.get('v.sNota'); 
        var q1 = component.get('v.question1Value');
        var q2 = component.get('v.question2Value');
        var q3 = component.get('v.question3Value');
        var vRit = component.get('v.myBool');
        var vEsito = component.get('v.valueEsito');
        var vEsitoMD = component.get('v.opzioneChiusura');
        var vNuovaData = component.get('v.nuovaData');
//        var b = component.get('v.categoria');

//        alert('vesitomd ->'+vEsitoMD);
//        alert('vnuovadata ->'+vNuovaData);
//        alert('q2-> '+ q2);
//        alert('q3-> '+ q3);
//        alert('nota-> '+notaSospesa);
//        alert('b-> '+b);

// CONTROLLI
        if(!notaSospesa){
            component.set('v.msg', "Inserire una nota per sospendere l'attivita");
            this.showErrorToast(component);
            return;
        }

        action.setParams({ 
            idCase : component.get("v.selectedActivity[0].Activity_id__c"),
            notaSospesa : notaSospesa,
            q1 : q1,
            q2 : q2,
            q3 : q3,
            vRit : vRit,
            vEsito : vEsito,
            vEsitoMD : vEsitoMD, 
            nData : vNuovaData
        });
        
        action.setCallback(this, function(resp) {
            if(resp.getState()=='SUCCESS'){
                this.gotoList(component, event);

//                $A.get("e.force:refreshView").fire();
            }else if (resp.getState() === 'ERROR') {
                var errors = resp.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        component.set('v.msg', errors[0].message);
                        this.showErrorToast(component);
                    }
                } else {
                    component.set('v.msg', 'Unknown error');
                    this.showErrorToast(component);
                }
            }
        });
        $A.enqueueAction(action);
    },

    handleCompleta : function(component, event){
        console.log('-------------------------------------------------------');
        console.log('-- Controller JS: SFACommodity_GestioneHelper - Method: handleCompleta');         
        this.showSpinner(component);
        var action = component.get("c.getCompleta");

        var nota = component.get('v.sNota'); 
        var q1 = component.get('v.question1Value');
        var q2 = component.get('v.question2Value');
        var q3 = component.get('v.question3Value');
        var vRit = component.get('v.myBool');
        var vEsito = component.get('v.valueEsito');
        var vEsitoMD = component.get('v.opzioneChiusura');
        var vNuovaData = component.get('v.nuovaData');
        var b = component.get('v.categoria');
        var UserIsBo = component.get('v.userIsBO');

        console.log('-- nota -> ' + nota); 
        console.log('-- q1  -> ' + q1 );
        console.log('-- q2  -> ' + q2);
        console.log('-- q3  -> ' + q3);
        console.log('-- vRit  -> ' + vRit);
        console.log('-- vEsito  -> ' + vEsito);
        console.log('-- vEsitoMD  -> ' + vEsitoMD);
        console.log('-- vNuovaData  -> ' + vNuovaData);
        console.log('-- b  -> ' + b);
        console.log('-- UserIsBo  -> ' + UserIsBo);


// CONTROLLI
        if(!nota){
            component.set('v.msg', "Inserire una nota");
            this.showErrorToast(component);
            return;
        }
        console.log('controllo vEsito '+vEsito);
        if(UserIsBo==false){
          
            if(vEsito=='Branch_Activity_Complete'){
                component.set('v.msg', "Esito Obbligatorio");
                this.showErrorToast(component);
                return;
            }else if(vEsito=='Activity Complete'){
                if(vEsitoMD==null || vEsitoMD==undefined){
                    console.log('dopo if '+vEsitoMD)
                    component.set('v.msg', "Esito Finale Obbligatorio");
                    this.showErrorToast(component);
                    return;
                }
            }    
        }
        if(b){
//            if(!q1){
            
            if(q1=='Si'){
               if(!q2){
                component.set('v.msg', "Rispondere alla domanda: Su quale telefono è stato contattato il cliente?");
                this.showErrorToast(component);
                return;

                }else if(!q3){
                    component.set('v.msg', "Rispondere alla domanda: E' stato inserito un nuovo recapito utile?");
                    this.showErrorToast(component);
                    return;
                }

            }                

        }
        action.setParams({ 
            idCase : component.get("v.selectedActivity[0].Activity_id__c"),
            nota : nota,
            q1 : q1,
            q2 : q2,
            q3 : q3,
            vRit : vRit,
            vEsito : vEsito,
            vEsitoMD : vEsitoMD, 
            vNuovaData : vNuovaData
        });
        //00B5E000002NIq3UAG
        action.setCallback(this, function(resp) {
            console.log('action get completa response' + resp);
            if(resp.getState()=='SUCCESS'){
                console.log('prima di gotolist');
                this.gotoList(component, event);

            }else if (resp.getState() === 'ERROR') {
                var errors = resp.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        component.set('v.msg', errors[0].message);
                        this.showErrorToast(component);
                    }
                } else {
                    component.set('v.msg', 'Unknown error');
                    this.showErrorToast(component);
                }
            }
            this.hideSpinner(component);
        });
        $A.enqueueAction(action);
    },

    handleUploadFinished : function(component, event){
        console.log('-------------------------------------------------------');
        console.log('-- Controller JS: SFACommodity_GestioneHelper - Method: handleUploadFinished');         

        var uploadedFiles = event.getParam("files");
        var documentId = uploadedFiles[0].documentId;
        var fileName = uploadedFiles[0].name;
        var descAll = component.get('v.descAll');
        console.log('uploadedFiles'+uploadedFiles);
        console.log('documentId'+documentId);
        console.log('fileName'+fileName);
        console.log('descAll'+descAll);

        component.set("v.refresh", false);
        component.set("v.refresh", true);
        $A.get("e.force:refreshView").fire();

        if (descAll!=null && descAll!="" && descAll!=undefined){
            var action = component.get("c.finishUploadFile");
            action.setParams({ 
    //            recordId : component.get("v.recordId"),
                recordId : component.get("v.selectedActivity[0].Activity_id__c"),
    //            recordId : "5005E000005Vd3yQAC",
                documentId: documentId,
                nameFile : fileName,
                Descr : descAll
            });
            
            action.setCallback(this, function(resp) {
                if(resp.getState()=='SUCCESS'){
                    component.set("v.elencoFile",resp.getReturnValue());
                    component.set("v.refresh", false);
                    component.set("v.refresh", true);
                    $A.get("e.force:refreshView").fire();
                }else if (resp.getState() === 'ERROR') {
                    var errors = resp.getError();
                    if (errors) {
                        if (errors[0] && errors[0].message) {
                            component.set('v.msg', errors[0].message);
                            this.showErrorToast(component);
                        }
                    } else {
                        component.set('v.msg', 'Unknown error');
                        this.showErrorToast(component);
                    }
                }
            });
            $A.enqueueAction(action);
        }else{
            component.set('v.msg', "Inserire descrizione Allegato");
            this.showErrorToast(component);
            console.log('Document ID: ' +documentId);
            var action = component.get("c.Attachment");
            action.setParams({
//                DownloadAttachmentID: id,
                DownloadAttachmentID: documentId,
                s : 'C'
            });
            action.setCallback(this, function(b){
                console.log('b.getState -> ' + b.getState());
                if(b.getState()=='SUCCESS'){
                    console.log('passo di qui');
                    component.set("v.refresh", false);
                    component.set("v.refresh", true);
                    $A.get("e.force:refreshView").fire();                }
            });
            $A.get("e.force:refreshView").fire();
            $A.enqueueAction(action);
        }
        component.set("v.refresh", false);
        component.set("v.refresh", true);
        location.reload();
        $A.get("e.force:refreshView").fire();
    },

    handleDownloadFile : function(component, event){
        console.log('-------------------------------------------------------');
        console.log('-- Controller JS: CRMDinieghiSDDHelper - Method: handleDownloadFile');         

        var id = event.target.getAttribute("data-id");       
        console.log('Document ID: ' +id);
        var action = component.get("c.Attachment");
        action.setParams({
            DownloadAttachmentID: id,
            s : 'D'
        });
        action.setCallback(this, function(b){
            console.log('b.getState -> ' + b.getState());
            if(b.getState()=='SUCCESS'){
                console.log('passo di qui');
                component.set("v.Baseurl", b.getReturnValue());
                var urlEvent = $A.get("e.force:navigateToURL");
                urlEvent.setParams({
                    "url": b.getReturnValue()
                });
	            urlEvent.fire();
            }
        });
         $A.enqueueAction(action);
    },    

    handleCancellaFile : function(component, event){
        console.log('-------------------------------------------------------');
        console.log('-- Controller JS: SFACommodity_GestioneHelper - Method: handleCancellaFile');         

        var id = event.target.getAttribute("data-id");       
        console.log('Document ID: ' +id);
        var action = component.get("c.Attachment");
        action.setParams({
            DownloadAttachmentID: id,
            s : 'C'
        });
        action.setCallback(this, function(b){
            console.log('b.getState -> ' + b.getState());
            if(b.getState()=='SUCCESS'){
                console.log('passo di qui');
                component.set("v.refresh", false);
                component.set("v.refresh", true);
//                component.set("v.Baseurl", b.getReturnValue());
//                var urlEvent = $A.get("e.force:navigateToURL");
//                urlEvent.setParams({
//                    "url": b.getReturnValue()
//                });
//                urlEvent.fire();
            }
        });
        $A.enqueueAction(action);
    },

    handleGetFile : function(component, event, sCaseId){
        console.log('-------------------------------------------------------');
        console.log('-- Controller JS: SFACommodity_GestioneHelper - Method: handleGetFile');         
        
        var caseId = sCaseId;
        var action = component.get("c.getFile");
		console.log('casaeId -> ' + caseId);
        action.setParams({ 
            recordId : caseId
        });
        action.setCallback(this, function(resp) {
            if(resp.getState()=='SUCCESS'){
                console.log('resp--> ');
                console.log(resp.getReturnValue());
                var listaf = resp.getReturnValue();
                
                console.log('----------');
                for(var x in listaf){
                    console.log(listaf[x].Id);
                    console.log(listaf[x].ContentDocument.Title);
                    console.log(listaf[x].ContentDocument.Id);
                }
                component.set("v.elencoF",resp.getReturnValue());
                
                this.handleGetCompleta(component, sCaseId);
                $A.get("e.force:refreshView").fire();
            }
        });
        $A.enqueueAction(action);
        component.set("v.refresh", false);
        component.set("v.refresh", true);

        $A.get("e.force:refreshView").fire();
    },

    handleGetCompleta : function(component, sCaseId){
        console.log('-------------------------------------------------------');
        console.log('-- Controller JS: SFACommodity_GestioneHelper - Method: handleGetCompleta');         
        
        var caseId = sCaseId;
        var action = component.get("c.getFileCompleta");
		console.log('casaeId -> ' + caseId);
        action.setParams({ 
            recordId : caseId
        });
        action.setCallback(this, function(resp) {
            if(resp.getState()=='SUCCESS'){
                console.log('resp--> ');
                console.log(resp.getReturnValue());
                var listac = resp.getReturnValue();
                var listaFile = component.get('v.elencoF');

                var items = []; //new Array();

                console.log('-+-+-+-+-+-+-+-+-+-');
                for(var x in listaFile){
                    for(var y in listac){
                        if(listac[y].ContentDocumentId==listaFile[x].ContentDocument.Id){
//                            items[x] = new Array();
                            console.log(listac[y].Completa__c);
                            console.log(listac[y].ContentDocumentId);
                            console.log(listaFile[x].ContentDocument.Id);    

                            var item = {
                                "ContentDocumentId":listac[y].ContentDocumentId,
                                "Title":listaFile[x].ContentDocument.Title,
                                "CreatedDate":listaFile[x].ContentDocument.CreatedDate,
                                "Description":listaFile[x].ContentDocument.Description,
                                "Completa":listac[y].Completa__c
                            };
        //                    console.log('value--> '+i.Esito_Chiusura__c + " - "+i.Descrizione_Esito__c);
                            items.push(item);

                        }
                    }
                }
                console.log('+++++++++++++++++');
                console.log(items);
                component.set('v.elencoFile',items);
            }
        });
        $A.enqueueAction(action);
        component.set("v.refresh", false);
        component.set("v.refresh", true);
        $A.get("e.force:refreshView").fire();
    },

    gotoList : function (component, event) {
        console.log('************');
        console.log('FUNCTION gotoList');
        var action = component.get("c.getListViews");
        var cat = component.get('v.selectedActivity[0].Activity_id__r.Categoria_Riferimento__r.Name');
        var sUser = component.get('v.userIsBO');
        var sCat;
        console.log('action ' + action);
        console.log('cat ' + cat);
        console.log('sUser ' + sUser);
        if(sUser==true){
            console.log('sUser==true');
            sCat = cat;
            console.log('2 sUser==true');
        }else{
            console.log('sUser==false');
            sCat = "MD - " + cat;
            console.log('2 sUser==false');
        }
        console.log('scat' + sCat);
        action.setParams({ 
            sName : sCat
        });
        console.log('dopo setparams');
        action.setCallback(this, function(response){
            var state = response.getState();
            console.log('state' + state);
            if (state === "SUCCESS") {
                var listviews = response.getReturnValue();
                console.log('*****************');
                console.log(listviews);
                console.log(listviews[0].Id);
                console.log(listviews[0].Name);
                
                var navEvent = $A.get("e.force:navigateToList");
                navEvent.setParams({
                    "listViewId": listviews[0].Id,
                    "listViewName": null,
                    "scope": "Case"
                });
                navEvent.fire();
            }
        });
        console.log('prima enqueueAction');
        
        $A.enqueueAction(action);
    }    
})