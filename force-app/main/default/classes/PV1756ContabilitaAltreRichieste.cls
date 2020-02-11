/**
 * @File Name          : PV1756ContabilitaAltreRichieste.cls
 * @Description        : 
 * @Author             : Federica Forte
 * @Group              : 
 * @Last Modified By   : Federica Forte
 * @Last Modified On   : 17/12/2019, 16:22:54
 * @Modification Log   : 
 * Ver       Date            Author      		    Modification
 * 1.0    17/12/2019   Federica Forte     Initial Version
**/
public with sharing class PV1756ContabilitaAltreRichieste extends PVAction {
    
    public class PV1756ContabilitaAltreRichiesteForm extends PVForm {
        @AuraEnabled public String importo { get; set; }    
    }

    @AuraEnabled
	public static void conferma(PV1756ContabilitaAltreRichiesteForm datiForm) {
		new PV1756ContabilitaAltreRichieste().execute(datiForm);
	}

	public void execute(PVForm form) {
		PV1756ContabilitaAltreRichiesteForm myForm = (PV1756ContabilitaAltreRichiesteForm) form;
		String messaggio_errore = '';
		try{
            commonExecute(myForm);
		} catch(Exception e) {
            messaggio_errore = loggaException(e);
		}finally {
			if(messaggio_errore != '') {
				gestisciException(messaggio_errore);
			}
		}

	}

    public override Case completaCasePostVendita(Case casoPV, PVForm form) {
	    return casoPV;
	}

	public override String recuperaNotaSpecificaPV(PVForm form, Case casoPV) {
        //preparazione nota
        PV1756ContabilitaAltreRichiesteForm myForm = (PV1756ContabilitaAltreRichiesteForm) form;

        String notaSpecificaPV = ' ';
        notaSpecificaPV = 'Pratica: ' + myForm.pratica.tipoPratica + ' - ' + myForm.pratica.numPratica + '<br>';
        if (myForm.importo != '') {
            notaSpecificaPV += 'Importo: ' + myForm.importo + '<br>';
        }
        return notaSpecificaPV;

    }

    public override XCS_Messaggio__c preparaMessaggioOCS(PVForm form, XCS_Messaggio__c xcs_messaggio) {
        PV1756ContabilitaAltreRichiesteForm myForm = (PV1756ContabilitaAltreRichiesteForm) form;
        xcs_messaggio.CodCliente__c = myForm.pratica.codCliente;
        return xcs_messaggio;
    }
}