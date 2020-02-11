/**
 * @File Name          : GestioneIVRCheckReqOnlineIncident.cls
 * @Description        : 
 * @Author             : Federico Negro
 * @Group              : 
 * @Last Modified By   : Federico Negro
 * @Last Modified On   : 9/12/2019, 10:06:38
 * @Modification Log   : 
 * Ver       Date            Author      		    Modification
 * 1.0    9/12/2019   Federico Negro     Initial Version
**/
@RestResource(urlMapping='/ivr_checkonlinecase/*')
global with sharing class GestioneIVRCheckReqOnlineIncident {


    global final static String CATEG_RICHIESTE_ONLINE = '1324';


    @HttpGet 
    global static Integer checkOnLineCase() {
        String id = RestContext.request.params.get('id');
        id = id.leftPad(8 , '0');
        System.debug('checkOnLineCase id:'+id);
        Case[] cases = [SELECT Id FROM Case WHERE Categoria_Riferimento__r.External_Id__c =: CATEG_RICHIESTE_ONLINE AND CaseNumber=:id];
        if (cases!=null && cases.size()>0) {
             return 1;
        }
        return 0;
    }
}