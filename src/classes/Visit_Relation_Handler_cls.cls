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
    /** @Description  oldAccs*/
    List<Commercial_Alert_Visit_Relation__c> oldComVis = Trigger.Old;
    /** @Description  newAccsMap*/
    Map<id,Commercial_Alert_Visit_Relation__c> newComVisMap = ((Map<Id,Commercial_Alert_Visit_Relation__c>)(Trigger.NewMap));
    /** @Description  oldAccsMap*/
    Map<id,Commercial_Alert_Visit_Relation__c> oldComVisMap = ((Map<Id,Commercial_Alert_Visit_Relation__c>)(Trigger.OldMap));

    /** @Description  beforeUpdate*/
    @TestVisible
    protected override void beforeInsert() {
        BE_CA_Visit_Relation_Trigger_cls.asignBeforeUpdate(newComVis, newComVisMap, oldComVis, oldComVisMap);
    }

}