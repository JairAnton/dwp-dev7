/**
 * Handler of Trigger of the AccountContactRelation object.
 * <p /><p />
 * Modification log:<p />
 * -------------------------------------------------------------------
 * Developer                    Date                Description<p />
 * -------------------------------------------------------------------
 * Isaías Velázquez Cortés    09/07/2018          Original version.<p />
 *
 * @author Isaías Velázquez Cortés
 */
public without sharing class Account_Handler_cls extends TriggerHandler {
    
    list<Account>Opps_New = Trigger.new;
    list<Account>Opps_Old = Trigger.Old;
    Map<id,Account>Opps_NewMap = ((Map<Id,Account>)(Trigger.NewMap));
    Map<id,Account>Opps_OldMap = ((Map<Id,Account>)(Trigger.OldMap));


    @TestVisible
    protected override void afterUpdate(){
        new Account_Trigger_cls().AsignAfterUpdate(Opps_New, Opps_NewMap, Opps_Old, Opps_OldMap);
        new Account_Trigger_cls().AfterUpdateOwner(Opps_New, Opps_OldMap);
    }
    protected override void afterInsert() {
        new Account_Trigger_cls().AfterInsert(Opps_New);
    }

}