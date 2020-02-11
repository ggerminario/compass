/**
 * @File Name          : OCSRecuperaRapportoHBCpayRequest.cls
 * @Description        : 
 * @Author             : Adriana Lattanzi
 * @Group              : 
 * @Last Modified By   : Adriana Lattanzi
 * @Last Modified On   : 25/11/2019, 15:50:50
 * @Modification Log   : 
 *==============================================================================
 * Ver         Date                     Author      		      Modification
 *==============================================================================
 * 1.0    25/11/2019, 15:50:50      Adriana Lattanzi             Initial Version
**/
public class OCSRecuperaRapportoHBCpayRequest extends OCSRequest {

    @auraEnabled
    public String codCliente{get;set;}

    public OCSRecuperaRapportoHBCpayRequest() {
        
        serviceId = 'recuperaRapportoHBCpay';
       
    }
}