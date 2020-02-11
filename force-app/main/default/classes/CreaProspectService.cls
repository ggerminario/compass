/*******************************************************************************
*@Author Madicke BALDE
*@description class service for CreaProspect
*@version 1.0
*@uses
*@code
 ***************************************************************/
public  class CreaProspectService {

  public static  Map<String, Object> returnValueMap = new Map<String, Object>();
    /****** *******************************************************************************
    *@Auhtor Madicke BALDE  
    *@description 
    *@param Case : c
    *@param Account acc
    *@param Products
     ****************************************************************************************/
    public static void gestatoRequestOnline(Case c, Account acc, Product2 p, String idCRM){
      System.debug('############ subject'+c.Subject);
        Case cp = new Case();
        try {
              createCaseDs(c, p, acc, idCRM);
              createCaseDSP( c,p,acc, idCRM);
              createCaseEcom(c,p,acc);
              System.debug('************** returnValueMap '+returnValueMap);
        } catch (Exception e) {
              System.debug(' ***************** error'+e.getCause());
              System.debug(' ***************** error'+e.getStackTraceString());
        }
    }
    /*
    *@Author Madicke BALDE 
    *@description create case whith product type DS
    *@param Case c
    *@param Product2 p
    @return void
    */
    public static void createCaseDs(Case c, Product2 p, Account acc, String idCRM){
          Case cp = new Case(); 
          System.debug('cId '+c.Id + 'p.Id'+p.Id +' p.Family'+ p.Family);

          if(c.Id != null && p.Family =='PP_ONLINE_COMPASS_DS' )  {
                System.debug('#################################### case To Update createCaseDS');
                  riaperturaAutomatica(c,  idCRM, p);
                  returnValueMap.put('case', c);
                  return;
          }
          if(c.Id != null || p.Id == null || p.Family != 'PP_ONLINE_COMPASS_DS'){
                  System.debug('No DS');
                  return;
          }
          cp =  controleCase(p.Id, acc.Codice_Cliente__c, acc.Codice_Fiscale__c);
          System.debug('********** cp '+cp);
          System.debug(' *********** cp.Id'+cp.Id);
          if(cp.id != null) {
                  Map<String,Object> returnValue  =  search_Link_Boza(cp);
                  System.debug(' ************* returnValue '+returnValue);
                  for(String key : returnValue.keySet()){
                      returnValueMap.put(key, returnValue.get(key));
                  }
          } 
          else {
                  saveCase(c,p);
                  System.debug('************** save Case '+ c);
                  returnValueMap.put('case', c);
            }
    } 
    /*
    *@Author Madicke BALDE 
    *@description create case whith product type DSP
    *@param Case c
    *@param Product2 p
    @return void
    */
     public static void createCaseDSP(Case c, Product2 p, Account acc, String idCRM){
        Case cp = new Case();
        if(c.Id != null && p.Family == 'PP_ONLINE_PARTNER_DS')  {
          System.debug('**************** Update DSP Case ******************* ');
                         
                        //   CaseService.caseToUpdate(c, p);  
                           riaperturaAutomatica(c,  idCRM, p);        
                           returnValueMap.put('case', c);
                           return;
              }
        if(c.Id != null || p.Id == null || p.Family != 'PP_ONLINE_PARTNER_DS'){
            System.debug('No DSP');
            return;
        }
        cp =  controleCase(p.Id, acc.Codice_Cliente__c, acc.Codice_Fiscale__c);
        System.debug('###################### cp found '+cp);
        if(cp.id != null) {
          Map<String,Object> returnValue  =  search_Link_Boza(cp);
          System.debug(' ************* returnValue DSP '+returnValue);
          for(String key : returnValue.keySet()){
              returnValueMap.put(key, returnValue.get(key));
          }
        } 
       else {
            saveCase(c,p);
            System.debug('************** save Case '+ c);
            returnValueMap.put('case', c);
          }
    }
    /*
    *@Author Madicke BALDE 
    *@description create case whith product type ECOM
    *@param Case c
    *@param Product2 p
    @return void
    */
     public static void createCaseEcom(Case c, Product2 p, Account acc){
       if(c.Id != null && p.Family == 'PF_ECOMMERCE_STANDARD')  {
          System.debug('**************** Update ECOM Case ******************* ');
                          // CaseService.UpdateCase(c);
                           CaseService.caseToUpdate(c, p);
                          // CaseService.UpdateCase(c);
                           returnValueMap.put('case', c);
                           return;
              }

        if(c.Id != null || p.Id == null || p.Family != 'PF_ECOMMERCE_STANDARD'){
            System.debug('No Ecom');
            return;
        }
     
      saveCase(c,p);
      returnValueMap.put('case', c);
    }
     /**
     *@Author Madicke BALDE 
     *@description 
     *@param productId : Id product2
     @param codiceCliente : codice client
     @param codiceFiscale : codice fiscale
     @return Case
     */
     public static Case controleCase(ID productId, String codiceCliente, String codiceFiscale){
       System.debug('****************  productId '+productId + ' codiceCliente '+codiceCliente +' codiceFiscale '+codiceFiscale);
            Case c = new Case();
        try {
        
           List<Case> casesList = CaseService.getCaseByCCCF(codiceCliente, codiceFiscale);
           System.debug(' ************* '+casesList.size());
            if( casesList.size() > 0){
                 for(Case ca: casesList){
                            Integer numberOfDay = (system.today()).daysBetween(Date.valueOf(ca.CreatedDate));
                            if(numberOfDay < 30 && ca.Status != 'Closed' && ca.Product__c == productId){
                                        System.debug('test serarchRichieste');
                                      c = ca;
                                      break;
                             }
                             
                    }   
            } 
          
        } catch (Exception e) {
            System.debug(' ************** **** preventiveControle '+e.getMessage());
            System.debug(' ************** **** preventiveControle '+e.getStackTraceString());
        }
        return c;

    }
    /**
    *@Author Madicke BALDE 
    *@description search link bozza in Case
    @param Link bozza in Case
    */
    public static Map<String,Object> search_Link_Boza(Case c){
        System.debug('*************** search_Link_Boza');
        ResponseWrapper res = new ResponseWrapper();
        Map<String, Object> returnValue = new Map<String, Object>();
        System.debug('################ Link '+c.RO_Link_Bozza__c);
          if(String.isNotEmpty(c.RO_Link_Bozza__c) ){
              returnValue.put('codiceCliente', c.Codice_Cliente__c);
              returnValue.put('codeErreur', 9);
          }
          else {
            returnValue.put('caseId', c);
            // res.caseId = c.Id;
          }
          System.debug('**************** test *********************' + returnValue);
          return returnValue; 
    }
    /*
    *@Author Madicke BALDE
    *@description 
    *@param Case 
    *@param p : Product2
    */
    public static void saveCase(Case c, Product2 p){
        System.debug('********************* saveCase');
        RO_CRMRich_online_steplog__c log ;
        Group g ;

        try {
                log = (RO_CRMRich_online_steplog__c) RequestOnlineApexClass.data.get('ros');
                System.debug('################## RO_CRMModalita_richiesta__c'+log.RO_CRMModalita_richiesta__c);
                System.debug('################## log.RO_CRMStep__c '+log.RO_CRMStep__c);
                if(log.RO_CRMModalita_richiesta__c =='TEL_IN' && log.RO_CRMStep__c == 'Step 2 - Scelta cliente'){
                    g = CaseService.getQueue('Q333');
                    System.debug('################## Q333 ');
                }
                else {
                     g = CaseService.getQueue('Q525');
                }
                if(g.Id !=null){
                    System.debug('********************* Group '+g);
                    c.OwnerId = g.Id;
                    c = CaseService.createCase(c);
                    System.debug('########################### case CREATED '+c);
                }
                log = RichOnlineSteplogService.createCrmOnlineStepLog(c);
                if(p.Family == 'PP_ONLINE_COMPASS_DS')
                   RO_CRMRich_online_prescoring__c logprescoring = RichOnlinePrescoringService.createCrmOnlinePrescoring(c); 

        } catch (Exception e) {
                System.debug('************ saveCase Error'+e.getMessage());
                System.debug('************ saveCase '+e.getStackTraceString());
        }
    } 

