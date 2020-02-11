/**
 * @File Name          : PV1759SbloccoCartaVIZD.cls
 * @Description        : 
 * @Author             : Michele Renda
 * @Group              : 
 * @Last Modified By   : ChangeMeIn@UserSettingsUnder.SFDoc
 * @Last Modified On   : 20/12/2019, 11:29:33
 * @Modification Log   : 
 * Ver       Date            Author      		    Modification
 * 1.0    20/12/2019      Michele Renda     Initial Version
**/
public with sharing class PV1759SbloccoCartaVIZD extends PVAction {
    
    
    public class PV1759SbloccoCartaVIZDForm extends PVForm {

    }

    @AuraEnabled
    public static void conferma(PV1759SbloccoCartaVIZDForm datiForm) {
        System.debug('---> [PV1759SbloccoCartaVIZD - conferma] datiForm: ' + datiForm);
        new PV1759SbloccoCartaVIZD().execute(datiForm);
    }

    public void execute(PVForm form) {
        String messaggio_errore = '';

        try {
            PV1759SbloccoCartaVIZDForm myForm = (PV1759SbloccoCartaVIZDForm) form;
            System.debug('---> [PV1759SbloccoCartaVIZD - execute] PVForm: ' + myForm);
            commonExecute(myForm);
        } catch (Exception e) {
            messaggio_errore = e.getMessage();
        } finally {
            if (messaggio_errore != '') {
                gestisciException(messaggio_errore);
            }
        }
    }

    public override Case completaCasePostVendita(Case casoPV, PVForm form) {
        return casoPV;
    }
     public override XCS_Messaggio__c preparaMessaggioOCS(PVForm form, XCS_Messaggio__c xcs_messaggio) {
        PV1759SbloccoCartaVIZDForm myForm = (PV1759SbloccoCartaVIZDForm) form;
        xcs_messaggio.NumPratica__c = myForm.pratica.numPratica;
        xcs_messaggio.TipoPratica__c = myForm.pratica.tipoPratica;
        xcs_messaggio.CodCliente__c = myForm.pratica.codCliente;
        return xcs_messaggio;
    }
    public override String recuperaNotaSpecificaPV(PVForm form, Case casoPV) {

        PV1759SbloccoCartaVIZDForm myform = (PV1759SbloccoCartaVIZDForm) form;
        String notaSpecificaPV = '';
        return notaSpecificaPV;
        
    }
     @AuraEnabled
    public static OCSCartaDatiFinanziariResponse.DatiCartaDatiFinanziariResponseDTO getDatiFinanziariCarta(String numeroCarta) {
        OCSCartaDatiFinanziariResponse response = OCSCartaDatiFinanziariInvoker.cartaDatiFinanziari(numeroCarta);
        return response.datiCartaDatiFinanziariResponse;
    }
}