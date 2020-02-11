public class OCSRecuperaRapportoHBCpayInvoker {
    // company da impostare a F per Futuro, C per Compass
    
    public static OCSRecuperaRapportoHBCpayResponse callRecRapportoHB(OCSRecuperaRapportoHBCpayRequest data,String company){
        OCSRecuperaRapportoHBCpayResponse response = (OCSRecuperaRapportoHBCpayResponse) ApiUtils.callApi('ocs.recuperaRapportoHBCpay',data,OCSRecuperaRapportoHBCpayResponse.class,company);
        System.debug('response: '+ response);
        return response;
    }
    
    public static OCSRecuperaRapportoHBCpayResponse callRecRapportoHB(String codiceCliente,String company){
        return callRecRapportoHB(buildReq(codiceCliente),company);
    }
    
    public static List<OCSRecuperaRapportoHBCpayResponse> callRecRapportoHB(List<String> data,String company){
        List<OCSRecuperaRapportoHBCpayResponse> res=new List<OCSRecuperaRapportoHBCpayResponse>();
        for(String s:data){
            res.add(callRecRapportoHB(s,company));
        }
        return res;
    }
    
    public static OCSRecuperaRapportoHBCpayResponse callRecRapportoHB(String codiceCliente){
        return callRecRapportoHB(buildReq(codiceCliente),'C');
    }
    
    public static List<OCSRecuperaRapportoHBCpayResponse> callRecRapportoHB(List<String> data){
        List<OCSRecuperaRapportoHBCpayResponse> res=new List<OCSRecuperaRapportoHBCpayResponse>();
        for(String s:data){
            res.add(callRecRapportoHB(s));
        }
        return res;
    }
    
    private static OCSRecuperaRapportoHBCpayRequest buildReq(String codiceCliente){
        OCSRecuperaRapportoHBCpayRequest data=new OCSRecuperaRapportoHBCpayRequest();
        data.codCliente=codiceCliente;
        return data;
    }
}