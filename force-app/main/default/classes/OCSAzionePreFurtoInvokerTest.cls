@IsTest
public with sharing class OCSAzionePreFurtoInvokerTest {
   @TestSetup
    public static void setup() {
        insert new ApiRest__c(Name = 'ocs.azionePreFurtoFurto', Ref__c = 'CompassInternal', EndPoint__c = 'Test', Method__c = 'POST', User__c = 'Test', Password__c = 'Test');
        insert new ApiUtil__c(Name = 'CompassInternal', Ref__c = 'CompassInternal', EndPoint__c = 'Test', User__c = 'Test', Password__c = 'Test');
    }

 @IsTest
    public static void azionePreFurtoFurtoTest() {
        Test.startTest();
        OCSAzionePreFurtoInvoker.Response response = getOCSAzionePreFurtoInvokerResponse();
        Test.setMock(HttpCalloutMock.class, new AzionePreFurtoFurtoInvokerMock(JSON.serialize(response)));
        OCSAzionePreFurtoInvoker.AzionePreFurtoFurtoRequestDTO azionePreFurtoFurtoRequestDTO = new OCSAzionePreFurtoInvoker.AzionePreFurtoFurtoRequestDTO();
        azionePreFurtoFurtoRequestDTO.provenienza = 'CA';
        azionePreFurtoFurtoRequestDTO.tipoIntermediario = 'AG';
        azionePreFurtoFurtoRequestDTO.intermediario = '12';
        azionePreFurtoFurtoRequestDTO.numCarta = '3109269996';
        azionePreFurtoFurtoRequestDTO.operazione = 'F';
        azionePreFurtoFurtoRequestDTO.modEmissione = 'S';
        azionePreFurtoFurtoRequestDTO.dataValidita = '20190913';
        azionePreFurtoFurtoRequestDTO.mesiValidita = '0';
        azionePreFurtoFurtoRequestDTO.importoCommissioni = '';
        azionePreFurtoFurtoRequestDTO.addebitoCommissioni = 'S';
        azionePreFurtoFurtoRequestDTO.utente = '';
        response = OCSAzionePreFurtoInvoker.invoke(azionePreFurtoFurtoRequestDTO);
        Test.stopTest();
        System.assertEquals(true, response != null && response.statusCode == 200);
    }

    private class AzionePreFurtoFurtoInvokerMock implements HttpCalloutMock {

        public String body { get; set;}

        public AzionePreFurtoFurtoInvokerMock(String body) {
            this.body = body;
        }

        public HttpResponse respond(HttpRequest request) {
            HttpResponse response = new HttpResponse();
            response.setHeader('Content-Type', 'application/json');
            response.setStatus('OK');
            response.setStatusCode(200);
            response.setBody(this.body);
            return response;
        }
    }

    private static OCSAzionePreFurtoInvoker.Response getOCSAzionePreFurtoInvokerResponse() {
        OCSAzionePreFurtoInvoker.Response response = new OCSAzionePreFurtoInvoker.Response();
        response.resultCode = 0;
        response.resultMessage = 'OK';
        response.azionePreFurtoFurtoResponse = new OCSAzionePreFurtoInvoker.AzionePreFurtoFurtoResponseDTO();
        response.azionePreFurtoFurtoResponse.panNuovo = '56574839';
        response.azionePreFurtoFurtoResponse.as400Status = 'OK';
        response.azionePreFurtoFurtoResponse.as400Errore = '';
        return response;
    }
}