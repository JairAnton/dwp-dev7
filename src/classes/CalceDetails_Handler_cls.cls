public without sharing class CalceDetails_Handler_cls extends TriggerHandler {     
    
	List<Calce_Details__c> triggerNew = Trigger.new;
	List<Calce_Details__c> triggerOld = Trigger.Old;
	Map<Id, Calce_Details__c> triggerNewMap = ((Map<Id, Calce_Details__c>)(Trigger.NewMap));
	Map<Id, Calce_Details__c> triggerOldMap = ((Map<Id, Calce_Details__c>)(Trigger.OldMap));
    
    
    @TestVisible
	protected override void beforeUpdate() {
        CalceDetails_Trigger_cls.createNewCalceDetails(triggerNew, triggerOldMap);        
    }
}