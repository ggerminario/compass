({
    init : function(cmp, event, helper) 
    {
        console.log('********' + cmp.get('v.idCliente'));
        var spinner = cmp.find('spinnerComponent');
        spinner.incrementCounter(); 
        var action = cmp.get('c.doHandlerInit');
        action.setParams({
            'customerId' : cmp.get('v.idCliente') 
        });
        action.setCallback(this, function(response)
                           {
                               if(response.getState() == 'SUCCESS' ) 
                               {
                                   var wrapInit = response.getReturnValue();
                                  // var pageReference = cmp.get("v.pageReference");
                                   console.log('*******######################## CAllback');
                                   var vectorRetention = wrapInit.listaRetention;
                                   var arrayLength = wrapInit.arrayLength;
                                   var listRet = [];
                                   console.log('im here arraylenght : ' +  arrayLength);
                                   
                                   var customerId = wrapInit.customerId;
                                   console.log('*********** + ' + customerId);
                                   var customerPersonEmail = wrapInit.customerEmail;
                                   var customerTelefono = wrapInit.customerTelefono;
                                   var customerOCS = wrapInit.customerOCSCode;
                                   var customerLastname = wrapInit.customerLastname;
                                   for(var i = 0; i < arrayLength; i++)
                                   {
                                       console.log("CIAO FOR  " + JSON.stringify(wrapInit.listaRetention[i]));
                                       listRet[i] = wrapInit.listaRetention[i];
                                   }
                                   console.log("******************************");
                                   console.log(wrapInit.retentionNonPossibile);
                                   console.log(JSON.stringify(wrapInit.listaRetention));
                                   cmp.set("v.retentionNonPossibile",wrapInit.retentionNonPossibile);
                                   cmp.set("v.descRetention",wrapInit.retentionDesc);
                                   cmp.set("v.listaRetention",listRet);
                                   cmp.set("v.customerId", customerId);
                                   cmp.set("v.customerLastname",customerLastname);
                                   cmp.set("v.customerEmail",customerPersonEmail);
                                   cmp.set("v.customerCellulare",customerTelefono);
                                   cmp.set("v.customerOCSCode",customerOCS);
                                   cmp.set("v.esitoCustomer",wrapInit.esitoCliente);
                                   cmp.set("v.esitoDescriptionCustomer",wrapInit.esitoDescriptionCustomer);
                                   cmp.set("v.valoreCustomer",wrapInit.valoreCliente);        
                                  // cmp.set("v.reference",{
                                   //    type: 'standard__component',
                                    //   attributes: {
                                     //      componentName: 'c__' + pageReference.state.c__redirectComponentName
                                    //   },
                                   //    state: {
                                   //        "c__postvenditaId": pageReference.state.c__redirectPostvenditaId
                                   //    }
                                   //});
                                   cmp.set("v.tableColumns", [
                                       {label: 'Procedura', fieldName: 'tipoPratica', type: 'text' ,fixedWidth:120},
                                       {label: 'Num Pratica', fieldName: 'numPratica', type: 'text',fixedWidth:120},
                                       {label: 'Stato Pratica', fieldName: 'statoPratica', type: 'text',fixedWidth:120},
                                       {label: 'Attributo Pratica', fieldName: 'attributoPratica', type: 'text',fixedWidth:120},
                                       {label: 'Flag Partner', fieldName: 'partner', type: 'text',fixedWidth:120},
                                       {label: 'Prima Data Scadenza', fieldName: 'dataPrimaScadenza', type: 'text',fixedWidth:120},
                                       {label: 'Cod Prodotto', fieldName: 'codProdotto', type: 'text',fixedWidth:120},
                                       {label: 'Des Prodotto', fieldName: 'desProdotto', type: 'text',fixedWidth:120},
                                       {label: 'Mod Pagamento', fieldName: 'modalitaPagamento', type: 'text',fixedWidth:120},
                                       {label: 'Importo Finanziato', fieldName: 'importoFinanziato', type: 'text',fixedWidth:120},
                                       {label: 'Montante', fieldName: 'montante', type: 'text',fixedWidth:120},
                                       {label: 'Data Liquidazione', fieldName: 'dataLiquidazione', type: 'text',fixedWidth:120},
                                       {label: 'Data Estinzione', fieldName: 'dataEstinzione', type: 'text',fixedWidth:120},
                                       {label: 'Saldo Pratica', fieldName: 'saldoPratica', type: 'text',fixedWidth:120},
                                       {label: 'Cod Cliente', fieldName: 'codCliente', type: 'text',fixedWidth:120},
                                       {label: 'Canale', fieldName: 'source', type: 'text',fixedWidth:120}
                                   ]);
                                   cmp.set("v.radioGroupOptionConsenso",[
                                       {'label': 'Si' , 'value' : 'true'},
                                       {'label': 'No', 'value': 'false'}
                                   ]);
                                   
                                   cmp.set("v.listaFasciaOraria",[
                                       {"label" : "Nessuna Preferenza (9-18)", "value" : "9-18"},
                                       {"label" : "9-12", "value" : "9-12"},
                                       {"label" : "9-15", "value" : "9-15"},
                                       {"label" : "15-18", "value" : "15-18"}
                                   ]);    
                               }
                               spinner.decreaseCounter();
                           });
        $A.enqueueAction(action);
    },
    getSelected : function(cmp,event,helper)
    {
        var selectedRows = event.getParam('selectedRows');
        cmp.set('v.listaRetentionSelezionata',selectedRows);    
    },
    reSendToPostvendita : function(cmp,event,helper)
    {   
        var codCliente = cmp.get('v.customerOCSCode');
        var codCategoria = cmp.get('v.estinzioneAnticipataCatId');
        
        var evt = $A.get("e.force:navigateToComponent");
        evt.setParams({
            componentDef : "c:PVInserimento",
            /*componentAttributes: {
                'pvRequest' : pvRequest
			}*/
			componentAttributes : {
                parametriEsterni : { 
                    "codClienteOCS" : codCliente ? codCliente.replace('C','') : '',
					"codCategoria"  : codCategoria ? codCategoria : null,
                    //"codPraticaOCS" : mappa.codPraticaOCS,
                    "parentId" : ''
                }
            }
        });
		evt.fire();
        
        
        
        
    },
    handleSelezionaFascia : function(cmp,event,helper)
    {
        var fascia = cmp.find("fasciaOrariaSelezione").get("v.value");
        cmp.set("v.fasciaSelezionata", fascia);
        console.log("*** fascia selezionata :: " + fascia);
        
    },
    closeAttivita : function(cmp,event,helper)
    {
        var spinner = cmp.find('spinnerComponent');
        spinner.incrementCounter();
        console.log('CompletaAttivita');
        var action = cmp.get('c.completaAttivita');
        action.setParams({
            'noteUtente' : cmp.get('v.noteValue') ,
            'esitoCliente' : cmp.get('v.esitoCustomer'),
            'valoreCliente': cmp.get('v.valoreCustomer') ,
            'customerId' : cmp.get('v.customerId'),
            'customerEmail' : cmp.get('v.customerEmail'),
            'customerCellulare' : cmp.get('v.customerCellulare'),
            'flagPrivacy' : cmp.get('v.radioGroupOptionConsensoValue'),
            'fasciaOraria' : cmp.get('v.fasciaSelezionata'),
            'listRetention' : cmp.get('v.listaRetentionSelezionata')
        });
        action.setCallback(this, function(response)
                           {
                               if(response.getState() == 'SUCCESS' ) 
                               {
                                           console.log('CompletaAttivita 2');

                                   var toastEvent = $A.get("e.force:showToast");
                                   var returnObj = response.getReturnValue();
                                   var retentionNonPossibile = returnObj.retentionNonPossibile;
                                   var check = returnObj.res;
                                   var messToast = returnObj.messToast;
                                   if(retentionNonPossibile)
                                   {
                                               console.log('CompletaAttivita 3');

                                       cmp.set('v.retentionNonPossibile',retentionNonPossibile);
                                   }
                                   else
                                   {
                                               console.log('CompletaAttivita 4');

                                       if(check)
                                       {
                                                   console.log('CompletaAttivita 5');

                                           toastEvent.setParams({
                                               "title": "Successo",
                                               "message": "Chiudere la chiamata",
                                               "type" : "Success"	
                                           });
                                           toastEvent.fire();
                                           cmp.set('v.endMessage',messToast);
                                           cmp.set('v.checkEndMessagge', false);
                                       }
                                       else
                                       {
                                           toastEvent.setParams({
                                               "title": "Attenzione",
                                               "message": messToast,
                                               "type" : "Warning",
                                               "duration": "5000"
                                           });
                                           toastEvent.fire();
                                       }
                                   }
                               }
                               spinner.decreaseCounter();
                           });
        $A.enqueueAction(action);
    },
    oldInit : function(cmp, event, helper){
        var action = cmp.get('c.doHandlerInit');
        action.setParams({
            'customerId' : cmp.get('v.customerId') 
        });
        action.setCallback(this, function(response)
                           {
                               if(response.getState() == 'SUCCESS' ) 
                               {
                                   
                                   
                                   
                                   
                               }
                           });
        
        
        
        var pageReference = cmp.get("v.pageReference");
        console.log('*******########################' + JSON.stringify(pageReference));
        var vectorRetention = pageReference.state.c__listaRetention;
        var arrayLength = pageReference.state.c__arrayLength;
        var listRet = [];
        console.log('im here arraylenght : ' +  arrayLength);
        
        var customerId = pageReference.state.c__customerId;
        console.log('*********** + ' + customerId);
        var customerPersonEmail = pageReference.state.c__customerEmail;
        var customerTelefono = pageReference.state.c__customerTelefono;
        var customerOCS = pageReference.state.c__customerOCSCode;
        var customerLastname = pageReference.state.c__customerLastname;
        for(var i = 0; i < arrayLength; i++)
        {
            console.log("CIAO FOR  " + JSON.stringify(pageReference.state.c__listaRetention[i]));
            listRet[i] = pageReference.state.c__listaRetention[i];
        }
        console.log("******************************");
        console.log(pageReference.state.c__retentionNonPossibile);
        console.log(JSON.stringify(pageReference.state.c__listaRetention));
        cmp.set("v.retentionNonPossibile",pageReference.state.c__retentionNonPossibile);
        cmp.set("v.descRetention",pageReference.state.c__retentionDesc);
        cmp.set("v.listaRetention",listRet);
        cmp.set("v.customerId", customerId);
        cmp.set("v.customerLastname",customerLastname);
        cmp.set("v.customerEmail",customerPersonEmail);
        cmp.set("v.customerCellulare",customerTelefono);
        cmp.set("v.customerOCSCode",customerOCS);
        cmp.set("v.esitoCustomer",pageReference.state.c__esitoCliente);
        cmp.set("v.esitoDescriptionCustomer",pageReference.state.c__esitoDescriptionCustomer);
        cmp.set("v.valoreCustomer",pageReference.state.c__valoreCliente);        
        cmp.set("v.reference",{
            type: 'standard__component',
            attributes: {
                componentName: 'c__' + pageReference.state.c__redirectComponentName
            },
            state: {
                "c__postvenditaId": pageReference.state.c__redirectPostvenditaId
            }
        });
        cmp.set("v.tableColumns", [
            {label: 'Procedura', fieldName: 'tipoPratica', type: 'text' ,fixedWidth:120},
            {label: 'Num Pratica', fieldName: 'numPratica', type: 'text',fixedWidth:120},
            {label: 'Stato Pratica', fieldName: 'statoPratica', type: 'text',fixedWidth:120},
            {label: 'Attributo Pratica', fieldName: 'attributoPratica', type: 'text',fixedWidth:120},
            {label: 'Flag Partner', fieldName: 'partner', type: 'text',fixedWidth:120},
            {label: 'Prima Data Scadenza', fieldName: 'dataPrimaScadenza', type: 'text',fixedWidth:120},
            {label: 'Cod Prodotto', fieldName: 'codProdotto', type: 'text',fixedWidth:120},
            {label: 'Des Prodotto', fieldName: 'desProdotto', type: 'text',fixedWidth:120},
            {label: 'Mod Pagamento', fieldName: 'modalitaPagamento', type: 'text',fixedWidth:120},
            {label: 'Importo Finanziato', fieldName: 'importoFinanziato', type: 'text',fixedWidth:120},
            {label: 'Montante', fieldName: 'montante', type: 'text',fixedWidth:120},
            {label: 'Data Liquidazione', fieldName: 'dataLiquidazione', type: 'text',fixedWidth:120},
            {label: 'Data Estinzione', fieldName: 'dataEstinzione', type: 'text',fixedWidth:120},
            {label: 'Saldo Pratica', fieldName: 'saldoPratica', type: 'text',fixedWidth:120},
            {label: 'Cod Cliente', fieldName: 'codCliente', type: 'text',fixedWidth:120},
            {label: 'Canale', fieldName: 'source', type: 'text',fixedWidth:120}
        ]);
        cmp.set("v.radioGroupOptionConsenso",[
            {'label': 'Si' , 'value' : 'true'},
            {'label': 'No', 'value': 'false'}
        ]);
        
        cmp.set("v.listaFasciaOraria",[
            {"label" : "Nessuna Preferenza (9-18)", "value" : "9-18"},
            {"label" : "9-12", "value" : "9-12"},
            {"label" : "9-15", "value" : "9-15"},
            {"label" : "15-18", "value" : "15-18"}
        ]);    
        
    }
})