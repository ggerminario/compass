/**
 * @File Name          : PV1771CancAggBancheDati.cls
 * @Description        : 
 * @Author             : Nicola Musicco
 * @Group              : 
 * @Last Modified By   : Nicola Musicco
 * @Last Modified On   : 21/1/2020, 11:23:49
 * @Modification Log   : 
 * Ver       Date            Author      		    Modification
 * 1.0    7/1/2020   Nicola Musicco     Initial Version
**/
public class PV1771CancAggBancheDati extends PVAction{
    

    public class PV1771CancAggBancheDatiForm extends PVForm{
        
        @AuraEnabled public String dataEstinzione {get;set;}
    }

    @AuraEnabled
	public static void conferma(PV1771CancAggBancheDatiForm datiForm) {
		new PV1771CancAggBancheDati().execute(datiForm);
	}


	public void execute(PV1771CancAggBancheDatiForm form) {
		String messaggio_errore = '';
		try{

			
			commonExecute(form);
			
		}catch(Exception e) {
			if(messaggio_errore == '') {
				messaggio_errore = loggaException(e);
			}
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
		PV1771CancAggBancheDatiForm nForm=(PV1771CancAggBancheDatiForm)form;
		String notaSpecificaPV='';

		 notaSpecificaPV = 'Filiale di: ' +  nForm.userData.accountOffice.Name+'-'+nForm.userData.user.LastName+'<br>';
		 notaSpecificaPV += 'Numero pratica: ' + nForm.pratica.tipoPratica+'-'+nForm.pratica.numPratica + '<br>';
		 
		 if(!String.isEmpty(nForm.dataEstinzione))
            notaSpecificaPV += 'Data estinzione posizione: ' + nForm.dataEstinzione + '<br>';
		return notaSpecificaPV;

	}

	public override XCS_Messaggio__c preparaMessaggioOCS(PVForm form, XCS_Messaggio__c xcs_messaggio) {
		return xcs_messaggio;
	}
}