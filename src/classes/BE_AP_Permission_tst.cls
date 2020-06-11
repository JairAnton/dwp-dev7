/**
 * Test class for BE_AP_Permission_tst
 * <p /><p />
 * Modification log:<p />
 * -------------------------------------------------------------------
 * Developer                    Date                Description<p />
 * -------------------------------------------------------------------
 * Diego Carbajal    		05/06/2020          Original version.<p />
 *
 * @author Diego Carbajal
 */
@isTest
public class BE_AP_Permission_tst {
	/*
	 * @Description  method setUp
	 */
	@TestSetup
	static void setUp() {
		Final String perfil = [SELECT Id FROM Profile WHERE name = 'Ejecutivo'].Id;
		//Creaci�n de usuario
		Final Id gerenteRole = [SELECT Id FROM UserRole WHERE DeveloperName = 'GERENTE_BANCA_EMPRESAS_MIRAFLORES' LIMIT 1].Id;
		Map<Schema.SObjectField, Object> mapFields = new Map<Schema.SObjectField, Object> {User.LastName => 'GERENTE', User.ProfileId => perfil,
			                                                                               User.prof_position_id__c => 'E01', User.user_position_equivalence__c => 'User Test', User.UserRoleId => gerenteRole};
		Final User gof = TestFactory.getUser(true, mapFields);
		Final User usuario = [SELECT Id FROM User WHERE Id =:UserInfo.getUserId()];
		System.runAs(usuario) {
			insert new AccountPlanning_Administration__c(SetupOwnerId = gof.Id, Create_Account_Planning_Team_Members__c = true, Create_Commercial_Plan__c = true,
			                                             Create_Growth_Driver__c = true,  Delete_Account_Planning__c = true, Delete_Account_Planning_Questions__c = true,
			                                             Delete_Account_Planning_Team_Members__c = true, Delete_Need__c = true, Delete_Business_Plan__c = true,
			                                             Delete_Commercial_Plan__c = true, Delete_Growth_Driver__c = true,  Edit_Account_Planning__c = true,
			                                             Edit_Business_Plan__c = true, Edit_Account_Planning_Questions__c = true, Edit_Account_Planning_Team_Members__c = true,
			                                             Edit_Commercial_Plan__c = true, Create_Need__c = true, Edit_Growth_Driver__c = true, Edit_Need__c = true);
		}
	}

	/*
	 * @Description  method permissionOnAP
	 */
	public static testmethod void permissionOnAP() {
		Final User adminAP = [SELECT Id FROM User WHERE user_position_equivalence__c = 'User Test' LIMIT 1];
		Boolean edit;
		Boolean delet;
		Test.startTest();
		System.runAs(adminAP) {
			Final BE_AP_Permission_helper permission = new BE_AP_Permission_helper(adminAP.Id);
			edit = permission.permissionOnAP('update');
			delet = permission.permissionOnAP('delete');
		}
		Test.stopTest();
		System.assert (edit, 'Fail');
		System.assert (delet, 'Fail');
	}

	/*
	 * @Description  method permissionOnNeed
	 */
	public static testmethod void permissionOnNeed() {
		Final User adminAP = [SELECT Id FROM User WHERE user_position_equivalence__c = 'User Test' LIMIT 1];
		Boolean create;
		Boolean edit;
		Boolean delet;
		Test.startTest();
		System.runAs(adminAP) {
			BE_AP_Permission_helper permission = new BE_AP_Permission_helper(adminAP.Id);
			create = permission.permissionOnNeed('insert');
			edit = permission.permissionOnNeed('update');
			delet = permission.permissionOnNeed('delete');
		}
		Test.stopTest();
		System.assert (create, 'Fail');
		System.assert (edit, 'Fail');
		System.assert (delet, 'Fail');
	}

	/*
	 * @Description  method permissionGrowthDriver
	 */
	public static testmethod void permissionGrowthDriver() {
		Final User adminAP = [SELECT Id FROM User WHERE user_position_equivalence__c = 'User Test' LIMIT 1];
		Boolean create;
		Boolean edit;
		Boolean delet;
		Test.startTest();
		System.runAs(adminAP) {
			Final BE_AP_Permission_helper permission = new BE_AP_Permission_helper(adminAP.Id);
			create = permission.permissionGrowthDriver('insert');
			edit = permission.permissionGrowthDriver('update');
			delet = permission.permissionGrowthDriver('delete');
		}
		Test.stopTest();
		System.assert (create, 'Fail');
		System.assert (edit, 'Fail');
		System.assert (delet, 'Fail');
	}

