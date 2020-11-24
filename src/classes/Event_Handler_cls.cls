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
public class Event_Handler_cls extends TriggerHandler {
    
    /**
     * @Description variable triggerNew
     */
	List<Event> triggerNew = Trigger.new;
    /**
     * @Description variable triggerOld
     */
	List<Event> triggerOld = Trigger.Old;
    /**
     * @Description variable triggerNewMap
     */
	Map<id, Event> triggerNewMap = ((Map<Id, Event>)(Trigger.NewMap));
    /**
     * @Description variable triggerOldMap
     */
    Map<id, Event> triggerOldMap = ((Map<Id, Event>)(Trigger.OldMap));
    
    /**
     * @Description afterInsert
     */
	@TestVisible
	protected override void afterInsert() {
        Event_Trigger_cls.createAttendeesSM(Trigger.new);
	}
}