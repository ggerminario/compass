/**
 * @File Name          : BatchSaldiRossi.cls
 * @Description        : 
 * @Author             : sabrina vitali
 * @Group              : 
 * @Last Modified By   : sabrina vitali
 * @Last Modified On   : 4/12/2019, 13:54:31
 * @Modification Log   : 
 * Ver       Date            Author      		    Modification
 * 1.0    3/12/2019   sabrina vitali     Initial Version
**/
public class BatchSaldiRossi implements Database.Batchable<OCSRecuperaSaldiRossiCarteRevocateRes.SaldoRossoDTO>, Database.Stateful, Database.AllowsCallouts {
    
    private final String EMPTY_STRING = ''; 
    private final String ZERO_VALUE = '0';
    private final String NUM_PRATICA_003 = '003';
    private String strFlagError = EMPTY_STRING;    
    private String destinatario = 'crm@compass.it';    
    private List<OCSRecuperaSaldiRossiCarteRevocateRes.SaldoRossoDTO> dtos;
    private List<OCSSbloccaSaldiRossiRequest.SbloccoSaldoRossoDTO> elencoPraticheDaAgg = new List<OCSSbloccaSaldiRossiRequest.SbloccoSaldoRossoDTO>();
    
    public BatchSaldiRossi(List<OCSRecuperaSaldiRossiCarteRevocateRes.SaldoRossoDTO> dtos) {
        this.dtos = dtos;
    }
    
    public Iterable<OCSRecuperaSaldiRossiCarteRevocateRes.SaldoRossoDTO> start(Database.BatchableContext context) {
        return this.dtos;
    }
    
