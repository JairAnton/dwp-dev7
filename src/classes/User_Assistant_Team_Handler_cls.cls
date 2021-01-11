/**
 * Handler of Trigger of the User_Assistant_Team__c object.
 * <p /><p />
 * Modification log:<p />
 * -------------------------------------------------------------------
 * Developer                    Date                Description<p />
 * -------------------------------------------------------------------
 * Jose Luis Ruiz Garrido    14/08/2018          Original version.<p />
 *
 * @author Jose Luis Ruiz Garrido
 */
public without sharing class User_Assistant_Team_Handler_cls extends TriggerHandler {
	list<User_Assistant_Team__c> uatNew = Trigger.new;
	list<User_Assistant_Team__c> uatOld = Trigger.Old;
	Map<id, User_Assistant_Team__c> uatNewMap = ((Map<Id, User_Assistant_Team__c>)(Trigger.NewMap));
	Map<id, User_Assistant_Team__c> uatOldMap = ((Map<Id, User_Assistant_Team__c>)(Trigger.OldMap));

	@TestVisible
	protected override void afterInsert() {
		User_Assistant_Team_Trigger_cls.asignAfterInsert(uatNew, uatNewMap, uatOld, uatOldMap);
	}
	@TestVisible
	protected override void afterDelete() {
		User_Assistant_Team_Trigger_cls.asignAfterDelete(uatOld);
	}
}