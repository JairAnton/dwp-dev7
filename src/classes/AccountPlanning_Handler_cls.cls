/**
 * Handler of Trigger of the AccountPlanning object.
 * <p /><p />
 * Modification log:<p />
 * -------------------------------------------------------------------
 * Developer                    Date                Description<p />
 * -------------------------------------------------------------------
 * Diego Carbajal    		15/05/2020          Original version.<p />
 *
 * @author Diego Carbajal
 */
public class AccountPlanning_Handler_cls extends TriggerHandler {
	/*
	 * @Description  triggerNew
	 */
	List<acpl__Account_Planning__c> triggerNew = Trigger.new;
	/*
	 * @Description  triggerOld
	 */
	List<acpl__Account_Planning__c> triggerOld = Trigger.Old;
	/*
	 * @Description  triggerNewMap
	 */
	Map<id, acpl__Account_Planning__c> triggerNewMap = ((Map<Id, acpl__Account_Planning__c>)(Trigger.NewMap));
	/*
	 * @Description  triggerOldMap
	 */
	Map<id, acpl__Account_Planning__c> triggerOldMap = ((Map<Id, acpl__Account_Planning__c>)(Trigger.OldMap));
	/*
	 * @Description  Clase implementada por Global
	 */
	final acpl.AccountPlanningHandler apHandler = acpl.AccountPlanningHandler.getInstance();

	/*
	 * @Description  beforeInsert
	 */
	@TestVisible
	protected override void beforeInsert() {
		//Ejecuta acciones de acuerdo a criterios
		AccountPlanning_Trigger_cls.beforeInsert(triggerNew);
		//Bloquea y coloca el subestado 'Expired' a los AP's antiguos, relacionados al mismo cliente
		apHandler.changeToTimedOut(triggerNew);
	}

	/*
	 * @Description  beforeUpdate
	 */
	@TestVisible
	protected override void beforeUpdate() {
		//Valida si los AP's pueden ser modificados de acuerdo a su estado, bloqueo y usuario
		AccountPlanning_Trigger_cls.beforeDML(triggerNewMap, triggerOldMap, 'update');
		//Cambia solo del estado 'Not Started' a 'In Progress' cuando un miembro del APT modifica el AP
		AccountPlanning_Trigger_cls.updateStatusOnAPnotStarted(triggerNew, triggerOldMap);
		//Completa el campo 'Fecha de validación' cuando el AP es validado
		apHandler.fillValidationDate(triggerNew, triggerOldMap);
	}

	/*
	 * @Description  beforeDelete
	 * beforeDML: Valida si los AP's pueden ser eliminados de acuerdo a su estado, bloqueo y usuario
	 * beforeDeleteRelatedRecords: Metodo que elimina los registros de APT, Historial y Fields Config relacionados al AP
	 */
	@TestVisible
	protected override void beforeDelete() {
		AccountPlanning_Trigger_cls.beforeDML(triggerOldMap, null, 'delete');	
		AccountPlanning_Trigger_cls.beforeDeleteRelatedRecords(triggerOldMap);
	}

	/*
	 * @Description  afterInsert
	 */
	@TestVisible
	protected override void afterInsert() {
		//Inserta registros de historial de AP's creados
		apHandler.insertAPHistory(triggerNewMap, null, true, false);
		//Crea Business Plan y APT Owners relacionados a los AP's
		AccountPlanning_Trigger_cls.afterInsert(triggerNew);
		//Clona preguntas desde el catalogo y los asocia a los AP's
		AccountPlanning_Trigger_cls.relateAPQuestions(triggerNew);
	}

	/*
	 * @Description  afterUpdate
	 */
	@TestVisible
	protected override void afterUpdate() {
		//Bloquea/desbloquea los AP's y envia notificación a los usuarios del APT
		apHandler.blockUnblockAP(triggerNew, triggerOldMap);
		//Inserta registros al historial del AP
		apHandler.insertAPHistory(triggerNewMap, triggerOldMap, false, true);
		//Actualiza el estado de los Business Plan al estado en que se encuentra el AP
		apHandler.updateStatusOnBP(triggerNewMap, triggerOldMap);
		//Crea registros de acuerdo a las acciones comerciales cuando el AP es validado
		AP_Trigger_Helper.postValidated(triggerNewMap);
	}
}
