/**
 * Handler of Trigger of the BusinessPlan object.
 * <p /><p />
 * Modification log:<p />
 * -------------------------------------------------------------------
 * Developer                    Date                Description<p />
 * -------------------------------------------------------------------
 * Diego Carbajal    		15/05/2020          Original version.<p />
 *
 * @author Diego Carbajal
 */
public without sharing class BusinessPlan_Handler_cls extends TriggerHandler {
	/**
	   @Description triggerNew
	 */
	List<bupl__BusinessPlan__c> triggerNew = Trigger.new;
	/**
	   @Description triggerOld
	 */
	List<bupl__BusinessPlan__c> triggerOld = Trigger.Old;
	/**
	   @Description triggerNewMap
	 */
	Map<id, bupl__BusinessPlan__c> triggerNewMap = ((Map<Id, bupl__BusinessPlan__c>)(Trigger.NewMap));
	/**
	   @Description triggerOldMap
	 */
	Map<id, bupl__BusinessPlan__c> triggerOldMap = ((Map<Id, bupl__BusinessPlan__c>)(Trigger.OldMap));
	//Clase implementada por Global
	final acpl.BusinessPlan_TriggerHandler bpHandler = acpl.BusinessPlan_TriggerHandler.getInstance();

	/**
	   @Description beforeUpdate
	 */
	@TestVisible
	protected override void beforeUpdate() {
		//EVALUAR
		//Inserta registros de seguimiento de AP creado
		//BusinessPlan_Trigger_Helper.preventModifyBP(triggerNewMap, 'update');
	}
	/**
	   @Description beforeDelete
	 */
	@TestVisible
	protected override void beforeDelete() {
		//Inserta registros de seguimiento de AP creado
		BusinessPlan_Trigger_cls.preventModifyBP(triggerOldMap, 'delete');
	}
	/**
	   @Description afterInsert
	 */
	@TestVisible
	protected override void afterInsert() {
		//Inserta registros de seguimiento de AP creado
		bpHandler.insertAPHistory(triggerNewMap, null);
	}
	/**
	   @Description afterUpdate
	 */
	@TestVisible
	protected override void afterUpdate() {
		//Inserta registros de seguimiento de AP creado
		bpHandler.insertAPHistory(triggerNewMap, triggerOldMap);
		//Metodo que actualiza el estado del AP si el BP es validado o modificado
		BusinessPlan_Trigger_cls.updateStatusOnAP(triggerNewMap, triggerOldMap);
	}
}
