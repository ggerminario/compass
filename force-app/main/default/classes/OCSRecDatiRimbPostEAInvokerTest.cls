/**
* @File Name          : OCSRecDatiRimbPostEAInvokerTest.cls
* @Description        : 
* @Author             : Cristiano
* @Group              : 
* @Last Modified By   : Cristiano
* @Last Modified On   : 16/12/2019, 12:29:58
* @Modification Log   : 
* Ver       Date            Author      		    Modification
* 1.0    13/12/2019   Cristiano     Initial Version
**/
@isTest(SeeAllData=true)
public class OCSRecDatiRimbPostEAInvokerTest {
    
    @isTest
    static void test1(){
        String response = '{"resultCode": 0,"resultMessage": "Ok","recuperaDatiRimborsoPostEAResponse": {"datiRimborsoPostEADTO": null,"elencoPacchettiServizi": [],"elencoPianoAmmortamento": []}}';
        OCSRecuperaDatiRimborsoPostEAInvoker.Request req = new OCSRecuperaDatiRimborsoPostEAInvoker.Request();
        req.authorization = 'Y';
        OCSRecuperaDatiRimborsoPostEAInvoker.OCSRecuperaDatiRimborsoPostEARequestDTO recDati = new OCSRecuperaDatiRimborsoPostEAInvoker.OCSRecuperaDatiRimborsoPostEARequestDTO();
        recDati.numPratica = '123';
        req.recuperaDatiRimborsoPostEARequest = recDati; 
        
        OCSRecuperaDatiRimborsoPostEAInvoker.RecuperaDatiRimborsoPostEAResponseDTO resDto = new OCSRecuperaDatiRimborsoPostEAInvoker.RecuperaDatiRimborsoPostEAResponseDTO();
        OCSRecuperaDatiRimborsoPostEAInvoker.Response res = new OCSRecuperaDatiRimborsoPostEAInvoker.Response();
        res.recuperaDatiRimborsoPostEAResponse = resDto;
        res.isOK();
        res.getMessage();
        
        OCSRecuperaDatiRimborsoPostEAInvoker.DatiRimborsoPostEADTO datiRimb = new OCSRecuperaDatiRimborsoPostEAInvoker.DatiRimborsoPostEADTO();
        datiRimb.tipoPratica = 'cia';
        datiRimb.numPratica = '124';
        datiRimb.codCliente = '001';
        datiRimb.statoPratica = 'b';
        datiRimb.attributoPratica = 'vw';
        datiRimb.dataDecorrenza = '13122019';
        datiRimb.dataCaricamento = '13122019';
        datiRimb.dataPrimaScadenza = '14122020';
        datiRimb.dataUltimaScadenza = '14122020';
        datiRimb.dataEstinzione = '15122021';
        datiRimb.dataChiusura = '16112022';
        datiRimb.dataAccettazione = '230793';
        datiRimb.numRate = '36';
        resDto.datiRimborsoPostEADTO = datiRimb;
        
        OCSRecuperaDatiRimborsoPostEAInvoker.PacchettoServizioDTO pacche = new OCSRecuperaDatiRimborsoPostEAInvoker.PacchettoServizioDTO();
        pacche.codServizio = '002';
        pacche.codPacchetto = '111';
        pacche.codFornitore = '222';
        pacche.dataInizioCopertura = '16122019';
        pacche.dataFineCopertura = '16122020';
        pacche.assicurazioneAttivaFinanziata = 'fz';
        pacche.durata = '360';
        pacche.desFornitore = 'bo';
        pacche.dataFineCoperturaSlashed = '12122021';
        pacche.dataInizioCoperturaSlashed = '12122020';
        string getString = pacche.dataFineCoperturaSlashed;
        getString = pacche.dataInizioCoperturaSlashed;
        system.debug(resDto);
        resDto.elencoPacchettiServizi = new List<OCSRecuperaDatiRimborsoPostEAInvoker.PacchettoServizioDTO>();
        resDto.elencoPacchettiServizi.add(pacche);
        
        OCSRecuperaDatiRimborsoPostEAInvoker.PianoAmmortamentoEADTO piano = new OCSRecuperaDatiRimborsoPostEAInvoker.PianoAmmortamentoEADTO();
        piano.ratePreammortamento = '12';
        piano.numRata = '3';
        piano.dataScadenzaRata = '01012020';
        resDto.elencoPianoAmmortamento = new List<OCSRecuperaDatiRimborsoPostEAInvoker.PianoAmmortamentoEADTO>();
        resDto.elencoPianoAmmortamento.add(piano);
        PVtestFactory pVtestFactory = new PVtestFactory();
        pVtestFactory.pushApiList(response,'recuperaDatiRimborsoPostEA');
        pVtestFactory.finalizeApiList();
        
        Test.startTest();
        /*
System.runAs(contextuser){

}*/
        OCSRecuperaDatiRimborsoPostEAInvoker.invoke(recDati);
        Test.stopTest();
        
    }
}