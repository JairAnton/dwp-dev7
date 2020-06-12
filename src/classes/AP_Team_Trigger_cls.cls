/**
 * Logic class of Handler Trigger of the AP_Team object.
 * <p /><p />
 * Modification log:<p />
 * -------------------------------------------------------------------
 * Developer                    Date                Description<p />
 * -------------------------------------------------------------------
 * Diego Carbajal    		15/05/2020          Original version.<p />
 *
 * @author Diego Carbajal
 */
public without sharing class AP_Team_Trigger_cls {
    
    /** @Description  W_INSERT*/
    private static Final String W_INSERT = 'insert';
    /** @Description  W_DELETE*/
    private static Final String W_DELETE = 'delete';
    /** @Description  GESTOR*/
    private static Final String GESTOR = 'Gestor del Plan';
    /*
	 * @Description  AP_Team_Trigger_cls
	 */
    private AP_Team_Trigger_cls() {}
	/*
	 * @Description  Llena datos en los campos antes de insertarse
	 */
	public static void putValuesAPT(bupl__AP_Team__c[] newAPTs) {
		Final Map<Id, User> mapUser = new Map<Id, User>([SELECT Id, Name, LastName FROM User LIMIT 2000]);
		for(bupl__AP_Team__c apt:newAPTs) {
			//Completa el campo Name del APT
			if(String.isNotBlank(apt.bupl__gf_ap_team_user_id__c)) {
				apt.Name = mapUser.get(apt.bupl__gf_ap_team_user_id__c).Name;
			}
		}
	}
	/*
	 * @Description  Recorre los APT y ejecutida diversos metodos de acuerdo al tipo de DML y filtros de APT
	 */
	public static void beforeDML(bupl__AP_Team__c[] newAPTs, String actionType) {
		Final Map<Id, List<bupl__AP_Team__c>> mapAPTs = new Map<Id, List<bupl__AP_Team__c>>();
		List<bupl__AP_Team__c> aptAux;
		for(bupl__AP_Team__c apt:newAPTs) {
			//Si la eliminación es independiente, es decir, no es eliminado cuando se elimina el AP principal
			if(!(actionType == W_DELETE && String.isBlank(apt.bupl__gf_business_plan_id__c))) {
				aptAux = new List<bupl__AP_Team__c> {apt};
				if(mapAPTs.containsKey(apt.acpl__gf_account_planning_id__c)) {
					aptAux.addAll(mapAPTs.get(apt.acpl__gf_account_planning_id__c));
				}
				mapAPTs.put(apt.acpl__gf_account_planning_id__c, aptAux);
			}
		}
		Final acpl__Account_Planning__c[] lstAP = [SELECT Id, acpl__gf_ap_indvi_lock_edit_ind_type__c, acpl__gf_ap_status_type_name__c, acpl__gf_ap_substatus_type_name__c
		                                           FROM acpl__Account_Planning__c WHERE Id IN:mapAPTs.keySet() AND recordType.DeveloperName = 'Account_Planning'];
		Final Integer lstAPSize = lstAP.size();
		if(lstAPSize > 0) {
			switch on actionType {
				when 'insert' {
					AP_Team_Trigger_Helper_cls.validateUserPermission(lstAP, mapAPTs, W_INSERT);
					checkAPT(newAPTs, mapAPTs.keySet(), actionType);
				}
				when 'update' {
					AP_Team_Trigger_Helper_cls.validateUserPermission(lstAP, mapAPTs, 'update');
				}
				when 'delete' {
					AP_Team_Trigger_Helper_cls.validateUserPermission(lstAP, mapAPTs, W_DELETE);
					checkAPT(newAPTs, mapAPTs.keySet(), actionType);
				}
			}
		}
	}

	/*
	 * @Description  Realiza validaciones:
	 *	- Si se agrega un nuevo gestor, solo puede ser agregado por un administrador o gestor principal del AP
	 *	- No permite agregar un mismo usuario mas de una vez
	 */
	public static void checkAPT(bupl__AP_Team__c[] newAPTs, Set<Id> idsAP, String actionType) {
		//Guarda los APT relacionados al AP
		Map<Id, Set<Id>> mapAPTInAP = new Map<Id, Set<Id>>();
		//Guarda los gestores principales de los APT relacionados al AP
		Map<Id, Set<Id>> mapAptMainGestor = new Map<Id, Set<Id>>();
		//Guarda los usuarios gestores de los APT relacionados al AP
		Map<Id, Set<Id>> mapAptGestores = new Map<Id, Set<Id>>();
		for(bupl__AP_Team__c apt: [SELECT Id, acpl__gf_account_planning_id__c, account_planning_Owner__c, bupl__gf_ap_team_user_id__c,
		                           bupl__gf_ap_team_role_user_name__c FROM bupl__AP_Team__c WHERE acpl__gf_account_planning_id__c IN:idsAP]) {
			switch on actionType {
				when 'insert' {
					mapAPTInAP = checkAPTsInAP(apt, mapAPTInAP);
					mapAptMainGestor = checkMainGestor(apt, mapAptMainGestor);
					mapAptGestores = getGestores(mapAptGestores, apt);
				}
				when 'delete' {
					mapAptMainGestor = checkMainGestor(apt, mapAptMainGestor);
					mapAptGestores = getGestores(mapAptGestores, apt);
				}
			}
		}
		//Validamos si el usuario en el contexto de ejecución es administrador
		Final BE_AP_Permission_helper permission = new BE_AP_Permission_helper(UserInfo.getUserId());
		Boolean adminUser = permission.adminPermission();
		//Administrador del sistema o administrador del AP
		adminUser = adminUser || permission.permissionOnAPT(W_INSERT);
		for(bupl__AP_Team__c apt:newAPTs) {
			switch on actionType {
				when 'insert' {
					AP_Team_Trigger_Helper_cls.putErrorInvalidGestor(mapAptMainGestor, apt, adminUser);
					AP_Team_Trigger_Helper_cls.putErrorMemberInAPT(mapAPTInAP, apt);
					AP_Team_Trigger_Helper_cls.putErrorInvalidUser(mapAptGestores, apt, adminUser);
				}
				when 'delete' {
					AP_Team_Trigger_Helper_cls.putErrorDeleteGestor(mapAptMainGestor, apt, adminUser);
					AP_Team_Trigger_Helper_cls.putErrorDeleteOwnAPT(apt, adminUser);
					AP_Team_Trigger_Helper_cls.putErrorDeleteAPT(mapAptGestores, apt, adminUser);
				}
			}
		}
	}

	/*
	 * @Description  Obtiene los APT asociados al AP
	 */
	public static Map<Id, Set<Id>> checkAPTsInAP(bupl__AP_Team__c apt, Map<Id, Set<Id>> mapAPTInAP) {
        Final Set<Id> idsAux = new Set<Id> {apt.bupl__gf_ap_team_user_id__c};
		if(mapAPTInAP.containsKey(apt.acpl__gf_account_planning_id__c)) {
			idsAux.addAll(mapAPTInAP.get(apt.acpl__gf_account_planning_id__c));
		}
		mapAPTInAP.put(apt.acpl__gf_account_planning_id__c, idsAux);
		return mapAPTInAP;
	}

	/*
	 * @Description  Obtiene al gestor principal del AP
	 */
	public static Map<Id, Set<Id>> checkMainGestor(bupl__AP_Team__c apt, Map<Id, Set<Id>> mapAptMainGestor) {
		if(String.isNotBlank(apt.bupl__gf_ap_team_user_id__c) && apt.account_planning_Owner__c) {
            Final Set<Id> idsAux = new Set<Id> {apt.bupl__gf_ap_team_user_id__c};
			if(mapAptMainGestor.containsKey(apt.acpl__gf_account_planning_id__c)) {
				idsAux.addAll(mapAptMainGestor.get(apt.acpl__gf_account_planning_id__c));
			}
			mapAptMainGestor.put(apt.acpl__gf_account_planning_id__c, idsAux);
		}
		return mapAptMainGestor;
	}

	/*
	 * @Description  Obtiene los gestores del AP
	 */
	public static Map<Id, Set<Id>> getGestores(Map<Id, Set<Id>> mapAptGestores, bupl__AP_Team__c apt) {
		if(apt.bupl__gf_ap_team_role_user_name__c == GESTOR) {
			Final Set<Id> idsAux = new Set<Id> {apt.bupl__gf_ap_team_user_id__c};
			if(mapAptGestores.containsKey(apt.acpl__gf_account_planning_id__c)) {
				idsAux.addAll(mapAptGestores.get(apt.acpl__gf_account_planning_id__c));
			}
			mapAptGestores.put(apt.acpl__gf_account_planning_id__c, idsAux);
		}
		return mapAptGestores;
	}
    
	/*
	 * @author       Global Desktop - local modify
	 * @Description  Check if AP Team Member has been added and propagates this change on Status field in related AP.
	 */
	public static void updateStatusOnAP(Map<Id, bupl__AP_Team__c> triggerNewMap) {
		Final Set<Id> apIds = new Set<Id>();
		for(bupl__AP_Team__c apt:triggerNewMap.values()) {
			apIds.add(apt.acpl__gf_account_planning_id__c);
		}
		Final BE_AP_Permission_helper permission = new BE_AP_Permission_helper(UserInfo.getUserId());
		Final Map<Id, Set<Id>> mapAPTs = permission.getAPTs(apIds);
		Final list<acpl__Account_Planning__c> listAPtoUpdate = [SELECT Id, acpl__gf_ap_status_type_name__c, acpl__gf_ap_substatus_type_name__c FROM acpl__Account_Planning__c
		                                                        WHERE Id IN :apIds AND acpl__gf_ap_status_type_name__c = 'Not started'];
		for(acpl__Account_Planning__c ap : listAPtoUpdate) {
			Final Boolean userInAPT = (mapAPTs.get(ap.Id) == null ? false : mapAPTs.get(ap.Id).contains(UserInfo.getUserId()));
			if(userInAPT && ap.acpl__gf_ap_status_type_name__c == 'Not started' && ap.acpl__gf_ap_substatus_type_name__c != Label.acpl.AP_Timed_Out) {
				ap.acpl__gf_ap_status_type_name__c = 'In Progress';
				ap.acpl__gf_ap_substatus_type_name__c = 'AP team not invited';
			}
		}
		Final Integer listAPUpdSize = listAPtoUpdate.size();
		if(listAPUpdSize > 0) {
			update listAPtoUpdate;
		}
	}
}