@isTest
public with sharing class SFACommodity_Controller_Test {
    
    
    @isTest
    public static void test1() {

        Case cas = New case();
        cas.NumeroPratica__c = '123456';
        cas.Status = 'Nuovo';
        insert cas;

        sfa_commodity_check_activity_details__c scadc  = new sfa_commodity_check_activity_details__c();
        scadc.Activity_Id__c = cas.Id; 
        scadc.Allegato_sospeso__c = null; 
        scadc.Categoria__c = 'CATEG Test';
        scadc.Cod_agente_convenzionato__c = null; 
        scadc.Cod_esito__c = 'C00'; 
        scadc.Cod_subagente_pv__c = null; 
        scadc.Data_notifica__c = Date.valueOf('2019-11-21'); 
        scadc.Data_verifica__c = Date.valueOf('2019-11-21'); 
        scadc.Debitore__c = null; 
        scadc.Dipendente__c = null; 
        scadc.Esito__c = 'ESITO TEST'; 
        scadc.Esito_finale_md__c = 'ESITO TEST FINALE'; 
        scadc.Nota_compass__c = 'Nota COMPASS'; 
        scadc.Nota_societa_esterna__c = 'Nota Soc Est'; 
        scadc.Nota_sospesa__c = 'Nota Sospesa';
        scadc.Num_Pratica__c = '123456'; 
        scadc.pratica_carta__c = 'P'; 
        scadc.question1__c = null; 
        scadc.question2__c = null; 
        scadc.question3__c = null; 
        scadc.Rag_sociale_agente_convenzionato__c = null;
        scadc.Rag_sociale_subagente_pv__c = null; 
        scadc.Ritardo_dealer__c = null; 
        scadc.Name = 'ATTIVIT TEST'; 
        scadc.Societa__c = null; 
        scadc.Tipo_prodotto__c = 'PA-PF';
        insert scadc;

/*
        sfa_commodity_check_esiti_finali_md__mdt sccefmd = new sfa_commodity_check_esiti_finali_md__mdt();
        sccefmd.Esito_Chiusura__c = 'N44'; 
        sccefmd.Descrizione_Esito__c = 'Anomalia non Risolta';
        sccefmd.DeveloperName = 'PAPF24'; 
        sccefmd.id__c = 24; 
        sccefmd.Language = 'IT'; 
        sccefmd.MasterLabel = 'PAPF'; 
        sccefmd.NamespacePrefix = null; 
        sccefmd.Tipo_Prodotto__c = 'PA-PF';
        insert sccefmd;
*/
/*
        sfa_commodity_check_esiti_soc_est__mdt sccese = new sfa_commodity_check_esiti_soc_est__mdt();
        sccese.Categoria__c = ''; 
        sccese.Desc__c = ''; 
        sccese.DeveloperName = ''; 
        sccese.Esito__c = ''; 
        sccese.id__c = ''; 
        sccese.Language = ''; 
        sccese.NamespacePrefix = ''; 
        sccese.QualifiedApiName = ''; 
        sccese.Tipo__c = '';
        insert sccese;
*/


		Map<String,List<String>> serviceIdResponseMap = new Map<String,List<String>>();
        
        List<String> respRDP= new List<String>();
        List<String> respRDC= new List<String>();
        
        respRDP.add('{"resultCode":0,"resultMessage":"Ok", "recuperaDatiPraticaCommodityResponse":{"datiPraticaCommodityDTO":{"numPratica":"1234","codCliente":null,"abi":null,"cab":null,"numConto":null,"iban":null,"statoPratica":null,"tipoPagamento":null,"prodotto":null,"filiale":null,"dataEstinzione":null,"tipoPratica":null,"dataCaricamento":null,"pan":null,"convenzionato":null,"puntoVendita":null,"venditore":null,"agente":null,"subAgente":null,"flagRecupero":null,"classiRecupero":null,"societa":null,"elencoCoobbligati":null,"codStatoPratica":null,"codAttributoPratica":null,"desStatoPratica":null,"desAttributoPratica":null,"codRecuperatore":null,"desRecuperatore":null,"canale":null}],"cliente":[{"cognome":"GIULIANI","codCliente":"55281774","nome":"FABIO", "dataNascita":"19690318", "luogoNascita":"ROMA", "provNascita":"RM", "sesso":"M", "codFiscale":null, "piva":null, "indirizzo":"VIALE ETIOPIA", "cap":"00199", "localita":"ROMA", "provincia":"RM", "paeseEstero":null, "email":null, "tipoDocumento":"", "numDocumento":"","ufficioRilascio":""}]}');
        respRDC.add('{"resultCode":0,"resultMessage":"Ok","datiChiusuraSinistroResponse":[{"compagnia":"ALICO", "tipoPratica":"CO", numPratica":"12345","flagEsito":"C","esito":"CON INDENNIZZO","motivo":null,"importoIndennizzato":"200","cognome":"GIULIANI","nome":"FABIO","tipoSinistro":"MG","tipoPagamento":"CLO","desScarto":"OK"}]}');

        serviceIdResponseMap.put('recuperaDatiPraticaCommodity', respRDP);
        serviceIdResponseMap.put('recuperaDatiCartaDealer', respRDC);

        ApiRest__c rest3 = new ApiRest__c(Method__c = 'POST' ,Test_Response__c='',Test_Request__c = 'testRequest',Mock__c = false,User__c = 'CDSLF00',Password__c = 'P00FLSDC' ,ref__c = 'CompassInternal',Name ='ocs.recuperaDatiPraticaCommodity',EndPoint__c = 'https://richiestaonlinesvi.compassonline.it/B2BSOAP/rest/B2BREST/execute');
        insert rest3;
        ApiRest__c rest4 = new ApiRest__c(Method__c = 'POST' ,Test_Response__c='',Test_Request__c = 'testRequest',Mock__c = false,User__c = 'CDSLF00',Password__c = 'P00FLSDC' ,ref__c = 'CompassInternal',Name ='ocs.recuperaDatiCartaDealer',EndPoint__c = 'https://richiestaonlinesvi.compassonline.it/B2BSOAP/rest/B2BREST/execute');
        insert rest4;
        ApiUtil__c uti = new ApiUtil__c(Name = 'CompassInternal' ,EndPoint__c ='https://richiestaonlinesvi.compassonline.it/B2BSOAP/rest/B2BREST/execute' ,Password__c = 'P00FLSDC',User__c = 'CDSLF00');      
        insert uti;
        
        UtilityMockResponse UMR = new UtilityMockResponse();
        
        Test.setMock(HttpCalloutMock.class, new UtilityMockResponseMultipleService(serviceIdResponseMap));
        SFACommodity_Controller.getActivity(cas.Id);
        List<sfa_commodity_check_esiti_finali_md__mdt> s = SFACommodity_Controller.getChiusura(scadc.Tipo_prodotto__c );
		Boolean b = SFACommodity_Controller.getSospendi(cas.Id, 'NOTA SOSPESA', 'Si', 'Cell', 'Si', true, 'Return_To_Branch', null, null);   
		Boolean b1 = SFACommodity_Controller.getSospendi(cas.Id, 'NOTA SOSPESA', 'Si', 'Cell', 'Si', false, 'Return_To_Branch', null, null);
        Map<String,String> ms = SFACommodity_Controller.getUserMap();


    }
}