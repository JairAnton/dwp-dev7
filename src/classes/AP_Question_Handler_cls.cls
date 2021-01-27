/**
 * Handler of Trigger of the AP_Question object.
 * <p /><p />
 * Modification log:<p />
 * ------------------------------------------------------------------------------------
 * Developer                    		Date                Description<p />
 * ------------------------------------------------------------------------------------
 * Diego Carbajal    					15/05/2020          Original version.<p />
 * Martin Alejandro Mori Chávez    		20/01/2021          Update methods for package 3.3.<p />
 *
 * @author Diego Carbajal
 */
public without sharing class AP_Question_Handler_cls extends TriggerHandler {
	/**
	 * @Description variable new List<acpl__AP_Question__c>
	 */
	List<acpl__AP_Question__c> triggerNew = Trigger.new;
	/**
	 * @Description variable old List<acpl__AP_Question__c>
	 */
	List<acpl__AP_Question__c> triggerOld = Trigger.Old;
	/**
	 * @Description variable new Map<id,acpl__AP_Question__c>
	 */
	Map<id, acpl__AP_Question__c> triggerNewMap = ((Map<Id, acpl__AP_Question__c>)(Trigger.NewMap));
	/**
	 * @Description variable old Map<id,acpl__AP_Question__c>
	 */
	Map<id, acpl__AP_Question__c> triggerOldMap = ((Map<Id, acpl__AP_Question__c>)(Trigger.OldMap));
    /*
	 * @Description  Clase implementada por Global
	 */
    final acpl.AP_QuestionHandler apQuestion = acpl.AP_QuestionHandler.getInstance();

	/**
	 * @Description method beforeInsert
	 */
	@TestVisible
	protected override void beforeInsert() {
		//start new methods ver 3.3
		//apQuestion.insertFinalResponse(triggerNew);
        //end new methods ver 3.3
	}
	/**
	 * @Description method beforeUpdate
	 */
	@TestVisible
	protected override void beforeUpdate() {
		//Valida si se puede modificar las preguntas de acuerdo al estado, bloqueo y usuario
		AP_Question_Trigger_cls.preventModifyQuestions(triggerNewMap, 'update');
        //start new methods ver 3.3
		//apQuestion.updateFinalResponse(triggerNewMap, triggerOldMap);
        //end new methods ver 3.3
	}
	/**
	 * @Description method beforeDelete
	 */
	@TestVisible
	protected override void beforeDelete() {
		//Valida si se puede eliminar las preguntas de acuerdo al estado, bloqueo y usuario
		AP_Question_Trigger_cls.preventModifyQuestions(triggerOldMap, 'delete');
	}
	/**
	 * @Description method AfterUpdate
	 */
	@TestVisible
	protected override void afterUpdate() {
		//Actualiza el estado del AP de 'Not started' a 'In progress' cuando se modifica una pregunta
		AP_Question_Trigger_cls.updateStatusOnAP(triggerNewMap, triggerOldMap);//  -- Deprecated
		//start new methods ver 3.3
		//Method updateStatusOnAP: Checks if AP_Question__c has been modified and propagates this change on Status field in related AP.
        //apQuestion.updateStatusOnAP(triggerNewMap, triggerOldMap);
        //end new methods ver 3.3
	}
}