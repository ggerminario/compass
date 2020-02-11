/**
 * @File Name          : OCSRecuperaInfoSIDResponse.cls
 * @Description        :
 * @Author             : Andrea Michieli
 * @Group              :
 * @Last Modified By   : Adriana Lattanzi
 * @Last Modified On   : 2019-12-03 12:03:15
 * @Modification Log   :
 *====================================================================================
 * Ver         Date                     Author                        Modification
 *====================================================================================
 * 1.0    2019-6-27 11:58:36     	Andrea Michieli     			Initial Version
 * 1.1    2019-12-03 12:03:15      Adriana Lattanzi    				Correct Version
 **/
public class OCSRecuperaInfoSIDResponse extends OCSResponse {
    @auraEnabled
	public RecuperaInfoSIDResponseDTO recuperaInfoSIDResponse {get; set;}

	public OCSRecuperaInfoSIDResponse() {
		recuperaInfoSIDResponse = new RecuperaInfoSIDResponseDTO();
	}

	public class RecuperaInfoSIDResponseDTO {

		@AuraEnabled public String keyN {get; set;}
        @AuraEnabled public String pind {get; set;}
        @AuraEnabled public String cellulare {get; set;}
        @AuraEnabled public String email {get; set;}
        @AuraEnabled public String modalitaInoltro {get; set;}
        @AuraEnabled public String operTelef {get; set;}
        @AuraEnabled public String attesaAttivazione {get; set;}
        @AuraEnabled public String servizioSoglia {get; set;}
    	@AuraEnabled public String dataAttSoglia {get {
									  String res = '';
									  if(!String.isBlank(dataAttSoglia) && !'0'.equalsIgnoreCase(dataAttSoglia)) {

										  res += dataAttSoglia.subString(0, 4);
										  res += dataAttSoglia.subString(4, 6);
									  }
									  return res;
								  } set;}
        @AuraEnabled public String dataVarSoglia {get {
									  String res = '';
									  if(!String.isBlank(dataVarSoglia) && !'0'.equalsIgnoreCase(dataVarSoglia)) {

										  res += dataVarSoglia.subString(0, 4);
										  res += dataVarSoglia.subString(4, 6);
									  }
									  return res;
								  } set;}
        @AuraEnabled public String dataDisSoglia {get {
									  String res = '';
									  if(!String.isBlank(dataDisSoglia) && !'0'.equalsIgnoreCase(dataDisSoglia)) {

										  res += dataDisSoglia.subString(0, 4);
										  res += dataDisSoglia.subString(4, 6);
									  }
									  return res;
								  } set;}
    	@AuraEnabled public String importoSoglia {get; set;}
        @AuraEnabled public String servizioAggEc {get; set;}
        @AuraEnabled public String dataAttAggEc {get {
									  String res = '';
									  if(!String.isBlank(dataAttAggEc) && !'0'.equalsIgnoreCase(dataAttAggEc)) {

										  res += dataAttAggEc.subString(0, 4);
										  res += dataAttAggEc.subString(4, 6);
									  }
									  return res;
								  } set;}
        @AuraEnabled public String dataVarAggEc {get {
									  String res = '';
									  if(!String.isBlank(dataVarAggEc) && !'0'.equalsIgnoreCase(dataVarAggEc)) {

										  res += dataVarAggEc.subString(0, 4);
										  res += dataVarAggEc.subString(4, 6);
									  }
									  return res;
								  } set;}
        @AuraEnabled public String dataDisAggEc {get {
									  String res = '';
									  if(!String.isBlank(dataDisAggEc) && !'0'.equalsIgnoreCase(dataDisAggEc)) {

										  res += dataDisAggEc.subString(0, 4);
										  res += dataDisAggEc.subString(4, 6);
									  }
									  return res;
								  } set;}
        @AuraEnabled public String servizioSaldo {get; set;}
        @AuraEnabled public String dataAttSaldo {get {
									  String res = '';
									  if(!String.isBlank(dataAttSaldo) && !'0'.equalsIgnoreCase(dataAttSaldo)) {

										  res += dataAttSaldo.subString(0, 4);
										  res += dataAttSaldo.subString(4, 6);
									  }
									  return res;
								  } set;}
        @AuraEnabled public String dataVarSaldo {get {
									  String res = '';
									  if(!String.isBlank(dataVarSaldo) && !'0'.equalsIgnoreCase(dataVarSaldo)) {

										  res += dataVarSaldo.subString(0, 4);
										  res += dataVarSaldo.subString(4, 6);
									  }
									  return res;
								  } set;}
        @AuraEnabled public String dataDisSaldo {get {
									  String res = '';
									  if(!String.isBlank(dataDisSaldo) && !'0'.equalsIgnoreCase(dataDisSaldo)) {

										  res += dataDisSaldo.subString(0, 4);
										  res += dataDisSaldo.subString(4, 6);
									  }
									  return res;
								  } set;}
        @AuraEnabled public String frequenzaSaldo {get; set;}
        @AuraEnabled public String costoSaldo {get; set;}
        @AuraEnabled public String servAcqSaldoCm {get; set;}
        @AuraEnabled public String dataAttAcqSaldo {get {
									  String res = '';
									  if(!String.isBlank(dataAttAcqSaldo) && !'0'.equalsIgnoreCase(dataAttAcqSaldo)) {

										  res += dataAttAcqSaldo.subString(0, 4);
										  res += dataAttAcqSaldo.subString(4, 6);
									  }
									  return res;
								  } set;}
        @AuraEnabled public String dataVarAcqSaldo {get {
									  String res = '';
									  if(!String.isBlank(dataVarAcqSaldo) && !'0'.equalsIgnoreCase(dataVarAcqSaldo)) {

										  res += dataVarAcqSaldo.subString(0, 4);
										  res += dataVarAcqSaldo.subString(4, 6);
									  }
									  return res;
								  } set;}
        @AuraEnabled public String dataDisAcqSaldo {get {
									  String res = '';
									  if(!String.isBlank(dataDisAcqSaldo) && !'0'.equalsIgnoreCase(dataDisAcqSaldo)) {

										  res += dataDisAcqSaldo.subString(0, 4);
										  res += dataDisAcqSaldo.subString(4, 6);
									  }
									  return res;
								  } set;}
        @AuraEnabled public String servizioDisp {get; set;}
        @AuraEnabled public String dataAttDisp {get {
									  String res = '';
									  if(!String.isBlank(dataAttDisp) && !'0'.equalsIgnoreCase(dataAttDisp)) {

										  res += dataAttDisp.subString(0, 4);
										  res += dataAttDisp.subString(4, 6);
									  }
									  return res;
								  } set;}
        @AuraEnabled public String dataVarDisp {get {
									  String res = '';
									  if(!String.isBlank(dataVarDisp) && !'0'.equalsIgnoreCase(dataVarDisp)) {

										  res += dataVarDisp.subString(0, 4);
										  res += dataVarDisp.subString(4, 6);
									  }
									  return res;
								  } set;}
        @AuraEnabled public String dataDisDisp {get {
									  String res = '';
									  if(!String.isBlank(dataDisDisp) && !'0'.equalsIgnoreCase(dataDisDisp)) {

										  res += dataDisDisp.subString(0, 4);
										  res += dataDisDisp.subString(4, 6);
									  }
									  return res;
								  } set;}
        @AuraEnabled public String dataTrasmServDisp {get {
									  String res = '';
									  if(!String.isBlank(dataTrasmServDisp) && !'0'.equalsIgnoreCase(dataTrasmServDisp)) {

										  res += dataTrasmServDisp.subString(0, 4);
										  res += dataTrasmServDisp.subString(4, 6);
									  }
									  return res;
								  } set;}
        @AuraEnabled public String avvisoAut {get; set;}
        @AuraEnabled public String dataAttAut {get {
									  String res = '';
									  if(!String.isBlank(dataAttAut) && !'0'.equalsIgnoreCase(dataAttAut)) {

										  res += dataAttAut.subString(0, 4);
										  res += dataAttAut.subString(4, 6);
									  }
									  return res;
								  } set;}
        @AuraEnabled public String dataVarAut {get {
									  String res = '';
									  if(!String.isBlank(dataVarAut) && !'0'.equalsIgnoreCase(dataVarAut)) {

										  res += dataVarAut.subString(0, 4);
										  res += dataVarAut.subString(4, 6);
									  }
									  return res;
								  } set;}
        @AuraEnabled public String dataDisAut {get {
									  String res = '';
									  if(!String.isBlank(dataDisAut) && !'0'.equalsIgnoreCase(dataDisAut)) {

										  res += dataDisAut.subString(0, 4);
										  res += dataDisAut.subString(4, 6);
									  }
									  return res;
								  } set;}
        @AuraEnabled public String impSogliaAut {get; set;}
        @AuraEnabled public String presSogliaAut {get; set;}
        @AuraEnabled public String avvisoAutTot {get; set;}
        @AuraEnabled public String dataAttAutTot {get {
									  String res = '';
									  if(!String.isBlank(dataAttAutTot) && !'0'.equalsIgnoreCase(dataAttAutTot)) {

										  res += dataAttAutTot.subString(0, 4);
										  res += dataAttAutTot.subString(4, 6);
									  }
									  return res;
								  } set;}
        @AuraEnabled public String dataVarAutTot {get {
									  String res = '';
									  if(!String.isBlank(dataVarAutTot) && !'0'.equalsIgnoreCase(dataVarAutTot)) {

										  res += dataVarAutTot.subString(0, 4);
										  res += dataVarAutTot.subString(4, 6);
									  }
									  return res;
								  } set;}
        @AuraEnabled public String dataDisAutTot {get {
									  String res = '';
									  if(!String.isBlank(dataDisAutTot) && !'0'.equalsIgnoreCase(dataDisAutTot)) {

										  res += dataDisAutTot.subString(0, 4);
										  res += dataDisAutTot.subString(4, 6);
									  }
									  return res;
								  } set;}
        @AuraEnabled public String impSogliaAutTot {get; set;}
        @AuraEnabled public String vprVariazProxRata {get; set;}
        @AuraEnabled public String dataAttVpr {get {
									  String res = '';
									  if(!String.isBlank(dataAttVpr) && !'0'.equalsIgnoreCase(dataAttVpr)) {

										  res += dataAttVpr.subString(0, 4);
										  res += dataAttVpr.subString(4, 6);
									  }
									  return res;
								  } set;}
        @AuraEnabled public String dataVarVpr {get {
									  String res = '';
									  if(!String.isBlank(dataVarVpr) && !'0'.equalsIgnoreCase(dataVarVpr)) {

										  res += dataVarVpr.subString(0, 4);
										  res += dataVarVpr.subString(4, 6);
									  }
									  return res;
								  } set;}
        @AuraEnabled public String dataDisVpr {get {
									  String res = '';
									  if(!String.isBlank(dataDisVpr) && !'0'.equalsIgnoreCase(dataDisVpr)) {

										  res += dataDisVpr.subString(0, 4);
										  res += dataDisVpr.subString(4, 6);
									  }
									  return res;
								  } set;}
        @AuraEnabled public String protCampServizio {get; set;}
        @AuraEnabled public String protCampDataAtt {get; set;}
        @AuraEnabled public String protCampDataVar {get; set;}
        @AuraEnabled public String protCampDataDis {get; set;}
        @AuraEnabled public String risPrincServizio {get; set;}
        @AuraEnabled public String risPrincDataAtt {get; set;}
        @AuraEnabled public String risPrincDataVar {get; set;}
        @AuraEnabled public String risPrincDataDis {get; set;}
        @AuraEnabled public String bloccoServizio {get; set;}
        @AuraEnabled public String bloccoDataAtt {get; set;}
        @AuraEnabled public String bloccoDataVar {get; set;}
        @AuraEnabled public String bloccoDataDis {get; set;}
        @AuraEnabled public String catbopteDescrizione {get; set;}

	}
		
}