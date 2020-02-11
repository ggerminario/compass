/**
 * @File Name          : PV6203RichiestaDettagliAssicurativiController.js
 * @Description        : 
 * @Author             : Adriana Lattanzi
 * @Group              : 
 * @Last Modified By   : Adriana Lattanzi
 * @Last Modified On   : 23/12/2019, 16:23:32
 * @Modification Log   : 
 * Ver       Date            Author      		    Modification
 * 1.0    23/12/2019   Adriana Lattanzi     Initial Version
**/
({
    callQuestion : function(component, event, helper) {
        component.set("v.selectedpack", event.getParam("selectedRows")[0]["codPacchetto"]);
        component.set("v.questionHistory", null);
        helper.callQuestion(component, event, helper);
    },

    callResponse : function(component, event, helper) {
        component.set("v.selectedquestion", event.getParam("selectedRows")[0]["idDomanda"]);
        helper.callResponse(component, event, helper);
    }
})