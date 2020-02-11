/**
 * @File Name          : PVInserimentoHelper.js
 * @Description        : 
 * @Author             : Andrea Vanelli
 * @Group              : 
 * @Last Modified By   : Federico
 * @Last Modified On   : 3/2/2020, 14:52:58
 * @Modification Log   : 
 *==============================================================================
 * Ver         Date                     Author      		      Modification
 *==============================================================================
 * 1.0    11/8/2019, 17:20:04   Andrea Vanelli     Initial Version
**/
({
    inizializzaDatiBase: function (cmp, event, helper) {
        this.mostraClessidra(cmp, helper);

        // preparo gli allegati esterni
        var attachmentsIDs = cmp.get("v.parametriEsterni.attachmentsIDs");
        // imposto il form iniziale
        cmp.set('v.PVForm', {
            'sobjectype': 'PVForm',
            'attachmentsIDs': cmp.get("v.parametriEsterni.attachmentsIDs"),
            'attachmentList': [],
            'parentId': cmp.get("v.parametriEsterni.parentId")            
        });



        //recupero i dati User
        var actionU = cmp.get("c.getUserData");
        actionU.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                cmp.set("v.PVForm.userData", response.getReturnValue());
            } else {
                console.log("Utente non riconosciuto");
            }
        });
        $A.enqueueAction(actionU);

        // AV se viene passata da fuori la categoria carico solo quel PV
        var parametriEsterni = cmp.get("v.parametriEsterni");
        console.log("parametriEsterni : " + JSON.stringify(parametriEsterni));
        if ((!$A.util.isUndefinedOrNull(parametriEsterni)) && (!$A.util.isUndefinedOrNull(parametriEsterni.codCategoria)) && (parametriEsterni.codCategoria != '')) {
            // valorizzo la lista tipologia con un dato fittizzio
            var listTipologia = [{ label: '', value: null }];
            listTipologia.push({ label: "PostVendita", value: "9999999" });
            cmp.set("v.listTipologia", listTipologia);

            //carico la sottotipologia fissa
            var action = cmp.get("c.loadFixedSottotipologia");
            action.setParams({ "postVenditaId": parametriEsterni.codCategoria });
            action.setCallback(this, function (response) {

                var state = response.getState();
                if (state === "SUCCESS") {
                    cmp.set("v.listSottotipologia", response.getReturnValue());
                    // seleziono la prima voce
                    if (response.getReturnValue().length == 0) {
                        this.fireToast("Postvendita", "PV " + parametriEsterni.codCategoria + " non trovato in PostvenditaConfig_menu__mdt.", "error", 20000);
                        return;
                    }
                    console.log("prima voce:" + response.getReturnValue()[0].PostvenditaId__c);
                    if (!$A.util.isUndefinedOrNull(response.getReturnValue()[0])) {
                        // AV TODO selezionare la prima voce
                        cmp.find("sottotipologia").set("v.value", response.getReturnValue()[0].PostvenditaId__c);
                        //cmp.set("v.PVForm.categoriaPV.External_Id__c", response.getReturnValue()[0].PostvenditaId__c);
                        this.inizializzaDatiCategoria(cmp, event, helper);
                    }
                }
                this.nascondiClessidra(cmp, helper);
            });
            $A.enqueueAction(action);

        } else {
            // valorizzo la lista tipologia
            var listTipologia = [{ label: '', value: null }];
            var action = cmp.get("c.loadListaTipologia");
            action.setCallback(this, function (response) {

                var state = response.getState();
                if (state === "SUCCESS") {
                    var list = response.getReturnValue();
                    list.forEach(function (element) {
                        listTipologia.push({ label: element.MasterLabel__c, value: element.UniqueId__c });
                    });
                    cmp.set("v.listTipologia", listTipologia);
                }
                this.nascondiClessidra(cmp, helper);
            });
            $A.enqueueAction(action);

        }




    },
    onRender: function (cmp, event, helper) {
        // AV potrebbe non servire
        var childComponent = cmp.find('child');
        if ($A.util.isUndefinedOrNull(childComponent)) {
            cmp.set("v.isChildLoaded", false);
        } else {
            cmp.set("v.isChildLoaded", true);
            // blocco slezione PV
            try {

                var button = cmp.find('tipologia');
                button.set('v.disabled', true);
                button = cmp.find('sottotipologia');
                button.set('v.disabled', true);

                var button = cmp.find('btnInserisci');
                if (cmp.get("v.showMarkup")) {
                    button.set('v.disabled', false);
                } else {
                    button.set('v.disabled', true);
                }
            } catch (error) {

            }

        }



    },


    inserisciCase: function (cmp, event, helper) {
        var childComponent = cmp.find('child');
        var messaggi = "";

        // controllo selezione obbligatoria subtype e/o motivo

        if (!cmp.find("pvsubtype").checkValidity()) {
            cmp.find("pvsubtype").showHelpMessageIfInvalid();
            messaggi += "Selezionare la sottotipologia.<br>";
        }

        if (!cmp.find("psvreason").checkValidity()) {
            cmp.find("psvreason").showHelpMessageIfInvalid();
            messaggi += "Selezionare il motivo.<br>";
        }

        var allegatoOpt = cmp.get("v.PVForm.categoriaPV.Flag_Mostra_Allegati__c");
        if (allegatoOpt == "REQUIRED") {
            var invioViaFax = cmp.find("checkFax").get('v.checked');
            //var quantiAllegati = cmp.get('v.PVForm.attachmentList').length;
            //#sabry
            var quantiAllegati = 0
            if (!$A.util.isUndefinedOrNull(cmp.get('v.PVForm.attachmentList'))) {
                quantiAllegati = cmp.get('v.PVForm.attachmentList').length;
            }
            if (invioViaFax == false && quantiAllegati == 0) {
                messaggi += "Allegare un documento o inviare via fax";
            }
        }
        cmp.set("v.messaggiErrore", messaggi);
        if (messaggi == '') {
            childComponent.inserisciCase();
        }

    },

    
    //valorizzo la lista sottoTipologia
    getListaCategorie: function (cmp, event, helper) {
        this.mostraClessidra(cmp, helper);

        cmp.set("v.PVForm.categoriaPV", {});	//svuoto sottotipologia
        //svuoto i valori della ricerca cliente/pratica
        cmp.set("v.listPsvreason", []);
        cmp.set("v.listPvsubtype", []);

        var childComponent = cmp.find('ricercaOCS');
        if (!$A.util.isUndefinedOrNull(childComponent)) {
            childComponent.resetRicerca();
        }
        // AV serve anche il profile name
        console.log("v.PVForm.userData.user.Profile.Name: " + cmp.get("v.PVForm.userData.user.Profile.Name"));

        var action = cmp.get("c.loadListaSottotipologia");
        action.setParams({
            "tipologiaSelezionata": cmp.find("tipologia").get("v.value"),
            "branchOrOffice": cmp.get("v.PVForm.userData.user.Branch_Or_Office__c"),
            "profileName": cmp.get("v.PVForm.userData.user.Profile.Name")
        });

        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                cmp.set("v.listSottotipologia", response.getReturnValue());

            }
            this.nascondiClessidra(cmp, helper);
        });
        $A.enqueueAction(action);
    },

    selezionaReason: function (cmp, event, helper) {
        var psvreasonSelezionata = cmp.find("psvreason").get("v.value");
        // imposto anche il PVForm
        cmp.set("v.PVForm.reasonMdt",
            cmp.get('v.listPsvreason').find(x => {
                return x.uniqueId__c == psvreasonSelezionata;
            })
        );

    },

    //valorizzo la lista MOTIVI
    getListaReasons: function (cmp, event, helper) {
        this.mostraClessidra(cmp, helper);
        var pvsubtypeSelezionata = cmp.find("pvsubtype").get("v.value");
        
        // imposto anche il PVForm
        cmp.set("v.PVForm.sottotipologiaMdt",
            cmp.get('v.listPvsubtype').find(x => {
                return x.uniqueId__c == pvsubtypeSelezionata;
            })
        );

        // carico i SUBTYPE
        var action = cmp.get("c.loadListaReasons");
        action.setParams({
            "sottotipologiaSelezionata": cmp.get("v.PVForm.categoriaPV.External_Id__c"),
            "pvsubtypeSelezionata": pvsubtypeSelezionata,
            //"branchOrOffice": cmp.get("v.branchOrOffice")
            "branchOrOffice": cmp.get("v.PVForm.userData.user.Branch_Or_Office__c")
        });

        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                cmp.set("v.listPsvreason", response.getReturnValue());
                // controllo se ho una lista
                if (response.getReturnValue().length == 0) {
                    // non obbligatorio senza ho una lista
                    cmp.set("v.psvreasonRequired", false);
                } else {
                    // rendo obbligatorio se ho una lista
                    cmp.set("v.psvreasonRequired", true);
                }

            }
            this.nascondiClessidra(cmp, helper);
        });
        $A.enqueueAction(action);

    },

    getListaSottotipologie: function (cmp, event, helper) {
        this.mostraClessidra(cmp, helper);

        // carico i subtypes

        var action = cmp.get("c.loadListaSubtypes");
        action.setParams({
            "sottotipologiaSelezionata": cmp.get("v.PVForm.categoriaPV.External_Id__c"),
            //"branchOrOffice": cmp.get("v.branchOrOffice")
            "branchOrOffice": cmp.get("v.PVForm.userData.user.Branch_Or_Office__c")
        });

        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                cmp.set("v.listPvsubtype", response.getReturnValue());

                // controllo se ho una lista
                if (response.getReturnValue().length == 0) {
                    // non obbligatorio senza ho una lista
                    cmp.set("v.pvsubtypeRequired", false);
                    this.getListaReasons(cmp, event, helper);
                } else {
                    // rendo obbligatorio se ho una lista
                    cmp.set("v.pvsubtypeRequired", true);
                    // svuoto per attendere la selezione della subtype
                    cmp.set("v.psvreasonSelezionata", "");
                    cmp.set("v.listPsvreason", []);
                }

                this.nascondiClessidra(cmp, helper);
            } else {
                this.nascondiClessidra(cmp, helper);
            }
        });
        $A.enqueueAction(action);

    },

    inizializzaDatiCategoria: function (cmp, event, helper) {
        this.mostraClessidra(cmp, helper);
        var postvendita = cmp.find("sottotipologia").get("v.value");
        // imposto il form iniziale
        //    cmp.set("v.PVForm.categoriaPV", {});	//svuoto sottotipologia
        // AV TODO dovrei svuotare alcuni dati ???
        cmp.set("v.listPsvreason", []);
        cmp.set("v.listPvsubtype", []);

        /*********************************************
         * SET UP FILTRI
         */
        // AV imposto il filtro del PV se necessario 
        cmp.set("v.PVRecuperaDatiPVfiltroClassName", "");
        cmp.set("v.PVRecuperaDatiPVfiltroParametriMap", []);
        if (postvendita == "1766") {
            cmp.set("v.PVRecuperaDatiPVfiltroClassName", "PV1766CancellazionePraticaInserimento.RecuperaDatiPVFiltro");
            var filtroParametriMap ={};
            if (cmp.get("v.PVForm.userData.user.Branch_Or_Office__c") == 'FIL') {
                filtroParametriMap = { "filiale": cmp.get("v.PVForm.userData.codiceFiliale") };
            }else{
                filtroParametriMap = { "ufficio": "altro" };
            }
            cmp.set("v.PVRecuperaDatiPVfiltroParametriMap", filtroParametriMap); 
            console.log("PVRecuperaDatiPVfiltroClassName: " + cmp.get("v.PVRecuperaDatiPVfiltroClassName"));
            console.log("PVRecuperaDatiPVfiltroParametriMap: " + cmp.get("v.PVRecuperaDatiPVfiltroParametriMap"));
        }

        if (postvendita == "2873") {
            cmp.set("v.PVRecuperaDatiPVfiltroClassName", "PV2873RetrodatazioneEstAntCtrl.RecuperaDatiPVFiltro");
            var filtroParametriMap ={};
            
            //segno a true il filtro per segnalare alla classe apex che il filtro deve essere attivo
            filtroParametriMap = { "stato_90_91": "true" };
            
            cmp.set("v.PVRecuperaDatiPVfiltroParametriMap", filtroParametriMap); 
            console.log("PVRecuperaDatiPVfiltroClassName: " + cmp.get("v.PVRecuperaDatiPVfiltroClassName"));
            console.log("PVRecuperaDatiPVfiltroParametriMap: " + cmp.get("v.PVRecuperaDatiPVfiltroParametriMap"));
        }
        /*
        ***********************************************/



        var action = cmp.get("c.getCommonComponents");
        action.setParams({ "postVenditaId": postvendita });

        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var postvenditaCategoria = response.getReturnValue();
                cmp.set("v.PVForm.categoriaPV", postvenditaCategoria);
                //  AV se è un ticketing devo fare altro... ATTESA Matalone
                if ($A.util.isUndefinedOrNull(postvenditaCategoria.XCS_Template__r)) {
                    // ticketing
                    // this.fireToast("PV", "Categoria Ticketing. Attesa dettagli per implementazione", "info", 60000);
                    var evt = $A.get("e.force:navigateToComponent");
                    evt.setParams({
                        componentDef: "c:TicketingCreazione",
                        componentAttributes: {
                            'CatId': postvenditaCategoria.External_Id__c
                        }
                    });
                    evt.fire();
                } else {
                    this.getListaSottotipologie(cmp, event, helper);
                    // creo il PV child
                    // AV TODO il nome del componenete dovrei prenderlo dalla categoria
                    console.log("Here2!");
                    this.creaComponenetePV(cmp, helper, postvenditaCategoria.External_Id__c);

                }

            }
            this.nascondiClessidra(cmp, helper);

        });
        $A.enqueueAction(action);

        //lo sposto nel success : si accavallano i contatori dello spinner 
        //this.loadSubtypesHelper(cmp,event,helper);
    },



    //funzioni comuni del PV *****************************************************************************

    fireToast: function (header, message, type, duration) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            title: header,
            message: message,
            duration: duration,
            type: type,
            mode: 'dismissible'
        });
        toastEvent.fire();
    },

    mostraToast: function (cmp, event) {
        var params = event.getParam('arguments');

        var header = params.header == "" ? "" : params.header;
        var message = params.message;
        var duration = params.duration == "" ? "10000" : params.duration;
        var type = params.type == "" ? "info" : params.type;

        this.fireToast(header, message, type, duration);

    },

    gestisciRispostaInserimento: function (cmp, event) {
        var params = event.getParam('arguments');
        if (params) {
            var response = params.response;
            var header = params.header;
            var message = params.message;
            var type, duration;

            if (response.getState() == 'SUCCESS') {

                //alert di altri messaggi specifici del PV
                if(response.getReturnValue() != null){
                    if(response.getReturnValue().messages.length>0){
                    
                        //for(var i=response.getReturnValue().messages.length-1; i>=0; i--){
                        for(var i=0; i<response.getReturnValue().messages.length; i++){
                            
                            type = response.getReturnValue().messages[i][0];
                            header = "Postvendita";
                            message = response.getReturnValue().messages[i][1]; //messaggi da visualizzare
                            duration = parseInt(response.getReturnValue().messages[i][2]);
                            
                            this.fireToast(header, message, type, duration);
                        }
                    }
                }   

                type = "success";
                header = "Postvendita";
                message = "Richiesta inserita correttamente.";
                duration = 10000;
                cmp.set("v.isDaLavorare", "false");
                
            } else {
                type = "error";
                message = "Errore generico. " + message;
                header = "Postvendita";
                var duration = 10000;
                var errors = response.getError();
                if (errors) {
                    if (errors[0] && errors[0].message) {
                        console.error("Error message: " + errors[0].message);
                        message = message + errors[0].message;
                    }
                }
            }
            this.fireToast(header, message, type, duration);

            // gestione uscita
            if (response.getState() == 'SUCCESS') {
                // gestione uscita al termine dell'operatività
                var exitMethod = cmp.get("v.exitMethod");

                if (exitMethod == "refresh") {
                    $A.get('e.force:refreshView').fire();
                } else if (exitMethod == "") {
                    // nulla
                } else {
                    // qualsiasi altro valore signifiva vai a quella pagina
                    var urlEvent = $A.get("e.force:navigateToURL");
                    urlEvent.setParams({
                        'url': exitMethod
                    });
                    urlEvent.fire();
                }
            }

        }
    },
    mostraClessidra: function (cmp) {
        var spinner = cmp.find('spinnerComponent');
        spinner.incrementCounter();
    },

    nascondiClessidra: function (cmp) {
        var spinner = cmp.find('spinnerComponent');
        spinner.decreaseCounter();
    },

    showCartaDatiFinanziari: function (cmp, event) {
        var params = event.getParam('arguments');
        if (params) {
            cmp.set("v.showCartaDatiFinanziari", params.valore);
        }
    },

    callChild_onParentChange: function (cmp, whatIsChanged) {
        var childComponent = cmp.find('child');
        if (!$A.util.isUndefinedOrNull(childComponent)) {
            childComponent.onParentChange(whatIsChanged);
        }
        /* VALORI 
        if (params.whatIsChanged == 'psvSubtype') {
        } else if (params.whatIsChanged == 'psvReason') {
        } else if (params.whatIsChanged == 'ocsCliente') {
        } else if (params.whatIsChanged == 'ocsPratica') {        
            */
    },

    /**/
    creaComponenetePV: function (cmp, helper, catId) {
        this.mostraClessidra(cmp);


        // AV TODO lo mettiamo comecampo aggiuntivo nella categoria??
        var myArray = {
            '1760': 'PV1760CopiaContratto',
            '1761': 'PV1761CopiaEstrattoConto',
            '1752': 'PV1752RiattribImportiSistemaPartitario',
            '1763': 'PV1763VariazioneAnagrafica',
            '1768': 'PV1768RipristinoRID',
            '1757': 'PV1757RimborsoClienteSaldoRosso',
            '1762': 'PV1762CancellazioneDaOffertePromozionali',
            '1751': 'PV1751GirocontoIncasso',
            '2564': 'PV2564AzzeramentoSpese',
            '2870': 'PV2870RiemissionePIN',
            '2871': 'PV2871DuplicatoCarta',
            '3260': 'PV3260AumentoFido',
            '3256': 'PV3256ErogazioneDiretta',
            '3388': 'PV3388VariazioneEmail',
            '3481': 'PV3481AttivazioneCarta',
            '3261': 'PV3261VariazioneTelefoni',
            '5864': 'PV5864RESRecessoServizi',
            '1766': 'PV1766CancellazionePratica',
            '3257': 'PV3257VariazioneModInvioEC',
            '3264': 'PV3264VariazioneRataMinima',
            '3255': 'PV3255InserimentoAnnulloBlocco',
            '1772': 'PV1772DaCustomerServAFiliale',
            '1769': 'PV1769DenunciaCarta',
            '1754': 'PV1754StornoAddebito',
            '3267': 'PV3267VariazioneIndirizzi',
            '3707': 'PV3707EstinzioneAnticipata',
            '2877': 'PV2877SegnalazioneCS',
            '3266': 'PV3266ConversioneSaldoRevolving',
            '2790': 'PV2790EstinzioneChiusuraconto',
            '2794': 'PV2794EstinzioneChiusuraconto',
            '3700': 'PV3700RispedizioneBollettiniPostali',
            '3262': 'PV3262TrasfSaldoCampagna',
            '3263': 'PV3263GestioneAlert',
            '3706': 'PV3706VariazioneScadenzaRata',
            '1764': 'PV1764AnalisiFusioneAnagrafiche',
            '2875': 'PV2875RichiestaDocumentazioneAssicurativa',
            '1756': 'PV1756ContabilitaAltreRichieste',
            '3488': 'PV3488AnnulloRipristinoCampagna',
            '6203': 'PV6203RichiestaDettagliAssicurativi',
            '3824': 'PV3824CpayCredenziali',
            '1771': 'PV1771CancAggBancheDati',
            '2382': 'PV2382RintraccioVagliaPostali',
            '2380': 'PV2380RintraccioBollettiniPosteItaliane',
            '5865': 'PV5865CancellazioneAnagrafica',
            '5866': 'PV5866RichiestaConteggiEA',
            '1770': 'PV1770StornoPraticaNonStandard',
            '5603': 'PV5603ReinvioFlussoSDD',
            '2792': 'PV2792GestioneSospesiCpay',
            '2784': 'PV2784OperazioniNonABuonFine',
            '2873': 'PV2873RetrodatazioneEstinzioneAnticipata',
            '1753': 'PV1753AttribuzioneIncasso',
            '3708': 'PV3708EstinzioneParziale',
            '2133': 'PV2133InadempimentoVerbaleFornitore',
            '3259': 'PV3259VariazioneProdottoIns',
            '2791': 'PV2791StornoConRecesso',
            '2874': 'PV2874AvanzSinistroAssicur',
            '2786': 'PV2786CpayStorni',
            '3758': 'PV3758VerificaStatoRimbPremioComp',
            '3265': 'PV3265ModificaModPagamento',
            '1759': 'PV1759SbloccoCartaVIZD'

        };

        var name = myArray[catId];
        console.log('***name: ' + name);

        if (name != '') {
            $A.createComponent(
                'c:' + name,
                {
                    "aura:id": "child",
                    "PVForm": cmp.getReference("v.PVForm"),
                    "parametriEsterni": cmp.getReference("v.parametriEsterni"),
                    "cartaDatiFinanziariData": cmp.getReference("v.cartaDatiFinanziariData"),
                    "showMarkup": cmp.getReference("v.showMarkup"),
                },
                function (element, status, errorMessage) {
                    if (cmp.isValid() && status == 'SUCCESS') {
                        var body = cmp.get('v.body');
                        body.push(element);
                        cmp.set('v.body', element);
                    }
                    helper.nascondiClessidra(cmp);
                }
            );
        } else {
            console.log("Here we are!");
            this.fireToast("Postvendita", "PV " + catId + " non implementato.", "info", 5000);
            this.nascondiClessidra(cmp);

        }
    },
    setIconAndNameTab: function(cmp,event,helper){
        var workspaceAPI = cmp.find("workspace");
        workspaceAPI.isConsoleNavigation().then(function(response) {
            workspaceAPI.getFocusedTabInfo().then(function(response) {
                var focusedTabId = response.tabId;
                //Cambio Label
                workspaceAPI.setTabLabel({
                    tabId: focusedTabId,
                    label: "Nuovo PV"
                });
                //Cambio icona
                workspaceAPI.setTabIcon({
                    tabId: focusedTabId,
                    icon: "action:new_case",
                    iconAlt: "Nuovo PV"
                });
                
  
            })
            .catch(function(error) {
                console.log(error);
            });
            
        })
        .catch(function(error) {
            console.log(error);
        });
    }
})