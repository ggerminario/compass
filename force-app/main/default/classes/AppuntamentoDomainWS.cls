public with sharing class AppuntamentoDomainWS {
  public static String appuntoDate;
  static List<XCS_DeskItem__c> deskItems;
  static List<XCS_Desk__c> listDesks;
  static String ora ;
  static  Date activiDate ; 
  static AppuntamentoWService.AppuntamentoWrapper appuntamentoWrapper;
  static Account customer;
  static Product2 prodotto;
  static  Account filiale;
  static Event eventUpdatedCreated;
  public static Datetime currentDateTime;
  public static Map<Id, Object> DESK_SLOT_MAP = new Map<Id, Object>();
  public static Id personContactId;
  public static Integer minutesSlotDefault = 30;
 
/**-----------------------------------------------------------------------------------------
      *@Author Madicke BALDE
      *@description
      *date 2019/09/04
  *-----------------------------------------------------------------------------------------*/
public static Event gestitoAppuntamento(AppuntamentoWService.AppuntamentoWrapper appuntamento){
        try {
                filiale = getFilialeByCodiceCliente(appuntamento.codFiliale);
                System.debug('#################### filiale '+filiale);
                System.debug('#################### filiale '+filiale.XCS_Desk__r.size());
                if(filiale.Id == null || filiale.XCS_Desk__r.size() == 0) throw new CGMWSUtils_1_0.CGMWSRException('[KO-FILIALE001]','');
                prodotto = ProdottoService.getProdottoByCodeProdotto(appuntamento.datiAggiuntivi.prodottoOcs);

                //if(prodotto.Id == null) throw new CGMWSUtils_1_0.CGMWSRException('[KO-PROD002]','');
                if(prodotto.Id == null) {
                   prodotto = ProdottoService.getProdottoByExtCode(appuntamento.prodottoLvl2);
                } else {
                  throw new CGMWSUtils_1_0.CGMWSRException('[KO-PROD002]','');
                }
                Map<Id, Object> mapDeskSlot = new Map<Id, Object>();
                Map<String, List<Event>> mpDataEvent = new Map<String, List<Event>>();
                appuntamentoWrapper = appuntamento;

                System.debug(' #############  AppuntamentoError.errorMessage  ### '+ AppuntamentoError.errorMessage);
                System.debug(' #############  AppuntamentoError.hasError  ### '+ AppuntamentoError.hasError);

                activiDate = CGMWSUtils_1_0.formatStringToDate(appuntamento.data);
                
                appuntoDate = appuntamento.data;
                ora = appuntamento.ora;
                System.debug(' ################ filiale.XCS_Desk__r '+filiale.XCS_Desk__r);
                listDesks = filiale.XCS_Desk__r;
                deskItems = AppuntomentoQuery.getXCSDeskItemByIdDesk(filiale.XCS_Desk__r);
                List<Event> events = getEventByDesk(filiale.XCS_Desk__r, activiDate);
                System.debug(' ######################### events test  '+events);

                Event   eventActive =  appuntamentoCerca(appuntamento.datiCliente.codiceFiscale, AppuntamentoError.hasError);

                if(activiDate<System.today()){
                    AppuntamentoError.hasError = true;
                    AppuntamentoError.errorMessage = 'La nuova data non è futura';
                    AppuntamentoError.resultMessage = 'La nuova data non è futura';
                    return eventActive;
                }

                if(eventActive.Id != null){
                    AppuntamentoError.hasError = true;
                    AppuntamentoError.errorMessage = 'Hai già un appuntamento';
                    AppuntamentoError.resultMessage = 'Hai già un appuntamento';
                    return eventActive;
                }

                Set<Time> timeSlots = disponibilitaAppuntamento(filiale, activiDate);
                System.debug(' ############## timseSlots '+timeSlots);
                Time t = EventDomaine.convertStringToTime(appuntamento.ora);
                Map<String,Object>  eventMap =  oraDisponibilita(t, timeSlots,  activiDate, AppuntamentoError.hasError);
                System.debug('############ eventMap'+eventMap);
                
                createAppuntamento(AppuntamentoError.hasError, eventMap);

          }
        catch(DmlException e){
           AppuntamentoError.hasError = true;
            AppuntamentoError.errorMessage = e.getDmlMessage(0);
            AppuntamentoError.resultMessage =e.getDmlMessage(0);
            System.debug(' #################### AppuntamentoErrorMessage '+AppuntamentoError.errorMessage );
            System.debug(' #################### errorMessage '+e.getMessage());
            System.debug(' ############# errorMessage '+e.getStackTraceString());
        }
        catch (Exception e) {
           AppuntamentoError.hasError = true;
            AppuntamentoError.errorMessage = e.getMessage();
            AppuntamentoError.resultMessage =e.getMessage();
            if(filiale.Id != null && filiale.XCS_Desk__r.size() == 0){
                  AppuntamentoError.hasError = true;
                  AppuntamentoError.errorMessage = 'Desk non disponibile per la filiale';
                  AppuntamentoError.resultMessage = 'Desk non disponibile per la filiale';
            }
            System.debug(' #################### AppuntamentoErrorMessage '+AppuntamentoError.errorMessage );
            System.debug(' #################### errorMessage '+e.getMessage());
            System.debug(' ############# errorMessage '+e.getStackTraceString());
        }
        return eventUpdatedCreated;
}

/**
  
public static Boolean isAppuntamentoActive (Event appuntamento){
  Boolean isActive = true;
  if(appuntamento == null || appuntamento.Id == null ){
    return !isActive;
  }
  else {
     Datetime dt =  Datetime.now();
    if(appuntamento.ActivityDateTime > dt  ){
      isActive = false;
    }
    return !isActive;
  }
} */

/*************************************************************************************************************************
  *@Author Madicke BALDE
  *@description  
  *@param desks
  *@param appuntamentoDate
  *@param mapDeskSlot
  *@param codeFiale
 ************************************************************************************************************************/
public static void disponibilitaDesk(List<XCS_Desk__c> desks, Date appuntamentoDate, Map<Id, Object> mapDeskSlot, String codeFiale, Integer minutesSlot){

            String appDate =  CGMWSUtils_1_0.ToString(appuntamentoDate);
            String dayOfWeek = CGMWSUtils_1_0.getDayOfWeek(appDate);
            List<Date> appuntamentoDates = new  List<Date>{appuntamentoDate};
            Map<String, List<Event>> mapDeskEvent = new Map<String, List<Event>>();
            String query = 'SELECT Id, Desk__c, StartTime__c, EndTime__c FROM XCS_DeskItem__c WHERE '+dayOfWeek +'= true AND Desk__c IN :desks' ;
            List<XCS_DeskItem__c> items = Database.query(query);
            System.debug('################# items  '+items.size());
            System.debug('################# items  '+items );
            System.debug(items);
            if(items.size() == 0 ){
                AppuntamentoError.hasError = true;
                AppuntamentoError.errorMessage = 'Appuntamento not Available at '+dayOfWeek;
                return;
            }

          else {
                  Map<Id,List<XCS_DeskItem__c>> mapDeskItemDesk =  groupDeskItemByDesk(items);
                  getDisponibilite(mapDeskItemDesk,  mapDeskSlot ,minutesSlot);
                  System.debug('##################  mapDeskSlot   mario'+ mapDeskSlot);
                  System.debug('################## id Desk '+ mapDeskItemDesk.keySet() );
                  List<Event> events =  AppuntomentoQuery.getDeskIndispo(mapDeskItemDesk.keySet(), appuntamentoDates);
                  System.debug('################## indisponibilite event '+ events);
                  groupEventByType(events, mapDeskEvent); 
                  System.debug('################  groupEventByType '+mapDeskEvent.keySet());
                  Map<Id, List<Event>>  mapEventsByDesk =  getSlotDeskEvent(events);
                  System.debug('###################  mapEventsByDesk  '+mapEventsByDesk.keySet());
                  System.debug('###################  mapEventsByDesk  '+mapEventsByDesk );
                  Map<Id, Object>  indisponibleMap =  getSlotIndisponible(mapEventsByDesk);
                  System.debug('################### indisponibleMap '+indisponibleMap);
                  removeSlotNoDisponible(indisponibleMap, mapDeskSlot);
                  System.debug('################# mapDeskSlot after remove  '+mapDeskSlot);
                  Map<Id, Set<Time>> mapSlotOccupato = getSlotOccupatoByDesk(codeFiale, appuntamentoDate);
                  System.debug(' #################### mapSlotOccupato test'+mapSlotOccupato);
                  removeSlotOccupato(mapDeskSlot, mapSlotOccupato); 
                  setDeskSlotMap(mapDeskSlot);

          }
}

public static List<Slot>  disponibilitaCompleta(List<XCS_Desk__c> desks, Date appuntamentoDate, Map<Id, Object> mapDeskSlot,
                                        String codeFiale){
            String appDate =  CGMWSUtils_1_0.ToString(appuntamentoDate);
            List<Slot> slotlist = new List<Slot>();
            String dayOfWeek = CGMWSUtils_1_0.getDayOfWeek(appDate);
            List<Date> appuntamentoDates = new  List<Date>{appuntamentoDate};
            Map<String, List<Event>> mapDeskEvent = new Map<String, List<Event>>();
            String query = 'SELECT Id, Desk__c, StartTime__c, EndTime__c FROM XCS_DeskItem__c WHERE '+dayOfWeek +'= true AND Desk__c IN :desks' ;
            List<XCS_DeskItem__c> items = Database.query(query);
            System.debug('################# items  '+items.size());
            System.debug('################# items  '+items );
            System.debug(items);
            if(items.size() == 0 ){
                AppuntamentoError.hasError = true;
                //AppuntamentoError.errorMessage = 'Appuntamento not Available at '+dayOfWeek;
                //AppuntamentoError.errorMessage = 'Nessuna disponibilità';
                AppuntamentoError.codeErreor = '999';
                AppuntamentoError.resultMessage = 'Nessuna disponibilità';
                AppuntamentoError.statusCode = 200;
                return slotlist;
            }

          else {
                  Map<Id,List<XCS_DeskItem__c>> mapDeskItemDesk =  groupDeskItemByDesk(items);
                  getDisponibilite(mapDeskItemDesk,  mapDeskSlot );
                  System.debug('##################  mapDeskSlot   mario'+ mapDeskSlot);
                  System.debug('################## id Desk '+ mapDeskItemDesk.keySet() );
                  List<Event> events =  AppuntomentoQuery.getDeskIndispo(mapDeskItemDesk.keySet(), appuntamentoDates);
                  System.debug('################## indisponibilite event '+ events);
                  groupEventByType(events, mapDeskEvent); 
                  System.debug('################  groupEventByType '+mapDeskEvent.keySet());
                  Map<Id, List<Event>>  mapEventsByDesk =  getSlotDeskEvent(events);
                  System.debug('###################  mapEventsByDesk  '+mapEventsByDesk.keySet());
                  System.debug('###################  mapEventsByDesk  '+mapEventsByDesk );
                  Map<Id, Object>  indisponibleMap =  getSlotIndisponible(mapEventsByDesk);
                  System.debug('################### indisponibleMap '+indisponibleMap);
                  removeSlotNoDisponible(indisponibleMap, mapDeskSlot);
                  System.debug('################# mapDeskSlot after remove  '+mapDeskSlot);
                  Map<Id, Set<Time>> mapSlotOccupato = getSlotOccupatoByDesk(codeFiale, appuntamentoDate);
                  System.debug(' #################### mapSlotOccupato test'+mapSlotOccupato);
                  slotlist =  slotDisponibleCompleta(mapDeskSlot, mapSlotOccupato); 
                  System.debug('############# disponibilitaCompleta  slotlist'+slotlist);
                  return slotlist;
                  
              }
}

/***********************************************************************************************
  *@Author Maidkce BALDE
  *@description
  *@param indisponibleMap
  *@param mapDeskSlot
 *************************************************************************************************/
public static void removeSlotNoDisponible(Map<Id,Object> indisponibleMap, Map<Id,Object> mapDeskSlot ){
        if(mapDeskSlot == null || mapDeskSlot.keySet().size() == 0){
            return;
        }
      system.debug('#### removeSlotNoDisponible #indisponibleMap '+indisponibleMap);
      system.debug('#### removeSlotNoDisponible #mapDeskSlot '+mapDeskSlot);
        for(Id key : mapDeskSlot.keySet() ){
              List<Set<Time>> slotDisponible = ( List<Set<Time>>) mapDeskSlot.get(key);
              if(indisponibleMap.containsKey(key)){
                List<Set<Time>> slotNoDisponible = (List<Set<Time>>) indisponibleMap.get(key);
                for(Set<Time> st :  slotNoDisponible ){
                      List<Time> lT = new List<Time>(st);
                      System.debug('############ removeSlotNoDisponible contains element st '+st);
                      Integer taille = lT.size() - 1;
                      Time lastElem = lT[taille];
                      Boolean b = st.remove(lastElem);
                      System.debug('############ removeSlotNoDisponible contains element st '+st+' - check '+b);
                    for(Set<Time> times : slotDisponible ){
                      system.debug('##### removeSlotNoDisponible times available '+times);
                     //   if(times.containsAll(st)){
                                System.debug('############ removeSlotNoDisponible contains element Ok '+st);
                                Boolean bb = times.removeAll(st);
                       // }
                    }

                  }
                  system.debug('############ removeSlotNoDisponible key '+key+' - slotDisponible '+slotDisponible+' - slotNoDisponible '+slotNoDisponible );
              }            
        }

        System.debug('################ test removed '+mapDeskSlot);
}

/**************************************************************************************************
  *@Auhtor Madicke BALDE
  *@description
  *@param mapEventsByDesk
  *@return Map<Id, Object>
 *************************************************************************************************/
public static  Map<Id, Object>  getSlotIndisponible(Map<Id, List<Event>>  mapEventsByDesk ){
        Map<Id, Object> mapIndisponible = new Map<Id, Object>();
        if(mapEventsByDesk == null || mapEventsByDesk.keySet().size() == 0 ){

        }
        for(Id key : mapEventsByDesk.keySet() ){
              List<Event> events = mapEventsByDesk.get(key);
              for(Event ev : events ){
                 if(ev.Type== 'Appuntamento'){

                 }
                  Set<Time> listTime = getSlots(ev.StartDateTime.Time(), ev.EndDateTime.Time());
                  if(!mapIndisponible.containsKey(key)){
                    mapIndisponible.put(key, new List<Set<Time>>{listTime});
                  }
                  else {
                      List<Set<Time>> times =(List<Set<Time>>) mapIndisponible.get(key);
                      times.add(listTime);
                      mapIndisponible.put(key, times);

                  }
              }
                
        }
        return mapIndisponible;
}


public static void getDisponibilite(Map<Id,List<XCS_DeskItem__c>> mapDeskItemDesk , Map<Id,Object> mapslotDisponible){
    getDisponibilite(mapDeskItemDesk,mapslotDisponible,minutesSlotDefault);
}

/*************************************************************************************************
  *@Author Madicke BALDE
  *@description
  *@param mapDeskItemDesk
  *@param mapslotDisponible
  *@return 
 *************************************************************************************************/
public static void getDisponibilite(Map<Id,List<XCS_DeskItem__c>> mapDeskItemDesk , Map<Id,Object> mapslotDisponible,Integer minutesSlot){
         System.debug('#################  running getDisponibilite ' +mapDeskItemDesk.keySet());
         if(mapDeskItemDesk == null || mapDeskItemDesk.keySet().size() == 0 ){
            return;
         }
         for(Id key : mapDeskItemDesk.keySet() ){
                List<XCS_DeskItem__c> items =  mapDeskItemDesk.get(key);
                System.debug('##################  get listTime  item ######## '+items);
                //Set<Time> listTime = getSlots(items.StartTime__c, item.EndTime__c);
                for(XCS_DeskItem__c item :items ){
                  System.debug('##################  listTime  item ######## '+item);
                  Set<Time> listTime = getSlots(item.StartTime__c, item.EndTime__c,minutesSlot);
                  System.debug('##################  listTime ######## '+listTime);
                  if(!mapslotDisponible.containsKey(key) ){
                              mapslotDisponible.put(key, new List<Set<Time>>{listTime});
                    }
                else {
                      List<Set<Time>> itemsList = ( List<Set<Time>>) mapslotDisponible.get(key);
                      itemsList.add(listTime);
                      mapslotDisponible.put(key,itemsList );
                }
            }
          
      } 
       removeLastSlot(mapslotDisponible);
      System.debug('################ after remove '+mapslotDisponible);
 }
/////MC 20200121

 public static void getDisponibilita2(Date dt,Map<Id,List<XCS_DeskItem__c>> mapDeskItemDesk , Map<Id,Object> mapslotDisponible){
         System.debug('#################  running getDisponibilite ' +mapDeskItemDesk.keySet());
         if(mapDeskItemDesk == null || mapDeskItemDesk.keySet().size() == 0 ){
            return;
         }
         for(Id key : mapDeskItemDesk.keySet() ){
                List<XCS_DeskItem__c> items =  mapDeskItemDesk.get(key);
                System.debug('##################  get listTime  item ######## '+items);
                //Set<Time> listTime = getSlots(items.StartTime__c, item.EndTime__c);
                
              for(XCS_DeskItem__c item :items ){                 
                  System.debug('##################  listTime  item ######## '+item);
                   //check giorno della settimana
                  /////////--------//////
                  
                  String dayeOfWeek = ((Datetime) dt).format('EEEE')+'__c';
                  Object availableDay=item.get(dayeOfWeek);
                if(Boolean.valueOf(availableDay)) { // slot disponibile
                  Set<Time> listTime = getSlots(item.StartTime__c, item.EndTime__c);
                  System.debug('##################  listTime ######## '+listTime);
                  if(!mapslotDisponible.containsKey(key) ){
                              mapslotDisponible.put(key, new List<Set<Time>>{listTime});
                    }
                  else {
                      List<Set<Time>> itemsList = ( List<Set<Time>>) mapslotDisponible.get(key);
                      itemsList.add(listTime);
                      mapslotDisponible.put(key,itemsList );
                  }
                }
            }
          
      } 
       removeLastSlot(mapslotDisponible);
      System.debug('################ after remove '+mapslotDisponible);
 }

 public static void removeLastSlot(Map<Id,Object> mapslotDisponiblep){
      if(mapslotDisponiblep == null || mapslotDisponiblep.keySet().size() == 0){
        return;
      }
      for(Id key : mapslotDisponiblep.keySet()){
          List<Set<Time>> listSlot = ( List<Set<Time>>) mapslotDisponiblep.get(key);
          for(Set<Time> times : listSlot ){
              List<Time> listTimes = new List<Time>(times);
              Integer taille = listTimes.size() - 1;
              Time t = listTimes[taille];
              Boolean b = times.remove(t);
              
          }
      }
 }


    /**--------------------------------------------------------------------------------------------
      *@Author Madicke BALDE

     *---------------------------------------------------------------------------------------------*/
    public static Map<Id,List<XCS_DeskItem__c>> groupDeskItemByDesk(List<XCS_DeskItem__c> desksItems){
          Map<Id, List<XCS_DeskItem__c>> mapDesks = new Map<Id, List<XCS_DeskItem__c>>();
          for(XCS_DeskItem__c item : desksItems ){
         if(!mapDesks.containsKey(item.Desk__c)){
              mapDesks.put(item.Desk__c, new List<XCS_DeskItem__c>{item});
         }
         else {
             mapDesks.get(item.Desk__c).add(item);
         }
      }
     return mapDesks;
    }

    public static Map<Id,List<XCS_DeskItem__c>> getDeskDisponible(List<XCS_DeskItem__c> desksItems, List<Event> events){
      System.debug('###############  getDeskDisponible desksItems '+desksItems);
       System.debug('###############  getDeskDisponible events '+events);
       Map<Id, List<XCS_DeskItem__c>> mapDesks = new Map<Id, List<XCS_DeskItem__c>>();
   
      for(XCS_DeskItem__c item : desksItems ){
         if(!mapDesks.containsKey(item.Desk__c)){
           mapDesks.put(item.Desk__c, new List<XCS_DeskItem__c>{item});
         }
         else {
           mapDesks.get(item.Desk__c).add(item);
         }
      }
      for(Event ev : events){
        if(mapDesks.containsKey(ev.Desk__c)){
         mapDesks.remove(ev.Desk__c);
        }
      }
      System.debug(' #################### getDeskDisponible '+mapDesks);
      return mapDesks;
    }

/**-------------------------------------------------------------------------------------
      *@Author Madicke BALDE
      *@description check  Filiale existence
      *@param code Filiale
      *@return Account
      *@date 2019/08/27
 *---------------------------------------------------------------------------------------*/
public static Account ckeckFilialeExistence (String codeFiliale){
      Account account;
      if(String.isNotBlank(codeFiliale) ){
       // account = AppuntomentoQuery.getFiliale(codeFiliale);
        account = AppuntomentoQuery.getFilialeByCodeFiliale(codeFiliale);
        return account;
      }
      else {
        return null;
      }
}

public static Account getFilialeByCodiceCliente(String codice){
   System.debug('#################### getFilialeByCodiceCliente ruunning ');
    Account account;
      if(String.isNotBlank(codice) ){
        account = AppuntomentoQuery.getFiliale(codice);
        //  account = AppuntomentoQuery.getFilialeByCodeFiliale(codeFiliale);
        System.debug('#################### getFilialeByCodiceCliente '+account);
        return account;
      }
      else {
        return null;
      }
}

public static Account getFilialeById(Id idFiliale){
     System.debug('#################### getFilialeByCodiceCliente ruunning ');
      Account account;
      if(String.isNotBlank(idFiliale) ){
        account = AppuntomentoQuery.getFiliale(idFiliale);
        //  account = AppuntomentoQuery.getFilialeByCodeFiliale(codeFiliale);
        System.debug('#################### getFilialeByCodiceCliente '+account);
        return account;
      }
      else {
        return null;
      }

}
/**-----------------------------------------------------------------------
  *@Author Madicke BALDE
  *@description get List of event by desk of filiale
  *@date 2019/09/04
  *
 *-----------------------------------------------------------------------*/
public static List<Event> getEventByDesk(List<XCS_Desk__c> deskList, Date appuntamentoDate){
    System.debug(' ################# running getEventByDesk desk '+ deskList);
    List<Event> events = new List<Event>();
    try {
        events = AppuntomentoQuery.getEventByDeskDate(deskList, appuntamentoDate);
        
        
    } catch (Exception e) {
      System.debug(' ######### errorMessage '+e.getMessage());
      System.debug(' ######### errorMessage '+e.getStackTraceString() );
    }
    return events;
}

public static void getEventByDeskEvent(List<Event> eventList, Map<Id,List<Event>> mapData){
   for(Event ev : eventList){
      if(!mapData.containsKey(ev.Desk__c)){
        mapData.put(ev.Desk__c, new List<Event>{ev});
      }
      else {
        mapData.get(ev.Desk__c).add(ev);
      }
   }
}
/**---------------------------------------------------------------------------------------
  *@Author Madicke BALDE
  *@description Group event by type
  *@param events  List event 
  *@return Map<String,List<Event>>
 *--------------------------------------------------------------------------------------*/
public static void groupEventByType(List<Event> events, Map<String,List<Event>> mapRetuenValue ){
    System.debug(' ############### running groupEventByType');
    if(events.size() == 0 ){
       /* AppuntamentoError.hasError = true;
        AppuntamentoError.errorMessage = 'Filiale Has Not Available at this Date'; */
        return;
    }
    else {
         System.debug(' ################### mapRetuenValue groupEventByType ');
          System.debug(' ################### event  '+events);
         for(Event ev : events){
             if(ev.Type =='Appuntamento'){
                 if(!mapRetuenValue.containsKey('disponible')){
                     mapRetuenValue.put('disponible', new List<Event>{ev} );
                 }
                 else {
                     // mapRetuenValue.put('disponible',(List<Event>) mapRetuenValue.get('disponible').add(ev) );
                     mapRetuenValue.get('disponible').add(ev);
                 }
             }
              if(ev.Type =='Festività'){
                 if(!mapRetuenValue.containsKey('festivita')){
                     mapRetuenValue.put('festivita', new List<Event>{ev} );
                 }
                 else {
                     // mapRetuenValue.put('disponible',(List<Event>) mapRetuenValue.get('disponible').add(ev) );
                     mapRetuenValue.get('festivita').add(ev);
                 }
             }

             else {
                  if(!mapRetuenValue.containsKey('indisponibilita')){
                     mapRetuenValue.put('indisponibilita', new List<Event>{ev} );
                 }
                 else {
                     // mapRetuenValue.put('indisponibilita',(List<Event>) mapRetuenValue.get('indisponibilita').add(ev) );
                        mapRetuenValue.get('indisponibilita').add(ev);
                 }
             }
         }
    }
}


/**----------------------------------------------------------------------
  *@Author Madicke BALDE
  *@description 
  *@param 
 *----------------------------------------------------------------------*/
public static void setDeskSlotMap (Map<Id,Object> mapSlotDesks){
  if(mapSlotDesks == null || mapSlotDesks.keySet().size() == 0){
    return;
  }
     DESK_SLOT_MAP = mapSlotDesks;
}
/**------------------------------------------------------------------------
  *@Author Madicke BALDE
  *@description check if Ora Appuntamento is available
  *@param ora : Appuntamento Ora
  *@param timseSlot : List slot available
  *@return Boolean
 *------------------------------------------------------------------------*/
public static Boolean checkValidateOra(Time ora, Set<Time> timeSlot){
  System.debug('############ running  checkValidateOra');
  Boolean isValid = false;
  for(Time t : timeSlot){
    if(ora == t){
      isValid = true;
      break;
    }
  }
  return isValid;
}

/**----------------------------------------------------------------------------------------------
  *@Author Madicke 
  *@description 
  *@date 2019/09/04
  *@param events
  *@param mapDeskSlot
 *-----------------------------------------------------------------------------------------------*/
/*public static void  getSlotDeskDisponibilita(Map<String,List<Event>> mapDeskEvent, Map<Id, Object> mapDeskSlot){
    System.debug(' ################# running getSlotDeskDisponibilita');
    if(mapDeskEvent == null || mapDeskEvent.get('disponible') == null  ){
        return;
    }
    else {
        System.debug(' ############ disponile '+mapDeskEvent.get('disponible'));
        for(Event ev : mapDeskEvent.get('disponible')){
            Set<Time> listTimeSlot = getSlot(ev.StartDateTime, ev.EndDateTime);
            System.debug(' ############## listTimeSlot  disponible'+listTimeSlot);
            mapDeskSlot.put(ev.Desk__c, listTimeSlot);
        }
        
    }
     System.debug(' ############ getSlotDeskDisponibilita '+mapDeskSlot.keySet().size());
     System.debug(' ############ getSlotDeskDisponibilita '+mapDeskSlot);
} */

/*public static void slotDesk(Map<Id, Object> mapDeskSlot,  Map<Id, List<XCS_DeskItem__c>> mapDesk ){
  if(mapDesk == null || mapDesk.keySet().size() == 0){
    return;
  }
  else {
       for(Id key : mapDesk.keySet()){
              XCS_DeskItem__c item = mapDesk.get(key)[0];
              Set<Time> listTime = getSlots(item.StartTime__c, item.EndTime__c);
              System.debug('################# listTime '+listTime);
            // Datetime startT = Datetime.newI
            //Set<Time> listTimeSlot = getSlot( mapDesk.get(key)[0].StarTime__c , (XCS_DeskItem__c) mapDesk.get(key)[0].EndTime__c );
              mapDeskSlot.put(key, listTime);
              System.debug('########################## slotDesk slotDesk '+mapDeskSlot);
       }
  }
  System.debug('################# slotDesk  '+ mapDeskSlot);
} */
/**-----------------------------------------------------------------------------------------------
  *@Author Madicke BALDE
  *@description
  *@date
  *@param mapDeskEvent
  *@param mapDeskSlot
 *-------------------------------------------------------------------------------------------------*/
/*public static void getSlotDeskInDisponibilita(Map<String,List<Event>> mapDeskEvent, Map<Id, Object> mapDeskSlot){
    System.debug(' ############## running ########### getSlotDeskInDisponibilita');
    System.debug(' ################# isdisp '+ mapDeskEvent.get('indisponibilita'));
    System.debug(' ################# listDesks '+ listDesks);
    // mapDeskEvent == null ||  !mapDeskEvent.containsKey('indisponibilita') ||  mapDeskEvent.get('indisponibilita') == null  || listDesks.size()
    if(mapDeskEvent == null ||  !mapDeskEvent.containsKey('indisponibilita') ||  mapDeskEvent.get('indisponibilita') == null  ){
        return;
    }
    else {
         List<Event> ev = mapDeskEvent.values()[0];
         System.debug(' ################## getSlotDeskInDisponibilita  else ok');
           System.debug(' ################## appuntoDate  '+ev[0].ActivityDate);
         String appDate =  CGMWSUtils_1_0.ToString(ev[0].ActivityDate);

         System.debug(' ##################   mapDeskSlot  indisponibilita '+mapDeskSlot);
         System.debug('####################### ');
        String dayOfWeek = CGMWSUtils_1_0.getDayOfWeek(appDate);
        listDesks = getListDeskIndisponibilita((List<Event>)mapDeskEvent.get('indisponibilita'));
        System.debug(' ############## indisponibilita listDesks '+listDesks);
        EventDomaine.getSlotDesk(listDesks, mapDeskSlot, dayOfWeek);
        subtractSlotsUnavailable(mapDeskSlot, (List<Event>) mapDeskEvent.get('indisponibilita'), AppuntamentoError.hasError);
        System.debug(' ############## mapDeskSlot indisponibilita '+mapDeskSlot);
        
    }
} */

/*public static void getSlotDeskFestivita(Map<String,List<Event>> mapDeskEvent, Map<Id, Object> mapDeskSlot){
    System.debug('################# running getSlotDeskFestivita '+ mapDeskEvent.get('festivita'));
   if(mapDeskEvent == null ||  !mapDeskEvent.containsKey('festivita') ||  mapDeskEvent.get('festivita') == null  ){
        return;
    }
    else {
             listDesks = getListDeskIndisponibilita((List<Event>)mapDeskEvent.get('festivita'));
            List<Event> ev = mapDeskEvent.values()[0];
            System.debug(' ################## getSlotDeskFestivita  else ok');
            System.debug(' ################## appuntoDate  '+ev[0].ActivityDate);
            String appDate =  CGMWSUtils_1_0.ToString(ev[0].ActivityDate);
            System.debug(' ################## appuntoDate  '+appDate);

            String dayOfWeek = CGMWSUtils_1_0.getDayOfWeek(appDate);
           if(mapDeskSlot == null || mapDeskSlot.keySet().size() == 0 ){
                  System.debug(' ############ Festività '+mapDeskEvent.get('festivita'));
                  System.debug('############### mapDeskSlot in festivita '+mapDeskSlot);
                  
                 
                  System.debug(' ############## Festività listDesks '+listDesks);
                  EventDomaine.getSlotDesk(listDesks, mapDeskSlot, dayOfWeek);
                  subtractSlotsUnavailable(mapDeskSlot, (List<Event>) mapDeskEvent.get('festivita'), AppuntamentoError.hasError);
                  System.debug(' ############## mapDeskSlot festivita '+mapDeskSlot);
           }
           else {
                 Map<Id, Object> slotMap = new Map<Id, Object>();
                 EventDomaine.getSlotDesk(listDesks, slotMap, dayOfWeek);
                 subtractSlotsUnavailable(slotMap, (List<Event>) mapDeskEvent.get('festivita'), AppuntamentoError.hasError);
                 List<Time> times = new List<Time>();
                 System.debug('##### key  '+mapDeskSlot.keySet() );
                 for(Id key : slotMap.keySet()){
                   if(mapDeskSlot.containsKey(key)){
                      System.debug('##### key '+key + '######## '+mapDeskSlot.get(key));
                       
                       Set<Time> timseSlot = ( Set<Time>) mapDeskSlot.get(key);
                      List<Time> listTimes = new List<Time>(timseSlot);
                      for(Time t : ( Set<Time>) slotMap.get(key) ){
                         if(t  >=   listTimes[0] ){
                            times.add(t);
                         }
                      } 
                     
                      mapDeskSlot.put(key,  new Set<Time>(times));
                   }
                 }
                 System.debug('#########################  slotMap festivita '+slotMap);
                System.debug('#########################  slotMap festivita '+slotMap.keySet());
                System.debug('#########################  slotMap festivita '+mapDeskSlot.keySet());
                System.debug('#########################  slotMap festivita '+mapDeskSlot);
                System.debug('#########################  slotMap festivita '+times);
           }
         
        
    }

} */

/*public static  void subtractSlotsUnavailable(Map<Id, Object> mapDeskSlot, List<Event> eventsIndisponibilita, Boolean hasError ){
   if(hasError){
      System.debug(' ############## running subtractSlotsUnavailable hasError ');
     return;
   }
   else {
     System.debug('#################### subtractSlotsUnavailable mapDeskSlot '+mapDeskSlot);
     System.debug(' ############## running subtractSlotsUnavailable else ');
        Map<Id, Object> slotMap = new Map<Id, Object>();
         List<Set<Time>> test = new  List<Set<Time>>();
        for(Event ev : eventsIndisponibilita){
            Set<Time> listTimeSlot = getSlot(ev.StartDateTime, ev.EndDateTime);
            if(!slotMap.containsKey(ev.Desk__c)){
               slotMap.put(ev.Desk__c,  new List<Set<Time>>{listTimeSlot});
            }
            else {
                   System.debug('################# listTimeSlot 2 ');
                  // slotMap.get(ev.Desk__c).add(listTimeSlot);
                 List<Set<Time>> setSlot = (List<Set<Time>>) slotMap.get(ev.Desk__c);
                 setSlot.add(listTimeSlot);
                  // setSlot.addAll(listTimeSlot);
                    slotMap.put(ev.Desk__c, setSlot);
            }
            
        }
        System.debug('####################  slotMap subtractSlotsUnavailable '+slotMap);
        removeSlots(mapDeskSlot, slotMap);
     
   }
} */

public static void removeSlots(Map<Id, Object> mapDeskSlot,  Map<Id, Object> slotMap ){
  if(mapDeskSlot == null || mapDeskSlot.keySet().size() == 0 || slotMap == null || slotMap.keySet().size() == 0){
    System.debug(' ############## running  removeSlots hasError ');
    return;
  }
  else {
      Map<Id, Object> mapSlotRemoved = new Map<Id, Object>();
      //List<Time> slotToremove = new List<Time>();
      for(Id key : mapDeskSlot.keySet() ){
      System.debug('###################  mapDeskSlot test2 '+key +' ####### '+mapDeskSlot.get(key));
      }
      System.debug(' ############## running  removeSlots esle  mapDeskSlot '+mapDeskSlot);
      System.debug(' ############## running  removeSlots esle  slotMap '+slotMap);
       System.debug(' ############## running  removeSlots esle  slotMap keySet '+slotMap.keySet() );
        System.debug(' ############## running  removeSlots esle  mapDeskSlot keySet '+mapDeskSlot.keySet() );
    for(Id key : mapDeskSlot.keySet()){
      List<Time> slotToremove = new List<Time>();
            if(slotMap.containsKey(key)){
                  System.debug('###################  mapDeskSlot test '+key +' ####### '+mapDeskSlot.get(key));
                  System.debug('###################  mapDeskSlot '+key);
                  Set<Time> slot = (Set<Time>) mapDeskSlot.get(key);
                  List<Time> slotList = new  List<Time>(slot);
                  Integer elementSize = slotList.size()-1;
                  Time fs = slotList[0];
                  Time es = slotList[elementSize];
                  System.debug('################# fs '+fs);
                  System.debug('################# es '+es);
                  System.debug('####################### mapDeskSlot key  '+mapDeskSlot.get(key) );
                  System.debug('################# slotMap '+slotMap.get(key) );
                  List<Set<Time>> llistTimeSlot = (List<Set<Time>>) slotMap.get(key);
                  System.debug('################# test slotMap llistTimeSlot '+ llistTimeSlot);
                  Integer i = 0;
                  for(Set<Time> slotIndisponibilita : llistTimeSlot ){
                          List<Time> slotIndisp = new List<Time>(slotIndisponibilita);
                          Integer taille = slotIndisp.size()-1;
                          slotIndisp.sort();
                          System.debug('##################### slotIndisp '+slotIndisp);
                          Time endElem = slotIndisp[taille];
                          Time fsElem = slotIndisp[0];
                          System.debug('##################### slotIndisp fs '+fsElem);
                          System.debug('##################### slotIndisp fse '+endElem);
                        if(fsElem != fs){
                          System.debug('########## ok fs');
                          Boolean b = slotIndisponibilita.remove(fsElem);
                          // Boolean  bb= ((Set<Time>) mapDeskSlot.get(key)).removeAll(slotIndisponibilita);
                        }
                        if(endElem != es){
                            System.debug('########## ok es');
                          Boolean b = slotIndisponibilita.remove(endElem);
                          
                          }
                        System.debug('####################### slotIndisponibilita mapDeskSlot.get(key)  key ++++ '+ key+ '#### ' +mapDeskSlot.get(key));
                        System.debug('####################### slotIndisponibilita mapDeskSlot.get(key) ++++ '+mapDeskSlot.get(key));
                        System.debug('####################### slotIndisponibilita mapDeskSlot.get(key) ++++ test   '+mapDeskSlot.get('a0x5E000001Kh4rQAC'));
                        System.debug('##################### slotIndisponibilita to remove test '+slotIndisponibilita);
                        slotToremove.addAll(slotIndisponibilita);
                    } 
     
                }
              mapSlotRemoved.put(key, slotToremove );
    }
      
          // System.debug('########################### slotToremove '+slotToremove);
          System.debug('########################### mapSlotRemoved keyset '+mapSlotRemoved.keySet());
          System.debug('########################### mapSlotRemoved k '+mapSlotRemoved );
          //a0x5E000001Kh4rQAC   a0x5E000001Kh4mQAC
          System.debug('######################## mapSlotRemoved a0x5E000001Kh4rQAC '+mapSlotRemoved.get('a0x5E000001Kh4rQAC') );
          System.debug('######################## mapSlotRemoved a0x5E000001Kh4mQAC '+mapSlotRemoved.get('a0x5E000001Kh4mQAC') );
          System.debug('######################## mapDeskSlot mapSlotRemoved a0x5E000001Kh4mQAC '+mapDeskSlot.get('a0x5E000001Kh4mQAC') );
          System.debug('######################## mapDeskSlot mapSlotRemoved a0x5E000001Kh4rQAC '+mapDeskSlot.get('a0x5E000001Kh4rQAC') );
    for(Id key : mapSlotRemoved.keySet()){
        List<Time> elementList =(List<Time>) mapSlotRemoved.get(key);
        Set<Time> recover = new Set<Time>();
      if(mapDeskSlot.containsKey(key)){
            Set<Time> ffs = (Set<Time>) mapDeskSlot.get(key);
            List<Time> listT = new List<Time>(ffs);
            System.debug('############# elementList '+elementList);
             System.debug('############# elementList ffs  '+ffs);
             for(Time t : ffs){
                if(!elementList.contains(t)){
                  recover.add(t);
                }
        }
        System.debug('################### recover '+recover);
        mapDeskSlot.put(key, recover);
      }
     System.debug('################# reomveSlots  bb '+mapDeskSlot);
    }
   
  }
}
public static void removeSlotOccupato(Map<Id, Object> mapDeskSlot,  Map<Id, Object> slotMap ){
   if(mapDeskSlot == null || mapDeskSlot.keySet().size() == 0 || slotMap == null || slotMap.keySet().size() == 0){
    System.debug(' ############## running  removeSlots hasError ');
    return;
  }
  else{
      for(Id key : slotMap.keySet()){
        if(mapDeskSlot.containsKey(key)){
          Set<Time> slotDesk = (Set<Time>) slotMap.get(key);
          List<Set<Time>> times =  (List<Set<Time>> ) mapDeskSlot.get(key);
          for(Set<Time> st : times ){
           //  if(st.containsAll(slotDesk)){
               System.debug('################# removed st '+st);
               System.debug('################# removed '+slotDesk);
               Boolean b = st.removeAll(slotDesk);
                System.debug('################# removed  after'+st);
            // }
          }
        
        }
      }

  }
}

public static   List<Slot> slotDisponibleCompleta(Map<Id, Object> mapDeskSlot,  Map<Id, Object> slotMap ){
   Map<Id, Object> allSlotsMap = new Map<Id, Object>();
   System.debug('***Slot disponibile->'+mapDeskSlot);
   System.debug('***Slot occupati-->'+slotMap);
   List<Slot> listSlot = new List<Slot>();
   if(mapDeskSlot == null || mapDeskSlot.keySet().size() == 0 /*|| slotMap == null || slotMap.keySet().size() == 0*/){
    System.debug(' ############## running  removeSlots hasError ');
    return null;
  }
  else{
    
    Map<String,Slot> mergeSlot = new Map<String,Slot>();
    //non ci sono slot occupati
    if(slotMap.size()==0){
      for(Id key : mapDeskSlot.keySet()){
          //Set<Time> slotDesk = (Set<Time>) mapDeskSlot.get(key);
          List<Set<Time>> times =  (List<Set<Time>> ) mapDeskSlot.get(key);
          for(Set<Time> st : times ){
               System.debug('############ st '+st);
              //if(st.containsAll(slotDesk)){
                //  List<Slot> listSlot = new List<Slot>();
                  System.debug('################# removed st '+st);
                  //System.debug('################# removed '+slotDesk);
                  for(Time t : st){
                      Integer b = 1; //Sempre disponibile
                      Slot s = new SLot(t, b);
                      //listSlot.add(s);
                      mergeSlot.put(String.valueOf(t),s);
                  }
                 // allSlotsMap.put(key, listSlot );
            // }
           }
      }
    }else {
      //ci sono slot occupati, bisogna effettuare un filtro
      for(Id key : mapDeskSlot.keySet()){
          Set<Time> slotDesk = (Set<Time>) slotMap.get(key);
          System.debug('############ slotDesk '+slotDesk);
       //   System.debug('############ ');
          List<Set<Time>> times =  (List<Set<Time>> ) mapDeskSlot.get(key);
          for(Set<Time> st : times ){
               System.debug('############ st '+st);
              //if(st.containsAll(slotDesk)){
                //  List<Slot> listSlot = new List<Slot>();
                  System.debug('################# removed st '+st);
                  System.debug('################# removed '+slotDesk);
                  for(Time t : st){
                      Integer b = (slotDesk!=null && slotDesk.contains(t))?0:1;
                      Slot s = new SLot(t, b);
                      //listSlot.add(s);
                      if(b==1){ //se è disponibile, inserisco il valore
                        mergeSlot.put(String.valueOf(t),s);
                      } else { //se non è dispobile, inserisco solo se non c'è valore già inserito
                        if(!mergeSlot.containsKey(String.valueOf(t)))
                          mergeSlot.put(String.valueOf(t),s);
                      }
                        
                      
                  }
                 // allSlotsMap.put(key, listSlot );
             //
        }
        
        }
      }
      System.debug('################ allSlotsMap '+listSlot);
      System.debug('################ allSlotsMap '+allSlotsMap.values());
      //return listSlot;
      return mergeSlot.values();
  }

 
  
}

/*public static void removeTimeSlot(Map<Id, Object> mapDeskSlot,  Map<Id, Object> slotMap ){
  if(mapDeskSlot == null || mapDeskSlot.keySet().size() == 0 || slotMap == null || slotMap.keySet().size() == 0){
    System.debug(' ############## running  removeSlots hasError ');
    return;
  }
  else {
      System.debug(' ############## running  removeSlots esle  mapDeskSlot '+mapDeskSlot);
      System.debug(' ############## running  removeSlots esle  slotMap '+slotMap);
    for(Id key : slotMap.keySet()){
        if(mapDeskSlot.containsKey(key)){
            Set<Time>  listTimeSlot = (Set<Time>) slotMap.get(key);
            Integer taille = listTimeSlot.size();
            Set<Time> timeremove = new Set<Time>();
          //  Time endElement;
       
            System.debug(' #########################  listTimeSlot end '+listTimeSlot);
            // listTimeSlot.remove(listTimeSlot.size()-1);
         //   List<Time>  lt = new  List<Time> (listTimeSlot);
          // for(Time t : listTimeSlot ){
                // System.debug(' #########################  mapDeskSlot.get(key))'+mapDeskSlot.get(key));
                Boolean  b= ((Set<Time>) mapDeskSlot.get(key)).removeAll(listTimeSlot);
                System.debug(' ################### boolean bbbbbbbbb '+b);
                System.debug(' #########################  mapDeskSlot.get(key))'+mapDeskSlot.get(key));
     //   }
      
      }
    }
  }
} */



public static List<XCS_Desk__c> getListDeskIndisponibilita( List<Event> events){
    List<XCS_Desk__c> xdesks = new List<XCS_Desk__c>();
    Set<Id> idDesk = new Set<Id>();
    try { 
        for(Event ev : events){
         idDesk.add(ev.Desk__c);
        }  
        xdesks = [SELECT Id, Branch__c, DeskName__c FROM XCS_Desk__c WHERE Id IN: idDesk];

    } catch (Exception e) {
      System.debug(' ############# errorMessage '+e.getMessage());
      System.debug(' ############# errorMessage '+e.getStackTraceString() );
    }
    System.debug(' ################### getListDeskIndisponibilita events '+xdesks);
    return xdesks;
}


public static Set<Time> getSlots(Time timeStar, Time timeEnd){
   return  getSlots(timeStar,timeEnd,minutesSlotDefault);
}


public static Set<Time> getSlots(Time timeStar, Time timeEnd,Integer minutestSlot){
  //System.debug('######### '+timeStar)
   Set<Time> listTime = new Set<Time>();
    Time t = timeStar.addMinutes(minutestSlot);
     while (t <= timeEnd) {
        listTime.add(timeStar);
        listTime.add(t);
        timeStar = t;
        t= t.addMinutes(minutestSlot);
    }
    System.debug(' ############# listTime  '+listTime);
    return listTime;
}


public static  Map<String,Object> checkDisponilitaOra(String ora, Map<Id, Object> mapDesk, Date activiDate, Boolean hasError ){
    return checkDisponilitaOra(ora,mapDesk,activiDate,hasError,minutesSlotDefault);
}

 /**-------------------------------------------------------------------------------
      *@Author Madicke BALDE
      *@description get Desk and Slot
  *--------------------------------------------------------------------------------*/
   
public static  Map<String,Object> checkDisponilitaOra(String ora, Map<Id, Object> mapDesk, Date activiDate, Boolean hasError,Integer minutesSlot){
        System.debug(' ################ running checkDisponilitaOra ############# ');
        Map<String,Object> eventMap = new Map<String, Object>();
         System.debug(' ################ running hasError ############# '+hasError);
        eventMap.put('isAvailable', false);
        Event event = new Event();
        if(hasError){
            return null;
        }
        else {
              Map<Id, List<Event>> mp = EventDomaine.getEventByIDesk(mapDesk.keySet() ,activiDate);
              System.debug('######################## mp checkDisponilitaOra '+mp);
              Time t = EventDomaine.convertStringToTime(ora);
              Datetime dt =  EventDomaine.convertStringToDatetime(appuntoDate, ora);
              Datetime ddt = Datetime.newInstance(activiDate.year(), activiDate.month(), activiDate.day(), t.hour(), t.minute(), t.second());
              Integer leaveLoop = 0;
              for(Id idDesk : mapDesk.keySet()){
                    System.debug(' ############### mapDesk.get(idDesk)) ####### '+mapDesk.keySet() );
                    System.debug(' ############### mapDesk.get(idDesk)) ####### '+mapDesk.get(idDesk));
                      List<Set<Time>> lt = (List<Set<Time>>) mapDesk.get(idDesk);
                    for(Set<Time> s : lt){
                        if(( mp.keySet().size() == 0 && s.contains(t)) ||
                                ((mp.keySet().size() > 0 ) &&   ( mp.get(idDesk)!=null && mp.get(idDesk).size() < s.size() ) && (s.contains(t) )) ){
                                      System.debug(' ############### test Ok  ####### ');
                                      event.ActivityDate = dt.date();
                                      event.StartDateTime = ddt;
                                      event.ActivityDateTime = ddt;
                                      event.Desk__c = idDesk;   
                                      event.EndDateTime = dt.addMinutes(minutesSlot);
                                      event.DurationInMinutes = minutesSlot;
                                      eventMap.put('event', event);
                                      leaveLoop = 1;
                                      break;
                            } 

                        }
                    if(leaveLoop == 1) break;
                 
                }
                if(eventMap.get('event') == null ){
                  AppuntamentoError.hasError = true;
                  AppuntamentoError.errorMessage = 'Per la filiale selezionata non è disponibile questo slot '+ora;
                }
                System.debug(' ########## eventMap '+event);
                return eventMap;
              }
}

public static Map<String,Object>  oraDisponibilita(Time oraTime, Set<Time> timseSlot,Date appuntamentoDate, Boolean hasError){
  return oraDisponibilita(oraTime,timseSlot,appuntamentoDate,hasError,minutesSlotdefault);
}

public static Map<String,Object>  oraDisponibilita(Time oraTime, Set<Time> timseSlot,Date appuntamentoDate, Boolean hasError,Integer minutesSlot){
  System.debug('################ oraDisponibilita ##############  ');
  if(hasError == true || timseSlot.size() == 0 ){
    System.debug('################## oraDisponibilita error ');
    AppuntamentoError.hasError = true;
    AppuntamentoError.errorMessage = 'La filiale non è disponibile a questa data';
    AppuntamentoError.resultMessage = 'La filiale non è disponibile a questa data';
    return null ;
  }
  else {
      Map<String, Object> eventMap = new Map<String, Object>();
      //Time t = EventDomaine.convertStringToTime(oraTime);
    
      if(checkValidateOra(oraTime, timseSlot)){
          System.debug('################ oraDisponibilita checkValidateOra ##############  ');
          Datetime  dt = Datetime.newInstance(appuntamentoDate, oraTime);
          System.debug(' ###################  DESK_SLOT_MAP'+DESK_SLOT_MAP);
          for(Id key : DESK_SLOT_MAP.keySet()){
             List<Set<Time>> setList = (List<Set<Time>>) DESK_SLOT_MAP.get(key);
             for(Set<Time> times : setList ){
                 if(times.contains(oraTime)){
                          Event event = new Event();
                          event.ActivityDate = dt.date();
                          event.StartDateTime = dt;
                          event.ActivityDateTime = dt;
                          event.Desk__c = key;
                          event.EndDateTime = dt.addMinutes(minutesSlot);
                          event.DurationInMinutes = minutesSlot;
                          eventMap.put('event', event);
                          break;
                 }
             }
          }
      }
  else {
         AppuntamentoError.hasError = true;
         AppuntamentoError.errorMessage = ' ora '+ora +' non disponible';
         AppuntamentoError.resultMessage = ' ora '+ora +' non disponible';
      }
         /*   if( ((Set<Time>)DESK_SLOT_MAP.get(key)).contains(oraTime)){
              Event event = new Event();
             System.debug(' ############### test Ok  ####### ');
                          event.ActivityDate = dt.date();
                          event.StartDateTime = dt;
                          event.ActivityDateTime = dt;
                          event.Desk__c = key;
                          event.EndDateTime = dt.addMinutes(30);
                          event.DurationInMinutes = 30;
                          eventMap.put('event', event);
                          break;

            }
      }
      else{
        AppuntamentoError.hasError = true;
        AppuntamentoError.errorMessage = ' ora '+ora +' No disponible';
      } */
      System.debug(' ###################### eventMap '+eventMap);
      return eventMap;
  }
  
}

/**-----------------------------------------------------------------------
  *@Author Madicke BALDE
  *@date 2019/09/05
  *@description search Event active by codiceFiscale
  *@param codiceFiscale : codice Fiscale of client
  *@param eventFound : Event Founded
 *-------------------------------------------------------------------------*/
public static Event appuntamentoCerca(String codiceFiscale, Boolean hasError){
    if(String.isBlank(codiceFiscale) || hasError == true){
        return null;
    }
    else {
      System.debug(' ############ ruuning appuntamentoCerca else ');
     Event   eventFound = AppuntomentoQuery.appuntomentoCercaActive(codiceFiscale);
        System.debug(' ################# test  eventFound '+eventFound);
        return eventFound;
    }
}

/**--------------------------------------------------------------------------------------
  *@Author Madicke BALDE
  *@description update Appuntamento
  *@param eventActiveFound : Event  Found to Update
  *@param hasError : check error
 *-----------------------------------------------------------------------------------*/
/*public static void upadateAppuntamento(Event eventActiveFound, Boolean hasError, Map<String,Object> eventMap){
    if(eventActiveFound == null || eventActiveFound.Id == null || hasError == true){
        return;
    }
    if(activiDate < eventActiveFound.ActivityDate ){
        AppuntamentoError.hasError = true;
        AppuntamentoError.errorMessage = 'La nuova data deve essere futura alla data precedente';
        return;
    }
    Map<String, Object> returnValue = new Map<String, Object>();
    EventDomaine.appuntamentaCerca(eventActiveFound, filiale.OCS_External_Id__c, returnValue);
    if( returnValue.get('isOk') == false){
        AppuntamentoError.hasError = true;
        AppuntamentoError.errorMessage = (String) returnValue.get('errorMessage');
        return;
    }
        makeDataEvent(eventActiveFound);
        Event evt = (Event) eventMap.get('event');
        eventActiveFound.Desk__c = evt.Desk__c;
        eventActiveFound.ActivityDate = evt.ActivityDate;
        eventActiveFound.StartDateTime = evt.StartDateTime;
        eventActiveFound.ActivityDateTime = evt.ActivityDateTime;
        eventActiveFound.EndDateTime = evt.EndDateTime;
        eventActiveFound.DurationInMinutes = evt.DurationInMinutes; 
        eventActiveFound.Stato_Azione__c ='Appuntamento modificato';
        eventUpdatedCreated = EventService.updateEvent(eventActiveFound);
        System.debug('############# update event '+eventUpdatedCreated.Id);
        if (eventUpdatedCreated.Id != null) {
           sendDEM(eventUpdatedCreated.Id, filiale.Id , 'DEM575', 'richiesta@compass.it', 'Compass Banca S.p.A.');
           
        }
        System.debug(' ##########  upadateAppuntamento event updated ############# '+eventUpdatedCreated);

} */
/**-----------------------------------------------------------------------------------------------
  *@Author Madicke BALDE 
  *@description create Appuntamento
  *@param eventActiveFound : Event Active Found
  *@param hasError : Boolean to check Error
  *@param evenToCreated : new Event Object to create
 *------------------------------------------------------------------------------------------------*/
public static void createAppuntamento(Boolean hasError,  Map<String,Object> eventMap){
    System.debug(' ################## running createAppuntamento ##################');
    if(hasError == true){
        return;
    }
     Event ev = (Event) eventMap.get('event');
     System.debug('#################### createAppuntamento event '+ev);
     makeDataEvent(ev);
     
     Calendar calendar = AppuntomentoQuery.getCalendar(filiale.OCS_External_Id__c);
     System.debug('###################### calendar '+calendar);
     ev.OwnerId = calendar.Id;
     eventUpdatedCreated = EventService.createNewEvent(ev);
     
     if(eventUpdatedCreated.Id != null){
        sendDEM(eventUpdatedCreated.Id, filiale.Id , 'DEM575', 'richiesta@compass.it', 'Compass Banca S.p.A.');
     }
    System.debug(' ############# createAppuntamento  eventCreated ########## '+eventUpdatedCreated);

}
/*public static void addCalanedar(Event ev, String codiceFiliale){
  if(String.isEmpty(codiceFiliale))
} */

/**------------------------------------------------------------------------------------------------------
  *@Author Madicke BALDE
  *@description create Event Objet
  *@param eCreated : event  to create
 *------------------------------------------------------------------------------------------------------*/
public static void  makeDataEvent( Event eCreated){
  System.debug(' ##################### makeDataEvent '+eCreated);
    setStringField(eCreated, 'Cognome__c', appuntamentoWrapper.datiCliente.cognome);
    setStringField(eCreated, 'Nome__c', appuntamentoWrapper.datiCliente.nome);
    setStringField(eCreated, 'Telefono_Cellulare__c', appuntamentoWrapper.datiCliente.cellulare);
    setStringField(eCreated, 'Comune_nascita__c', appuntamentoWrapper.datiCliente.provinciaNascita);
    setStringField(eCreated, 'utm_medium__c', appuntamentoWrapper.datiMediaUTM.utmMedium);
    setStringField(eCreated, 'utm_campaign__c', appuntamentoWrapper.datiMediaUTM.utmCampaign);
    setStringField(eCreated, 'utm_content__c', appuntamentoWrapper.datiMediaUTM.utmContent);
    setStringField(eCreated, 'utm_history__c', appuntamentoWrapper.datiMediaUTM.utmHistory);
    setStringField(eCreated, 'utm_source__c', appuntamentoWrapper.datiMediaUTM.utmSource);
    setStringField(eCreated, 'utm_term__c', appuntamentoWrapper.datiMediaUTM.utmTerm);
    setDateFields(eCreated, 'utm_date__c', appuntamentoWrapper.datiMediaUTM.utmDate);
    setIntegerField(eCreated, 'mediacodeInt__c', appuntamentoWrapper.datiMediaUTM.mediacodeInt);
    setOccupazione(eCreated, 'Tipo_Occupazione__c', appuntamentoWrapper.datiCliente.tipoOccupazione);
    setStringField(eCreated, 'mediacode__c', appuntamentoWrapper.datiMediaUTM.mediacode);
    
    eCreated.Product__c = prodotto.Id;
    customer = createAccountData(appuntamentoWrapper.datiCliente);
    eCreated.Customer__c = customer.Id;
    eCreated.WhatId = customer.Id;
    eCreated.Type='Appuntamento';
    eCreated.Subject='Appuntamento';
    eCreated.Stato_Azione__c ='GAFissato';
    eCreated.Canale_Acquisizione__C ='web';
    personContactId = customer.Id; //(getContactInformation(customer.Id)).PersonContactId;

}
public static Account getContactInformation(Id accountId){
  Account acc = AppuntomentoQuery.getPersonContactId(accountId);
  return acc;
}  
/** public static Calendar createCalendar(){
  Calendar calend = new Calendar();
  try{
    insert calend;
  }
  catch(Exception e){
    System.debug(' ###################### errorMessage '+e.getMessage());
    System.debug(' ###################### errorMessage '+e.getStackTraceString());
  }
  return calend;
} */
 /**-------------------------------------------------------------------------------
   *@Author Madicke BALDE
   *@description 
   *@date 2019/09/05
   *@param Dati client
   *@return Account
  *-------------------------------------------------------------------------------*/
 public static Account createAccountData(AppuntamentoWService.DatiCliente cliente){
       Id recordTypeId = CGMWSUtils_1_0.getRecordTypeId('Account', 'PersonAccount');
        Account acc = new Account();
        System.debug('************  recordTypeId '+recordTypeId);
        Map<Account, Account> accountMap = new Map<Account, Account>();
        XCSModuloAnagraficaUtils.setStringField(acc, 'LastName', cliente.nome);
        //acc.LastName = cliente.cognome;
         XCSModuloAnagraficaUtils.setStringField(acc, 'FirstName', cliente.cognome);
       // acc.FirstName = cliente.nome;
      //  acc.PersonEmail = cliente.email;
      //
        // XCSModuloAnagraficaUtils.setStringField(acc, 'RSS_External_Id__c', cliente.email);
         XCSModuloAnagraficaUtils.setStringField(acc, 'PersonEmail', cliente.email);
         XCSModuloAnagraficaUtils.setStringField(acc, 'Sesso__pc', cliente.sesso);
       // acc.Codice_Fiscale__c = cliente.codiceFiscale; 
         XCSModuloAnagraficaUtils.setStringField(acc, 'Codice_Fiscale__c', cliente.codiceFiscale);
         XCSModuloAnagraficaUtils.setStringField(acc, 'Codice_Fiscale__pc', cliente.codiceFiscale);
       // acc.Codice_Fiscale__pc = cliente.codiceFiscale;
       XCSModuloAnagraficaUtils.setPhoneField(acc, 'PersonHomePhone', cliente.cellulare);
        XCSModuloAnagraficaUtils.setPhoneField(acc, 'Phone', cliente.cellulare);
        XCSModuloAnagraficaUtils.setPhoneField(acc, 'PersonMobilePhone', cliente.cellulare);
       // acc.PersonHomePhone = cliente.cellulare;
       // acc.PersonBirthdate = cliente.dataNascita;
       // acc.Birthprovince__c = cliente.provinciaNascita;
        XCSModuloAnagraficaUtils.setStringField(acc, 'Birthcity__c', cliente.localitaNascita);
        XCSModuloAnagraficaUtils.setStringField(acc, 'Birthprovince__c', cliente.provinciaNascita);
        //XCSModuloAnagraficaUtils.setDateField(acc,'PersonBirthdate',cliente.dataNascita);
        String birthDate=cliente.dataNascita;
        if(birthDate.length()==8) acc.PersonBirthdate= Date.newInstance (Integer.valueOf(birthDate.substring(0,4)),
          Integer.valueOf(birthDate.substring(4,6)) , Integer.valueOf(birthDate.substring(6,8)));
        XCSModuloAnagraficaUtils.setBooleanField(acc, 'Privacy_Profilazione__pc', cliente.privacyProfilazione);
        XCSModuloAnagraficaUtils.setBooleanField(acc, 'OtherService__pc', cliente.privacyOtherservice);
        XCSModuloAnagraficaUtils.setBooleanField(acc, 'Extcommoffer__pc', cliente.privacyExtcommoffer);
        XCSModuloAnagraficaUtils.setBooleanField(acc, 'Interncommoffer__pc', cliente.privacyInterncommoffer);
        //SET RESIDENZA
        XCSModuloAnagraficaUtils.setStringField(acc, 'ShippingCity',cliente.localitaResidenza);
        XCSModuloAnagraficaUtils.setStringField(acc, 'ShippingStreet',cliente.indirizzoResidenza);
        XCSModuloAnagraficaUtils.setStringField(acc, 'ShippingState',cliente.siglaProvinciaResidenza);
        XCSModuloAnagraficaUtils.setStringField(acc, 'ShippingPostalCode',cliente.capResidenza);

        //TODO
        String tipoOccupazione= cliente.tipoOccupazione;
       
        if(!String.isBlank(tipoOccupazione)){
           String[]  occupazioneLevels= tipoOccupazione.split(';',2);
         //tipoOccupazioneLvl1=tipoOccupazione.substringBefore(';');               
          XCSModuloAnagraficaUtils.setStringField(acc, 'Occupation_Lvl1__c', occupazioneLevels[0]);
          if (occupazioneLevels.size()>1)  XCSModuloAnagraficaUtils.setStringField(acc, 'Occupation_Lvl2__c',occupazioneLevels[1] );
          else XCSModuloAnagraficaUtils.setStringField(acc, 'Occupation_Lvl2__c','' );
        }
        accountMap.put(acc, null);
         XCSGestioneAnagrafica.execute(accountMap, false, false);
       // XCSGestioneAnagrafica.execute(accountMap, true, true);
      //XCSGestioneAnagrafica.deduplica(accountMap, false);
        System.debug('########### accountMap.get(acc) '+accountMap.get(acc));
        System.debug('**************** Account Id ****** '+ accountMap.get(acc).Id);
        return  accountMap.get(acc);
    }

/**------------------------------------------------------------------------------
  * @Author Madicke BALDE
  * @description  
  * @date
 **------------------------------------------------------------------------------*/  
public static void setStringField(Event ev , String fieldName, String fieldValue){
    System.debug('************* runnginh  setStringField ******* '+fieldName + '####### value '+ fieldValue);
    try{
           if(fieldValue == null) return;
    if(fieldValue.trim().equals('')) ev.put(fieldName, null);
    else ev.put(fieldName, fieldValue);
    }
    catch(Exception e){
      System.debug('################# errorMessage setStringField '+e.getMessage());
       System.debug('################# errorMessage setStringField '+e.getStackTraceString() );
    }
   
       
}
 /** -------------------------------------------------------------------------------
   *@Author Madicke BALDE
   *@description 
   *@param
   *@param 
   *@param
  *-------------------------------------------------------------------------------*/
 public static void setDateFields(Event ev, String fieldName, String fieldValue){
      if(fieldValue == null) return;
      if(fieldValue.trim().equals('')) ev.put(fieldName, null);
      else ev.put(fieldName, CGMWSUtils_1_0.formatStringToDate(fieldValue));
   }


/**------------------------------------------------------------------------------
  *@Author Madicke BALDE
  *@description
  @date 2019/08/29
  *@param
  *@param
   @param 
 *------------------------------------------------------------------------------*/
public static void setOccupazione(Event ev, String fieldName, String fieldValue){
   System.debug(' ######################## running   setOccupazione');
  System.debug(' ############### fieldName '+fieldName);
  if(fieldValue == null) return;
  if(fieldValue.trim().equals('')) ev.put(fieldName, null);
  else {
   List<SelectOption> listSelect = AppuntamentoDomain.getOccupazioneValue();
    for(SelectOption sele : listSelect){
            System.debug('############# getValue ###### '+sele.getValue());
            if(sele.getValue() == fieldValue.substringBefore(';')){
              System.debug(' ############### '+sele);
              ev.put(fieldName, sele.getLabel());
               break;
            }
        }
   
  }
}
/**----------------------------------------------------------------------------
  *@Author Madicke BALDE
  *@description
  *@date
  *@param 
  *@param
  *@param
 *-----------------------------------------------------------------------------*/
public static void setIntegerField(Event ev, String fieldName, String fieldValue){
  System.debug(' ######################## fieldName  '+fieldName);
  if(fieldValue == null) return;
  if(fieldValue.trim().equals('')) ev.put(fieldName, null);
  else {
    Integer nbre = Integer.valueOf(fieldValue);
    ev.put(fieldName, fieldValue);
    System.debug(' ######################## finish  '+fieldName);
  }
}

/**---------------------------------------------------------------------------------
  *@Author Madicke BALDE
  *@description
  *@param appuntamento appuntamento Wrapper
  *@return Map<String,Object>
 *---------------------------------------------------------------------------------*/
public static Map<String,Object> appuntamentoModifica(AppuntamentoWService.AppuntamentoModifica appuntamento){
        Map<String, Object> returnValue = new Map<String, Object>();
        Map<Id, Object> mapDeskSlot = new Map<Id, Object>();
        Event event = new Event();
        Account filiale = AppuntomentoQuery.getFiliale(appuntamento.codFiliale);
        Account customer = AppuntomentoQuery.getClientByCodeFiscale(appuntamento.codiceFiscale); 
        Event ev = checkAppuntamentoExistence(appuntamento.oppID);
        if(ev == null || ev.Id == null ) throw new CGMWSUtils_1_0.CGMWSRException('[KO-APP0001]', appuntamento.oppID );
        Date dt = CGMWSUtils_1_0.formatStringToDate(appuntamento.data);
        
        if(!consistencyCheck(customer,ev)){ //controllo coerenza Account ed Appuntamento
          AppuntamentoError.hasError = true;
          AppuntamentoError.errorMessage='CF e ID appuntamento non sono coerenti';
          AppuntamentoError.resultMessage='CF e ID appuntamento non sono coerenti';
        } else {
          if(checkifdataValide(dt, ev.ActivityDate )){
            listDesks = filiale.XCS_Desk__r;
            appuntoDate = appuntamento.data;
            appuntamentoDisponibilita(filiale, dt, mapDeskSlot);
            Map<String,Object> eventMap = checkDisponilitaOra(appuntamento.ora, mapDeskSlot, dt, AppuntamentoError.hasError);
            System.debug(' ##################  eventMap modifica '+eventMap);   
            System.debug(' ##################  AppuntamentoError.hasError '+AppuntamentoError.hasError);
            System.debug(' ##################  AppuntamentoError.errorMessage '+AppuntamentoError.errorMessage);
            System.debug(' ########### ev Before '+ev.DurationInMinutes);
            System.debug(' ########### ev Before dateTime '+ev.ActivityDateTime);
            updateAppuntamento(ev , (Event) eventMap.get('event'),AppuntamentoError.hasError);
            returnValue.put('event',  ev);
            System.debug(' ########### eventUpdated '+ev.ActivityDateTime);
        }
        else {
            /*AppuntamentoError.hasError = true;
            AppuntamentoError.errorMessage='The new appointment date must be future and not passed';*/
          //  AppuntamentoError.codeErreor ='[ERR00APM001]';
        }
        }
        
        
        
           return returnValue;
    }

    public static Boolean consistencyCheck (Account acc,Event appuntamento){
        System.debug('----consistencyCheck----');
        System.debug('Account-->'+acc);
        System.debug('Appuntamento-->'+appuntamento);
        return acc.ID == appuntamento.AccountID;
    }


     /**
      *@Author Madicke BALDE
      *@description check if new Date is grater than the old Date
      *@param newDate : new Date
      *@param dateToUpdate : old date
      *@return Booleqn
     */
    public static Boolean checkifdataValide(Date newDate, Date dateToUpdate){
      System.debug(' *********** newDate '+newDate);
      System.debug(' *********** dateToUpdate '+dateToUpdate);
      if(dateToUpdate<System.today()) {
        AppuntamentoError.hasError = true;
        AppuntamentoError.errorMessage='L\'appuntamento che si sta cercando di modificare è passato';
        AppuntamentoError.resultMessage='L\'appuntamento che si sta cercando di modificare è passato';
        return false;
      }
      //if(newDate < dateToUpdate ){
      if(newDate < System.today() ){
        System.debug(' ************* checkifdataValide false ');
        AppuntamentoError.hasError = true;
        AppuntamentoError.errorMessage='La nuova data non è futura';
        AppuntamentoError.resultMessage='La nuova data non è futura';
        return false;
      }
      else {
        System.debug(' ************* checkifdataValide true ');
        return true;
      }
    }
  /**---------------------------------------------------------------------------------------
      *@Author Madicke BALDE
      *@description check appuntamento 
      *@date 2019/08/27
      *@param oppID : ID appuntamento
      *@return Event
     *---------------------------------------------------------------------------------------*/

/**---------------------------------------------------------------------------------------------------------
  *@Auhtor Madicke BALDE
  *@description  check if appuntamento Existe
  *@param Id appuntamento
  *@return Event
 *--------------------------------------------------------------------------------------------------------*/
public static Event checkAppuntamentoExistence(String oppID){
        System.debug('############## running  checkAppuntamentoExistence oppID' +oppID);
      if(String.isNotBlank(oppID)){
        System.debug('############## checkAppuntamentoExistence');
        Event ev = AppuntomentoQuery.getEventById(oppID);
        return ev;
      }
      else {
        return null;
      }
}

 

  public static void appuntamentoDisponibilita(Account filiale, Date dateAppuntamento,  Map<Id, Object> mapDeskSlot){
      appuntamentoDisponibilita(filiale,dateAppuntamento, mapDeskSlot,minutesSlotDefault);
  }

 /**---------------------------------------------------------------------------------
   *@Auhtor Madicke BALDE
   *@description check disponibilita of Filiale
   *@@param filiale : the Filiale
   *@param dateAppuntamento : Date appuntamento
  *----------------------------------------------------------------------------------*/
 public static void appuntamentoDisponibilita(Account filiale, Date dateAppuntamento,  Map<Id, Object> mapDeskSlot, Integer minutesSlot){
     if( filiale == null  || filiale.Id == null ){
       return;
     }
        
     else {
        System.debug('################### appuntamentoDisponibilita hasError '+AppuntamentoError.hasError);
        System.debug(' ###################  appuntamentoDisponibilita running');
        disponibilitaDesk(filiale.XCS_Desk__r, dateAppuntamento, mapDeskSlot, filiale.OCS_External_Id__c ,minutesSlot);
        //  cercaDisponibilita(filiale.XCS_Desk__r, dateAppuntamento, mapDeskSlot);
          //  Map<Id, Object> mapDeskSlot = new Map<Id, Object>();
        /*  Map<String, List<Event>> mpDataEvent = new Map<String, List<Event>>();
          List<Event> events = getEventByDesk(filiale.XCS_Desk__r, dateAppuntamento);
          System.debug(' ###################  appuntamentoDisponibilita events'+events);
          groupEventByType(events, mpDataEvent);
          getSlotDesk(mpDataEvent,mapDeskSlot, AppuntamentoError.hasError); */
          System.debug(' #################  mapDeskSlot  appuntamentoDisponibilita  '+mapDeskSlot);
          System.debug(' #################  ErrorMessage  '+AppuntamentoError.errorMessage);
     }
}

 public static List<Slot>  appuntamentoDisponibilitaCompleta(Account filiale, Date appuntamentoDate, Map<Id, Object> mapDeskSlot){

    if( filiale == null  || filiale.Id == null ){
             return null;
     }
     else {
            List<Slot> slotlist = new List<Slot>();
            System.debug('################### appuntamentoDisponibilita hasError '+AppuntamentoError.hasError);
            System.debug(' ###################  appuntamentoDisponibilita running');
            slotlist =   disponibilitaCompleta(filiale.XCS_Desk__r, appuntamentoDate, mapDeskSlot, filiale.OCS_External_Id__c);
            System.debug('############### appuntamentoDisponibilitaCompleta '+slotlist);
            System.debug(' #################  mapDeskSlot  appuntamentoDisponibilita  '+mapDeskSlot);
            System.debug(' #################  ErrorMessage  '+AppuntamentoError.errorMessage);
            return slotlist;
         }
      
    }
  

public static  Set<Time> appuntamentoDisponilitaCompleta(String codeFiliale, String appuntamentoDate){
  return  appuntamentoDisponilitaCompleta(codeFiliale,appuntamentoDate,minutesSlotDefault);
}

/**
  *@Author Madicke BALDE
  *@description 
  *@param codeFiliale
  *@param appuntamentoDate
  *@return Map<String,Object>
 */
public static  Set<Time> appuntamentoDisponilitaCompleta(String codeFiliale, String appuntamentoDate,Integer minutesSlot){

    currentDateTime = Datetime.now();
     System.debug(' ############################# currentDateTime  '+currentDateTime);
  System.debug(' ############################# codeFiliale  '+codeFiliale);
  Map<Id, Object> mapDeskSlot = new Map<Id, Object>();
   Set<Time> slotList = new  Set<Time>();
  try {
        String cf = (codeFiliale.contains('F'))?codeFiliale.substringAfter('F'):codeFiliale;
        System.debug('############## CF'+cf);
        Account filiale = getFilialeByCodiceCliente(cf);
        if(filiale == null || filiale.Id == null) throw new CGMWSUtils_1_0.CGMWSRException('[KO-FILIALE001]','');
        System.debug(' ############# controllNumberOfdaysGreater15 filiale '+filiale);
        Date appuntDate =  CGMWSUtils_1_0.formatStringToDate(appuntamentoDate);
        if(controllNumberOfdaysGreater15(appuntDate) ){
            System.debug(' ############# controllNumberOfdaysGreater15 is Ok ');
            listDesks = filiale.XCS_Desk__r;
            appuntoDate = appuntamentoDate;
            System.debug('########################################  filiale.XCS_Desk__r '+ filiale.XCS_Desk__r);
            System.debug(' ############## fililale '+filiale);
            appuntamentoDisponibilita(filiale, appuntDate, mapDeskSlot,minutesSlot);
            System.debug(' ############## mapDeskSlot test test '+mapDeskSlot);
        
            slotList = getAllSlots(mapDeskSlot);
            
            filterOraAppuntamento(slotList,appuntDate );
        }
        else {
             AppuntamentoError.hasError = true;
             AppuntamentoError.errorMessage = 'Un appuntamento non può essere fissato in questa data : '+appuntDate;
             AppuntamentoError.resultMessage = 'Un appuntamento non può essere fissato in questa data : '+appuntDate;
        }
         System.debug( ' ################ AppuntamentoError.errorMessage  '+AppuntamentoError.errorMessage);
        System.debug( ' ################ slot fililale  '+slotList);

    
  } catch (Exception e) {
     AppuntamentoError.hasError = true;
    System.debug(' ############## errorMessage '+e.getMessage());
    System.debug(' ############## errorMessage '+e.getStackTraceString() );
  }

  return slotList;
}


public static  List<Slot>  appuntamentoCompleta(String codeFiliale, String appuntamentoDate){
    currentDateTime = Datetime.now();
    System.debug(' ############################# currentDateTime  '+currentDateTime);
    System.debug(' ############################# codeFiliale  '+codeFiliale);
    Map<Id, Object> mapDeskSlot = new Map<Id, Object>();
    Set<Time> slotList = new  Set<Time>();
     List<Slot> listSlots =  new  List<Slot> ();
    try {
          String cf = (codeFiliale.contains('F'))?codeFiliale.substringAfter('F'):codeFiliale;
          System.debug('############## CF'+cf);
          Account filiale = getFilialeByCodiceCliente(cf);
          if(filiale == null || filiale.Id == null) throw new CGMWSUtils_1_0.CGMWSRException('[KO-FILIALE001]','');
          System.debug(' ############# controllNumberOfdaysGreater15 filiale '+filiale);
          Date appuntDate =  CGMWSUtils_1_0.formatStringToDate(appuntamentoDate);
          if(controllNumberOfdaysGreater15(appuntDate) ){
          System.debug(' ############# controllNumberOfdaysGreater15 is Ok ');
          listDesks = filiale.XCS_Desk__r;
          appuntoDate = appuntamentoDate;
          System.debug('########################################  filiale.XCS_Desk__r '+ filiale.XCS_Desk__r);
          System.debug(' ############## fililale '+filiale);
          
          listSlots = appuntamentoDisponibilitaCompleta(filiale, appuntDate, mapDeskSlot);
          System.debug(' ############## listSlots final test '+listSlots);
          }
          else {
                AppuntamentoError.hasError = true;
                AppuntamentoError.errorMessage = 'Un appuntamento non può essere fissato in questa data : '+appuntDate;
                AppuntamentoError.resultMessage = 'Un appuntamento non può essere fissato in questa data : '+appuntDate;
          }
          System.debug( ' ################ AppuntamentoError.errorMessage  '+AppuntamentoError.errorMessage);
          System.debug( ' ################ slot fililale  '+slotList);
    } catch (Exception e) {
              AppuntamentoError.hasError = true;
              System.debug(' ############## errorMessage '+e.getMessage());
              System.debug(' ############## errorMessage '+e.getStackTraceString() );
    }

  return listSlots;

}
public static void updateAppuntamento(Event evUpdated, Event evReturned, Boolean hasError){
  try {
    System.debug(' ############# running updateAppuntamento ');
    if(hasError){
      return;
    }
    else {
       System.debug( ' ############### evReturned '+evReturned);
      Event e = new Event();
       System.debug(' ############# running updateAppuntamento else ');
     //  makeDataEvent(evUpdated);
       evUpdated.Desk__c = evReturned.Desk__c;
       evUpdated.ActivityDate = evReturned.ActivityDate;
       evUpdated.StartDateTime = evReturned.StartDateTime;
       evUpdated.ActivityDateTime = evReturned.ActivityDateTime;
       evUpdated.EndDateTime = evReturned.EndDateTime;
       evUpdated.DurationInMinutes = evReturned.DurationInMinutes;
       e = EventService.updateEvent(evUpdated);
       if(e.Id != null){
         sendDEM(e.Id, filiale.Id , 'DEM575', 'richiesta@compass.it', 'Compass Banca S.p.A.');
       }
       System.debug(' ##################### eee '+e);
    }
    
  } catch (Exception e) {
    System.debug(' ############### errorMessage '+e.getMessage());
    System.debug(' ############### errorMessage '+e.getStackTraceString() );
  }
  
}
public static Set<Time> getAllSlots(Map<Id,Object> mapSlots){
   Set<Time> slots = new Set<Time>();
    if(mapSlots != null || mapSlots.keySet().size() > 0){
          for(Id key : mapSlots.keySet() ){
            List<Set<Time>> ltimes = (List<Set<Time>>)mapSlots.get(key);
            for(Set<Time> times :  ltimes ){
              slots.addAll(times);
            }
        //  slots.addAll( (List<Set<Time>> )mapSlots.get(key) );
    }
    }
    List<Time>  timeSlots = new List<Time>(slots);
    timeSlots.sort();
     Set<Time> slotsSet = new Set<Time>(timeSlots);
    return slotsSet;
}
public static Set<Time> getSlotFiliale(Map<Id,Object> mapSlots){
      Set<Time> slots = new Set<Time>();
      if(mapSlots != null || mapSlots.keySet().size() > 0){
          for(Id key : mapSlots.keySet() ){

             slots.addAll( (Set<Time>) mapSlots.get(key) );

          }

      }
      List<Time>  timeSlots = new List<Time>(slots);
      timeSlots.sort();
      Set<Time> slotsSet = new Set<Time>(timeSlots);
      List<Time> listTime = new List<Time>(slotsSet);
      Integer taille = listTime.size()-1;
      Time elemn = listTime[taille];
      Boolean b = slotsSet.remove(elemn);
      return slotsSet;
}


/*public static String appuntamentoOccupazionniFiliale(String dateIni, String dateEnd, String codeFiliale){
    try {
        Account filiale = ckeckFilialeExistence(codeFiliale);
        Map<String,Date> mapDataString =  EventDomaine.getListDateString(dateIni, dateEnd);
        System.debug(' ################# mapDataString '+mapDataString);

      
     } 
     catch (Exception e) {
          System.debug(' ################## errorMessage '+e.getMessage());
          System.debug(' ################## errorMessage '+e.getStackTraceString() );
    }
    return '';
}  */
/**-------------------------------------------------------------------------
  *@Author Madicke BALDE
  *@description  search Customer by Codice Fiscale Or Codice OCS
  *@param codiceFiscale : codice Fiscale
  *@param codiceOcs : Codice Cliente
  *@return Account
 *------------------------------------------------------------------------------*/
public static Account getCustumerByCodice(String codiceFiscale, String codiceOcs){
    Account acc = new Account();
    Set<String> fields = new Set<String>();
    if(String.isNotBlank(codiceFiscale)){
        fields.add(codiceFiscale);
    }
    if(String.isNotEmpty(codiceOcs)){
        fields.add(codiceOcs);
    }
    acc = AppuntomentoQuery.getCustomer(fields);
   return acc;
}

/**-----------------------------------------------------------------------------
  *@Author Madicke BALDE
  *@description this method recover all occupied slot for this Branch
  *@param codeFiliale 
  *@param appuntamentoDate
 *-----------------------------------------------------------------------------------*/
public static  Map<Id, Set<Time>> getSlotOccupatoByDesk(String codeFiliale, Date appuntamentoDate){
  System.debug(' ############## runiing ################# ');
  List<Event> eventList = new List<Event>();
   Map<Id, Set<Time>> slotMap = new  Map<Id, Set<Time>> ();
 try {
       eventList =  AppuntomentoQuery.getSlotOccupatoQuery(codeFiliale, appuntamentoDate);
       if(eventList.size() > 0 ){
         Map<Id, List<Event>> returValue = getSlotDeskEvent(eventList);
         System.debug(' ############## returValue getSlotOccupatoByDesk '+returValue);
         slotMap = slotOccupato(returValue);
         System.debug(' ############## getSlotOccupatoByDesk slotMap '+slotMap);
       }
   
 } catch (Exception e) {
         System.debug(' ################ errorMessage '+e.getMessage());
         System.debug(' ################ errorMessage '+e.getStackTraceString() );
 }
 return slotMap;
}

/*public static  Map<Date, Integer> getSotOccupatoForFiliale(String codeFiliale, List<Date> appuntamentoDateList){
        System.debug(' ############## runiing ################# ');

        List<Event> eventList = new List<Event>();
        Map<Id, Set<Time>> slotMap = new  Map<Id, Set<Time>> ();
        Map<Date, Set<Id>> dateSetMap = new Map<Date, Set<Id>>();
        Map<Date, Integer> maxApp = new  Map<Date, Integer>();
        try{

              eventList = AppuntomentoQuery.getOccupatoSlotFiliale(codeFiliale, appuntamentoDateList);
              if(eventList.size() > 0 ){
                    Map<Id, List<Event>> returValue = getSlotDeskEvent(eventList);

                    System.debug(' ############## returValue getSlotOccupatoByDesk '+returValue);
                    slotMap = slotOccupato(returValue);
                    System.debug(' ############## getSlotOccupatoByDesk slotMap '+slotMap);
                    groupDateDesk(eventList, dateSetMap);
                    Map<Date, Object> mValue =  groupeSlotByDate(slotMap,  dateSetMap);
                    System.debug(' ################ mValue' +mValue);
                    maxApp  = numberMaxAppuntamentoBranch (mValue, appuntamentoDateList);
                    System.debug(' ####################### maxApp '+maxApp);
               }
        }
        catch(Exception e){
                  System.debug(' ################ errorMessage '+e.getMessage());
                  System.debug(' ################ errorMessage '+e.getStackTraceString() );
        }
        return maxApp;

} */

/**-------------------------------------------------------------------
  *@Author Madicke BALDE
  *@description 
  *@param  events
  *@return Map<Id, List<Event>>
 *----------------------------------------------------------------------*/
public static Map<Id, List<Event>> getSlotDeskEvent(List<Event> events){
    System.debug(' ############### getSlotDeskEvent running ################## ');
    Map<Id, List<Event>> mapData = new Map<Id, List<Event>>();
    for(Event ev : events){
      System.debug(' ############ getSlotDeskEvent type  '+ev.Type);
      System.debug(' ############ StartDateTime  '+ev.StartDateTime);
       System.debug(' ############ EndDateTime  '+ev.EndDateTime);
      if(!mapData.containsKey(ev.Desk__c)){
         mapData.put(ev.Desk__c, new List<Event>{ev});
      }
      else {
       // mapData.put(ev.Desk__c, (List<Event>) mapData.get(ev.Desk__c).add(ev));
       mapData.get(ev.Desk__c).add(ev);
      }
    }
    return mapData;
}


public static Map<Id, Set<Time>> slotOccupato(Map<Id, List<Event>> mp){
  System.debug(' ################## slotOccupato  '+mp);
    Map<Id, Set<Time>> mapSlot = new Map<Id, Set<Time>>();
    for(Id key: mp.keySet()){
     // Set<Time> slots = getSlotList(mp.get(key)); occupareSlot
     Set<Time> slots = occupareSlot(mp.get(key));
      mapSlot.put(key, slots);
    }
    System.debug(' ########### mapSlot');
    return mapSlot;
}



public static Set<Time> getSlotList(List<Event> events){
    return getSlotList(events,minutesSlotDefault);
}

/**---------------------------------------------------------------------
  *@Author Madicke BALDE
  *@description get List Slot for a Desk
  *@param events : List<Event>
  *@return Set<Time>
 *-------------------------------------------------------------------------*/
public static Set<Time> getSlotList(List<Event> events,Integer minutesSlot){
  System.debug(' ################## getSlotList '+events);
   Set<Time> listTime = new Set<Time>();
   for( Event ev : events){
      System.debug(' ################## getSlotList startTime '+ev.startDateTime);
       System.debug(' ################## getSlotList endTime '+ ev.endDateTime.time());
      Datetime dt = ev.startDateTime;
      System.debug(' ################## getSlotList dt '+ dt );
      Time startTime = ev.startDateTime.time();
      

      Time endTime = ev.endDateTime.time();
      Time t = startTime.addMinutes(minutesSlot);
      while (t <= endTime) {
        listTime.add(startTime);
        listTime.add(t);
        startTime = t;
        t= t.addMinutes(minutesSlot);
    }
   }
    return listTime;
}

/**--------------------------------------------------------------------
  *@Author Madicke BALDE
  *@description 
  *@
 *-------------------------------------------------------------------*/
public static  Set<Time> occupareSlot(List<Event> events){
   Set<Time> listTime = new Set<Time>();
   for(Event ev : events){
      System.debug('################ startTime '+ev.startDateTime);
      System.debug('############# Time '+ev.startDateTime.time());
      listTime.add(ev.startDateTime.time());
   }
   return listTime;
}
/**-------------------------------------------------------------------------
  *@Author Madicke BALDE
  *@description 
  *@param 
  *@return Boolean
 *-------------------------------------------------------------------------*/
public static void filterOraAppuntamento(Set<Time> timeSlots, Date appuntamentoDate){
  System.debug(' ################ ruuning filterOraAppuntamento #################### '+currentDateTime.time());
  //  Datetime dtNow = Datetime.now();
    Time initTime = Time.newInstance(0, 0, 0, 0);
    Time endTime = Time.newInstance(15, 59, 0, 0);
    XCS_CompassParameters__c xcs = XCS_CompassParameters__c.getValues('Ora_Di_Fine');
    Time oraDiFine = xcs.Intervallo_Di_Appuntamenti__c.Time();  
    XCS_CompassParameters__c oraInizio = XCS_CompassParameters__c.getValues('Ora_Di_Inizio');
    Time oraDiInizio = oraInizio.Intervallo_Di_Appuntamenti__c.Time();
    System.debug(' ############# oraDiInizio '+oraDiInizio);
    System.debug(' ############# Ora_Di_Fine '+oraDiFine);
    boolean isSFAUser=RoleUtils.isSFAUser();
  
    if(appuntamentoDate == currentDateTime.date() && ( ( oraDiInizio <= currentDateTime.time() && currentDateTime.time() <= oraDiFine ) || isSFAUser)){
      for(Time t : timeSlots)
        if(t  <= currentDateTime.time()){
          System.debug(' ###### OK '+t);
          Boolean b = timeSlots.remove(t);
        }
    }     
    else if(!isSFAUser && appuntamentoDate == currentDateTime.date()){
      AppuntamentoError.hasError = true;
      AppuntamentoError.errorMessage = 'No ora disponible';
      AppuntamentoError.resultMessage = 'No ora disponible';
      timeSlots.clear();
    }    
        
}
/**-----------------------------------------------------------------------------------
  *@Auhtor Madicke BALDE
  *@param codiceFiscale : Codice Fiscale
  *@param codiceOcs : Codice OCS
  *@return List<Event>
 *-------------------------------------------------------------------------------------*/
public static List<Event> getEventByCodeOcsFiscale(String codiceFiscale, String codiceOcs ){
   List<Event> events = new List<Event>();
    Set<String> fields = new Set<String>();
    if(String.isNotBlank(codiceFiscale)){
        fields.add(codiceFiscale);
    }
    if(String.isNotEmpty(codiceOcs)){
        fields.add(codiceOcs);
    }
    events = AppuntomentoQuery.appuntamentoCercaByOcsFiscale(fields);
   return events;
}

/**----------------------------------------------------------------------------
  *@Author Madicke BALDE
  *@description
  *@param appuntamentoDate : Date appuntamento
  *@return Boolean
 *----------------------------------------------------------------------------*/
public static Boolean controllNumberOfdaysGreater15(Date appuntamentoDate){
  System.debug(' ############ controllNumberOfdaysGreater15 ####'+appuntamentoDate);
  Boolean isValid = false;
  Date dateNow = Date.today();
  Integer numberOfDay ;
  if(dateNow < appuntamentoDate){
       System.debug(' ############ OK ####');
       numberOfDay = dateNow.daysBetween(appuntamentoDate);
       System.debug(' ###################  numberOfDay '+numberOfDay);
       if(numberOfDay > 15 ) isValid = true;
       return !isValid;
  }
  if(dateNow == appuntamentoDate){
    isValid = false;
    return !isValid;
  }
  else  {
     isValid = true;
     return !isValid;
  }
    
}


public static Set<Time> disponibilitaAppuntamento(Account filiale, Date appuntamentoDate){
  Map<Id, Object> mapDeskSlot = new Map<Id, Object>();
   Set<Time> slotList = new  Set<Time>();
   currentDateTime = Datetime.now();
   System.debug('######################## currentDateTime '+currentDateTime);

   if(controllNumberOfdaysGreater15(appuntamentoDate) ){
      appuntoDate = CGMWSUtils_1_0.ToString(appuntamentoDate);
      appuntamentoDisponibilita(filiale, appuntamentoDate, mapDeskSlot);
      System.debug(' ############## mapDeskSlot test '+mapDeskSlot);
     
      slotList = getAllSlots(mapDeskSlot);

      filterOraAppuntamento(slotList,appuntamentoDate );
      System.debug(' #####################  slotList '+slotList);

   }
   else {
        AppuntamentoError.hasError = true;
        AppuntamentoError.errorMessage = 'Un appuntamento non può essere fissato in questa data : '+appuntamentoDate;
        AppuntamentoError.resultMessage = 'Un appuntamento non può essere fissato in questa data : '+appuntamentoDate;
   }
  return slotList;
}


/*public static String appuntamentoOccupazionniFiliale(Date dateIni, Date dateEnd, Account Filiale){
   String response;
  try {
   
      Map<Id, Object> mapDeskSlot = new Map<Id, Object>();
       Map<String, List<Event>> mapDeskEvent = new Map<String, List<Event>>();
      List<Date> listDate = getListDate(dateIni, dateEnd );
      List<Event> events = AppuntomentoQuery.getEventCodeFilialeDate(filiale.OCS_External_Id__c, listDate);
      Map<Date, List<Event>> mapDate = new Map<Date, List<Event>>();
      Map<Id, List<Event>> mapEventDesk= new Map<Id, List<Event>>();
      Map<Date, Set<Id>> dateSetMap = new Map<Date, Set<Id>>();
      getEventByDeskEvent(events, mapEventDesk);
      groupEventByType(events, mapDeskEvent);
      getSlotDeskDisponibilita(mapDeskEvent, mapDeskSlot);
      getSlotDeskInDisponibilita(mapDeskEvent, mapDeskSlot);
      getSlotDeskFestivita(mapDeskEvent, mapDeskSlot);
      System.debug(' ################## getSlotDesk  mapDeskSlot '+mapDeskSlot);
      groupDateDesk(events, dateSetMap);
      System.debug(' ################## dateSetMap  dateSetMap '+dateSetMap);
      Map<Date, Object> returnValue =  groupeSlotByDate(mapDeskSlot,  dateSetMap);
      System.debug(' ################## returnValue  returnValue '+returnValue);
      System.debug(' ################## returnValue  returnValue '+returnValue.values().size());
    // groupEventByDate(events, mapDate);
      Map<Date, Integer> maxApp  = numberMaxAppuntamentoBranch (returnValue, listDate);
      Map<Date, Integer> mapMaxSlotOccupatoByDate = getSotOccupatoForFiliale(filiale.OCS_External_Id__c, new List<Date>(maxApp.keySet()));
      System.debug(' ####################### maxApp '+maxApp);
      System.debug(' ####################### mapMaxSlotOccupatoByDate '+mapMaxSlotOccupatoByDate);
     response = CalcolaNumeroMassimo(maxApp,mapMaxSlotOccupatoByDate);
    
  } catch (Exception e) {
          System.debug(' ############### errorMessage '+e.getMessage());
          System.debug(' ############### errorMessage '+e.getStackTraceString() );
    
  }
  return response;
} */
 
/**-----------------------------------------------------------------------------------------------------
  *@Author Madicke BALDE
  *@description
  *@param maxApp : This map contains for each date the number of appointments by a Filiale
  *@param mapMaxSlotOccupatoByDate : this map contains for each date the number of slot occupated
  *@return String
 *---------------------------------------------------------------------------------------------------------*/
public static String CalcolaNumeroMassimo(Map<Date, Integer> maxApp, Map<Date, Integer> mapMaxSlotOccupatoByDate ){
     Map<Date, Object> objectMap = new Map<Date, Object>();
     System.debug('################# maxApp '+maxApp);
     List<Date> lstDate=new List<Date>(maxApp.keySet());
     lstDate.sort();
     for(Date d : lstDate){
        if(maxApp.get(d) == 0){
        //if(mapMaxSlotOccupatoByDate.get(d) == 0){
           objectMap.put(d,'C');
         }
        else if(maxApp.get(d) <= mapMaxSlotOccupatoByDate.get(d)){          
              objectMap.put(d,'C');
         }
         else {
              System.debug('################# mapMaxSlotOccupatoByDate.get(d)  '+mapMaxSlotOccupatoByDate.get(d));
              Double pourcentage = (Double.valueOf(mapMaxSlotOccupatoByDate.get(d)) / Double.valueOf(maxApp.get(d)) ) *100;
              System.debug('################# mapMaxSlotOccupatoByDate.get(d)  '+pourcentage );
              objectMap.put(d, pourcentage.intValue() );
         }
     }
     System.debug(' ################ objectMap '+objectMap);
    String response = parseResponse(objectMap);
    System.debug(' ################ response '+response);
    return response;
}

/**
     *@Author Madicke  Madicke
     *@description
     *@param returnValue
     *@return String
    */
public static String parseResponse(Map<Date,Object>  returnValue ){
     String chaine = '';
     if(returnValue != null && returnValue.keySet().size() > 0 ){
       for (Date key :  returnValue.keySet()) {
            chaine += returnValue.get(key)+'|';
       }
     }
     System.debug(' ############## chaine before remove ####### '+chaine);
     return chaine.removeEnd('|');
   }

public static  Map<Date, Integer> numberMaxAppuntamentoBranch( Map<Date, Object> returnValue, List<Date> dateList  ){
  Integer maxAppuntamento =0;
  Map<Date, Integer> mapDateMax = new Map<Date, Integer>();
  if(returnValue == null || returnValue.keySet().size() == 0){
        return null;
  }
  else {
      for(Date d : returnValue.keySet()){
         List<Object> timeslot = ( List<Object>) returnValue.get(d);
         System.debug(' ############# timeslot '+timeslot.size());
        maxAppuntamento = maxAppuntamento(timeslot);
        mapDateMax.put(d, maxAppuntamento);
      }
      System.debug(' ############# maxAppuntamento '+maxAppuntamento);
       System.debug(' ############# mapDateMax '+mapDateMax);
       for(Date d : dateList){
         if(!returnValue.containsKey(d)){
           mapDateMax.put(d, 0);
         }
       }
      return mapDateMax;
}    
}

public static Integer maxAppuntamento(List<Object> objectList ){
   System.debug(' ############# maxAppuntamento  ruunign ');
   Integer maxAppuntamento = 0;
   for(Object obj :  objectList ){
      Set<Time> timeSlot = ( Set<Time>) obj;
       System.debug(' ############# maxAppuntamento  timeSlot size '+timeSlot.size());
      maxAppuntamento += timeSlot.size();
   }
   System.debug(' ############# maxAppuntamento  in maxAppuntamento '+maxAppuntamento);
   return maxAppuntamento;
}


public static Map<Date, Object> groupeSlotByDate(Map<Id, Object> eventMap,  Map<Date, Set<Id>> dateSetMap){
   Map<Date, List<Object>> mapSlotDate = new  Map<Date, List<Object>>();
   // Map<Id, Object> mapSlotDate = new  Map<Date, Object>();
   //  Map<Id, List<Event>> mapSlotDate = new  Map<Date, Object>();
  //  System.debug(' ############### groupeSlotByDate '+mapDeskSlot.keySet());
   for(Date d : dateSetMap.keySet()){
        for(Id idDesk : dateSetMap.get(d) ){
          //mapSlotDate.put(d, new List<Object>{eventMap.get});
          if(!mapSlotDate.containsKey(d) ){
              mapSlotDate.put(d, new List<Object>{eventMap.get(idDesk)});
          }
          else {
            mapSlotDate.get(d).add(eventMap.get(idDesk));
          }
        }
       
     }
      
 return mapSlotDate;
}

public static void groupDateDesk(List<Event> events, Map<Date, Set<Id>> mapDate){
    if(events == null || events.size() == 0){
      return;
    }
    else {
        for(Event ev : events){
          if(!mapDate.containsKey(ev.ActivityDate)){
            mapDate.put(ev.ActivityDate, new Set<Id>{ev.Desk__c});
          }
          else {
            mapDate.get(ev.ActivityDate).add(ev.Desk__c);
          }
        }
    }
}


public static void groupEventByDate(List<Event> events, Map<Date, List<Event>> mapDate){
  if(events == null || events.size() == 0){
    return;
  } 
  else {
   for(Event ev : events){
      if(!mapDate.containsKey(ev.ActivityDate)){
        mapDate.put(ev.ActivityDate, new List<Event>{ev});
      }
      else {
        mapDate.get(ev.ActivityDate).add(ev);
      }

    } 
   
    
  }
}

public static List<Date> getListDate(Date dateIni, Date dateEnd){
      Date inizioDate = dateIni;
      List<Date> datesList = new List<Date>();
      Integer cpt = 1;
      while (inizioDate <= dateEnd  ) {
        cpt++;
        datesList.add(inizioDate);
        inizioDate=   inizioDate.addDays(1);
        System.debug(' ################ inizioDate '+inizioDate);
    
      }
      return datesList;
 
}

/*public static Map<Date, Integer> maxNumberAppuntamentoByDay(String codeFiliale, List<Date> datelists){


} */
@Future
public static void sendDEM(Id idEvent, Id idFiliale, String nameTemplate, String fromAddresse, String senderDisplayName){
    System.debug('################ sendEmail Futuro');
    Event event= [select Id,Customer__r.PersonEmail, Event.StartDateTime, Customer__r.Name, ActivityDateTime,ActivityDate from Event where Id=:idEvent];
    EmailTemplate template = [SELECT Id, HtmlValue, Body  FROM EmailTemplate WHERE Name =:nameTemplate];
    System.debug('##################### Id Filiale '+idFiliale);
    Account filiale = [SELECT Id, ShippingStreet, ShippingCity, ShippingPostalCode, Phone FROM Account WHERE RecordType.Name='Branch' AND Id =: idFiliale];
    System.debug('#####################  Filiale Futuro '+filiale);
    System.debug('################ filiale.ShippingStreet '+filiale.ShippingStreet);
    List<Messaging.SingleEmailMessage> allMsg = new List<Messaging.SingleEmailMessage>();
    Messaging.SingleEmailMessage mail = new Messaging.SingleEmailMessage();
    //String subjectMail = subject
    mail.setReplyTo(fromAddresse);
    mail.setToAddresses(new String[] {event.Customer__r.PersonEmail}); //event.Customer__r.PersonEmail
    mail.setTemplateID(template.Id);
    mail.setSaveAsActivity(true);
    mail.setSubject(event.Customer__r.Name+', il tuo appuntamento in filiale è stato fissato!');
    mail.setSenderDisplayName(senderDisplayName);
    String htmlBody = template.HtmlValue;
    String plainBody = template.Body;
    System.debug('################## test '+event.Customer__r.Name);
    htmlBody = htmlBody.replace('{!Contact.Name}', event.Customer__r.Name);
    htmlBody = htmlBody.replace('{!Event.ActivityDate}', ''+event.ActivityDate);
    htmlBody = htmlBody.replace('{!AccountRichiesteDEM__c.DEM_Param_9__c}',''+event.ActivityDateTime.time());
    htmlBody = htmlBody.replace('{!XCS_Desk__r.Branch__r.ShippingAddress}',filiale.ShippingStreet);
    htmlBody = htmlBody.replace('{!Contact.Param_7__c}',filiale.ShippingCity);
    htmlBody = htmlBody.replace('{!Contact.codice_Lista__c}',filiale.ShippingPostalCode);
    htmlBody = htmlBody.replace('{!Contact.DEM_Param_10__c}',filiale.Phone);
    htmlBody = htmlBody.replace('{!Event.StartDateTime}',''+event.StartDateTime);
    mail.setHtmlBody(htmlBody);
    allMsg.add(mail);
    try {
            List<Messaging.SendEmailResult> results = Messaging.sendEmail(allMsg);
           
        } 
    catch (EmailException e) {
            System.debug('sendTemplatedEmail error. ' + e.getMessage());
        }
}

public class Slot {
  public Time t;
  public Integer b;
  public Slot(Time t, Integer b){
    this.t= t;
    this.b= b;
  }
}

public static Boolean checkIfClienteHasAppuntamento(Map<String,Event> mapEvents, String codicefIscale){
    Boolean hasAppuntamento = false;
    if(mapEvents.get(codicefIscale) != null ){
        hasAppuntamento = true;
    }
    return hasAppuntamento;
}


public static Date filialeDisponibleSobato(Id idFiliale){
     Map<Id, Object> mapDeskSlot = new Map<Id, Object>();
     Map<String,Object> retuenValue  = new  Map<String,Object>();
     Date  dateUnitaAffari;
     Set<Time> slotList = new  Set<Time>();
  try {
       Account filiale = getFilialeById(idFiliale);
     
                                
      if(filiale.Id != null){
                XCS_DeskItem__c deskItem = [SELECT Id, Desk__c FROM XCS_DeskItem__c WHERE Saturday__c=true AND Desk__r.Branch__c =: filiale.Id LIMIT 1 ];
              
                retuenValue =   cercaDisponibilitaSabatoFiliale(deskItem, filiale);
                dateUnitaAffari = (retuenValue.get('isOk')== true )? (Date) retuenValue.get('date'):null;
      }    
      System.debug('##################### log returnValue '+retuenValue);
                                                 

   }
   catch (Exception e) {
        System.debug('####################### filialeDisponibleSobato  '+e.getMessage());
        System.debug('####################### filialeDisponibleSobato  '+e.getStackTraceString() );
  }
  System.debug('################### date '+dateUnitaAffari);
  return  dateUnitaAffari;
}


public static Map<String,Object> cercaDisponibilitaSabatoFiliale(XCS_DeskItem__c deskItem, Account filiale){
        Map<String,Object> retuenValue = new  Map<String,Object>();
        Map<String, Integer> mapDayOfWeek = new Map<String, Integer>{
          'Monday' => 5,
          'Tuesday' => 4,
          'Wednesday' => 3,
          'Thursday' => 2,
          'Friday' => 1,
          'Sunday' => 7
        };
       Set<Time> slotList = new  Set<Time>();
      if(deskItem.Id == null || filiale.Id == null){
        return null;
      }
      else {
            Datetime dt = Datetime.now();
            //   Date today = dt.date();
            String dayOfWeek = dt.format('EEEE');
            Date disponibilitaDate =  dt.date().addDays(mapDayOfWeek.get(dayOfWeek)) ;
            System.debug ('################### xxxxx test '+disponibilitaDate);
             retuenValue = sabatoFiliale(filiale, disponibilitaDate);
            System.debug('################# returnValue '+retuenValue);
            }
              
          return retuenValue;
}
public static  Map<String,Object> sabatoFiliale(Account filiale, Date sabatoDate){
            Map<String, Object> returnValue = new Map<String, Object>();
            Map<Id, Object> mapDeskSlot = new Map<Id, Object>();
            Boolean isOk;
            Set<Time> slotList = new  Set<Time>();
            appuntamentoDisponibilita(filiale, sabatoDate, mapDeskSlot);
            System.debug(' ############## mapDeskSlot test test '+mapDeskSlot);
            slotList = getAllSlots(mapDeskSlot);
            System.debug('####################### slotList '+slotList);
            
            if(slotList.size() == 0 ){
              sabatoDate = sabatoDate.addDays(7);
               slotList = getAllSlots(mapDeskSlot);
            } 
            isOk = (slotList.size() == 0 )?false:true;
           returnValue.put('isOk',isOk);
           returnValue.put('date',sabatoDate);

           return returnValue;

}


}