/**
 * @File Name          : PV2784OperazioniNonABuonFineInserimento.cls
 * @Description        : 
 * @Author             : Federica Forte
 * @Group              : 
 * @Last Modified By   : Federica Forte
 * @Last Modified On   : 24/1/2020, 15:04:32
 * @Modification Log   : 
 * Ver       Date            Author      		    Modification
 * 1.0    21/1/2020   Federica Forte     Initial Version
**/
public with sharing class PV2784OperazioniNonABuonFineInserimento extends PVAction {
    
    public class PV2784OperazioniNonABuonFineInserimentoForm extends PVForm {
        @AuraEnabled public Date data { get; set; }
        @AuraEnabled public String importo { get; set; }
    }

    @AuraEnabled
	public static void conferma(PV2784OperazioniNonABuonFineInserimentoForm datiForm) {
		new PV2784OperazioniNonABuonFineInserimento().execute(datiForm);
	}

    public void execute(PVForm form) {
		PV2784OperazioniNonABuonFineInserimentoForm myForm = (PV2784OperazioniNonABuonFineInserimentoForm) form;
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
		PV2784OperazioniNonABuonFineInserimentoForm myForm = (PV2784OperazioniNonABuonFineInserimentoForm) form;

		String notaSpecificaPV = ' ';
		notaSpecificaPV = 'Pratica: ' + myForm.pratica.tipoPratica + ' - ' + myForm.pratica.numPratica + '<br>';
        if (myForm.data != null) {
            notaSpecificaPV += 'Data: ' + myForm.data.format() + '<br>';
        }
        if (myForm.importo != '') {
            notaSpecificaPV += 'Importo: ' + myForm.importo + '<br>';
        }
        return notaSpecificaPV;

	}

	public override XCS_Messaggio__c preparaMessaggioOCS(PVForm form, XCS_Messaggio__c xcs_messaggio) {
		PV2784OperazioniNonABuonFineInserimentoForm myForm = (PV2784OperazioniNonABuonFineInserimentoForm) form;
		xcs_messaggio.CodCliente__c = myForm.pratica.codCliente;
		return xcs_messaggio;
	}
}