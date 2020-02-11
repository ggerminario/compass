({
    init:function(cmp,event,helper){
        if(cmp.get('v.campiCase')){
            helper.setFields(cmp);
        }
        cmp.set('v.isOk',helper.checkIfOkHelper(cmp));
        cmp.set('v.output',helper.buildOutputObj(cmp));
    },
    
    checkIfOk:function(cmp,event,helper){
        cmp.set('v.isOk',helper.checkIfOkHelper(cmp));
    },
    
    buildOutput:function(cmp,event,helper){
        cmp.set('v.output',helper.buildOutputObj(cmp));
    }/*,
    isEmpty: function(e) {
        switch (e) {
          case "":
          case 0:
          case "0":
          case null:
          case false:
          case typeof this == "undefined":
            return true;
          default:
            return false;
        }
    }, 
    checkImportiFuturo:function(cmp,event,helper) {
        // correzione forzata Dotti Importi
        if (cmp.get('v.isRimborsoCOk')==true && this.isEmpty(cmp.get('v.commissioniValue'))) {
           return 'Non è stato valorizzato Importo commissioni';
        }
        if (cmp.get('v.isRimborsoPOk')==true && this.isEmpty(cmp.get('v.provvAccValue'))) {
            return 'Non è stato valorizzato Importo Provvigioni';
        }
        if (cmp.get('v.isRimborsoPremiomOk')==true && this.isEmpty(cmp.get('v.premioAssValue'))) {
            return 'Non è stato valorizzato Importo Premio Assicurativo';
        }
        if (cmp.get('v.isRimborsoVOk')==true && this.isEmpty(cmp.get('v.varieValue'))) {
            return 'Non è stato valorizzato Non è stato valorizzato Rimborso Varie';
        }
        if (cmp.get('v.isRimborsoSOk')==true && this.isEmpty(cmp.get('v.speseLegaliValue'))) {
            return 'Non è stato valorizzato Rimborso Spese Legali';
        }
        return null;
    }*/
})