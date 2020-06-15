/*
 * @Name: User_Handler_cls
 * @Description:Clase handler del trigger de usuarios.
 * @author Jose Rodriguez
 */
public without sharing class User_Handler_cls extends TriggerHandler {
	list<User> userNew = Trigger.new;
	list<User> userOld = Trigger.Old;
	Map<id, User> userNewMap = ((Map<Id, User>)(Trigger.NewMap));
	Map<id, User> userOldMap = ((Map<Id, User>)(Trigger.OldMap));

	/*
	 * @Name: beforeInsert
	 * @Description:invoca al trigguer user.
	 * @author Jose Rodriguez
	 */
	@TestVisible
	protected override void beforeInsert() {
		User_Trigger_cls.asignBeforeInsert(userNew, userNewMap);
	}

	/*
	 * @Name: afterInsert
	 * @Description:invoca al trigger user.
	 * @author Diego Carbajal
	 */
	@TestVisible
	protected override void afterInsert() {
		User_Trigger_cls.asignAfterInsert(userNew, userNewMap, userOld, userOldMap);
	}

	/*
	 * @Name: beforeUpdate
	 * @Description:invoca al trigguer user.
	 * @author Jose Rodriguez
	 */
	@TestVisible
	protected override void beforeUpdate() {
		User_Trigger_cls.asignBeforeUpdate(userNew, userNewMap, userOld, userOldMap);
	}

	/*
	 * @Name: AfterUpdate
	 * @Description:invoca al trigger user.
	 * @author Diego Carbajal
	 */
	@TestVisible
	protected override void AfterUpdate() {
		User_Trigger_cls.asignAfterUpdate(userNew, userNewMap, userOld, userOldMap);
		User_Trigger_cls.assigmentPermission(userOldMap, userNewMap);
	}
}