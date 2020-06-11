/**
 * Test class AccountPlanning_Trigger_Validation_cls
 * <p /><p />
 * Modification log:<p />
 * -------------------------------------------------------------------
 * Developer                    Date                Description<p />
 * -------------------------------------------------------------------
 * Diego Carbajal    		04/05/2020          Original version.<p />
 *
 * @author Diego Carbajal
 */
public without sharing class AccountPlanning_Trigger_Validation_cls {
	/* @Description guarda id del RecordType de AP*/
	private static Final Id rtAP = [SELECT Id FROM RecordType WHERE developerName = 'Account_Planning' AND SobjectType = 'acpl__Account_Planning__c' LIMIT 1].Id;
	/* @Description lstAPP*/
	public static List<acpl__Account_Planning__c> lstAP = new List<acpl__Account_Planning__c>();
	/* @Description mapAPs*/
	private static Map<Id, List<acpl__Account_Planning__c>> mapAPs = new Map<Id, List<acpl__Account_Planning__c>>();
	/* @Description message*/
	private static String message;

	/*
	 * @Description  method preventModifyAP
	 */
	public static void preventModifyAP(Map<Id, acpl__Account_Planning__c> triggerMap, Map<Id, acpl__Account_Planning__c> triggerOldMap, String actionType) {
		Final BE_AP_Permission_helper apAdministration = new BE_AP_Permission_helper(UserInfo.getUserId());
		Boolean adminUser = apAdministration.adminPermission();
		adminUser = adminUser || apAdministration.permissionOnAP(actionType);
		Final Map<String, Set<Id>> mapAPInCases = getAPsInRequest(triggerMap.keySet());
		for(acpl__Account_Planning__c ap:triggerMap.values()) {
			if(ap.RecordTypeId == rtAP) {
				if(actionType == 'update') {
					message = null;
					Boolean checkChangeValidator = checkUserChangeValidator(ap, triggerOldMap, mapAPInCases.get('reAssigned'), adminUser);
					//Previene que un AP se devuelva o valide por un usuario que no sea el validador, administrador del AP o el Admin
					Boolean checkReturnOrValidated = checkReturnOrValidation(ap, triggerOldMap, mapAPInCases, adminUser);
					if(checkChangeValidator || checkReturnOrValidated) {
						if(String.isNotBlank(message)) {
							BE_AP_Administration_helper.addErrorOnSobject(new List<acpl__Account_Planning__c> {ap}, 'acpl__Account_Planning__c', message);
						}
					} else {
						traditionalValidation(ap, triggerOldMap);
					}
				} else {//Previen la edición/eliminación del AP si el registro esta expirado, bloqueado o asignado a otro usuario
					traditionalValidation(ap, triggerOldMap);
				}
			}
		}
		lstAP = (triggerOldMap == null ? triggerMap.values() : lstAP);
		Final Map<String, String> mapConfig = new Map<String, String> {'sobjectType' => 'acpl__Account_Planning__c', 'actionType' => actionType};
		apAdministration.permissionOnRelatedRecords(lstAP, mapAPs, mapConfig);
	}

	/*
	 * @Description  Obtiene los Id's de los AP que se encuentran en una petición
	 */
	private static Map<String, Set<Id>> getAPsInRequest(Set<Id> idsAPs) {
		Final Map<String, Set<Id>> mapAPInCases = new Map<String, Set<Id>>();
		Final Set<Id> idsAPReassigned = new Set<Id>();
		Final Set<Id> idsAPReview = new Set<Id>();
		Final Set<Id> idsAPApproved = new Set<Id>();
		//La gestión de la query es en orden desde la fecha mas antigua a la actual, la asignación de Ids se realizan acorde a las fechas
		for(Case request: [SELECT Id, Status, OwnerId, acpl__Account_plan_id__c, CreatedDate FROM Case WHERE RecordType.developerName = 'Account_Plan_Validation'
		                                                                                                                                AND acpl__Account_plan_id__c IN:idsAPs AND Status IN('Request Re-Assigned', 'Request Sent For Review', 'Request Approved') ORDER BY CreatedDate ASC]) {
			//Si el AP ha sido devuelto
			if(request.Status == 'Request Sent For Review') {
				idsAPReview.add(request.acpl__Account_plan_id__c);
			} else //Si el AP ha sido reasignado
			if(request.Status == 'Request Re-Assigned') {
				idsAPReassigned.add(request.acpl__Account_plan_id__c);
				//Si un AP devuelto tiene una reasignación despues de haber sido devuelta, significa que no debe existir una solicitud de devolución actual,
				//por lo tanto se elimina
				if(idsAPReview.contains(request.acpl__Account_plan_id__c)) {
					idsAPReview.remove(request.acpl__Account_plan_id__c);
				}
			} else {//Si un AP es aprobado
				idsAPApproved.add(request.acpl__Account_plan_id__c);
				//Si un AP es aprobado, significa que no debe existir una solicitud de devolución actual, por lo tanto se elimina
				if(idsAPReview.contains(request.acpl__Account_plan_id__c)) {
					idsAPReview.remove(request.acpl__Account_plan_id__c);
				}
			}
		}
		mapAPInCases.put('reAssigned', idsAPReassigned);
		mapAPInCases.put('review', idsAPReview);
		mapAPInCases.put('approved', idsAPApproved);
		return mapAPInCases;
	}

	/*
	 * @Description  Compruebra el usuario que cambia de validador y si esta asociado a un caso activo
	 */
	private static Boolean checkUserChangeValidator(acpl__Account_Planning__c ap, Map<Id, acpl__Account_Planning__c> triggerOldMap, Set<Id> idsAPInRequest, Boolean adminUser) {
		Boolean checkUser = false;
		//Si se cambia de validador cuando el AP esta en pendiente de validación
		if(triggerOldMap.get(ap.Id).acpl__gf_ap_validator_user_id__c != ap.acpl__gf_ap_validator_user_id__c &&
		   triggerOldMap.get(ap.Id).acpl__gf_ap_status_type_name__c == ap.acpl__gf_ap_status_type_name__c &&
		   triggerOldMap.get(ap.Id).acpl__gf_ap_substatus_type_name__c == ap.acpl__gf_ap_substatus_type_name__c &&
		   triggerOldMap.get(ap.Id).acpl__gf_ap_indvi_lock_edit_ind_type__c == ap.acpl__gf_ap_indvi_lock_edit_ind_type__c &&
		   ap.acpl__gf_ap_status_type_name__c == 'Pending Validation' && ap.acpl__gf_ap_substatus_type_name__c != 'Expired' &&
		   !ap.acpl__gf_ap_indvi_lock_edit_ind_type__c) {
			checkUser = true;
			//Si el cambio es mediante la petición
			if(idsAPInRequest.contains(ap.Id)) {   //Si el usuario no es validador o administrador
				if(!(UserInfo.getUserId() == triggerOldMap.get(ap.Id).acpl__gf_ap_validator_user_id__c || adminUser)) {
					message = 'No puede asignar otro validador a este plan de cuenta.';
				}
			} else {   //Si el cambio no es mediante la petición, no debe permitir si no es administrador
				if(UserInfo.getUserId() == triggerOldMap.get(ap.Id).acpl__gf_ap_validator_user_id__c) {
					message = 'Para cambiar de validador debe hacerlo a tróves de la petición solicitada por el gestor.';
				} else if(!adminUser) {
					message = 'No puede asignar otro validador a este plan de cuenta.';
				}
			}
			//Si se cambia de validador cuando el AP esta en Not started o In progress
		} else if(triggerOldMap.get(ap.Id).acpl__gf_ap_validator_user_id__c != ap.acpl__gf_ap_validator_user_id__c &&
		          triggerOldMap.get(ap.Id).acpl__gf_ap_status_type_name__c == ap.acpl__gf_ap_status_type_name__c &&
		          triggerOldMap.get(ap.Id).acpl__gf_ap_substatus_type_name__c == ap.acpl__gf_ap_substatus_type_name__c &&
		          triggerOldMap.get(ap.Id).acpl__gf_ap_indvi_lock_edit_ind_type__c == ap.acpl__gf_ap_indvi_lock_edit_ind_type__c &&
		          (ap.acpl__gf_ap_status_type_name__c != 'Pending Validation' && ap.acpl__gf_ap_status_type_name__c != 'Validated') &&
		          ap.acpl__gf_ap_substatus_type_name__c != 'Expired' && ap.acpl__gf_ap_indvi_lock_edit_ind_type__c) {
			checkUser = true;
			//Si el cambio de validador no lo hace el validador o administrador
			if(!(UserInfo.getUserId() == triggerOldMap.get(ap.Id).acpl__gf_ap_validator_user_id__c || adminUser)) {
				message = 'No puede asignar otro validador a este plan de cuenta.';
			}
		}
		return checkUser;
	}

	/*
	 * @Description  Compruebra el usuario retorna un AP y si esta asociado a un caso activo
	 */
	private static Boolean checkReturnOrValidation(acpl__Account_Planning__c ap, Map<Id, acpl__Account_Planning__c> triggerOldMap, Map<String, Set<Id>> mapAPInCases, Boolean adminUser) {
		Final Set<Id> idsAPReview = mapAPInCases.get('review');
		Final Set<Id> idsAPApproved = mapAPInCases.get('approved');
		Boolean checkUser = false;
		//Cuando se devuelve un AP del proceso de validación
		if(triggerOldMap.get(ap.Id).acpl__gf_ap_status_type_name__c == 'Pending Validation' &&
		   triggerOldMap.get(ap.Id).acpl__gf_ap_substatus_type_name__c == 'Pending validation' &&
		   ap.acpl__gf_ap_status_type_name__c == 'In Progress' && ap.acpl__gf_ap_substatus_type_name__c == 'Pending review' &&
		   ap.acpl__gf_ap_req_validation_ind_type__c == 'Yes') {
			checkUser = true;
			//Si el AP se devuelves desde la petición
			if(idsAPReview.contains(ap.Id)) {   //Si el usuario que devuelve no es validador o admin
				if(!(UserInfo.getUserId() == triggerOldMap.get(ap.Id).acpl__gf_ap_validator_user_id__c || adminUser)) {
					message = 'No puede devolver un plan de cuenta que no tiene asignado.';
				}
			} else {   //Si el AP no es devuelto desde la petición
				if(UserInfo.getUserId() == triggerOldMap.get(ap.Id).acpl__gf_ap_validator_user_id__c) {
					message = 'Para devolver un plan de cuenta debe hacerlo a tróves de la petición del gestor.';
				} else if(!adminUser) {
					message = 'No puede devolver un plan de cuenta que no tiene asignado.';
				}
			}
		} else    //Cuando se valida un AP con validación requerida
		if(triggerOldMap.get(ap.Id).acpl__gf_ap_status_type_name__c == 'Pending Validation' &&
		   triggerOldMap.get(ap.Id).acpl__gf_ap_substatus_type_name__c == 'Pending validation' &&
		   ap.acpl__gf_ap_status_type_name__c == 'Validated' && ap.acpl__gf_ap_substatus_type_name__c == 'In place' &&
		   ap.acpl__gf_ap_req_validation_ind_type__c == 'Yes') {
			checkUser = true;
			//Cuando el AP es validado desde la petición
			if(idsAPApproved.contains(ap.Id)) {    //Si el AP no es validado por el validador o administrador
				if(!(UserInfo.getUserId() == triggerOldMap.get(ap.Id).acpl__gf_ap_validator_user_id__c || adminUser)) {
					message = 'No puede validar un plan de cuenta que no tiene asignado.';
				}
			} else {    //Cuando el AP es validado fuera del proceso de la petición
				if(UserInfo.getUserId() == triggerOldMap.get(ap.Id).acpl__gf_ap_validator_user_id__c) {
					message = 'Para validar un plan de cuenta debe hacerlo a tróves de la petición del gestor.';
				} else if(!adminUser) {
					message = 'No puede validar un plan de cuenta que no tiene asignado.';
				}
			}
		}
		return checkUser;
	}

	/*
	 * @Description  method settraditionalValidationUp
	 */
	private static void traditionalValidation(acpl__Account_Planning__c ap, Map<Id, acpl__Account_Planning__c> triggerOldMap) {
		mapAPs.put(ap.Id, new List<acpl__Account_Planning__c> {ap});
		if(triggerOldMap != null) {
			lstAP.add(triggerOldMap.get(ap.Id));
		}
	}
}