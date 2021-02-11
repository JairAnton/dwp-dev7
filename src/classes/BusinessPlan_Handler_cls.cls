/**
 * Handler of Trigger of the BusinessPlan object.
 * <p /><p />
 * Modification log:<p />
 * -----------------------------------------------------------------------------
 * Developer                    	Date                Description<p />
 * -----------------------------------------------------------------------------
 * Diego Carbajal    				15/05/2020          Original version.<p />
 * Martin Alejandro Mori Chávez    	20/01/2021          Update methods for package 3.3.<p />
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
    /**@Description Clase implementada por Global*/
	final acpl.BusinessPlan_TriggerHandler bpHandler = acpl.BusinessPlan_TriggerHandler.getInstance();

	/**
	   @Description beforeUpdate
	 */
	@TestVisible
	protected override void beforeUpdate() {
		//EVALUAR
		//BusinessPlan_Trigger_Helper.preventModifyBP(triggerNewMap, 'update');
	}
	/**
	   @Description beforeDelete
	 * preventModifyBP: Inserta registros de seguimiento de AP creado
	 */
	@TestVisible
	protected override void beforeDelete() {
		BusinessPlan_Trigger_cls.preventModifyBP(triggerOldMap, 'delete');
	}
	/**
	   @Description afterInsert
	 * insertAPHistory:Inserta registros de seguimiento de AP creado
	 */
	@TestVisible
	protected override void afterInsert() {
		bpHandler.insertAPHistory(triggerNewMap, null);
	}
	/**
	   @Description afterUpdate
	*insertAPHistory: Inserta registros de seguimiento de AP creado
	*updateStatusOnAP: Metodo que actualiza el estado del AP si el BP es validado o modificado
	 */
	@TestVisible
	protected override void afterUpdate() {
		bpHandler.insertAPHistory(triggerNewMap, triggerOldMap);
		BusinessPlan_Trigger_cls.updateStatusOnAP(triggerNewMap, triggerOldMap);//  -- Deprecated
        //start new methods ver 3.3
		//Method updateStatusOnAP: Checks if the Business Plan has changed and if so propagates this change on Status field in related AP.
        //bpHandler.updateStatusOnAP(triggerNewMap, triggerOldMap);
        //end new methods ver 3.3
	}
}