/**
 * Handler class of Trigger handler of the CommercialPlantEvent object.
 * <p /><p />
 * Modification log:<p />
 * -------------------------------------------------------------------
 * Developer                    Date                Description<p />
 * -------------------------------------------------------------------
 * Diego Carbajal    		15/05/2020          Original version.<p />
 *
 * @author Diego Carbajal
 */
public without sharing class AP_CommercialPlan_Trigger_cls {
	/*
	 * @Description  private constructor
	 *
	 */
	private AP_CommercialPlan_Trigger_cls() {
	}

	/*
	 * @Description  Valida que el usuario tenga permiso de insertar/modificar/eliminar
	 */
	public static void validateUserPermission(acpl__Commercial_Plan_Event__c[] newCPE, String actionType) {
		Final Map<Id, List<acpl__Commercial_Plan_Event__c>> mapCPE = new Map<Id, List<acpl__Commercial_Plan_Event__c>>();
		List<acpl__Commercial_Plan_Event__c> tmpCPE;
		for(acpl__Commercial_Plan_Event__c cpe:newCPE) {
			tmpCPE = new List<acpl__Commercial_Plan_Event__c> {cpe};
			if(mapCPE.containsKey(cpe.acpl__gf_account_planning_id__c)) {
				tmpCPE.addAll(mapCPE.get(cpe.acpl__gf_account_planning_id__c));
			}
			mapCPE.put(cpe.acpl__gf_account_planning_id__c, tmpCPE);
		}
		Final acpl__Account_Planning__c[] lstAP = [SELECT Id, acpl__gf_ap_indvi_lock_edit_ind_type__c, acpl__gf_ap_status_type_name__c, acpl__gf_ap_substatus_type_name__c
		                                           FROM acpl__Account_Planning__c WHERE Id IN:mapCPE.keySet() AND recordType.DeveloperName = 'Account_Planning'];
		Final Integer lstAPSize = lstAP.size();
		if(lstAPSize > 0) {
			Final Map<String, String> mapConfig = new Map<String, String> {'sobjectType' => 'acpl__Commercial_Plan_Event__c', 'actionType' => actionType};
			Final BE_AP_Permission_helper apAdministration = new BE_AP_Permission_helper(UserInfo.getUserId());
			apAdministration.permissionOnRelatedRecords(lstAP, mapCPE, mapConfig);
		}
	}

	/*
	 * @author       Global Desktop
	 * @Description  Check if a CommercialPlanEvent has been created and propagates this change on Status field in related AP.
	 */
	public static void updateStatusOnAP(Map<Id, acpl__Commercial_Plan_Event__c> triggerNewMap) {
		Final Set<Id> apIdList = new Set<Id>();
		for(acpl__Commercial_Plan_Event__c cpe : triggerNewMap.values()) {
			//save de ap id's to query on it later
			apIdList.add(cpe.acpl__gf_account_planning_id__c);
		}
		if(!apIdList.isEmpty()) {
			Final BE_AP_Permission_helper permission = new BE_AP_Permission_helper(UserInfo.getUserId());
			Final Map<Id, Set<Id>> mapAPTs = permission.getAPTs(apIdList);
			final list<acpl__Account_Planning__c> listAPtoUpdate = [SELECT Id, acpl__gf_ap_status_type_name__c, acpl__gf_ap_substatus_type_name__c FROM acpl__Account_Planning__c WHERE Id IN :apIdList AND acpl__gf_ap_status_type_name__c = 'Not started'];
			for(acpl__Account_Planning__c ap : listAPtoUpdate) {
				Boolean userInAPT = (mapAPTs.get(ap.Id) == null ? false : mapAPTs.get(ap.Id).contains(UserInfo.getUserId()));
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