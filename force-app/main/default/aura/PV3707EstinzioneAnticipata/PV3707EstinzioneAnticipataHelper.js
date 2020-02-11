/**
 * @File Name          : PV3707EstinzioneAnticipataHelper.js
 * @Description        : 
 * @Author             : Federico Negro
 * @Group              : 
 * @Last Modified By   : Federico Negro
 * @Last Modified On   : 3/12/2019, 10:50:05
 * @Modification Log   : 
 * Ver       Date            Author      		    Modification
 * 1.0    14/11/2019   Federico Negro     Initial Version
**/
({

    onPraticaSelected: function (cmp, event, helper) {

        this.mostraErrori(cmp, "");
        cmp.set("v.OK",false);
        cmp.set("v.codOCS","");

    },

    verificaEVO : function(cmp, event, helper) {

		var action = cmp.get('c.getPSVService');
        action.setParams({
            'numPratica' : cmp.get('v.PVForm.pratica.numPratica'),
            'tipoPratica' : cmp.get('v.PVForm.pratica.tipoPratica'),
            'codAzione' : "EST"
        });
        action.setCallback(this, function(response){
            if(response.getState() == 'SUCCESS'){
                var result = response.getReturnValue();
                console.log(JSON.stringify(response));
                
                var i;
                var ok=false;
                var dataAzioni = new Array();
                var dataComunicazioni = new Array();
                
                if(result != null){
                    cmp.set("v.res", result[0]);
                    for(i=0;i<result.length;i++){
                        console.log(result[i]);

                        if(result[i].stato == "30" && result[i].blocco == "AC" && ok==false){
                            ok=true;
                            cmp.set("v.OK",true);
                        }

                        dataAzioni.push({
                            Azione: result[i].codAzione,
                            Stato: result[i].stato,
                            Blocco: result[i].blocco
                        });

                    }
                }else{
                    this.mostraToast(cmp, '', "Nessuna azione OCS rilevata", 'error', '');
                }

                dataComunicazioni.push({
                    Tipologia: "Lettera",
                    Codice: "CC12"
                });
                dataComunicazioni.push({
                    Tipologia: "Email",
                    Codice: "MC12"
                });

                if(ok==true){
                    cmp.set("v.dataAzioni",dataAzioni);
                    cmp.set("v.dataComunicazioni",dataComunicazioni);
                }

            }
        });
        $A.enqueueAction(action);
    },
    
    handleRowAction: function (cmp, event, helper) {   
        var row = event.getParam('selectedRows')[0];
        cmp.set("v.codOCS",row.Codice);
        
    },

    /************************/
    /* Gestione Inserimento */
    /************************/

    validateUserInput: function (cmp, event, helper) {
        var messaggi = "";
        messaggi = this.checkPraticaSelezionata(cmp);
        if (messaggi == "") {
            if(cmp.get("v.PVForm.pratica.tipoPratica") == "CA"){
                messaggi+="Selezionare una pratica di tipo CO.\n";
            }else{
                if(cmp.get("v.OK")!=true){
                    messaggi+="Non è stata rilevata un'azione approvata in OCS.\n";
                }
            }
        }

        return messaggi;
    },

    completaPVForm: function (cmp, event, helper, PVForm) {
        //arricchisco il PVForm con dati specifici del PV
        
        PVForm.progressivo = cmp.get('v.res').progressivo;
        PVForm.stato = cmp.get('v.res').stato;
        PVForm.blocco = cmp.get("v.res").blocco;
        
        return PVForm;
    },
})