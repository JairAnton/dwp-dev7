/**
   -------------------------------------------------------------------------------------------------
   @Name Event_Handler_cls
   @Author Martin Alejandro Mori Chavez (martin.mori.contractor@bbva.com)
   @Date 2020-11-11
   @Description
   @Changes
   Date        Author   Email                  				Type
   2020-11-11  MAMCH    martin.mori.contractor@bbva.com    	Creation
   -------------------------------------------------------------------------------------------------
 */
public without sharing class Event_Trigger_cls {
    /**
     * @Description constructor
     */
    private Event_Trigger_cls() {}

    /**
     * @Description salesMeetingColOwner put Colaborator like Owner
     */
    public static void createAttendeesSM(List<Event> triggerNew) {
        Final Map<Id, Id> mapSlmt = new Map<Id, Id>();
        for(Event evtAux: triggerNew) {
            if(evtAux.slmt__management_plan_meeting_id__c!=null) {
                mapSlmt.put(evtAux.slmt__management_plan_meeting_id__c, evtAux.Id);
            }
        }
        if(!mapSlmt.isEmpty()) {
            Final List<EventRelation> ltsEvtRel = new List<EventRelation>();
            for(slmt__Sales_Meeting__c slmtAux : [SELECT Id, CreatedById, Collaborator__c, slmt__mngmt_plan_meeting_user_id__c FROM slmt__Sales_Meeting__c WHERE Id IN :mapSlmt.keySet()]) {
                if(slmtAux.CreatedById == slmtAux.slmt__mngmt_plan_meeting_user_id__c) {
                    ltsEvtRel.add(new EventRelation(EventId = mapSlmt.get(slmtAux.Id), RelationId=slmtAux.Collaborator__c, IsInvitee=True));
                } else {
                    ltsEvtRel.add(new EventRelation(EventId = mapSlmt.get(slmtAux.Id), RelationId=slmtAux.slmt__mngmt_plan_meeting_user_id__c, IsInvitee=True));
                }
            }
            insert ltsEvtRel;
        }
    }
}