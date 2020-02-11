/**
 * @File Name          : OCSRecuperaCircuitoCartaResponse.cls
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
public class OCSRecuperaCircuitoCartaResponse extends OCSResponse{
    
    @AuraEnabled
    public CircuitoPanCartaDTO recuperaCircuitoCartaResponse {get;set;}

    public OCSRecuperaCircuitoCartaResponse() {
        recuperaCircuitoCartaResponse = new CircuitoPanCartaDTO(); 
    }
    
    public class CircuitoPanCartaDTO  {        
        @AuraEnabled public String pan {get;set;}
        @AuraEnabled public String circuito {get;set;}
        @AuraEnabled public String emettitore {get;set;}
    }

}