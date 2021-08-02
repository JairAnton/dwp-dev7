/*  Clase Handler para el triger del objeto Calce_Details__c  */

public without sharing class CalceDetails_Handler_cls extends TriggerHandler {
    /* Lista con valores nuevos  */
	List<Calce_Details__c> triggerNew = Trigger.new;
	/*  Lista con valores antiguos */
	List<Calce_Details__c> triggerOld = Trigger.Old;
	/*  Mapa con valores nuevos */
	Map<Id, Calce_Details__c> triggerNewMap = ((Map<Id, Calce_Details__c>)(Trigger.NewMap));
		/*  Mapa con valores antiguos */
	Map<Id, Calce_Details__c> triggerOldMap = ((Map<Id, Calce_Details__c>)(Trigger.OldMap));
    
    
    @TestVisible
	/*  Antes de actualizar */
	protected override void beforeUpdate() {
        CalceDetails_Trigger_cls.createNewCalceDetails(triggerNew, triggerOldMap);        
    }
}