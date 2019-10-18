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
    Map<id,Opportunity> oppsNewMap = ((Map<Id,Opportunity>)(Trigger.NewMap));
    Map<id,Opportunity> oppsOldMap = ((Map<Id,Opportunity>)(Trigger.OldMap));
    
    @TestVisible
    protected override void beforeInsert() {
        new Opportunity_Trigger_cls().asignBeforeInsert(oppsNew, oppsNewMap);
    }
    
    @TestVisible
    protected override void beforeUpdate() {
        new Opportunity_Trigger_cls().asignBeforeUpdate(oppsNew, oppsNewMap, oppsOld, oppsOldMap);
    }
    
    @TestVisible
    protected override void afterUpdate() {
        new Opportunity_Trigger_cls().asignAfterUpdate(oppsNew, oppsOldMap);
        OpportunityChatterNotifications.notificationMethods(oppsNew, oppsNewMap, oppsOldMap);
    }
    @TestVisible
    protected override void afterInsert() {
        new Opportunity_Trigger_cls().asignAfterInsert(oppsNew);
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