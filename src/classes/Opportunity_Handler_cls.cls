/*
 * @Name: Opportunity_tgr
 * @Description: Trigger de Ejecucion Opportunity
 * @Create by:
 *
 * V0-Creacion
 */
public without sharing class Opportunity_Handler_cls extends TriggerHandler {
	list<Opportunity> oppsNew = Trigger.new;
	list<Opportunity> oppsOld = Trigger.Old;
	Map<id, Opportunity> oppsNewMap = ((Map<Id, Opportunity>)(Trigger.NewMap));
	Map<id, Opportunity> oppsOldMap = ((Map<Id, Opportunity>)(Trigger.OldMap));

	@TestVisible
	protected override void beforeInsert() {
		Opportunity_Trigger_cls.asignBeforeInsert(oppsNew, oppsNewMap);
	}

	@TestVisible
	protected override void beforeUpdate() {
		Opportunity_Trigger_cls.asignBeforeUpdate(oppsNew, oppsNewMap, oppsOld, oppsOldMap);
	}

	@TestVisible
	protected override void afterUpdate() {
		Opportunity_Trigger_cls.asignAfterUpdate(oppsNew, oppsOldMap);
		OpportunityChatterNotifications.notificationMethods(oppsNew, oppsNewMap, oppsOldMap);
		Opportunity_Trigger_cls.addUserToOppTeam(oppsNew, oppsOldMap);
	}
    
	@TestVisible
	protected override void afterInsert() {
		Opportunity_Trigger_cls.asignAfterInsert(oppsNew);
	}

	/*
	   @TestVisible
	   protected override void beforeDelete(){}

	   @TestVisible
	   protected override void afterUpdate(){}

	   @TestVisible
	   protected override void afterDelete(){}

	   @TestVisible
	   protected override void afterUndelete(){}
	 */
}
