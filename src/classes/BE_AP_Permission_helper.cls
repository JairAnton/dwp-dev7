/*** BE_AP_Permission_helper helper class for validation AP
 * Developer                    Date                Description<p />
 * -------------------------------------------------------------------
 * Diego Carbajal    		07/05/2020          Original version.<p />
 * Jair Anton				19/08/2021			Omitir validación para reabrir AP
 * @author Diego Carbajal
 */
@SuppressWarnings('all')
public with sharing class BE_AP_Permission_helper {
    
    /** @Description R_NAME*/
    private static Final String R_NAME = 'recordName';
    /** @Description V_PERMISSION*/
    private static Final String V_PERMISSION = 'permission';
	/*
	 * @Description  variable usuario
	 */
	public User usuario {get; set;}
	/*
	 * @Description  variable csAPA
	 */
	public AccountPlanning_Administration__c csAPA {get; set;}

	/*
	 * @Description  constructor BE_AP_Permission_helper
	 */
	public BE_AP_Permission_helper(Id userId) {
		this.usuario = [SELECT Id, Name, isActive, profileId, profile.Name FROM User WHERE Id =:userId LIMIT 1];
		this.csAPA = AccountPlanning_Administration__c.getInstance(usuario.Id);
	}

	/*
	 * @Description  method permissionOnNeed
	 */
	public Boolean permissionOnNeed(String type) {
		Boolean permission;
		if(csAPA != null) {
			switch on type {
				when 'insert' {
					permission = csAPA.Create_Need__c;
				}
				when 'update' {
					permission = csAPA.Edit_Need__c;
				}
				when 'delete' {
					permission = csAPA.Delete_Need__c;
				}
			}
		}
		return permission;
	}

	/*
	 * @Description  method permissionGrowthDriver
	 */
	public Boolean permissionGrowthDriver(String type) {
		Boolean permission;
		if(csAPA != null) {
			switch on type {
				when 'insert' {
					permission = csAPA.Create_Growth_Driver__c;
				}
				when 'update' {
					permission = csAPA.Edit_Growth_Driver__c;
				}
				when 'delete' {
					permission = csAPA.Delete_Growth_Driver__c;
				}
			}
		}
		return permission;
	}

	/*
	 * @Description  method permissionOnAPT
	 */
	public Boolean permissionOnAPT(String type) {
		Boolean permission;
		if(csAPA != null) {
			switch on type {
				when 'insert' {
					permission = csAPA.Create_Account_Planning_Team_Members__c;
				}
				when 'update' {
					permission = csAPA.Edit_Account_Planning_Team_Members__c;
				}
				when 'delete' {
					permission = csAPA.Delete_Account_Planning_Team_Members__c;
				}
			}
		}
		return permission;
	}

	/*
	 * @Description  method permissionOnAP
	 */
	public Boolean permissionOnAP(String type) {
		Boolean permission;
		if(csAPA != null) {
			switch on type {
				when 'update' {
					permission = csAPA.Edit_Account_Planning__c;
				}
				when 'delete' {
					permission = csAPA.Delete_Account_Planning__c;
				}
			}
		}
		return permission;
	}

	/*
	 * @Description  method permissionCPE
	 */
	public Boolean permissionCPE(String type) {
		Boolean permission;
		if(csAPA != null) {
			switch on type {
				when 'insert' {
					permission = csAPA.Create_Commercial_Plan__c;
				}
				when 'update' {
					permission = csAPA.Edit_Commercial_Plan__c;
				}
				when 'delete' {
					permission = csAPA.Delete_Commercial_Plan__c;
				}
			}
		}
		return permission;
	}

	/*
	 * @Description  method permissionBP
	 */
	public Boolean permissionBP(String type) {
		Boolean permission;
		if(csAPA != null) {
			switch on type {
				when 'update' {
					permission = csAPA.Edit_Business_Plan__c;
				}
				when 'delete' {
					permission = csAPA.Delete_Business_Plan__c;
				}
			}
		}
		return permission;
	}

	/*
	 * @Description  method permissionQuestions
	 */
	public Boolean permissionQuestions(String type) {
		Boolean permission;
		if(csAPA != null) {
			switch on type {
				when 'update' {
					permission = csAPA.Edit_Account_Planning_Questions__c;
				}
				when 'delete' {
					permission = csAPA.Delete_Account_Planning_Questions__c;
				}
			}
		}
		return permission;
	}

    /*
	 * @Description  method permissionStockHolder
	 */
	public Boolean permissionSH(String type) {
		Boolean permission;
		if(csAPA != null) {
			switch on type {
                when 'insert' {
					permission = csAPA.Create_StockHolder__c;
				}
				when 'update' {
					permission = csAPA.Edit_StockHolder__c;
				}
				when 'delete' {
					permission = csAPA.Delete_StockHolder__c;
				}
			}
		}
		return permission;
	}
    
	/*
	 * @Description  method adminPermission
	 */
	public Boolean adminPermission() {
		Final List<String> PROFILE_NAMES = new List<String> {'Migracion', System.Label.profAdministrator, 'System Administrator'};
		return PROFILE_NAMES.contains(usuario.profile.Name);
	}

	/*
	 * @Description  method getAPTs
	 */
	public Map<Id, Set<Id>> getAPTs(Set<Id> idsAPs) {
		Final Map<Id, Set<Id>> mapAPTs = new Map<Id, Set<Id>>();
		Set<Id> tmpIds;
		for(bupl__AP_Team__c apt:[SELECT Id, bupl__gf_ap_team_user_id__c, acpl__gf_account_planning_id__c FROM bupl__AP_Team__c WHERE acpl__gf_account_planning_id__c IN:idsAPs]) {
			tmpIds = new Set<Id> {apt.bupl__gf_ap_team_user_id__c};
			if(mapAPTs.containsKey(apt.acpl__gf_account_planning_id__c)) {
				tmpIds.addAll(mapAPTs.get(apt.acpl__gf_account_planning_id__c));
			}
			mapAPTs.put(apt.acpl__gf_account_planning_id__c, tmpIds);
		}
		return mapAPTs;
	}

	/*
	 * @Description  method permissionOnRelatedRecords
	 */
	public void permissionOnRelatedRecords(acpl__Account_Planning__c[] lstAP, Map<Id, List<SObject>> mapsObject, Map<String, String> mapConfig) {
		Final Boolean adminUser = adminPermission();
		Final String sobjType = mapConfig.get('sobjectType');
		Final String actionType = mapConfig.get('actionType');
		Final Map<Id, Set<Id>> mapAPTs = getAPTs(mapsObject.keySet());
		Final Map<String, Object> mapWorkOnSObj = workOnSObject(sobjType, actionType);
		Final Boolean workOnSObj = (Boolean) mapWorkOnSObj.get(V_PERMISSION);
		Final String recordName = (String) mapWorkOnSObj.get(R_NAME);
		for(acpl__Account_Planning__c apR:lstAP) {
			Final Map<String, Object> validateSobj = BE_AP_Administration_helper.validateStatus(apR);
			if((Boolean) validateSobj.get('validation') == false) { // validacion SONAR
				if(!(adminUser || workOnSObj)) {
					// commented for reopen account planning
					//BE_AP_Administration_helper.addErrorOnSobject(mapsObject.get(apR.Id), sobjType, BE_AP_Administration_helper.customMessage(actionType, recordName, (String)validateSobj.get('status')));
				}
			} else if(!(apR.acpl__gf_ap_indvi_lock_edit_ind_type__c)) {//validacion SONAR
				if(!(adminUser || workOnSObj)) {
					BE_AP_Administration_helper.addErrorOnSobject(mapsObject.get(apR.Id), sobjType, BE_AP_Administration_helper.customMessage(actionType, recordName, 'bloqueado.'));
				}
			} else {
				Final Boolean userInAPT = (mapAPTs.get(apR.Id) == null ? false : mapAPTs.get(apR.Id).contains(usuario.Id));
				if(!(adminUser || workOnSObj || userInAPT)) {
					BE_AP_Administration_helper.addErrorOnSobject(mapsObject.get(apR.Id), sobjType, BE_AP_Administration_helper.customMessage(actionType, recordName, 'que no tiene asignado.'));
				}
			}
		}
	}

	/*
	 * @Description  method readRecords
	 */
	public Map<String, Object> workOnSObject(String sobj, String actionType) {
		Final Map<String, Object> mapWRR = new Map<String, Object> {V_PERMISSION => false, R_NAME => 'objeto desconocido'};
		switch on sobj {
			when 'bupl__BP_Need__c' {
				mapWRR.put(V_PERMISSION, permissionOnNeed(actionType));
				mapWRR.put(R_NAME, 'necesidades');
			}
			when 'bupl__BP_GrowthDriver__c' {
				mapWRR.put(V_PERMISSION, permissionGrowthDriver(actionType));
				mapWRR.put(R_NAME, 'variables de crecimiento');
			}
			when 'acpl__Commercial_Plan_Event__c' {
				mapWRR.put(V_PERMISSION, permissionCPE(actionType));
				mapWRR.put(R_NAME, 'acciones comerciales');
			}
			when 'bupl__AP_Team__c' {
				mapWRR.put(V_PERMISSION, permissionOnAPT(actionType));
				mapWRR.put(R_NAME, 'miembros');
			}
			when 'acpl__Account_Planning__c' {
				mapWRR.put(V_PERMISSION, permissionOnAP(actionType));
				mapWRR.put(R_NAME, 'el registro');
			}
			when 'acpl__AP_Question__c' {
				mapWRR.put(V_PERMISSION, permissionQuestions(actionType));
				mapWRR.put(R_NAME, 'preguntas');
			}
			when 'bupl__BusinessPlan__c' {
				mapWRR.put(V_PERMISSION, permissionBP(actionType));
				mapWRR.put(R_NAME, 'plan de negocio');
			}
            when 'BE_StockHolder__c' {
				mapWRR.put(V_PERMISSION, permissionSH(actionType));
				mapWRR.put(R_NAME, 'fiadores');
			}
		}
		return mapWRR;
	}
}