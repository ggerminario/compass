/**
  * @author Mame Diarra    
  * @Created date 2020/0/15
  */
@isTest
public class XCSDeskItemServiceTest {
	@testSetup 
    static void testSetup() {
        XCS_Desk__c desk = new XCS_Desk__c(Name ='Desk1',isActive__c=true, DeskName__c='Desk1' );
        insert desk;
        XCS_DeskItem__c deskItem = new XCS_DeskItem__c(Desk__c= desk.Id, Monday__c=true, Tuesday__c=true,Wednesday__c=true,
                            Thursday__c=true, Friday__c=true,Saturday__c=false,Sunday__c =false);
    }
    
    @isTest
    static void getDeskItemTest(){
        XCS_Desk__c desk =[select id from XCS_Desk__c limit 1 ];
        XCS_DeskItem__c deskItem = XCSDeskItemService.getDeskItem(desk.Id);
    }
    
}