	/*
	 * @Description  method permissionOnAPT
	 */
	public static testmethod void permissionOnAPT() {
		Final User adminAP = [SELECT Id FROM User WHERE user_position_equivalence__c = 'User Test' LIMIT 1];
		Boolean create;
		Boolean edit;
		Boolean delet;
		Test.startTest();
		System.runAs(adminAP) {
			Final BE_AP_Permission_helper permission = new BE_AP_Permission_helper(adminAP.Id);
			create = permission.permissionOnAPT('insert');
			edit = permission.permissionOnAPT('update');
			delet = permission.permissionOnAPT('delete');
		}
		Test.stopTest();
		System.assert (create, 'Fail');
		System.assert (edit, 'Fail');
		System.assert (delet, 'Fail');
	}

	/*
	 * @Description  method permissionCPE
	 */
	public static testmethod void permissionCPE() {
		Final User adminAP = [SELECT Id FROM User WHERE user_position_equivalence__c = 'User Test' LIMIT 1];
		Boolean create;
		Boolean edit;
		Boolean delet;
		Test.startTest();
		System.runAs(adminAP) {
			Final BE_AP_Permission_helper permission = new BE_AP_Permission_helper(adminAP.Id);
			create = permission.permissionCPE('insert');
			edit = permission.permissionCPE('update');
			delet = permission.permissionCPE('delete');
		}
		Test.stopTest();
		System.assert (create, 'Fail');
		System.assert (edit, 'Fail');
		System.assert (delet, 'Fail');
	}

	/*
	 * @Description  method permissionBP
	 */
	public static testmethod void permissionBP() {
		Final User adminAP = [SELECT Id FROM User WHERE user_position_equivalence__c = 'User Test' LIMIT 1];
		Boolean edit;
		Boolean delet;
		Test.startTest();
		System.runAs(adminAP) {
			Final BE_AP_Permission_helper permission = new BE_AP_Permission_helper(adminAP.Id);
			edit = permission.permissionBP('update');
			delet = permission.permissionBP('delete');
		}
		Test.stopTest();
		System.assert (edit, 'Fail');
		System.assert (delet, 'Fail');
	}

	/*
	 * @Description  method permissionQuestions
	 */
	public static testmethod void permissionQuestions() {
		Final User adminAP = [SELECT Id FROM User WHERE user_position_equivalence__c = 'User Test' LIMIT 1];
		Boolean edit;
		Boolean delet;
		Test.startTest();
		System.runAs(adminAP) {
			Final BE_AP_Permission_helper permission = new BE_AP_Permission_helper(adminAP.Id);
			edit = permission.permissionQuestions('update');
			delet = permission.permissionQuestions('delete');
		}
		Test.stopTest();
		System.assert (edit, 'Fail');
		System.assert (delet, 'Fail');
	}

	/*
	 * @Description  method onRelatedRecordsValidation
	 */
	public static testmethod void onRelatedRecordsValidation() {
		Final User adminAP = [SELECT Id FROM User WHERE user_position_equivalence__c = 'User Test' LIMIT 1];
		Final AccountPlanning_Administration__c settings = AccountPlanning_Administration__c.getInstance(adminAP.Id);
		settings.Edit_Account_Planning__c = false;
		update settings;
		Final acpl__Account_Planning__c ap = getAP();
		ap.acpl__gf_ap_status_type_name__c = 'Validated';
		update ap;
		Boolean error;
		Test.startTest();
		System.runAs(adminAP) {
			try {
				Final BE_AP_Permission_helper permission = new BE_AP_Permission_helper(adminAP.Id);
				Map<String, String> mapConfig = new Map<String, String> {'sobjectType' => 'acpl__Account_Planning__c', 'actionType' => 'update'};
				permission.permissionOnRelatedRecords(new List<acpl__Account_Planning__c> {ap},
				                                      new Map<Id, List<SObject>> {ap.Id => new List<acpl__Account_Planning__c> {ap}}, mapConfig);
				error = true;
			} catch(Exception e) {
				System.debug(e.getMessage());
				error = false;
			}
		}
		Test.stopTest();
		System.assert (error, 'Fail');
	}

	/*
	 * @Description  method onRelatedRecordsLock
	 */
	public static testmethod void onRelatedRecordsLock() {
		Final User adminAP = [SELECT Id FROM User WHERE user_position_equivalence__c = 'User Test' LIMIT 1];
		Final acpl__Account_Planning__c ap = getAP();
		ap.acpl__gf_ap_indvi_lock_edit_ind_type__c = false;
		update ap;
		Boolean error;
		Test.startTest();
		System.runAs(adminAP) {
			try {
				Final BE_AP_Permission_helper permission = new BE_AP_Permission_helper(adminAP.Id);
				Map<String, String> mapConfig = new Map<String, String> {'sobjectType' => 'acpl__Account_Planning__c', 'actionType' => 'update'};
				permission.permissionOnRelatedRecords(new List<acpl__Account_Planning__c> {ap},
				                                      new Map<Id, List<SObject>> {ap.Id => new List<acpl__Account_Planning__c> {ap}}, mapConfig);
				error = true;
			} catch(Exception e) {
				System.debug(e.getMessage());
				error = false;
			}
		}
		Test.stopTest();
		System.assert (error, 'Fail');
	}

