/*
 * @Name: User_Trigger_cls
 * @Description: Calss User Trigger de Ejecucion
 * @Create by: Jose Erasmo Rodriguez Paredes
 */
public without sharing class User_Trigger_cls {
	/*
	 *   @Variable: temporal
	 */
	final Map<String, Organizational_Unit_Equivalence__c> orgEquivalentMap = new Map<String, Organizational_Unit_Equivalence__c>();
	/*
	 *   @Variable: temporal
	 */
	final Map<String, User_Position_equivalence__c> positionEquivMap = new Map<String, User_Position_equivalence__c>();
	/*
	 *   @Variable: temporal
	 */
	private static final String PERFIL_MIGRACION {get {return 'Migracion';} set;}

	/*
	 * @Name: AsignBeforeInsert
	 * @Description: Invoca al metodo setEquivalentValues.
	 * @author Jose Rodriguez
	 */
	public void AsignBeforeInsert(List<User> userNew, Map<id, User> userNewMap) {
		setEquivalentValues(userNew);
	}

	/*
	 * @Name: AsignAfterInsert
	 * @Description: Invoca al metodo newMembersFormalization.
	 * @author Diego Carbajal
	 */
	public void AsignAfterInsert(List<User> userNew, Map<id, User> userNewMap, list<User> userOld, Map<id, User> userOldMap) {
		User_Trigger_Case_cls.newMembersFormalization(userNew);
		//Assigment AP Validation Permission
		Final Set<Id> userGOF = new Set<Id>();
		//Obtenemos los codigos de los usuarios que deben ser validadores
		Final List<String> lstVCodes = System.Label.AP_ValidatorsCode.split(',');
		for(User usuario:userNew) {
			if(lstVCodes.contains(usuario.prof_position_id__c)) {
				userGOF.add(usuario.Id);
			}
		}
        Final Integer userGSize = userGOF.size();
		if(userGSize > 0) {
			AssigmentPermissionValidationAP_cls.assigmentPermission(userGOF);
		}
	}
	/*
	 * @Name: AsignBeforeUpdate
	 * @Description: Invoca al metodo setEquivalentValues.
	 * @author Jose Rodriguez
	 */
	public void AsignBeforeUpdate(List<User> userNew, Map<id, User> userNewMap, list<User> userOld, Map<id, User> userOldMap) {
		setEquivalentValues(userNew);
	}

	/*
	 * @Name: AsignAfterUpdate
	 * @Description: Invoca a los metodos de la clase User_Trigger_Case_cls.
	 * updFormalizationDeactiveOwners
	 * changeRolAssis_Sgof
	 * addUserToFormalizationGroup
	 * @author Diego Carbajal
	 */
	public void AsignAfterUpdate(List<User> userNew, Map<id, User> userNewMap, list<User> userOld, Map<id, User> userOldMap) {
		User_Trigger_Case_cls.updFormalizationDeactiveOwners(userNewMap, userOldMap);
		User_Trigger_Case_cls.changeRolAssis_Sgof(userNewMap, userOld);
		User_Trigger_Case_cls.addUserToFormalizationGroup(userNewMap, userOld);
		BE_User_Trigger_VisitTeam_Cls.sharingVisitTeamMember(userNewMap, userOldMap);
	}

	public void assigmentPermission(Map<id, User> userOldMap, Map<id, User> userNewMap) {
		//Obtenemos los codigos de los usuarios que deben ser validadores
		Final List<String> lstVCodes = System.Label.AP_ValidatorsCode.split(',');
		Final Set<Id> userIds = new Set<Id>();
		Final Set<Id> userGOF = new Set<Id>();
		Final Set<Id> usersExGOF = new Set<Id>();
		for(User usuario:userOldMap.values()) {
			if(!usuario.isActive && userNewMap.get(usuario.Id).isActive) {
				userIds.add(usuario.Id);
			}
			if(lstVCodes.contains(userNewMap.get(usuario.Id).prof_position_id__c)) {
				userGOF.add(usuario.Id);
			}
			if(usuario.prof_position_id__c != userNewMap.get(usuario.Id).prof_position_id__c &&
			   lstVCodes.contains(usuario.prof_position_id__c)) {
				usersExGOF.add(usuario.Id);
			}
		}
		if(userIds.size() > 0) {
			User_APSharing_batch userAPShareBatch = new User_APSharing_batch(userIds);
			Database.executeBatch(userAPShareBatch);
		}
		if(userGOF.size() > 0) {
			AssigmentPermissionValidationAP_cls.assigmentPermission(userGOF);
		}
		if(usersExGOF.size() > 0) {
			AssigmentPermissionValidationAP_cls.deletePermission(usersExGOF);
		}
	}
	/*
	 * @Name: setEquivalentValues
	 * @Description: Ejecuta la logica para la asignacion de unidad organizativa y cargo equivalente de un usuario.
	 * @author Jose Rodriguez.
	 */
	public void setEquivalentValues(List<User> userNew) {
		if(PERFIL_MIGRACION.equals([select Name from profile where Id = : Userinfo.getProfileId() limit 1].Name)) {
			List<Organizational_Unit_Equivalence__c>  orgEquivalent =  new List<Organizational_Unit_Equivalence__c>();
			List<User_Position_equivalence__c>  userPosEquiv =  new List<User_Position_equivalence__c>();
			orgEquivalent = [select Organizational_unit__c, Organizational_unit_code__c, Organizational_unit_code_equivalence__c, Organizational_unit_equivalence__c from Organizational_Unit_Equivalence__c limit 200];
			userPosEquiv = [select Organizational_unit__c, Organizational_unit_code__c, User_position__c, User_position_code__c, User_position_equivalence__c from User_Position_equivalence__c limit 200];

			for(Organizational_Unit_Equivalence__c o:orgEquivalent) {
				orgEquivalentMap.put(o.Organizational_unit__c + o.Organizational_unit_code__c, o);
			}
			System.debug('orgEquivalentMap:  ' + orgEquivalentMap);
			for(User_Position_equivalence__c p:userPosEquiv) {
				positionEquivMap.put(p.Organizational_unit__c + p.Organizational_unit_code__c + p.User_position__c, p);
			}
			System.debug('positionEquivMap: ' + positionEquivMap);
			for(User u : userNew) {
				if(orgEquivalentMap.get(u.organizational_unit_name__c + u.organizational_unit_id__c) == null) {
					u.Organizational_unit_code_equivalence__c = u.organizational_unit_id__c;
					u.Organizational_unit_equivalence__c = u.organizational_unit_name__c;
				} else {
					u.Organizational_unit_code_equivalence__c = orgEquivalentMap.get(u.organizational_unit_name__c + u.organizational_unit_id__c).Organizational_unit_code_equivalence__c;
					u.Organizational_unit_equivalence__c = orgEquivalentMap.get(u.organizational_unit_name__c + u.organizational_unit_id__c).Organizational_unit_equivalence__c;
				}
				if(positionEquivMap.get(u.organizational_unit_name__c + u.organizational_unit_id__c + u.prof_position_type__c) == null) {
					u.User_position_equivalence__c = u.prof_position_type__c;
				} else {
					u.User_position_equivalence__c = positionEquivMap.get(u.organizational_unit_name__c + u.organizational_unit_id__c + u.prof_position_type__c).User_position_equivalence__c;
				}
				System.debug('Cambios aplicados: unidad: ' + u.Organizational_unit_equivalence__c + ' posicion ' + u.User_position_equivalence__c);
			}
		}
	}
}
