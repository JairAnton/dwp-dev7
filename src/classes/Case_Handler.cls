public with sharing class Case_Handler extends TriggerHandler {
    
    list<Case>lstNew = Trigger.new;
    list<Case>lstOld = Trigger.Old;
    Map<id,Case>NewMap = ((Map<Id,Case>)(Trigger.NewMap));
    Map<id,Case>mpOld = ((Map<Id,Case>)(Trigger.OldMap));
    
    @TestVisible
    protected override void afterUpdate(){
        Case_Helper.updateCaseNotification(lstNew,mpOld);
    }
    @TestVisible
    protected override void afterInsert(){
        Case_Helper.insertCaseNotification(lstNew);        
    }
    
    @TestVisible
    protected override void beforeInsert(){
        //BeforeInsert
       // Case_Helper.UpdaterateCases(lstNew);
    }
   /* 
    @TestVisible
    protected override void beforeUpdate(){
        //BeforeUpdate
    }
    
@TestVisible
protected override void beforeDelete(){}

@TestVisible
protected override void afterDelete(){}

@TestVisible
protected override void afterUndelete(){}
*/
}