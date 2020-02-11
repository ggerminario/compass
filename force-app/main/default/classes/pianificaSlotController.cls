public with sharing class pianificaSlotController {
    
	@AuraEnabled
	public static InitWrapper initApex(){
		list<DataWrapper> dataWrapperList= initWeekDays(null);
		User manager= getManager();
		List<Account> branches= getBranches(manager);
		Map<String, List<User>> filialistiPerFiliale= getFilialistiPerFiliale(manager, branches);
        Map<String,List<String>> getAreaListPerRegion = getAreaListPerRegion(branches);
		Map<String,List<Account>> getBranchListPerArea = getBranchListPerArea(branches);
		List<SFA_Slot__c> slotList= getSlots(dataWrapperList,manager,filialistiPerFiliale);
		List<SFA_Slot__c> allZoneSlotList = getAllZoneSlotList(manager,filialistiPerFiliale);
		List<SFA_Assenza_Prolungata__c> assenzeProlungateList= getAssenzeProlungate(dataWrapperList,manager,filialistiPerFiliale);
		Map<String, List<Zone__c> > zonePerFiliale= getZonePerFiliale(branches);
		List<Map<String,String>> TypeSelectOptions = getTypeSelectOptions();
		Map<String, List<XCS_Appointment__c>> mapOfAppointmentsPerDesk= getMapOfAppointmentsPerDesk(branches,dataWrapperList);
		
		return new InitWrapper(manager, 
								filialistiPerFiliale, 
								slotList,
								allZoneSlotList, 
								assenzeProlungateList,
								dataWrapperList,
								branches,
								getAreaListPerRegion,
								getBranchListPerArea,
								zonePerFiliale,
								TypeSelectOptions,
								null,
								mapOfAppointmentsPerDesk);
	}
	@AuraEnabled
	public static InitWrapper changeTargetDate(Date targetDate,User manager,Map<String, List<User>> filialistiPerFiliale){
		
		List<Account> branches= getBranches(manager);
		Map<String,List<String>> getAreaListPerRegion = getAreaListPerRegion(branches);
		Map<String,List<Account>> getBranchListPerArea = getBranchListPerArea(branches);
		list<DataWrapper> dataWrapperList= initWeekDays(targetDate);
		List<SFA_Slot__c> slotList= getSlots(dataWrapperList,manager,filialistiPerFiliale);
		List<SFA_Slot__c> allZoneSlotList = getAllZoneSlotList(manager,filialistiPerFiliale);
		List<SFA_Assenza_Prolungata__c> assenzeProlungateList= getAssenzeProlungate(dataWrapperList,manager,filialistiPerFiliale);
		Map<String, List<Zone__c> > zonePerFiliale= getZonePerFiliale(branches);
		Map<String, List<XCS_Appointment__c>> mapOfAppointmentsPerDesk= getMapOfAppointmentsPerDesk(branches,dataWrapperList);

		return new InitWrapper(manager, 
								null, 
								slotList, 
								allZoneSlotList,
								assenzeProlungateList,
								dataWrapperList,
								branches,
								getAreaListPerRegion,
								getBranchListPerArea,
								zonePerFiliale,
								null,
								targetDate,
								mapOfAppointmentsPerDesk);
	}

	@AuraEnabled
	public static Map<String, List<Zone__c> > getZonePerFiliale(List<Account> branches){
		List<Zone__c> zoneList= [SELECT Id, Name, Branch__c, Branch__r.OCS_External_Id__c FROM Zone__c WHERE Branch__c=:branches];
		Map<String, List<Zone__c> > zonePerFiliale= new Map<String, List<Zone__c> >();
		for(Zone__c zona:zoneList){
			if(zonePerFiliale.containsKey(zona.Branch__r.OCS_External_Id__c)){
				zonePerFiliale.get(zona.Branch__r.OCS_External_Id__c).add(zona);
			}
			else{
				zonePerFiliale.put(zona.Branch__r.OCS_External_Id__c, new List<Zone__c>{zona});
			}
		}
		return zonePerFiliale;
	}
    
    public static String typeUser() {
        String userType = [SELECT Name FROM Profile WHERE id=:userinfo.getProfileId() LIMIT 1].name;       
        return userType == null ? '' : userType;      
    }

    //Recupero la lista delle Regioni
    @AuraEnabled
	public static Map<String,List<String>> getAreaListPerRegion(List<Account> allBranchList){
        
        Map<String,List<String>> areaListPerRegion = new Map<String,List<String>>();

        for (Account branch : allBranchList){

			if(areaListPerRegion.containsKey(branch.Region_Name__c)){
				if(!areaListPerRegion.get(branch.Region_Name__c).contains(String.valueOf(branch.OCSAreaId__c)))
					areaListPerRegion.get(branch.Region_Name__c).add(String.valueOf(branch.OCSAreaId__c));
            }else{
                areaListPerRegion.put(branch.Region_Name__c,new List<String>{String.valueOf(branch.OCSAreaId__c)});
            }

        }
        System.debug('DP areaListPerRegion: '+areaListPerRegion);        
		return areaListPerRegion;
                
    }

    //Recupero la lista delle Aree
	@AuraEnabled
	public static Map<String,List<Account>> getBranchListPerArea(List<Account> allBranchList){
        
		Map<String,List<Account>> branchListPerArea = new Map<String,List<Account>>();

        for (Account branch : allBranchList){

            if(branchListPerArea.containsKey(String.valueOf(branch.OCSAreaId__c))){
                branchListPerArea.get(String.valueOf(branch.OCSAreaId__c)).add(branch);
            }else{
                branchListPerArea.put(String.valueOf(branch.OCSAreaId__c),new List<Account>{branch});
            }
        }
        System.debug('DP branchListPerArea: '+branchListPerArea);       
		return branchListPerArea;       
        
    }
    
	@AuraEnabled
	public static List<Account> getBranches(User manager){
        
        List<Account> allBranchList = SetupVisibilityFiliali.getFiliali();
        return allBranchList;
        /*
        String userType = typeUser();
        User u= [SELECT Id,Name,DefaultQueueId__c,Area__c,UserRole.Name FROM User WHERE Id =: UserInfo.getUserId()];
        String OCSExternalId = u.DefaultQueueId__c == null ? '' : u.DefaultQueueId__c;
        String Area = u.Area__c == null ? '' : u.Area__c;
        String Role = u.UserRole.Name == null ? '' : u.UserRole.Name;
        System.debug('DP Ruolo: '+Role);
        System.debug('DP typeUser: '+userType);
        
        String QueryBranch = 'SELECT FirstName, LastName, Name, Id, toLabel(Type) typeLabel,OCS_External_Id__c,OCSAreaId__c,Region_Name__c '+
            				   +' FROM Account '+
                               +' WHERE OCS_External_Id__c != null AND OCSAreaId__c != null AND Region_Name__c != null'+
                               +' AND Type = \'FIL\' AND RecordType.DeveloperName = \'Branch\'';
        

        //Settoggio visibilità filiali:
        //Branch Manager e Branch Employee vedono la singola filiale
        //Area Manager vede la sua singola Area con tutte le filiali che ne fanno parte
        //Area Manager con ruolo contente 'Regione' vede la sua regione con tutte le aree e le filiali sottostanti
        //Se sei diverso da tutti le condizioni indicate prima l'utente vede tutte le filiali.
        
        if(userType=='Area Manager' && Role.contains('REGIONE')){
           QueryBranch +=' AND toLabel(Region_Name__c) =: Role'; 
           System.debug('DP sono un region manager');
        }
        if(userType=='Area Manager' && !Role.contains('REGIONE')){
            QueryBranch +=' AND OCSAreaIdText__c=: Area';
            System.debug('DP sono un Area manager');
        }                                     
        If(userType=='Branch Manager' || userType=='Branch Employee'){
            QueryBranch += ' AND OCS_External_Id__c=: OCSExternalId';
            System.debug('DP sono un utente di filiale');
        }
        
        List<Account> allBranchList = Database.query(QueryBranch);
        system.debug('DP allBranchList: '+allBranchList);	
        return allBranchList;*/
	}


	public static List<Map<String,String>> getTypeSelectOptions(){
		Schema.DescribeFieldResult fieldResult = SFA_Slot__c.Type__c.getDescribe();
		return (List<Map<String,String>>) JSON.deserialize(JSON.serialize(fieldResult.getPicklistValues()),List<Map<String,String>>.Class);
	}

	@AuraEnabled
	public static Map<String, List<User>> getFilialistiPerFiliale(User manager, List<Account> branches){
		List<String> branchExternalIds= new List<String>();
		for(Account branch:branches){
			if(!String.isBlank(branch.OCS_External_Id__c)){
				branchExternalIds.add(branch.OCS_External_Id__c);
			}
		}
		List<User> allFilialisti= [SELECT FirstName, LastName, Name, Id, DefaultQueueId__c 
                                   FROM User 
                                   WHERE DefaultQueueId__c =: branchExternalIds 
                                   AND Id !=: manager.Id
                                   AND IsActive = true];
		Map<String, List<User>> filialistiPerFiliale= new Map<String, List<User>>();

		for(User filialista:allFilialisti){

			if(filialistiPerFiliale.containsKey(filialista.DefaultQueueId__c)){
				filialistiPerFiliale.get(filialista.DefaultQueueId__c).add(filialista);
			}
			else{
				filialistiPerFiliale.put(filialista.DefaultQueueId__c, new List<User>{filialista});
			}
		}
		return filialistiPerFiliale;
	}

	@AuraEnabled
	public static User getCurrentUser(){
		String utenteId = UserInfo.getUserId();
        User currentUser= [SELECT FirstName, LastName,Id,Name,DefaultQueueId__c FROM User WHERE Id =: utenteId];
        /*if(String.isBlank(currentUser.DefaultQueueId__c)){
            AuraHandledException e = new AuraHandledException('utente non correttamente configurato');
			e.setMessage('utente non correttamente configurato');
			throw e;
        }*/
		return currentUser; 
	}

	@AuraEnabled
	public static User getManager(){
		User currentUser = getCurrentUser();
		List<User> managerList = [SELECT FirstName, LastName, Name, Id, DefaultQueueId__c  
                                    FROM User  
                                   WHERE DefaultQueueId__c =: currentUser.DefaultQueueId__c
			  						 AND Profile.Name = 'Branch Manager'];
		
		return managerList.size() == 1 ? managerList[0] : currentUser;
	}
	
	@AuraEnabled
	public static List<DataWrapper> initWeekDays(Date targhetDate){

		Integer weekDays= 5;
		
		targhetDate = null ==  targhetDate ? Date.today():targhetDate;

		List<DataWrapper> dateWrapperList= new List<DataWrapper>{new DataWrapper(targhetDate.toStartofWeek())};
		List<Date> theDateList = new List<Date>{ targhetDate.toStartofWeek()};
		for(Integer i = 0; i < weekDays; i++){
			theDateList.add(theDateList.get(i).addDays(1));
			dateWrapperList.add(new DataWrapper(theDateList.get(i).addDays(1)));
		}
		return dateWrapperList;
	}

	@AuraEnabled
	public static List<SFA_Slot__c> getSlots(list<DataWrapper> dataWrapperList, User manager, Map<String, List<User>> filialistiPerFiliale){
		Date startDate= dataWrapperList.get(0).theDate;
		Date lastDate= dataWrapperList.get(dataWrapperList.size()-1).theDate;

		Set<String> filialiSet= new Set<String>(filialistiPerFiliale.keySet());
		//fix Manfredi Smaniotto casistica manager unico filialista start
		filialiSet.add(manager.DefaultQueueId__c);
		//end
		List<Id> userListId= new list<Id>();
		userListId.add(manager.Id);
		for(List<User> listOfUser:filialistiPerFiliale.values()){
			for(User user:listOfUser){
				userListId.add(user.Id);
			}
		}
	  return [select Id ,Branch__c , Branch__r.OCS_External_Id__c, Date__c, Dealer__c, Status__c, Time__c, User__c, toLabel(Type__c) typeLabel, Type__c, XCS_Zone__c, XCS_Zone__r.Name
		FROM SFA_Slot__c 
		WHERE User__c=:userListId AND Date__c >=: startDate AND Date__c <=: lastDate AND Branch__r.OCS_External_Id__c =: filialiSet AND recordtype.developerName = 'Slot']; //Aggiunta RT
	}

	@AuraEnabled
	public static List<SFA_Slot__c> getAllZoneSlotList(User manager, Map<String, List<User>> filialistiPerFiliale){
		Date startDate = Date.today();
		
		Set<String> filialiSet= new Set<String>(filialistiPerFiliale.keySet());
		//fix Manfredi Smaniotto casistica manager unico filialista start
		filialiSet.add(manager.DefaultQueueId__c);
		//end
		List<Id> userListId= new list<Id>();
		userListId.add(manager.Id);
		for(List<User> listOfUser:filialistiPerFiliale.values()){
			for(User user:listOfUser){
				userListId.add(user.Id);
			}
		}
	    return [select Id ,Branch__c , Branch__r.OCS_External_Id__c, Date__c, Dealer__c, Status__c, Time__c, User__c,XCS_Zone__c, XCS_Zone__r.Name
		FROM SFA_Slot__c 
		WHERE  User__c=:userListId AND Date__c >=: startDate AND Branch__r.OCS_External_Id__c =: filialiSet AND XCS_Zone__r.Name != null AND Type__c = null AND recordtype.developerName = 'Slot']; //Aggiunta RT
	}

	@AuraEnabled
	public static List<SFA_Assenza_Prolungata__c> getAssenzeProlungate(list<DataWrapper> dataWrapperList, User manager, Map<String, List<User>> filialistiPerFiliale){
		Date startDate= dataWrapperList.get(0).theDate;
		Date lastDate= dataWrapperList.get(dataWrapperList.size()-1).theDate;
		List<Id> userListId= new list<Id>();
		userListId.add(manager.Id);
		for(List<User> listOfUser:filialistiPerFiliale.values()){
			for(User user:listOfUser){
				userListId.add(user.Id);
			}
		}
	  	return [SELECT Name, CreatedById, EndDate__c, LastModifiedById, toLabel(MotivazioneAssenza__c) MotivazioneAssenza, OwnerId, RisorsaFiliale__c, StartDate__c 
				FROM SFA_Assenza_Prolungata__c 
				WHERE  StartDate__c <=: lastDate AND EndDate__c >=: startDate AND RisorsaFiliale__c=: userListId];
	}

	@AuraEnabled
    public static Map<String, List<XCS_Appointment__c>> getMapOfAppointmentsPerDesk(List<Account> branches, list<DataWrapper> dataWrapperList){
		Date startDate= dataWrapperList.get(0).theDate;
		Date lastDate= dataWrapperList.get(dataWrapperList.size()-1).theDate;
        List<XCS_Appointment__c> appointmentsList=[SELECT Name,Id,Date__c, XCS_Desk__r.DeskName__c, Branch__r.OCS_External_Id__c, EndTime__c, StartTime__c, Type__c FROM XCS_Appointment__c WHERE Branch__c=: branches AND Date__c >=: startDate AND Date__c <=: lastDate AND Type__c='App'];
		Map<String, List<XCS_Appointment__c>> mapOfAppointmentsPerDesk=new Map<String, List<XCS_Appointment__c>>();
		for(XCS_Appointment__c appuntamento:appointmentsList){
			if(mapOfAppointmentsPerDesk.containsKey(appuntamento.XCS_Desk__r.DeskName__c))
				mapOfAppointmentsPerDesk.get(appuntamento.XCS_Desk__r.DeskName__c).add(appuntamento);
			else
				mapOfAppointmentsPerDesk.put(appuntamento.XCS_Desk__r.DeskName__c, new List<XCS_Appointment__c>{appuntamento});
		}
        return mapOfAppointmentsPerDesk;
    }

	@AuraEnabled
	public static List<SFA_Slot__c>  saveSlotsApex(List<SFA_Slot__c> upsertList, List<SFA_Slot__c> deleteList, List<SFA_Slot__c> slotModello){ //Aggiunta RT
		if(upsertList!=null && !upsertList.isEmpty()){
            
            for(Integer i =0; i<upsertList.size();){ //Rimuovo i duplicati
                if(upsertList[i].modello__c!=null && upsertList[i].Id == null){
                    upsertList.remove(i);
                }
                else i++;
            }
            Recordtype rt = [Select id from Recordtype where developername = 'Slot' AND SobjectType = 'SFA_Slot__c'];
            for(SFA_Slot__c temp : upsertList) temp.recordtypeid = rt.id;
			upsert upsertList;
		}
		if(deleteList!=null && !deleteList.isEmpty()){
			delete deleteList;
		}
        if(slotModello!=null && !slotModello.isEmpty()){
             for(SFA_Slot__c temp : slotModello) temp.Status__c = 'Valido';
            insert slotModello;
            upsertList.addAll(slotModello);
        }
        
		return upsertList;
        
	}

	@AuraEnabled
	public static Map<String,List<Account>> getCaseOpenOnZone(List<String> listIdZone){

        List<Account> accountList = [SELECT Id,Zone__r.Name,Zone__r.Branch__c,(SELECT Id ,CreatedDate,Priority FROM Cases WHERE Status != 'Closed' ORDER BY CreatedDate) 
				FROM Account 
				WHERE Id IN (SELECT AccountId FROM Case WHERE Status != 'Closed' AND Account.Zone__c =: listIdZone AND ClosedDate = null AND Account.RecordType.DeveloperName = 'Dealer')];
		
		Map<String,List<Account>> zonePerCaseMap =new Map<String,List<Account>>();
		
		for(Account acc:accountList){
			if(zonePerCaseMap.containsKey(acc.Zone__r.Name))
				zonePerCaseMap.get(acc.Zone__r.Name).add(acc);
			else
				zonePerCaseMap.put(acc.Zone__r.Name, new List<Account>{acc});
		}

		return zonePerCaseMap;
	}


	public class DataWrapper{
		@AuraEnabled
		public String weekDay;
		@AuraEnabled
		public Integer dateNumber;
		@AuraEnabled
		public String formattedDate;
		@AuraEnabled
		public Date theDate;

		public DataWrapper(Date theDate){

			this.theDate=theDate;
			dateTime theDateTime = (dateTime)theDate;
			//this.weekDay=theDateTime.format('MM/dd/yyyy HH:mm:ss','Italia/Rome');
            this.weekDay=theDateTime.format('EEEE').replace('Monday', 'Lunedì');
            this.weekDay=this.weekDay.replace('Tuesday', 'Martedì');
            this.weekDay=this.weekDay.replace('Wednesday', 'Mercoledì');
            this.weekDay=this.weekDay.replace('Thursday', 'Giovedì');
            this.weekDay=this.weekDay.replace('Friday', 'Venerdì');
            this.weekDay=this.weekDay.replace('Saturday', 'Sabato');
            
			this.dateNumber=theDate.day();
			this.formattedDate=theDateTime.format('dd-MM-YYYY');


		}
	}

	public virtual class InitWrapper{
		@AuraEnabled
        public Map<String,List<String>> areaListPerRegion;
        @AuraEnabled
        public Map<String,List<Account>> branchListPerArea;
		@AuraEnabled
		public User manager;
		@AuraEnabled
		public Map<String, List<User>> filialistiPerFiliale;
		@AuraEnabled
		public List<SFA_Slot__c> slotList;
		@AuraEnabled
		public List<SFA_Slot__c> allZoneSlotList;
		@AuraEnabled
		public List<SFA_Assenza_Prolungata__c> assenzeProlungateList;
		@AuraEnabled
		public List<DataWrapper> dataWrapperList;
		@AuraEnabled
		public Date targetDate;
		@AuraEnabled
		public List<Account> branches;
		@AuraEnabled
		public Map<String, List<Zone__c> > zonePerFiliale;
		@AuraEnabled
		public List<Map<String,String>> TypeSelectOptions;
		@AuraEnabled
		public Map<String, List<XCS_Appointment__c>> mapOfAppointmentsPerDesk;
		
        public InitWrapper(){}

		public InitWrapper( User manager,
							Map<String, List<User>> filialistiPerFiliale, 
							List<SFA_Slot__c> slotList, 
							List<SFA_Slot__c> allZoneSlotList,
							List<SFA_Assenza_Prolungata__c> assenzeProlungateList,
							List<DataWrapper> dataWrapperList,
							List<Account> branches,
                            Map<String, List<String>> areaListPerRegion,
                            Map<String, List<Account>> branchListPerArea,
							Map<String, List<Zone__c>> zonePerFiliale,
							List<Map<String,String>> TypeSelectOptions,
							Date targetDate,
							Map<String, List<XCS_Appointment__c>> mapOfAppointmentsPerDesk){
			this.manager= manager;
			this.filialistiPerFiliale= filialistiPerFiliale;
			this.slotList= slotList;
			this.allZoneSlotList= allZoneSlotList;
			this.dataWrapperList= dataWrapperList;
			this.targetDate= targetDate == null ? Date.today() : targetDate;
			this.branches= branches;
			this.areaListPerRegion = areaListPerRegion;
			this.branchListPerArea = branchListPerArea;
			this.zonePerFiliale= zonePerFiliale;
			this.TypeSelectOptions= TypeSelectOptions;
			this.assenzeProlungateList= assenzeProlungateList;
			this.mapOfAppointmentsPerDesk= mapOfAppointmentsPerDesk;
		}

	}

	public class pianificaSlotException extends Exception {}
    
    
    //CR applicazione modello
    @AuraEnabled
    public static List<SFA_Modello_Pianificazione__c> caricaModelliCTRL(){
        return Modelli_PianificazioneController.caricaListaModelliCTRL();
    }
    
      @AuraEnabled
    public static Modelli_PianificazioneController.Modello caricaSlotCTRL(String ident){
        return Modelli_PianificazioneController.caricaSlotCTRL(ident);
    }
    
     @AuraEnabled
    public static boolean dateIsValid(Date dataPartenza){
        Date d = (System.today()).addDays(7);
        
        return d.toStartOfWeek() <= dataPartenza;
    }
    
    @AuraEnabled
    public static DateWrap getSettimanaCTRL(Integer numSettimana, Date dataPartenza){
        dataPartenza = dataPartenza.toStartOfWeek();
        Integer numGiorni = numSettimana * 7;
        
        return new DateWrap(dataPartenza, dataPartenza.addDays(numGiorni));
		
    }
    
    @AuraEnabled
    public static List<SFA_Slot__c> applicaModCTRL(Object settimana, List<SFA_Slot__c> calendario){
     	
        for(Integer i=0; i<calendario.size(); ){
            SFA_Slot__c temp = calendario[i];
            if(temp.Name=='shadow'){
                System.debug(temp);
                calendario.remove(i);
            }
            else i++;
        }
        
        Set<Id> listaUtenti = new Set<Id>();
        for(SFA_Slot__c slot : calendario) listaUtenti.add(slot.user__c);
        String jsonString = JSON.serialize(settimana);
        DateWrap dw =(DateWrap) JSON.deserialize(jsonString, DateWrap.class) ; 
       
        List<SFA_Slot__c> isExists = [Select id from SFA_Slot__c Where user__c =:listaUtenti AND date__c >= :dw.inizio and date__c <= :dw.fine and recordtype.developerName = 'Slot'];
        if(isExists != null && isExists.size() > 0) return null; //Lancio Exc
        
        List<SFA_Slot__c> listaSlot = new List<SFA_Slot__c>();
        Recordtype rt = [Select id from Recordtype where developername = 'Slot' AND SobjectType = 'SFA_Slot__c'];
        Date dt = dw.inizio;
        
        List<SFA_slot__c> listaSlotFull =  [SELECT Id ,Branch__c, XCS_Zone__r.Name, Giorno__c, Modello__c, RSS_External_Id__c, modello__r.Name,modello__r.descrizione__c,  RecordTypeId, Name  , Branch__r.OCS_External_Id__c, Date__c, Dealer__c, Status__c, Time__c, User__c, toLabel(Type__c) typeLabel, Type__c, XCS_Zone__c
                                        FROM SFA_Slot__c
                                        WHERE id =:calendario and recordtype.developerName = 'Modello'];
        
        
        
        System.debug(listaSlotFull.size());
        
            while(dt <= dw.fine){
            
            if(((Datetime)dt).format('EEEE') == 'Sunday'){
                dt = dt.addDays(1);
                continue;
            } 
            for(SFA_Slot__c slot : listaSlotFull){
                System.debug('For degli slot');
                if(slot.Name == 'shadow') continue;
                Datetime dateTemp = slot.Date__c;
                Datetime dtTemp = dt;
                if(dateTemp.format('EEEE') !=dtTemp.format('EEEE')) continue;
                SFA_Slot__c temp = slot.clone();
                temp.RecordTypeId = rt.id;
                temp.Date__c = getDateByDay(dt, slot);
                temp.Status__c = 'Draft';
				listaSlot.add(temp);
            }
            dt = dt.addDays(1);
        }
        System.debug('Controllo finale');
         for(SFA_Slot__c slot : listaSlot) System.debug(slot);
        
        return listaSlot;
    }
    
    public static Date getDateByDay(Datetime startweek, SFA_Slot__c slot){
        Datetime temp = startweek;
        Datetime slotDate = slot.Date__c;
        while(true){
              System.debug(slotDate.format('EEEE')+' While della data '+startweek.format('EEEE'));
            if(slotDate.format('EEEE') == startweek.format('EEEE')){
                return startWeek.date();
            }
            else startWeek = startWeek.addDays(1);
            if(startweek.format('EEEE') == 'Sunday') return null; 
        }
        return null;
    }
    
    public class DateWrap{
        @AuraEnabled
        public Date inizio;
        @AuraEnabled
        public Date fine;
        @AuraEnabled
        public String error;
        
        public DateWrap(Date inizio, Date fine){
            this.inizio = inizio;
            this.fine = fine.addDays(-2);
            if(inizio < System.today()) error = 'La pianificazione deve avvenire nella settimana successiva';
        }
    }
    
	
}