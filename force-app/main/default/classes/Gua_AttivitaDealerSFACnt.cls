/**
 * @File Name          : Gua_ManageUnitaAffariQuery.cls
 * @Description        : 
 * @Author             : Dieynaba Diallo
 * @CreatedDate        : 11/12/2019
**/
public with sharing class Gua_AttivitaDealerSFACnt {
    
    public class CustomException extends Exception {}
    
    @AuraEnabled
    public static Map<String ,Object> getCasesByAccount(String idAccount){
        Map<String ,Object> returnValue = new  Map<String ,Object>();
        returnValue.put('erreur', false);
       try {
           List<Case> AccountCase =  [SELECT  Id, NumeroPratica__c, CodiceDealer__c, Esito__c, Status, Subject, Priority, AccountId FROM Case 
                        WHERE AccountId =: idAccount];
           System.debug('AccountCase' + JSON.serialize(AccountCase));
           returnValue.put('resultat',AccountCase);
            if(AccountCase.size() == 0){
            	returnValue.put('message', 'Nessun contatto trovato');
                throw new CustomException('Nessun contatto trovato');
            }
       } catch (Exception e) {
            System.debug('errorMessage Gua_AttivitaDealerSFACnt getCasesByAccount '+e.getMessage()+' '+e.getLineNumber());
             returnValue.put('message', e.getMessage()+' '+e.getCause()+' '+e.getLineNumber());
             returnValue.put('erreur', true);
       }
        return returnValue;
    }

}