    public void execute(Database.BatchableContext context, List<OCSRecuperaSaldiRossiCarteRevocateRes.SaldoRossoDTO> saldiRossiJson) {
        
        Datetime executionDate = Datetime.now();
        Integer executionDay = executionDate.day();
       	Boolean isFirstDay = (executionDay == 1) ? true : false;
        String strTipoPagamento;
        String strImportoSaldo;
        String strNumPratica;
        List<Messaging.SingleEmailMessage> emailToSend = new List<Messaging.SingleEmailMessage>();
        
        Map<Account, Account> accountMap = new Map<Account, Account>();
        for (OCSRecuperaSaldiRossiCarteRevocateRes.SaldoRossoDTO saldoRosso : saldiRossiJson) {
            if (String.isEmpty(saldoRosso.numPratica)) {
                strFlagError = 'numero pratica vuoto.';
                break;
            }
            strTipoPagamento = saldoRosso.tipoPagamento;
            if ((SaldiRossiUtils.PAYMENT_METHOD_BP.equalsIgnoreCase(strTipoPagamento)) || ((SaldiRossiUtils.PAYMENT_METHOD_RID.equalsIgnoreCase(strTipoPagamento)) && (isFirstDay))) {
                
                strImportoSaldo = saldoRosso.importoSaldo;
                Double importoSaldo;
                try {
                    importoSaldo = Double.valueOf(strImportoSaldo); 
                } catch (Exception e) {
                    strFlagError = e.getMessage();
                    break;
                }
                
                if (importoSaldo > 500.00) {
                    strNumPratica = saldoRosso.numPratica;
                    if (NUM_PRATICA_003.equals(strNumPratica.substring(0,3))) {
                        strTipoPagamento = SaldiRossiUtils.PAYMENT_METHOD_BP;
                    }
                    
/*                      //remmato sabry per gestione Account nel PV
                        Account acc = new Account(OCS_External_Id__c = saldoRosso.codCliente,                                                
                                              FirstName = saldoRosso.nome,
                                              LastName = saldoRosso.cognome,
                                              Codice_Fiscale__pc = saldoRosso.codFiscale,
                                              PersonEmail = saldoRosso.email,
                                              PersonBirthdate = getDateValue(saldoRosso.dataNascita),
                                              Birthcity__c = saldoRosso.luogoNascita,
                                              Birthprovince__c = saldoRosso.provNascita,
                                              Sesso__pc = saldoRosso.sesso,                                                
                                              Phone = saldoRosso.telefonoCasa,
                                              PersonMobilePhone = saldoRosso.telCellulare
                                             );
                    
                    accountMap.put(acc, null);
*/                    
                    PV1757RimborsoCliSaldoRossoInserimento.PV1757RimborsoCliSaldoRossoForm datiForm = new PV1757RimborsoCliSaldoRossoInserimento.PV1757RimborsoCliSaldoRossoForm();
                    datiForm = (PV1757RimborsoCliSaldoRossoInserimento.PV1757RimborsoCliSaldoRossoForm) PV1757RimborsoCliSaldoRossoInserimento.prepareFormExternal(datiForm, '1757', null);
                    //datiForm = (PV1757RimborsoCliSaldoRossoInserimento.PV1757RimborsoCliSaldoRossoForm) PV1757RimborsoCliSaldoRossoInserimento.prepareFormExternal(datiForm, '1757', '0050Q000002FQu4QAG');
                    datiForm.cliente = new OCSCliente();
                    datiForm.cliente.email = saldoRosso.email;
                    datiForm.cliente.codCliente = saldoRosso.codCliente;
                    datiForm.cliente.cognome = saldoRosso.cognome;
                    datiForm.cliente.nome = saldoRosso.nome;
                    datiForm.cliente.denominazioneAzienda = saldoRosso.nome + ' ' + saldoRosso.cognome;
                    datiForm.cliente.dataNascita = saldoRosso.dataNascita;
                    //aggiunte sabry per gestione Account da PV
                    datiForm.cliente.codFiscale = saldoRosso.codFiscale;
                    datiForm.cliente.luogoNascita = saldoRosso.luogoNascita;
                    datiForm.cliente.provNascita = saldoRosso.provNascita;
                    datiForm.cliente.sesso = saldoRosso.sesso;                                          
                    datiForm.cliente.telefonoCasa = saldoRosso.telefonoCasa;
                    datiForm.cliente.telCellulare = saldoRosso.telCellulare;
                    
                    datiform.note = 'richiesta creata automaticamente';
                    
                    datiform.pratica = new OCSPratica();
                    datiform.pratica.tipoPratica = saldoRosso.tipoPratica;
                    datiform.pratica.numPratica = saldoRosso.numPratica;
                    
                    if (SaldiRossiUtils.PAYMENT_METHOD_RID.equalsIgnoreCase(strTipoPagamento)) {
                        datiform.modalitaRimborso = 'Bonifico';  
                    } else {
                        datiform.modalitaRimborso = 'Assegno';  
                    }
                    
                    datiform.importo = importoSaldo;
                    //sabry: aggiunta nota appropriata
                    if(datiform.modalitaRimborso.equalsIgnoreCase('Bonifico')){
                      datiform.noteRimborso = 'Modalità rimborso: Bonifico\nDati Bancari:\n';
                      datiform.noteRimborso += ' ABI:' + saldoRosso.abi + '\n CAB' + saldoRosso.cab + '\n C/C' + saldoRosso.numConto + '\nI BAN' + saldoRosso.iban;
                    }
                    if(datiform.modalitaRimborso.equalsIgnoreCase('Assegno')){
                      datiform.noteRimborso = 'Modalità rimborso: Assegno\nDi seguito è riportato l"indirizzo di spedizione rilevato in OCS.\n ';
                      datiform.noteRimborso += saldoRosso.cognome + ' ' + saldoRosso.nome + '\n ';
                      datiform.noteRimborso += saldoRosso.indirizzo + '\n ' + saldoRosso.cap + ' ' + saldoRosso.localita + '('+ saldoRosso.provincia +')\n';  
                    }
                    //sabry: verifica precedenti inserimenti per la stessa pratica per calcolare lo stato nel PV
                    System.debug('** numPratica : ' + saldoRosso.numPratica + ' - dataRevocaCarta : ' + saldoRosso.dataRevocaCarta + ' - importo : ' + importoSaldo
                         + ' - CIP : ' + saldoRosso.codCliente + ' - CF : ' + saldoRosso.codFiscale);   
                    List<Case> casoPrec = new List<Case>();
                    casoPrec = [SELECT Id,NumeroPratica__c,Importo_Rimborso__c FROM Case 
                                                WHERE Categoria_Riferimento__r.External_Id__c = '1757' 
                                                and NumeroPratica__c =: saldoRosso.numPratica
                                                    and CreatedDate >: getDateValue(saldoRosso.dataRevocaCarta)
                                                        and RecordType.DeveloperName = 'XCS_Post_Vendita' ];
                    
                    if(casoPrec.size()>0)
                        datiForm.importoPrec = casoPrec[0].Importo_Rimborso__c;
                    System.debug('** datiForm.importoPrec : ' + datiForm.importoPrec);

                    PV1757RimborsoCliSaldoRossoInserimento.conferma(datiform);
                    
                    //alimentazione lista di pratiche da aggiornare in OCS...   
                    OCSSbloccaSaldiRossiRequest.SbloccoSaldoRossoDTO pratica = new OCSSbloccaSaldiRossiRequest.SbloccoSaldoRossoDTO();
                    pratica.numPratica = saldoRosso.numPratica;
                    pratica.dataRevocaCarta = saldoRosso.dataRevocaCarta;
                    elencoPraticheDaAgg.add(pratica);
                }
            }
        }
        //fuori dal ciclo for, se è valorizzato strFlagError allora mando mail errore....
        if (!EMPTY_STRING.equals(strFlagError)) {
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            String[] toAddresses = new String[]{destinatario};
                mail.setToAddresses(toAddresses);
            mail.setSubject('Compass: Recupero Saldi Rossi carte revocate ERRORE');
            mail.setPlainTextBody('Errore lettura saldi:' + strFlagError);
            emailToSend.add(mail);
        }
        /* //remmato sabry per gestione Account nel PV
            else {
            //richiamo deduplica anagrafica                   
            if ((accountMap != null) && (accountMap.size()>0)) {
                XCSGestioneAnagrafica.deduplica(accountMap, true);
                Map<String, Account> accountVerifiedMap = new Map<String, Account>();
                for (Account acc : AccountMap.values()) {                       
                    accountVerifiedMap.put(decodeOcsExternalId(acc.OCS_external_id__c), acc);
                }
            }
        }*/
        
        if ((emailToSend != null) && (emailToSend.size() > 0)) {
            EmailUtils.sendEmail(emailToSend);
            elencoPraticheDaAgg = null;
        }
        
    }
    
