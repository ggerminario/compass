/**
 * @File Name          : OCSRecuperaCircuitoCartaInvoker.cls
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
public class OCSRecuperaCircuitoCartaInvoker {
    // company da impostare a F per Futuro, C per Compass
    
    public static OCSRecuperaCircuitoCartaResponse callRecCircuitoCarta(OCSRecuperaCircuitoCartaRequest data,String company){
        OCSRecuperaCircuitoCartaResponse response = (OCSRecuperaCircuitoCartaResponse) ApiUtils.callApi('ocs.recuperaCircuitoCarta',data,OCSRecuperaCircuitoCartaResponse.class,company);
        System.debug('response: '+ response);
        return response;
    }
    
    public static OCSRecuperaCircuitoCartaResponse callRecCircuitoCarta(String numCarta,String company){
        return callRecCircuitoCarta(buildReq(numCarta),company);
    }
    
    public static List<OCSRecuperaCircuitoCartaResponse> callRecCircuitoCarta(List<String> data,String company){
        List<OCSRecuperaCircuitoCartaResponse> res=new List<OCSRecuperaCircuitoCartaResponse>();
        for(String s:data){
            res.add(callRecCircuitoCarta(s,company));
        }
        return res;
    }
    
    public static OCSRecuperaCircuitoCartaResponse callRecCircuitoCarta(String numCarta){
        return callRecCircuitoCarta(buildReq(numCarta),'C');
    }
    
    public static List<OCSRecuperaCircuitoCartaResponse> callRecCircuitoCarta(List<String> data){
        List<OCSRecuperaCircuitoCartaResponse> res=new List<OCSRecuperaCircuitoCartaResponse>();
        for(String s:data){
            res.add(callRecCircuitoCarta(s));
        }
        return res;
    }
    
    private static OCSRecuperaCircuitoCartaRequest buildReq(String numCarta){
        OCSRecuperaCircuitoCartaRequest data=new OCSRecuperaCircuitoCartaRequest();
        data.numPratica=numCarta;
        return data;
    }
}