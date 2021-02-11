/**
 * Handler of Trigger of the AccountPlanningType object.
 * <p /><p />
 * Modification log:<p />
 * --------------------------------------------------------------------------------
 * Developer                   			 Date                Description<p />
 * --------------------------------------------------------------------------------
 * Martín Alejandro Mori Chávez    		20/01/2021          Original version.<p />
 *
 * @author Martín Alejandro Mori Chávez
 */
public class AccountPlanningType_Handler_cls extends TriggerHandler {
    /**
     * @Description variable triggerNew
     */
	List<acpl__Account_Planning_Type__c> triggerNew = Trigger.new;
    /**
     * @Description variable triggerOld
     */
	List<acpl__Account_Planning_Type__c> triggerOld = Trigger.Old;
    /**
     * @Description variable triggerNewMap
     */
	Map<id, acpl__Account_Planning_Type__c> triggerNewMap = ((Map<Id, acpl__Account_Planning_Type__c>)(Trigger.NewMap));
    /**
     * @Description variable triggerOldMap
     */
	Map<id, acpl__Account_Planning_Type__c> triggerOldMap = ((Map<Id, acpl__Account_Planning_Type__c>)(Trigger.OldMap));
	/*** @Description Clase implementada por Global*/
	final acpl.AccountPlanningTypeHandler aptHandler =  new acpl.AccountPlanningTypeHandler();

    /**
     * @Description afterInsert
     */
	@TestVisible
	protected override void afterInsert() {
		//Creates records acpl__AP_PeriodConfiguration__c, gfsc__Guidance_for_Success__c and dyfr__Template__c associated 
		//with this acpl__Account_Planning_Type__c. It also creates a Catalog record of type acpl__Account_Planning__c associated
		aptHandler.afterInsert(triggerNew);
	}
}