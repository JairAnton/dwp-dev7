/**
 * Handler of Trigger of the GrowthDriver object.
 * <p /><p />
 * Modification log:<p />
 * -------------------------------------------------------------------
 * Developer                    Date                Description<p />
 * -------------------------------------------------------------------
 * Diego Carbajal    		15/05/2020          Original version.<p />
 *
 * @author Diego Carbajal
 */
public without sharing class BP_GrowthDriver_Handler_cls extends TriggerHandler {
	/**
	   @Description triggerNew
	 */
	List<bupl__BP_GrowthDriver__c> triggerNew = Trigger.new;
	/**
	   @Description triggerOld
	 */
	List<bupl__BP_GrowthDriver__c> triggerOld = Trigger.Old;
	/**
	   @Description triggerNewMap
	 */
	Map<id, bupl__BP_GrowthDriver__c> triggerNewMap = ((Map<Id, bupl__BP_GrowthDriver__c>)(Trigger.NewMap));
	/**
	   @Description triggerOldMap
	 */
	Map<id, bupl__BP_GrowthDriver__c> triggerOldMap = ((Map<Id, bupl__BP_GrowthDriver__c>)(Trigger.OldMap));

	/**
	   @Description beforeInsert
	 * validateUserPermission: Valida si se puede insertar variables de crecimiento, validados por estado y bloqueo en el AP y usuario
	 */
	@TestVisible
	protected override void beforeInsert() {
		BP_GrowthDriver_Trigger_cls.validateUserPermission(triggerNew, 'insert');
	}
	/**
	   @Description beforeUpdate
	 * validateUserPermission: Valida si se puede modificar variables de crecimiento, validados por estado y bloqueo en el AP y usuario
	 */
	@TestVisible
	protected override void beforeUpdate() {
		BP_GrowthDriver_Trigger_cls.validateUserPermission(triggerNew, 'update');
	}
	/**
	   @Description beforeDelete
	 * validateUserPermission: Valida si se puede eliminar variables de crecimiento, validados por estado y bloqueo en el AP y usuario
	 */
	@TestVisible
	protected override void beforeDelete() {
		BP_GrowthDriver_Trigger_cls.validateUserPermission(triggerOld, 'delete');
	}
	/**
	   @Description afterInsert
	*updateStatusOnAP: Metodo que actualiza el estado del AP de estado 'Not started' a 'In Progress'
	 */
	@TestVisible
	protected override void afterInsert() {
		BP_GrowthDriver_Trigger_cls.updateStatusOnAP(triggerNewMap);
	}
}