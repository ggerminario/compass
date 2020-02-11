public class BancheDatiCaseUpdatePBClass {
	@invocableMethod
    public static void ricercaStatoPratica (List<Case> cases)
    {
        List<Case> listCase = new List<Case>();
        for(Case c : cases)
        {
            Case cNew = new Case(Id = c.id);
            cNew.type = XCSCompassConstants.CASETYPECRM;
            cNew.Status = CaseUtils.APERTO;
            cNew.Categoria_Riferimento__r = XCS_CategoriaUtil.getCategoryForExternalId('1803');
            listCase.add(cNew);
        } 
        update listCase;
        System.debug('#LISTA CASE BANCHE DATI#' + listCase);
    }
}