    public static void riaperturaAutomatica(Case c, String idCRM, Product2 p ){
        System.debug('**********CreaProspectService.riaperturaAutomatica****START');
        try{
          
          Case oldCase = [SELECT Id, AccountId, RO_Current_Step__c, Status, NumeroPratica__c, OwnerId FROM Case WHERE Id =: c.Id ];
          System.debug('case-->'+oldCase);
          if(oldCase.Status == 'Gestito' && String.isBlank(oldCase.NumeroPratica__c)){
              //Coda casi chiusi
              Group gr = CaseService.getQueue('Q524');
              if(gr.Id.equals(oldCase.OwnerId)){
                System.debug('ENTRATO IN CONDIZIONI DI RIAPERTURA AUTOMATICA');
                //inserimento in coda DS - Richieste Online - Richiamami	
                Group g = CaseService.getQueue('Q333');
                if(g.Id != null){
                    c.OwnerId = g.Id;
                }
                c.Status = 'Ricevuto';
              } 
              System.debug('gr.Id-->'+gr.Id);   
          } else {
            System.debug('NON SONO SOFFISFATTE LE CONDIZIONI DI APERTURA AUTOMATICA:');
            System.debug('case.Status-->'+oldCase.Status);
            System.debug('case.NumeroPratica__c-->'+oldCase.NumeroPratica__c);
            System.debug('case.OwnerId-->'+oldCase.OwnerId);
            
            
          }
          CaseService.caseToUpdate(c, p);
        }catch(Exception e){
          System.debug('EXCEPTION-->'+e);
          System.debug(e.getMessage());
          System.debug(e.getStackTraceString());
        }
        System.debug('**********CreaProspectService.riaperturaAutomatica****DONE');
    }  

