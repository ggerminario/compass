({
    init:function(cmp,event,helper){
       
		     
        if(cmp.get('v.dettagliMessage')==undefined){ 
            cmp.set('v.isDettagliOk',true);
        }

        helper.getAss(cmp);
        helper.getAttachmentIDM(cmp,event,helper);
        helper.getAttachment(cmp,event,helper);
        helper.getIsCloned(cmp,event,helper);
        //helper.getValueDecisione(cmp,event,helper);
        
       
    },
    
   
    
    settaClientePratica : function(cmp,event, helper){
        var cliente = event.getParam("cliente");
        var pratica = event.getParam("pratica");
          console.log('pratica@@');
        console.log(JSON.stringify(pratica));
        cmp.set("v.clienteSelezionatoContainer", cliente);
         cmp.set("v.praticaSelezionataContainer", pratica);
        

        var inserimentoContainer = cmp.find("ReclamiInserimentoContainerPadre");
        if(inserimentoContainer == null) return;
         console.log('inserimentoContainer');
        console.log(inserimentoContainer);
        var inserimentoRiepilogoCliente = inserimentoContainer.find("InserimentoRiepilogoCliente");
        if(inserimentoRiepilogoCliente == null) return;
        var inserimentoRiepilogoPratica = inserimentoRiepilogoCliente.find("InserimentoRiepilogoPratica");
        inserimentoRiepilogoPratica.refresh();
    },
    
    cambiaInserimentoCliente:function(cmp,event, helper){
      cmp.set("v.InserimentoClienteInit", false); 
     
    },
    
    recuperaAssicurazione:function(cmp,event, helper){
        
        /*window.setTimeout(
            $A.getCallback(function() {
                helper.settaDatiPraticaAggiuntivi(cmp, event);
            }), 3000
        );*/
     
       
    },
    
    changePratica :function(cmp,event, helper){
        if(cmp.get('v.praticaSelezionataContainer') != undefined) helper.recuperaAssicurazione(cmp, event);
    },
    
    cambiaStatoChiusura : function(cmp,event, helper){
        var isGestito = cmp.get('v.isGestito');
        if(isGestito){
            cmp.set("v.status", 'Gestito');
            cmp.set('v.campiCase.Status','Gestito');
        }
    },
    
    handleCaseUpdated:function(cmp,event,helper){
        var eventParams = event.getParams();
        if(eventParams.changeType === "LOADED"){
            var azienda=cmp.get('v.campiCase')['Referenced_Company__c'];
            cmp.set('v.accountClienteId',azienda=='Compass' ? cmp.get('v.campiCase')['AccountId'] : cmp.get('v.campiCase')['Account_Futuro_MBCS__c']);
            
            cmp.set('v.isCaseLoaded',true);
            cmp.set("v.statoIniziale", cmp.get("v.campiCase").Status);

        }
        else{
         
        }
    },
    
    handleAccountUpdated:function(cmp,event,helper){
        var eventParams = event.getParams();
        if(eventParams.changeType === "LOADED"){
            console.log('Account loaded');
            helper.loadCustomData(cmp,helper);
        }
    },
    
    rebuildDettagliOutputObj:function(cmp,event,helper){  
        
        console.log('//*/*//*/*/*/');
        console.log('avviamento rebuild');
        console.log('/*/*/*/*/*/');
        //helper.rebuildDettagliOutputObjHelper(cmp);
        
    },
    
    annullaSalvataggio: function(cmp,event,helper){
        cmp.set('v.confermaReclamoAssociato', false);
    },
    
    salvaReclamoAuraMethod : function(cmp,event,helper){
        
        
        //Reclamo Associato
        var reclamoAssociato = cmp.get("v.reclamoSelezionato");
        var btn=event.getSource();
        var conferma = btn.get("v.name");

        
        if(reclamoAssociato!=undefined && conferma!='ReclamoAssociatoOk'){
            cmp.set("v.confermaReclamoAssociato", true);
            return; 
        }
        if(conferma == 'ReclamoAssociatoOk')  cmp.set("v.confermaReclamoAssociato", false);
        //Mittenti 
        var cliente = cmp.get("v.clienteSelezionatoContainer");
        if(cliente == undefined){
             cmp.set("v.toastMsg","Devi inserire il cliente (Tab )");
                helper.showToastError(cmp); 
                return;
        }
        var lista = cmp.get('v.mittentiList');
        var isPrincipale = false;
        if(lista==undefined || lista.length==0){
             cmp.set("v.toastMsg","Devi inserire almeno un mittente");
            helper.showToastError(cmp); 
            return;
        }
        
        for(var i = 0; i<lista.length;i++){
            var mit = lista[i];
            if(mit.Principale__c && isPrincipale){
                cmp.set("v.toastMsg","Il mittente principale deve essere unico");
                helper.showToastError(cmp); 
                return;
            }
            else if(mit.Principale__c){
                isPrincipale = true;
            }
        }
        if(!isPrincipale){
            cmp.set("v.toastMsg","Il mittente principale non è stato settato");
            helper.showToastError(cmp); 
            return;
        }
        
        //
        
        
        //Chiusura check
        var stato = cmp.get("v.status");
        var statoIniziale = cmp.get("v.statoIniziale");
        var tabChiusura = cmp.find("Chiusura");
        if(stato != statoIniziale && tabChiusura == undefined && stato == 'Gestito'){
            cmp.set("v.toastMsg","Devi completare il tab Chiusura");
            helper.showToastError(cmp); 
            return;
        }
        //Controllo Decisione in fase chiusura
        if(stato == 'Gestito' && tabChiusura != undefined){
            var t = cmp.get("v.tipoDettagliContainerTipo");
            if(t=='5413' || t=='5414' ||t=='5415' ||t=='5416' ||t=='5417' ||t=='5418' || t=='5419' || t=='5420' || t=='5412'){
                var dec = cmp.get("v.decisioneChiusura");
                if(dec == undefined || dec == ''){
                    cmp.set("v.toastMsg","Tab Chiusura - Valore Decisione mancante");
                    helper.showToastError(cmp); 
                    return;
                }
            }
        }
        //
        
        //Boris Inizio: Salvo la lettera di risposta
        var rispostaContainer = cmp.find("CRMReclamiGestioneRispostaContainerComponent");
    
        if(rispostaContainer != undefined && rispostaContainer != null){
            var letteraRisposta = rispostaContainer.find("LetteraRispostaComponent");
            if(letteraRisposta!=null && letteraRisposta!= undefined){
               letteraRisposta.save(); 
            }
        }
        //Boris Fine: Salvo la lettera di risposta
        
        //Gestione Approvazione Inizio
        console.log('Salvo lettera risposta Autorizzazione '+cmp.get('v.salvaLetteraRisposta'));
        if(cmp.get('v.salvaLetteraRisposta')){
            var autorizzazione = cmp.find("CRMReclamiGestioneRispostaContainerComponent");
            console.log('Chiamo Autorizzo ')
            autorizzazione.autorizzo();
            cmp.set("v.salvaLetteraRisposta", false);
        }
        
        
        //Gestione Approvazione FIne
        
        
        var coda = cmp.get("v.codaSelezionata");
       
        var json = JSON.stringify(coda);
   
        //Controllo Coda
        
        if(coda == null || coda == undefined || coda == ''){
           helper.showToast(null, 'Salvataggio','error','Devi selezionare una coda');
            return ;
        }
        
        //Controllo Modalità Invio
        
        var invio = cmp.get('v.modalitaInvioDettagli');
        console.log('/###########################/');
        console.log(invio);
         if(invio == null || invio == undefined || invio == 'Selezionare Modalità'){
            
           helper.showToast(null, 'Salvataggio','error','Devi selezionare la modalità di invio');
            return ;
        }
        //Controllo Stato
        var stato = cmp.get('v.status');
        
        if(stato == ''){
              helper.showToast(null, 'Salvataggio','error','Devi selezionare lo stato del Reclamo');
            return;
        }
        
        //Controllo Data Ricezione e Data Ricezione IDM
       	var dataRicez = new Date(cmp.get("v.dataRicezione"));
        var dataRicezIDM = new Date(cmp.get("v.dataRicezioneIDM"));
        var dataComun = new Date(cmp.get("v.dataComunicazione"));
        var today = new Date();
      
		    
        
        var risValue = cmp.get("v.rimborsoValue");
        
        //RICERCA RICHIESTE
     //   var ricercaRichiesta = cmp.find("ReclamiInserimentoContainer");
     //   if(ricercaRichiesta)ricercaRichiesta.salvaGestione();
        
        console.log('*****************à°°°°°°°°°°°°°°°°°°°°°°v.campiCasePost');  
        console.log(cmp.get('v.campiCase'));  
        console.log(cmp.get('v.currentCase'));
        
        var caseHeader;
        var gestioneHeader = cmp.find("gestioneHeader");
        if(gestioneHeader != undefined) caseHeader = gestioneHeader.salvaReclamoGestioneHeader();
		
      // console.log('ricercaRichiesta');
      //  console.log(ricercaRichiesta);
        console.log('caseHeader');
        console.log(caseHeader);
        
        
        
        var cChiusuraDouble = {};
        var cChiusura = {};
        var cChiusuraResponsabilitaSel = null; 
        if(cmp.get('v.tabChiusura')){
            var chiusura = cmp.find("Chiusura");
           
            if(chiusura!=null&&chiusura!=undefined){
                cChiusura = chiusura.makeChiusura();
                cChiusuraDouble = chiusura.makeCaseChiusuraDouble();
                cChiusuraResponsabilitaSel = chiusura.getResponsabilitaSel();
                //FIX Radio Button con relativi importi

                var azienda = cmp.get('v.campiCase');
                var aziendaSelezionata = azienda.Referenced_Company__c;

                var isValid = 'ko';

                if(aziendaSelezionata == 'Compass'){
                    isValid = chiusura.checkCompass();
                }else if(aziendaSelezionata == 'Futuro'){
                    isValid = chiusura.checkFuturo();
                }else{
                    isValid = chiusura.checkCompass();
                }

                if(isValid != 'ok') {
                    helper.showToast(cmp, 'Errore', 'error', 'Errore '+isValid);
                    return
                }
            }
        }
        
        var cAggiuntivi = {}; 
        var tipo = cmp.get("v.tipoDettagliContainerTipo");
        
        var salvaReclamoCampiAggiuntivi = cmp.find("salvaReclamoCampiAggiuntivi");
        var tipoIniziale = cmp.get("v.tipoIniziale");
        var tipo = cmp.get("v.tipoDettagliContainerTipo");
        if(salvaReclamoCampiAggiuntivi == undefined && (tipoIniziale!="5409" && tipoIniziale!="5410") && (tipo=="5410" || tipo=="5409") ){
             helper.showToast(cmp, 'Errore Salvataggio tab Dettagli', 'error', 'Completa tutti i campi');
            return;
        }
        if(salvaReclamoCampiAggiuntivi  != undefined){
            var cAggiuntivi = salvaReclamoCampiAggiuntivi.salvaReclamoCampiAggiuntivi();
            if(tipo=='5409' || tipo=='5410'){
                if(cAggiuntivi['trattabile'] == undefined || cAggiuntivi['trattabile']=='Selezionare'){
                    helper.showToast(cmp, 'Errore Salvataggio tab Dettagli', 'error', 'Completare il campo Trattabile');
                    return;
                }
             
                if(cAggiuntivi['tipoProdottoVita'] == undefined || cAggiuntivi['tipoProdottoVita'] == ''){
                    helper.showToast(cmp, 'Errore Salvataggio tab Dettagli', 'error', 'Completare il campo Tipo Prodotto Vita');
                    return;
                }
              
                if(cAggiuntivi['tipoProdottoDanni'] == undefined || cAggiuntivi['tipoProdottoDanni'] == ''){
                    helper.showToast(cmp, 'Errore Salvataggio tab Dettagli', 'error', 'Completare il campo Tipo Prodotto Danni');
                    return;
                }
                if(cAggiuntivi['areaAziendale'] == undefined || cAggiuntivi['areaAziendale'] == ''){
                    helper.showToast(cmp, 'Errore Salvataggio tab Dettagli', 'error', 'Completare il campo Area Aziendale');
                    return;
                }
                if(cAggiuntivi['tipoProponente'] == undefined || cAggiuntivi['tipoProponente'] == ''){
                    helper.showToast(cmp, 'Errore Salvataggio tab Dettagli', 'error', 'Completare il campo Tipo Proponente');
                    return;
                }
                if(cAggiuntivi['tipoReclamante'] == undefined || cAggiuntivi['tipoReclamante'] == ''){
                    helper.showToast(cmp, 'Errore Salvataggio tab Dettagli', 'error', 'Completare il campo Tipo Reclamante');
                    return;
                }
                if(cAggiuntivi['areaGeograficaProponente'] == undefined || cAggiuntivi['areaGeograficaProponente'] == ''){
                    helper.showToast(cmp, 'Errore Salvataggio tab Dettagli', 'error', 'Completare il campo Area Proponente');
                    return;
                }
            }
        }
        var oldInadempimentoGravita = cmp.get('v.isInadempimento');
        var newInadempimentoGravita = cmp.get('v.inadempimentoGravita') == 'Uff Legale - Grave' ? true : false;
        var isGraveToNonGrave = false;
        if (cmp.get('v.isInadempimento')){
            if ( oldInadempimentoGravita && !newInadempimentoGravita ){
                isGraveToNonGrave = true;
                helper.cambiamentoGravita(cmp,cmp.get('v.recordId'),isGraveToNonGrave,cmp.get('v.inadempimentoStageOld') ) ;
            } else if(! oldInadempimentoGravita && newInadempimentoGravita){
                isGraveToNonGrave= false;
                helper.cambiamentoGravita(cmp,cmp.get('v.recordId'),isGraveToNonGrave,cmp.get('v.inadempimentoStageOld') ) ;
            }
        } 
    
        

        if (!cmp.get('v.isDettagliOk')) {
            //alert(cmp.get('v.dettagliMessage'));
            cmp.set("v.toastMsg", 'Campi vuoti o non validi: '+cmp.get('v.dettagliMessage'));
            helper.showToastError(cmp);
        }else{
            console.log('ReclamoSel: ');
            console.log(cmp.get('v.reclamoSelezionato'));

            var action= cmp.get("c.salvaReclamoTotale");
            action.setParams({
                'recordId' : cmp.get('v.recordId'),
                'caseHeader' : caseHeader,
                'cChiusura' : cChiusura,
                'cChiusuraDouble' : cChiusuraDouble,
                'caseDettagli' : helper.makeDettagli(cmp),
                'caseDettagliDouble' : helper.makeDettagliDouble(cmp),
                'cAggiuntivi' : cAggiuntivi,
                'isInadempimento' : cmp.get('v.isInadempimento'),
                'stageInadempimento' : cmp.get('v.inadempimentoStage'),
                'respSelected' : cChiusuraResponsabilitaSel
            });
            action.setParam('fileList',cmp.get('v.fileList'));
            action.setParam('mittentiList',cmp.get('v.mittentiList'));
            action.setParam('cCliente',cmp.get('v.clienteSelezionatoContainer'));
            action.setParam('reclamoSelezionato',cmp.get('v.reclamoSelezionato'));
  
 
            action.setCallback(this,function(resp){
                if(resp.getState()=='SUCCESS'){
                    //Inadempimento
                    var inadempimento = cmp.find('Inadempimento')
                    if (inadempimento != undefined){
                        helper.isInadempimento(cmp);
                        var x =  inadempimento.salvaReclamoInadempimento();
                        if(!x){
                            helper.showToast(cmp, 'Errore Salvataggio', 'error', 'Completare il tab inadempimento');
                            return;
                        }
                        
                    }
                    //helper.checkResponse(resp.getReturnValue());
                    helper.creaCopiaReclamoIDM(cmp,event,helper);
                    var mappa = resp.getReturnValue();
                    if(mappa.Status != undefined && mappa.Status == '1005'){
                        cmp.set("v.status", 'F&T Sent');
                        cmp.set('v.campiCase.Status','F&T Sent');
                    }
                    helper.refresh(cmp,event, helper);

                    if(cmp.get('v.tabChiusura')){
                        var chiusura = cmp.find("Chiusura");
                        if(chiusura!=null&&chiusura!=undefined){
                            var statusReclamo =cmp.get("v.status");
                            chiusura.refresh(statusReclamo);
                        }
                    }
                    helper.refreshDaServer(cmp, event);
                    helper.showToast(cmp, 'Salvataggio', 'success','Salvataggio effettuato con successo');
                    debugger;
                    //window.location.reload();
                } 
                else{    
                    var error = resp.getError();
                    var msg = error[0].message;
                    
                    //alert('Problemi col salvataggio del reclamo...'+msg);
                    cmp.set("v.toastMsg", "Problemi col salvataggio del reclamo...");
                    helper.showToastError(cmp);

                }
                helper.hideSpinner(cmp);
            });
             helper.showSpinner(cmp); 
            $A.enqueueAction(action);
        }
        
       helper.isFrode(cmp);
      
        


    },
    
    checkInitAss : function(cmp,event,helper){    
        cmp.get('v.listaAss').forEach(function(temp){
            if(temp == cmp.get('v.tipoDettagliContainerTipo'))
                cmp.set('v.initAss', true);
            else
                cmp.set('v.initAss', false);                
        });
    },
    
    refresh : function(cmp, event, helper){
        
        helper.refresh(cmp,event, helper);
    },
    
    isInadempimento : function(cmp){
        var isGrave = cmp.get("v.isGrave");
        var delega = cmp.get("v.delegaPresente");
        var coda =  cmp.get("v.codaSelezionata");
        
        var isInadempimento = isGrave && delega == 'Si' && coda.DeveloperName == 'DN_57';
        cmp.set("v.isInadempimento", isInadempimento);
        
    },
    
    refreshDaServer : function(cmp, event, helper){
        helper.refreshDaServer(cmp, event);
    },
    
    aggiornaDataScadenza : function(cmp, event, helper){
        if(cmp.get("v.initTipoIniziale")){
            cmp.set("v.tipoIniziale", cmp.get("v.tipoDettagliContainerTipo"));
            cmp.set("v.initTipoIniziale", false);
        }
        helper.aggiornaDataScadenzaHelper(cmp, event);
    },

    prova: function(cmp, event, helper){

        //var label=event.getSource().get('v.label');
        //
        //if(label=='Tipo'){
            var tipo = cmp.get('v.tipoDettagliContainerTipo');
            cmp.set('v.tipoName',tipo);
            var x = cmp.get('v.tipoName');
            
        //}else if(label=='Data Decisione:'){
            var data = cmp.get('v.dataDecisione');
            if(data!=null && data!=undefined){
                cmp.set('v.dataDecisione',data);
                var y = cmp.get('v.dataDecisione');
                
            }
            
        //}

        var tabDettagli = cmp.find("ReclamiDettagli");
        if(tabDettagli!=null && tabDettagli!=undefined){
            
            tabDettagli.reload();
        }
        
        var accessoDati = cmp.get('v.accessoDati');
        
        if(accessoDati){
            var gestioneHeader = cmp.find("gestioneHeader");
            if(gestioneHeader!=null && gestioneHeader!=undefined){
                
                gestioneHeader.setScadenza();
            }
        }
        
        
        
    },
    
    refreshCorrispondenza : function(cmp){
       var corrispondenza = cmp.find("reclamiCorrispondenza");
        if(corrispondenza!=undefined){
           
            corrispondenza.refresh();
        }   
    },
    
    refreshRisposta : function(cmp){
       var risposta = cmp.find("CRMReclamiGestioneRispostaContainerComponent");
        if(risposta!=undefined){
            console.log('Refresho la lettera Risposta');
            risposta.refresh();
        }   
    },
    
    refreshDataScadenza : function(cmp){
        
    },
    
    salvaLetteraRispostaEvent : function(cmp){
        cmp.set('v.salvaLetteraRisposta', true);
    }
    
 })