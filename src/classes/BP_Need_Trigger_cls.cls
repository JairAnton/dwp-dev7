/**
 * Handler class of Trigger handler of the Need object.
 * <p /><p />
 * Modification log:<p />
 * -------------------------------------------------------------------
 * Developer                    Date                Description<p />
 * -------------------------------------------------------------------
 * Diego Carbajal    		15/05/2020          Original version.<p />
 *
 * @author Diego Carbajal
 */
public without sharing class BP_Need_Trigger_cls {
    
    /*
	 * @Description  BP_Need_Trigger_cls
	 */
    private BP_Need_Trigger_cls() {}
	/*
	 * @Description  Valida que el usuario tenga permisos para insertar/modificar/eliminar registros
	 */
	public static void validateUserPermission(bupl__BP_Need__c[] newNeeds, String actionType) {
		Final Map<Id, List<bupl__BP_Need__c>> mapNeeds = new Map<Id, List<bupl__BP_Need__c>>();
		List<bupl__BP_Need__c> tmpNeed;
		for(bupl__BP_Need__c need:newNeeds) {
			tmpNeed = new List<bupl__BP_Need__c> {need};
			if(mapNeeds.containsKey(need.acpl__gf_account_planning_id__c)) {
				tmpNeed.addAll(mapNeeds.get(need.acpl__gf_account_planning_id__c));
			}
			mapNeeds.put(need.acpl__gf_account_planning_id__c, tmpNeed);
		}
		Final acpl__Account_Planning__c[] lstAP = [SELECT Id, acpl__gf_ap_indvi_lock_edit_ind_type__c, acpl__gf_ap_status_type_name__c, acpl__gf_ap_substatus_type_name__c
		                                     FROM acpl__Account_Planning__c WHERE Id IN:mapNeeds.keySet() AND recordType.DeveloperName = 'Account_Planning'];
		Final Integer lstAPSize = lstAP.size();
		if(lstAPSize > 0) {
			Final BE_AP_Permission_helper apAdministration = new BE_AP_Permission_helper(UserInfo.getUserId());
			Final Map<String, String> mapConfig = new Map<String, String> {'sobjectType' => 'bupl__BP_Need__c', 'actionType' => actionType};
			apAdministration.permissionOnRelatedRecords(lstAP, mapNeeds, mapConfig);
		}
	}

	/*
	 * @author       Global Desktop
	 * @Description  Check if Need has been created and propagates this change on Status field in related AP.
	 */
	public static void updateStatusOnAP(Map<Id, bupl__BP_Need__c> triggerNewMap) {
		Final Set<Id> bpIdList = new Set<Id>();
		for(bupl__BP_Need__c nd : triggerNewMap.values()) {
			//save de BP id's to query on it later
			bpIdList.add(nd.bupl__gf_business_plan_id__c);
		}

		if(!bpIdList.isEmpty()) {
			final List<bupl__BusinessPlan__c> listRelatedBP = [SELECT Id, acpl__gf_account_planning_id__c FROM bupl__BusinessPlan__c WHERE Id IN :bpIdList AND acpl__gf_account_planning_id__r.acpl__gf_ap_status_type_name__c = 'Not started'];
			final Set<Id> apIdList = new Set<Id>();
			for(bupl__BusinessPlan__c bp : listRelatedBP) {
				apIdList.add(bp.acpl__gf_account_planning_id__c);
			}
			if(!apIdList.isEmpty()) {
				updateAP(apIdList);
			}
		}
	}
    
    /*
	 * @Description  updateAP
	 */
    private static void updateAP(final Set<Id> apIdList) {
        Final BE_AP_Permission_helper permission = new BE_AP_Permission_helper(UserInfo.getUserId());
        Final Map<Id, Set<Id>> mapAPTs = permission.getAPTs(apIdList);
        final List<acpl__Account_Planning__c> listAPtoUpdate = [SELECT Id, acpl__gf_ap_status_type_name__c, acpl__gf_ap_substatus_type_name__c FROM acpl__Account_Planning__c WHERE Id IN :APidList AND acpl__gf_ap_status_type_name__c = 'Not started'];
        for(acpl__Account_Planning__c ap : listAPtoUpdate) {
            Final Boolean userInAPT = (mapAPTs.get(ap.Id) == null ? false :mapAPTs.get(ap.Id).contains(UserInfo.getUserId()));
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