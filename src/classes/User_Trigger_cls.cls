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
	 * @Name: asignBeforeInsert
	 * @Description: call to method setEquivalentValues.
	 * @author Jose Rodriguez
	 */
	public void asignBeforeInsert(List<User> userNew, Map<id, User> userNewMap) {
		setEquivalentValues(userNew);
	}

	/*
	 * @Name: asignAfterInsert
	 * @Description: call to method newMembersFormalization.
	 * @author Diego Carbajal
	 */
	public void asignAfterInsert(List<User> userNew, Map<id, User> userNewMap, list<User> userOld, Map<id, User> userOldMap) {
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
	 * @Name: asignBeforeUpdate
	 * @Description: call to method setEquivalentValues.
	 * @author Jose Rodriguez
	 */
	public void asignBeforeUpdate(List<User> userNew, Map<id, User> userNewMap, list<User> userOld, Map<id, User> userOldMap) {
		setEquivalentValues(userNew);
	}

	/*
	 * @Name: asignAfterUpdate
	 * @Description: call to methods to User_Trigger_Case_cls class.
	 * updFormalizationDeactiveOwners
	 * changeRolAssis_Sgof
	 * addUserToFormalizationGroup
	 * @author Diego Carbajal
	 */
	public void asignAfterUpdate(List<User> userNew, Map<id, User> userNewMap, list<User> userOld, Map<id, User> userOldMap) {
		User_Trigger_Case_cls.updFormalizationDeactiveOwners(userNewMap, userOldMap);
		User_Trigger_Case_cls.changeRolAssis_Sgof(userNewMap, userOld);
		User_Trigger_Case_cls.addUserToFormalizationGroup(userNewMap, userOld);
		BE_User_Trigger_VisitTeam_Cls.sharingVisitTeamMember(userNewMap, userOldMap);
	}
    
    /*
	 * @Name: assigmentPermission
	 * @Description: call to method used for assigment permission to AP
	 * @author 
	 */
    public void assigmentPermission(Map<id, User> userOldMap, Map<id, User> userNewMap) {
		Set<Id> userIds = new Set<Id>();
		Set<Id> userGOF = new Set<Id>();
		Set<Id> usersExGOF = new Set<Id>();
		for(User usuario : userOldMap.values()) {
            userIds = getUserIds(1, usuario, userNewMap, userIds);
            userGOF = getUserIds(2, usuario, userNewMap, userGOF);
            usersExGOF = getUserIds(3, usuario, userNewMap, usersExGOF);
		}
		if(!userIds.isEmpty()) {
			Final User_APSharing_batch userAPShareBatch = new User_APSharing_batch(userIds);
			Database.executeBatch(userAPShareBatch);
		}
		if(!userGOF.isEmpty()) {
			AssigmentPermissionValidationAP_cls.assigmentPermission(userGOF);
		}
		if(!usersExGOF.isEmpty()) {
			AssigmentPermissionValidationAP_cls.deletePermission(usersExGOF);
		}
	}
    
    /*
	 * @Name: getUserIds
	 * @Description: get users ids valids
	 * @author Martin Mori
	 */
    public Set<Id> getUserIds(Integer option, User usuario, Map<id, User> userNewMap, Set<Id> setIds) {
		//Obtenemos los codigos de los usuarios que deben ser validadores
		Final List<String> lstVCodes = System.Label.AP_ValidatorsCode.split(',');
        switch on option {
            when 1 {
                if(!usuario.isActive && userNewMap.get(usuario.Id).isActive) {
                    setIds.add(usuario.Id);
                }
            }
            when 2 {
                if(lstVCodes.contains(userNewMap.get(usuario.Id).prof_position_id__c)) {
                    setIds.add(usuario.Id);
                }
            }
            when 3 {
                if(usuario.prof_position_id__c != userNewMap.get(usuario.Id).prof_position_id__c &&
                   lstVCodes.contains(usuario.prof_position_id__c)) {
                    setIds.add(usuario.Id);
                }
            }
        }
        return setIds;
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