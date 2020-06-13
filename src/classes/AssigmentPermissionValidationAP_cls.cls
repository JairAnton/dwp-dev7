/**
 * AssigmentPermissionValidationAP_cls assign Validator permission to GOF
 * <p /><p />
 * Modification log:<p />
 * -------------------------------------------------------------------
 * Developer                    Date                Description<p />
 * -------------------------------------------------------------------
 * Diego Carbajal    		03/06/2020          Original version.<p />
 *
 * @author Diego Carbajal
 */
global class AssigmentPermissionValidationAP_cls {
	/*
	 * @Description  method assigmentPermission
	 */
	@future
	public static void assigmentPermission(Set<ID> usersId) {
		Final List<PermissionSet> valPermission = [SELECT Id, Name FROM PermissionSet WHERE name = 'Account_Planning_Validation_Permission' LIMIT 1];
		Final Integer validateSize = valPermission.size();
		if(validateSize > 0) {
			Final List<PermissionSetAssignment> permissionSetList = new List<PermissionSetAssignment>();
			for(User gof : [SELECT Id, IsActive FROM User WHERE Id IN:usersId AND IsActive = true]) {
				final PermissionSetAssignment permSetAssig = new PermissionSetAssignment(PermissionSetId = valPermission[0].Id, AssigneeId = gof.Id);
				permissionSetList.add(permSetAssig);
			}
			try {
				upsert permissionSetList;
			} catch(Exception e) {
				system.debug('Error in assigment permission' + e.getMessage());
			}
		}
	}

	/*
	 * @Description  method deletePermission
	 */
	@future
	public static void deletePermission(Set<ID> usersId) {
		Final List<PermissionSet> valPermission = [SELECT Id, Name FROM PermissionSet WHERE name = 'Account_Planning_Validation_Permission' LIMIT 1];
		Final Integer validateSize = valPermission.size();
		if(validateSize > 0) {
			try {
				delete [SELECT Id FROM PermissionSetAssignment WHERE PermissionSetId = : valPermission[0].Id AND AssigneeId IN : usersId];
			} catch(Exception e) {
				system.debug('Error in delete permission' + e.getMessage());
			}
		}
	}
}