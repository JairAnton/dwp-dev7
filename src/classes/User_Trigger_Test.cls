/*
 * @Name: User_Trigger_Test
 * @Description: Trigger de Ejecucion User
 * @Create by: Jose Rodriguez
 *
   @Changes
   Date        Author   Email                  				Type
   2019-06-15  JERP     jose.rodriguez.paredes@bbva.com		Creation
   2020-06-04  MAMC     martin.mori.contractor@bbva.com		Update (add AsignAfterInsertTest, AsignAfterUpdateTest and setEquivalentValuesTest methods)
 */
@isTest(seeAllData = false)
private class User_Trigger_Test {
    /**   @Variable: STR_EJECUTIVO*/
	private static final String USER_NAME = 'usuario.salesforce';
    /**   @Variable: CODE_USER*/
    private static Final String CODE_USER = 'E01';
	/*static variable*/
	static List<User> users;
	/*
	 * @Name: static var
	 * @Description: obtiene lista de usuarios para test.
	 * @author Jose Rodriguez
	 */
	static { 
        users = new List<User>([SELECT Id, Name, unique_id__c, organizational_unit_id__c, organizational_unit_name__c, prof_position_type__c, isactive FROM User 
                                where isactive = true and profile.name in('Ejecutivo', 'Especialista', 'Operativo', 'Analista') limit 50]); 
    }

	/*Setup Data*/
	@TestSetup
	public static void setUp() {
		final List<String> sObjNames = new List<String> {'acpl__Account_Planning__c'};
		final Map<String, Schema.RecordTypeInfo> recordType = BE_General_Utils.getRecordTypeInfo(sObjNames);

		final User userOwner = TestFactory.createUser('userExecutiveOwner', 'Ejecutivo');
		final User userBranch = TestFactory.createUser('userExecutiveBranch', 'Ejecutivo');
		final Account acc = TestFactory.createAccount();

		final acpl__Account_Planning__c accPlan = new acpl__Account_Planning__c();
		accPlan.recordTypeId = recordType.get('Account_Planning').getRecordTypeId();
		accPlan.Name = 'Account_Planning Test';
		accPlan.acpl__gf_ap_indvi_lock_edit_ind_type__c = true;
		accPlan.acpl__gf_ap_limit_date__c = System.today().addDays(90);
		accPlan.acpl__gf_ap_status_type_name__c = 'Not started';
		accPlan.acpl__participant_id__c = acc.Id;
		accPlan.acpl__proposal_manager_id__c = userOwner.Id;
		insert accPlan;

		final bupl__BusinessPlan__c bussPlan = new bupl__BusinessPlan__c();
		bussPlan.Name = 'Plan de Negocio AP_RECORD_102';
		bussPlan.bupl__gf_ap_public_ind_type__c = false;
		bussPlan.bupl__gf_business_growth_rec_number__c = 1;
		bussPlan.bupl__status_type__c = 'Not started';
		bussPlan.acpl__gf_account_planning_id__c = accPlan.id;
		insert bussPlan;

		final bupl__AP_Team__c apTeam = new bupl__AP_Team__c();
		apTeam.Name = 'BRUNELLA MARIA MELLO CROSBY MELLO CROSBY';
		apTeam.bupl__gf_ap_team_role_user_name__c = 'Gestor del Plan';
		apTeam.bupl__gf_ap_team_user_id__c = userBranch.Id;
		apTeam.bupl__gf_business_plan_id__c = bussPlan.Id;
		apTeam.acpl__gf_account_planning_id__c = accPlan.Id;
		apTeam.account_planning_Owner__c = true;
		insert apTeam;
	}

	/*
	 * @Name: AsignBeforeInsert
	 * @Description: Ejecuta el trigger de usuarios al insertar.
	 * @author Jose Rodriguez
	 */
	@isTest
	static void asignBeforeInsert() {
		final User userToInsert = new User();
		final Double random = Math.random();
		userToInsert.Username = USER_NAME + 'u2@u.com.u' + random;
		userToInsert.LastName = USER_NAME + 'uLast2';
		userToInsert.Email = USER_NAME + 'u2@u.com';
		userToInsert.Alias = String.valueOf(random).substring(0, 3) + 'uAas2';
		userToInsert.TimeZoneSidKey = 'America/Mexico_City';
		userToInsert.IsActive = true;
		userToInsert.LocaleSidKey = 'en_US';
		userToInsert.EmailEncodingKey = 'ISO-8859-1';
		final List<Profile> prof = new List<Profile>([SELECT Id, Name FROM Profile where Name = 'Ejecutivo']);
		userToInsert.ProfileId =  prof[0].Id;
		userToInsert.LanguageLocaleKey = 'es';
		userToInsert.Unique_id__c = 'p088888';
		userToInsert.organizational_unit_id__c = '00027902';
		userToInsert.organizational_unit_name__c = 'BIBEC PERU';
		userToInsert.prof_position_type__c = 'LEVEL C';
		boolean exito = false;
		Test.startTest();
		insert userToInsert;
		exito = true;
		System.assert (exito, 'exito');
		Test.stopTest();
	}
	/*
	 * @Name: AsignBeforeUpdate
	 * @Description: Ejecuta el trigger de usuarios al hacer update.
	 * @author Jose Rodriguez
	 */
	@isTest
	static void asignBeforeUpdate() {
		boolean exito = false;
		Test.startTest();
		update(users);
		exito = true;
		System.assert (exito, 'exito');
		Test.stopTest();
	}