	/*
	 * @Description  method onRelatedRecords
	 */
	public static testmethod void onRelatedRecords() {
		Final User adminAP = [SELECT Id FROM User WHERE user_position_equivalence__c = 'User Test' LIMIT 1];
		Final acpl__Account_Planning__c ap = getAP();
		Boolean error;
		Test.startTest();
		System.runAs(adminAP) {
			try {
				Final BE_AP_Permission_helper permission = new BE_AP_Permission_helper(adminAP.Id);
				Map<String, String> mapConfig = new Map<String, String> {'sobjectType' => 'acpl__Account_Planning__c', 'actionType' => 'update'};
				permission.permissionOnRelatedRecords(new List<acpl__Account_Planning__c> {ap},
				                                      new Map<Id, List<SObject>> {ap.Id => new List<acpl__Account_Planning__c> {ap}}, mapConfig);
				error = true;
			} catch(Exception e) {
				System.debug(e.getMessage());
				error = false;
			}
		}
		Test.stopTest();
		System.assert (error, 'Fail');
	}

	/*
	 * @Description  method workOnSObject
	 */
	public static testmethod void workOnSObject() {
		Boolean validateNeed, validateGD, validateCP, validateBP, validateAP, validateAPT, validateQuestion;
		Final User adminAP = [SELECT Id FROM User WHERE user_position_equivalence__c = 'User Test' LIMIT 1];
		Test.startTest();
		System.runAs(adminAP) {
			Final BE_AP_Permission_helper permission = new BE_AP_Permission_helper(adminAP.Id);
			validateNeed = (Boolean)permission.workOnSObject('bupl__BP_Need__c', 'update').get('permission');
			validateGD = (Boolean)permission.workOnSObject('bupl__BP_GrowthDriver__c', 'update').get('permission');
			validateCP = (Boolean)permission.workOnSObject('acpl__Commercial_Plan_Event__c', 'update').get('permission');
			validateBP = (Boolean)permission.workOnSObject('bupl__BusinessPlan__c', 'update').get('permission');
			validateAP = (Boolean)permission.workOnSObject('acpl__Account_Planning__c', 'update').get('permission');
			validateAPT = (Boolean)permission.workOnSObject('bupl__AP_Team__c', 'update').get('permission');
			validateQuestion = (Boolean)permission.workOnSObject('acpl__AP_Question__c', 'update').get('permission');
		}
		Test.stopTest();
		System.assert (validateNeed, 'Fail');
		System.assert (validateGD, 'Fail');
		System.assert (validateCP, 'Fail');
		System.assert (validateBP, 'Fail');
		System.assert (validateAP, 'Fail');
		System.assert (validateAPT, 'Fail');
		System.assert (validateQuestion, 'Fail');
	}

	/*
	 * @Description  method getAP
	 */
	private static acpl__Account_Planning__c getAP() {
		Final User admin = [SELECT Id FROM User WHERE Id =:UserInfo.getUserId() LIMIT 1];
		Final User adminAP = [SELECT Id FROM User WHERE user_position_equivalence__c = 'User Test' LIMIT 1];
		User ejecutivo;
		System.runAs(admin) {
			Final String perfil = [SELECT Id FROM Profile WHERE name = 'Ejecutivo'].Id;
			//Creaci�n de usuario
			Final Id gerenteRole = [SELECT Id FROM UserRole WHERE DeveloperName = 'GERENTE_BANCA_EMPRESAS_MIRAFLORES' LIMIT 1].Id;
			Map<Schema.SObjectField, Object> mapFields = new Map<Schema.SObjectField, Object> {User.LastName => 'EJECUTIVO', User.ProfileId => perfil,
				                                                                               User.prof_position_id__c => 'E01', User.user_position_equivalence__c => 'Test', User.UserRoleId => gerenteRole};
			ejecutivo = TestFactory.getUser(true, mapFields);
			Final AccountPlanning_Administration__c settings = AccountPlanning_Administration__c.getInstance(adminAP.Id);
			settings.Edit_Account_Planning__c = false;
			settings.Delete_Account_Planning__c = false;
			update settings;
		}
		Final Account acc = TestFactory.createAccount();
		Final acpl__Account_Planning__c ap = TestFactory.createAccountPlanning(acc.Id, ejecutivo.Id, null, true);
		insert ap;
		return ap;
	}
}
