/**
 * @File Name          : PV2382RintraccioVagliaPosteItalianeIns.cls
 * @Description        : 
 * @Author             : Cristiano
 * @Group              : 
 * @Last Modified By   : Cristiano
 * @Last Modified On   : 17/1/2020, 12:52:53
 * @Modification Log   : 
 * Ver       Date            Author      		    Modification
 * 1.0    9/1/2020   Cristiano     Initial Version
**/
public with sharing class PV2382RintraccioVagliaPosteItalianeIns extends PVAction{

    public class PV2382RintraccioVagliaPosteItalianeInsForm extends PVForm {

        @AuraEnabled
		public String importo {get;set;}

        @AuraEnabled
        public Date dataValuta{get;set;}
    
        @AuraEnabled
        public String provincia{get;set;}
        
        @AuraEnabled
        public String ufficio{get;set;}      

        @AuraEnabled
        public String codiceVaglia{get;set;} 

        @AuraEnabled
        public String nome{get;set;} 

        @AuraEnabled
        public String indirizzoMitt{get;set;}

        @AuraEnabled
        public String CFPartitaIva{get;set;}

        @AuraEnabled
        public String indirizzoBen{get;set;}

        @AuraEnabled
        public String comunicazMitt{get;set;}
    }

    @AuraEnabled
	public static void conferma(PV2382RintraccioVagliaPosteItalianeInsForm datiForm){
		new PV2382RintraccioVagliaPosteItalianeIns().execute(datiForm);
	}

    public void execute(PVForm form){
		// TO DO EXECUTE con chiamata a VariazioneModalCalcoloRata
        PV2382RintraccioVagliaPosteItalianeInsForm myForm = (PV2382RintraccioVagliaPosteItalianeInsForm) form;
		String errorMessage = '';
		String codiceVaglia = myForm.codiceVaglia;
		String messaggio_errore = '';
		try{
			commonExecute(myForm);
		}catch(Exception e) {
			messaggio_errore = errorMessage;
		}finally{
			if(messaggio_errore != '') {
				gestisciException(messaggio_errore);
			}
		}
	}

    public override Case completaCasePostVendita(Case casoPV,PVForm form){
		return casoPV;	
	}

    public override String recuperaNotaSpecificaPV(PVForm form, Case casoPV){
		//preparazione nota
		PV2382RintraccioVagliaPosteItalianeInsForm myForm = (PV2382RintraccioVagliaPosteItalianeInsForm) form;
		String notaSpecificaPV;
        // date d = Date.valueOf(myForm.dataValuta);
		date d = myForm.dataValuta;
		notaSpecificaPV = 'Numero pratica: ' + myForm.pratica.numPratica + '\n' 
						//+ 'Modalità calcolo rata da: ' +myForm.modCalcRataOrig + ' a ' + myForm.modCalcRata.substring(0,1);
						+ 'Cognome o Rag.Soc/Nome Mittente: ' + myForm.Nome + '\n'
						+ 'Indirizzo Mittente: ' + myForm.indirizzoMitt + '\n'
						+ 'Codice Fiscale o Partita Iva: ' + myForm.CFPartitaIva + '\n'
						+ 'Cognome o Rag.Soc/Nome Beneficiario: COMPASS S.P.A' + '\n'
						+ 'Indirizzo Beneficiario: ' + myForm.indirizzoBen + '\n'
						+ 'Comunicazione dal Mittente: ' + myForm.comunicazMitt + '\n'
						+ 'Importo: ' + myForm.importo + '\n'
						+ 'Provincia: ' + myForm.provincia + '\n'
						+ 'Ufficio: ' + myForm.ufficio + '\n'
						+ 'Codice Vaglia: ' + myForm.codiceVaglia + '\n'
						+ 'Data Valuta: ' + d.day() + '/' + d.month() + '/' + d.year();
        return notaSpecificaPV;
	}

    public override XCS_Messaggio__c preparaMessaggioOCS(PVForm form, XCS_Messaggio__c xcs_messaggio){
		//preparazione XCS_Messaggio
		PV2382RintraccioVagliaPosteItalianeInsForm myForm = (PV2382RintraccioVagliaPosteItalianeInsForm) form;
		//xcs_messaggio.CodCliente__c = myForm.cliente.codCliente;
		xcs_messaggio.NumPratica__c = myForm.pratica.numPratica;
		xcs_messaggio.TipoPratica__c = myForm.pratica.tipoPratica;
		return xcs_messaggio;
	}
}