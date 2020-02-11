public class RedirectFromAttendeeToEventCtrl {
    @AuraEnabled
    public static string getParentEvent(String attendeeId){
        Event evAttendee = [select id, isChild, subject, whatId, StartDateTime from event where id =:attendeeId];
        List<Event> parentEvent = [select id from event where  WhatId =:evAttendee.whatId and StartDateTime = :evAttendee.StartDateTime and ischild = false and type = 'Appuntamento' ];
        if(parentEvent==null || parentEvent.size()==0){
            return null;
        }
        return parentEvent[0].ID;
    }

}