/**
 * Handler of Trigger of the CommercialPlantEvent object.
 * <p /><p />
 * Modification log:<p />
 * -------------------------------------------------------------------
 * Developer                    Date                Description<p />
 * -------------------------------------------------------------------
 * Diego Carbajal    		15/05/2020          Original version.<p />
 *
 * @author Diego Carbajal
 */
public without sharing class AP_CommercialPlanEvent_Handler_cls extends TriggerHandler {
	/**
	 * @Description new List acpl__Commercial_Plan_Event__c
	 */
	List<acpl__Commercial_Plan_Event__c> triggerNew = Trigger.new;
	/**
	 * @Description old List acpl__Commercial_Plan_Event__c
	 */
	List<acpl__Commercial_Plan_Event__c> triggerOld = Trigger.Old;
	/**
	 * @Description new Map acpl__Commercial_Plan_Event__c
	 */
	Map<id, acpl__Commercial_Plan_Event__c> triggerNewMap = ((Map<Id, acpl__Commercial_Plan_Event__c>)(Trigger.NewMap));
	/**
	 * @Description old Map acpl__Commercial_Plan_Event__c
	 */
	Map<id, acpl__Commercial_Plan_Event__c> triggerOldMap = ((Map<Id, acpl__Commercial_Plan_Event__c>)(Trigger.OldMap));

	/**
	 * @Description beforeInsert method
	 */
	@TestVisible
	protected override void beforeInsert() {
		//Valida que el usuario tenga permiso de inserción
		AP_CommercialPlan_Trigger_cls.validateUserPermission(triggerNew, 'insert');
	}
	/**
	 * @Description beforeUpdate method
	 */
	@TestVisible
	protected override void beforeUpdate() {
		//Valida que el usuario tenga permiso de modificación
		AP_CommercialPlan_Trigger_cls.validateUserPermission(triggerNew, 'update');
	}
	/**
	 * @Description beforeDelete method
	 */
	@TestVisible
	protected override void beforeDelete() {
		//Valida que el usuario tenga permiso de eliminación
		AP_CommercialPlan_Trigger_cls.validateUserPermission(triggerOld, 'delete');
	}
	/**
	 * @Description afterInsert method
	 */
	@TestVisible
	protected override void afterInsert() {
		//Cambia el estado a los AP's de 'Not started' a 'In Progress'
		AP_CommercialPlan_Trigger_cls.updateStatusOnAP(triggerNewMap);
	}
}