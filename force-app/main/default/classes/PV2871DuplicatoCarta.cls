public with sharing class PV2871DuplicatoCarta extends PVAction {

    public class Indirizzo {
        @AuraEnabled
        public String cap {
            get {
				return cap;
			}
			set {
                cap = value != null ? value.trim() : value;
			}
        }
        @AuraEnabled
        public String capRischio {
            get {
				return capRischio;
			}
			set {
                capRischio = value != null ? value.trim() : value;
			}
        }
        @AuraEnabled
        public String civico {
            get {
				return civico;
			}
			set {
                civico = value != null ? value.trim() : value;
			}
        }
        @AuraEnabled
        public String indirizzo {
            get {
				return indirizzo;
			}
			set {
                indirizzo = value != null ? value.trim() : value;
			}
        }
        @AuraEnabled
        public String localita {
            get {
				return localita;
			}
			set {
                localita = value != null ? value.trim() : value;
			}
        }
        @AuraEnabled
        public String nazione {
            get {
				return nazione;
			}
			set {
                nazione = value != null ? value.trim() : value;
			}
        }
        @AuraEnabled
        public String provincia {
            get {
				return provincia;
			}
			set {
                provincia = value != null ? value.trim() : value;
			}
        }
        @AuraEnabled
        public String tipoIndirizzo {
            get {
				return tipoIndirizzo;
			}
			set {
                tipoIndirizzo = value != null ? value.trim() : value;
			}
        }

        public Indirizzo() {
            this('', '', '', '', '', '', '', '');
        }

        public Indirizzo(String cap, String capRischio, String civico, String indirizzo, String localita, String nazione, String provincia, String tipoIndirizzo) {
            this.cap = cap;
            this.capRischio = capRischio;
            this.civico = civico;
            this.indirizzo = indirizzo;
            this.localita = localita;
            this.nazione = nazione;
            this.provincia = provincia;
            this.tipoIndirizzo = tipoIndirizzo;
        }
    }
     public class BloccoCarta {
        @AuraEnabled
        public String keyCode { get; set; }
        @AuraEnabled
        public String descrizione {
            get {
                return descrizione;
            }
            set {
                descrizione = value != null ? value.trim() : value;
            }
        }
    }
    public class BloccoSbloccoCartaResult {
        @AuraEnabled
        public String bloccoCarta { get; set; }
        @AuraEnabled
        public String as400Status { get; set; }
        @AuraEnabled
        public String as400Errore { get; set; }
    }
    public class AzionePreFurtoFurtoResult {
        @AuraEnabled
        public String panNuovo { get; set; }
        @AuraEnabled
        public String as400Status { get; set; }
        @AuraEnabled
        public String as400Errore { get; set; }
    }

    public class DatiDuplicatoCarta{
        @AuraEnabled
        public String numeroCarta { get; set; }
        @AuraEnabled
        public String numeroPratica { get; set; }
        @AuraEnabled
        public String emettitore { get; set; }
        @AuraEnabled
        public String bloccoCarta { get; set; }
        @AuraEnabled
        public String dataValidita { get; set; }
        @AuraEnabled
        public String dataRientroProduzione { get; set; }
        @AuraEnabled
        public String origine { get; set; }
        @AuraEnabled
        public Double commissioni { get; set; }
        @AuraEnabled
        public Boolean applicaCommissioni { get; set; }
        @AuraEnabled
        public Boolean mostraScript { get; set; }
        @AuraEnabled
        public String as400Status { get; set; }
        @AuraEnabled
        public String as400Errore { get; set; }
        @AuraEnabled
        public Boolean errore { get; set; }

        @AuraEnabled public String filiale { get; set; }
        @AuraEnabled public Double pagamentoMinimo { get; set; }
        @AuraEnabled public String pagamentoMinimoPerc { get; set; }
        @AuraEnabled public String commissioneEntrata { get; set; }
        @AuraEnabled public String modCalcoloRata { get; set; }
        @AuraEnabled public String intestazione1 { get; set; }
        @AuraEnabled public String intestazione2 { get; set; }
        
        @AuraEnabled public String dataScadenza { get; set; }
        @AuraEnabled public String checkIntermediario { get; set; }
        @AuraEnabled public String pagamento { get; set; }
        @AuraEnabled public String bancaCliAbi { get; set; }
        @AuraEnabled public String bancaCliCab { get; set; }
        @AuraEnabled public String contoCorrente { get; set; }
        @AuraEnabled public String iban { get; set; }
        @AuraEnabled public String comRinnovo { get; set; }
        @AuraEnabled public String comRinnovo1 { get; set; }
        @AuraEnabled public String comRinnovoDurata1 { get; set; }
        @AuraEnabled public String comRinnovo2 { get; set; }
        @AuraEnabled public String comRinnovoDurata2 { get; set; }
        @AuraEnabled public String comRinnovo3 { get; set; }
        @AuraEnabled public String comRinnovoDurata3 { get; set; }
        @AuraEnabled public String stato { get; set; }
        @AuraEnabled public String blocco { get; set; }
        @AuraEnabled public String tassoTan { get; set; }
        @AuraEnabled public String tassoTaeg { get; set; }
        @AuraEnabled public String pan { get; set; }
        @AuraEnabled public Double fidoTotale { get; set; }
        @AuraEnabled public Double dispTotale { get; set; }
        @AuraEnabled public String fidoRiserva1 { get; set; }
        @AuraEnabled public String dispRiserva1 { get; set; }
        @AuraEnabled public String fidoRiserva2 { get; set; }
        @AuraEnabled public String dispRiserva2 { get; set; }
        @AuraEnabled public String fidoRiserva3 { get; set; }
        @AuraEnabled public String dispRiserva3 { get; set; }
        @AuraEnabled public String flagAttivazioneCarta { get; set; }
        @AuraEnabled public String codProdotto { get; set; }
        @AuraEnabled public String desProdotto { get; set; }
        @AuraEnabled public String flagAlertSms { get; set; }
        @AuraEnabled public Double riservaPrincipaleFido { get; set; }
        @AuraEnabled public String riservaPrincipaleFidoSegno { get; set; }
        @AuraEnabled public Double riservaPrincipaleSaldo { get; set; }
        @AuraEnabled public String riservaPrincipaleSaldoSegno { get; set; }
        @AuraEnabled public Double riservaPrincipaleDisp { get; set; }
        @AuraEnabled public String riservaPrincipaleDispSegno { get; set; }
        @AuraEnabled public Double riservaPrincipaleSconfino { get; set; }
        @AuraEnabled public String riservaPrincipaleSconfinoSegno { get; set; }
        @AuraEnabled public Double riservaPrincipaleOverlimit { get; set; }
        @AuraEnabled public String riservaPrincipaleOverlimitSegno { get; set; }
        @AuraEnabled public Double riservaPrincipaleDispTeorMax { get; set; }
        @AuraEnabled public String riservaPrincipaleDispTeorMaxSegno { get; set; }
        @AuraEnabled public Double riservaSalvadanaioFido { get; set; }
        @AuraEnabled public String riservaSalvadanaioFidoSegno { get; set; }
        @AuraEnabled public Double riservaSalvadanaioSaldo { get; set; }
        @AuraEnabled public String riservaSalvadanaioSaldoSegno { get; set; }
        @AuraEnabled public Double riservaSalvadanaioDisp { get; set; }
        @AuraEnabled public String riservaSalvadanaioDispSegno { get; set; }
        @AuraEnabled public Double riservaSalvadanaioSconfino { get; set; }
        @AuraEnabled public String riservaSalvadanaioSconfinoSegno { get; set; }
        @AuraEnabled public Double riservaSalvadanaioOverlimit { get; set; }
        @AuraEnabled public String riservaSalvadanaioOverlimitSegno { get; set; }
        @AuraEnabled public Double riservaSalvadanaioDispTeorMax { get; set; }
        @AuraEnabled public String riservaSalvadanaioDispTeorMaxSegno { get; set; }
        @AuraEnabled public Double riservaInternetFido { get; set; }
        @AuraEnabled public String riservaInternetFidoSegno { get; set; }
        @AuraEnabled public Double riservaInternetSaldo { get; set; }
        @AuraEnabled public String riservaInternetSaldoSegno { get; set; }
        @AuraEnabled public Double riservaInternetDisp { get; set; }
        @AuraEnabled public String riservaInternetDispSegno { get; set; }
        @AuraEnabled public Double riservaInternetSconfino { get; set; }
        @AuraEnabled public String riservaInternetSconfinoSegno { get; set; }
        @AuraEnabled public Double riservaInternetOverlimit { get; set; }
        @AuraEnabled public String riservaInternetOverlimitSegno { get; set; }
        @AuraEnabled public Double riservaInternetDispTeorMax { get; set; }
        @AuraEnabled public String riservaInternetDispTeorMaxSegno { get; set; }
        @AuraEnabled public Double riservaMulticontoFido { get; set; }
        @AuraEnabled public String riservaMulticontoFidoSegno { get; set; }
        @AuraEnabled public Double riservaMulticontoSaldo { get; set; }
        @AuraEnabled public String riservaMulticontoSaldoSegno { get; set; }
        @AuraEnabled public Double riservaMulticontoDisp { get; set; }
        @AuraEnabled public String riservaMulticontoDispSegno { get; set; }
        @AuraEnabled public Double riservaMulticontoSconfino { get; set; }
        @AuraEnabled public String riservaMulticontoSconfinoSegno { get; set; }
        @AuraEnabled public Double riservaMulticontoOverlimit { get; set; }
        @AuraEnabled public String riservaMulticontoOverlimitSegno { get; set; }
        @AuraEnabled public Double riservaMulticontoDispTeorMax { get; set; }
        @AuraEnabled public String riservaMulticontoDispTeorMaxSegno { get; set; }



        public OCSCartaDatiFinanziariResponse.DatiCartaDatiFinanziariResponseDTO datiFinanziari {get; set;}

        public DatiDuplicatoCarta() {
            this.commissioni = 0;
            this.applicaCommissioni = false;
            this.mostraScript = false;
            this.errore = false;
        }
    }

    @AuraEnabled
    public static List<Indirizzo> getIndirizziCliente(String codiceCliente) {
        List<Indirizzo> indirizzi;

        try {

            OCSRecuperaIndirizziClienteResponse response = OCSRecuperaIndirizziClienteInvoker.callRecIndirizzi(codiceCliente);
            System.debug('---> [PV2871DuplicatoCarta - getIndirizzi] response: ' + response);

            if (response != null && response.statusCode == 200 && response.resultCode == 0 ) {
                indirizzi = new List<Indirizzo>();

                if (response.recuperaIndirizziClienteResponse.elencoIndirizzi != null) {
                    for(OCSRecuperaIndirizziClienteResponse.IndirizzoDTO indirzzoDTO : response.recuperaIndirizziClienteResponse.elencoIndirizzi) {
                        indirizzi.add(new Indirizzo(indirzzoDTO.cap, indirzzoDTO.capRischio, indirzzoDTO.civico, indirzzoDTO.indirizzo, indirzzoDTO.localita, indirzzoDTO.nazione, indirzzoDTO.provincia, indirzzoDTO.tipoIndirizzo));
                    }
                }

            }

        } catch (Exception e) {
            System.debug('---> [PV2871DuplicatoCarta - getIndirizzi] Exception: ' + e.getMessage());
            indirizzi = null;
        }

        System.debug('---> [PV2871DuplicatoCarta - getIndirizzi] indirizzi: ' + indirizzi);
        return indirizzi;
    }

    @AuraEnabled
    public static DatiDuplicatoCarta getDatiDuplicatoCarta(String numeroCarta) {
        DatiDuplicatoCarta datiDuplicatoCarta = new DatiDuplicatoCarta();
        OCSCartaDatiFinanziariResponse cartaDatiFinanziari = OCSCartaDatiFinanziariInvoker.cartaDatiFinanziari(numeroCarta);
        OCSRecuperaInfoCartaResponse infoCarta2 = OCSRecuperaInfoCartaInvoker.callRecInfoCarta(numeroCarta);
        if (cartaDatiFinanziari != null && cartaDatiFinanziari.statusCode == 200 && cartaDatiFinanziari.resultCode == 0 && cartaDatiFinanziari.datiCartaDatiFinanziariResponse != null) {

            datiDuplicatoCarta.numeroCarta = numeroCarta;
            datiDuplicatoCarta.numeroPratica= cartaDatiFinanziari.datiCartaDatiFinanziariResponse.numeroPratica;
            datiDuplicatoCarta.emettitore = cartaDatiFinanziari.datiCartaDatiFinanziariResponse.emettitore;
            datiDuplicatoCarta.bloccoCarta = cartaDatiFinanziari.datiCartaDatiFinanziariResponse.blocco;
            
            datiDuplicatoCarta.as400Status = cartaDatiFinanziari.datiCartaDatiFinanziariResponse.as400Status;
            datiDuplicatoCarta.as400Errore = cartaDatiFinanziari.datiCartaDatiFinanziariResponse.as400Errore;
            datiDuplicatoCarta.filiale = cartaDatiFinanziari.datiCartaDatiFinanziariResponse.filiale; 
            datiDuplicatoCarta.pagamentoMinimo = cartaDatiFinanziari.datiCartaDatiFinanziariResponse.pagamentoMinimo; 
            datiDuplicatoCarta.pagamentoMinimoPerc = cartaDatiFinanziari.datiCartaDatiFinanziariResponse.pagamentoMinimoPerc; 
            datiDuplicatoCarta.commissioneEntrata = cartaDatiFinanziari.datiCartaDatiFinanziariResponse.commissioneEntrata; 
            datiDuplicatoCarta.modCalcoloRata = cartaDatiFinanziari.datiCartaDatiFinanziariResponse.modCalcoloRata; 
            datiDuplicatoCarta.intestazione1 = cartaDatiFinanziari.datiCartaDatiFinanziariResponse.intestazione1; 
            datiDuplicatoCarta.intestazione2 = cartaDatiFinanziari.datiCartaDatiFinanziariResponse.intestazione2; 
            datiDuplicatoCarta.dataValidita = cartaDatiFinanziari.datiCartaDatiFinanziariResponse.dataValidita; 
            datiDuplicatoCarta.dataScadenza = cartaDatiFinanziari.datiCartaDatiFinanziariResponse.dataScadenza; 
            datiDuplicatoCarta.checkIntermediario = cartaDatiFinanziari.datiCartaDatiFinanziariResponse.checkIntermediario; 
            datiDuplicatoCarta.pagamento = cartaDatiFinanziari.datiCartaDatiFinanziariResponse.pagamento; 
            datiDuplicatoCarta.bancaCliAbi = cartaDatiFinanziari.datiCartaDatiFinanziariResponse.bancaCliAbi; 
            datiDuplicatoCarta.bancaCliCab = cartaDatiFinanziari.datiCartaDatiFinanziariResponse.bancaCliCab; 
            datiDuplicatoCarta.contoCorrente = cartaDatiFinanziari.datiCartaDatiFinanziariResponse.contoCorrente; 
            datiDuplicatoCarta.iban = cartaDatiFinanziari.datiCartaDatiFinanziariResponse.iban; 
            datiDuplicatoCarta.comRinnovo = cartaDatiFinanziari.datiCartaDatiFinanziariResponse.comRinnovo; 
            datiDuplicatoCarta.comRinnovo1 = cartaDatiFinanziari.datiCartaDatiFinanziariResponse.comRinnovo1; 
            datiDuplicatoCarta.comRinnovoDurata1 = cartaDatiFinanziari.datiCartaDatiFinanziariResponse.comRinnovoDurata1; 
            datiDuplicatoCarta.comRinnovo2 = cartaDatiFinanziari.datiCartaDatiFinanziariResponse.comRinnovo2; 
            datiDuplicatoCarta.comRinnovoDurata2 = cartaDatiFinanziari.datiCartaDatiFinanziariResponse.comRinnovoDurata2; 
            datiDuplicatoCarta.comRinnovo3 = cartaDatiFinanziari.datiCartaDatiFinanziariResponse.comRinnovo3; 
            datiDuplicatoCarta.comRinnovoDurata3 = cartaDatiFinanziari.datiCartaDatiFinanziariResponse.comRinnovoDurata3; 
            datiDuplicatoCarta.stato = cartaDatiFinanziari.datiCartaDatiFinanziariResponse.stato; 
            datiDuplicatoCarta.blocco = cartaDatiFinanziari.datiCartaDatiFinanziariResponse.blocco; 
            datiDuplicatoCarta.tassoTan = cartaDatiFinanziari.datiCartaDatiFinanziariResponse.tassoTan; 
            datiDuplicatoCarta.tassoTaeg = cartaDatiFinanziari.datiCartaDatiFinanziariResponse.tassoTaeg; 
            datiDuplicatoCarta.pan = cartaDatiFinanziari.datiCartaDatiFinanziariResponse.pan; 
            datiDuplicatoCarta.fidoTotale = cartaDatiFinanziari.datiCartaDatiFinanziariResponse.fidoTotale; 
            datiDuplicatoCarta.dispTotale = cartaDatiFinanziari.datiCartaDatiFinanziariResponse.dispTotale; 
            datiDuplicatoCarta.fidoRiserva1 = cartaDatiFinanziari.datiCartaDatiFinanziariResponse.fidoRiserva1; 
            datiDuplicatoCarta.dispRiserva1 = cartaDatiFinanziari.datiCartaDatiFinanziariResponse.dispRiserva1; 
            datiDuplicatoCarta.fidoRiserva2 = cartaDatiFinanziari.datiCartaDatiFinanziariResponse.fidoRiserva2; 
            datiDuplicatoCarta.dispRiserva2 = cartaDatiFinanziari.datiCartaDatiFinanziariResponse.dispRiserva2; 
            datiDuplicatoCarta.fidoRiserva3 = cartaDatiFinanziari.datiCartaDatiFinanziariResponse.fidoRiserva3; 
            datiDuplicatoCarta.dispRiserva3 = cartaDatiFinanziari.datiCartaDatiFinanziariResponse.dispRiserva3; 
            datiDuplicatoCarta.flagAttivazioneCarta = cartaDatiFinanziari.datiCartaDatiFinanziariResponse.flagAttivazioneCarta; 
            datiDuplicatoCarta.codProdotto = cartaDatiFinanziari.datiCartaDatiFinanziariResponse.codProdotto; 
            datiDuplicatoCarta.desProdotto = cartaDatiFinanziari.datiCartaDatiFinanziariResponse.desProdotto; 
            datiDuplicatoCarta.flagAlertSms = cartaDatiFinanziari.datiCartaDatiFinanziariResponse.flagAlertSms; 
            datiDuplicatoCarta.riservaPrincipaleFido = cartaDatiFinanziari.datiCartaDatiFinanziariResponse.riservaPrincipaleFido; 
            datiDuplicatoCarta.riservaPrincipaleFidoSegno = cartaDatiFinanziari.datiCartaDatiFinanziariResponse.riservaPrincipaleFidoSegno; 
            datiDuplicatoCarta.riservaPrincipaleSaldo = cartaDatiFinanziari.datiCartaDatiFinanziariResponse.riservaPrincipaleSaldo; 
            datiDuplicatoCarta.riservaPrincipaleSaldoSegno = cartaDatiFinanziari.datiCartaDatiFinanziariResponse.riservaPrincipaleSaldoSegno; 
            datiDuplicatoCarta.riservaPrincipaleDisp = cartaDatiFinanziari.datiCartaDatiFinanziariResponse.riservaPrincipaleDisp; 
            datiDuplicatoCarta.riservaPrincipaleDispSegno = cartaDatiFinanziari.datiCartaDatiFinanziariResponse.riservaPrincipaleDispSegno; 
            datiDuplicatoCarta.riservaPrincipaleSconfino = cartaDatiFinanziari.datiCartaDatiFinanziariResponse.riservaPrincipaleSconfino; 
            datiDuplicatoCarta.riservaPrincipaleSconfinoSegno = cartaDatiFinanziari.datiCartaDatiFinanziariResponse.riservaPrincipaleSconfinoSegno; 
            datiDuplicatoCarta.riservaPrincipaleOverlimit = cartaDatiFinanziari.datiCartaDatiFinanziariResponse.riservaPrincipaleOverlimit; 
            datiDuplicatoCarta.riservaPrincipaleOverlimitSegno = cartaDatiFinanziari.datiCartaDatiFinanziariResponse.riservaPrincipaleOverlimitSegno; 
            datiDuplicatoCarta.riservaPrincipaleDispTeorMax = cartaDatiFinanziari.datiCartaDatiFinanziariResponse.riservaPrincipaleDispTeorMax; 
            datiDuplicatoCarta.riservaPrincipaleDispTeorMaxSegno = cartaDatiFinanziari.datiCartaDatiFinanziariResponse.riservaPrincipaleDispTeorMaxSegno; 
            datiDuplicatoCarta.riservaSalvadanaioFido = cartaDatiFinanziari.datiCartaDatiFinanziariResponse.riservaSalvadanaioFido; 
            datiDuplicatoCarta.riservaSalvadanaioFidoSegno = cartaDatiFinanziari.datiCartaDatiFinanziariResponse.riservaSalvadanaioFidoSegno; 
            datiDuplicatoCarta.riservaSalvadanaioSaldo = cartaDatiFinanziari.datiCartaDatiFinanziariResponse.riservaSalvadanaioSaldo; 
            datiDuplicatoCarta.riservaSalvadanaioSaldoSegno = cartaDatiFinanziari.datiCartaDatiFinanziariResponse.riservaSalvadanaioSaldoSegno; 
            datiDuplicatoCarta.riservaSalvadanaioDisp = cartaDatiFinanziari.datiCartaDatiFinanziariResponse.riservaSalvadanaioDisp; 
            datiDuplicatoCarta.riservaSalvadanaioDispSegno = cartaDatiFinanziari.datiCartaDatiFinanziariResponse.riservaSalvadanaioDispSegno; 
            datiDuplicatoCarta.riservaSalvadanaioSconfino = cartaDatiFinanziari.datiCartaDatiFinanziariResponse.riservaSalvadanaioSconfino; 
            datiDuplicatoCarta.riservaSalvadanaioSconfinoSegno = cartaDatiFinanziari.datiCartaDatiFinanziariResponse.riservaSalvadanaioSconfinoSegno; 
            datiDuplicatoCarta.riservaSalvadanaioOverlimit = cartaDatiFinanziari.datiCartaDatiFinanziariResponse.riservaSalvadanaioOverlimit; 
            datiDuplicatoCarta.riservaSalvadanaioOverlimitSegno = cartaDatiFinanziari.datiCartaDatiFinanziariResponse.riservaSalvadanaioOverlimitSegno; 
            datiDuplicatoCarta.riservaSalvadanaioDispTeorMax = cartaDatiFinanziari.datiCartaDatiFinanziariResponse.riservaSalvadanaioDispTeorMax; 
            datiDuplicatoCarta.riservaSalvadanaioDispTeorMaxSegno = cartaDatiFinanziari.datiCartaDatiFinanziariResponse.riservaSalvadanaioDispTeorMaxSegno; 
            datiDuplicatoCarta.riservaInternetFido = cartaDatiFinanziari.datiCartaDatiFinanziariResponse.riservaInternetFido; 
            datiDuplicatoCarta.riservaInternetFidoSegno = cartaDatiFinanziari.datiCartaDatiFinanziariResponse.riservaInternetFidoSegno; 
            datiDuplicatoCarta.riservaInternetSaldo = cartaDatiFinanziari.datiCartaDatiFinanziariResponse.riservaInternetSaldo; 
            datiDuplicatoCarta.riservaInternetSaldoSegno = cartaDatiFinanziari.datiCartaDatiFinanziariResponse.riservaInternetSaldoSegno; 
            datiDuplicatoCarta.riservaInternetDisp = cartaDatiFinanziari.datiCartaDatiFinanziariResponse.riservaInternetDisp; 
            datiDuplicatoCarta.riservaInternetDispSegno = cartaDatiFinanziari.datiCartaDatiFinanziariResponse.riservaInternetDispSegno; 
            datiDuplicatoCarta.riservaInternetSconfino = cartaDatiFinanziari.datiCartaDatiFinanziariResponse.riservaInternetSconfino; 
            datiDuplicatoCarta.riservaInternetSconfinoSegno = cartaDatiFinanziari.datiCartaDatiFinanziariResponse.riservaInternetSconfinoSegno; 
            datiDuplicatoCarta.riservaInternetOverlimit = cartaDatiFinanziari.datiCartaDatiFinanziariResponse.riservaInternetOverlimit; 
            datiDuplicatoCarta.riservaInternetOverlimitSegno = cartaDatiFinanziari.datiCartaDatiFinanziariResponse.riservaInternetOverlimitSegno; 
            datiDuplicatoCarta.riservaInternetDispTeorMax = cartaDatiFinanziari.datiCartaDatiFinanziariResponse.riservaInternetDispTeorMax; 
            datiDuplicatoCarta.riservaInternetDispTeorMaxSegno = cartaDatiFinanziari.datiCartaDatiFinanziariResponse.riservaInternetDispTeorMaxSegno; 
            datiDuplicatoCarta.riservaMulticontoFido = cartaDatiFinanziari.datiCartaDatiFinanziariResponse.riservaMulticontoFido; 
             
            datiDuplicatoCarta.riservaMulticontoSaldo = cartaDatiFinanziari.datiCartaDatiFinanziariResponse.riservaMulticontoSaldo; 
            datiDuplicatoCarta.riservaMulticontoSaldoSegno = cartaDatiFinanziari.datiCartaDatiFinanziariResponse.riservaMulticontoSaldoSegno; 
            datiDuplicatoCarta.riservaMulticontoDisp = cartaDatiFinanziari.datiCartaDatiFinanziariResponse.riservaMulticontoDisp; 
            datiDuplicatoCarta.riservaMulticontoDispSegno = cartaDatiFinanziari.datiCartaDatiFinanziariResponse.riservaMulticontoDispSegno; 
            datiDuplicatoCarta.riservaMulticontoSconfino = cartaDatiFinanziari.datiCartaDatiFinanziariResponse.riservaMulticontoSconfino; 
            datiDuplicatoCarta.riservaMulticontoSconfinoSegno = cartaDatiFinanziari.datiCartaDatiFinanziariResponse.riservaMulticontoSconfinoSegno; 
            datiDuplicatoCarta.riservaMulticontoOverlimit = cartaDatiFinanziari.datiCartaDatiFinanziariResponse.riservaMulticontoOverlimit; 
            datiDuplicatoCarta.riservaMulticontoOverlimitSegno = cartaDatiFinanziari.datiCartaDatiFinanziariResponse.riservaMulticontoOverlimitSegno; 
            datiDuplicatoCarta.riservaMulticontoDispTeorMax = cartaDatiFinanziari.datiCartaDatiFinanziariResponse.riservaMulticontoDispTeorMax; 
            datiDuplicatoCarta.riservaMulticontoDispTeorMaxSegno = cartaDatiFinanziari.datiCartaDatiFinanziariResponse.riservaMulticontoDispTeorMaxSegno;

            if(cartaDatiFinanziari.datiCartaDatiFinanziariResponse.as400Status == 'OK') {
                System.debug('----------> gestioneBlocchiLVVI datiDuplicatoCarta 1: ' + datiDuplicatoCarta);

                if (datiDuplicatoCarta.bloccoCarta == 'PT') {
                    datiDuplicatoCarta.mostraScript = true;
                    datiDuplicatoCarta.applicaCommissioni = false;
                } else if (datiDuplicatoCarta.bloccoCarta == 'SX') {
                    datiDuplicatoCarta.mostraScript = true;
                    datiDuplicatoCarta.applicaCommissioni = true;
                } else if (datiDuplicatoCarta.bloccoCarta == 'PE') {
                    datiDuplicatoCarta.mostraScript = true;
                    datiDuplicatoCarta.applicaCommissioni = true;
                   /* datiDuplicatoCarta.commissioni = double.valueOf(infoCarta2.recuperaInfoCartaResponse.importoCommAdesione)/100;*/
                } else if (datiDuplicatoCarta.bloccoCarta == 'XI') {
                    datiDuplicatoCarta.mostraScript = false;
                    datiDuplicatoCarta.applicaCommissioni = true;
                } else if (datiDuplicatoCarta.bloccoCarta == 'LL') {
                    datiDuplicatoCarta.mostraScript = false;
                    datiDuplicatoCarta.applicaCommissioni = true;
                } else {
                    datiDuplicatoCarta.mostraScript = false;
                    OCSRecuperaInfoCartaResponse infoCarta = OCSRecuperaInfoCartaInvoker.callRecInfoCarta(datiDuplicatoCarta.numeroCarta);

                    System.debug('----------> gestioneBlocchiLVVI datiDuplicatoCarta 2: ' + datiDuplicatoCarta);
                    System.debug('----------> gestioneBlocchiLVVI infoCarta 1: ' + infoCarta);
                    if (infoCarta != null && infoCarta.statusCode == 200 && infoCarta.resultCode == 0 && infoCarta.recuperaInfoCartaResponse != null) {
                        datiDuplicatoCarta.dataRientroProduzione = infoCarta.recuperaInfoCartaResponse.dataRientroProduzione;
                        datiDuplicatoCarta.origine = infoCarta.recuperaInfoCartaResponse.origine;
                       /* datiDuplicatoCarta.commissioni = decimal.valueOf(infoCarta.recuperaInfoCartaResponse.importoCommAdesione);*/
                        gestioneBlocchiLVVI(datiDuplicatoCarta);
                        
                    }
                    
                    else {
                        System.debug('----------> datiDuplicatoCarta.errore 1: ' + datiDuplicatoCarta.errore);
                        datiDuplicatoCarta.errore = true;
                    }
                }
                
             
            }
            else {
                System.debug('----------> datiDuplicatoCarta.errore 2: ' + datiDuplicatoCarta.errore);
                datiDuplicatoCarta.errore = true;
            }
           
        }

        System.debug('----------> datiDuplicatoCarta.errore 4: ' + datiDuplicatoCarta.errore);
        if (datiDuplicatoCarta.applicaCommissioni=true) {

            datiDuplicatoCarta.commissioni = double.valueOf(infoCarta2.recuperaInfoCartaResponse.importoCommAdesione)/100;    
        }
        

        else {
            datiDuplicatoCarta.errore = true;
        }
       /* if (datiDuplicatoCarta.applicaCommissioni == true) {
                        datiDuplicatoCarta.commissioni = Double.valueOf(commissioniDaApplicare);
                    System.debug('commissioni'+ datiDuplicatoCarta.commissioni);
                    
                }*/

        return datiDuplicatoCarta;
    }
    

    private static void gestioneBlocchiLVVI(DatiDuplicatoCarta datiDuplicatoCarta) {
        System.debug('----------> gestioneBlocchiLVVI datiDuplicatoCarta 3: ' + datiDuplicatoCarta);
        if(datiDuplicatoCarta.dataValidita != null && datiDuplicatoCarta.dataValidita.length() == 8 && datiDuplicatoCarta.dataRientroProduzione != null && datiDuplicatoCarta.dataRientroProduzione.length() == 8) {

            // Data richiesta duplicato carta
            Date dataRiferimento = System.today();

            // Data validità: per il calcolo va considerato sempre il primo giorno del mese
            Integer dataValiditaYear = Integer.valueOf(datiDuplicatoCarta.dataValidita.substring(0, 4));
            Integer dataValiditaMonth = Integer.valueOf(datiDuplicatoCarta.dataValidita.substring(4, 6));
            Integer dataValiditaDay = 1;
            Date dataValidita = Date.newInstance(dataValiditaYear, dataValiditaMonth, dataValiditaDay);

            // Data rientro produzione
            Integer dataRientroProduzioneYear = Integer.valueOf(datiDuplicatoCarta.dataRientroProduzione.substring(0, 4));
            Integer dataRientroProduzioneMonth = Integer.valueOf(datiDuplicatoCarta.dataRientroProduzione.substring(4, 6));
            Integer dataRientroProduzioneDay = Integer.valueOf(datiDuplicatoCarta.dataRientroProduzione.substring(6, 8));
            Date dataRientroProduzione = Date.newInstance(dataRientroProduzioneYear, dataRientroProduzioneMonth, dataRientroProduzioneDay);

            if(datiDuplicatoCarta.bloccoCarta == 'LV') {

                if(datiDuplicatoCarta.origine.equalsIgnoreCase('RINNOVO')) {
                    // Se dataRiferimento >= 4 settimane dalla data di validità si applicano commissioni
                    datiDuplicatoCarta.applicaCommissioni = dataRiferimento >= dataValidita.addDays(7*4);
                }
                else {
                    // Se dataRientroProduzione >= 6 settimane si applicano commissioni
                    datiDuplicatoCarta.applicaCommissioni = dataRientroProduzione <= dataRiferimento.addDays(-7*6);
                }
            }
            else if(datiDuplicatoCarta.bloccoCarta == 'VI') {

                //Se cliente BP
                if(datiDuplicatoCarta.emettitore == '3' || datiDuplicatoCarta.emettitore == '003') {
                    if(datiDuplicatoCarta.origine.equalsIgnoreCase('RINNOVO')) {
                        // Se dataRiferimento >= 4 settimane dalla data di validità si applicano commissioni
                        datiDuplicatoCarta.applicaCommissioni = dataRiferimento >= dataValidita.addDays(7*4);
                    }
                    else {
                        // Se dataRientroProduzione >= 6 settimane si applicano commissioni
                        datiDuplicatoCarta.applicaCommissioni = dataRientroProduzione <= dataRiferimento.addDays(-7*6);
                    }
               
                }
                else{
                    //Cliente Compass
                    // Se dataRiferimento >= 4 settimane dalla data di validità si applicano commissioni
                    datiDuplicatoCarta.applicaCommissioni = dataRiferimento >= dataValidita.addDays(7*4);

                }
            }
            
        }
        else {
            System.debug('----------> datiDuplicatoCarta.errore 3: ' + datiDuplicatoCarta.errore);
            datiDuplicatoCarta.errore = true;
        }
    }

    

/*****************************************************************************************************************/

    public class PV2871DuplicatoCartaForm extends PVForm {
       
        @AuraEnabled
        public BloccoCarta bloccoCarta { get; set;}
        @AuraEnabled
        public String nuovoPan { get; set;}
    }

    @AuraEnabled
    public static void conferma(PV2871DuplicatoCartaForm datiForm) {
        System.debug('---> [PV2871DuplicatoCarta - conferma] datiForm: ' + datiForm);
        new PV2871DuplicatoCarta().execute(datiForm);
    }

    public void execute(PVForm form) {
        String messaggio_errore = '';

        try {
            PV2871DuplicatoCartaForm myForm = (PV2871DuplicatoCartaForm) form;
            System.debug('---> [PV2871DuplicatoCarta - execute] PVForm: ' + myForm);
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
        PV2871DuplicatoCartaForm myform = (PV2871DuplicatoCartaForm) form;
        String notaSpecificaPV;
		notaSpecificaPV = 'Blocco Rimosso: ' +  myForm.bloccoCarta.keyCode + '<br>';
		notaSpecificaPV += 'Nuovo Pan: ' + myForm.nuovoPan + '<br>';
        return notaSpecificaPV;
    }

    public override XCS_Messaggio__c preparaMessaggioOCS(PVForm form, XCS_Messaggio__c xcs_messaggio) {
        PV2871DuplicatoCartaForm myForm = (PV2871DuplicatoCartaForm) form;
        xcs_messaggio.NumPratica__c = myForm.pratica.numPratica;
        xcs_messaggio.TipoPratica__c = myForm.pratica.tipoPratica;
        xcs_messaggio.CodCliente__c = myForm.pratica.codCliente;
        return xcs_messaggio;
    }
   @AuraEnabled
    public static BloccoSbloccoCartaResult bloccoSbloccoCarta(String numeroCarta, String tipoOperazione, String bloccoCarta, String utente) {
        BloccoSbloccoCartaResult result;

        try {

            OCSBloccoSbloccoCartaInvoker.BloccoSbloccoCartaRequestDTO bloccoSbloccoCartaRequestDTO = new OCSBloccoSbloccoCartaInvoker.BloccoSbloccoCartaRequestDTO();
            bloccoSbloccoCartaRequestDTO.numeroCarta = numeroCarta;
            bloccoSbloccoCartaRequestDTO.tipoOperazione = tipoOperazione;
            bloccoSbloccoCartaRequestDTO.bloccoCarta = bloccoCarta;
            bloccoSbloccoCartaRequestDTO.utente = utente;

            OCSBloccoSbloccoCartaInvoker.Response response = OCSBloccoSbloccoCartaInvoker.invoke(bloccoSbloccoCartaRequestDTO);
            System.debug('---> [PV2871DuplicatoCarta - bloccoSbloccoCarta] response: ' + response);

            if (response != null && response.statusCode == 200 && response.resultCode == 0) {
                result = new BloccoSbloccoCartaResult();
                result.bloccoCarta = response.datiBloccoSbloccoCartaResponse.bloccoCarta;
                result.as400Status = response.datiBloccoSbloccoCartaResponse.as400Status;
                result.as400Errore = response.datiBloccoSbloccoCartaResponse.as400Errore;
            }

        } catch (Exception e) {
            System.debug('---> [PV2871DuplicatoCarta - bloccoSbloccoCarta] Exception: ' + e.getMessage());
            result = null;
        }

        System.debug('---> [PV2871DuplicatoCarta - bloccoSbloccoCarta] result: ' + result);
        return result;
    }
    
    @AuraEnabled
    public static AzionePreFurtoFurtoResult azionePreFurtoFurto(String provenienza, String tipoIntermediario, String intermediario, String numCarta, String operazione, String modEmissione, String dataValidita, String mesiValidita, String importoCommissioni, String addebitoCommissioni, String utente ) {
        AzionePreFurtoFurtoResult result;

        system.debug('**** azionePreFurtoFurto ****');

        try {

            OCSAzionePreFurtoInvoker.AzionePreFurtoFurtoRequestDTO azionePreFurtoFurtoRequestDTO = new OCSAzionePreFurtoInvoker.AzionePreFurtoFurtoRequestDTO();
            azionePreFurtoFurtoRequestDTO.provenienza = provenienza;
            azionePreFurtoFurtoRequestDTO.tipoIntermediario = tipoIntermediario;
            azionePreFurtoFurtoRequestDTO.intermediario = intermediario;
            azionePreFurtoFurtoRequestDTO.numCarta = numCarta;

            azionePreFurtoFurtoRequestDTO.operazione = operazione;
            azionePreFurtoFurtoRequestDTO.modEmissione = modEmissione;
            azionePreFurtoFurtoRequestDTO.dataValidita = dataValidita;
            azionePreFurtoFurtoRequestDTO.mesiValidita = mesiValidita;
            azionePreFurtoFurtoRequestDTO.importoCommissioni = importoCommissioni;
            azionePreFurtoFurtoRequestDTO.addebitoCommissioni = addebitoCommissioni;
            azionePreFurtoFurtoRequestDTO.utente = utente;
            

            OCSAzionePreFurtoInvoker.Response response = OCSAzionePreFurtoInvoker.invoke(azionePreFurtoFurtoRequestDTO);
            System.debug('---> [PV2871DuplicatoCarta - azionePreFurtoFurto] response: ' + response);

            if (response != null && response.statusCode == 200 ) {
                result = new AzionePreFurtoFurtoResult();
                result.panNuovo = response.azionePreFurtoFurtoResponse.panNuovo;
                result.as400Status = response.azionePreFurtoFurtoResponse.as400Status;
                result.as400Errore = response.azionePreFurtoFurtoResponse.as400Errore;
            }

        } catch (Exception e) {
            System.debug('---> [PV2871DuplicatoCarta - azionePreFurtoFurto] Exception: ' + e.getMessage());
            result = null;
        }

        System.debug('---> [PV2871DuplicatoCarta - azionePreFurtoFurto] result: ' + result);
        return result;
    }
}