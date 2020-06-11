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
			if(!(actionType == 'delete' && String.isBlank(apt.bupl__gf_business_plan_id__c))) {
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
					validateUserPermission(lstAP, mapAPTs, 'insert');
					CheckAPT(newAPTs, mapAPTs.keySet(), actionType);
				}
				when 'update' {
					validateUserPermission(lstAP, mapAPTs, 'update');
				}
				when 'delete' {
					validateUserPermission(lstAP, mapAPTs, 'delete');
					CheckAPT(newAPTs, mapAPTs.keySet(), actionType);
				}
			}
		}
	}

	/*
	 * @Description  Valida que se tenga permisos para modificar/eliminar un APT
	 */
	public static void validateUserPermission(acpl__Account_Planning__c[] lstAP, Map<Id, List<bupl__AP_Team__c>> mapAPTs, String actionType) {
		Final BE_AP_Permission_helper apAdministration = new BE_AP_Permission_helper(UserInfo.getUserId());
		Final Map<String, String> mapConfig = new Map<String, String> {'sobjectType' => 'bupl__AP_Team__c', 'actionType' => actionType};
		apAdministration.permissionOnRelatedRecords(lstAP, mapAPTs, mapConfig);
	}

	/*
	 * @Description  Realiza validaciones:
	 *	- Si se agrega un nuevo gestor, solo puede ser agregado por un administrador o gestor principal del AP
	 *	- No permite agregar un mismo usuario mas de una vez
	 */
	public static void CheckAPT(bupl__AP_Team__c[] newAPTs, Set<Id> idsAP, String actionType) {
		//Guarda los APT relacionados al AP
		Map<Id, Set<Id>> mapAPTInAP = new Map<Id, Set<Id>>();
		//Guarda los gestores principales de los APT relacionados al AP
		Map<Id, Set<Id>> mapAptMainGestorUser = new Map<Id, Set<Id>>();
		//Guarda los usuarios gestores de los APT relacionados al AP
		Map<Id, Set<Id>> mapAptGestores = new Map<Id, Set<Id>>();
		Set<Id> idsAux;
		for(bupl__AP_Team__c apt: [SELECT Id, acpl__gf_account_planning_id__c, account_planning_Owner__c, bupl__gf_ap_team_user_id__c,
		                           bupl__gf_ap_team_role_user_name__c FROM bupl__AP_Team__c WHERE acpl__gf_account_planning_id__c IN:idsAP]) {
			switch on actionType {
				when 'insert' {
					mapAPTInAP = checkAPTsInAP(apt, mapAPTInAP, idsAux);
					mapAptMainGestorUser = checkMainGestor(apt, mapAptMainGestorUser, idsAux);
					mapAptGestores = getGestores(mapAptGestores, apt, idsAux);
				}
				when 'delete' {
					mapAptMainGestorUser = checkMainGestor(apt, mapAptMainGestorUser, idsAux);
					mapAptGestores = getGestores(mapAptGestores, apt, idsAux);
				}
			}
		}
		//Validamos si el usuario en el contexto de ejecución es administrador
		Final BE_AP_Permission_helper permission = new BE_AP_Permission_helper(UserInfo.getUserId());
		Boolean adminUser = permission.adminPermission();
		//Administrador del sistema o administrador del AP
		adminUser = adminUser || permission.permissionOnAPT('insert');
		for(bupl__AP_Team__c apt:newAPTs) {
			switch on actionType {
				when 'insert' {
					putErrorInvalidGestor(mapAptMainGestorUser, apt, adminUser);
					putErrorMemberInAPT(mapAPTInAP, apt);
					putErrorInvalidUser(mapAptGestores, apt, adminUser);
				}
				when 'delete' {
					putErrorDeleteGestor(mapAptMainGestorUser, apt, adminUser);
					putErrorDeleteOwnAPT(apt, adminUser);
					putErrorDeleteAPT(mapAptGestores, apt, adminUser);
				}
			}
		}
	}

	/*
	 * @Description  Obtiene los APT asociados al AP
	 */
	public static Map<Id, Set<Id>> checkAPTsInAP(bupl__AP_Team__c apt, Map<Id, Set<Id>> mapAPTInAP, Set<Id> idsAux) {
		idsAux = new Set<Id> {apt.bupl__gf_ap_team_user_id__c};
		if(mapAPTInAP.containsKey(apt.acpl__gf_account_planning_id__c)) {
			idsAux.addAll(mapAPTInAP.get(apt.acpl__gf_account_planning_id__c));
		}
		mapAPTInAP.put(apt.acpl__gf_account_planning_id__c, idsAux);
		return mapAPTInAP;
	}

	/*
	 * @Description  Obtiene al gestor principal del AP
	 */
	public static Map<Id, Set<Id>> checkMainGestor(bupl__AP_Team__c apt, Map<Id, Set<Id>> mapAptMainGestorUser, Set<Id> idsAux) {
		if(String.isNotBlank(apt.bupl__gf_ap_team_user_id__c) && apt.account_planning_Owner__c) {
			idsAux = new Set<Id> {apt.bupl__gf_ap_team_user_id__c};
			if(mapAptMainGestorUser.containsKey(apt.acpl__gf_account_planning_id__c)) {
				idsAux.addAll(mapAptMainGestorUser.get(apt.acpl__gf_account_planning_id__c));
			}
			mapAptMainGestorUser.put(apt.acpl__gf_account_planning_id__c, idsAux);
		}
		return mapAptMainGestorUser;
	}

	/*
	 * @Description  Obtiene los gestores del AP
	 */
	public static Map<Id, Set<Id>> getGestores(Map<Id, Set<Id>> mapAptGestores, bupl__AP_Team__c apt, Set<Id> idsAux) {
		if(apt.bupl__gf_ap_team_role_user_name__c == 'Gestor del Plan') {
			idsAux = new Set<Id> {apt.bupl__gf_ap_team_user_id__c};
			if(mapAptGestores.containsKey(apt.acpl__gf_account_planning_id__c)) {
				idsAux.addAll(mapAptGestores.get(apt.acpl__gf_account_planning_id__c));
			}
			mapAptGestores.put(apt.acpl__gf_account_planning_id__c, idsAux);
		}
		return mapAptGestores;
	}

	/*
	 * @Description  Si el usuario esta agregando un nuevo miembro y no es administrador o gestor del AP
	 */
	public static void putErrorInvalidUser(Map<Id, Set<Id>> mapAptUserIds, bupl__AP_Team__c apt, Boolean adminUser) {
		if((!adminUser && !mapAptUserIds.containsKey(apt.acpl__gf_account_planning_id__c)) ||
		   (!adminUser && mapAptUserIds.containsKey(apt.acpl__gf_account_planning_id__c) &&
		    !(mapAptUserIds.get(apt.acpl__gf_account_planning_id__c).contains(UserInfo.getUserId())))) {
			apt.addError('Solo los gestores pueden agregar miembros al equipo.');
		}
	}

	/*
	 * @Description  Si se intenta agregar un APT ya existente
	 */
	public static void putErrorMemberInAPT(Map<Id, Set<Id>> mapAPTInAP, bupl__AP_Team__c apt) {
		if(mapAPTInAP.containsKey(apt.acpl__gf_account_planning_id__c) && mapAPTInAP.get(apt.acpl__gf_account_planning_id__c).contains(apt.bupl__gf_ap_team_user_id__c)) {
			apt.addError('No puede agregar a un miembro ya existente en el equipo.');
		}
	}

	/*
	 * @Description  Si el usuario que esta agregando un nuevo gestor no es administrador o el gestor principal del AP
	 */
	public static void putErrorInvalidGestor(Map<Id, Set<Id>> mapAptUserIds, bupl__AP_Team__c apt, Boolean adminUser) {
		if((!adminUser && !mapAptUserIds.containsKey(apt.acpl__gf_account_planning_id__c) && apt.bupl__gf_ap_team_role_user_name__c == 'Gestor del Plan') ||
		   (!adminUser && apt.bupl__gf_ap_team_role_user_name__c == 'Gestor del Plan' &&
		    mapAptUserIds.containsKey(apt.acpl__gf_account_planning_id__c) &&
		    !(mapAptUserIds.get(apt.acpl__gf_account_planning_id__c).contains(UserInfo.getUserId())))) {
			apt.addError('Solo el gestor principal puede asignar otro gestor al plan de cuenta.');
		}
	}

	/*
	 * @Description  Si el usuario intenta eliminar un APT que tiene asignado como suyo
	 */
	public static void putErrorDeleteOwnAPT(bupl__AP_Team__c apt, Boolean adminUser) {
		if(apt.bupl__gf_ap_team_user_id__c == UserInfo.getUserId() && !adminUser) {
			apt.addError('No puede eliminar su propio registro como miembro.');
		}
	}

	/*
	 * @Description  Si el usuario que no es gestor intenta eliminar un APT
	 */
	public static void putErrorDeleteAPT(Map<Id, Set<Id>> mapAptUserIds, bupl__AP_Team__c apt, Boolean adminUser) {
		if((!adminUser && !mapAptUserIds.containsKey(apt.acpl__gf_account_planning_id__c)) ||
		   (!adminUser && mapAptUserIds.containsKey(apt.acpl__gf_account_planning_id__c) &&
		    !mapAptUserIds.get(apt.acpl__gf_account_planning_id__c).contains(UserInfo.getUserId()))) {
			apt.addError('Solo los gestores pueden eliminar miembros en el equipo.');
		}
	}

    /*
	 * @Description  Si el usuario que no es gestor principal intenta eliminar otros gestores
	 */
	public static void putErrorDeleteGestor(Map<Id, Set<Id>> mapAptMainGestorUser, bupl__AP_Team__c apt, Boolean adminUser) {
		if((!adminUser && !mapAptMainGestorUser.containsKey(apt.acpl__gf_account_planning_id__c)) ||
		   (!adminUser && mapAptMainGestorUser.containsKey(apt.acpl__gf_account_planning_id__c) &&
		    !mapAptMainGestorUser.get(apt.acpl__gf_account_planning_id__c).contains(UserInfo.getUserId()) &&
		    apt.bupl__gf_ap_team_role_user_name__c == 'Gestor del Plan')) {
			apt.addError('Solo el gestor principal puede eliminar otros gestores.');
		}
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
			Boolean userInAPT = (mapAPTs.get(ap.Id) == null ? false : mapAPTs.get(ap.Id).contains(UserInfo.getUserId()));
			if(userInAPT && ap.acpl__gf_ap_status_type_name__c == 'Not started' && ap.acpl__gf_ap_substatus_type_name__c != Label.acpl.AP_Timed_Out) {
				ap.acpl__gf_ap_status_type_name__c = 'In Progress';
				ap.acpl__gf_ap_substatus_type_name__c = 'AP team not invited';
			}
		}
		Final Integer listAPtoUpdateSize = listAPtoUpdate.size();
		if(listAPtoUpdateSize > 0) {
			update listAPtoUpdate;
		}
	}
}