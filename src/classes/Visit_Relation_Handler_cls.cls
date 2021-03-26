/**
 * Handler of Trigger of the Commercial_Alert_Visit_Relation object.
 * <p /><p />
 * Modification log:<p />
 * -------------------------------------------------------------------
 * Developer                    Date                Description<p />
 * -------------------------------------------------------------------
 * Eduardo Vargas Matute        25/03/2021          Original version.<p />
 *
 * @author Eduardo Vargas
 */
public without sharing class Visit_Relation_Handler_cls extends TriggerHandler {
    /** @Description  newAccs*/
    List<Commercial_Alert_Visit_Relation__c> newComVis = Trigger.new;
    /** @Description  beforeUpdate*/
    @TestVisible
    protected override void beforeInsert() {
        BE_CA_Visit_Relation_Trigger_cls.asignBeforeUpdate(newComVis);
    }
}