    public static void riaperturaAutomatica_old(Case c, String idCRM, Product2 p ){
      System.debug('########################b riaperturaAutomatica running ');
        try {
          Case oldCase = [SELECT Id, AccountId, RO_Current_Step__c, Status, (SELECT Id,RO_CRMModalita_richiesta__c FROM Rich_online_steplogs__r) FROM Case WHERE Id =: c.Id];
          // && String.isNotEmpty(idCRM)
           System.debug('########################b oldCase'+oldCase);
          if(oldCase.Status == 'Gestito'){
                System.debug('################## re Open Case');
                Group gr = [select Id  from Group  where Type = 'Queue' AND DeveloperName = 'Q525'   ];
                System.debug('################## Group  '+gr);
                if(gr.Id != null){
                c.OwnerId = gr.Id;
                }
                c.Status = 'Ricevuto';
                CaseService.caseToUpdate(c, p);
          } 

          else {
                
                  RO_CRMRich_online_steplog__c log  = (RO_CRMRich_online_steplog__c) RequestOnlineApexClass.data.get('ros');
                  if(log.RO_CRMModalita_richiesta__c =='TEL_IN' && log.RO_CRMStep__c =='Step 2 - Scelta cliente'){
                        System.debug('################# chiamata Q333');
                        Group g = CaseService.getQueue('Q333');
                        if(g.Id != null){
                              c.OwnerId = g.Id;
                        }
                  }
                    CaseService.caseToUpdate(c, p);
              }  
        } 
        catch (Exception e) {
          System.debug('################## '+e.getMessage());
          System.debug('################## '+e.getStackTraceString() );
        } 
    }

    public class ResponseWrapper {
    public String codiceCliente;
    public Integer codeErreur;
    public Id caseId;
    }

  /************************************************************
    *@Author Madicke BALDE
    *@description insert case Ind Q333 Queue
    *@param caseObject 

  ***************************************************************/
  public static void inserimentoInCoda(Case caseObject){
      if(caseObject == null || caseObject.Id == null ){
          return;
      }
      else {
            Group g = CaseService.getQueue('Q333');
              if(g != null ) {
                    caseObject.OwnerId = g.Id;
                  
              }
      }
  }
}