	/*
	 * @Name: AsignAfterInsert
	 * @Description: call to AssigmentPermissionValidationAP_cls class after create user with prof_position_id__c = CODE_USER
	 * @author Martin Mori
	 */
	@isTest
	static void asignAfterInsertTest() {
		final User userToInsert = new User();
		final Double random = Math.random();
		userToInsert.Username = USER_NAME + 'u2@u.com.u' + random;
		userToInsert.LastName = USER_NAME + 'uLast2';
		userToInsert.Email = USER_NAME + 'u2@u.com';
		userToInsert.Alias = String.valueOf(random).substring(0, 3) + 'uAas2';
		userToInsert.TimeZoneSidKey = 'America/Mexico_City';
		userToInsert.IsActive = true;
		userToInsert.LocaleSidKey = 'en_US';
		userToInsert.EmailEncodingKey = 'ISO-8859-1';
		final List<Profile> prof = new List<Profile>([SELECT Id, Name FROM Profile where Name = 'Ejecutivo']);
		userToInsert.ProfileId =  prof[0].Id;
		userToInsert.LanguageLocaleKey = 'es';
		userToInsert.Unique_id__c = 'p088888';
		userToInsert.organizational_unit_id__c = '00027902';
		userToInsert.organizational_unit_name__c = 'BIBEC PERU';
		userToInsert.prof_position_type__c = 'LEVEL C';
		userToInsert.prof_position_id__c = CODE_USER;
		Test.startTest();
		insert userToInsert;
        Test.stopTest();
		final List<PermissionSet> valPermission = [SELECT Id, Name FROM PermissionSet WHERE name = 'Account_Planning_Validation_Permission' LIMIT 1];
        Final List<PermissionSetAssignment> userAS = [SELECT Id FROM PermissionSetAssignment WHERE PermissionSetId =: valPermission[0].Id AND AssigneeId =: userToInsert.Id];
		System.assertEquals (userAS.size(), 1, 'Fail!');
	}

	/*
	 * @Name: AsignAfterUpdate
	 * @Description: call to AssigmentPermissionValidationAP_cls class after create user with prof_position_id__c = CODE_USER
	 * @author Martin Mori
	 */
	@isTest
	static void asignAfterUpdateTest() {
		final bupl__AP_Team__c apTeam = [SELECT Id, bupl__gf_ap_team_user_id__c FROM bupl__AP_Team__c LIMIT 1][0];
		final User userTest1 = new User(Id = apTeam.bupl__gf_ap_team_user_id__c);
		userTest1.isActive = false;
		update userTest1;
		final User userTest2 = new User(Id = apTeam.bupl__gf_ap_team_user_id__c);
		userTest2.isActive = true;
		userTest2.prof_position_id__c = CODE_USER;
		Test.startTest();
		update userTest2;
        Test.stopTest();
        final List<PermissionSet> valPermission = [SELECT Id, Name FROM PermissionSet WHERE name = 'Account_Planning_Validation_Permission' LIMIT 1];
        Final List<PermissionSetAssignment> userAS = [SELECT Id FROM PermissionSetAssignment WHERE PermissionSetId =: valPermission[0].Id AND AssigneeId =: userTest2.Id];
		System.assertEquals (1, userAS.size(), 'Fail!');
	}
    
    @isTest
	static void deleteAssigment() {
        final User userT = TestFactory.createUser('TestDelete', 'Ejecutivo');
		userT.prof_position_id__c = CODE_USER;
        update userT;
        userT.prof_position_id__c = '';
		Test.startTest();
		update userT;
        Test.stopTest();
        final List<PermissionSet> valPermission = [SELECT Id, Name FROM PermissionSet WHERE name = 'Account_Planning_Validation_Permission' LIMIT 1];
        Final List<PermissionSetAssignment> userAS = [SELECT Id FROM PermissionSetAssignment WHERE PermissionSetId =: valPermission[0].Id AND AssigneeId =: userT.Id];
		System.assertEquals (userAS.size(), 0, 'Fail!');
	}

