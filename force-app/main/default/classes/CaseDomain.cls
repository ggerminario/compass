/**
* @author ADIOP abdoulaye.diop@compass.com.dev
* @date  13/11/2019
* @description
**/
global with sharing class CaseDomain { 

    static final String CONTATTO_NON_ESEGUITO = 'CONTATTO NON ESEGUITO';
    static final String CONTATTO_ESEGUITO = 'CONTATTO ESEGUITO';
    static final String NUMERO_INESISTENTE = 'NUMERO INESISTENTE';
    static final String CLIENTE_NON_TROVATO = 'CLIENTE NON TROVATO';
    static final String CLIENTE_NON_INTERESSATO = 'CLIENTE NON INTERESSATO';
    public static final String CONFERMA_VECCHIO_RECAPITO = 'CONFERMA VECCHIO RECAPITO';    
    public static final String CONFERMA_NUOVO_RECAPITO = 'CONFERMA NUOVO RECAPITO';
    static final String INVIO_LINK_RIPRESA_BOZZA = 'INVIO LINK RIPRESA BOZZA';
    static final String NESSUNA_ALTRA_AZIONE = 'NESSUNA ALTRA AZIONE';
    static final String NON_INTERESSATO = 'NON INTERESSATO';
    static final String DISCONOSCE_LA_PRATICA  = 'DISCONOSCE LA PRATICA';
    static final String FISSA_APPUNTAMENTO  = 'FISSA APPUNTAMENTO';
    static final String CHIEDE_DI_ESSERE_RICHIAMATO  = 'CHIEDE DI ESSERE RICHIAMATO';
    static final String CARICHERA_LA_DOCUMENTAZIONE = 'Caricherà la documentazione';
    static final String HA_GIA_CARICATO_LA_DOCUMENTAZIONE = 'Ha già caricato la documentazione';
    static final String FIRMERA_IL_CONTRATTO = 'Firmerà il contratto';
    static final String HA_GIA_FIRMATO_IL_CONTRATTO = 'Ha già firmato il contratto';
    static final String INBOUND_ASSISTENZA = 'INBOUND ASSISTENZA';
    static final String INVIO_DEM_RICARICA_PRATICA = 'INVIO DEM RICARICA PRATICA';
    static final String DISCORDANZA_CELLULARE_ESEGUITA = 'DISCORDANZA CELLULARE ESEGUITA';
    static final String IDENTITA_NON_CONFERMATA = 'Identità non confermata';
    static final String RICHIESTA_INFO_GENERICHE_SUL_CARICO = 'RICHIESTA INFO GENERICHE SUL CARICO';

    static final List<String> codesQueue = new List<String>{'Q330', 'Q331', 'Q332'};
    public static Integer tentativo = 3;
    public static Boolean isResolved = false;
    
    /**
     * @Author ADIOP
     * @date  04/06/2019
     * @description Method get a developerName(code) in queue
     * @param String ownerId, the owner of the case
     **/
    global with sharing class Assembly {
        Case caseObject;
        String code; 
        String firstLevel;
        String secondLevel;
        String thirdLevel;
        Boolean showLinkEvo;

        global Assembly(){}

        global Assembly(Case caseObject, String code, String firstLevel, String secondLevel, 
                            String thirdLevel, Boolean showLinkEvo){
            this.caseObject = caseObject;
            this.code = code;
            this.firstLevel = firstLevel;
            this.secondLevel = secondLevel;
            this.thirdLevel = thirdLevel;
            this.showLinkEvo = showLinkEvo;
        }

        global String getSecondLevel() {
            return secondLevel.toUpperCase();
        }

        global String getEtat(String developerName){
            if (CaseService.checkCaseInQueue(this.caseObject.OwnerId)) {
                switch on developerName {
                    //Discordanza cellulare E-commerce
                    when 'Q337' {
                        /*
                        Id profileId = UserInfo.getProfileId();
                        String profileName = [Select Id, Name from Profile where Id=:profileId].Name;
                        system.debug('#l ProfileName '+ profileName);
                        if (profileName == 'RTC') {
                            if (this.firstLevel.toUpperCase() == CONTATTO_ESEGUITO) {
                                if (this.secondLevel.toUpperCase() == RICHIESTA_INFO_GENERICHE_SUL_CARICO) {
                                    return '10';
                                } else if (this.secondLevel.toUpperCase() == INVIO_LINK_RIPRESA_BOZZA ) {
                                    return '114';
                                } else if (this.secondLevel.toUpperCase() == NON_INTERESSATO) {
                                    return '100';
                                } else if (this.secondLevel.toUpperCase() == DISCONOSCE_LA_PRATICA) {
                                    return '106';
                                } else {
                                    return '10';
                                }
                            }
                            return '10';
                        }
                        */
                        if (this.firstLevel.toUpperCase() == CONTATTO_NON_ESEGUITO) {
                            if (this.secondLevel.toUpperCase() == NUMERO_INESISTENTE) {
                                if(this.showLinkEvo){                                
                                    return '100';
                                }
                                return '101';
                            } else if (this.secondLevel.toUpperCase() == CLIENTE_NON_TROVATO) {
                                return '102';
                            }
                        } else if (this.firstLevel.toUpperCase() == CONTATTO_ESEGUITO) {
                            if (this.secondLevel.toUpperCase() == CONFERMA_VECCHIO_RECAPITO) {
                                if (this.thirdLevel.toUpperCase() == INVIO_LINK_RIPRESA_BOZZA) {
                                    isResolved = true;
                                    return '103';
                                } else if (this.thirdLevel.toUpperCase() == NESSUNA_ALTRA_AZIONE) {
                                    // si esce dalla coda
                                    isResolved = true;
                                    return '104';                                    
                                }
                            } else if (this.secondLevel.toUpperCase() == CONFERMA_NUOVO_RECAPITO) {
                                if (this.thirdLevel.toUpperCase() == INVIO_LINK_RIPRESA_BOZZA) {
                                    return '103';
                                } else if (this.thirdLevel.toUpperCase() == NESSUNA_ALTRA_AZIONE) {
                                    return '104';
                                } else if (this.thirdLevel == '') {
                                    return '120';
                                }
                            } else if (this.secondLevel.toUpperCase() == NON_INTERESSATO) {
                                isResolved = true;     
                                return '105';
                            } else if (this.secondLevel.toUpperCase() == DISCONOSCE_LA_PRATICA) {                                
                                isResolved = true;
                                return '106';
                            } else if (this.secondLevel.toUpperCase() == IDENTITA_NON_CONFERMATA.toUpperCase()) {
                                return '100';
                            }
                        }
                    }
                    /*Abbandono web PP * Abbandono non forzoso PP * Abbandono forzoso PP  richiami */
                    when 'Q330', 'Q331', 'Q332', 'Q333' {
                        if (this.firstLevel.toUpperCase() == CONTATTO_NON_ESEGUITO) {
                            if (this.secondLevel.toUpperCase() == NUMERO_INESISTENTE) {                                
                                return '107';
                            } else if (this.secondLevel.toUpperCase() == CLIENTE_NON_TROVATO) {
                                return '108';
                            }
                        } else if (this.firstLevel.toUpperCase() == CONTATTO_ESEGUITO) {
                            if (this.secondLevel.toUpperCase() == INVIO_LINK_RIPRESA_BOZZA) {                          
                                return '103';
                            } else if (this.secondLevel.toUpperCase() == NON_INTERESSATO) {                            
                                return '107';
                            } else if (this.secondLevel.toUpperCase() == FISSA_APPUNTAMENTO) {
                                // opens page to contact center operator of request appointment.
                                return '111';
                            }
                        }
                    }
                    // Abbandono PP Partners
                    when 'Q375' {
                        if (this.firstLevel.toUpperCase() == CONTATTO_NON_ESEGUITO) {
                            if (this.secondLevel.toUpperCase() == NUMERO_INESISTENTE) {
                                return '107';
                            } else if (this.secondLevel.toUpperCase() == CLIENTE_NON_TROVATO) {
                                return '108';
                            }
                        } else if (this.firstLevel.toUpperCase() == CONTATTO_ESEGUITO) {
                            if (this.secondLevel.toUpperCase() == INVIO_LINK_RIPRESA_BOZZA) {
                                return '103';
                            } else if (this.secondLevel.toUpperCase() == NON_INTERESSATO) {
                                return '107';
                            } else if (this.secondLevel.toUpperCase() == FISSA_APPUNTAMENTO) {
                                return '116';
                            }
                        }
                    }
                    // Anomalie Pre Sic PP
                    when 'Q339' {
                        // if anomalie  review         
                        // Nel caso sia presente una discordanza Cellulare
                        if (this.caseObject.Is_Discordanza_Cellulare__c) {
                            if (this.firstLevel.toUpperCase() == CONTATTO_NON_ESEGUITO) {
                                if (this.secondLevel.toUpperCase() == NUMERO_INESISTENTE) {
                                    return '100';
                                } else if (this.secondLevel.toUpperCase() == CLIENTE_NON_TROVATO) {
                                    return '102';
                                }
                            } else if (this.firstLevel.toUpperCase() == CONTATTO_ESEGUITO) {
                                if (this.secondLevel.toUpperCase() == CONFERMA_VECCHIO_RECAPITO) {
                                    if (this.thirdLevel.toUpperCase() == INVIO_LINK_RIPRESA_BOZZA) {
                                        isResolved = true;
                                        return '103';
                                    } else if (this.thirdLevel.toUpperCase() == NESSUNA_ALTRA_AZIONE) {
                                        isResolved = true;
                                        return '104';
                                    }
                                } else if (this.secondLevel.toUpperCase() == CONFERMA_NUOVO_RECAPITO) {
                                    if (this.thirdLevel.toUpperCase() == INVIO_LINK_RIPRESA_BOZZA) {
                                        return '103';
                                    } else if (this.thirdLevel.toUpperCase() == NESSUNA_ALTRA_AZIONE) {
                                        return '104';
                                    } else if (this.thirdLevel == '') {
                                        return '120';
                                    }
                                } else if (this.secondLevel.toUpperCase() == NON_INTERESSATO) {
                                    isResolved = true;
                                    return '105'; 
                                    // à ajouter dans la liste                  
                                } else if (this.secondLevel.toUpperCase() == DISCONOSCE_LA_PRATICA) {
                                    isResolved = true;
                                    return '106';
                                } else if (this.secondLevel.toUpperCase() == CHIEDE_DI_ESSERE_RICHIAMATO) {
                                    return '111';
                                } else if (this.secondLevel.toUpperCase() == IDENTITA_NON_CONFERMATA.toUpperCase()) {
                                    return '100';
                                }
                            }
                        } // Nel caso siano presenti solo anomalie documentali (senza discordanza cellulare)
                        else {
                            if (this.firstLevel.toUpperCase() == CONTATTO_NON_ESEGUITO) {
                                if (this.secondLevel.toUpperCase() == NUMERO_INESISTENTE) {
                                    return '109';
                                } else if (this.secondLevel.toUpperCase() == CLIENTE_NON_TROVATO) {
                                    return '119';
                                }
                            } else if (this.firstLevel.toUpperCase() == CONTATTO_ESEGUITO) {
                                if (this.secondLevel.toUpperCase() == CARICHERA_LA_DOCUMENTAZIONE.toUpperCase()) {
                                    if (this.thirdLevel.toUpperCase() == INVIO_LINK_RIPRESA_BOZZA) {
                                        return '103';
                                    } else if (this.thirdLevel.toUpperCase() == NESSUNA_ALTRA_AZIONE) {
                                        return '104';
                                    } else if (this.thirdLevel == '') {
                                        return '113';
                                    }
                                } else if (this.secondLevel.toUpperCase() == HA_GIA_CARICATO_LA_DOCUMENTAZIONE.toUpperCase()) {
                                    return '113';
                                } else if (this.secondLevel.toUpperCase() == NON_INTERESSATO) {
                                    return '115';
                                } else if (this.secondLevel.toUpperCase() == DISCONOSCE_LA_PRATICA) {
                                    return '107';
                                } else if (this.secondLevel.toUpperCase() == CHIEDE_DI_ESSERE_RICHIAMATO) {
                                    return '111';
                                }
                            }
                        }
                        return '10';
                    }
                    // Anomalie Post Sic PP (à revoir thirdlevel == cliente non trovato)
                    when 'Q340' {
                        if (this.firstLevel.toUpperCase() == CONTATTO_NON_ESEGUITO) {
                            if (this.secondLevel.toUpperCase() == NUMERO_INESISTENTE) {
                                return '109';
                            } else if (this.secondLevel.toUpperCase() == CLIENTE_NON_TROVATO) {
                                return '119';
                            }
                        } else if (this.firstLevel.toUpperCase() == CONTATTO_ESEGUITO) {
                            if (this.secondLevel.toUpperCase() == CARICHERA_LA_DOCUMENTAZIONE.toUpperCase()) {
                                if (this.thirdLevel.toUpperCase() == INVIO_LINK_RIPRESA_BOZZA) {
                                    return '103';
                                } else if (this.thirdLevel.toUpperCase() == NESSUNA_ALTRA_AZIONE) {
                                    return '104';
                                } else if (this.thirdLevel == '') {
                                    return '113';
                                }
                            } else if (this.secondLevel.toUpperCase() == HA_GIA_CARICATO_LA_DOCUMENTAZIONE.toUpperCase()) {
                                return '113';
                            } else if (this.secondLevel.toUpperCase() == NON_INTERESSATO) {
                                return '107';
                            } else if (this.secondLevel.toUpperCase() == DISCONOSCE_LA_PRATICA) {
                                return '106';
                            } else if (this.secondLevel.toUpperCase() == CHIEDE_DI_ESSERE_RICHIAMATO) {
                                return '111';
                            }
                        }
                    }
                    // Sollecito Contratto
                    when 'Q377' {
                        if (this.firstLevel.toUpperCase() == CONTATTO_NON_ESEGUITO) {
                            if (this.secondLevel.toUpperCase() == NUMERO_INESISTENTE) {
                                return '109';
                            } else if (this.secondLevel.toUpperCase() == CLIENTE_NON_TROVATO) {
                                return '119';
                            }
                        } else if (this.firstLevel.toUpperCase() == CONTATTO_ESEGUITO) {
                            if (this.secondLevel.toUpperCase() == FIRMERA_IL_CONTRATTO.toUpperCase()) {
                                if (this.thirdLevel.toUpperCase() == INVIO_LINK_RIPRESA_BOZZA) {
                                    return '103';
                                } else if (this.thirdLevel.toUpperCase() == NESSUNA_ALTRA_AZIONE) {
                                    return '104';
                                } else if (this.thirdLevel == '') {
                                    return '113';
                                }
                            } else if (this.secondLevel.toUpperCase() == HA_GIA_FIRMATO_IL_CONTRATTO.toUpperCase()) {
                                return '113';
                            } else if (this.secondLevel.toUpperCase() == NON_INTERESSATO) {
                                return '107';
                            } else if (this.secondLevel.toUpperCase() == DISCONOSCE_LA_PRATICA) {
                                return '106';
                            } else if (this.secondLevel.toUpperCase() == CHIEDE_DI_ESSERE_RICHIAMATO) {
                                return '111';
                            }
                        }
                    }
                    // Anomalie PP Partners // Anomalie
                    when 'Q376' {
                        // if anomalie  review
                        // Nel caso sia presente una discordanza Cellulare
                        if (this.caseObject.Is_Discordanza_Cellulare__c) {
                            if (this.firstLevel.toUpperCase() == CONTATTO_NON_ESEGUITO) {
                                if (this.secondLevel.toUpperCase() == NUMERO_INESISTENTE) {
                                    isResolved = true;
                                    return '100';
                                } else if (this.secondLevel.toUpperCase() == CLIENTE_NON_TROVATO) {
                                    isResolved = true;
                                    return '102';
                                }
                            } else if (this.firstLevel.toUpperCase() == CONTATTO_ESEGUITO) {
                                if (this.secondLevel.toUpperCase() == CONFERMA_VECCHIO_RECAPITO) {
                                    if (this.thirdLevel.toUpperCase() == INVIO_LINK_RIPRESA_BOZZA) {
                                        isResolved = true;
                                        return '103';
                                    } else if (this.thirdLevel.toUpperCase() == NESSUNA_ALTRA_AZIONE) {
                                        isResolved = true;
                                        return '104';
                                    }
                                } else if (this.secondLevel.toUpperCase() == CONFERMA_NUOVO_RECAPITO) {
                                    if (this.thirdLevel.toUpperCase() == INVIO_LINK_RIPRESA_BOZZA) {
                                        return '103';
                                    } else if (this.thirdLevel.toUpperCase() == NESSUNA_ALTRA_AZIONE) {
                                        return '104';
                                    } else if (this.thirdLevel == '') {
                                        return '120';
                                    }
                                } else if (this.secondLevel.toUpperCase() == NON_INTERESSATO) {
                                    isResolved = true;
                                    return '105'; 
                                    // à ajouter dans la liste                  
                                } else if (this.secondLevel.toUpperCase() == DISCONOSCE_LA_PRATICA) {
                                    isResolved = true;
                                    return '106';
                                } else if (this.secondLevel.toUpperCase() == CHIEDE_DI_ESSERE_RICHIAMATO) {
                                    return '111';
                                } /*else if (this.secondLevel.toUpperCase() == CARICHERA_LA_DOCUMENTAZIONE.toUpperCase()) {
                                    if (this.thirdLevel == '') {
                                        return '113';
                                    }
                                }*/
                            }
                        } // Nel caso siano presenti solo anomalie documentali (senza discordanza cellulare)
                        else {
                            if (this.firstLevel.toUpperCase() == CONTATTO_NON_ESEGUITO) {
                                if (this.secondLevel.toUpperCase() == NUMERO_INESISTENTE) {
                                    return '109';
                                } else if (this.secondLevel.toUpperCase() == CLIENTE_NON_TROVATO) {
                                    return '119';
                                }
                            } else if (this.firstLevel.toUpperCase() == CONTATTO_ESEGUITO) {
                                if (this.secondLevel.toUpperCase() == CARICHERA_LA_DOCUMENTAZIONE.toUpperCase()) {
                                    if (this.thirdLevel.toUpperCase() == INVIO_LINK_RIPRESA_BOZZA) {
                                        return '103';
                                    } else if (this.thirdLevel.toUpperCase() == NESSUNA_ALTRA_AZIONE) {
                                        return '104';
                                    } else if (this.thirdLevel == '') {
                                        return '113';
                                    }
                                } else if (this.secondLevel.toUpperCase() == HA_GIA_CARICATO_LA_DOCUMENTAZIONE.toUpperCase()) {
                                    return '113';
                                } else if (this.secondLevel.toUpperCase() == NON_INTERESSATO) {
                                    return '107';
                                } else if (this.secondLevel.toUpperCase() == DISCONOSCE_LA_PRATICA) {
                                    return '106';
                                } else if (this.secondLevel.toUpperCase() == CHIEDE_DI_ESSERE_RICHIAMATO) {
                                    return '111';
                                }
                            }
                        }
                        return '10'; 
                    }
                    // default queue
                    when 'Q525' {
                        if (this.firstLevel.toUpperCase() == INBOUND_ASSISTENZA) {
                            if (this.secondLevel.toUpperCase() == INVIO_LINK_RIPRESA_BOZZA) {
                                return '103';
                            } else if (this.secondLevel.toUpperCase() == INVIO_DEM_RICARICA_PRATICA) {
                                return 'review';
                            } else if (this.secondLevel.toUpperCase() == NON_INTERESSATO) {
                                return '107';
                            } else if (this.secondLevel.toUpperCase() == DISCONOSCE_LA_PRATICA) {
                                return '106';
                            }
                        }
                    }
                    // Abbandono E-commerce
                    when 'Q336' {
                        if (this.firstLevel.toUpperCase() == CONTATTO_NON_ESEGUITO) {
                            if (this.secondLevel.toUpperCase() == NUMERO_INESISTENTE) {                            
                                return '109';
                            } else if (this.secondLevel.toUpperCase() == CLIENTE_NON_TROVATO) {
                                return '108';
                            }
                        } else if (this.firstLevel.toUpperCase() == CONTATTO_ESEGUITO) {                        
                            if (this.secondLevel.toUpperCase() == CARICHERA_LA_DOCUMENTAZIONE.toUpperCase()) {
                                if (this.thirdLevel.toUpperCase() == INVIO_LINK_RIPRESA_BOZZA) {
                                    return '103';
                                } else if (this.thirdLevel.toUpperCase() == NESSUNA_ALTRA_AZIONE) {
                                    return '104';
                                } else if (this.thirdLevel == '') {
                                    return '113';
                                }
                            } else if (this.secondLevel.toUpperCase() == HA_GIA_CARICATO_LA_DOCUMENTAZIONE.toUpperCase()) {
                                return '104';
                            } else if (this.secondLevel.toUpperCase() == NON_INTERESSATO) {
                                return '107';
                            } else if (this.secondLevel.toUpperCase() == DISCONOSCE_LA_PRATICA) {
                                return '106';
                            } else if (this.secondLevel.toUpperCase() == CHIEDE_DI_ESSERE_RICHIAMATO) {
                                return '111';
                            }
                        }
                    }
                    // CODA ANOMALIE Doc. E-commerce
                    when 'Q338' {
                        // if anomalie  review
                        // Nel caso sia presente una discordanza Cellulare
                        if (this.caseObject.Is_Discordanza_Cellulare__c) {
                            if (this.firstLevel.toUpperCase() == CONTATTO_NON_ESEGUITO) {
                                if (this.secondLevel.toUpperCase() == NUMERO_INESISTENTE) {
                                    return '10';
                                } else if (this.secondLevel.toUpperCase() == CLIENTE_NON_TROVATO) {
                                    return '108';
                                }
                            } else if (this.firstLevel.toUpperCase() == CONTATTO_ESEGUITO) {
                                if (this.secondLevel.toUpperCase() == CONFERMA_VECCHIO_RECAPITO) {
                                    if (this.thirdLevel.toUpperCase() == INVIO_LINK_RIPRESA_BOZZA) {
                                        isResolved = true;
                                        return '104';
                                    } else if (this.thirdLevel.toUpperCase() == NESSUNA_ALTRA_AZIONE) {
                                        isResolved = true;
                                        return '104';
                                    }
                                } else if (this.secondLevel.toUpperCase() == CONFERMA_NUOVO_RECAPITO) {                                    
                                    return '120';
                                } else if (this.secondLevel.toUpperCase() == NON_INTERESSATO) {
                                    isResolved = true;
                                    return '110';                 
                                } else if (this.secondLevel.toUpperCase() == DISCONOSCE_LA_PRATICA) {
                                    isResolved = true;
                                    return '100';
                                } else if (this.secondLevel.toUpperCase() == CHIEDE_DI_ESSERE_RICHIAMATO) {
                                    return '111';
                                    // review
                                } else if (this.secondLevel.toUpperCase() == IDENTITA_NON_CONFERMATA.toUpperCase()) {
                                    isResolved = true;
                                    //return '105';
                                    return '100';
                                }
                            }
                        } else {
                            if (this.firstLevel.toUpperCase() == CONTATTO_NON_ESEGUITO) {
                                if (this.secondLevel.toUpperCase() == NUMERO_INESISTENTE) {
                                    return '104';
                                } else if (this.secondLevel.toUpperCase() == CLIENTE_NON_TROVATO) {
                                    return '119';
                                }
                            } else if (this.firstLevel.toUpperCase() == CONTATTO_ESEGUITO) {
                                if (this.secondLevel.toUpperCase() == CARICHERA_LA_DOCUMENTAZIONE.toUpperCase()) {
                                    return '104';
                                } else if (this.secondLevel.toUpperCase() == HA_GIA_CARICATO_LA_DOCUMENTAZIONE.toUpperCase()) {
                                    return '104';
                                } else if (this.secondLevel.toUpperCase() == NON_INTERESSATO) {
                                    return '104';
                                } else if (this.secondLevel.toUpperCase() == DISCONOSCE_LA_PRATICA) {
                                    return '104';
                                }
                            }
                        }
                        return '10';
                    }
                    // Sollecito Contratto PP Partners
                    when 'Q341' {
                        if (this.firstLevel.toUpperCase() == CONTATTO_NON_ESEGUITO) {
                            if (this.secondLevel.toUpperCase() == NUMERO_INESISTENTE) {
                                return '109';
                            } else if (this.secondLevel.toUpperCase() == CLIENTE_NON_TROVATO) {
                                return '119';
                            }
                        } else if (this.firstLevel.toUpperCase() == CONTATTO_ESEGUITO) {
                            if (this.secondLevel.toUpperCase() == FIRMERA_IL_CONTRATTO.toUpperCase()) {
                                if (this.thirdLevel.toUpperCase() == INVIO_LINK_RIPRESA_BOZZA) {
                                    return '103';
                                } else if (this.thirdLevel.toUpperCase() == NESSUNA_ALTRA_AZIONE) {
                                    return '104';
                                } else if (this.thirdLevel == '') {
                                    return '113';
                                }
                            } else if (this.secondLevel.toUpperCase() == HA_GIA_FIRMATO_IL_CONTRATTO.toUpperCase()) {
                                return '113';
                            } else if (this.secondLevel.toUpperCase() == NON_INTERESSATO) {
                                return '107';
                            } else if (this.secondLevel.toUpperCase() == DISCONOSCE_LA_PRATICA) {
                                return '106';
                            } else if (this.secondLevel.toUpperCase() == CHIEDE_DI_ESSERE_RICHIAMATO) {
                                return '111';
                            }
                        }
                    }
                    when else {
                        return '10';
                    }
                }
            }
            return '10';
        }
    }

    /**
     * @Author ADIOP
     * @date  06/06/2019
     * @description 
     **/
    global interface CaseStateInterface {
        Map<String, Object> action(CaseDomain.CaseContext caseContext);
    }

    /**
     * @Author ADIOP
     * @date  06/06/2019
     * @description 
     **/
    global with sharing class CaseContext {
        private CaseStateInterface caseStateInterface {get; set;} 
        private Case caseObject {get; set;}
        private String developerName {get; set;}
        private Boolean showLinkEvo{get; set;}

        global void setState(CaseStateInterface caseStateInterface) {
            this.caseStateInterface = caseStateInterface;
        }
        
        global CaseContext(Case caseObject, String developerName, Boolean showLinkEvo){
            //this.caseStateInterface = caseStateInterface;
            this.caseObject = caseObject;
            this.developerName = developerName;
            this.showLinkEvo = showLinkEvo;
        }

        public Map<String, Object> action(){
            return caseStateInterface.action(this);
        }
    }

    // for state 100
    global with sharing class ContattoNonEseguitoContext1 implements CaseDomain.CaseStateInterface  {        
        global Map<String, Object> action(CaseDomain.CaseContext caseContext){
            Map<String, Object> response = new Map<String, Object>(); 
            response.put('linkevo', caseContext.showLinkEvo);
            String developerName = caseContext.developerName;
            caseContext.caseObject = CaseDomain.changeOwner(caseContext.caseObject, developerName);            
            response.put('case', caseContext.caseObject);
            return response;
        }
    }

    // for state 102
    global with sharing class ContattoNonEseguitoContext2 implements CaseDomain.CaseStateInterface  {        
        global Map<String, Object> action(CaseDomain.CaseContext caseContext){
            Map<String, Object> response = new Map<String, Object>();
            Decimal cmpt = caseContext.caseObject.Tentativo__c; 
            
            if (cmpt > tentativo) {
                String developerName = caseContext.developerName;
                caseContext.caseObject = CaseDomain.changeOwner(caseContext.caseObject, developerName);
                response.put('linkevo', caseContext.showLinkEvo);
            }
            response.put('case', caseContext.caseObject);
            return response;
        }
    }

    // for state 103
    global with sharing class ContattoNonEseguitoContext3 implements CaseDomain.CaseStateInterface  {        
        global Map<String, Object> action(CaseDomain.CaseContext caseContext){
            Map<String, Object> response = new Map<String, Object>();
            String developerName = caseContext.developerName;
            caseContext.caseObject = CaseDomain.changeOwner(caseContext.caseObject, developerName);
            response.put('case', caseContext.caseObject);
            response.put('linkevo', caseContext.showLinkEvo);
            return response;
        }
    }

    // for state 104
    global with sharing class ContattoNonEseguitoContext4 implements CaseDomain.CaseStateInterface  {        
        global Map<String, Object> action(CaseDomain.CaseContext caseContext){
            Map<String, Object> response = new Map<String, Object>();
            String developerName = caseContext.developerName;
            caseContext.caseObject = CaseDomain.changeOwner(caseContext.caseObject, developerName);     
            response.put('case', caseContext.caseObject);
            response.put('linkevo', caseContext.showLinkEvo);
            return response;
        }
    }

    // for 
    global with sharing class ContattoNonEseguitoContext5 implements CaseDomain.CaseStateInterface  {        
        global Map<String, Object> action(CaseDomain.CaseContext caseContext){
            Map<String, Object> response = new Map<String, Object>(); 
            response.put('linkevo', caseContext.showLinkEvo);
            response.put('case', caseContext.caseObject);
            return response;
        }
    }

    //for status '106'; 
    global with sharing class ContattoNonEseguitoContext6 implements CaseDomain.CaseStateInterface  {        
        global Map<String, Object> action(CaseDomain.CaseContext caseContext){
            Map<String, Object> response = new Map<String, Object>();
            String developerName = caseContext.developerName;
            caseContext.caseObject = CaseDomain.changeOwner(caseContext.caseObject, developerName);         
            response.put('linkevo', caseContext.showLinkEvo);
            response.put('case', caseContext.caseObject);
            return response;
        }
    }

    // for status
    global with sharing class ContattoNonEseguitoContext7 implements CaseDomain.CaseStateInterface  {        
        global Map<String, Object> action(CaseDomain.CaseContext caseContext){
            Map<String, Object> response = new Map<String, Object>();
            Decimal cmpt = caseContext.caseObject.Tentativo__c;
            if (cmpt >= tentativo) {
                system.debug('///////////////////////// Numero tentativi raggiunti');
                String developerName = caseContext.developerName;
                caseContext.caseObject = CaseDomain.changeOwner(caseContext.caseObject, developerName);
                response.put('linkevo', caseContext.showLinkEvo);
            }
            response.put('case', caseContext.caseObject);
            return response;
        }
    }

    // for status 119
    global with sharing class ContattoNonEseguitoContext8 implements CaseDomain.CaseStateInterface  {        
        global Map<String, Object> action(CaseDomain.CaseContext caseContext){
            Map<String, Object> response = new Map<String, Object>();
            Decimal cmpt = caseContext.caseObject.Tentativo__c;                                  
            if (cmpt == tentativo) {                
                String developerName = caseContext.developerName;
                caseContext.caseObject = CaseDomain.changeOwner(caseContext.caseObject, developerName);
                response.put('linkevo', caseContext.showLinkEvo);               
            }
            response.put('case', caseContext.caseObject);
            return response;
        }
    }

    // for state 113
    global with sharing class ContattoNonEseguitoContext9 implements CaseDomain.CaseStateInterface  {        
        global Map<String, Object> action(CaseDomain.CaseContext caseContext){
            Map<String, Object> response = new Map<String, Object>();
            String developerName = caseContext.developerName;
            caseContext.caseObject = CaseDomain.changeOwner(caseContext.caseObject, developerName);
            response.put('linkevo', caseContext.showLinkEvo);
            response.put('case', caseContext.caseObject);
            return response;
        }
    }

    global with sharing class ContattoNonEseguitoContext10 implements CaseDomain.CaseStateInterface  {        
        global Map<String, Object> action(CaseDomain.CaseContext caseContext){
            Map<String, Object> response = new Map<String, Object>();
            Decimal cmpt = caseContext.caseObject.Tentativo__c;
            if (cmpt > 6) {
                String developerName = caseContext.developerName;
                caseContext.caseObject = CaseDomain.changeOwner(caseContext.caseObject, developerName);
                response.put('linkevo', caseContext.showLinkEvo);
            }
            response.put('case', caseContext.caseObject);
            return response;
        }
    }

    /**
     * @author ADIOP
     * @date 14/11/2019
     * @description change Case Owner
     * @param String developerName the code of the queue
     * @param Case caseObject
     **/
    public static Case changeOwner(Case caseObject, String developerName){
        if (developerName != '') {
            Group gr = CaseService.getQueue(developerName);
            if (gr != null) {
                caseObject.Tentativo__c = null;
                caseObject.OwnerId = gr.Id;
            }
            if (developerName == 'Q524') {
                caseObject.Status = 'Gestito';
            }
        }
        return  caseObject;
    }

    /**
     * @author ADIOP
     * @date 30/09/2019
     * @description handle send email dem
     * @param String developerName the name of the queue
     **/
    @future
    public static void mailDem(String dem, Id idCase, String subj, String replyTo, String fromAddress){

        try {            
            Case caseObject = [SELECT Id, NumeroPratica__c, RO_Link_Bozza__c, CaseNumber, AccountId, (SELECT Id, CreatedDate FROM Anomalie_Doc__r ORDER BY CreatedDate DESC LIMIT 1) FROM Case WHERE Id=:idCase];
            Map<String, Object> caseObjectMap = (Map<String, Object>) JSON.deserializeUntyped(JSON.serialize(caseObject));
            String linkBozza = caseObjectMap.containsKey('RO_Link_Bozza__c') ?  caseObject.RO_Link_Bozza__c : '';
            String caseNumber = caseObjectMap.containsKey('CaseNumber') ?  caseObject.CaseNumber : '';
            String numeroPratica = caseObjectMap.containsKey('NumeroPratica__c') ? caseObject.NumeroPratica__c : '';

            List<Anomalie_Doc__c> anomalies = new List<Anomalie_Doc__c>();
            if(caseObject.Anomalie_Doc__r.size() > 0){
                Datetime cDate = caseObject.Anomalie_Doc__r[0].CreatedDate;
                anomalies = [SELECT Id, CreatedDate,codice_Anomalia__c, Descrizione_Anomalia_Op__c,Codice_Macro_Documento__c,
                Descrizione_Anomalia_Cliente__c, Codice_Documento__c, descrizione_Documento__c,descrizione_Macro_Doc__c FROM Anomalie_Doc__c 
                                WHERE CaseId__c=:idCase AND  CreatedDate =: cDate];
            }

            Contact contact = [Select Email	, Id, FirstName, LastName, DEM_Param_7__c, DEM_Param_8__c, DEM_Param_9__c From Contact WHERE AccountId =:caseObject.AccountId LIMIT 1];
            Account account = [SELECT Id, FirstName, LastName, PersonEmail FROM Account WHERE Id =:caseObject.AccountId LIMIT 1];
            
            Map<String, Object> accountObjectMap = (Map<String, Object>) JSON.deserializeUntyped(JSON.serialize(account));

            String personName = account.FirstName+' '+account.LastName;
            String nameTemplate = 'DEM' + dem;
            EmailTemplate template = [SELECT Id, HtmlValue, Body, subject FROM EmailTemplate WHERE Name =:nameTemplate];
            List<Messaging.SingleEmailMessage> allMsg = new List<Messaging.SingleEmailMessage>();
            Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
            try {
                OrgWideEmailAddress owea = [select Id from OrgWideEmailAddress where Address = 'donotreply@compass.it']; //:fromAddress
                mail.setOrgWideEmailAddressId(owea.Id);
            } catch (Exception e) {
                mail.setSenderDisplayName(fromAddress);
                System.debug('error '+ e.getMessage() + ' '+ e.getStackTraceString());
            }
            mail.setReplyTo('donotreply@compass.it'); //replyTo account.PersonEmail
            System.debug('#l account.PersonEmail '+ account.PersonEmail);
            //account.PersonEmail
            mail.setToAddresses(new String[] {account.PersonEmail});  // 'layepythagore.91@gmail.com', 'assanebadji16@gmail.com', account.PersonEmail 'moustapha.diop@lynxspa.com', 
            mail.setTemplateID(template.Id);
            mail.setSaveAsActivity(true);
            String subject = template.subject;
            mail.setSubject(subject);
            
            String htmlBody = template.HtmlValue;
            String plainBody = template.Body;
            System.debug('################ DEM ' + nameTemplate + ' ##############');

            switch on nameTemplate {
                // DEMAbbandonoPostSecci_PP_CB
                when 'DEM2552'{
                    String firstName = accountObjectMap.containsKey('FirstName') ? account.FirstName : '';
                    String lastName =  accountObjectMap.containsKey('LastName') ? account.LastName : '';
                    htmlBody = htmlBody.replace('{!Contact.FirstName}', firstName);
                    htmlBody = htmlBody.replace('{!Contact.LastName}', lastName);
                    htmlBody = htmlBody.replace('{!param8}', linkBozza);
                }
                // DEMAbbandonoWEBPreSecci
                when 'DEM2059'{
                    String firstName = accountObjectMap.containsKey('FirstName') ? account.FirstName : '';
                    htmlBody = htmlBody.replace('{!Contact.FirstName}', firstName);
                    subject = subject.replace('{!Contact.FirstName}', firstName);
                }
                // DEMAbbandonoWEBPostSecci
                when 'DEM2060'{
                    String firstName = accountObjectMap.containsKey('FirstName') ? account.FirstName : '';
                    htmlBody = htmlBody.replace('{!Contact.FirstName}', firstName);                
                    htmlBody = htmlBody.replace('{!param8}', linkBozza);
                    subject = subject.replace('{!Contact.FirstName}', firstName);
                }
                //DEMAbbandonoForz
                when 'DEM2062'{
                    String firstName = accountObjectMap.containsKey('FirstName') ? account.FirstName : '';
                    htmlBody = htmlBody.replace('{!first_name}', firstName);
                    subject = subject.replace('{!first_name}', firstName);
                }
                // DEMAnomalieContratto_DS
                when 'DEM2069' {
                    String firstName = accountObjectMap.containsKey('FirstName') ? account.FirstName : '';
                    htmlBody = htmlBody.replace('[first_name]', firstName);             
                    htmlBody = htmlBody.replace('{!param8}', linkBozza);
                     String param7 = '';

                    if (caseObject.Anomalie_Doc__r != null) {
                       
                        String descrizioneMacroDoc = '';
                        for(Anomalie_Doc__c anomalie : anomalies){
                            if(anomalie.Descrizione_Anomalia_Cliente__c!=null){
                                descrizioneMacroDoc+=anomalie.descrizione_Macro_Doc__c;
                                param7+= '<p><ul><li>'+descrizioneMacroDoc+ ' : '+ anomalie.Descrizione_Anomalia_Cliente__c + '</li></ul></p>';
                            }                      
                        }
                       
                    } 
                     htmlBody = htmlBody.replace('{!param7}', param7);
                     subject = subject.replace('{!first_name}', firstName);
                }
                // DEMAnomalieDoc_DS
                when 'DEM2068' {
                    String firstName = accountObjectMap.containsKey('FirstName') ? account.FirstName : '';
                  //  if (personName != null) {
                        htmlBody = htmlBody.replace('{!first_name}', firstName);
                 //  }
                    htmlBody = htmlBody.replace('{!param8}', linkBozza);
                     String param7 = '';
                    if (anomalies.size() > 0) {
                       
                        String descrizioneMacroDoc = '';
                        for(Anomalie_Doc__c anomalie : anomalies){
                            if(anomalie.Descrizione_Anomalia_Cliente__c!=null){
                                descrizioneMacroDoc+=anomalie.descrizione_Macro_Doc__c;
                                param7+= '<p><ul><li>'+descrizioneMacroDoc+ ' : '+ anomalie.Descrizione_Anomalia_Cliente__c+ '</li></ul></p>';
                            }                        
                        }
                       
                    } 
                     htmlBody = htmlBody.replace('{!param7}', param7);
                    subject = subject.replace('{!first_name}', firstName);
                }
                // DEMRassicuraCliente_DS
                when 'DEM2725' {
                    subject = subject.replace('{!Contact.FirstName}', account.FirstName);
                    htmlBody = htmlBody.replace('{!Contact.FirstName}', account.FirstName);
                }
                // DEMAnomalieContratto_PP_CB
                when 'DEM2555' {
                    String firstName = accountObjectMap.containsKey('FirstName') ? account.FirstName : '';
                    String lastName = accountObjectMap.containsKey('LastName') ? account.LastName : '';
                    htmlBody = htmlBody.replace('[first_name]', firstName);
                    htmlBody = htmlBody.replace('[last_name]', lastName);
                    htmlBody = htmlBody.replace   ('{!param8}', linkBozza);
                        String param7 = '';
                    if (caseObject.Anomalie_Doc__r != null) {
                    
                        String descrizioneMacroDoc = '';
                        for(Anomalie_Doc__c anomalie : anomalies){
                            if(anomalie.Descrizione_Anomalia_Cliente__c!=null){
                                descrizioneMacroDoc+=anomalie.descrizione_Macro_Doc__c;
                                param7+= '<p><ul><li>'+descrizioneMacroDoc+ ' : '+ anomalie.Descrizione_Anomalia_Cliente__c + '</li></ul></p>';
                            }                    
                        }
                       
                    } 
                     htmlBody = htmlBody.replace('{!param7}', param7);
                }
                // Abbandono E-commerce
                when 'DEM2070' {
                    htmlBody = htmlBody.replace('{!first_name}', account.FirstName);
                    htmlBody = htmlBody.replace('{!last_name}', account.LastName);
                    //htmlBody = htmlBody.replace('{!param7}', caseNumber);
                    htmlBody = htmlBody.replace('{!param8}', linkBozza);
                    htmlBody = htmlBody.replace('{!param9}', numeroPratica);
                    
                }
                // DEMAnomalieDoc_PP_CB  
                when 'DEM2554' {
                    htmlBody = htmlBody.replace('{!first_name}', account.FirstName);
                    htmlBody = htmlBody.replace('{!last_name}', account.LastName);
                    htmlBody = htmlBody.replace('{!param8}', linkBozza);
                     String param7 = '';
                    if (caseObject.Anomalie_Doc__r != null) {
                       
                        String descrizioneMacroDoc = '';
                        for(Anomalie_Doc__c anomalie : anomalies){
                            if(anomalie.Descrizione_Anomalia_Cliente__c!=null){
                                descrizioneMacroDoc+=anomalie.descrizione_Macro_Doc__c;
                                param7+= '<p><ul><li>'+descrizioneMacroDoc+ ' : '+ anomalie.Descrizione_Anomalia_Cliente__c + '</li></ul></p>';
                            }                    
                        }
                       
                    } 
                     htmlBody = htmlBody.replace('{!param7}', param7);
                }
                // DEMRipresaBozzaEcommerce
                when 'DEM2071' {
                    htmlBody = htmlBody.replace('{!Contact.FirstName}', account.FirstName);
                    htmlBody = htmlBody.replace('{!Contact.LastName}', account.LastName);
                    htmlBody = htmlBody.replace('{!param8}', linkBozza);
                    htmlBody = htmlBody.replace('{!param9}', numeroPratica);
                }
                // Anomali Documentalie E-commerce
                when 'DEM2072' {
                    htmlBody = htmlBody.replace('{!first_name}', account.FirstName);
                    htmlBody = htmlBody.replace('{!last_name}', account.LastName);
                    htmlBody = htmlBody.replace('{!param8}', linkBozza);  
                    htmlBody = htmlBody.replace('{!param9}', numeroPratica);  
                    String param7 = '';
                    if (anomalies.size() > 0) {
                     
                        String descrizioneMacroDoc = '';
                        for(Anomalie_Doc__c anomalie : anomalies){
                            descrizioneMacroDoc+=anomalie.descrizione_Macro_Doc__c;
                            param7+= '<p><ul><li>'+descrizioneMacroDoc+ ' : '+ anomalie.Descrizione_Anomalia_Cliente__c + '</li></ul></p>';                            
                        }
                      
                    }
                      htmlBody = htmlBody.replace('{!param7}', param7);
                }           
                // DEMRipresaBozza_PP_CB
                when 'DEM2553' {
                    htmlBody = htmlBody.replace('{!param7}', caseNumber);
                    htmlBody = htmlBody.replace('{!param8}', linkBozza);
                    htmlBody = htmlBody.replace('{!first_name}', account.FirstName);
                    htmlBody = htmlBody.replace('{!last_name}', account.LastName);
                }
                //  Non trovato anomalie pre sic PP
                when 'DEM2064' {
                     String param7 = ' ';
                    if (anomalies.size() > 0) {
                       
                        String descrizioneMacroDoc = '';
                        for(Anomalie_Doc__c anomalie : anomalies){
                            //param7+= '<p>'+anomalie.codice_Anomalia__c+ ' '+ anomalie.Codice_Documento__c+ ' '+ anomalie.descrizione_Documento__c + '</p> ';
                            if (anomalie.Descrizione_Anomalia_Cliente__c != null) {
                                    descrizioneMacroDoc+=anomalie.descrizione_Macro_Doc__c;
                                    param7+= '<p><ul><li>'+descrizioneMacroDoc+ ' : '+ anomalie.Descrizione_Anomalia_Cliente__c + '</li></ul></p>'; 
                            }
                        }
                      
                    }  
                    htmlBody = htmlBody.replace('{!param7}', param7);                 
                    htmlBody = htmlBody.replace('{!param8}', linkBozza);
                    htmlBody = htmlBody.replace('{!Contact.FirstName}', account.FirstName);
                    subject = subject.replace('{!Contact.FirstName}', account.FirstName);
                }
                // Non trovato anomalie post sic PP
                when 'DEM2065' {
                    htmlBody = htmlBody.replace('{!param7}', caseNumber);
                    htmlBody = htmlBody.replace('{!param8}', linkBozza);
                    htmlBody = htmlBody.replace('{!Contact.FirstName}', account.FirstName);
                    subject = subject.replace('{!first_name}', account.FirstName);
                }
                //
                when 'DEM2566' {
                    htmlBody = htmlBody.replace('{!param8}', linkBozza);
                    htmlBody = htmlBody.replace('{!first_name}', account.FirstName);
                    htmlBody = htmlBody.replace('{!last_name}', account.LastName);
                }
                // DEM “Non trovato firma contratto PP” DEMNonTrovatoFirmaContratto_PP_MPS
                when 'DEM2565' {
                    htmlBody = htmlBody.replace('{!param8}', linkBozza);
                    htmlBody = htmlBody.replace('{!first_name}', account.FirstName);
                    htmlBody = htmlBody.replace('{!last_name}', account.LastName);
                }
                // DEM “Non trovato firma contratto PP” DEMNonTrovatoFirmaContratto_PP_CB
                when 'DEM2557' {
                    htmlBody = htmlBody.replace('{!param7}', caseNumber);
                    htmlBody = htmlBody.replace('{!param8}', linkBozza);
                    htmlBody = htmlBody.replace('{!first_name}', account.FirstName);
                    htmlBody = htmlBody.replace('{!last_name}', account.LastName);
                }
                // DEM “Non trovato anomalie PP Partners” 
                when 'DEM2556' {
                    htmlBody = htmlBody.replace('{!param7}', caseNumber);
                    htmlBody = htmlBody.replace('{!param8}', linkBozza);
                    htmlBody = htmlBody.replace('{!first_name}', account.FirstName);
                    htmlBody = htmlBody.replace('{!last_name}', account.LastName);
                }
                // DEM “Non trovato anomalie PP Partners” 
                when 'DEM2564' {
                    htmlBody = htmlBody.replace('{!param7}', caseNumber);
                    htmlBody = htmlBody.replace('{!param8}', linkBozza);
                    htmlBody = htmlBody.replace('{!first_name}', account.FirstName);
                    htmlBody = htmlBody.replace('{!last_name}', account.LastName);
                }
                // Numero inesistente firma contratto PP Partners
                when 'DEM2558' {
                    htmlBody = htmlBody.replace('{!param7}', caseNumber);
                    htmlBody = htmlBody.replace('{!param8}', linkBozza);
                    htmlBody = htmlBody.replace('{!first_name}', account.FirstName);
                    htmlBody = htmlBody.replace('{!last_name}', account.LastName);
                }
                // Cliente non trovato E-commerce
                when 'DEM2073' {
                    // '{!param_localita_fil}'
                    htmlBody = htmlBody.replace('{!param_localita_fil}', '');       
                    htmlBody = htmlBody.replace('{!param9}', numeroPratica);                    
                    htmlBody = htmlBody.replace('{!param8}', linkBozza);
                    htmlBody = htmlBody.replace('{!first_name}', account.FirstName);
                    htmlBody = htmlBody.replace('{!last_name}', account.LastName);
                }
                // DEMRipresaBozza_PP_MPS
                when 'DEM2061' {
                    htmlBody = htmlBody.replace('{!Contact.FirstName}', account.FirstName);
                    subject = subject.replace('{!Contact.FirstName}', account.FirstName);
                }
                // DEMRipresaBozza_DS
                when 'DEM2063' {  
                    htmlBody = htmlBody.replace('{!param7}', caseNumber);
                    htmlBody = htmlBody.replace('{!param8}', linkBozza);
                    subject = subject.replace('{!Contact.FirstName}', account.FirstName);
                    htmlBody = htmlBody.replace('{!Contact.FirstName}', account.FirstName);
                }
                when 'DEM2066' {
                    htmlBody = htmlBody.replace('{!param8}', linkBozza);
                    htmlBody = htmlBody.replace('{!first_name}', personName);
                    subject = subject.replace('{!first_name}', personName);
                }
                // DEMAbbandonoPostSecci
                when 'DEM2560' {
                    htmlBody = htmlBody.replace('{!param8}', linkBozza);
                    String firstName = accountObjectMap.containsKey('FirstName') ? account.FirstName : '';
                    String lastName = accountObjectMap.containsKey('LastName') ? account.LastName : '';
                    htmlBody = htmlBody.replace('{!first_name}', firstName);
                    htmlBody = htmlBody.replace('{!last_name}', lastName);
                }
                // DEMAbbandonoPreSecci
                when 'DEM2551' {
                    htmlBody = htmlBody.replace('{!param8}', linkBozza);
                    String firstName = accountObjectMap.containsKey('FirstName') ? account.FirstName : '';
                    String lastName = accountObjectMap.containsKey('LastName') ? account.LastName : '';
                    htmlBody = htmlBody.replace('{!first_name}', firstName);
                    htmlBody = htmlBody.replace('{!last_name}', lastName);
                }
                // DEMAbbandonoPreSecci
                when 'DEM2559' {
                    String firstName = accountObjectMap.containsKey('FirstName') ? account.FirstName : '';
                    String lastName = accountObjectMap.containsKey('LastName') ? account.LastName : '';
                    htmlBody = htmlBody.replace('{!first_name}', firstName);
                    htmlBody = htmlBody.replace('{!last_name}', lastName);
                }
                //DEMNumeroInesistenteContratto_DS
                when 'DEM2067' {
                     //String name = accountObjectMap.containsKey('Name') ? account.Name : '';
                     htmlBody = htmlBody.replace('{!Account.Name}', personName);
                     htmlBody = htmlBody.replace('[param8]', linkBozza);
                }
                // DEMRipresaBozza_PP_MPS
                when 'DEM2561' {
                     String firstName = accountObjectMap.containsKey('FirstName') ? account.FirstName : '';
                     htmlBody = htmlBody.replace('{!Contact.FirstName}', firstName);
                     htmlBody = htmlBody.replace('{!param8}', linkBozza);
                     htmlBody = htmlBody.replace('{!param7}', caseNumber);
                }
                //DEMAnomalieDoc_PP_MPS
                when'DEM2562' {
                    String firstName = accountObjectMap.containsKey('FirstName') ? account.FirstName : '';
                    String lastName = accountObjectMap.containsKey('LastName') ? account.LastName : '';
                    htmlBody = htmlBody.replace('[first_name]', firstName);
                    htmlBody = htmlBody.replace('[last_name]', lastName);
                    htmlBody = htmlBody.replace('[param8]', linkBozza);
                    htmlBody = htmlBody.replace('[param7]', caseNumber);
                }
                //DEMAnomalieContratto_PP_MPS
                when 'DEM2563'{
                    String firstName = accountObjectMap.containsKey('FirstName') ? account.FirstName : '';
                    String lastName = accountObjectMap.containsKey('LastName') ? account.LastName : '';
                    htmlBody = htmlBody.replace('[first_name]', firstName);
                    htmlBody = htmlBody.replace('[last_name]', lastName);
                    htmlBody = htmlBody.replace('[param8]', linkBozza);
                    htmlBody = htmlBody.replace('[param7]', caseNumber);

                }
                //DEMAnomalieDocEcommerce_MedC
                when 'DEM2477' {
                    String firstName = accountObjectMap.containsKey('FirstName') ? account.FirstName : '';
                    String lastName = accountObjectMap.containsKey('LastName') ? account.LastName : '';
                    htmlBody = htmlBody.replace('[first_name]', firstName);
                    htmlBody = htmlBody.replace('[last_name]', lastName);
                    htmlBody = htmlBody.replace('[param8]', linkBozza);
                    htmlBody = htmlBody.replace('[param7]', caseNumber);
                    htmlBody = htmlBody.replace('[param9]', numeroPratica);

                }
                //DEMAbbandonoEcommerce_MedC
                when 'DEM2475' {
                    String firstName = accountObjectMap.containsKey('FirstName') ? account.FirstName : '';
                    String lastName = accountObjectMap.containsKey('LastName') ? account.LastName : '';
                    htmlBody = htmlBody.replace('[first_name]', firstName);
                    htmlBody = htmlBody.replace('[last_name]', lastName);
                    htmlBody = htmlBody.replace('[param8]', linkBozza);
                     htmlBody = htmlBody.replace('[param9]', numeroPratica);

                }
                //DEMRipresaBozzaEcommerce_MedC
               when 'DEM2476'{
                    String firstName = accountObjectMap.containsKey('FirstName') ? account.FirstName : '';
                    String lastName = accountObjectMap.containsKey('LastName') ? account.LastName : '';
                    htmlBody = htmlBody.replace('[first_name]', firstName);
                    htmlBody = htmlBody.replace('[last_name]', lastName);
                    htmlBody = htmlBody.replace('[param8]', linkBozza);
                    htmlBody = htmlBody.replace('[param9]', numeroPratica);
                }
                //DEMClienteNonTrovatoEcommerce_MedC
                when 'DEM2478' {
                    String firstName = accountObjectMap.containsKey('FirstName') ? account.FirstName : '';
                    String lastName = accountObjectMap.containsKey('LastName') ? account.LastName : '';
                    htmlBody = htmlBody.replace('[first_name]', firstName);
                    htmlBody = htmlBody.replace('[last_name]', lastName);
                    htmlBody = htmlBody.replace('[param_localita_fil]', '');
                    htmlBody = htmlBody.replace('[param8]', linkBozza);
                    htmlBody = htmlBody.replace('[param9]', numeroPratica);

                }
                when else {}
            }

            System.debug('################ HMTL BODY MODIFICATO ##############');
            System.debug(htmlBody);
            mail.setSubject(subject);
            mail.setHtmlBody(htmlBody);
            allMsg.add(mail);
            List<Messaging.SendEmailResult> results = Messaging.sendEmail(allMsg);            
        } catch (Exception ex) {
            System.debug('#l sendTemplatedEmail error. ' + ex.getMessage());
        }
    }

    /**
     * @author ADIOP
     * @date 03/10/2019
     * @description send email dem
     * @param String developerName the name of the queue
     **/
    public static void sendEmailDem(String developerName, Id idCase, String state) {
        try {
            
            System.debug('******sendEmailDem*****START');
            System.debug('*****developerName-->'+developerName);
            System.debug('*****idCase-->'+idCase);
            System.debug('*****state-->'+state);
            Map<Id,Case> caseMap = new Map<Id,Case>();
            Case caseObject = [SELECT Id, OwnerId, RO_Vecchio_Cellulare__c, Tentativo__c, Product__r.DEMNonTrovatoFirmaContratto__c, Is_Discordanza_Cellulare__c,
                Product__r.DEMNonTrovatoAnomalie__c, Product__r.DEMNumeroInesistenteContratto__c, Product__r.DEMRipresaBozza__c,
                AccountId, Account.PersonMobilePhone, Product__c, Product__r.DEMNonTrovato__c FROM Case WHERE Id=:idCase];
            caseMap.put(idCase, caseObject);
            String nameDEM = 'Inviata mail : ';
            switch on developerName {
                // Discordanza cellulare E-commerce
                when 'Q337' {
                    mailDem('2071', idCase, 'Ripresa Bozza E-commerce', 'noreply@compass.it', 'noreply@compass.it');
                    nameDEM = nameDEM + ' DEMRipresaBozzaEcommerce (2071)';
                } 
                // Abbandono web and richiamami
                when 'Q330', 'Q331', 'Q332', 'Q333' {
                    mailDem(caseObject.Product__r.DEMRipresaBozza__c, idCase, '', CGMWSUtils_1_0.EMAIL_RICHIESTA, CGMWSUtils_1_0.EMAIL_RICHIESTA);
                    nameDEM = nameDEM + ' DEMRipresaBozza_DS (2063)';
                }
                // Abbandono PP Partners
                when 'Q375' {
                    //mailDem('2553', idCase, 'Prestito Online CheBanca!: segui l\'andamento del tuo finanziamento', 'noreplay@compass.it', 'PrestitoonlineCheBanca@compass.it');
                    mailDem(caseObject.Product__r.DEMRipresaBozza__c, idCase, '', CGMWSUtils_1_0.EMAIL_RICHIESTA, CGMWSUtils_1_0.EMAIL_RICHIESTA);
                    nameDEM = nameDEM + ' DEMRipresaBozza_PP_CB (2553)';
                } 
                // Anomalie Pre Sic PP
                when 'Q339' {
                    if (caseObject.Is_Discordanza_Cellulare__c) {
                        mailDem('2561', idCase, 'MPS prestito online: segui l\' andamento del tuo finanziamento', CGMWSUtils_1_0.EMAIL_RICHIESTA, CGMWSUtils_1_0.EMAIL_RICHIESTA);
                        nameDEM = nameDEM + ' DEMRipresaBozza_PP_MPS (2561)';
                    } else {
                        if (state == '109' || state == '119' || state == '102') {
                            mailDem('2064', idCase, '', CGMWSUtils_1_0.EMAIL_RICHIESTA, CGMWSUtils_1_0.EMAIL_RICHIESTA);
                            nameDEM = nameDEM + ' DEMNonTrovatoAnomaliePreSIC_DS (2064)';
                        } else if (state == '103') {
                            mailDem('2063', idCase, '{!first_name} segui la tua pratica di Prestito Online Compass', CGMWSUtils_1_0.EMAIL_RICHIESTA, CGMWSUtils_1_0.EMAIL_RICHIESTA);
                            nameDEM = nameDEM + ' DEMRipresaBozza_DS (2063)';
                        }
                        else {
                            mailDem('2561', idCase, 'MPS prestito online: segui l\' andamento del tuo finanziamento', CGMWSUtils_1_0.EMAIL_RICHIESTA, CGMWSUtils_1_0.EMAIL_RICHIESTA);
                            nameDEM = nameDEM + ' DEMRipresaBozza_PP_MPS (2561)';
                        }
                    }
                }
                // Anomalie Post Sic PP
                when 'Q340' {
                    if (state == '109' || state == '119') {
                        mailDem('2065', idCase, '{!first_name}, abbiamo ancora bisogno di te!', CGMWSUtils_1_0.EMAIL_RICHIESTA, 'Compass Banca S.P.A.');
                        nameDEM = nameDEM + ' DEMNonTrovatoAnomaliePostSIC_DS (2065)';
                    } else if (state == '103') {
                        mailDem('2063', idCase, '{!first_name} segui la tua pratica di Prestito Online Compass', CGMWSUtils_1_0.EMAIL_RICHIESTA, CGMWSUtils_1_0.EMAIL_RICHIESTA);
                        nameDEM = nameDEM + ' DEMRipresaBozza_DS (2063)';
                    } else {
                        mailDem('2553', idCase, 'Prestito Online CheBanca!: segui l\'andamento del tuo finanziamento', 'noreplay@compass.it', 'PrestitoonlineCheBanca@compass.it');
                        nameDEM = nameDEM + ' DEMRipresaBozza_PP_CB (2553)';
                    }
                }
                // Sollecito Contratto
                when 'Q377' {
                    if (state == '109') {
                        mailDem('2566', idCase, 'MPS prestito online: il tuo contratto è pronto per essere firmato!', CGMWSUtils_1_0.EMAIL_RICHIESTA, 'Compass Banca S.P.A.');
                        nameDEM = nameDEM + ' DEMNumeroInesistenteContratto_PP_MPS (2566)';
                    } else if (state == '119') {
                        mailDem(caseObject.Product__r.DEMNonTrovatoFirmaContratto__c, idCase, 'MPS prestito online: il tuo contratto è pronto per essere firmato!', 
                            CGMWSUtils_1_0.EMAIL_RICHIESTA, 'Compass Banca S.P.A.');
                        nameDEM = nameDEM + ' DEMNonTrovatoFirmaContratto ('+ caseObject.Product__r.DEMNonTrovatoFirmaContratto__c+')';
                    }
                }
                // Anomalie PP Partners
                when 'Q376' {
                    if (state == '103') {
                        mailDem('2553', idCase, 'Prestito Online CheBanca!: segui l\'andamento del tuo finanziamento ', 'noreplay@compass.it', 'PrestitoonlineCheBanca@compass.it');
                        nameDEM = nameDEM + ' DEMRipresaBozza_PP_CB (2553)';
                    } else if (state == '109' || state == '119') {
                        System.debug('#l caseObject.Product__r.DEMNonTrovatoAnomalie__c '+ caseObject.Product__r.DEMNonTrovatoAnomalie__c);
                        String dem = caseObject.Product__r.DEMNonTrovatoAnomalie__c;
                        if (dem == '2556') {
                            mailDem('2556', idCase, 'Prestito online CheBanca!:richiesta con anomalie', 'noreplay@compass.it', 'Compass Banca S.P.A.');
                            nameDEM = nameDEM + ' DEMNonTrovatoAnomalieDoc_PP_CB (2556)';
                        } else {
                            mailDem('2564', idCase, 'MPS prestito online:abbiamo bisogno ancora di te!', CGMWSUtils_1_0.EMAIL_RICHIESTA, 'Compass Banca S.P.A.');
                            nameDEM = nameDEM + ' DEMNonTrovatoAnomalieDoc_PP_MPS (2564)';
                        }
                    }
                }
                // Sollecito Contratto PP Parteners
                when 'Q341' {
                    System.debug('#l Product__r.DEMNumeroInesistenteContratto__c '+ caseObject.Product__r.DEMNumeroInesistenteContratto__c);
                    if (state == '119') {
                        // caseObject.Product__r.DEMNonTrovatoFirmaContratto__c
                        mailDem('2066', idCase, '{!first_name}, firma il tuo contratto di Prestito Online Compass!', 
                            CGMWSUtils_1_0.EMAIL_RICHIESTA, 'Compass Banca S.P.A.');
                        nameDEM = nameDEM + ' DEMNonTrovatoFirmaContratto_DS (2066)';
                    } else if (state == '109') {
                        mailDem(caseObject.Product__r.DEMNumeroInesistenteContratto__c, idCase, 'Prestito Online CheBanca!:firma il contratto', CGMWSUtils_1_0.EMAIL_RICHIESTA, 'Compass Banca S.P.A.');
                        nameDEM = nameDEM + ' DEMNumeroInesistenteContratto_PP_CB '+caseObject.Product__r.DEMNumeroInesistenteContratto__c;
                    } else if (state == '103') {
                        //noreplay@compass.it
                        //DEMRipresaBozzaCodice
                        mailDem(caseObject.Product__r.DEMRipresaBozza__c, idCase, 'Prestito Online CheBanca!: segui l\'andamento del tuo finanziamento ', 'noreplay@compass.it', 'PrestitoonlineCheBanca@compass.it');
                        nameDEM = nameDEM + ' DEMRipresaBozza_PP_CB '+caseObject.Product__r.DEMRipresaBozza__c;
                    }
                }
                // Abbandono E-commerce
                when 'Q336' {
                    if (state == '103') {
                        mailDem('2071', idCase, 'Ripresa Bozza E-commerce', 'noreply@compass.it', 'noreply@compass.it');
                        nameDEM = nameDEM + ' DEMRipresaBozzaEcommerce (2071)';
                    } else  {
                        CGMWSUtils_1_0.sendNotifications(caseMap.values(), 'DEMNonTrovato__c', null, CGMWSUtils_1_0.EMAIL_NO_REPLY, CGMWSUtils_1_0.EMAIL_LABEL_COMPASS);
                        nameDEM = nameDEM + ' DEMClienteNonTrovatoEcommerce (2073)';
                    }
                }
                // Anomali Documentalie E-commerce
                when 'Q338' {
                    mailDem('2072', idCase, 'Anomalie Doc. E-commerce', CGMWSUtils_1_0.EMAIL_RICHIESTA, CGMWSUtils_1_0.EMAIL_RICHIESTA);
                }
                // Nessuna Coda
                when 'Q525' {
                    // state 103
                    mailDem(caseObject.Product__r.DEMRipresaBozza__c, idCase, '{!first_name} segui la tua pratica di Prestito Online Compass', CGMWSUtils_1_0.EMAIL_RICHIESTA, CGMWSUtils_1_0.EMAIL_RICHIESTA);
                    nameDEM = nameDEM + ' DEMRipresaBozza__c ('+ caseObject.Product__r.DEMRipresaBozza__c+')';
                }
                when else {}
            }
            System.debug('#l nameDem '+ nameDEM);
            createNote(nameDEM, caseObject);
        } catch (Exception e) {
            System.debug('#l message '+ e.getCause() + ' '+ e.getMessage());
        }
    }

   
    public static String getCronExp(Integer numeroMinutiDiAttesa){        
        //Datetime dateExecution = System.now().addHours(numeroDiOreLavoro);
        Datetime dateExecution = System.now().addMinutes(numeroMinutiDiAttesa); 
        String cronExp = dateExecution.second() + ' '+ dateExecution.minute() + ' '+ dateExecution.hour() +' '+ dateExecution.day()+ ' '+ dateExecution.month()+ ' ? '+dateExecution.year();
        System.debug('cronExp-->'+cronExp);
        return cronExp;
    }

    /**
     * @author ADIOP
     * @date 12/10/2019
     * @description 
     * @param id
     * @param String developerName
     **/
    public static void  ricicliEsiti(Case c, String developerName){
        try {
            XCS_CompassParameters__c rlt = [SELECT Fea__c, NumeroRicicli__c FROM XCS_CompassParameters__c WHERE Name =:developerName];
            System.debug('#l ### rlt ### '+ JSON.serialize(rlt));
            System.debug('££££££Case-->'+c);
            if (rlt != null) {
                //numero minuti al prossimo riciclo
                Integer fea =  Integer.valueOf(rlt.Fea__c); 
                //nessuna schedulazione se viene superato il numero di riciclo
                if(c.RO_Tentativo_Ricicli__c >= rlt.NumeroRicicli__c){
                    c.RO_Tentativo_Ricicli__c = 0; //azzero il numero di ricicli se superato il limite
                    return;
                }  

                String cronExp =  getCronExp(fea);
                Set<Id> ids = new Set<Id> {c.Id};
                RicicliPerEsitiSchedulable rPES = new RicicliPerEsitiSchedulable(ids, developerName, Integer.valueOf(rlt.NumeroRicicli__c), 7); //Integer.valueOf(rlt.NumeroRicicli__c), fea
                String jobName = 'riciclo-' + c.Id + '-' + cronExp;
                System.debug('jobName-->'+jobName);
                String jobId = System.schedule(jobName , cronExp, rPES);
                System.debug('#l jobId '+ jobId);
            }
        } catch (Exception e) {
            System.debug('#l message '+ e.getCause() +' '+ e.getMessage()+ ' '+ e.getLineNumber());
        }
    }

    /**
     * @author SANA BADJI
     * @date 09/11/2019
     * @description 
     * @param String title
     * @param String body
     * @param String idcase
     **/
    public static FeedItem  createFeeditem(String title, String body, Id idCase){
        FeedItem feeditem = new FeedItem();
        feeditem.ParentId = idCase;
        feeditem.Body =body;
        feeditem.Title =title;
        try {
            insert feeditem;
            System.debug('FeedItem Created Successfully '+feeditem);
            ContentDocumentLink clnk = new ContentDocumentLink();
            clnk.ContentDocumentId = feeditem.Id;
            System.debug('ContentDocumentLink Created Successfully '+clnk);
        } catch (Exception e) {
             System.debug('error insert FeedItem '+e.getMessage()+' '+e.getStackTraceString()+' '+e.getLineNumber());
        }
        return feeditem;         
    }

    /***************************************************
     * @author Madicke BALDE
     * @description
     * @param  nameDEM
     * @param Case 
    ****************************************************/
    public static void createNote(String nameDEM,  Case c){
        System.debug('###################### createNote test 11 ');
        String email = 'nessuna email';
        String anomaliesCase='' ;
        String linkBozza = '';
        System.debug('########### case test'+c);
        Map<String, Object> caseMap = (Map<String, Object>) JSON.deserializeUntyped(JSON.serialize(c));
        System.debug('########### case test'+caseMap);
        if(caseMap.keySet().contains('Account')){
            System.debug('################## accoutMap tes '+caseMap.get('Account'));
            // Account acc = (Account) caseMap.get('Account');
            Map<String, Object> accountMap = (Map<String, Object>) JSON.deserializeUntyped(JSON.serialize(caseMap.get('Account')));
            if(accountMap.keySet().contains('PersonEmail')){
                email = (String) accountMap.get('PersonEmail');
            }
        }
        if(caseMap.keySet().contains('RO_Link_Bozza__c') ){
           linkBozza = (String) caseMap.get('RO_Link_Bozza__c');
           System.debug('############## isLinkBozza');
        }
        Case caseObject = [SELECT Id,(SELECT Id, codice_Anomalia__c , Codice_Documento__c, descrizione_Documento__c FROM Anomalie_Doc__r),Is_Discordanza_Cellulare__c FROM Case WHERE Id=:c.Id];
        if(caseObject.Anomalie_Doc__r.size() > 0 ){
            for(Anomalie_Doc__c anomalie :  caseObject.Anomalie_Doc__r){
                String codeAnomalie = (String.isNotEmpty(anomalie.codice_Anomalia__c))?anomalie.codice_Anomalia__c:'';
                String codiceDocumenti = (String.isNotEmpty(anomalie.Codice_Documento__c))?anomalie.Codice_Documento__c:'';
                String descrizione = (String.isNotEmpty(anomalie.descrizione_Documento__c))?anomalie.descrizione_Documento__c:'';
                anomaliesCase +=codeAnomalie+' '+codiceDocumenti+' '+descrizione;
            }
        }
        /*  
        System.debug('#################### caseMap.keySet().contains(Anomalie_Doc__r)'+caseMap.keySet().contains('Anomalie_Doc__r'));
        if(caseMap.keySet().contains('Anomalie_Doc__r')){
            List<Anomalie_Doc__c> anomalies = (List<Anomalie_Doc__c>) caseMap.get('Anomalie_Doc__r');
            for(Anomalie_Doc__c anomalie : anomalies){
                anomaliesCase +=' '+ anomalie.descrizione_Documento__c;
            }
        } 
        */
        //  anomaliesCase = (String.isEmpty(anomaliesCase))?'nessuna Anomalie':anomaliesCase;
        System.debug('######## create Anomalie '+anomaliesCase);
        System.debug('################## email '+email);
        System.debug('################## link '+linkBozza);
        System.debug('################## anomaliesCase '+linkBozza);
        String tlink = (String.isNotEmpty(linkBozza))?'LINK Bozza:'+linkBozza:'';
        String an= (String.isNotBlank(anomaliesCase))?'Anomalie DOC:'+anomaliesCase:'';
        System.debug('################# annnnnnnn'+an);
        String body = 'a:'+email+'\n'+  ' '+tlink+'\n'+ ' '+an;
        System.debug('############## body '+body);
        FeedItem f = createFeeditem(nameDEM,body,c.Id);
        System.debug('################### f '+f);
        System.debug('################### finish ');
    }

    public static void createNtote(String nameDEM, Case c, String reasonNote){

        System.debug('############# createNtote createNote test');
        String email = 'nessuna email';
        String anomaliesCase='' ;
        String body;
        String linkBozza = 'nessuna email';
        Map<String, Object> caseMap = (Map<String, Object>) JSON.deserializeUntyped(JSON.serialize(c));
        if(caseMap.keySet().contains('Account')){
            System.debug('################## accoutMap tes '+caseMap.get('Account'));
            Map<String, Object> accountMap = (Map<String, Object>) JSON.deserializeUntyped(JSON.serialize(caseMap.get('Account')));
            if(accountMap.keySet().contains('PersonEmail')){
                email = (String) accountMap.get('PersonEmail');
            }
        }
        if(caseMap.keySet().contains('RO_Link_Bozza__c') ){
            linkBozza = (String) caseMap.get('RO_Link_Bozza__c');
        }

        /*     
        if(caseMap.keySet().contains('Anomalie_Doc__r')){
        List<Anomalie_Doc__c> anomalies = (List<Anomalie_Doc__c>) caseMap.get('Anomalie_Doc__r');
        for(Anomalie_Doc__c anomalie : anomalies){
            anomaliesCase +=' '+anomalie.codice_Anomalia__c+'-'+anomalie.Codice_Documento__c+'-'+anomalie.descrizione_Documento__c;
        }
        }*/
        // anomaliesCase = (String.isEmpty(anomaliesCase))?'nessuna Anomalie':anomaliesCase;
        // System.debug('######## create Anomalie '+anomaliesCase);
        switch on reasonNote {
            when 'DEM' {
                if(caseMap.keySet().contains('Anomalie_Doc__r')){
                    List<Anomalie_Doc__c> anomalies = (List<Anomalie_Doc__c>) caseMap.get('Anomalie_Doc__r');
                    for(Anomalie_Doc__c anomalie : anomalies){
                            anomaliesCase +=' '+anomalie.codice_Anomalia__c+'-'+anomalie.Codice_Documento__c+'-'+anomalie.descrizione_Documento__c;
                    }
                }
                anomaliesCase = (String.isEmpty(anomaliesCase))?'nessuna Anomalie':anomaliesCase;
                System.debug('############# DEM createNote');
                body = 'a:'+email+'\n'+
                'Link Bozza :'+linkBozza+'\n'+
                'Anomalie DOC:'+anomaliesCase;
            }
            when 'Anomalie' {
                Case caseObject = [SELECT Id,(SELECT Id, codice_Anomalia__c , Codice_Documento__c, descrizione_Documento__c FROM Anomalie_Doc__r),Is_Discordanza_Cellulare__c FROM Case WHERE Id=:c.Id];
                if(caseObject.Anomalie_Doc__r.size() > 0 ){
                    for(Anomalie_Doc__c anomalie :  caseObject.Anomalie_Doc__r){
                        anomaliesCase +=' '+anomalie.codice_Anomalia__c+'-'+anomalie.Codice_Documento__c+'-'+anomalie.descrizione_Documento__c;
                    }
                }
                
                /* if(caseMap.keySet().contains('Anomalie_Doc__r')){
                    Map<String, Object> mapAnomalies =   (Map<String, Object>) JSON.deserializeUntyped(JSON.serialize(caseMap.get('Anomalie_Doc__r')));
                //    List<Anomalie_Doc__c> anomalies = (List<Anomalie_Doc__c>) mapAnomalies.get('records');
                        
                    System.debug('######## test trigger '+mapAnomalies.get('records'));
                    List<Anomalie_Doc__c>  tx =  (List<Anomalie_Doc__c>)  mapAnomalies.get('records');
                    System.debug('########## wwwww '+tx);
                }*/
                anomaliesCase = (String.isEmpty(anomaliesCase))?'nessuna Anomalie':anomaliesCase;
                System.debug('############# Anomalie createNote');
                body = 'Anomalie documentali riscontrate:\n'+ anomaliesCase;
            }
            when else {
                System.debug('############# else note');
            }
        }
        createFeeditem(nameDEM,body,c.Id);
    }

    /**
     * @author ADIOP
     * @date 06/12/2019
     * @description send SMS
     * @param 
     **/
    public static void sendSMS(String contactMobile, String nameSms){
        try {
            XCS_Template__c template = [SELECT Name, Body__c FROM XCS_Template__c WHERE Name= :nameSms LIMIT 1];
            OCSInviaSMSInvoker.inviaSMS('', contactMobile,'','', template.Body__c);
        } catch (Exception e) {
            System.debug('#l sendSms '+ e.getCause() + ' '+ e.getLineNumber() + ' '+ e.getStackTraceString());
        }
    }
}