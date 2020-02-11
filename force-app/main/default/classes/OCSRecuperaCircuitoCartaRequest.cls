/**
 * @File Name          : OCSRecuperaCircuitoCartaRequest.cls
 * @Description        : 
 * @Author             : Adriana Lattanzi
 * @Group              : 
 * @Last Modified By   : Adriana Lattanzi
 * @Last Modified On   : 13/11/2019, 16:21:08
 * @Modification Log   : 
 *==============================================================================
 * Ver         Date                     Author      		      Modification
 *==============================================================================
 * 1.0    13/11/2019, 16:21:08      Adriana Lattanzi             Initial Version
**/
public class OCSRecuperaCircuitoCartaRequest extends OCSRequest {
    
    @auraEnabled
    public String numPratica{get;set;}

    public OCSRecuperaCircuitoCartaRequest() {
        
        serviceId = 'recuperaCircuitoCarta';
       
    }

}