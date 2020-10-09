/**
 * Handler of Trigger of the BE_Stockholder__c object.
 * <p /><p />
 * Modification log:<p />
 * -------------------------------------------------------------------
 * Developer                    Date                Description<p />
 * -------------------------------------------------------------------
 * Diego Carbajal    		06/10/2020          Original version.<p />
 *
 * @author Diego Carbajal
 */
public without sharing class AP_StockHolder_Handler_cls extends TriggerHandler {

    /**
	 * @Description new List BE_Stockholder__c
	 */
	List<BE_Stockholder__c> triggerNew = Trigger.new;
	/**
	 * @Description old List BE_Stockholder__c
	 */
	List<BE_Stockholder__c> triggerOld = Trigger.Old;
	/**
	 * @Description new Map BE_Stockholder__c
	 */
	Map<id, BE_Stockholder__c> triggerNewMap = ((Map<Id, BE_Stockholder__c>)(Trigger.NewMap));
	/**
	 * @Description old Map BE_Stockholder__c
	 */
	Map<id, BE_Stockholder__c> triggerOldMap = ((Map<Id, BE_Stockholder__c>)(Trigger.OldMap));

	/**
	 * @Description beforeInsert method
	 */
	@TestVisible
	protected override void beforeInsert() {
		//Valida que el usuario tenga permiso de inserción
		AP_StockHolder_Trigger_cls.validateUserPermission(triggerNew, 'insert');
	}
	/**
	 * @Description beforeUpdate method
	 */
	@TestVisible
	protected override void beforeUpdate() {
		//Valida que el usuario tenga permiso de modificación
		AP_StockHolder_Trigger_cls.validateUserPermission(triggerNew, 'update');
	}
	/**
	 * @Description beforeDelete method
	 */
	@TestVisible
	protected override void beforeDelete() {
		//Valida que el usuario tenga permiso de eliminación
		AP_StockHolder_Trigger_cls.validateUserPermission(triggerOld, 'delete');
	}
	/**
	 * @Description afterInsert method
	 */
	@TestVisible
	protected override void afterInsert() {
		//Cambia el estado a los AP's de 'Not started' a 'In Progress'
		AP_StockHolder_Trigger_cls.updateStatusOnAP(triggerNewMap);
	}
    
}