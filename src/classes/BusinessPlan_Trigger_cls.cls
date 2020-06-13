/**
 * Handler class of Trigger handler of the BusinessPlan object.
 * <p /><p />
 * Modification log:<p />
 * -------------------------------------------------------------------
 * Developer                    Date                Description<p />
 * -------------------------------------------------------------------
 * Diego Carbajal    		15/05/2020          Original version.<p />
 *
 * @author Diego Carbajal
 */
public without sharing class BusinessPlan_Trigger_cls {
    
    /*** @Description BusinessPlan_Trigger_cls*/
    private BusinessPlan_Trigger_cls() {}
	/*
	 * @author       Global Desktop
	 * @Description  Check if BP has changed and if so propagates this change on Status field in related AP.
	 */
	public static void updateStatusOnAP(Map<Id, bupl__BusinessPlan__c> triggerNewMap, Map<Id, bupl__BusinessPlan__c> triggerOldMap) {
		final Set<Id> APidList = new Set<Id>();
		final Set<Id> changeStatus = new Set<Id>();
		final Set<Id> changeAnother = new Set<Id>();
		for(bupl__BusinessPlan__c bp : triggerNewMap.values()) {
			if(bp.bupl__status_type__c != triggerOldMap.get(bp.Id).bupl__status_type__c && bp.bupl__status_type__c == 'Validated' &&
			   bp.acpl__gf_ap_indvi_lock_edit_ind_type__c) { //if change status to "Validated" on BP
				changeStatus.add(bp.acpl__gf_account_planning_id__c);
				APidList.add(bp.acpl__gf_account_planning_id__c);
			} else if(bp.acpl__gf_ap_indvi_lock_edit_ind_type__c) { //if any other field is changed save de AP_id to query on it later
				changeAnother.add(bp.acpl__gf_account_planning_id__c);
				APidList.add(bp.acpl__gf_account_planning_id__c);
			}
		}
		if(!APidList.isEmpty()) {
			updateAP(APidList, changeStatus, changeAnother);
		}
	}

	/**
	* @Description updateAP
	*/    
    private static void updateAP(Set<Id> APidList, Set<Id> changeStatus, Set<Id> changeAnother) {
        final list<acpl__Account_Planning__c> listAPtoUpdate = [SELECT Id, acpl__gf_ap_status_type_name__c, acpl__gf_ap_substatus_type_name__c FROM 
                                                                acpl__Account_Planning__c WHERE Id IN :APidList AND acpl__gf_ap_status_type_name__c = 'Not started'];
        Final BE_AP_Permission_helper permission = new BE_AP_Permission_helper(UserInfo.getUserId());
        Final Map<Id, Set<Id>> mapAPTs = permission.getAPTs(APidList);
        for(acpl__Account_Planning__c ap : listAPtoUpdate) {
            Final Boolean userInAPT = (mapAPTs.get(ap.Id) == null ? false : mapAPTs.get(ap.Id).contains(UserInfo.getUserId()));
            if(changeStatus.contains(ap.Id)) {
                ap.acpl__gf_ap_status_type_name__c = 'Validated';
                ap.acpl__gf_ap_substatus_type_name__c = 'In place';
            } else if(changeAnother.contains(ap.Id) &&  userInAPT) {
                ap.acpl__gf_ap_status_type_name__c = 'In Progress';
                ap.acpl__gf_ap_substatus_type_name__c = 'AP team not invited';
            }
        }
        if(!listAPtoUpdate.isEmpty()) {
            update listAPtoUpdate;
        }
    }

    /**
	* @Description preventModifyBP
	*/
	public static void preventModifyBP(Map<Id, bupl__BusinessPlan__c> triggerMap, String actionType) {
		Final Map<Id, List<bupl__BusinessPlan__c>> mapBP = new Map<Id, List<bupl__BusinessPlan__c>>();
		List<bupl__BusinessPlan__c> lstBP;
		for(bupl__BusinessPlan__c bp:triggerMap.values()) {
			lstBP = new List<bupl__BusinessPlan__c> {bp};
			if(mapBP.containsKey(bp.acpl__gf_account_planning_id__c)) {
				lstBP.addAll(mapBP.get(bp.acpl__gf_account_planning_id__c));
			}
			mapBP.put(bp.acpl__gf_account_planning_id__c, lstBP);
		}
		Final List<acpl__Account_Planning__c> lstAP = [SELECT Id, Name, acpl__gf_ap_indvi_lock_edit_ind_type__c, acpl__participant_id__c, acpl__participant_id__r.Name,
		                                               acpl__gf_ap_status_type_name__c, acpl__gf_ap_substatus_type_name__c, acpl__gf_ap_priority_type_name__c FROM acpl__Account_Planning__c
		                                               WHERE Id IN:mapBP.keySet()];
		Final BE_AP_Permission_helper apAdministration = new BE_AP_Permission_helper(UserInfo.getUserId());
		Final Map<String, String> mapConfig = new Map<String, String> {'sobjectType' => 'bupl__BusinessPlan__c', 'actionType' => actionType};
		apAdministration.permissionOnRelatedRecords(lstAP, mapBP, mapConfig);
	}
}