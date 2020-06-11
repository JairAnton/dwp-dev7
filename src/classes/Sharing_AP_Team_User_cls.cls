/**
 * ------------------------------------------------------------------------------------------------
 * @Name Sharing_AP_Team_User_cls
 * @Author Diego Carbajal diego.carbajal@bbva.com
 * @Date Created: 2020-04-08
 * @Group
 * @Description Clase que permite compartir registros de AP/BP a través del Trigger
 */
public without sharing class Sharing_AP_Team_User_cls {
	/*Constructor Method*/
	private Sharing_AP_Team_User_cls() {
	}

	/*
	 * @Description	Comparte los registros de AP/BP
	 */
	public static void SharingAPT(Map<Id, bupl__AP_Team__c> triggerNew, Boolean isTrigger) {
		Final List<acpl__Account_Planning__Share> lstAPTShare = new List<acpl__Account_Planning__Share>();
		Final List<bupl__BusinessPlan__Share> lstBPShare = new List<bupl__BusinessPlan__Share>();
		Final List<bupl__AP_Team__c> lstAPT = triggerNew.values();
		for(bupl__AP_Team__c apt:lstAPT) {
			if(String.isNotBlank(apt.acpl__gf_account_planning_id__c) && String.isNotBlank(apt.bupl__gf_business_plan_id__c) &&
			   String.isNotBlank(apt.bupl__gf_ap_team_user_id__c)) {
				lstAPTShare.add(new acpl__Account_Planning__Share(ParentId = apt.acpl__gf_account_planning_id__c, UserOrGroupId = apt.bupl__gf_ap_team_user_id__c,
				                                                  AccessLevel = 'Edit', RowCause = 'Manual'));
				lstBPShare.add(new bupl__BusinessPlan__Share(ParentId = apt.bupl__gf_business_plan_id__c, UserOrGroupId = apt.bupl__gf_ap_team_user_id__c,
				                                             AccessLevel = 'Edit', RowCause = 'Manual'));
			}
		}
		Final Integer lstAPTShareSize = lstAPTShare.size();
		Final Integer lstBPShareSize = lstBPShare.size();
		if(lstAPTShareSize > 0) {
			insertSharingAPT(lstAPTShare, lstAPT, isTrigger);
		}
		if(lstBPShareSize > 0) {
			insertSharingAPT(lstBPShare, lstAPT, isTrigger);
		}
	}

	/*
	 * @Description	Inserta compartimiento
	 */
	private static void insertSharingAPT(List<SObject> lstShare, List<bupl__AP_Team__c> lstAPT, Boolean isTrigger) {
		fINAL Database.SaveResult[] result = Database.insert(lstShare, false);
		for(Integer i = 0; i < result.size(); i++) {
			if(result[i].isSuccess()) {
				System.debug('Sharing success on record with Id: ' + lstShare[i].get('ParentId'));
			} else if(isTrigger) {
				lstAPT[i].addError(result[i].getErrors()[0].getStatusCode() + ' : ' + result[i].getErrors()[0].getMessage());
				System.debug(result[i].getErrors()[0].getStatusCode() + ' : ' + result[i].getErrors()[0].getMessage());
			} else {
				System.debug(result[i].getErrors()[0].getStatusCode() + ' : ' + result[i].getErrors()[0].getMessage());
			}
		}
	}
	//PROBAR CARGA DE APT DESACTIVADO Y DESACTIVAR Y VOLVER A ACTIVAR AÑADIENDO PERMISOS DE EDICION A LOS AP DONDE ES APT

	/*
	 * @Description  Elimina el compartimiento de registro cuando se elimina un APT
	 */
	public static void deleteSharing(Map<Id, bupl__AP_Team__c> triggerOldMap) {
		Final Set<Id> userIds = new Set<Id>();
		Final Map<Id, Set<Id>> groupAPTbyAP = new Map<Id, Set<Id>>();
		Final Map<Id, Set<Id>> groupAPTbyBP = new Map<Id, Set<Id>>();
		Set<Id> aptMembers;
		for(bupl__AP_Team__c apt:triggerOldMap.values()) {
			if(String.isNotBlank(apt.acpl__gf_account_planning_id__c) && String.isNotBlank(apt.bupl__gf_ap_team_user_id__c) &&
			   String.isNotBlank(apt.bupl__gf_business_plan_id__c)) {
				if(groupAPTbyAP.containsKey(apt.acpl__gf_account_planning_id__c) && groupAPTbyBP.containsKey(apt.bupl__gf_business_plan_id__c)) {
					aptMembers = groupAPTbyAP.get(apt.acpl__gf_account_planning_id__c);
					aptMembers.add(apt.bupl__gf_ap_team_user_id__c);
				} else {
					aptMembers = new Set<Id> {apt.bupl__gf_ap_team_user_id__c};
				}
				groupAPTbyAP.put(apt.acpl__gf_account_planning_id__c, aptMembers);
				groupAPTbyBP.put(apt.bupl__gf_business_plan_id__c, aptMembers);
				userIds.add(apt.bupl__gf_ap_team_user_id__c);
			}
		}
		deleteAPTSharing(userIds, groupAPTbyAP);
		deleteBPSharing(userIds, groupAPTbyBP);
	}

	/*
	 * @Description  Elimina el compartimiento de AP
	 */
	public static void deleteAPTSharing(Set<Id> userIds, Map<Id, Set<Id>> groupAPTbyAP) {
		Final List<acpl__Account_Planning__Share> aptShareDelete = new List<acpl__Account_Planning__Share>();
		for(acpl__Account_Planning__Share aptShare:[SELECT Id, parentId, UserOrGroupId FROM acpl__Account_Planning__Share WHERE parentId IN:groupAPTbyAP.keySet() AND
		                                            UserOrGroupId IN:userIds AND RowCause = 'Manual']) {
			if(groupAPTbyAP.containsKey(aptShare.parentId) && groupAPTbyAP.get(aptShare.parentId).contains(aptShare.UserOrGroupId)) {
				aptShareDelete.add(aptSHare);
			}
		}
		Final Integer aptSDSize = aptShareDelete.size();
		if(aptSDSize > 0) delete aptShareDelete;
	}

	/*
	 * @Description  Elimina el compartimiento de BP
	 */
	public static void deleteBPSharing(Set<Id> userIds, Map<Id, Set<Id>> groupAPTbyAP) {
		Final List<bupl__BusinessPlan__Share> aptShareDelete = new List<bupl__BusinessPlan__Share>();
		for(bupl__BusinessPlan__Share aptShare:[SELECT Id, parentId, UserOrGroupId FROM bupl__BusinessPlan__Share WHERE parentId IN:groupAPTbyAP.keySet() AND
		                                        UserOrGroupId IN:userIds AND RowCause = 'Manual']) {
			if(groupAPTbyAP.containsKey(aptShare.parentId) && groupAPTbyAP.get(aptShare.parentId).contains(aptShare.UserOrGroupId)) {
				aptShareDelete.add(aptSHare);
			}
		}
		Final Integer aptSDSize = aptShareDelete.size();
		if(aptSDSize > 0) delete aptShareDelete;
	}
}
