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
    /** @Description  newAccs*/
    List<Account> newAccs = Trigger.new;
    /** @Description  oldAccs*/
    List<Account> oldAccs = Trigger.Old;
    /** @Description  newAccsMap*/
    Map<id,Account> newAccsMap = ((Map<Id,Account>)(Trigger.NewMap));
    /** @Description  oldAccsMap*/
    Map<id,Account> oldAccsMap = ((Map<Id,Account>)(Trigger.OldMap));

    /** @Description  afterUpdate*/
    @TestVisible
    protected override void afterUpdate(){
        Account_Trigger_cls.asignAfterUpdate(newAccs, newAccsMap, oldAccs, oldAccsMap);
        Account_Trigger_cls.afterUpdateOwner(newAccs, oldAccsMap);
    }
    /** @Description  afterInsert*/
    @TestVisible
    protected override void afterInsert() {
        Account_Trigger_cls.afterInsert(newAccs);
        new BE_AccountNonClient_Trigger_cls().mergeNonClientToClient();
    }
}
