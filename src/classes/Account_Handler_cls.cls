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
	List<Account> newAccs = Trigger.new;
	List<Account> oldAccs = Trigger.Old;
	Map<id, Account> newAccsMap = ((Map<Id, Account>)(Trigger.NewMap));
	Map<id, Account> oldAccsMap = ((Map<Id, Account>)(Trigger.OldMap));

	@TestVisible
	protected override void afterUpdate() {
		new Account_Trigger_cls().AsignAfterUpdate(newAccs, newAccsMap, oldAccs, oldAccsMap);
		new Account_Trigger_cls().AfterUpdateOwner(newAccs, oldAccsMap);
	}
	protected override void afterInsert() {
		new Account_Trigger_cls().AfterInsert(newAccs);
		new BE_AccountNonClient_Trigger_cls().mergeNonClientToClient();
	}
}
