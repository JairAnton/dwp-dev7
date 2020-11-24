/**
   -------------------------------------------------------------------------------------------------
   @Name SalesMeeting_Handler_cls
   @Author Diego Carbajal Pastor (diego.carbajal@bbva.com)
   @Date 2020-11-11
   @Description
   @Changes
   Date        Author   Email                  Type
   2020-11-11  DCP     diego.carbajal@bbva.com    Creation
   -------------------------------------------------------------------------------------------------
 */
public class SalesMeeting_Handler_cls extends TriggerHandler {
    
    /**
     * @Description variable triggerNew
     */
	List<slmt__Sales_Meeting__c> triggerNew = Trigger.new;
    /**
     * @Description variable triggerOld
     */
	List<slmt__Sales_Meeting__c> triggerOld = Trigger.Old;
    /**
     * @Description variable triggerNewMap
     */
	Map<id, slmt__Sales_Meeting__c> triggerNewMap = ((Map<Id, slmt__Sales_Meeting__c>)(Trigger.NewMap));
    /**
     * @Description variable triggerOldMap
     */
    Map<id, slmt__Sales_Meeting__c> triggerOldMap = ((Map<Id, slmt__Sales_Meeting__c>)(Trigger.OldMap));
    
    /**
     * @Description beforeInsert
     */
	@TestVisible
	protected override void beforeInsert() {
          //Keep the Colaborator like Owner of Meeting
          SalesMeeting_Trigger_cls.salesMeetingColOwner(triggerNew);
    }
    
    /**
     * @Description afterInsert
     */
	@TestVisible
	protected override void afterInsert() {
          //Comparte registros de SM con asistentes y JPN
          SalesMeeting_Trigger_cls.addRecordAccess(triggerNewMap);
	}
}