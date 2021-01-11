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
    
    /** @Description  FAIL*/
    private static Final String FAIL = 'Fail';
    /** @Description  V_INSERT*/
    private static Final String V_INSERT = 'insert';
    /** @Description  UPDT*/
    private static Final String UPDT = 'update';
    /** @Description  DEL*/
    private static Final String DEL = 'delete';
    /** @Description  USER_TEST*/
    private static Final String USER_TEST = 'User Test';
	/*
	 * @Description  method setUp
	 */
	@TestSetup
	static void setUp() {
		Final String perfil = [SELECT Id FROM Profile WHERE name = 'Ejecutivo'].Id;
		//Creación de usuario
		Final Id gerenteRole = [SELECT Id FROM UserRole WHERE DeveloperName = 'GERENTE_BANCA_EMPRESAS_MIRAFLORES' LIMIT 1].Id;
		Final Map<Schema.SObjectField, Object> mapFields = new Map<Schema.SObjectField, Object> {User.LastName => 'GERENTE', User.ProfileId => perfil, 
            User.prof_position_id__c => 'E01', User.user_position_equivalence__c => USER_TEST, User.UserRoleId => gerenteRole};
		Final User gof = TestFactory.getUser(true, mapFields);
		Final User usuario = [SELECT Id FROM User WHERE Id =:UserInfo.getUserId()];
		System.runAs(usuario) {
			insert new AccountPlanning_Administration__c(SetupOwnerId = gof.Id, Create_Account_Planning_Team_Members__c = true, Create_Commercial_Plan__c = true,
			                                             Create_Growth_Driver__c = true,  Delete_Account_Planning__c = true, Delete_Account_Planning_Questions__c = true,
			                                             Delete_Account_Planning_Team_Members__c = true, Delete_Need__c = true, Delete_Business_Plan__c = true,
			                                             Delete_Commercial_Plan__c = true, Delete_Growth_Driver__c = true,  Edit_Account_Planning__c = true,
			                                             Edit_Business_Plan__c = true, Edit_Account_Planning_Questions__c = true, Edit_Account_Planning_Team_Members__c = true,
			                                             Edit_Commercial_Plan__c = true, Create_Need__c = true, Edit_Growth_Driver__c = true, Edit_Need__c = true, 
                                                         Create_StockHolder__c = true, Edit_StockHolder__c = true, Delete_StockHolder__c = true);
		}
	}

	/*
	 * @Description  method permissionOnAP
	 */
	public static testmethod void permissionOnAP() {
		Final User adminAP = [SELECT Id FROM User WHERE user_position_equivalence__c =: USER_TEST LIMIT 1];
		Boolean edit;
		Boolean delet;
		Test.startTest();
		System.runAs(adminAP) {
			Final BE_AP_Permission_helper permission = new BE_AP_Permission_helper(adminAP.Id);
			edit = permission.permissionOnAP(UPDT);
			delet = permission.permissionOnAP(DEL);
		}
		Test.stopTest();
        Final Boolean assert = edit && delet;
		System.assert (assert, FAIL);
	}

	/*
	 * @Description  method permissionOnNeed
	 */
	public static testmethod void permissionOnNeed() {
		Final User adminAP = [SELECT Id FROM User WHERE user_position_equivalence__c =: USER_TEST LIMIT 1];
		Boolean create;
		Boolean edit;
		Boolean delet;
		Test.startTest();
		System.runAs(adminAP) {
			Final BE_AP_Permission_helper permission = new BE_AP_Permission_helper(adminAP.Id);
			create = permission.permissionOnNeed(V_INSERT);
			edit = permission.permissionOnNeed(UPDT);
			delet = permission.permissionOnNeed(DEL);
		}
		Test.stopTest();
        Final Boolean result = create && edit && delet;
		System.assert (result, FAIL);
	}

	/*
	 * @Description  method permissionGrowthDriver
	 */
	public static testmethod void permissionGrowthDriver() {
		Final User adminAP = [SELECT Id FROM User WHERE user_position_equivalence__c =: USER_TEST LIMIT 1];
		Boolean create;
		Boolean edit;
		Boolean delet;
		Test.startTest();
		System.runAs(adminAP) {
			Final BE_AP_Permission_helper permission = new BE_AP_Permission_helper(adminAP.Id);
			create = permission.permissionGrowthDriver(V_INSERT);
			edit = permission.permissionGrowthDriver(UPDT);
			delet = permission.permissionGrowthDriver(DEL);
		}
		Test.stopTest();
        Final Boolean result = create && edit && delet;
		System.assert (result, FAIL);
	}

	/*
	 * @Description  method permissionOnAPT
	 */
	public static testmethod void permissionOnAPT() {
		Final User adminAP = [SELECT Id FROM User WHERE user_position_equivalence__c =: USER_TEST LIMIT 1];
		Boolean create;
		Boolean edit;
		Boolean delet;
		Test.startTest();
		System.runAs(adminAP) {
			Final BE_AP_Permission_helper permission = new BE_AP_Permission_helper(adminAP.Id);
			create = permission.permissionOnAPT(V_INSERT);
			edit = permission.permissionOnAPT(UPDT);
			delet = permission.permissionOnAPT(DEL);
		}
		Test.stopTest();
        Final Boolean result = create && edit && delet;
		System.assert (result, FAIL);
	}

	/*
	 * @Description  method permissionCPE
	 */
	public static testmethod void permissionCPE() {
		Final User adminAP = [SELECT Id FROM User WHERE user_position_equivalence__c =: USER_TEST LIMIT 1];
		Boolean create;
		Boolean edit;
		Boolean delet;
		Test.startTest();
		System.runAs(adminAP) {
			Final BE_AP_Permission_helper permission = new BE_AP_Permission_helper(adminAP.Id);
			create = permission.permissionCPE(V_INSERT);
			edit = permission.permissionCPE(UPDT);
			delet = permission.permissionCPE(DEL);
		}
		Test.stopTest();
        Final Boolean result = create && edit && delet;
		System.assert (result, FAIL);
	}

	/*
	 * @Description  method permissionStocker
	 */
	public static testmethod void permissionStocker() {
		Final User adminAP = [SELECT Id FROM User WHERE user_position_equivalence__c =: USER_TEST LIMIT 1];
		Boolean create;
		Boolean edit;
		Boolean delet;
		Test.startTest();
		System.runAs(adminAP) {
			Final BE_AP_Permission_helper permission = new BE_AP_Permission_helper(adminAP.Id);
			create = permission.permissionSH(V_INSERT);
			edit = permission.permissionSH(UPDT);
			delet = permission.permissionSH(DEL);
		}
		Test.stopTest();
        Final Boolean result = create && edit && delet;
		System.assert (result, FAIL);
	}
    
	/*
	 * @Description  method getAP
	 */
	public static acpl__Account_Planning__c obtainAP() {
		Final User admin = [SELECT Id FROM User WHERE Id =:UserInfo.getUserId() LIMIT 1];
		Final User adminAP = [SELECT Id FROM User WHERE user_position_equivalence__c =: USER_TEST LIMIT 1];
		User ejecutivo;
		System.runAs(admin) {
			Final String perfil = [SELECT Id FROM Profile WHERE name = 'Ejecutivo'].Id;
			//Creación de usuario
			Final Id gerenteRole = [SELECT Id FROM UserRole WHERE DeveloperName = 'GERENTE_BANCA_EMPRESAS_MIRAFLORES' LIMIT 1].Id;
			Final Map<Schema.SObjectField, Object> mapFields = new Map<Schema.SObjectField, Object> {User.LastName => 'EJECUTIVO', User.ProfileId => perfil,
				                                                                               User.prof_position_id__c => 'E01', User.user_position_equivalence__c => 'Test', User.UserRoleId => gerenteRole};
			ejecutivo = TestFactory.getUser(true, mapFields);
			Final AccountPlanning_Administration__c settings = AccountPlanning_Administration__c.getInstance(adminAP.Id);
			settings.Edit_Account_Planning__c = false;
			settings.Delete_Account_Planning__c = false;
			update settings;
		}
		Final Account acc = TestFactory.createAccount();
		Final acpl__Account_Planning__c apR = AP_FactoryTest_tst.createAccountPlanning(acc.Id, ejecutivo.Id, null, true);
		insert apR;
		return apR;
	}
}