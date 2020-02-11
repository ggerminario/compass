public  class RecuperaDatiPostvenditaRequest extends OCSAPIRequest {
    public String numPratica{get;set;}
    public String flagInfoCliente {get;set;}
    public String filtroTipoPratica {get;set;}
    public String codCliente {get;set;}
    public String cognomeCliente {get;set;}
    public String nomeCliente {get;set;}
    public String dataNascitaCliente {get;set;}
    public String codFiscaleCliente {get;set;}
    public String pan {get;set;}
    public String telefonoCliente {get;set;}
    public String faxCliente {get;set;}
    public String emailCliente {get;set;}
    public String provinciaCliente {get;set;}
    public String ragioneSociale {get;set;}
    public RecuperaDatiPostvenditaRequest(){
      super();
    }
    public RecuperaDatiPostvenditaRequest(String codCliente, String filtroTipoPratica, String flagInfoCliente) {
     super();
    this.codCliente = codCliente;
    this.filtroTipoPratica = filtroTipoPratica;
    this.flagInfoCliente = flagInfoCliente;
    } 
     public RecuperaDatiPostvenditaRequest(String codCliente) {
     super();
     this.codCliente = codCliente;
    } 
    public RecuperaDatiPostvenditaRequest(String telefonoCliente, String ragioneSociale, String provinciaCliente,
                                         String pan, String numPratica, String nomeCliente,
                                          String filtroTipoPratica, String flagInfoCliente, String faxCliente,
                                         String emailCliente, String dataNascitaCliente, 
                                         String cognomeCliente,  String codFiscaleCliente,  String codCliente) {
     super();

    this.telefonoCliente = telefonoCliente;
    this.ragioneSociale = ragioneSociale;
    this.provinciaCliente = provinciaCliente;
    this.pan = pan;
    
    this.numPratica = numPratica;
    this.nomeCliente = nomeCliente;
    this.filtroTipoPratica = filtroTipoPratica;
    this.flagInfoCliente = flagInfoCliente;

    this.faxCliente = faxCliente;
    this.emailCliente = emailCliente;
    this.dataNascitaCliente = dataNascitaCliente;
    this.cognomeCliente = cognomeCliente;
      this.codFiscaleCliente = codFiscaleCliente;
    this.codFiscaleCliente = codFiscaleCliente;


    this.codCliente = codCliente;
  
    } 

    /*

     "telefonoCliente":"",
   "ragioneSociale":"",
   "provinciaCliente":"",
   "pan":"",
   "numPratica":"21490879",
   "nomeCliente":"",
   "flagInfoCliente":"",
   "filtroTipoPratica":"CO",
   "faxCliente":"",
   "emailCliente":"",
   "dataNascitaCliente":"",
   "cognomeCliente":"",
   "codFiscaleCliente":"",
   "codCliente":"" */


}