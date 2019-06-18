/**
* @Name: User_Handler_cls
* @Description:Clase handler del trigger de usuarios.
* @author Jose Rodriguez
*/
public without sharing class User_Handler_cls extends TriggerHandler {
   list<User>userNew = Trigger.new;
   list<User>userOld = Trigger.Old;
   Map<id,User>userNewMap = ((Map<Id,User>)(Trigger.NewMap));
   Map<id,User>userOldMap = ((Map<Id,User>)(Trigger.OldMap));
   /**
   * @Name: beforeInsert
   * @Description:invoca al trigguer user.
   * @author Jose Rodriguez
   */
   @TestVisible
   protected override void beforeInsert() {
    new User_Trigger_cls().AsignBeforeInsert(userNew,userNewMap);
   }
   /**
   * @Name: beforeUpdate
   * @Description:invoca al trigguer user.
   * @author Jose Rodriguez
   */
   @TestVisible
   protected override void beforeUpdate() {
    new User_Trigger_cls().AsignBeforeUpdate(userNew, userNewMap, userOld, userOldMap);
   }
}