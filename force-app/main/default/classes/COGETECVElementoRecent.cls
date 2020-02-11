global class COGETECVElementoRecent implements Comparable {
    public COGETECV1Response.MFTCOECO_ELEMENTO mftCoecoElement;
    public COGETECVElementoRecent(COGETECV1Response.MFTCOECO_ELEMENTO mft) {
     this.mftCoecoElement = mft;
    }
    global Integer compareTo(Object compareTo){
        COGETECVElementoRecent  cogeteElem = (COGETECVElementoRecent) compareTo;
        Integer returnValue = 0;
        if(mftCoecoElement.mftcoeco_DATA_SCADENZA < 
           cogeteElem.mftCoecoElement.mftcoeco_DATA_SCADENZA ){
                returnValue = 1;
         
        }
        else if(mftCoecoElement.mftcoeco_DATA_SCADENZA > cogeteElem.mftCoecoElement.mftcoeco_DATA_SCADENZA && mftCoecoElement.mftcoeco_SALDO != 0){
              returnValue = -1;
        }
        System.debug('********* returnValue '+returnValue);
        return returnValue;
    }
}