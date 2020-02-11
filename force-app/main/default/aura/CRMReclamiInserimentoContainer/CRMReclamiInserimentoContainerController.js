//----------------------------------------------------------------------
//-- - Controller JS Name : CRMReclamiInserimentoContainerController.js
//-- - Autor              : 
//-- - Date               : 22/05/2019
//-- - Description        : 
//-- - Version            : 1.0
//----------------------------------------------------------------------
({
    init:function(cmp,event,helper){
        cmp.set('v.stepInserimentoCliente',1);       
    },
    
    settaClientePratica:function(cmp,event,helper){
        
    },
    
    changeComunicazionePresaInCarico:function(cmp,event,helper) {
        var cliente = cmp.get("v.clienteSelezionatoContainer");
        
 
        var presaInCarico = cmp.find('coda_dettaglio').get("v.presaInCarico");
      
            if(presaInCarico=='EMAIL_CLIENTE_APERTURA' || presaInCarico=='EMAIL_TERZO_APERTURA' ){
                if(cliente == undefined || cliente == null || cliente.email == undefined || cliente.email.length == 0) {
                    helper.showToast(cmp, 'Errore','error', 'Attenzione: non è presente un indirizzo email a cui inviare la comunicazione di presa in carico');
                	return;
                }
                else{
                   
                    cmp.find('coda_dettaglio').set('v.comunicazioneEmail',  cliente.email);
                }
            }
        if(presaInCarico=='SMS_TERZO_APERTURA' || presaInCarico=='SMS_CLIENTE_APERTURA' ){
            if(cliente == undefined || cliente == null || cliente.telCellulare == undefined || cliente.telCellulare.length == 0) {
                helper.showToast(cmp, 'Errore','error', 'Attenzione: non è presente un numero di cellulare a cui inviare la comunicazione di presa in carico');
            }
            else{
                cmp.find('coda_dettaglio').set('v.numSMS',  cliente.telCellulare);
            }
        } 
        
    },
    
    reset : function(cmp, event){
        var button = event.getSource();
        var choose = button.get("v.value");
        console.log(choose);
       	if(choose == 'modal') cmp.set("v.showMessage", true);
        else if(choose == 'Si'){
            cmp.set("v.showMessage", false);
            $A.get('e.force:refreshView').fire();
            cmp.set("v.aziendaSelezionata",'');
    

            //-----------------------
            console.log('--------RESET-------');
            cmp.set('v.listaClienti',null);
            cmp.set('v.clienteSelezionato',null);
            cmp.set('v.stepInserimentoCliente',1);
            cmp.set('v.listaPratiche',null);
            cmp.set('v.praticaSelezionata',null);
            cmp.set('v.praticaSelezionataContainer',null);
            cmp.get('v.listaInfoPratiche',null);
            cmp.set('v.infoPraticaSelezionata',null);
            cmp.set('v.clienteSelezionatoContainer',null);
            cmp.set('v.reclamoSelezionato',null);
            cmp.set('v.categoriaDettagli',null);
            cmp.set('v.reclamoIdAfterSave',null);
            cmp.set('v.filiale',null);
            //-----------------------

        }
        else cmp.set("v.showMessage", false);
    },
    
    salvaReclamo:function(cmp,event,helper){        
        //CR
        var presaInCarico = cmp.find('coda_dettaglio').get("v.presaInCarico");
        var cEmail = cmp.find('coda_dettaglio').get("v.comunicazioneEmail");
        var cSMS = cmp.find('coda_dettaglio').get("v.numSMS");
   
        if(presaInCarico==null || presaInCarico.length == 0){
        	helper.showToast(cmp, 'Errore','error', 'Errore nel campo Presa In Carico');
            return;
        }else{
            if(presaInCarico=='EMAIL_CLIENTE_APERTURA' || presaInCarico=='EMAIL_TERZO_APERTURA' ){
                if(cEmail==null || cEmail.length == 0){
                    helper.showToast(cmp, 'Errore','error', 'Indirizzo Comunicazione obbligatorio');
                    return;
                }
                else if(!helper.isEmailValida(cEmail)){
                        helper.showToast(cmp, 'Errore','error', 'comunicazione di presa in carico:  EMAIL NON VALIDA');
                        return;
                    }
            }
            if(presaInCarico=='SMS_CLIENTE_APERTURA' || presaInCarico=='SMS_TERZO_APERTURA' ){
                if(cSMS==null || cSMS.length == 0){
                    helper.showToast(cmp, 'Errore','error', 'Numero Comunicazione obbligatorio');
                    return;
                }
                else if(!helper.isNumeroTelefonoValido(cmp, cSMS+'')){
                    helper.showToast(cmp, 'Errore','error', 'comunicazione di presa in carico:  NUMERO COMUNICAZIONE NON VALIDO');
                    return;
                }
            }
        }
        //CR Fine
        var categoria = cmp.get("v.categoriaDettagli");
        if(categoria == null || categoria == undefined || categoria.length <=0){
            helper.showToast(cmp, 'Errore', 'error','Categoria non valorizzata');
            return;
        }
        
        var isAllOk=helper.checkAll(cmp,helper);
  
        if(!isAllOk){
            var msg = cmp.get('v.errorMessage')
            helper.showToast(cmp, 'Errore','Error', msg);

          
        }else{
           
            helper.salvaReclamoHelper(cmp,helper);
            
            if(helper.isCategoriaFrode(cmp)){
                //helper.sendFandTFrode(cmp);
                console.log('------------------------------------------------------------------------------');
                console.log('Controller JS: CRMReclamiInserimentoContainerController - Method: salvaReclamo'); 
                console.log('if(helper.isCategoriaFrode(cmp))  - Value: ' + helper.isCategoriaFrode(cmp)); 
                console.log('TEXT: la categoria è una frode'); 
            }else{
                console.log('------------------------------------------------------------------------------');
                console.log('Controller JS: CRMReclamiInserimentoContainerController - Method: salvaReclamo'); 
                console.log('if(helper.isCategoriaFrode(cmp))  - Value: ' + helper.isCategoriaFrode(cmp)); 
                console.log('TEXT: la categoria non è una frode'); 
            }
            if(helper.isInadempimento(cmp)){
               // helper.sendFandTChatterInadempimento(cmp);
                console.log('------------------------------------------------------------------------------');
                console.log('Controller JS: CRMReclamiInserimentoContainerController - Method: salvaReclamo'); 
                console.log('if(helper.isInadempimento(cmp))  - Value: ' + helper.isInadempimento(cmp)); 
                console.log('TEXT: la categoria è un inadempimento'); 
            }else{
                console.log('------------------------------------------------------------------------------');
                console.log('Controller JS: CRMReclamiInserimentoContainerController - Method: salvaReclamo'); 
                console.log('if(helper.isInadempimento(cmp))  - Value: ' + helper.isInadempimento(cmp)); 
                console.log('TEXT: la categoria non è un inadempimento'); 
            }
        }
        
      
    },
    
    getOrgPath:function(cmp,event,helper){
        console.log('------------------------------------------------------------------------');
        console.log('Controller JS: CRMReclamiInserimentoContainerHelper - Method: getOrgPath'); 

        var action = cmp.get("c.pathOrg");
//        action.setParam('recordId',cmp.get('v.reclamoIdAfterSave'));
        action.setCallback(this,function(resp){
            if(resp.getState()=='SUCCESS'){
		        cmp.set('v.orgPath',resp.getReturnValue());
            }
        });
        $A.enqueueAction(action);
    },
})