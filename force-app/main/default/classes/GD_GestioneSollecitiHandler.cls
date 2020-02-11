public class GD_GestioneSollecitiHandler{
     
    public static void PopulateFieldUltimoInvio(List<IVASS_Dealer_Courses_Sollecito__c> TriggerNewList)
    {
           if( TriggerNewList != null && TriggerNewList.size() > 0 )
           {
               for( IVASS_Dealer_Courses_Sollecito__c ObjIterSollecito : TriggerNewList )
               {
                    ObjIterSollecito.Ultimo_Invio__c       = Date.today();
                    ObjIterSollecito.Tipo_Ricevente__c     = ObjIterSollecito.Destinatari_Sollecito__c;
                    ObjIterSollecito.Descrizione_Corso__c  = ObjIterSollecito.Tipo_Corso_Form__c;
               }
           }
    }

}