/**
 * Handler of Trigger of the Guidance object.
 * <p /><p />
 * Modification log:<p />
 * --------------------------------------------------------------------------------
 * Developer                   			 Date                Description<p />
 * --------------------------------------------------------------------------------
 * Martín Alejandro Mori Chávez    		20/01/2021          Original version.<p />
 *
 * @author Martín Alejandro Mori Chávez
 */
public class Guidance_Handler_cls extends TriggerHandler {
    /**
     * @Description variable triggerNew
     */
	List<gfsc__Guidance_for_Success__c> triggerNew = Trigger.new;
    /**
     * @Description variable triggerOld
     */
	List<gfsc__Guidance_for_Success__c> triggerOld = Trigger.Old;
    /**
     * @Description variable triggerNewMap
     */
	Map<id, gfsc__Guidance_for_Success__c> triggerNewMap = ((Map<Id, gfsc__Guidance_for_Success__c>)(Trigger.NewMap));
    /**
     * @Description variable triggerOldMap
     */
	Map<id, gfsc__Guidance_for_Success__c> triggerOldMap = ((Map<Id, gfsc__Guidance_for_Success__c>)(Trigger.OldMap));
	/*** @Description Clase implementada por Global*/
	final acpl.GuidanceForSuccessHandler guidanceHandler =  new acpl.GuidanceForSuccessHandler();

    /**
     * @Description afterInsert
     */
	@TestVisible
	protected override void afterInsert() {
		//Creates a related record gfsc__Guidance_for_Success_Item__c
		guidanceHandler.afterInsert(Trigger.new);
	}
}