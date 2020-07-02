/**
 * AccountPlanning_Trigger_Validation_cls
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
	private static Final Id RT_AP = [SELECT Id FROM RecordType WHERE developerName = 'Account_Planning' AND SobjectType = 'acpl__Account_Planning__c' LIMIT 1].Id;
	/* @Description lstAP*/
	private static List<acpl__Account_Planning__c> lstAP = new List<acpl__Account_Planning__c>();
	/* @Description mapAPs*/
	private static Map<Id, List<acpl__Account_Planning__c>> mapAPs = new Map<Id, List<acpl__Account_Planning__c>>();
	/* @Description message*/
	private static String message;
    /* @Description VALIDATED*/
    private static Final String VALIDATED = 'Validated';
    /* @Description IN_PROGRESS*/
	private static Final String IN_PROGRESS = 'In Progress';
    /* @Description UPD*/
    private static Final String UPD = 'update';
    
    /*
	 * @Description  method AccountPlanning_Trigger_Validation_cls
	 */
    private AccountPlanning_Trigger_Validation_cls() {}
	/*
	 * @Description  method preventModifyAP
	 */
	public static void preventModifyAP(Map<Id, acpl__Account_Planning__c> triggerMap, Map<Id, acpl__Account_Planning__c> triggerOldMap, String actionType) {
		Final BE_AP_Permission_helper apAdministration = new BE_AP_Permission_helper(UserInfo.getUserId());
		Boolean adminUser = apAdministration.adminPermission();
		adminUser = adminUser || apAdministration.permissionOnAP(actionType);
		Final Map<String, Set<Id>> mapAPInCases = AP_Trigger_Validation_Helper_cls.getAPsInRequest(triggerMap.keySet());
		for(acpl__Account_Planning__c apR:triggerMap.values()) {
			if(apR.RecordTypeId == RT_AP) {
				if(actionType == UPD) {
					message = null;//NOSONAR
					Final Boolean checkCV = checkUserChangeValidator(apR, triggerOldMap, mapAPInCases.get('reAssigned'), adminUser);
					//Previene que un AP se devuelva o valide por un usuario que no sea el validador, administrador del AP o el Admin
					Final Boolean checkRV = checkReturnOrValidation(apR, triggerOldMap, mapAPInCases, adminUser);
					if(checkCV || checkRV) {
						if(String.isNotBlank(message)) {
							BE_AP_Administration_helper.addErrorOnSobject(new List<acpl__Account_Planning__c> {apR}, 'acpl__Account_Planning__c', message);
						}
					} else {
						traditionalValidation(apR, triggerOldMap);
					}
				} else {//Previen la edición/eliminación del AP si el registro esta expirado, bloqueado o asignado a otro usuario
					traditionalValidation(apR, triggerOldMap);
				}
			}
		}
		lstAP = (triggerOldMap == null ? triggerMap.values() : lstAP);
		Final Map<String, String> mapConfig = new Map<String, String> {'sobjectType' => 'acpl__Account_Planning__c', 'actionType' => actionType};
		apAdministration.permissionOnRelatedRecords(lstAP, mapAPs, mapConfig);
	}

	

	/*
	 * @Description  Compruebra el usuario que cambia de validador y si esta asociado a un caso activo
	 */
	private static Boolean checkUserChangeValidator(acpl__Account_Planning__c apR, Map<Id, acpl__Account_Planning__c> triggerOldMap, Set<Id> idsAPInRequest, Boolean adminUser) {
		Boolean checkUser = false;
        //Validaciones reutilizables
        //Si lo valores del campo Unlock son iguales
        Final Boolean validationCV = AP_Trigger_Validation_Helper_cls.getValidationsCV(triggerOldMap, apR);
        //Primera validación IF
        Final Boolean equalStatusPV = AP_Trigger_Validation_Helper_cls.getEqualsStatusPV(triggerOldMap, apR);
        //Segunda validación IF
        Final Boolean equalStatusNI = AP_Trigger_Validation_Helper_cls.getEqualsStatusNI(triggerOldMap, apR);
		//Si se cambia de validador cuando el AP esta en pendiente de validación
		if(validationCV && equalStatusPV && !apR.acpl__gf_ap_indvi_lock_edit_ind_type__c) {
			checkUser = true;
			changeWPetition(apR, triggerOldMap, idsAPInRequest, adminUser);
		} else //Si se cambia de validador cuando el AP esta en Not started o In progress
            if(validationCV && equalStatusNI && apR.acpl__gf_ap_indvi_lock_edit_ind_type__c) {
			checkUser = true;
			changeWOutPetition(apR, triggerOldMap, adminUser);
		}
		return checkUser;
	}

    /*
	 * @Description  changeWPetition
	 */
    private static void changeWPetition(acpl__Account_Planning__c apR, Map<Id, acpl__Account_Planning__c> triggerOldMap, Set<Id> idsAPInRequest, Boolean adminUser) {
        //Si el cambio es mediante la petición
        if(idsAPInRequest.contains(apR.Id)) {   //Si el usuario no es validador o administrador
            if(!(UserInfo.getUserId() == triggerOldMap.get(apR.Id).acpl__gf_ap_validator_user_id__c || adminUser)) {
                message = System.Label.AP_InvalidAssignationValidatorByUser;
            }
        } else {   //Si el cambio no es mediante la petición, no debe permitir si no es administrador
           	if(UserInfo.getUserId() == triggerOldMap.get(apR.Id).acpl__gf_ap_validator_user_id__c) {
                message = System.Label.AP_ChangeValidatorOutPetition;
            } else if(!adminUser) {
                message = System.Label.AP_InvalidAssignationValidatorByUser;
            }
        }
    }
    
    /*
	 * @Description  changeWOutPetition
	 */
    private static void changeWOutPetition(acpl__Account_Planning__c apR, Map<Id, acpl__Account_Planning__c> triggerOldMap, Boolean adminUser) {
        //Si el cambio de validador no lo hace el validador o administrador
        if(!(UserInfo.getUserId() == triggerOldMap.get(apR.Id).acpl__gf_ap_validator_user_id__c || adminUser)) {
            message = System.Label.AP_InvalidAssignationValidatorByUser;
        }
    }
    
	/*
	 * @Description  Compruebra el usuario retorna un AP y si esta asociado a un caso activo
	 */
	private static Boolean checkReturnOrValidation(acpl__Account_Planning__c apR, Map<Id, acpl__Account_Planning__c> triggerOldMap, 
                                                   Map<String, Set<Id>> mapAPInCases, Boolean adminUser) {
		Boolean checkUser = false;
        //Si el estado y subEstado es Pending Validation
        Final Boolean statSubStatPV = AP_Trigger_Validation_Helper_cls.getStatSbStatPV(apR, triggerOldMap);
		//Cuando se devuelve un AP del proceso de validación
		if(statSubStatPV && apR.acpl__gf_ap_status_type_name__c == IN_PROGRESS && apR.acpl__gf_ap_substatus_type_name__c == 'Pending review') {
			checkUser = true;
			returnAPCriteria(mapAPInCases.get('review'), apR, triggerOldMap, adminUser);
		} else //Cuando se valida un AP con validación requerida
		if(statSubStatPV && apR.acpl__gf_ap_status_type_name__c == VALIDATED && apR.acpl__gf_ap_substatus_type_name__c == 'In place') {
			checkUser = true;
			validateAPCriteria(mapAPInCases.get('approved'), apR, triggerOldMap, adminUser);
		}
		return checkUser;
	}

    /*
	 * @Description  returnAPCriteria
	 */
    private static void returnAPCriteria(Set<Id> idsAPReview, acpl__Account_Planning__c apR, Map<Id, acpl__Account_Planning__c> triggerOldMap, Boolean adminUser) {
        //Si el AP se devuelves desde la petición
			if(idsAPReview.contains(apR.Id)) {//Si el usuario que devuelve no es validador o admin
				if(!(UserInfo.getUserId() == triggerOldMap.get(apR.Id).acpl__gf_ap_validator_user_id__c || adminUser)) {
					message = System.Label.AP_UnableToReturnAPUnassigned;
				}
			} else {   //Si el AP no es devuelto desde la petición
				if(UserInfo.getUserId() == triggerOldMap.get(apR.Id).acpl__gf_ap_validator_user_id__c) {
					message = String.format(System.Label.AP_BadActionWithAPOutPetition, new String[]{'devolver'});
				} else if(!adminUser) {
					message = System.Label.AP_UnableToReturnAPUnassigned;
				}
			}
    }
    
    /*
	 * @Description  validateAPCriteria
	 */
    private static void validateAPCriteria(Set<Id> idsAPApproved, acpl__Account_Planning__c apR, Map<Id, acpl__Account_Planning__c> triggerOldMap, Boolean adminUser) {
        //Cuando el AP es validado desde la petición
        if(idsAPApproved.contains(apR.Id)) {    //Si el AP no es validado por el validador o administrador
            if(!(UserInfo.getUserId() == triggerOldMap.get(apR.Id).acpl__gf_ap_validator_user_id__c || adminUser)) {
                message = System.Label.AP_ValidationByUnAssignedUser;
            }
        } else {    //Cuando el AP es validado fuera del proceso de la petición
           	if(UserInfo.getUserId() == triggerOldMap.get(apR.Id).acpl__gf_ap_validator_user_id__c) {
                message = String.format(System.Label.AP_BadActionWithAPOutPetition, new String[]{'validar'});
            } else if(!adminUser) {
                message = System.Label.AP_ValidationByUnAssignedUser;
            }
        }
    }

	/*
	 * @Description  method settraditionalValidationUp
	 */
	private static void traditionalValidation(acpl__Account_Planning__c apR, Map<Id, acpl__Account_Planning__c> triggerOldMap) {
		mapAPs.put(apR.Id, new List<acpl__Account_Planning__c> {apR});
		if(triggerOldMap != null) {
			lstAP.add(triggerOldMap.get(apR.Id));
		}
	}
}