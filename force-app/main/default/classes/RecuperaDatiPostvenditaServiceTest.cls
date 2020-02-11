@isTest
public with sharing class RecuperaDatiPostvenditaServiceTest {
    
    
    @isTest
    static void getPraticheValidetest(){
        List<RecuperaDatiPostvenditaResponse.PSVDatiPraticaDTO> pratiches = new List<RecuperaDatiPostvenditaResponse.PSVDatiPraticaDTO> ();
        
        RecuperaDatiPostvenditaResponse.PSVDatiPraticaDTO p = new RecuperaDatiPostvenditaResponse.PSVDatiPraticaDTO();
        p.tipoPratica='CA';
        p.codAttributoPratica ='';
        p.codStatoPratica ='50';
        pratiches.add(p);

        RecuperaDatiPostvenditaResponse.PSVDatiPraticaDTO p1 = new RecuperaDatiPostvenditaResponse.PSVDatiPraticaDTO();
        p1.tipoPratica='CA';
        p1.codAttributoPratica ='CF';
        p1.codStatoPratica ='30';
        pratiches.add(p1);

        RecuperaDatiPostvenditaResponse.PSVDatiPraticaDTO p2 = new RecuperaDatiPostvenditaResponse.PSVDatiPraticaDTO();
        p2.tipoPratica='CP';
        p2.codAttributoPratica ='CF';
        p2.codStatoPratica ='30';
        pratiches.add(p2);

        RecuperaDatiPostvenditaResponse.PSVDatiPraticaDTO p3 = new RecuperaDatiPostvenditaResponse.PSVDatiPraticaDTO();
        p3.tipoPratica='CO';
        p3.codAttributoPratica ='CF';
        p3.codStatoPratica ='40';
        pratiches.add(p3);

        RecuperaDatiPostvenditaResponse.PSVDatiPraticaDTO p4 = new RecuperaDatiPostvenditaResponse.PSVDatiPraticaDTO();
        p4.tipoPratica='CO';
        p4.codAttributoPratica ='';
        p4.codStatoPratica ='40';
        pratiches.add(p4);



        Test.startTest();
        List<RecuperaDatiPostvenditaResponse.PSVDatiPraticaDTO> returnValue = RecuperaDatiPostvenditaService.getPraticheValide(pratiches);
        System.debug('############### returnValue'+returnValue);
        for( RecuperaDatiPostvenditaResponse.PSVDatiPraticaDTO pp : returnValue){
            System.debug('######## '+pp.tipoPratica +' ##### '+pp.codStatoPratica +' ##### '+pp.codAttributoPratica);
        }

        Test.stopTest();
    }
}