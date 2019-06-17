public without sharing class User_Handler_cls extends TriggerHandler{
   list<User>User_New = Trigger.new;
   list<User>User_Old = Trigger.Old;
   Map<id,User>User_NewMap = ((Map<Id,User>)(Trigger.NewMap));
   Map<id,User>User_OldMap = ((Map<Id,User>)(Trigger.OldMap));
    @TestVisible
    protected override void beforeInsert(){
        new User_Trigger_cls().AsignBeforeInsert(User_New,User_NewMap);
    }
    @TestVisible
    protected override void beforeUpdate(){
        new User_Trigger_cls().AsignBeforeUpdate(User_New, User_NewMap, User_Old, User_OldMap);
    }
}