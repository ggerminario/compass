public class AnnullaCasiRelatedListController {
    
 	@TestVisible public List<Case> currentCases {get;set;}   
    
    public AnnullaCasiRelatedListController(ApexPages.StandardSetController std){
        this.currentCases = (List<Case>)std.getSelected();
    }
    
    
    public PageReference deleteCaseChild(){
        
        System.debug('********************' + currentCases);
        system.debug('#######################' + ApexPages.currentPage().getParameters().get('id'));
        PageReference pageRef = new PageReference('/' +   ApexPages.currentPage().getParameters().get('id'));
        return pageRef;
    }
}