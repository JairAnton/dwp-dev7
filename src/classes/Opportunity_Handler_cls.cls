/*
 * @Name: Opportunity_tgr
 * @Description: Trigger de Ejecucion Opportunity
 * @Create by: 
 * 
 * V0-Creacion
*/
public without sharing class Opportunity_Handler_cls extends TriggerHandler {
    
    list<Opportunity>Opps_New = Trigger.new;
    list<Opportunity>Opps_Old = Trigger.Old;
    Map<id,Opportunity>Opps_NewMap = ((Map<Id,Opportunity>)(Trigger.NewMap));
    Map<id,Opportunity>Opps_OldMap = ((Map<Id,Opportunity>)(Trigger.OldMap));
    
    @TestVisible
    protected override void beforeInsert(){
        new Opportunity_Trigger_cls().AsignBeforeInsert(Opps_New,Opps_NewMap);
    }
    
    @TestVisible
    protected override void beforeUpdate(){
        new Opportunity_Trigger_cls().AsignBeforeUpdate(Opps_New, Opps_NewMap, Opps_Old, Opps_OldMap);
    }
    
    @TestVisible
    protected override void afterUpdate(){
        new Opportunity_Trigger_cls().AsignAfterUpdate(Opps_New, Opps_OldMap);
        OpportunityChatterNotifications.ownerChangeNotification(Opps_New, Opps_NewMap, Opps_OldMap);
        OpportunityChatterNotifications.statusChangeNotification(Opps_New, Opps_NewMap, Opps_OldMap);
    }
    
    /*
    @TestVisible
    protected override void beforeDelete(){}
    
    @TestVisible
    protected override void afterInsert(){}
    
    @TestVisible
    protected override void afterUpdate(){}
    
    @TestVisible
    protected override void afterDelete(){}
	
    @TestVisible
    protected override void afterUndelete(){}
	*/
}