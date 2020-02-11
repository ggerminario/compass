public class OCSCensimentoCollegatiInvoker {

   public static OCSCensimentoCollegatiResponse callCensimentoCollegati (String dealerId) {   
        List<OCSCensimentoCollegatiRequest.ELenco> elenco=processaDati(dealerId);
        OCSCensimentoCollegatiRequest req = new OCSCensimentoCollegatiRequest();
        req.censimentoCollegatiRequest.elenco = elenco;  
        OCSCensimentoCollegatiResponse response = (OCSCensimentoCollegatiResponse) ApiUtils.callApi('ocs.censimentoCollegati', req, OCSCensimentoCollegatiResponse.class);
        system.debug('Response: ' + response);
        return response;
    }
    public static wrapResponse callCensimentoCollegatiConv (String dealerId){
          
        wrapResponseProcess elenco=processaDatiWrapResponse(dealerId);
        OCSCensimentoCollegatiRequest req = new OCSCensimentoCollegatiRequest();
        req.censimentoCollegatiRequest.elenco = elenco.response;  
        OCSCensimentoCollegatiResponse response = (OCSCensimentoCollegatiResponse) ApiUtils.callApi('ocs.censimentoCollegati', req, OCSCensimentoCollegatiResponse.class);
        system.debug('Response: ' + response);
        wrapResponse res = new wrapResponse();
        res.response = response;
        res.listContactRelation = elenco.listContactRelation;
        return res;
    }
    
    /*public static DatiOCS processaResponse (OCSCensimentoCollegatiResponse response, List<Contact> collegatiList) {   
        DatiOCS datiOCS = new DatiOCS();
        datiOCS.chiamataOK=true;
        Map<Id, Contact> collegatiMap= new Map<Id, Contact>();
        for(Contact co:collegatiList){
            collegatiMap.put(co.Id,co);
        }
        for(OCSCensimentoCollegatiResponse.ELenco resElenco:response.censimentoCollegatiResponse.elenco){
                if(resElenco.segnala!='Anagrafica inserita CONTROLLARE MESSAGGIO!!!!!!!!!!!!'){   //risposta andata a buon fine
                   datiOCS.chiamataOK=false;
                   datiOCS.message.add('-Collegato "'+collegatiMap.get(resElenco.icoCollegato).LastName +' '+ collegatiMap.get(resElenco.icoCollegato).FirstName+ '": ' +resElenco.segnala);   
                }
                
         }
		return datiOCS; 
    }*/
    
    /*public static List<String> processaResponse (OCSCensimentoCollegatiResponse response, List<Contact> collegatiList) {   
        List<String> message = new List<String>();
        Map<Id, Contact> collegatiMap= new Map<Id, Contact>();
        for(Contact co:collegatiList){
            collegatiMap.put(co.Id,co);
        }
        for(OCSCensimentoCollegatiResponse.ELenco resElenco:response.censimentoCollegatiResponse.elenco){
            message.add('-Collegato "'+collegatiMap.get(resElenco.icoCollegato).LastName +' '+ collegatiMap.get(resElenco.icoCollegato).FirstName+ '": ' +resElenco.segnala);        
        }
		return message; 
    }*/   
    
    
    public static List<String> processaResponse (OCSCensimentoCollegatiResponse response, String dealerId) {   
        List<String> message = new List<String>();
        List<Contact> collegatiList=SFAConvenzionamento.getCollegati(dealerId);
        Map<Id, Contact> collegatiMap= new Map<Id, Contact>();
        for(Contact co:collegatiList){
            collegatiMap.put(co.Id,co);
        }
        for(OCSCensimentoCollegatiResponse.ELenco resElenco:response.censimentoCollegatiResponse.elenco){
            message.add('-Collegato "'+collegatiMap.get(resElenco.icoCollegato).LastName +' '+ collegatiMap.get(resElenco.icoCollegato).FirstName+ '": ' +resElenco.segnala);        
        }
		return message; 
    }    
    
    
    public static List<OCSCensimentoCollegatiRequest.Elenco> processaDatiCorrect(String dealerId){
        List<OCSCensimentoCollegatiRequest.ELenco> elenco = new List<OCSCensimentoCollegatiRequest.ELenco>();  
        Map<String,Trascodifica_ruoli_collegati__mdt> trascodificaRuoliMap = new Map<String,Trascodifica_ruoli_collegati__mdt>();       
        List<SFAConvenzionamento.CollegatoERuoloObject> collegatoERuoliList=new List<SFAConvenzionamento.CollegatoERuoloObject>();
        Set<String> ruoli = new Set<String>();
        
        SFAConvenzionamento.CollegatiERuoli collegatiERuoli= SFAConvenzionamento.getCollegatiNonCancellatiERuoliPerOCS(dealerId);
        collegatoERuoliList=collegatiERuoli.collegati;
        ruoli=collegatiERuoli.ruoli;
        System.debug('collegatoERuoliList:: '+collegatoERuoliList);
        System.debug('ruoli:: '+ruoli);        
        
		List<Trascodifica_ruoli_collegati__mdt>  trascodificaRuoliList =[SELECT Id, DeveloperName, IcoFirmatario__c, IcoRappresentante__c, IcoReferente__c, 
                                                    IcoSocio__c, IcoTitolare__c 
                                                    FROM Trascodifica_ruoli_collegati__mdt WHERE  DeveloperName IN: ruoli];
        
        System.debug('trascodificaRuoliList:: '+trascodificaRuoliList);
        
        if(trascodificaRuoliList.size()>0){
                    
            for(Trascodifica_ruoli_collegati__mdt tr:trascodificaRuoliList){
                trascodificaRuoliMap.put(tr.DeveloperName,tr);
            }
            System.debug('trascodificaRuoliMap:: '+trascodificaRuoliMap);
            
            Account dealer=[SELECT id, OCS_External_Id__c  
                            FROM Account WHERE id=:dealerId][0];        
            System.debug('***collegatoERuoliList: '+collegatoERuoliList);
            for(SFAConvenzionamento.CollegatoERuoloObject co_ruolo:collegatoERuoliList){   //co_ruolo.contactCollegato---> collegato     co_ruolo.Ruolo---> ruolo    co_ruolo-roles ---> lista ruoli        
                OCSCensimentoCollegatiRequest.ELenco elencoCollegato = new OCSCensimentoCollegatiRequest.ELenco();
                Trascodifica_ruoli_collegati__mdt trascodificaRuolo = new Trascodifica_ruoli_collegati__mdt();
                trascodificaRuolo=trascodificaRuoliMap.get(co_ruolo.Ruolo);
                System.debug('CICLO co_ruolo.Ruolo:: '+co_ruolo.Ruolo);
                System.debug('CICLO trascodificaRuolo:: '+trascodificaRuolo);
                System.debug('CICLO trascodificaRuoliMap.get(co_ruolo.Ruolo):: '+trascodificaRuoliMap.get(co_ruolo.Ruolo));
                elencoCollegato.icoCodice=dealer.OCS_External_Id__c.Substring(1);
                elencoCollegato.icoCollegato=co_ruolo.contactCollegato.OCS_External_Id__c;
                elencoCollegato.icoFirmatario=trascodificaRuolo.IcoFirmatario__c;          
                elencoCollegato.icoRappresentante=trascodificaRuolo.IcoRappresentante__c;
                elencoCollegato.icoReferente=trascodificaRuolo.IcoReferente__c;
                elencoCollegato.icoSocio=trascodificaRuolo.IcoSocio__c;
                elencoCollegato.icoTitolare=trascodificaRuolo.IcoTitolare__c;
                elencoCollegato.icoResponsabileIsvap='N';
                elencoCollegato.icoDataIscrizIsvap='0';	
                elencoCollegato.icoDataApertura='00000000';
                elencoCollegato.icoDataChiusura='00000000';		           
                elenco.add(elencoCollegato);            
            }
        }
        return elenco;
    }
    
    public static List<OCSCensimentoCollegatiRequest.Elenco> processaDati (String dealerId) {
		List<OCSCensimentoCollegatiRequest.ELenco> elenco = new List<OCSCensimentoCollegatiRequest.ELenco>();  
        Map<String,Trascodifica_ruoli_collegati__mdt> trascodificaRuoliMap = new Map<String,Trascodifica_ruoli_collegati__mdt>();       
        List<SFAConvenzionamento.CollegatoERuoloObject> collegatoERuoliList=new List<SFAConvenzionamento.CollegatoERuoloObject>();
        Set<String> ruoli = new Set<String>();  
        SFAConvenzionamento.CollegatiERuoli collegatiERuoli = SFAConvenzionamento.getCollegatiNonCancellatiERuoliPerOCS(dealerId);
        collegatoERuoliList=collegatiERuoli.collegati;
        ruoli=collegatiERuoli.ruoli;
        System.debug('collegatoERuoliList:: '+collegatoERuoliList);
        System.debug('ruoli:: '+ruoli);        
        
		List<Trascodifica_ruoli_collegati__mdt>  trascodificaRuoliList =[SELECT Id, DeveloperName, IcoFirmatario__c, IcoRappresentante__c, IcoReferente__c, 
                                                    IcoSocio__c, IcoTitolare__c 
                                                    FROM Trascodifica_ruoli_collegati__mdt WHERE  DeveloperName IN: ruoli];
        
        System.debug('trascodificaRuoliList:: '+trascodificaRuoliList);
        
        if(trascodificaRuoliList.size()>0){
                    
            for(Trascodifica_ruoli_collegati__mdt tr:trascodificaRuoliList){
                trascodificaRuoliMap.put(tr.DeveloperName,tr);
            }
            System.debug('trascodificaRuoliMap:: '+trascodificaRuoliMap);
            
            Account dealer=[SELECT id, OCS_External_Id__c  
                            FROM Account WHERE id=:dealerId][0];        
            System.debug('***collegatoERuoliList: '+collegatoERuoliList);
            for(SFAConvenzionamento.CollegatoERuoloObject co_ruolo:collegatoERuoliList){   //co_ruolo.contactCollegato---> collegato     co_ruolo.Ruolo---> ruolo            
                //Trascodifica_ruoli_collegati__mdt trascodificaRuolo = new Trascodifica_ruoli_collegati__mdt();
                //trascodificaRuolo=trascodificaRuoliMap.get(co_ruolo.Ruolo);
                OCSCensimentoCollegatiRequest.ELenco elencoCollegato = new OCSCensimentoCollegatiRequest.ELenco();
                System.debug('CICLO co_ruolo.Ruolo:: '+co_ruolo.Ruolo);
               // System.debug('CICLO trascodificaRuolo:: '+trascodificaRuolo);
                System.debug('CICLO trascodificaRuoliMap.get(co_ruolo.Ruolo):: '+trascodificaRuoliMap.get(co_ruolo.Ruolo));
                elencoCollegato.icoCodice=dealer.OCS_External_Id__c.Substring(1);
                elencoCollegato.icoCollegato=co_ruolo.contactCollegato.OCS_External_Id__c;
                elencoCollegato.icoFirmatario='N';          
                elencoCollegato.icoRappresentante='N';
                elencoCollegato.icoReferente='N';
                elencoCollegato.icoSocio='N';
                elencoCollegato.icoTitolare='N';
                elencoCollegato.icoResponsabileIsvap='N';
                elencoCollegato.icoDataIscrizIsvap='0';	
                elencoCollegato.icoDataApertura='00000000';
                elencoCollegato.icoDataChiusura='00000000';		           
                for(String rol : co_ruolo.roles)
                {
                 	if(trascodificaRuoliMap.get(rol) != null)
                    {
                    	Trascodifica_ruoli_collegati__mdt trascodificaRuolo = trascodificaRuoliMap.get(rol);	 
                        elencoCollegato.icoFirmatario = ('S'.EqualsIgnoreCase(trascodificaRuolo.IcoFirmatario__c) || 'S'.EqualsIgnoreCase(elencoCollegato.icoFirmatario)) ? 'S' : 'N';          
                        elencoCollegato.icoRappresentante= ('S'.EqualsIgnoreCase(trascodificaRuolo.IcoRappresentante__c) || 'S'.EqualsIgnoreCase(elencoCollegato.icoRappresentante)) ? 'S' : 'N';
                        elencoCollegato.icoReferente= ('S'.EqualsIgnoreCase(trascodificaRuolo.IcoReferente__c) || 'S'.EqualsIgnoreCase(elencoCollegato.icoReferente)) ? 'S' : 'N';
                        elencoCollegato.icoSocio=('S'.EqualsIgnoreCase(trascodificaRuolo.IcoSocio__c) || 'S'.EqualsIgnoreCase(elencoCollegato.icoSocio)) ? 'S' : 'N';
                        elencoCollegato.icoTitolare=('S'.EqualsIgnoreCase(trascodificaRuolo.IcoTitolare__c) || 'S'.EqualsIgnoreCase(elencoCollegato.icoTitolare)) ? 'S' : 'N';         
                    }  
                }  
                elenco.add(elencoCollegato);            
            }
        }
        return elenco;
    }
    
    
    //CLASSE CORRETTA::
    public static wrapResponseProcess processaDatiWrapResponse (String dealerId) {
		List<OCSCensimentoCollegatiRequest.ELenco> elenco = new List<OCSCensimentoCollegatiRequest.ELenco>();  
        Map<String,Trascodifica_ruoli_collegati__mdt> trascodificaRuoliMap = new Map<String,Trascodifica_ruoli_collegati__mdt>();       
        List<SFAConvenzionamento.CollegatoERuoloObject> collegatoERuoliList=new List<SFAConvenzionamento.CollegatoERuoloObject>();
        Set<String> ruoli = new Set<String>();
        SFAConvenzionamento.wrapResponse res = SFAConvenzionamento.getCollegatiNonCancellatiERuoliPerOCSWithWrap(dealerId);
        wrapResponseProcess resReturn = new wrapResponseProcess();
        resReturn.listContactRelation = res.accountContactList;
        SFAConvenzionamento.CollegatiERuoli collegatiERuoli = res.collRole;
        collegatoERuoliList=collegatiERuoli.collegati;
        ruoli=collegatiERuoli.ruoli;
        System.debug('collegatoERuoliList:: '+collegatoERuoliList);
        System.debug('ruoli:: '+ruoli);        
        
		List<Trascodifica_ruoli_collegati__mdt>  trascodificaRuoliList =[SELECT Id, DeveloperName, IcoFirmatario__c, IcoRappresentante__c, IcoReferente__c, 
                                                    IcoSocio__c, IcoTitolare__c 
                                                    FROM Trascodifica_ruoli_collegati__mdt WHERE  DeveloperName IN: ruoli];
        
        System.debug('trascodificaRuoliList:: '+trascodificaRuoliList);
        
        if(trascodificaRuoliList.size()>0){
                    
            for(Trascodifica_ruoli_collegati__mdt tr:trascodificaRuoliList){
                trascodificaRuoliMap.put(tr.DeveloperName,tr);
            }
            System.debug('trascodificaRuoliMap:: '+trascodificaRuoliMap);
            
            Account dealer=[SELECT id, OCS_External_Id__c  
                            FROM Account WHERE id=:dealerId][0];        
            System.debug('***collegatoERuoliList: '+collegatoERuoliList);
            for(SFAConvenzionamento.CollegatoERuoloObject co_ruolo:collegatoERuoliList){   //co_ruolo.contactCollegato---> collegato     co_ruolo.Ruolo---> ruolo            
                //Trascodifica_ruoli_collegati__mdt trascodificaRuolo = new Trascodifica_ruoli_collegati__mdt();
                //trascodificaRuolo=trascodificaRuoliMap.get(co_ruolo.Ruolo);
                OCSCensimentoCollegatiRequest.ELenco elencoCollegato = new OCSCensimentoCollegatiRequest.ELenco();
                System.debug('CICLO co_ruolo.Ruolo:: '+co_ruolo.Ruolo);
               // System.debug('CICLO trascodificaRuolo:: '+trascodificaRuolo);
                System.debug('CICLO trascodificaRuoliMap.get(co_ruolo.Ruolo):: '+trascodificaRuoliMap.get(co_ruolo.Ruolo));
                elencoCollegato.icoCodice=dealer.OCS_External_Id__c.Substring(1);
                elencoCollegato.icoCollegato=co_ruolo.contactCollegato.OCS_External_Id__c;
                elencoCollegato.icoFirmatario='N';          
                elencoCollegato.icoRappresentante='N';
                elencoCollegato.icoReferente='N';
                elencoCollegato.icoSocio='N';
                elencoCollegato.icoTitolare='N';
                elencoCollegato.icoResponsabileIsvap='N';
                elencoCollegato.icoDataIscrizIsvap='0';	
                elencoCollegato.icoDataApertura='00000000';
                elencoCollegato.icoDataChiusura='00000000';		           
                for(String rol : co_ruolo.roles)
                {
                 	if(trascodificaRuoliMap.get(rol) != null)
                    {
                    	Trascodifica_ruoli_collegati__mdt trascodificaRuolo = trascodificaRuoliMap.get(rol);	 
                        elencoCollegato.icoFirmatario = ('S'.EqualsIgnoreCase(trascodificaRuolo.IcoFirmatario__c) || 'S'.EqualsIgnoreCase(elencoCollegato.icoFirmatario)) ? 'S' : 'N';          
                        elencoCollegato.icoRappresentante= ('S'.EqualsIgnoreCase(trascodificaRuolo.IcoRappresentante__c) || 'S'.EqualsIgnoreCase(elencoCollegato.icoRappresentante)) ? 'S' : 'N';
                        elencoCollegato.icoReferente= ('S'.EqualsIgnoreCase(trascodificaRuolo.IcoReferente__c) || 'S'.EqualsIgnoreCase(elencoCollegato.icoReferente)) ? 'S' : 'N';
                        elencoCollegato.icoSocio=('S'.EqualsIgnoreCase(trascodificaRuolo.IcoSocio__c) || 'S'.EqualsIgnoreCase(elencoCollegato.icoSocio)) ? 'S' : 'N';
                        elencoCollegato.icoTitolare=('S'.EqualsIgnoreCase(trascodificaRuolo.IcoTitolare__c) || 'S'.EqualsIgnoreCase(elencoCollegato.icoTitolare)) ? 'S' : 'N';         
                    }  
                }  
                elenco.add(elencoCollegato);            
            }
        }
        resReturn.response = elenco;
        return resReturn;
    }

    public class wrapResponse
    {
        @AuraEnabled
        public OCSCensimentoCollegatiResponse response {get;set;}
        @AuraEnabled
        public List<AccountContactRelation> listContactRelation {get;set;}
    }
    public class wrapResponseProcess
    {
        @AuraEnabled
        public List<OCSCensimentoCollegatiRequest.ELenco> response {get;set;}
        @AuraEnabled
        public List<AccountContactRelation> listContactRelation {get;set;}
    }
}