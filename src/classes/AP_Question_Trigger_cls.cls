/**
 * Handler class of Trigger handler of the AP_Question object.
 * <p /><p />
 * Modification log:<p />
 * -------------------------------------------------------------------
 * Developer                    Date                Description<p />
 * -------------------------------------------------------------------
 * Diego Carbajal    		15/05/2020          Original version.<p />
 *
 * @author Diego Carbajal
 */
public without sharing class AP_Question_Trigger_cls {
	/* @Description guarda id del RecordType de AP*/
	private static Final Id rtAP = [SELECT Id FROM RecordType WHERE developerName = 'Account_Planning' AND SobjectType = 'acpl__Account_Planning__c' LIMIT 1].Id;

	/*
	 * @Description  Valida que se tenga permisos para modificar/eliminar un Question
	 */
	public static void preventModifyQuestions(Map<Id, acpl__AP_Question__c> triggerMap, String actionType) {
		Final Map<Id, List<acpl__AP_Question__c>> mapQuestions = new Map<Id, List<acpl__AP_Question__c>>();
		Final Map<Id, acpl__AP_Question__c> mapQuestionsRtAP = new Map<Id, acpl__AP_Question__c>([SELECT Id, acpl__gf_account_planning_id__r.RecordTypeId FROM acpl__AP_Question__c WHERE
		                                                                                          Id IN: triggerMap.keySet()]);
		List<acpl__AP_Question__c> tmpQuestions;
		for(acpl__AP_Question__c question:triggerMap.values()) {
			if(rtAP == mapQuestionsRtAP.get(question.Id).acpl__gf_account_planning_id__r.RecordTypeId) {
				tmpQuestions = new List<acpl__AP_Question__c> {question};
				if(mapQuestions.containsKey(question.acpl__gf_account_planning_id__c)) {
					tmpQuestions.addAll(mapQuestions.get(question.acpl__gf_account_planning_id__c));
				}
				mapQuestions.put(question.acpl__gf_account_planning_id__c, tmpQuestions);
			}
		}
		Final List<acpl__Account_Planning__c> lstAP = [SELECT Id, Name, acpl__gf_ap_indvi_lock_edit_ind_type__c, acpl__participant_id__c, acpl__participant_id__r.Name,
		                                               acpl__gf_ap_status_type_name__c, acpl__gf_ap_substatus_type_name__c, acpl__gf_ap_priority_type_name__c FROM acpl__Account_Planning__c
		                                               WHERE Id IN:mapQuestions.keySet()];
		Final Map<String, String> mapConfig = new Map<String, String> {'sobjectType' => 'acpl__AP_Question__c', 'actionType' => actionType};
		Final BE_AP_Permission_helper apAdministration = new BE_AP_Permission_helper(UserInfo.getUserId());
		apAdministration.permissionOnRelatedRecords(lstAP, mapQuestions, mapConfig);
	}

	/*
	 * @author       Global Desktop
	 * @Description  Check if AP_Question__c has been modified and propagates this change on Status field in related AP.
	 */
	public static void updateStatusOnAP(Map<Id, acpl__AP_Question__c> triggerNewMap, Map<Id, acpl__AP_Question__c> triggerOldMap) {
		Final Set<Id> apIdList = new Set<Id>();
		for(acpl__AP_Question__c apq : triggerNewMap.values()) {
			//save de ap id's to query on it later
			if(apq.acpl__AA_answer_checkbox__c != triggerOldMap.get(apq.Id).acpl__AA_answer_checkbox__c || apq.acpl__AA_answer_currency__c != triggerOldMap.get(apq.Id).acpl__AA_answer_currency__c ||
			   apq.acpl__AA_answer_date__c != triggerOldMap.get(apq.Id).acpl__AA_answer_date__c || apq.acpl__AA_answer_number__c != triggerOldMap.get(apq.Id).acpl__AA_answer_number__c ||
			   apq.acpl__AA_answer_text__c != triggerOldMap.get(apq.Id).acpl__AA_answer_text__c || apq.acpl__AA_answer_text_area__c != triggerOldMap.get(apq.Id).acpl__AA_answer_text_area__c) {
				apIdList.add(apq.acpl__gf_account_planning_id__c);
			}
		}

		if(!apIdList.isEmpty()) {
			Final BE_AP_Permission_helper permission = new BE_AP_Permission_helper(UserInfo.getUserId());
			Final Map<Id, Set<Id>> mapAPTs = permission.getAPTs(apIdList);
			final list<acpl__Account_Planning__c> listAPtoUpdate = [SELECT Id, acpl__gf_ap_status_type_name__c, acpl__gf_ap_substatus_type_name__c FROM acpl__Account_Planning__c WHERE id IN :apIdList AND acpl__gf_ap_status_type_name__c = 'Not started'];
			for(acpl__Account_Planning__c ap : listAPtoUpdate) {
				Final Boolean userInAPT = (mapAPTs.get(ap.Id) == null ? false : mapAPTs.get(ap.Id).contains(UserInfo.getUserId()));
				if(userInAPT && ap.acpl__gf_ap_status_type_name__c == 'Not started' && ap.acpl__gf_ap_substatus_type_name__c != Label.acpl.AP_Timed_Out) {
					ap.acpl__gf_ap_status_type_name__c = 'In Progress';
					ap.acpl__gf_ap_substatus_type_name__c = 'AP team not invited';
				}
			}
			if(!listAPtoUpdate.isEmpty()) {
				update listAPtoUpdate;
			}
		}
	}
}