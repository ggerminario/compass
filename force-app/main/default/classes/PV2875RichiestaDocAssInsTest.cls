/**
 * @File Name          : PV2875RichiestaDocAssInsTest.cls
 * @Description        : 
 * @Author             : Federico
 * @Group              : 
 * @Last Modified By   : Cristiano
 * @Last Modified On   : 10/1/2020, 11:29:20
 * @Modification Log   : 
 * Ver       Date            Author      		    Modification
 * 1.0    16/12/2019   Federico     Initial Version
**/
@isTest (SeeAlldata=true)
public class PV2875RichiestaDocAssInsTest {
    static String categoria='2875';
    static String response = '{"resultCode": 0,"resultMessage": "Ok","recuperaDatiRimborsoPostEAResponse": {"datiRimborsoPostEADTO": null,"elencoPacchettiServizi": [],"elencoPianoAmmortamento": []}}';    

    static testMethod void Tes1() {
    Fascicolo_informativo__c  fascicolo = new Fascicolo_informativo__c();
    fascicolo.Codice_servizio__c = '003';
    fascicolo.Tipologia__c = 'Fascicolo Informativo';
    insert fascicolo;
    PVtestFactory pVtestFactory = new PVtestFactory();
    PV2875RichiestaDocAssIns.PV2875RichiestaDocAssInsForm form = new PV2875RichiestaDocAssIns.PV2875RichiestaDocAssInsForm();
    form = (PV2875RichiestaDocAssIns.PV2875RichiestaDocAssInsForm) pVtestFactory.initForm(categoria, form);
    
    form.pacchettiSelezionati = new List<OCSRecuperaDatiRimborsoPostEAInvoker.PacchettoServizioDTO>();

    OCSRecuperaDatiRimborsoPostEAInvoker.PacchettoServizioDTO pacche = new OCSRecuperaDatiRimborsoPostEAInvoker.PacchettoServizioDTO();
    pacche.codServizio = '003';
    pacche.codPacchetto = '111';
    pacche.codFornitore = '222';
    pacche.dataInizioCopertura = '16122019';
    pacche.dataFineCopertura = '16122020';
    pacche.assicurazioneAttivaFinanziata = 'fz';
    pacche.durata = '360';
    //pacche.desFornitore = 'bo';
    pacche.dataFineCoperturaSlashed = '12122021';
    pacche.dataInizioCoperturaSlashed = '12122020';
    form.pacchettiSelezionati.add(pacche);

    form.mappaPacchettiSelezionati  = new Map<String,String>();
    form.mappaPacchettiSelezionati.put('003','3');

    pVtestFactory.pushApiList(response,'recuperaDatiRimborsoPostEA');
    pVtestFactory.finalizeApiList();
    Test.startTest();
    PV2875RichiestaDocAssIns.conferma(form);
    Test.stopTest();
   
    }
    static testMethod void Tes2() {
        PVtestFactory pVtestFactory = new PVtestFactory();
        pVtestFactory.pushApiList(response,'recuperaDatiRimborsoPostEA');
        pVtestFactory.finalizeApiList();
        Test.startTest();
        String numPratica = '123';
        PV2875RichiestaDocAssIns.recuperaPacchettiAssicurativi(numPratica);
        Test.stopTest();
    // PV2875RichiestaDocAssIns.recuperaPacchettiAssicurativi('ABC1');
     }
    static testMethod void Tes3() {
    Fascicolo_informativo__c  fascicolo = new Fascicolo_informativo__c();
    fascicolo.Codice_servizio__c = '002';
    fascicolo.Tipologia__c = 'Vademecum';
    insert fascicolo;
    PVtestFactory pVtestFactory = new PVtestFactory();
    PV2875RichiestaDocAssIns.PV2875RichiestaDocAssInsForm form = new PV2875RichiestaDocAssIns.PV2875RichiestaDocAssInsForm();
    form = (PV2875RichiestaDocAssIns.PV2875RichiestaDocAssInsForm) pVtestFactory.initForm(categoria, form);
    
    form.pacchettiSelezionati = new List<OCSRecuperaDatiRimborsoPostEAInvoker.PacchettoServizioDTO>();

    OCSRecuperaDatiRimborsoPostEAInvoker.PacchettoServizioDTO pacche = new OCSRecuperaDatiRimborsoPostEAInvoker.PacchettoServizioDTO();
    pacche.codServizio = '002';
    pacche.codPacchetto = '111';
    pacche.codFornitore = '222';
    pacche.dataInizioCopertura = '16122019';
    pacche.dataFineCopertura = '16122020';
    pacche.assicurazioneAttivaFinanziata = 'fz';
    pacche.durata = '360';
    //pacche.desFornitore = 'bo';
    pacche.dataFineCoperturaSlashed = '12122021';
    pacche.dataInizioCoperturaSlashed = '12122020';
    form.pacchettiSelezionati.add(pacche);

    form.mappaPacchettiSelezionati  = new Map<String,String>();
    form.mappaPacchettiSelezionati.put('002','2');

    pVtestFactory.pushApiList(response,'recuperaDatiRimborsoPostEA');
    pVtestFactory.finalizeApiList();
    Test.startTest();
    PV2875RichiestaDocAssIns.conferma(form);
    Test.stopTest();    
    }
    static testMethod void Tes4() {
    Fascicolo_informativo__c  fascicolo = new Fascicolo_informativo__c();
    fascicolo.Codice_servizio__c = '001';
    fascicolo.Tipologia__c = 'Fascicolo Informativo';
    insert fascicolo;
    PVtestFactory pVtestFactory = new PVtestFactory();
    PV2875RichiestaDocAssIns.PV2875RichiestaDocAssInsForm form = new PV2875RichiestaDocAssIns.PV2875RichiestaDocAssInsForm();
    form = (PV2875RichiestaDocAssIns.PV2875RichiestaDocAssInsForm) pVtestFactory.initForm(categoria, form);
    
    form.pacchettiSelezionati = new List<OCSRecuperaDatiRimborsoPostEAInvoker.PacchettoServizioDTO>();

    OCSRecuperaDatiRimborsoPostEAInvoker.PacchettoServizioDTO pacche = new OCSRecuperaDatiRimborsoPostEAInvoker.PacchettoServizioDTO();
    pacche.codServizio = '001';
    pacche.codPacchetto = '111';
    pacche.codFornitore = '222';
    pacche.dataInizioCopertura = '16122019';
    pacche.dataFineCopertura = '16122020';
    pacche.assicurazioneAttivaFinanziata = 'fz';
    pacche.durata = '360';
    //pacche.desFornitore = 'bo';
    pacche.dataFineCoperturaSlashed = '12122021';
    pacche.dataInizioCoperturaSlashed = '12122020';
    form.pacchettiSelezionati.add(pacche);

    form.mappaPacchettiSelezionati  = new Map<String,String>();
    form.mappaPacchettiSelezionati.put('001','1');

    pVtestFactory.pushApiList(response,'recuperaDatiRimborsoPostEA');
    pVtestFactory.finalizeApiList();
    Test.startTest();
    PV2875RichiestaDocAssIns.conferma(form);
    Test.stopTest();    
    }
}