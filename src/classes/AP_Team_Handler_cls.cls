/**
 * Handler of Trigger of the AP_Team object.
 * <p /><p />
 * Modification log:<p />
 * --------------------------------------------------------------------------------
 * Developer                    		Date                Description<p />
 * --------------------------------------------------------------------------------
 * Diego Carbajal    					15/05/2020          Original version.<p />
 * Martin Alejandro Mori Chávez    		20/01/2021          Update methods for package 3.3.<p />
 *
 * @author Diego Carbajal
 */
public class AP_Team_Handler_cls extends TriggerHandler {
    /**
     * @Description variable triggerNew
     */
	List<bupl__AP_Team__c> triggerNew = Trigger.new;
    /**
     * @Description variable triggerOld
     */
	List<bupl__AP_Team__c> triggerOld = Trigger.Old;
    /**
     * @Description variable triggerNewMap
     */
	Map<id, bupl__AP_Team__c> triggerNewMap = ((Map<Id, bupl__AP_Team__c>)(Trigger.NewMap));
    /**
     * @Description variable triggerOldMap
     */
	Map<id, bupl__AP_Team__c> triggerOldMap = ((Map<Id, bupl__AP_Team__c>)(Trigger.OldMap));
	/*** @Description Clase implementada por Global*/
	Final acpl.AP_TeamHandler apTeamHandler = acpl.AP_TeamHandler.getInstance();

    /**
     * @Description beforeInsert
     */
	@TestVisible
	protected override void beforeInsert() {
		//Execute various methods according to established criteria
		AP_Team_Trigger_cls.beforeDML(triggerNew, 'insert');
		//Ejecuta diversas acciones de acuerdo a los criterios establecidos
		AP_Team_Trigger_cls.putValuesAPT(triggerNew);
		//Completa el campo de BusinessPlan
		apTeamHandler.fillBPLookup(triggerNew);
	}
    /** @Description beforeUpdate: Execute various methods according to established criteria*/
	@TestVisible
	protected override void beforeUpdate() {
		AP_Team_Trigger_cls.beforeDML(triggerNew, 'update');
	}
    /**
     * @Description beforeDelete: various methods according to the established criteria
     */
	@TestVisible
	protected override void beforeDelete() {
		AP_Team_Trigger_cls.beforeDML(triggerOld, 'delete');
	}
    /**
     * @Description afterInsert
     */
	@TestVisible
	protected override void afterInsert() {
		//Comparte registros de AP y BP con el miembro agregado
		Sharing_AP_Team_User_cls.SharingAPT(triggerNewMap, true);
		//Actualiza el estado desde 'Not started' a 'In progress' cuando se agrega un APT
		AP_Team_Trigger_cls.updateStatusOnAP(triggerNewMap);//  -- Deprecated
        //start new methods ver 3.3
        //Method updateStatusOnAP: Checks if AP Team Member has been added and propagates this change on Status field in related AP.
		//apTeamHandler.updateStatusOnAP(triggerNewMap);
        //end new methods ver 3.3
	}
    /**
     * @Description afterDelete: Eliminar el compartimiento de registros de AP y BP
     */
	@TestVisible
	protected override void afterDelete() {
		Sharing_AP_Team_User_cls.deleteSharing(triggerOldMap);
	}
}