	/*
	 * @Name: setEquivalentValuesTest method
	 * @Description: call to setEquivalentValuesTest method when user is created to migracion
	 * @author Martin Mori
	 */
	@isTest
	static void setEquivalentValuesTest() {
		final User userExecutive = TestFactory.createUser('userExecutiveOwner', 'Migracion');
		Test.startTest();
		System.runAs(userExecutive) {
			final User userToInsert = new User();
			final Double random = Math.random();
			userToInsert.Username = USER_NAME + 'u2@u.com.u' + random;
			userToInsert.LastName = USER_NAME + 'uLast2';
			userToInsert.Email = USER_NAME + 'u2@u.com';
			userToInsert.Alias = String.valueOf(random).substring(0, 3) + 'uAas2';
			userToInsert.TimeZoneSidKey = 'America/Mexico_City';
			userToInsert.IsActive = true;
			userToInsert.LocaleSidKey = 'en_US';
			userToInsert.EmailEncodingKey = 'ISO-8859-1';
			final List<Profile> prof = new List<Profile>([SELECT Id, Name FROM Profile where Name = 'Ejecutivo']);
			userToInsert.ProfileId =  prof[0].Id;
			userToInsert.LanguageLocaleKey = 'es';
			userToInsert.Unique_id__c = 'p088888';
			userToInsert.organizational_unit_id__c = '00027902';
			userToInsert.organizational_unit_name__c = 'BIBEC PERU';
			userToInsert.prof_position_type__c = 'LEVEL C';
			userToInsert.prof_position_id__c = CODE_USER;
			insert userToInsert;
			Boolean successInsert;
			if(userToInsert.Id == null) {
				successInsert = false;
			} else {
				successInsert = true;
			}
			System.assert (successInsert, 'success!');
		}
		Test.stopTest();
	}
    
    @isTest
    static void addJpnInSMSTest() {
         Final Id ejeProfileId = BE_SM_Factory_tst.ID_EJE;
        Final Id jpnUR = [SELECT Id FROM UserRole WHERE DeveloperName = 'JEFE_PROMOCION_DE_NEGOCIO_BE_1' LIMIT 1].Id;
        Final User userGR = TestFactory.getUser(true, new Map<Schema.SObjectField, Object>{User.ProfileId => ejeProfileId, User.prof_position_id__c => 'OS8'});
        Final User userGOF = TestFactory.getUser(true, new Map<Schema.SObjectField, Object>{User.ProfileId => ejeProfileId, User.prof_position_id__c => CODE_USER, 
            																				User.ManagerId => userGR.Id});
        Final User userJPN = TestFactory.getUser(true, new Map<Schema.SObjectField, Object>{User.ProfileId => ejeProfileId, User.prof_position_id__c => '', 
            																				User.ManagerId => userGR.Id, User.UserRoleId => jpnUR });
        Final User userEJE = TestFactory.getUser(true, new Map<Schema.SObjectField, Object>{User.ProfileId => ejeProfileId, User.prof_position_id__c => 'E03', 
            																				User.ManagerId => userGOF.Id});
        System.runAs(userGOF) {
            BE_SM_Factory_tst.createSalesMeeting(DateTime.newInstance(System.today().addMonths(1).year(), System.today().addMonths(1).month(), 1), userGOF.Id, 'Planning', true);
            BE_SM_Factory_tst.createSalesMeeting(DateTime.newInstance(System.today().addMonths(1).year(), System.today().addMonths(1).month(), 1), userEJE.Id, 'Planning', true);
        }
        Test.startTest();
        userJPN.prof_position_id__c = 'OS9';
        update userJPN;
        Final User userJPN2 = TestFactory.getUser(true, new Map<Schema.SObjectField, Object>{User.ProfileId => ejeProfileId, User.prof_position_id__c => 'OS9', 
            																				User.ManagerId => userGR.Id, User.UserRoleId => jpnUR });
        Test.stopTest();
        Final slmt__Sales_Meeting__Share[] lstSMAJPN = [SELECT Id FROM slmt__Sales_Meeting__Share WHERE UserOrGroupId =: userJPN.Id OR UserOrGroupId =: userJPN2.Id];
        System.assertEquals(4, lstSMAJPN.size(), 'Assertion Error');
    }
    
    @isTest
    static void removeJPNofSMSTest() {
         Final Id ejeProfileId = BE_SM_Factory_tst.ID_EJE;
        Final Id jpnUR = [SELECT Id FROM UserRole WHERE DeveloperName = 'JEFE_PROMOCION_DE_NEGOCIO_BE_1' LIMIT 1].Id;
        Final User userGR = TestFactory.getUser(true, new Map<Schema.SObjectField, Object>{User.ProfileId => ejeProfileId, User.prof_position_id__c => 'OS8'});
        Final User userGOF = TestFactory.getUser(true, new Map<Schema.SObjectField, Object>{User.ProfileId => ejeProfileId, User.prof_position_id__c => CODE_USER, 
            																				User.ManagerId => userGR.Id});
        Final User userJPN = TestFactory.getUser(true, new Map<Schema.SObjectField, Object>{User.ProfileId => ejeProfileId, User.prof_position_id__c => 'OS9', 
            																				User.ManagerId => userGR.Id, User.UserRoleId => jpnUR });
        System.runAs(userGOF) {
            BE_SM_Factory_tst.createSalesMeeting(DateTime.newInstance(System.today().addMonths(1).year(), System.today().addMonths(1).month(), 1), userGOF.Id, 'Planning', true);
        }
        Test.startTest();
        userJPN.prof_position_id__c = CODE_USER;
        update userJPN;
        Test.stopTest();
        Final slmt__Sales_Meeting__Share[] lstSMAJPN = [SELECT Id FROM slmt__Sales_Meeting__Share WHERE UserOrGroupId =: userJPN.Id];
        System.assertEquals(0, lstSMAJPN.size(), 'Assertion Error');
    }
}