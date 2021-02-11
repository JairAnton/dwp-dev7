/**
 * Handler of Trigger of the Template object.
 * <p /><p />
 * Modification log:<p />
 * --------------------------------------------------------------------------------
 * Developer                   			 Date                Description<p />
 * --------------------------------------------------------------------------------
 * Martín Alejandro Mori Chávez    		20/01/2021          Original version.<p />
 *
 * @author Martín Alejandro Mori Chávez
 */
public class Template_Handler_cls extends TriggerHandler {
    /**
     * @Description variable triggerNew
     */
	List<dyfr__Template__c> triggerNew = Trigger.new;
    /**
     * @Description variable triggerOld
     */
	List<dyfr__Template__c> triggerOld = Trigger.Old;
    /**
     * @Description variable triggerNewMap
     */
	Map<id, dyfr__Template__c> triggerNewMap = ((Map<Id, dyfr__Template__c>)(Trigger.NewMap));
    /**
     * @Description variable triggerOldMap
     */
	Map<id, dyfr__Template__c> triggerOldMap = ((Map<Id, dyfr__Template__c>)(Trigger.OldMap));
	/*** @Description Clase implementada por Global*/
	final acpl.TemplateHandler templateHandler =  new acpl.TemplateHandler();

    /**
     * @Description afterInsert
     */
	@TestVisible
	protected override void afterInsert() {
		//Creates a related record dyfr__Tab__c
		templateHandler.afterInsert(triggerNew);
	}
}