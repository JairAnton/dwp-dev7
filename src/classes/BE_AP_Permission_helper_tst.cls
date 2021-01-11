/**
 * Test class for BE_AP_Permission_cls
 * <p />BE_AP_Permission_helper_tst<p />
 * Modification log:<p />
 * -------------------------------------------------------------------
 * Developer                    Date                Description<p />
 * -------------------------------------------------------------------
 * Diego Carbajal    		05/06/2020          Original version.<p />
 *
 * @author Diego Carbajal
 */
@isTest
public class BE_AP_Permission_helper_tst {

    /** @Description  FAIL*/
    private static Final String FAIL = 'Fail';
    /** @Description  V_PERMISSION*/
    private static Final String V_PERMISSION = 'permission';
    /** @Description  UPDT*/
    private static Final String UPDT = 'update';
    /** @Description  DEL*/
    private static Final String DEL = 'delete';
    /** @Description  USER_TEST*/
    private static Final String USER_TEST = 'User Test';
    /** @Description  SOBJ_NAME*/
    private static Final String SOBJ_NAME = 'acpl__account_planning__c';

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
			                                             Edit_Commercial_Plan__c = true, Create_Need__c = true, Edit_Growth_Driver__c = true, Edit_Need__c = true);
		}
	}
    
    /*
	 * @Description  method permissionBP
	 */
	public static testmethod void permissionBP() {
		Final User adminAP = [SELECT Id FROM User WHERE user_position_equivalence__c =: USER_TEST LIMIT 1];
		Boolean edit;
		Boolean delet;
		Test.startTest();
		System.runAs(adminAP) {
			Final BE_AP_Permission_helper permission = new BE_AP_Permission_helper(adminAP.Id);
			edit = permission.permissionBP(UPDT);
			delet = permission.permissionBP(DEL);
		}
		Test.stopTest();
        Final Boolean result = edit && delet;
		System.assert (result, FAIL);
	}

	/*
	 * @Description  method permissionQuestions
	 */
	public static testmethod void permissionQuestions() {
		Final User adminAP = [SELECT Id FROM User WHERE user_position_equivalence__c =: USER_TEST LIMIT 1];
		Boolean edit;
		Boolean delet;
		Test.startTest();
		System.runAs(adminAP) {
			Final BE_AP_Permission_helper permission = new BE_AP_Permission_helper(adminAP.Id);
			edit = permission.permissionQuestions(UPDT);
			delet = permission.permissionQuestions(DEL);
		}
		Test.stopTest();
        Final Boolean assert = edit && delet;
		System.assert (assert, FAIL);
	}

	/*
	 * @Description  method onRelatedRecordsValidation
	 */
	public static testmethod void onRelatedRecordsValidation() {
		Final User adminAP = [SELECT Id FROM User WHERE user_position_equivalence__c =: USER_TEST LIMIT 1];
		Final AccountPlanning_Administration__c settings = AccountPlanning_Administration__c.getInstance(adminAP.Id);
		settings.Edit_Account_Planning__c = false;
		update settings;
		Final acpl__Account_Planning__c apR = BE_AP_Permission_tst.obtainAP();
		apR.acpl__gf_ap_status_type_name__c = 'Validated';
		update apR;
		Boolean error;
		Test.startTest();
		System.runAs(adminAP) {
			try {
				Final BE_AP_Permission_helper permission = new BE_AP_Permission_helper(adminAP.Id);
				Final Map<String, String> mapConfig = new Map<String, String> {'sobjectType' => SOBJ_NAME, 'actionType' => UPDT};
				permission.permissionOnRelatedRecords(new List<acpl__Account_Planning__c> {apR},
				                                      new Map<Id, List<SObject>> {apR.Id => new List<acpl__Account_Planning__c> {apR}}, mapConfig);
				error = true;
			} catch(Exception e) {
				System.debug(e.getMessage());
				error = false;
			}
		}
		Test.stopTest();
		System.assert (error, FAIL);
	}

	/*
	 * @Description  method onRelatedRecordsLock
	 */
	public static testmethod void onRelatedRecordsLock() {
		Final User adminAP = [SELECT Id FROM User WHERE user_position_equivalence__c =: USER_TEST LIMIT 1];
		Final acpl__Account_Planning__c apR = BE_AP_Permission_tst.obtainAP();
		apR.acpl__gf_ap_indvi_lock_edit_ind_type__c = false;
		update apR;
		Boolean error;
		Test.startTest();
		System.runAs(adminAP) {
			try {
				Final BE_AP_Permission_helper permission = new BE_AP_Permission_helper(adminAP.Id);
				Final Map<String, String> mapConfig = new Map<String, String> {'sobjectType' => SOBJ_NAME, 'actionType' => UPDT};
				permission.permissionOnRelatedRecords(new List<acpl__Account_Planning__c> {apR},
				                                      new Map<Id, List<SObject>> {apR.Id => new List<acpl__Account_Planning__c> {apR}}, mapConfig);
				error = true;
			} catch(Exception e) {
				System.debug(e.getMessage());
				error = false;
			}
		}
		Test.stopTest();
		System.assert (error, FAIL);
	}

	/*
	 * @Description  method onRelatedRecords
	 */
	public static testmethod void onRelatedRecords() {
		Final User adminAP = [SELECT Id FROM User WHERE user_position_equivalence__c =: USER_TEST LIMIT 1];
		Final acpl__Account_Planning__c apR = BE_AP_Permission_tst.obtainAP();
		Boolean error;
		Test.startTest();
		System.runAs(adminAP) {
			try {
				Final BE_AP_Permission_helper permission = new BE_AP_Permission_helper(adminAP.Id);
				Final Map<String, String> mapConfig = new Map<String, String> {'sobjectType' => SOBJ_NAME, 'actionType' => UPDT};
				permission.permissionOnRelatedRecords(new List<acpl__Account_Planning__c> {apR},
				                                      new Map<Id, List<SObject>> {apR.Id => new List<acpl__Account_Planning__c> {apR}}, mapConfig);
				error = true;
			} catch(Exception e) {
				System.debug(e.getMessage());
				error = false;
			}
		}
		Test.stopTest();
		System.assert (error, FAIL);
	}

	/*
	 * @Description  method workOnSObject
	 */
	public static testmethod void workOnSObject() {
		Boolean validateNeed, validateGD, validateCP, validateBP, validateAP, validateAPT, validateQuestion;
		Final User adminAP = [SELECT Id FROM User WHERE user_position_equivalence__c =: USER_TEST LIMIT 1];
		Test.startTest();
		System.runAs(adminAP) {
			Final BE_AP_Permission_helper permission = new BE_AP_Permission_helper(adminAP.Id);
			validateNeed = (Boolean)permission.workOnSObject('bupl__BP_Need__c', UPDT).get(V_PERMISSION);
			validateGD = (Boolean)permission.workOnSObject('bupl__BP_GrowthDriver__c', UPDT).get(V_PERMISSION);
			validateCP = (Boolean)permission.workOnSObject('acpl__Commercial_Plan_Event__c', UPDT).get(V_PERMISSION);
			validateBP = (Boolean)permission.workOnSObject('bupl__BusinessPlan__c', UPDT).get(V_PERMISSION);
			validateAP = (Boolean)permission.workOnSObject('acpl__Account_Planning__c', UPDT).get(V_PERMISSION);
			validateAPT = (Boolean)permission.workOnSObject('bupl__AP_Team__c', UPDT).get(V_PERMISSION);
			validateQuestion = (Boolean)permission.workOnSObject('acpl__AP_Question__c', UPDT).get(V_PERMISSION);
		}
		Test.stopTest();
        Final Boolean assert = validateNeed && validateGD && validateCP && validateBP && validateAP && validateAPT && validateQuestion;
		System.assert (assert, FAIL);
	}
}