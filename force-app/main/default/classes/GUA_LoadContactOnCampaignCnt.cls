//----------------------------------------------------------------------
//-- - Author       : Aminata GUEYE
//-- - Date         : 22/09/2019
//-- - Class  : GUA_LoadContactOnCampaignCnt
//----------------------------------------------------------------------
public with sharing class GUA_LoadContactOnCampaignCnt {
    public static string myDate{get;set;}
    public static String[] csvRecordData = new String[]{};
    public  static   Map<String, Object> dataAccount = new Map<String, Object>();
/**
* @description:Insert List Case
* @date:17/09/2019
* @author: Aminata GUEYE 
* @Modify by: Sana BADJI | Date: 30/09/19
* @params: data | List<String>
* @return: List<Case> 
*/
    @AuraEnabled
    public static  Map<String,Object>  saveFile(List<String> data ,String campaignId,List < String > linesWithErrors){
        string header ='Codice pratica;Stato pratica;Priorita;Scadenza;Cognome;Nome;Data_caricamento;Data_delibera;Data_liquidazione;Importo_erogato;Cod_Convenzionato_H3G;Descr_Convenzionato_H3g;Codice_Fiscale_Conv;Partita_IVA_Conv;Codice_PV_H3G;Codice dealer;Descr_PV_H3G;Num I telefono;Num II telefono;Codice_Filiale_Compass;Filiale_Compass;gg_trascorsi_dalla_delibera;gg_trascorsi_dalla_liquidazione;Note;Anomalia_num_2;Anomalia_num_3;Anomalia_num_4;Anomalia_num_5';
        Map<String,Object> response = new Map<String,Object>();
		string finalstr = header;
		List<string> dataconvertToCsv = new List<String>();
        dataconvertToCsv.add(header);
		// Save the dataBase
        SavePoint sp = Database.setSavePoint();
        System.debug('List data ' +data);
        System.debug('size data ' +data.size());
        System.debug('campaignId ' +campaignId);
        if( data.size()==0 && campaignId==null){
        System.debug('campaignId is :' +campaignId);
        System.debug('list data is empty :' +campaignId);
        }
         List<Case> listCaseToinsert = new List<Case>();
         
         String csv = null;
        try{
            XCS_Categoria__c cat = [SELECT Id, Name, XCS_Disposition__c, XCS_Template__c, Parent__c, External_Id__c, Livello__c FROM XCS_Categoria__c WHERE External_Id__c = '5221' LIMIT 1];
            // Categoria_Riferimento__c
            // Disposition__c
			for(Integer j = 0; j < data.size(); j++) {
                //Boolean exist = false;
                Case c = new Case();

                csvRecordData = data[j].split(';');
                //data[j].replaceAll(' ','""');
                
                System.debug('csvRecordData size ' +csvRecordData.size());
                System.debug('csvRecordData  ' +csvRecordData);
                System.debug('csvRecordData[j] ' +csvRecordData[j]);
                System.debug('NumeroPratica ' +csvRecordData[0]);
                System.debug('Stato_Pratica ' +csvRecordData[1]);
                System.debug('Priority ' +csvRecordData[2]);
                System.debug('Scadenza__c ' +csvRecordData[3]);
                System.debug('Anomalia_num_2 ' +csvRecordData[24]);
                System.debug('Anomalia_num_3 ' +csvRecordData[25]);
                System.debug('Anomalia_num_5 ' +csvRecordData[26]);
                myDate =csvRecordData[3];
                 Date dateScadenza= GUA_LoadContactOnCampaignCnt.setStringToDateFormat(myDate);
                System.debug('Date parse Scadenza ' +dateScadenza);
                System.debug('Note ' +csvRecordData[23]);
                System.debug('CodiceDealer ' +csvRecordData[15]);
                
                 GUA_CSVparsingJSON jsonCsv = 
                new GUA_CSVparsingJSON (csvRecordData[4],
                csvRecordData[5],csvRecordData[6], 
                csvRecordData[7],csvRecordData[8],
                csvRecordData[9],csvRecordData[10],
                csvRecordData[11],csvRecordData[12],
                csvRecordData[13],csvRecordData[14],
                csvRecordData[16],csvRecordData[17],
                csvRecordData[18],csvRecordData[19],
                csvRecordData[20],csvRecordData[21],
                csvRecordData[22],csvRecordData[24],
                csvRecordData[25],csvRecordData[26], 
                csvRecordData[27]);
                String caseJSON = JSON.serialize(jsonCsv,true);
                System.debug('caseJSON' +caseJSON);    
                GUA_CSVparsingJSON mainJSONWrapper = (GUA_CSVparsingJSON) JSON.deserialize(caseJSON,GUA_CSVparsingJSON.class);
                System.debug('mainJSONWrapper' +mainJSONWrapper);
                String codiceDealer=csvRecordData[15];
                String cognome= csvRecordData[4];
                String nome =csvRecordData[5];
                String name=cognome+' '+nome;
                Account accOut1=createAccount(codiceDealer);
                System.debug('********************** account'+accOut1);
               /*  System.debug('********************** account '+account);
                Map<Account, DealerAccount> accountMap = new Map<Account, DealerAccount>();
                accountMap.put(account, null);
                System.debug('********************** accountMap before execute'+accountMap);
                XCSGestioneAnagraficaDealer.execute(accountMap, true);
                DealerAccount dealerAcc = accountMap.get(account);
                Account accOut1 = dealerAcc.account;
                System.debug('********************** accountMap '+accountMap);
                System.debug('********************** account '+account);
                System.debug('******************* dealerAcc ***************** '+dealerAcc.account);  */
                System.debug('******************* accOut1 ***************** '+accOut1.Id); 
                Id recordType=CGMWSUtils_1_0.getRecordTypeId('Case','GUA_Contact');
                c.RecordTypeId=recordType;
                c.NumeroPratica__c = csvRecordData[0].replace('\'\'',''); 
                c.Stato_Pratica__c =csvRecordData[1].replace('\'\'','');
                c.Priority = csvRecordData[2].replace('\'\'','');
                c.Scadenza__c =  dateScadenza;
                c.CodiceDealer__c =csvRecordData[15].replace('\'\'','');
                c.Note__c = csvRecordData[23].replace('\'\'','');
                c.UAF_DatiAggiuntiviFile__c =caseJSON.replace('\'\'','');
                c.CampaignId__c =campaignId;
                c.AccountId=accOut1.Id;
                c.Categoria_Riferimento__c = cat.Id;

                listCaseToinsert.add(c);
                   /*  if (!exist) {
                        linesWithErrors.add(data[j]);
                        data.remove(j);
                    } */
                    System.debug('listCaseToinsert  size ' +listCaseToinsert.size());
				}
                 // insert caseListToInsert;
				if (listCaseToinsert.size() > 0) {				  
					upsert listCaseToinsert;
                    System.debug('listCaseToinsert insert suucessfully' +listCaseToinsert.size());
				}

				//<<< Create CSV Report
				for (String linex: data) {
                    //dataconvertToCsv.add(successLine);
					finalstr = finalstr + linex;
				}
				for (String linex: linesWithErrors) {
					dataconvertToCsv.add(linex);
					finalstr = finalstr + linex;
				}
				csv = createCSVfile(finalstr);
				System.debug('lineError: ' + linesWithErrors.size());
				System.debug('lineSuccess : ' + data.size());

            }
            catch(Exception e){
                // Rollback
                Database.rollback(sp);
                csv = createCSVfile(finalstr);
                System.debug('Error insert Case' +listCaseToinsert);
                System.debug('cause: '+ e.getCause());
                System.debug('Line N°: '+ e.getLineNumber());
                System.debug('message debug: ' + e.getMessage());
                System.debug('Cause debug: ' + e.getCause());
                System.debug('Line N°: '+ e.getLineNumber());

            }   
            response.put('listCaseToinsert',listCaseToinsert); 
            response.put('dataconvertToCsv',dataconvertToCsv) ;
        return  response;  
    }
/**
* @description:Format String Date to type Date
* @date:30/09/19
* @author: Sana BADJI 
* @params: myDate | String
* @return: Date
*/
    
     @AuraEnabled
    public static Date setStringToDateFormat(String myDate) {
        System.debug('myDate-->'+myDate);
        String blankValue = '\'\'';
        if(String.isBlank(myDate) || myDate.equals(blankValue)) return null;
        String[] myDateOnly = myDate.split(' ');
        String[] strDate = myDateOnly[0].split('/');
        Integer myIntDate = integer.valueOf(strDate[1]);
        Integer myIntMonth = integer.valueOf(strDate[0]);
        Integer myIntYear = integer.valueOf(strDate[2]);
        Date d = Date.newInstance(myIntYear, myIntMonth, myIntDate);
        return d;
    }
    
/**
* @description:Method Create Account 
* @date:08/10/19
* @author: Sana BADJI 
* @params: codiceDealer | String
* @return: Account
*/
    public static Account createAccount(String codiceDealer){
            /******************************** Create Account Object **************************** */
            Integer randomNumber = Integer.valueof((30 * Math.random()+1));
            System.debug('randomNumber is'+randomNumber);
            Account account = new Account(
                Name = 'Test',
                OCS_External_Id__c=codiceDealer,
                OCSAreaId__c=randomNumber
            );
            System.debug('********************** account '+account);
            Map<Account, DealerAccount> accountMap = new Map<Account, DealerAccount>();
            accountMap.put(account, null);
            System.debug('********************** accountMap before execute'+accountMap);
            XCSGestioneAnagraficaDealer.execute(accountMap, true);
            DealerAccount dealerAcc = accountMap.get(account);
            Account accOut1 = dealerAcc.account;
            return accOut1;

    }

/**
* @description:Method Create CSV
* @date:18/11/19
* @author: Sana BADJI 
* @params: finalstr | String
*/
	public static String createCSVfile(String finalstr) {
       String csv = null;
		try {
			blob csvBlob = Blob.valueOf(finalstr);
			System.debug('--- createCSVfile Method Content of CSV file Created ---: ' + csvBlob.toString());
			csv = csvBlob.toString();
            /* Messaging.EmailFileAttachment csvAttc = new Messaging.EmailFileAttachment();
			string csvname = 'Results.csv';
			csvAttc.setFileName(csvname);
			csvAttc.setBody(csvBlob);
			Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
			String[] toAddresses = new list < string > {
				'assanebadji16@gmail.com'
			};//UserInfo.getUserEmail()
			String subject = 'Results Of Importation data  in CSV File';
			email.setSubject(subject);
			email.setToAddresses(toAddresses);
			email.setPlainTextBody('Results Of Importation data  in CSV File ');
			email.setFileAttachments(new Messaging.EmailFileAttachment[] {
				csvAttc
			});
			Messaging.SendEmailResult[] r = Messaging.sendEmail(new Messaging.SingleEmailMessage[] {
				email
			}); */
		} catch(Exception e) {
			System.debug('createCSVfile Method --> Error creating CSV file: ' + e.getMessage());
			//Adding the error message if an exception is occured
			System.debug('error creating CSV: '+ true);
			System.debug('message creating CSV: '+ e.getMessage());
			System.debug('cause creating CSV: '+ e.getCause());
			System.debug('Line N° creating CSV: '+ e.getLineNumber());
		}
        return csv;
	}
}