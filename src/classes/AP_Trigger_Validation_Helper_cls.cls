/**
 * AP_Trigger_Validation_Helper_cls for SONAR
 * <p /><p />
 * Modification log:<p />
 * -------------------------------------------------------------------
 * Developer                    Date                Description<p />
 * -------------------------------------------------------------------
 * Diego Carbajal    		04/05/2020          Original version.<p />
 *
 * @author Diego Carbajal
 */
public without sharing class AP_Trigger_Validation_Helper_cls {

    /* @Description NOT_STARTED*/
    private static final String NOT_STARTED = 'Not started';
    /* @Description PENDINGV*/
    private static final String PENDINGV = 'Pending Validation';
    /* @Description IN_PROGRESS*/
	private static Final String IN_PROGRESS = 'In Progress';
    /* @Description PENDV*/
    private static Final String PENDV = 'Pending validation';
    /* @Description R_S_R*/
    private static Final String R_S_R = 'Request Sent For Review';
    /* @Description R_R_R*/
    private static Final String R_R_R = 'Request Re-Assigned';
    
    /*
	 * @Description  AP_Trigger_Validation_Helper_cls
	 */
    private AP_Trigger_Validation_Helper_cls() {}
    
    /*
	 * @Description  Obtiene los Id's de los AP que se encuentran en una petición
	 */
	public static Map<String, Set<Id>> getAPsInRequest(Set<Id> idsAPs) {
		Final Map<String, Set<Id>> mapAPInCases = new Map<String, Set<Id>>();
		Final Set<Id> idsAPReassigned = new Set<Id>();
		Final Set<Id> idsAPReview = new Set<Id>();
		Final Set<Id> idsAPApproved = new Set<Id>();
		//La gestión de la query es en orden desde la fecha mas antigua a la actual, la asignación de Ids se realizan acorde a las fechas
		for(Case request: [SELECT Id, Status, OwnerId, acpl__Account_plan_id__c, CreatedDate FROM Case WHERE RecordType.developerName = 'Account_Plan_Validation'
                            AND acpl__Account_plan_id__c IN:idsAPs AND Status IN('Request Sent For Review', 'Request Re-Assigned', 'Request Approved') ORDER BY CreatedDate ASC]) {
			//Si el AP ha sido devuelto
			if(request.Status == R_S_R) {
				idsAPReview.add(request.acpl__Account_plan_id__c);
			} else //Si el AP ha sido reasignado
			if(request.Status == R_R_R) {
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
	 * @Description  Get same validation in method checkUserChangeValidator
	 */
    public static Boolean getValidationsCV(Map<Id, acpl__Account_Planning__c> triggerOldMap, acpl__Account_Planning__c apR) {
        //Si lo valores del campo Unlock son iguales
        Final Boolean equalsFieldLock = triggerOldMap.get(apR.Id).acpl__gf_ap_indvi_lock_edit_ind_type__c == apR.acpl__gf_ap_indvi_lock_edit_ind_type__c;
        //Si el validador anterior y el nuevo son diferentes
        Final Boolean notEqualValidator = triggerOldMap.get(apR.Id).acpl__gf_ap_validator_user_id__c != apR.acpl__gf_ap_validator_user_id__c;
        //Si los subestados son iguales y son diferentes a Expired
        Final Boolean equalSubStatusNE = getEqualsSubStatusNE(triggerOldMap, apR);
        return equalsFieldLock && notEqualValidator && equalSubStatusNE;
    }
    
    /*
	 * @Description  Si los subestados son iguales y ademas es diferente a Expired
	 */
    public static Boolean getEqualsSubStatusNE(Map<Id, acpl__Account_Planning__c> triggerOldMap, acpl__Account_Planning__c apR) {
        return triggerOldMap.get(apR.Id).acpl__gf_ap_substatus_type_name__c == apR.acpl__gf_ap_substatus_type_name__c 
	            && apR.acpl__gf_ap_status_type_name__c != 'Expired';
    }
    
    /*
	 * @Description  Si los estados son iguales, y es Pending Validation
	 */
    public static Boolean getEqualsStatusPV(Map<Id, acpl__Account_Planning__c> triggerOldMap, acpl__Account_Planning__c apR) {
        return triggerOldMap.get(apR.Id).acpl__gf_ap_status_type_name__c == apR.acpl__gf_ap_status_type_name__c 
            	&& apR.acpl__gf_ap_status_type_name__c == PENDINGV;
    }
    
    /*
	 * @Description  Si los estados son iguales, y igual a Not started o In progress
	 */
    public static Boolean getEqualsStatusNI(Map<Id, acpl__Account_Planning__c> triggerOldMap, acpl__Account_Planning__c apR) {
        Final Boolean statusNI = apR.acpl__gf_ap_status_type_name__c == NOT_STARTED || apR.acpl__gf_ap_status_type_name__c == IN_PROGRESS;
        return triggerOldMap.get(apR.Id).acpl__gf_ap_status_type_name__c == apR.acpl__gf_ap_status_type_name__c && statusNI;
    }
    
    /*
	 * @Description  Si el estado y SubEstado es Pending Validation y la validación es requerida
	 */
    public static Boolean getStatSbStatPV(acpl__Account_Planning__c apR, Map<Id, acpl__Account_Planning__c> triggerOldMap) {
        return triggerOldMap.get(apR.Id).acpl__gf_ap_status_type_name__c == PENDINGV && 
            triggerOldMap.get(apR.Id).acpl__gf_ap_substatus_type_name__c == PENDV && apR.acpl__gf_ap_req_validation_ind_type__c == 'Yes';
    }
}