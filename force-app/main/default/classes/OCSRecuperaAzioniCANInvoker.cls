/**
 * @File Name          : OCSRecuperaAzioniCANInvoker.cls
 * @Description        : 
 * @Author             : Nicola Musicco
 * @Group              : 
 * @Last Modified By   : Nicola Musicco
 * @Last Modified On   : 16/1/2020, 17:42:19
 * @Modification Log   : 
 * Ver       Date            Author      		    Modification
 * 1.0    19/12/2019   Nicola Musicco     Initial Version
**/
public class OCSRecuperaAzioniCANInvoker {
   
    public class Request extends OCSRequest {

		public OCSRecuperaAzioniCANRequestDTO recuperaAzioniCANRequest { get; set; }

		public Request() {
			serviceId = 'recuperaAzioniCAN';
			recuperaAzioniCANRequest = new OCSRecuperaAzioniCANRequestDTO();
		}

	}

   public class OCSRecuperaAzioniCANRequestDTO{
       

       public String dataAzione {get; set;}
       public String numPratica { get; set; }

   }

   

    public static OCSRecuperaAzioniCANResponse invoke(OCSRecuperaAzioniCANRequestDTO input) {
	    Request req = new Request();
		req.recuperaAzioniCANRequest = input;
		Date d= Date.today();
		String day=String.valueOf(d.day()).length()==1? '0'+ d.day() : String.valueOf(d.day());
		String month=String.valueOf(d.month()).length()==1? '0'+ d.month() : String.valueOf(d.month());
        req.recuperaAzioniCANRequest.dataAzione= String.valueOf(d.year() +''+ month +''+ day);
        OCSRecuperaAzioniCANResponse resp=(OCSRecuperaAzioniCANResponse) ApiUtils.callApi('ocs.recuperaAzioniCAN', req, OCSRecuperaAzioniCANResponse.class, 'C');
		System.debug('Response code: '+resp.resultCode);
		System.debug('Status code: '+resp.statusCode);

	    return  resp;
	}


}