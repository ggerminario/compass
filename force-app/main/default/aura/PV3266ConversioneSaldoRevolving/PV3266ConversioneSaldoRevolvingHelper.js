({
	doInit: function(cmp,event,helper){
		var action = cmp.get("c.getModalitaCalcoloRata");
		// Imposto la Callback
		action.setCallback(this, function (response, helper) {
			console.log("recuperaDatiFinanziari : result : " + JSON.stringify(response.getReturnValue()));
			if (response.getState() == 'SUCCESS') {
				var result = response.getReturnValue();
				console.log('DoInit Result:'+JSON.stringify(result));
				var modCalcoloRataOptions = [];
				for (var key in result){
					var singleModCalcoloRata = {label:key, value:result[key]};
					modCalcoloRataOptions.push(singleModCalcoloRata);
				}
				cmp.set("v.modCalcoloRataOptions",modCalcoloRataOptions);
				/*
				var modCalcoloRataOptions = [];
				for(var i = 0; i<result.length ; i++){
					var singleModCalcoloRata = {label:result[i].Label__c, value:result[i].Value__c};
					console.log('singleModCalcoloRata: '+JSON.stringify(singleModCalcoloRata));
					modCalcoloRataOptions.add(singleModCalcoloRata);
				}
				cmp.set("v.modCalcoloRataOptions",modCalcoloRataOptions);
				*/
			}else if (response2.getState() === "ERROR") {
				this.mostraToast(cmp, '', response2.getError(), 'error', '');
			}

		});
		$A.enqueueAction(action);
	},
    onPraticaSelected: function (cmp, event, helper) {
		console.log('Ho Selezionato la pratica su Conversione Saldo Revolving');
		console.log('PVform:'+JSON.stringify(cmp.get("v.PVForm")));
        this.clearFields(cmp);
		this.showMarkup(cmp,true);
        this.recuperaDatiCarta(cmp,helper);
    },
    clearFields: function (cmp) {
		this.mostraErrori(cmp, "");
		cmp.set("v.cartaDatiFinanziariData", null);
    },

    recuperaDatiCarta: function(cmp,helperComponent){
        		//verifica se la carta è attiva
        var messaggi = this.checkPraticaSelezionata(cmp);
		var isMultifunzione = false;
		//var isMultifunzione = true; // for Testing
		if (messaggi == "") {
			var pratica = cmp.get("v.PVForm.pratica");
			if (pratica.statoPratica == '50' ){
				//recupero lo stato rinnovo
				this.mostraClessidra(cmp);
				var action = cmp.get('c.recuperaDatiFinanziari');
				action.setParams({
					"numeroCarta": pratica.numPratica
				});
				// Imposto la Callback
				action.setCallback(this, function (response, helper) {
					console.log("recuperaDatiFinanziari : result : " + JSON.stringify(response.getReturnValue()));
					if (response.getState() == 'SUCCESS') {
						var result = response.getReturnValue();
						cmp.set("v.cartaDatiFinanziariData",response.getReturnValue());
						cmp.set("v.selectedValue",cmp.get("v.cartaDatiFinanziariData.modCalcoloRataCustom"));
        				cmp.set('v.minimoPercOrig',cmp.get('v.cartaDatiFinanziariData.pagamentoMinimoPerc'));
						cmp.set('v.minimoOrig',cmp.get('v.cartaDatiFinanziariData.pagamentoMinimo'));
						cmp.set('v.modCalcRataOriginal',cmp.get('v.cartaDatiFinanziariData.modCalcoloRata'));
						cmp.set("v.PVForm.modCalcRata",cmp.get("v.cartaDatiFinanziariData.modCalcoloRata'"));
						cmp.set("v.PVForm.pagMinImporto",cmp.get("v.cartaDatiFinanziariData.pagamentoMinimo"));
						cmp.set("v.PVForm.pagMinPerc",cmp.get("v.cartaDatiFinanziariData.pagamentoMinimoPerc"));
						console.log('modCalcRataOriginal' + cmp.get('v.modCalcRataOriginal'));
						helperComponent.showCartaDatiFinanziari(cmp,'true');
						if((result.statoRinnovoCustom.toUpperCase() == ('RINNOVO ATTIVO').toUpperCase() ||
							result.statoRinnovoCustom.toUpperCase() == ('-').toUpperCase())) {
							/********************************************/
							//recupero info carta
							var action2 = cmp.get('c.recuperaInfoCarta');
							action2.setParams({
								"numeroCarta": pratica.numPratica
							});
							// Imposto la Callback
							action2.setCallback(this, function (response2, helper) {
								console.log("recuperaInfoCarta : result : " + JSON.stringify(response2.getReturnValue()) + " - " + response2.getState());
								console.log("multifunzioneF: " + response2.getReturnValue().multifunzioneF + "multifunzioneR: " + response2.getReturnValue().multifunzioneR + "multifunzioneS: " + response2.getReturnValue().multifunzioneS + "multifunzioneT: " + response2.getReturnValue().multifunzioneT );
								if (response2.getState() == 'SUCCESS') {
                                    if((response2.getReturnValue().multifunzioneF != undefined && response2.getReturnValue().multifunzioneF.toUpperCase() == 'S') || (response2.getReturnValue().multifunzioneR != undefined && response2.getReturnValue().multifunzioneR.toUpperCase() == 'S') || 
                                    (response2.getReturnValue().multifunzioneS != undefined && response2.getReturnValue().multifunzioneS.toUpperCase() == 'S') || (response2.getReturnValue().multifunzioneT != undefined && response2.getReturnValue().multifunzioneT.toUpperCase() == 'S')){
                                        isMultifunzione = true;
                                    }
                                    cmp.set("v.infoCartaData",response2.getReturnValue());
                                    console.log('Multifunzione:'+isMultifunzione);
                                    if(!isMultifunzione){
                                        messaggi += "La carta non è multifunzione. Eseguire prima la modifica del prodotto.";
                                        this.mostraErrori(cmp, messaggi);
                                        this.showMarkup(cmp,false);
									}
									this.nascondiClessidra(cmp);
								}else if (response2.getState() === "ERROR") {
									this.mostraToast(cmp, '', response2.getError(), 'error', '');
									this.nascondiClessidra(cmp);
								}
							});
							$A.enqueueAction(action2);			
                        }
                        else{
                            messaggi += "La carta non è attiva."; // Possibile Custom Label
                            this.mostraErrori(cmp, messaggi);
							this.showMarkup(cmp,false);
							this.nascondiClessidra(cmp);
                        }
                        
					}else if (response.getState() === "ERROR") {
						this.nascondiClessidra(cmp);
						this.mostraToast(cmp, '', response.getError(), 'error', '');
					}
				});
				
				$A.enqueueAction(action);			

            }else {
                messaggi += "La carta non è attiva.";
            }
            console.log('messaggi'+messaggi);
			if(messaggi != ""){
				this.mostraErrori(cmp, messaggi);
				this.showMarkup(cmp,false);
			}
        }
        			

	},
	validateUserInput: function(cmp, event, helper) {
		//debugger;
		var messaggi = "";
		

		var modCalcRata = cmp.get("v.selectedValue");
		var pagMinImporto = cmp.get("v.cartaDatiFinanziariData.pagamentoMinimo");
		var pagMinPerc = cmp.get("v.cartaDatiFinanziariData.pagamentoMinimoPerc");

		console.log('Originali: ' + cmp.get('v.modCalcRataOriginal') + cmp.get('v.minimoPercOrig') + cmp.get('v.minimoOrig'));
		console.log('Nuovi: ' + modCalcRata + pagMinImporto + pagMinPerc);

		messaggi = this.checkClienteSelezionato(cmp);
		if(modCalcRata == cmp.get("v.modCalcRataOriginal") && pagMinImporto == cmp.get("v.minimoOrig") && pagMinPerc == cmp.get("v.minimoPercOrig")){
			messaggi += 'Nessuna variazione effettuata\n';
		}
		else{
			if(pagMinImporto === ""){
				messaggi += 'Valorizzare il campo rata minima\n'
			}
			else if(pagMinImporto < 0){
				messaggi += 'Valore non ammesso per il campo rata minima\n'
			}

			if(pagMinPerc === ""){
				messaggi += 'Valorizzare il campo percentuale\n'
			}else if(pagMinPerc < 0){
				messaggi += 'Valore non ammesso per il campo percentuale\n'
			}

			if(messaggi == ""){
				messaggi = this.checkPraticaSelezionata(cmp);
			}    
		}
		return messaggi;
	},

    completaPVForm: function(cmp, event, helper, PVForm) {
		console.log('Completo PVForm con modCalcRataOrig:'+cmp.get("v.modCalcRataOriginal"));
		PVForm.modCalcRata = cmp.get("v.selectedValue");
		PVForm.pagMinImporto = cmp.get("v.cartaDatiFinanziariData.pagamentoMinimo");
		PVForm.pagMinPerc = cmp.get("v.cartaDatiFinanziariData.pagamentoMinimoPerc");
		PVForm.modCalcRataOrig = cmp.get("v.modCalcRataOriginal");
        return PVForm;
    }
})