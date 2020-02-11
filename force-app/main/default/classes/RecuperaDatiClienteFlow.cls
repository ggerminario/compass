/**
 * @File Name          : RecuperaDatiClienteFlow.cls
 * @Description        : 
 * @Author             : Marco Cutolo
 * @Group              : 
 * @Last Modified By   : Marco Cutolo
 * @Last Modified On   : 13/1/2020, 15:37:40
 * @Modification Log   : 
 * Ver       Date            Author      		    Modification
 * 1.0    10/1/2020   Marco Cutolo     Initial Version
**/
public class RecuperaDatiClienteFlow {

    @InvocableMethod(label='Recupera_Dati_Cliente' description='Metodo che invoca il router del Post Vendita!!!')
    public static List<Results>  recuperaDatiCliente(List<String> requestList) {
        //List<OCSCliente> inputCollection = requestList[0].inputCollection;
        List<String> inputString = requestList[0].split(',');
        System.debug('inputString:'+inputString);
        Map<String,String> data = new Map<String,String> ();
        OCSCliente outputMember = new OCSCliente();
        //codCliente
        if(!inputString.isEmpty()){
            if(String.isNotBlank(inputString[0])){
                data.put('codCliente',inputString[0]);
            }
            //nome
            if(String.isNotBlank(inputString[1])){
                data.put('nomeCliente',inputString[1]);
            }
            //cognome
            if(String.isNotBlank(inputString[2])){
                data.put('cognomeCliente',inputString[2]);
            }
        }

        List<OCSCliente> clientiList=OCSObjectsFactory.makeClienti(OCSRecuperaDatiPostvenditaInvoker.callRecDatiPV(data));


        //outputMember.nome=requestList[1];

        //Create a Results object to hold the return values
        Results response = new Results();
        //response.outputMember = new List<OCSCliente> ();

        response.outputMember = clientiList;
        //Add the return values to the Results object
        //response.outputMember.add(outputMember);

        //Wrap the Results object in a List container 
        //(an extra step added to allow this interface to also support bulkification)
        List<Results> responseWrapper= new List<Results>();
        responseWrapper.add(response);
        return responseWrapper;    
    }


    public class Results{
        @InvocableVariable(label='Output' description='yourDescription' required=true)
        public List<OCSCliente> outputMember;
    }
    

    
}