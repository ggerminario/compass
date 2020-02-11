public with sharing class PV1754StornoAddebito extends PVAction {

    public class Rimborso {
        @AuraEnabled
        public String id { get; set; }
        @AuraEnabled
        public String descrizione { get; set; }
        @AuraEnabled
        public Decimal value { get; set; }

    }

    public class PV1754StornoAddebitoForm extends PVForm {
        @AuraEnabled
        public String numeroPratica { get; set; }

        @AuraEnabled
        public String richiestaRimborso { get; set; }

        @AuraEnabled
        public List <Rimborso> elencoRimborsi { get; set; }

        @AuraEnabled
        public Map<String, String> modalitaRimborso { get; set; }

        @AuraEnabled
        public Decimal getTotaleRimborsi() {
            Decimal totale = 0;

            if(elencoRimborsi != null) {
                for(Rimborso rimborso : this.elencoRimborsi) {
                    if(rimborso.value != null) {
                        totale += rimborso.value;
                    }
                }
            }

            return totale;
        }
    }

    @AuraEnabled
    public static OCSCartaDatiFinanziariResponse.DatiCartaDatiFinanziariResponseDTO getDatiFinanziariCarta(String numeroCarta) {
        OCSCartaDatiFinanziariResponse response = OCSCartaDatiFinanziariInvoker.cartaDatiFinanziari(numeroCarta);
        return response.datiCartaDatiFinanziariResponse;
    }

    @AuraEnabled
    public static void conferma(PV1754StornoAddebitoForm datiForm) {
        System.debug('---> [PV1754StornoAddebito - conferma] datiForm: ' + datiForm);
        new PV1754StornoAddebito().execute(datiForm);
    }

    /*
    @AuraEnabled
    public static Boolean verificaIBAN(String iban) {
        return XCS_IbanController.verificaIBAN(iban);
    }

    @AuraEnabled
    public static String calcolaIBAN(String abi,String cab,String numConto) {
        OCSCalcolaIbanInvoker.DatiChiamataOCS response = XCS_IbanController.calcolaIBAN(abi, cab, numConto);
        return ((response != null && response.chiamataOK == true) ? response.iban : '');
    }
    */

    public void execute(PVForm form) {
        String messaggio_errore = '';

        try {
            PV1754StornoAddebitoForm myForm = (PV1754StornoAddebitoForm) form;
            System.debug('---> [PV1754StornoAddebito - execute] PVForm: ' + myForm);
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

    public override String recuperaNotaSpecificaPV(PVForm form, Case casoPV) {
        PV1754StornoAddebitoForm myform = (PV1754StornoAddebitoForm) form;

        String notaSpecificaPV = 'Numero pratica: ' + myform.numeroPratica + '<br>Elenco Storni: <br>';

        List<String> args = new List<String>{'0','number','###,###,##0.00'};

        for(Rimborso rimborso : myform.elencoRimborsi) {
            notaSpecificaPV += rimborso.id + ' - ' + rimborso.descrizione + ' - ' + String.format(rimborso.value.format(), args) + ' € <br>';
        }

        notaSpecificaPV += 'Totale storni: ' + String.format(myform.getTotaleRimborsi().format(), args) + ' € <br>';

        notaSpecificaPV += 'Richiesta rimborso: ' + myform.richiestaRimborso + '<br>';

        if(myform.modalitaRimborso != null) {
            if(myform.modalitaRimborso.get('modalitaPagamento').equalsIgnoreCase('Assegno') ){
                notaSpecificaPV += 'Modalità pagamento: ' + myform.modalitaRimborso.get('modalitaPagamento') + '<br>';
                notaSpecificaPV += 'Indirizzo spedizione: ' + myform.modalitaRimborso.get('indirizzoSpedizione') + '<br>';
                notaSpecificaPV += 'CAP: ' + myform.modalitaRimborso.get('cap') + '<br>';
                notaSpecificaPV += 'Provincia: ' + myform.modalitaRimborso.get('provincia') + '<br>';
                notaSpecificaPV += 'Città: ' + myform.modalitaRimborso.get('citta');
            }
            else if(myform.modalitaRimborso.get('modalitaPagamento').equalsIgnoreCase('Bonifico') ){
                notaSpecificaPV += 'Modalità pagamento: ' + myform.modalitaRimborso.get('modalitaPagamento') + '<br>';
                notaSpecificaPV += 'Intestatario: ' + myform.modalitaRimborso.get('intestatario') + '<br>';
                notaSpecificaPV += 'ABI: ' + myform.modalitaRimborso.get('abi') + '<br>';
                notaSpecificaPV += 'CAB: ' + myform.modalitaRimborso.get('cab') + '<br>';
                notaSpecificaPV += 'CC: ' + myform.modalitaRimborso.get('cc')  + '<br>';
                notaSpecificaPV += 'IBAN: ' + myform.modalitaRimborso.get('iban');
            }
        }

        return notaSpecificaPV;
    }

    public override XCS_Messaggio__c preparaMessaggioOCS(PVForm form, XCS_Messaggio__c xcs_messaggio) {
        PV1754StornoAddebitoForm myForm = (PV1754StornoAddebitoForm) form;
        xcs_messaggio.NumPratica__c = myForm.pratica.numPratica;
        xcs_messaggio.TipoPratica__c = myForm.pratica.tipoPratica;
        xcs_messaggio.CodCliente__c = myForm.pratica.codCliente;
        return xcs_messaggio;
    }
}