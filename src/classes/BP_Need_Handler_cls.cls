/**
 * Handler of Trigger of the Need object.
 * <p /><p />
 * Modification log:<p />
 * -------------------------------------------------------------------
 * Developer                    Date                Description<p />
 * -------------------------------------------------------------------
 * Diego Carbajal    		15/05/2020          Original version.<p />
 *
 * @author Diego Carbajal
 */
public without sharing class BP_Need_Handler_cls extends TriggerHandler {
	/**
	   @Description triggerNew
	 */
	List<bupl__BP_Need__c> triggerNew = Trigger.new;
	/**
	   @Description triggerOld
	 */
	List<bupl__BP_Need__c> triggerOld = Trigger.Old;
	/**
	   @Description triggerNewMap
	 */
	Map<id, bupl__BP_Need__c> triggerNewMap = ((Map<Id, bupl__BP_Need__c>)(Trigger.NewMap));
	/**
	   @Description triggerOldMap
	 */
	Map<id, bupl__BP_Need__c> triggerOldMap = ((Map<Id, bupl__BP_Need__c>)(Trigger.OldMap));

	/**
	   @Description beforeInsert
	 */
	@TestVisible
	protected override void beforeInsert() {
		//Valida si se puede insertar necesidades, validados por estado y bloqueo en el AP y usuario
		BP_Need_Trigger_cls.validateUserPermission(triggerNew, 'insert');
	}
	/**
	   @Description beforeUpdate
	 */
	@TestVisible
	protected override void beforeUpdate() {
		//Valida si se puede modificar necesidades, validados por estado y bloqueo en el AP y usuario
		BP_Need_Trigger_cls.validateUserPermission(triggerNew, 'update');
	}
	/**
	   @Description beforeDelete
	 */
	@TestVisible
	protected override void beforeDelete() {
		//Valida si se puede eliminar necesidades, validados por estado y bloqueo en el AP y usuario
		BP_Need_Trigger_cls.validateUserPermission(triggerOld, 'delete');
	}
	/**
	   @Description afterInsert
	 */
	@TestVisible
	protected override void afterInsert() {
		//Actualiza el estado del AP de 'Not started' a 'In Progress'
		BP_Need_Trigger_cls.updateStatusOnAP(triggerNewMap);
	}
}
