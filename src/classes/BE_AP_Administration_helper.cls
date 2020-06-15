/**
 * BE_AP_Administration_helper helper class for message o AP
 * <p /><p />
 * Modification log:<p />
 * -------------------------------------------------------------------
 * Developer                    Date                Description<p />
 * -------------------------------------------------------------------
 * Diego Carbajal    		07/05/2020          Original version.<p />
 *
 * @author Diego Carbajal
 */
public without sharing class BE_AP_Administration_helper {
    /** @Description  EXPIRED*/
    private static Final String EXPIRED = 'Expired';
    /** @Description  EXPIRED*/
    private static Final String PENDG_VAL = 'Pending Validation';
    /** @Description  EXPIRED*/
    private static Final String VALIDATED = 'Validated';
	/*
	 * @Description  private constructor
	 */
	private BE_AP_Administration_helper() {
	}

	/*
	 * @Description  method getAP
	 */
	@AuraEnabled
	public static List<acpl__Account_Planning__c> getAP(String recordId) {
		return [SELECT Id, Name, acpl__gf_ap_indvi_lock_edit_ind_type__c, acpl__participant_id__c, acpl__participant_id__r.Name,
		        acpl__gf_ap_status_type_name__c, acpl__gf_ap_substatus_type_name__c, acpl__gf_ap_priority_type_name__c, acpl__proposal_manager_id__c,
		        acpl__participant_id__r.OwnerId FROM acpl__Account_Planning__c WHERE Id = : recordId LIMIT 1];
	}

	/*
	 * @Description  method validateStatus
	 */
	public static Map<String, Object> validateStatus(acpl__Account_Planning__c apR) {
		Final Map<String, Object> mapRes = new Map<String, Object> {'validation' => false};
		if(apR.acpl__gf_ap_substatus_type_name__c == EXPIRED) {
			mapRes.put('status', 'expirado.');
		} else if(apR.acpl__gf_ap_status_type_name__c == PENDG_VAL) {
			mapRes.put('status', 'pendiente de validación.');
		} else if(apR.acpl__gf_ap_status_type_name__c == VALIDATED) {
			mapRes.put('status', 'validado.');
		} else {
			mapRes.put('validation', true);
		}
		return mapRes;
	}

	/*
	 * @Description  method addErrorOnSobject
	 */
	public static void addErrorOnSobject(List<SObject> lstSObject, String sobjType, String msg) {
		Final List<SObject> castRecords = (List<SObject>)Type.forName('List<' + sobjType + '>').newInstance();
		castRecords.addAll(lstSObject);
        castRecords[0].addError(msg);
	}

	/*
	 * @Description  method customMessage
	 */
	public static String customMessage(String actionType, String recordName, String status) {
		String message;
		switch on actionType {
			when 'insert' {
				message = 'No puede agregar ' + recordName + ' a un plan de cuenta ' + status;
			}
			when 'update' {
				message = 'No puede actualizar ' + recordName + ' de un plan de cuenta ' + status;
			}
			when 'delete' {
				message = 'No puede eliminar ' + recordName + ' de un plan de cuenta ' + status;
			}
		}
		return message;
	}
}