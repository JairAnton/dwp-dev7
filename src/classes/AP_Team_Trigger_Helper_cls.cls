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
public class AP_Team_Trigger_Helper_cls {

    /** @Description  GESTOR*/
    private static Final String GESTOR = 'Gestor del Plan';
    /*
	 * @Description  AP_Team_Trigger_Helper_cls
	 */
    private AP_Team_Trigger_Helper_cls() {}

    /*
	 * @Description  Valida que se tenga permisos para modificar/eliminar un APT
	 */
	public static void validateUserPermission(acpl__Account_Planning__c[] lstAP, Map<Id, List<bupl__AP_Team__c>> mapAPTs, String actionType) {
		Final BE_AP_Permission_helper apAdministration = new BE_AP_Permission_helper(UserInfo.getUserId());
		Final Map<String, String> mapConfig = new Map<String, String> {'sobjectType' => 'bupl__AP_Team__c', 'actionType' => actionType};
		apAdministration.permissionOnRelatedRecords(lstAP, mapAPTs, mapConfig);
	}
    
    /*
	 * @Description  Si el usuario que esta agregando un nuevo gestor no es administrador o el gestor principal del AP
	 */
	public static void putErrorInvalidGestor(Map<Id, Set<Id>> mapAptUserIds, bupl__AP_Team__c apt, Boolean adminUser) {
		if((!adminUser && !mapAptUserIds.containsKey(apt.acpl__gf_account_planning_id__c) && apt.bupl__gf_ap_team_role_user_name__c == GESTOR) ||
		   (!adminUser && apt.bupl__gf_ap_team_role_user_name__c == GESTOR && mapAptUserIds.containsKey(apt.acpl__gf_account_planning_id__c) &&
		    !(mapAptUserIds.get(apt.acpl__gf_account_planning_id__c).contains(UserInfo.getUserId())))) {
			apt.addError(System.Label.AP_UserCantAddGestor);
		}
	}
    
    /*
	 * @Description  Si se intenta agregar un APT ya existente
	 */
	public static void putErrorMemberInAPT(Map<Id, Set<Id>> mapAPTInAP, bupl__AP_Team__c apt) {
		if(mapAPTInAP.containsKey(apt.acpl__gf_account_planning_id__c) && mapAPTInAP.get(apt.acpl__gf_account_planning_id__c).contains(apt.bupl__gf_ap_team_user_id__c)) {
			apt.addError(System.Label.AP_CantAddExistingUser);
		}
	}
    
    /*
	 * @Description  Si el usuario esta agregando un nuevo miembro y no es administrador o gestor del AP
	 */
	public static void putErrorInvalidUser(Map<Id, Set<Id>> mapAptUserIds, bupl__AP_Team__c apt, Boolean adminUser) {
		if((!adminUser && !mapAptUserIds.containsKey(apt.acpl__gf_account_planning_id__c)) ||
		   (!adminUser && mapAptUserIds.containsKey(apt.acpl__gf_account_planning_id__c) &&
		    !(mapAptUserIds.get(apt.acpl__gf_account_planning_id__c).contains(UserInfo.getUserId())))) {
			apt.addError(System.Label.AP_OnlyGestorAddMembers);
		}
	}
    
    /*
	 * @Description  Si el usuario que no es gestor principal intenta eliminar otros gestores
	 */
	public static void putErrorDeleteGestor(Map<Id, Set<Id>> mapAptMainGestorUser, bupl__AP_Team__c apt, Boolean adminUser) {
		if((!adminUser && !mapAptMainGestorUser.containsKey(apt.acpl__gf_account_planning_id__c)) ||
		   (!adminUser && mapAptMainGestorUser.containsKey(apt.acpl__gf_account_planning_id__c) &&
		    !mapAptMainGestorUser.get(apt.acpl__gf_account_planning_id__c).contains(UserInfo.getUserId()) &&
		    apt.bupl__gf_ap_team_role_user_name__c == GESTOR)) {
			apt.addError(System.Label.AP_MainGestorAddGestors);
		}
	}
    
    /*
	 * @Description  Si el usuario intenta eliminar un APT que tiene asignado como suyo
	 */
	public static void putErrorDeleteOwnAPT(bupl__AP_Team__c apt, Boolean adminUser) {
		if(apt.bupl__gf_ap_team_user_id__c == UserInfo.getUserId() && !adminUser) {
			apt.addError(System.Label.AP_CantDeleteItSelfAPT);
		}
	}
    
    /*
	 * @Description  Si el usuario que no es gestor intenta eliminar un APT
	 */
	public static void putErrorDeleteAPT(Map<Id, Set<Id>> mapAptUserIds, bupl__AP_Team__c apt, Boolean adminUser) {
		if((!adminUser && !mapAptUserIds.containsKey(apt.acpl__gf_account_planning_id__c)) ||
		   (!adminUser && mapAptUserIds.containsKey(apt.acpl__gf_account_planning_id__c) &&
		    !mapAptUserIds.get(apt.acpl__gf_account_planning_id__c).contains(UserInfo.getUserId()))) {
			apt.addError(System.Label.AP_OnlyGestorsDeleteMembers);
		}
	}
}