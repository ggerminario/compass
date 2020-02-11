/**
 * Utils class for Compass rest web services
 *
 * @author  Moussa Fofana
 * @version 1.0
 * @description Utils class for Compass rest web services
 * @testedIn  CGMWSUtilsTst_1_0
 * @uses
 * @code
 * @errorcode [ERR:CL-XXXYYZZ]
 * @history
 * 2019-03-13 : Moussa Fofana - Original
 */
global with sharing class CGMWSUtils_1_0 {

    global static final String STATUS_OK = 'OK';
    global static final String STATUS_KO = 'KO';
    global static final Integer RESULT_CODE_OK = 0;
    global static final Integer RESULT_CODE_KO = 1;

    public static final Integer GIACENZA_PRECARICO      = 5; // Default 30 minutes
    public static final Integer GIACENZA_PRECARICO_24   = 1440; // Default 1440 minutes (24 hours) 
    public static final Integer GIACENZA_PRECARICO_72   = 4320; // Default 4320 minutes (72 hours) 
    public static final Integer GIACENZA_5_GIORNI       = 10; // Default 7200 minutes (5 days) 
    
    public static final Integer GIACENZA_PRE_POST_SIC = 2; // Default 180 minutes (3 hours)
    public static final Integer GIACENZA_PRESIC = 2; // Default 180 minutes (3 hours)
    
    public static final Integer USCITA_DALLA_CODA = 4; // Default 240 minutes (4 hours)

    public static final String EMAIL_UFFICIO_FRODI = 'giuseppe.capasso81@gmail.com,marco.capece@lyxspa.com'; // Default ufficio.frodi@compass.it;
    public static final String EMAIL_COMPASS_AFFARI = 'giuseppe.capasso81@gmail.com,marco.capece@lyxspa.com'; // Default compassaffari@compass.it;
    public static final String EMAIL_RICHIESTA = 'giuseppe.capasso81@gmail.com,marco.capece@lyxspa.com'; // Default richiesta@compass.it;
    public static final String EMAIL_NO_REPLY = 'noreply@compass.it';
    public static final String EMAIL_LABEL_COMPASS = 'Compass Banca S.p.A.';


    /** Map of error code to error message */
    global static final Map < String, String > ERROR_MESSAGE_MAP = new Map < String, String > {

        '[KO-ERROR0001]' => 'Internal server error.',

        '[KO-LOGIN0001]' => 'Bad request. Missing or invalid App-authorization header field.',
        '[KO-LOGIN0002]' => 'We cannot find your email address. Have you registered by clicking on the REGISTER button?', //'Invalid email address. Lead does not exist on system.',
        '[KO-LOGIN0003]' => 'Incorrect password. Can you try again, or use the FORGOT PASSWORD button? ', //'Unauthorized access. Provided password is not valid.',
        '[KO-LOGIN0004]' => 'Bad request. Invalid App-authorization header field. [email:password] must be encoded in base 64.',
        '[KO-LOGIN0005]' => 'We recognize your email. To keep you safe, please click on the link in the email we sent you', //'Email address not verified.',

        '[KO-CREQ0001]' => 'Bad request. Invalid case id.',
        '[KO-CREQ0002]' => 'Bad request. Invalid cliente canale.',
        '[KO-CREQ0003]' => 'Bad request. Invalid or not allowed query parameters.',
        '[KO-CREQ0004]' => 'Unauthorized access.',
        '[KO-CREQ0005]' => 'Invalid request body.',
        '[KO-CREQ0006]' => 'Impossible to identify the case to update. Please specify a valid case id.',
        '[KO-CREQ0007]' => 'Bad request. Missing required fields.',
        '[KO-CREQ0008]' => 'Verified case already exists in the system with provided informations.',
        '[KO-CREQ0009]' => 'block the rest of the query',

        '[KO-ROCRMRichLog0001]' => 'Impossible to create object RO_CRMRich_online_steplog__c.',
        '[KO-ROCRMRichLogPresc0001]' => 'Impossible to create object RO_CRMRich_online_prescoring__c.',

        '[KO-CREC0001]' => 'Impossible to create object Case.',
        '[KO-Account0001]' => 'Impossible to create  Account',

        '[KO-Anomalie0001]' => 'Anomalie does not existe',
        '[KO-Anomalie0002]' => 'Insertion Anomalie Failed',
        '[KO-Anomalie0003]' => 'Case Not Find with OcsPratica',
        '[KO-Anomalie0004]' => 'Anomaly insert successfully',

        '[KO-ERR012]' => 'invalid date field',
        //********************  Code Product2 ******************************
        '[KO-PROD001]' => 'product not found with this codProdottoCRM',
        '[KO-PROD002]' => 'product not found with this prodottoLvl1',
        '[KO-FILIALE001]' => 'Filiale Not Found whith this CodeFiliale',
        '[KO-ACC0000001]' => 'Customer NOT Found ',
        '[KO-APP0001]' => 'Appuntamento NOT Found',

        //#############################" CreaProspect ################################""
        '[CRAPROS-001]' => 'Gentile Cliente, ci risulta essere già presente una richiesta a suo nome. Per controllare lo stato della sua pratica' +
        'utilizzi il link inviato nel momento della sua richiesta. Nel caso in cui sia stato smarrito contatti il numero 800774433 tasto 3',

        '[CRAPROS-002]' => 'Gentile Cliente, ci risulta essere già presente una richiesta a suo nome non ancora conclusa: può riprenderla utilizzando il link inviato all’ atto di richiesta.' +
        ' Nel caso in cui il link sia stato smarrito  o voglia annullare la richiesta per iniziarne una nuova contatti il numero 800774433 tasto 3',
        '[KO-APPLC01]' => 'Bad request. Missing or Empty required fields'

        // '[ERR00APM001]' => 'The new appointment date must be future and not passed'

    };

    /** Generic Compass  WSR Exception */
    global virtual class CGMWSRException extends Exception {

        global String additionalInfo;

        global CGMWSRException(String message, String additionalInfo) {
            this(message);
            this.additionalInfo = additionalInfo;
        }
    }

    /*********************************************
     * [getRequestTimestamp description]
     * @param timestamp record's timestamp
     * @return timestamp in milliseconds
     * @code 01
     ************************************************************************/
    global static Long getRequestTimestamp(Datetime timestamp) {
        return timestamp != null ? timestamp.getTime() : null;
    }


    /******************************************************************************
     * [getRequestTimestamp description]
     * @return timestamp in milliseconds
     * @code 06
     *********************************************************************************/
    global static Long getRequestTimestamp() {
        return getRequestTimestamp(System.now());
    }

    /**************************************** ********************************
     * @description  get Id recordType 
     * @param obj : the Object Name
     * @param  recName the developerName
     * @return Id
     *********************************************************************************/
    global static Id getRecordTypeId(string obj, string recName) {

        Id recTypeId;
        if (obj != null && recName != null) {
            recTypeId = Schema.getGlobalDescribe().get(obj).getDescribe().getRecordTypeInfosByDeveloperName().get(recName).getRecordTypeId();
        }
        return recTypeId;
    }

    /************************************************************* 
     *@description Get template email by developerName
     *@param developerName
     *@return liste of template
     *********************************************************************************/
    public static List < EmailTemplate > getTemplateByDeveloperName(String developerName) {
        List < EmailTemplate > templates = [SELECT Id, Subject, HtmlValue FROM EmailTemplate WHERE DeveloperName =: developerName];
        return templates;
    }
    /******************************************************************************* *
     *@Author Madicke BALDE
     *@description Get information about batch job
     *@param  batchableContext : Database.BatchableContext
     *@return AsyncApexJob
     *********************************************************************************/
    public static AsyncApexJob getInformationAbout_Batch(Database.BatchableContext batchableContext) {
        AsyncApexJob a = [SELECT Id, Status,
            NumberOfErrors,
            JobItemsProcessed,
            TotalJobItems,
            CreatedDate
            FROM AsyncApexJob
            WHERE Id =: batchableContext.getJobId()
        ];
        return a;

    }

    /********************************************************************************* 
     *@description format DateTime to String
     *@param createdDate : DateTime to convert
     *@param numberHours : 
     *@return String
     **************************************************************************************/
    public static String formatDate(Datetime createdDate, Integer numberHours) {
        String datechaine = String.valueOfGmt(createdDate);
        List < String > datestimes = datechaine.split(' ');

        String dates = datestimes[0];
        String times = datestimes[1];

        List < String > timesplit = times.split(':');
        List < String > datesplit = dates.split('-');

        String year = datesplit[0];
        String month = (datesplit[1].startsWith('0')) ? datesplit[1].substring(1) : datesplit[1];
        String days = (datesplit[2].startsWith('0')) ? datesplit[2].substring(1) : datesplit[2];

        String hours = (timesplit[0].startsWith('0')) ? timesplit[0].substring(1) : timesplit[0];

        Integer h = Integer.valueOf(hours) + numberHours;
        Integer day = Integer.valueOf(days);
        if (h == 24) h = 0;
        if (h == 25) h = 1;
        if (h == 0 || h == 1) day = day + 1;
        System.debug('******* days ' + days);
        String minutes = (timesplit[1].startsWith('0')) ? timesplit[1].substring(1) : timesplit[1];
        String secondes = (timesplit[2].startsWith('0')) ? timesplit[2].substring(1) : timesplit[2];

        String newDate = secondes + ' ' + minutes + ' ' + h + ' ' + day + ' ' + month + ' ' + '?' + ' ' + year;
        return newDate;
    }


    /*****************************************************************************
     *@description convert string into Date
     *@param formatedString : string to convert
     *@return Date 
     ***************************************************************************************/
    public static Date formatStringToDate(String formatedString) {
        System.debug('################# formatStringToDate  ' + formatedString);
        try {
            if (formatedString.length() > 8) throw new CGMWSUtils_1_0.CGMWSRException('[KO-ERR012]');
            String years = formatedString.substring(0, 4);
            String month = formatedString.substring(4, 6);
            String day = formatedString.substring(6, 8);
            String todate = years + '-' + month + '-' + day;
            Date dt = Date.valueOf(todate);
            return dt;

        } catch (Exception e) {
            System.debug(' ############ error ' + e.getMessage());
            System.debug(' ############ error ' + e.getStackTraceString());
            AppuntamentoError.hasError = true;
            AppuntamentoError.codeErreor = '[KO-ERR012]';
            RequestOnlineApexClass.errorCode = '[KO-ERR012]';
            AppuntamentoError.errorMessage = 'Date Non Valid';
            throw new CGMWSUtils_1_0.CGMWSRException('[KO-ERR012]');
        }
    }

    /**********************************************************************************
     *@Author Madicke BALDE
     *@description
     *@date
     *@param String date
     *@return Date
     **********************************************************************************************/
    public static String getDayOfWeek(String formatedString) {
        try {
            System.debug(' ################ getDayOfWeek formatedString' + formatedString);
            String years = formatedString.substring(0, 4);
            String month = formatedString.substring(4, 6);
            String day = formatedString.substring(6, 8);
            System.debug(' ################ month' + month);
            String todate = day + '/' + month + '/' + years;
            System.debug(' ################ todate' + todate);
            Date d = Date.parse(todate);
            System.debug('################# d ' + d);
            Datetime dt = Datetime.newInstance(d.year(), d.month(), d.day());
            String dayeOfWeek = dt.format('EEEE') + '__c';
            return dayeOfWeek;

        } catch (Exception e) {
            System.debug(' ################### errorMessage ' + e.getMessage());
            System.debug(' ################### errorMessage ' + e.getStackTraceString());
            AppuntomentoDisponibilitaWService.errorCode = '[KO-ERR012]';
            throw new CGMWSUtils_1_0.CGMWSRException('[KO-ERR012]');
        }
    }
    public static Datetime formatStringToDatetime(String value) {
        String years = value.substring(0, 4);
        String month = value.substring(4, 6);
        String day = value.substring(6, 8);
        String ds = years + '-' + month + '-' + day + ' ' + '00:00:00';
        Datetime dt = Datetime.newInstance(Integer.valueOf(years), Integer.valueOf(month), Integer.valueOf(day));
        return dt;
    }

    /**************************************************************************
     *@description 
     *@param ID Account : idAccount
     *@param String name of Campaign : nameOfCampaign
     *@param String Link : link
     *@param Anomalie_Doc__c List : anomalies
     ****************************************************************************/
    public static void sendEmailByInvioDEM(List < Anomalie_Doc__c > anomalies) {

        if (anomalies.size() > 0) {
            Id idAccount = anomalies[0].CaseId__r.AccountId;
            String link = anomalies[0].CaseId__r.RO_Link_Bozza__c;
            String nameOfCampaign = anomalies[0].CaseId__r.CampaignId__r.Name;

            String demParam2 = anomalies[0].Descrizione_Anomalia_Op__c;
            String demParam3 = anomalies[1].Descrizione_Anomalia_Op__c;
            Date today = Date.today();
            System.debug('************ Running sendEmailByInvioDEM');
        }
    }

    //Check if Object is NULL or Blank
    public static boolean isNotNullOrEmpty(string str) {
        return str != null || !String.isBlank(str);
    }

    /**************************************************************************
     *@Author Madicke BALDE          
     *@description Convert time into String
     *@param value : Time
     *@return String 
     **************************************************************************/
    public static String ToString(Time Value) {
        // string representation if a Time value 
        System.debug(' ************ Time ' + Value);
        String hours = (Value.hour() < 10) ? 0 + '' + String.valueOf(Value.hour()) : String.valueOf(Value.hour());
        String minutes = (Value.minute() < 10) ? 0 + '' + String.valueOf(Value.minute()) : String.valueOf(Value.minute());
        String seconde = (Value.second() < 10) ? 0 + '' + String.valueOf(Value.second()) : String.valueOf(Value.second());
        String timeString = hours + '' + minutes + '' + seconde;
        System.debug(' ************ returnTime' + timeString);
        return timeString;
    }

    /***************************************************** 
     *@Author Madicke BALDE      
     *@description convert Date to String
     *@param value : Date
     *@return String 
     *******************************************************/
    public static String ToString(Date Value) {
        // string representation if a Date value 
        System.debug(' ************ Date ' + Value);
        String days = (Value.day() < 10) ? 0 + '' + String.valueOf(Value.day()) : String.valueOf(Value.day());
        Integer years = Value.year();
        String month = (Value.month() < 10) ? 0 + '' + String.valueOf(Value.month()) : String.valueOf(Value.month());
        String dateString = years + '' + month + '' + days;
        System.debug(' ************ dateString ' + dateString);
        return dateString;
    }

    public static String formatedDatimeToStringSchedulable(DateTime dt) {
        String dateString;
        System.debug('##################### dt ' + dt);
        try {
            String days = (dt.day() < 10) ? 0 + '' + String.valueOf(dt.day()) : String.valueOf(dt.day());
            Integer years = dt.year();
            String month = (dt.month() < 10) ? 0 + '' + String.valueOf(dt.month()) : String.valueOf(dt.month());
            String hours = (dt.hour() < 10) ? 0 + '' + String.valueOf(dt.hour()) : String.valueOf(dt.hour());
            String minutes = (dt.minute() < 10) ? 0 + '' + String.valueOf(dt.minute()) : String.valueOf(dt.minute());
            String seconde = (dt.second() < 10) ? 0 + '' + String.valueOf(dt.second()) : String.valueOf(dt.second());

            dateString = seconde + ' ' + minutes + ' ' + hours + ' ' + days + ' ' + month + ' ' + ' ' + '?' + ' ' + years;
            System.debug('############### dateString ' + dateString);
            System.debug('############### dateString ' + minutes);
            System.debug('############### dateString ' + dt.minute());

        } catch (Exception e) {
            System.debug('############################ errorMessage ' + e.getMessage());
            System.debug('############################## error ' + e.getStackTraceString());
        }

        return dateString;
    }

    public static Boolean comparedDateTime(Datetime d1, Datetime d2) {
        Boolean returnValue = false;
        System.debug('DateTime now ' + d1);
        System.debug('Time30__c now ' + d2);
        if (d1.isSameDay(d2) && d1 >= d2) {
            returnValue = true;
        }
        return returnValue;
    }

    /*********************************************************
     *@author Madicke BALDE
     *@description method to lauch batch
     *@param Case Map : caseMap
     *@param name schedulable : mn
     *@param time to execute class : numHour
     **********************************************************/
    public static void schedulableJob(Map < Id, Case > caseMap, String mn, Integer numHour) {
        if (caseMap == null || caseMap.size() == 0) {
            return;
        } else {
            Map < String, String > returnValue = CaseService.parseNameJobAndCronExp(numHour);
            System.debug('*********** cronExp *** ' + returnValue.get('cronExp'));
            System.schedule(returnValue.get('namejob'), returnValue.get('cronExp'), new SchedulableJobsInCase(mn, caseMap));
        }

    }

    public static void schedulableJobexecute(Map < Id, Case > caseMap, String mn) {
        if (caseMap == null || caseMap.size() == 0) {
            return;
        } else {
            Datetime executeDate = caseMap.values()[0].LastModifiedDate;
            Map < String, String > returnValue = new Map < String, String > ();
            Datetime dt = executeDate.addMinutes(GIACENZA_PRECARICO);
            System.debug(' ************** dt after ' + GIACENZA_PRECARICO + ' **** ' + dt);
            String cronExp = CGMWSUtils_1_0.formatedDatimeToStringSchedulable(dt);
            String namejob = 'cronExp' + cronExp + '-schedule_Ds-' + caseMap.values()[0].Id;
            System.debug('******** cronExp ' + cronExp);
            returnValue.put('namejob', namejob);
            returnValue.put('cronExp', cronExp);
            System.debug('################ System.isBatch() ' + System.isBatch());
            System.debug('################ System.isFuture() ' + System.isFuture());
            if (System.isBatch() == false && System.isFuture() == false) {
                abordJobInFuture(caseMap.values()[0].Id);
            } else {
                abordJob(caseMap.values()[0].Id);
            }

            System.debug('############################ abordJob after');
            System.schedule(returnValue.get('namejob'), returnValue.get('cronExp'), new SchedulableJobsInCase(mn, caseMap));
        }
    }

    public static void schedulableJobexecute(Map <Id, Case> caseMap, String mn, Integer numberOfHours) {
        System.debug('################ schedulableJobexecute  ok test ');
        if (caseMap == null || caseMap.size() == 0) {
            return;
        } else {
            Datetime executeDate = Datetime.now();
            System.debug('##################### executeDate schedulableJobexecute 24 || 72 ' + executeDate);
            //Datetime dt = (mn == 'afterTwentyFourHours') ? executeDate.addHours(24) : executeDate.addHours(72);
            //gestione per minuti
            Datetime dt = (mn == 'afterTwentyFourHours') ? executeDate.addMinutes(GIACENZA_PRECARICO_24) : executeDate.addMinutes(GIACENZA_PRECARICO_72);
            System.debug('################# dt test ######## ' + dt);
            System.debug('################ schedulableJobexecute  mn ' + caseMap);
            System.debug('################ schedulableJobexecute  mn' + mn);
            String cronExp = CGMWSUtils_1_0.formatedDatimeToStringSchedulable(dt);
            String namejob = 'cronExp' + cronExp + '-schedule_Ds-' + caseMap.values()[0].Id;
            abordJob(caseMap.values()[0].Id);
            System.debug('################## cronEp test ' + cronExp);
            System.schedule(namejob, cronExp, new SchedulableJobsInCase(mn, caseMap));
        }
    }

    public static void sendInvioDemAndSMS(Map < Id, Case > caseMap, String templateName, String DEM, String templateSMS, String subject, String fromAddress, String param) {
        if (caseMap == null || caseMap.size() == 0) {
            return;
        } 

        for (Id idCase: caseMap.keySet()) {
            String accountPhoneNumber = '';
            if (caseMap.get(idCase).AccountId != null) {
                String idAccount = caseMap.get(idCase).AccountId;
                accountPhoneNumber = [SELECT PersonMobilePhone FROM Account WHERE Id= :idAccount].PersonMobilePhone;
            }
            // ************** Call sms *************************** 
            System.debug('#################  sms template ' + templateSMS);
            CaseDomain.sendSMS(accountPhoneNumber, templateSMS);
            //** ***************** call invio DEM*************** 
            CaseDomain.mailDem(DEM, idCase, subject, fromAddress, param);
        }
        
    }


    

    //method to check if date2 is within the next 30 minutes of date1
    public static Boolean DatetimeWithin30mn(Datetime date1, Datetime date2) {
        //check for date2 being in the past
        System.debug('************ date1 ' + date1);
        System.debug('************ date2 ' + date2);
        // tolgo 5 secondi di scarto perchè la schedulazione del job empiricamente ha qualche secondo di incertezza
        Datetime date30mn = date1.addMinutes(GIACENZA_PRECARICO).addSeconds(-5); //create a date 30 minutes away from date1
        System.debug('************ Datetime  ' + date30mn);
        System.debug('************ date2 time30__c  ' + date2);
        if (date2 >= date30mn) {
            return true;
        } else {
            return false;
        }
    }

    public static void dividendoElimina(String dateString, String importoString) {
        String importom = importoString.remove('-');
        Integer montant = Integer.valueOf(importom);
        importoString = String.valueOf(montant);
        Datetime df = CGMWSUtils_1_0.formatStringToDatetime(dateString);
        String deteformat = 'dd/MM/yyyy';
        String ds = df.format(deteformat);
        dateString = ds;
    }
    

    public static void sendInvioDemAndSMS_withFields(Map < Id, Case > caseMap, String fieldDEM, String fieldSMS, String fromAddress, String param) {
        System.debug('***sendInvioDemAndSMS_withFields***START');
        if (caseMap == null || caseMap.size() == 0) {
            return;
        } else {
            for(Case c : caseMap.values()){
                Id idAccount;
                String nameCampaign;
                String accountPhoneNumber;
                if(c.AccountId!=null){
                    System.debug('***HA L ACCOUNT ID-->'+c.AccountId);
                    idAccount = c.AccountId;
                    accountPhoneNumber = c.Account.PersonMobilePhone;
                }
                Product2 prod = (Product2)c.getSObject('Product__r');
                System.debug('il prodotto è -->'+prod);
                String templateSMS;
                if(String.isNotBlank(fieldSMS) && prod.get(fieldSMS) != null){
                    templateSMS = String.valueOf(prod.getSObject(fieldSMS.replace('__c','__r')).get('Name'));
                }
                    
                String templateDEM;
                if(String.isNotBlank(fieldDEM) && prod.get(fieldDEM) != null){
                    templateDEM = String.valueOf(prod.get(fieldDEM));
                }
                
                // ************** Call sms *************************** 
                System.debug('#################  dem template ' + templateDEM);
                System.debug('#################  sms template ' + templateSMS);
                if(String.isNotBlank(accountPhoneNumber) && String.isNotBlank(templateSMS))
                    CaseDomain.sendSMS(accountPhoneNumber, templateSMS);
                //** ***************** call invio DEM*************** 
                if(String.isNotBlank(templateDEM))
                    CaseDomain.mailDem(templateDEM, c.Id, '', fromAddress, param);
            }
            
        }
        System.debug('***sendInvioDemAndSMS_withFields***DONE');
            
    }

    public static void sendNotifications (List<Case> caseList, String fieldDEM, String fieldSMS, String fromAddress, String param) {
        System.debug('***sendNotifications***START');
        if (caseList == null || caseList.size() == 0) {
            return;
        } else {
            for(Case c : caseList){
                Id idAccount;
                String nameCampaign;
                String accountPhoneNumber;
                if(c.AccountId!=null){
                    System.debug('***HA L ACCOUNT ID-->'+c.AccountId);
                    idAccount = c.AccountId;
                    accountPhoneNumber = c.Account.PersonMobilePhone;
                }
                Product2 prod = (Product2)c.getSObject('Product__r');
                System.debug('il prodotto è -->'+prod);
                String templateSMS;
                if(String.isNotBlank(fieldSMS) && prod.get(fieldSMS) != null){
                    templateSMS = String.valueOf(prod.getSObject(fieldSMS.replace('__c','__r')).get('Name'));
                }
                    
                String templateDEM;
                if(String.isNotBlank(fieldDEM) && prod.get(fieldDEM) != null){
                    templateDEM = String.valueOf(prod.get(fieldDEM));
                }
                
                // ************** Call sms *************************** 
                System.debug('#################  dem template ' + templateDEM);
                System.debug('#################  sms template ' + templateSMS);
                if(String.isNotBlank(accountPhoneNumber) && String.isNotBlank(templateSMS))
                    CaseDomain.sendSMS(accountPhoneNumber, templateSMS);
                //** ***************** call invio DEM*************** 
                if(String.isNotBlank(templateDEM))
                    CaseDomain.mailDem(templateDEM, c.Id, '', fromAddress, param);
            }
            
        }
        System.debug('***sendNotifications***DONE');
            
    }

    /**
     *@author Madicke BALDE
     *@date 2019/07/29
     *@description check movementi is in last 30 day
     *@param RecuperaMovAutViaggiantiResponse.MovimentoViaggianteDTO mv
     *@return Boolean
     **/
    public static Boolean checkIfMovementIsInLast30days(String stringDate) {
        System.debug('*************** running   checkIfMovementIsInLast30days   ');
        Boolean inLast30Days = false;
        Date dateOperationLast30days = (Date.today()).addDays(-30);
        Date dateOperation = CGMWSUtils_1_0.formatStringToDate(stringDate);
        System.debug('************dateOperation ' + dateOperation);
        if (dateOperationLast30days > dateOperation) {
            inLast30Days = true;
        }
        System.debug('************ inLast30Days' + inLast30Days);
        return !inLast30Days;
    }

    /**********************************************************************
     *@Author Madicke BALDE
     *@description
     *@date
     *@param Time
     *@return String
     **************************************************************************/
    public static String convertTimeToString(Time t) {
        String h = (t.hour() < 10) ? 0 + '' + String.valueOf(t.hour()) : String.valueOf(t.hour());
        String m = (t.minute() < 10) ? 0 + '' + String.valueOf(t.minute()) : String.valueOf(t.minute());
        String chaine = h + ':' + m;
        return chaine;
    }


    /****************************************************************************************
     *@Author Sana Badji  
     *@description method to get CronTrigger with status WAITING
     *@Date 10/12/2019
     ****************************************************************************************************/
    public static Map < String, List < CronTrigger > > getBatchJobAno() {
        Map < String, List < CronTrigger > > mapJobs = new Map < String, List < CronTrigger >> ();
        List < CronTrigger > jobs = [Select Id, CronJobDetail.Name, CreatedDate, State, NextFireTime From CronTrigger WHERE State = 'WAITING'];
        System.debug('############## jobs' + jobs.size());
        System.debug('############## jobs' + jobs);
        String idJobDS;
        String idJobDSP;
        String idJobEcom;
        for (CronTrigger job: jobs) {
            System.debug('###########job.CronJobDetail.Name ' + job.CronJobDetail.Name);
            if ((job.CronJobDetail.Name).contains('solContrSchedul_DS') ||
                (job.CronJobDetail.Name).contains('anoSchedul_DSP') ||
                (job.CronJobDetail.Name).contains('anoSchedul_Ecom')) {
                System.debug('############## ok ok ');
                idJobDS = (job.CronJobDetail.Name).substringBetween('solContrSchedul_DS-', '-');
                idJobDSP = (job.CronJobDetail.Name).substringBetween('anoSchedul_DSP-', '-');
                idJobEcom = (job.CronJobDetail.Name).substringBetween('anoSchedul_Ecom-', '-');
                if (!mapJobs.keySet().contains(idJobDS)) {
                    mapJobs.put(idJobDS, new List < CronTrigger > {
                        job
                    });
                } else if (!mapJobs.keySet().contains(idJobDSP)) {
                    mapJobs.put(idJobDSP, new List < CronTrigger > {
                        job
                    });
                } else if (!mapJobs.keySet().contains(idJobEcom)) {
                    mapJobs.put(idJobEcom, new List < CronTrigger > {
                        job
                    });
                } else if (mapJobs.keySet().contains(idJobDS)) {
                    System.debug('################  idJobDS ' + idJobDS);
                    List < CronTrigger > ctlist = mapJobs.get(idJobDS);
                    mapJobs.get(idJobDS).add(job);
                } else if (mapJobs.keySet().contains(idJobDSP)) {
                    System.debug('################  idJobDSP ' + idJobDSP);
                    List < CronTrigger > ctlist = mapJobs.get(idJobDSP);
                    mapJobs.get(idJobDSP).add(job);
                } else if (mapJobs.keySet().contains(idJobEcom)) {
                    List < CronTrigger > ctlist = mapJobs.get(idJobEcom);
                    mapJobs.get(idJobEcom).add(job);
                    System.debug('################  idJobDS ' + idJobEcom);
                }
            }
        }
        System.debug('########### map JOB' + mapJobs);
        System.debug('########### map JOB' + mapJobs.keySet());
        return mapJobs;
    }

    /**************************************************************************************
     *@Author SANA BADJI
     *@description  method  abord the old job of a Case
     *@param idCase  : Case Id
     *************************************************************************************/
    @Future
    public static void abordJobAno(Id idCase) {
        System.debug(' ################# running  abordJob');
        Map < String, List < CronTrigger >> mapJobs = getBatchJobAno();
        Map < String, String > existeMap = new Map < String, String > ();
        Id detailId;
        System.debug('################### mapJobs test ' + mapJobs.values());
        System.debug('################### mapJobs test ' + mapJobs.keySet());
        System.debug('################### mapJobs test ' + mapJobs.keySet());
        try {
            for (String key: mapJobs.keySet()) {
                System.debug('################ key key ' + key);
                List < CronTrigger > crts = mapJobs.get(key);
                System.debug('################### crts size ' + crts.size());
                if (crts.size() > 0) {
                    System.debug('################### crts ' + crts);
                    List < ContriggerRecent > listContriger = new List < ContriggerRecent > ();
                    for (CronTrigger cc: crts) {
                        listContriger.add(new ContriggerRecent(cc));
                    }
                    listContriger.sort();
                    System.debug('listContriger ' + listContriger);
                    ContriggerRecent recent = listContriger[0];
                    System.debug('################# the plus recent  ' + key + ' ######' + recent.ctriger);
                    for (ContriggerRecent ct: listContriger) {
                        if (ct.ctriger.Id == recent.ctriger.Id) {
                            System.debug('################### ct abordJob  exist ' + ct.ctriger.Id);
                            System.debug('################### ct abordJob recent exist ' + recent.ctriger.Id);
                            //existeMap.put('idCrob',recent.ctriger.Id);
                            System.abortJob(ct.ctriger.Id);
                        }
                    }
                }
            }
        } catch (Exception e) {
            System.debug('################### errorMessage abordJob ' + e.getMessage());
            System.debug('################### errorMessage abordJob ' + e.getStackTraceString());
        }
    }

    public static Boolean isJobAlreadyScheduled(String jobName) {
        List <CronTrigger> jobs = [SELECT Id, CronJobDetail.Name FROM CronTrigger WHERE State = 'WAITING' AND CronJobDetail.Name = :jobName];
        if (jobs == null || jobs.size() == 0) return false;
        return true;            
    }

    @future
    public static void abortJobs(String jobType, String caseId) {
        String startName = jobType + caseId + '%';
        System.debug('abortJobs, start name-->'+startName);
        List <CronTrigger> jobs = [SELECT Id, CronJobDetail.Name FROM CronTrigger WHERE State = 'WAITING' AND CronJobDetail.Name like :startName];
        for (CronTrigger job : jobs) {
            System.debug('******** aborting job ' + job.CronJobDetail.Name);
            System.abortJob(String.valueOf(job.Id));
        }
    }

    @future
    public static void abortJobs(String jobType, String caseId, String cronTriggerId) {
        String startName = jobType + caseId + '%';
        System.debug('abortJobs, start name-->'+startName);
        List <CronTrigger> jobs = [SELECT Id, CronJobDetail.Name FROM CronTrigger WHERE State = 'WAITING' AND CronJobDetail.Name like :startName AND ID != :cronTriggerId];
        for (CronTrigger job : jobs) {
            System.debug('******** aborting job ' + job.CronJobDetail.Name);
            System.abortJob(String.valueOf(job.Id));
        }
    }

    public static void abortJobsSync(String jobType, String caseId) {
        String startName = jobType + '%' + caseId + '%';
        System.debug('abortJobs, start name-->'+startName);
        List <CronTrigger> jobs = [SELECT Id, CronJobDetail.Name FROM CronTrigger WHERE State = 'WAITING' AND CronJobDetail.Name like :startName];
        for (CronTrigger job : jobs) {
            System.debug('******** aborting job ' + job.CronJobDetail.Name);
            System.abortJob(String.valueOf(job.Id));
        }
    }

    @future
    public static void futureAbortJobRicontattoFromAccount (Set<Id> setAccountId, String jobType){
        System.debug('****CGMWSUtils_1_0.futureAbortJobRicontattoFromAccount****START');
        /*
        code di ricontatto:
        •	Richiamami
        •	Abbandono web PP
        •	Abbandono non forzoso PP 
        •	Abbandono forzoso PP
        */  
        Set<String> codeRicontatto = new Set<String> {'Q333','Q330','Q331','Q332'};
        Map<Id,Group> queueu = new Map<Id,Group>([SELECT id,Type,Name, DeveloperName 
                                FROM GROUP 
                                WHERE Type='Queue' AND DeveloperName in :codeRicontatto]);
        System.debug('trovate le seguenti code-->'+queueu);                     
        if(queueu.size() == 0) return;
        List<Case> cases = [SELECT ID FROM Case where AccountId in :setAccountId AND ownerid in :queueu.keySet()];
        System.debug('trovati i seguenti case che rispettano i parametri-->'+cases); 
        if(cases.size() == 0) return;
        for(Case c : cases){
            abortJobsSync(jobType,c.Id);
        }
        System.debug('****CGMWSUtils_1_0.futureAbortJobRicontattoFromAccount****DONE');
    }

    @future
    public static void rescheduleJobDS(String jobType, String caseId, String jobName, String cron, String timerType) {
        String startName = jobType + caseId + '%';
        System.debug('abortJobs, start name-->'+startName);
        List <CronTrigger> jobs = [SELECT Id, CronJobDetail.Name FROM CronTrigger WHERE State = 'WAITING' AND CronJobDetail.Name like :startName];
        for (CronTrigger job : jobs) {
            System.debug('******** aborting job ' + job.CronJobDetail.Name);
            System.abortJob(String.valueOf(job.Id));
        }
        System.debug('******** rescheduling job ' + jobName);
        SchedulableDS schedule = new SchedulableDS (new Set<Id>{caseId}, timerType, '');
        System.schedule(jobName, cron, schedule);
        System.debug('******** job ' + jobName + ' rescheduled');
    }

    /**************************************************************************************
     *@Author SANA BADJI
     *@description  method  abord the old job of a Case
     *@param idCase  : Case Id
     *************************************************************************************/
    @Future
    public static void abordJobAno(Id idCase, String jobID) {
        System.debug(' ################# running  abordJob');
        if (jobID != null) {
            Map < String, List < CronTrigger >> mapJobs = getBatchJobAno();
            Map < String, String > existeMap = new Map < String, String > ();
            Id detailId;
            System.debug('################### mapJobs test ' + mapJobs.values());
            System.debug('################### mapJobs test ' + mapJobs.keySet());
            System.debug('################### mapJobs test ' + mapJobs.keySet());
            try {
                for (String key: mapJobs.keySet()) {
                    System.debug('################ key key ' + key);
                    List < CronTrigger > crts = mapJobs.get(key);
                    System.debug('################### crts size ' + crts.size());
                    List < CronTrigger > jobs = [Select Id, CronJobDetail.Name, CreatedDate, State, NextFireTime From CronTrigger WHERE State = 'WAITING'];
                    String oldId;
                    CronTrigger jobsName = [Select Id, CronJobDetail.Name, CreatedDate, State, NextFireTime From CronTrigger WHERE State = 'WAITING'
                        AND Id =: jobID
                    ];
                    System.debug('############## jobs' + jobs.size());
                    System.debug('###########job.CronJobDetail.Name recent ' + jobsName.CronJobDetail.Name);
                    String idJobDSrecent = (jobsName.CronJobDetail.Name).substringAfter('solContrSchedul_DS-');
                    String idJobbefor = idJobDSrecent.substringBefore('-');
                    String idJobDSPrecent = (jobsName.CronJobDetail.Name).substringAfter('anoSchedul_DSP-');
                    String idJobEcomrecent = (jobsName.CronJobDetail.Name).substringAfter('anoSchedul_Ecom-');
                    System.debug('###########idJobbefor  ' + idJobbefor);
                    System.debug('###########idJobDSrecent  ' + idJobDSrecent);
                    System.debug('###########idJobDSPrecent  ' + idJobDSPrecent);
                    System.debug('###########idJobEcomrecent  ' + idJobEcomrecent);
                    String idJobDSOld;
                    String idJobDSPOld;
                    String idJobEcomOld;
                    System.debug('############## jobs' + jobsName);
                    for (CronTrigger job: jobs) {
                        System.debug('###########job.CronJobDetail.Name old ' + job.CronJobDetail.Name);
                        idJobDSOld = (job.CronJobDetail.Name).substringAfter('solContrSchedul_DS-');
                        idJobDSPOld = (job.CronJobDetail.Name).substringAfter('anoSchedul_DSP-');
                        idJobEcomOld = (job.CronJobDetail.Name).substringAfter('anoSchedul_Ecom-');
                        System.debug('###########idJobDSOld old ' + idJobDSOld);
                        if (idJobDSOld != idJobDSrecent) {
                            System.abortJob(job.Id);
                        }
                        if (idJobDSPOld != idJobDSPrecent) {
                            System.abortJob(job.Id);
                        }

                        if (idJobEcomOld != idJobEcomrecent) {
                            System.abortJob(job.Id);
                        }
                    }
                }

            } catch (Exception e) {
                System.debug('################### errorMessage abordJob ' + e.getMessage());
                System.debug('################### errorMessage abordJob ' + e.getStackTraceString());
            }
        } else {
            System.debug('################### jobID  is ' + jobID);
        }
    }

    /****************************************************************************************
     *@Author Madicke BALDE  
     *@description method to get CronTrigger with status WAITING
     *@Date 29/11/2019
     ****************************************************************************************************/
    public static Map < String, List < CronTrigger > > getBatchJob() {
        Map < String, List < CronTrigger > > mapJobs = new Map < String, List < CronTrigger >> ();
        List < CronTrigger > jobs = [Select Id, CronJobDetail.Name, CreatedDate, State, NextFireTime From CronTrigger WHERE State = 'WAITING'];
        System.debug('############## jobs' + jobs.size());
        System.debug('############## jobs' + jobs);
        for (CronTrigger job: jobs) {
            System.debug('###########job.CronJobDetail.Name ' + job.CronJobDetail.Name);
            if ((job.CronJobDetail.Name).contains('schedule_Ds') && (job.CronJobDetail.Name).contains('cronExp')) {
                System.debug('############## ok ok ');
                String idJob = (job.CronJobDetail.Name).substringAfter('schedule_Ds-');
                System.debug('################ idJob idJob ' + idJob);
                if (!mapJobs.keySet().contains(idJob)) {
                    mapJobs.put(idJob, new List < CronTrigger > {
                        job
                    });
                } else {
                    System.debug('################ else key');
                    List < CronTrigger > ctlist = mapJobs.get(idJob);
                    mapJobs.get(idJob).add(job);
                }

            }
        }
        System.debug('########### map JOB' + mapJobs);
        System.debug('########### map JOB' + mapJobs.keySet());
        return mapJobs;
    }
    /**************************************************************************************
     *@Author Madicke BALDE
     *@description  method  abord the old job of a Case
     *@param idCase  : Case Id
     *************************************************************************************/
    //@Future
    public static void abordJob(Id idCase) {
        System.debug(' ################# running  abordJob');
        Map < String, List < CronTrigger >> mapJobs = getBatchJob();
        System.debug('################### mapJobs test ' + mapJobs.values());
        System.debug('################### mapJobs test ' + mapJobs.keySet());
        System.debug('################### mapJobs test ' + mapJobs.keySet());
        try {
            for (String key: mapJobs.keySet()) {
                System.debug('################ key key ' + key);
                List < CronTrigger > crts = mapJobs.get(key);
                if (crts.size() > 1) {
                    List < ContriggerRecent > listContriger = new List < ContriggerRecent > ();
                    for (CronTrigger cc: crts) {
                        listContriger.add(new ContriggerRecent(cc));
                    }
                    listContriger.sort();
                    ContriggerRecent recent = listContriger[0];
                    System.debug('################# the plus recent  ' + key + ' ######' + recent.ctriger);
                    for (ContriggerRecent ct: listContriger) {
                        if (ct.ctriger.Id != recent.ctriger.Id) {
                            System.debug('################### ct abordJob ' + ct.ctriger.Id);
                            System.debug('################### ct abordJob ' + ct.ctriger.State);
                            System.abortJob(ct.ctriger.Id);
                        }
                    }
                }
            }

        } catch (Exception e) {
            System.debug('################### errorMessage abordJob ' + e.getMessage());
            System.debug('################### errorMessage abordJob ' + e.getStackTraceString());

        }
    }

    @Future
    public static void abordJobInFuture(Id idCase) {
        System.debug('################## running abordJobInFuture ');
        abordJob(idCase);
    }

    public static void abordJobForCase(Set < Id > idCases) {
        System.debug(' ################# running  abordJob');
        Map < String, List < CronTrigger >> mapJobs = getBatchJob();
        System.debug('################### mapJobs test ' + mapJobs.values());
        System.debug('################### mapJobs test ' + mapJobs.keySet());
        System.debug('################### mapJobs test ' + mapJobs.keySet());
        try {
            for (String key: mapJobs.keySet()) {
                System.debug('################ key key ' + key);
                List < CronTrigger > crts = mapJobs.get(key);
                if (crts.size() > 0 && idCases.contains(key)) {
                    for (CronTrigger ct: crts) {
                        System.debug('################### ct abordJob ' + ct.Id);
                        System.abortJob(ct.Id);
                    }
                }
            }

        } catch (Exception e) {
            System.debug('################### errorMessage abordJob ' + e.getMessage());
            System.debug('################### errorMessage abordJob ' + e.getStackTraceString());

        }
    }

    public static Boolean isStatoGreaterThan(String ocsStatus, String statusToCompare) {
        if (String.isBlank(ocsStatus)) return false;
        String numericStatus = ocsStatus.substring(0,2);
        Integer actualNum = Integer.valueOf(numericStatus);
        Integer numToCompare = Integer.valueOf(statusToCompare);
        return actualNum >= numToCompare;
    }

    public static void createNote(String nameDEM, Case c) {
        String email = c.Account.PersonEmail;
        String anomalies;
        String body = 'a:' + email + '\n' +
            'Link Bozza :' + c.RO_Link_Bozza__c + '\n' +
            'Anomalie DOC:' + c.Anomalie_Doc__r;
        CaseDomain.createFeeditem(nameDEM, body, c.Id);
    }

}