    public void finish(Database.BatchableContext context) {
        
        List<Messaging.SingleEmailMessage> emailToSend = new List<Messaging.SingleEmailMessage>();
        //richiamo servizio SOAP per sblocco pratiche in OCS...
        if ((elencoPraticheDaAgg != null) && (elencoPraticheDaAgg.size()>0)) {
            OCSSbloccaSaldiRossiResponse resp;
            try {
                resp = OCSSbloccaSaldiRossiInvoker.sbloccaSaldiRossi(elencoPraticheDaAgg);                        
            } catch (Exception e) {
                strFlagError = e.getMessage();
            } 
            
            if (!(String.isEmpty(strFlagError))) {
                //servizio sblocca andato in errore...
                Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                String[] toAddresses = new String[]{destinatario};
                    mail.setToAddresses(toAddresses);
                mail.setSubject('Compass: Sblocco Saldi Rossi carte revocate ERRORE');
                mail.setPlainTextBody('Errore sblocco :' + strFlagError);
                emailToSend.add(mail);
            } else {
                
                Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
                String[] toAddresses = new String[]{destinatario};
                    mail.setToAddresses(toAddresses);
                mail.setSubject('Compass: Sblocco Saldi Rossi carte revocate TERMINATO');                       
                emailToSend.add(mail); 
                
            }
            
            if ((emailToSend != null) && (emailToSend.size() > 0)) {
                EmailUtils.sendEmail(emailToSend);
            }
          
        }
        
    }
     
    private static Date getDateValue(String strDate) {
               
        if (!(String.isEmpty(strDate))) {
            
            if (strDate.length() == 8) {
                return Date.newInstance(Integer.valueOf(strDate.substring(0,4)), Integer.valueOf(strDate.substring(4,6)), Integer.valueOf(strDate.substring(6,8)));   
            } else {
                throw new UnexpectedException('Errore formato data non riconosciuto.');
            }
            
        } else {
            
            return null;
            
        }
        
    }
    
    private static String decodeOcsExternalId(String OcsExternalID) {
        
        String ret = null;
        final String CHAR_C = 'C';
        
        if (CHAR_C.equalsIgnoreCase(OcsExternalID.substring(0,1))) {
            ret = OcsExternalID.substring(1);
        }
        
        return ret;
    }

}