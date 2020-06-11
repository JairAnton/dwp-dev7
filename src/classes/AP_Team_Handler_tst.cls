/**
 * AP_Team_Handler_tst
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
public class AP_Team_Handler_tst {
	/**
	 * @Description variable mapUsers
	 */
	static Final Map<String, User> mapUsers = AP_FactoryTest_tst.getUsers();
	/**
	 * @Description variable fail
	 */
	static Final String fail = 'Fail Assertion';
	/**
	 * @Description method setUp
	 */
	@TestSetup
	static void setUp() {
		AP_FactoryTest_tst.forSetUp();
	}

	/**
	 * @Description Test method putValuesAPT and insertAPTSharing
	 */
	public static testmethod void valuesAndSharingAPT() {
		Final Account acc = [SELECT Id FROM Account LIMIT 1];
		Final acpl__Account_Planning__c ap = TestFactory.createAccountPlanning(acc.Id, mapUsers.get('EJECUTIVO').Id, null, true);
		insert ap;
		Test.startTest();
		System.runAs(mapUsers.get('EJECUTIVO')) {
			Final bupl__AP_Team__c apt = new bupl__AP_Team__c(acpl__gf_account_planning_id__c = ap.Id, Name = 'APT MEMBER', bupl__gf_ap_team_role_user_name__c = 'Acompanante',
			                                                  bupl__gf_ap_team_user_id__c = mapUsers.get('MANAGER').Id);
			insert apt;
		}
		Test.stopTest();
		Final bupl__BusinessPlan__c bp = [SELECT Id FROM bupl__BusinessPlan__c WHERE acpl__gf_account_planning_id__c =:ap.Id LIMIT 1];
		Final bupl__AP_Team__c[] apts = [SELECT Id FROM bupl__AP_Team__c WHERE acpl__gf_account_planning_id__c =:ap.Id AND bupl__gf_ap_team_role_user_name__c = 'Acompanante' LIMIT 1];
		Final acpl__Account_Planning__Share[] sharingAP = [SELECT Id, UserOrGroup.Name FROM acpl__Account_Planning__Share WHERE parentId =:ap.Id];
		Final bupl__BusinessPlan__Share[] sharingBP = [SELECT Id, UserOrGroup.Name FROM bupl__BusinessPlan__Share WHERE parentId =:bp.Id];
		Final Integer aptSize = apts.size();
		Final Integer sharingAPSize = sharingAP.size();
		Final Integer sharingBPSize = sharingBP.size();
		System.assertEquals(aptSize, 1, fail);
		System.assertEquals(sharingAPSize, 3, fail);
		System.assertEquals(sharingBPSize, 3, fail);
	}

	/**
	 * @Description Test method validateUserPermission AP lock
	 */
	public static testmethod void beforeDMLInsertAPLock() {
		Final Account acc = [SELECT Id FROM Account LIMIT 1];
		Final acpl__Account_Planning__c ap = TestFactory.createAccountPlanning(acc.Id, mapUsers.get('EJECUTIVO').Id, null, false);
		insert ap;
		Test.startTest();
		System.runAs(mapUsers.get('EJECUTIVO')) {
			try {
				Final bupl__AP_Team__c apt = new bupl__AP_Team__c(acpl__gf_account_planning_id__c = ap.Id, Name = 'APT MEMBER', bupl__gf_ap_team_role_user_name__c = 'Acompanante',
				                                                  bupl__gf_ap_team_user_id__c = mapUsers.get('MANAGER').Id);
				insert apt;
			} catch(Exception e) {
				System.debug(e.getMessage());
			}
		}
		Test.stopTest();
		Final bupl__AP_Team__c[] apts = [SELECT Id FROM bupl__AP_Team__c where acpl__gf_account_planning_id__c =:ap.Id AND bupl__gf_ap_team_role_user_name__c = 'Acompanante' LIMIT 1];
		Final Integer aptSize = apts.size();
		System.assertEquals(aptSize, 0, fail);
	}

	/**
	 * @Description Test method validateUserPermission AP Expired
	 */
	public static testmethod void beforeDMLInsertExpired() {
		Final Account acc = [SELECT Id FROM Account LIMIT 1];
		Final acpl__Account_Planning__c ap = TestFactory.createAccountPlanning(acc.Id, mapUsers.get('EJECUTIVO').Id, null, false);
		insert ap;
		ap.acpl__gf_ap_status_type_name__c = 'Not started';
		ap.acpl__gf_ap_substatus_type_name__c = 'Expired';
		update ap;
		Test.startTest();
		System.runAs(mapUsers.get('EJECUTIVO')) {
			try {
				Final bupl__AP_Team__c apt = new bupl__AP_Team__c(acpl__gf_account_planning_id__c = ap.Id, Name = 'APT MEMBER', bupl__gf_ap_team_role_user_name__c = 'Acompanante',
				                                                  bupl__gf_ap_team_user_id__c = mapUsers.get('MANAGER').Id);
				insert apt;
			} catch(Exception e) {
				System.debug(e.getMessage());
			}
		}
		Test.stopTest();
		Final bupl__AP_Team__c[] apts = [SELECT Id FROM bupl__AP_Team__c where acpl__gf_account_planning_id__c =:ap.Id AND bupl__gf_ap_team_role_user_name__c = 'Acompanante' LIMIT 1];
		Final Integer aptSize = apts.size();
		System.assertEquals(aptSize, 0, fail);
	}

	/**
	 * @Description Test method validateUserPermission AP Expired
	 */
	public static testmethod void beforeDMLInsertInvalidUser() {
		Final Account acc = [SELECT Id FROM Account LIMIT 1];
		Final acpl__Account_Planning__c ap = TestFactory.createAccountPlanning(acc.Id, mapUsers.get('EJECUTIVO').Id, null, true);
		insert ap;
		Test.startTest();
		System.runAs(mapUsers.get('MANAGER')) {
			try {
				Final bupl__AP_Team__c apt = new bupl__AP_Team__c(acpl__gf_account_planning_id__c = ap.Id, Name = 'APT MEMBER', bupl__gf_ap_team_role_user_name__c = 'Acompanante',
				                                                  bupl__gf_ap_team_user_id__c = mapUsers.get('MANAGER').Id);
				insert apt;
			} catch(Exception e) {
				System.debug(e.getMessage());
			}
		}
		Test.stopTest();
		Final bupl__AP_Team__c[] apts = [SELECT Id FROM bupl__AP_Team__c where acpl__gf_account_planning_id__c =:ap.Id AND bupl__gf_ap_team_role_user_name__c = 'Acompanante' LIMIT 1];
		Final Integer aptSize = apts.size();
		System.assertEquals(aptSize, 0, fail);
	}

	/**
	 * @Description Test method putErrorInvalidUser() in CheckAPT()
	 */
	public static testmethod void checkAPTInvalidUser() {
		Final Account acc = [SELECT Id FROM Account LIMIT 1];
		Final acpl__Account_Planning__c ap = TestFactory.createAccountPlanning(acc.Id, mapUsers.get('EJECUTIVO').Id, null, true);
		insert ap;
		Final bupl__AP_Team__c aptAux = new bupl__AP_Team__c(acpl__gf_account_planning_id__c = ap.Id, Name = 'APT MEMBER', bupl__gf_ap_team_role_user_name__c = 'Acompanante',
		                                                     bupl__gf_ap_team_user_id__c = mapUsers.get('MANAGER').Id);
		insert aptAux;
		Test.startTest();
		System.runAs(mapUsers.get('MANAGER')) {
			try {
				Final bupl__AP_Team__c apt = new bupl__AP_Team__c(acpl__gf_account_planning_id__c = ap.Id, Name = 'APT MEMBER', bupl__gf_ap_team_role_user_name__c = 'Gestor del Plan',
				                                                  bupl__gf_ap_team_user_id__c = mapUsers.get('GERENTE').Id);
				insert apt;
			} catch(Exception e) {
				System.debug(e.getMessage());
			}
		}
		Test.stopTest();
		Final bupl__AP_Team__c[] apts = [SELECT Id FROM bupl__AP_Team__c where acpl__gf_account_planning_id__c =:ap.Id AND bupl__gf_ap_team_role_user_name__c = 'Gestor del Plan'];
		Final Integer aptSize = apts.size();
		System.assertEquals(aptSize, 1, fail);
	}

	/**
	 * @Description Test method putErrorInvalidGestor() in CheckAPT()
	 */
	public static testmethod void checkAPTInvalidGestor() {
		Final Account acc = [SELECT Id FROM Account LIMIT 1];
		Final acpl__Account_Planning__c ap = TestFactory.createAccountPlanning(acc.Id, mapUsers.get('EJECUTIVO').Id, null, true);
		insert ap;
		Final bupl__AP_Team__c aptAux = new bupl__AP_Team__c(acpl__gf_account_planning_id__c = ap.Id, Name = 'APT MEMBER', bupl__gf_ap_team_role_user_name__c = 'Gestor del Plan',
		                                                     bupl__gf_ap_team_user_id__c = mapUsers.get('MANAGER').Id);
		insert aptAux;
		Test.startTest();
		System.runAs(mapUsers.get('MANAGER')) {
			try {
				Final bupl__AP_Team__c apt = new bupl__AP_Team__c(acpl__gf_account_planning_id__c = ap.Id, Name = 'APT MEMBER', bupl__gf_ap_team_role_user_name__c = 'Gestor del Plan',
				                                                  bupl__gf_ap_team_user_id__c = mapUsers.get('GERENTE').Id);
				insert apt;
			} catch(Exception e) {
				System.debug(e.getMessage());
			}
		}
		Test.stopTest();
		Final bupl__AP_Team__c[] apts = [SELECT Id FROM bupl__AP_Team__c where acpl__gf_account_planning_id__c =:ap.Id AND bupl__gf_ap_team_role_user_name__c = 'Gestor del Plan' LIMIT 1];
		Final Integer aptSize = apts.size();
		System.assertEquals(aptSize, 1, fail);
	}

	/**
	 * @Description Test method putErrorMemberInAPT() in CheckAPT()
	 */
	public static testmethod void checkAPTInvalidMember() {
		Final Account acc = [SELECT Id FROM Account LIMIT 1];
		Final acpl__Account_Planning__c ap = TestFactory.createAccountPlanning(acc.Id, mapUsers.get('EJECUTIVO').Id, null, true);
		insert ap;
		Test.startTest();
		System.runAs(mapUsers.get('EJECUTIVO')) {
			try {
				Final bupl__AP_Team__c apt = new bupl__AP_Team__c(acpl__gf_account_planning_id__c = ap.Id, Name = 'APT MEMBER', bupl__gf_ap_team_role_user_name__c = 'Gestor del Plan',
				                                                  bupl__gf_ap_team_user_id__c = mapUsers.get('EJECUTIVO').Id);
				insert apt;
			} catch(Exception e) {
				System.debug(e.getMessage());
			}
		}
		Test.stopTest();
		Final bupl__AP_Team__c[] apts = [SELECT Id FROM bupl__AP_Team__c where acpl__gf_account_planning_id__c =:ap.Id AND bupl__gf_ap_team_role_user_name__c = 'Gestor del Plan' LIMIT 1];
		Final Integer aptSize = apts.size();
		System.assertEquals(aptSize, 1, fail);
	}

	/**
	 * @Description Test method validateUserPermission() in update
	 */
	public static testmethod void updateValidateUserPermission() {
		Final Account acc = [SELECT Id FROM Account LIMIT 1];
		Final acpl__Account_Planning__c ap = TestFactory.createAccountPlanning(acc.Id, mapUsers.get('EJECUTIVO').Id, null, false);
		insert ap;
		Final bupl__AP_Team__c apt = [SELECT Id, bupl__gf_ap_team_new_member_date__c FROM bupl__AP_Team__c WHERE acpl__gf_account_planning_id__c =:ap.Id LIMIT 1];
		Final Date fecha = apt.bupl__gf_ap_team_new_member_date__c;
		Test.startTest();
		System.runAs(mapUsers.get('MANAGER')) {
			try {
				apt.bupl__gf_ap_team_new_member_date__c = System.today();
				update apt;
			} catch(Exception e) {
				System.debug(e.getMessage());
			}
		}
		Test.stopTest();
		Final bupl__AP_Team__c aptAux = [SELECT Id, bupl__gf_ap_team_new_member_date__c FROM bupl__AP_Team__c WHERE acpl__gf_account_planning_id__c =:ap.Id LIMIT 1];
		System.assertEquals(fecha, aptAux.bupl__gf_ap_team_new_member_date__c, fail);
	}

	/**
	 * @Description Test method deleteOwnAPT() in CheckAPT()
	 */
	public static testmethod void deleteOwnAPT() {
		Final Account acc = [SELECT Id FROM Account LIMIT 1];
		Final acpl__Account_Planning__c ap = TestFactory.createAccountPlanning(acc.Id, mapUsers.get('EJECUTIVO').Id, null, true);
		insert ap;
		Final bupl__AP_Team__c aptAux = [SELECT Id FROM bupl__AP_Team__c WHERE acpl__gf_account_planning_id__c =: ap.Id LIMIT 1];
		Test.startTest();
		System.runAs(mapUsers.get('EJECUTIVO')) {
			try {
				delete aptAux;
			} catch(Exception e) {
				System.debug(e.getMessage());
			}
		}
		Test.stopTest();
		Final bupl__AP_Team__c[] apts = [SELECT Id FROM bupl__AP_Team__c where acpl__gf_account_planning_id__c =:ap.Id];
		Final Integer aptSize = apts.size();
		System.assertEquals(aptSize, 1, fail);
	}

	/**
	 * @Description Test method deleteOwnAPT() in CheckAPT()
	 */
	public static testmethod void deleteAPTInvalidUser() {
		Final Account acc = [SELECT Id FROM Account LIMIT 1];
		Final acpl__Account_Planning__c ap = TestFactory.createAccountPlanning(acc.Id, mapUsers.get('EJECUTIVO').Id, null, true);
		insert ap;
		Final bupl__AP_Team__c apt = new bupl__AP_Team__c(acpl__gf_account_planning_id__c = ap.Id, Name = 'APT MEMBER', bupl__gf_ap_team_role_user_name__c = 'Acompanante',
		                                                  bupl__gf_ap_team_user_id__c = mapUsers.get('MANAGER').Id);
		insert apt;
		Final bupl__AP_Team__c aptAux = [SELECT Id FROM bupl__AP_Team__c WHERE acpl__gf_account_planning_id__c =: ap.Id LIMIT 1];
		Test.startTest();
		System.runAs(mapUsers.get('MANAGER')) {
			try {
				delete aptAux;
			} catch(Exception e) {
				System.debug(e.getMessage());
			}
		}
		Test.stopTest();
		Final bupl__AP_Team__c[] apts = [SELECT Id FROM bupl__AP_Team__c where acpl__gf_account_planning_id__c =:ap.Id ];
		Final Integer aptSize = apts.size();
		System.assertEquals(aptSize, 2, fail);
	}

	/**
	 * @Description Test method putErrorDeleteGestor() in CheckAPT()
	 */
	public static testmethod void deleteMainGestor() {
		Final Account acc = [SELECT Id FROM Account LIMIT 1];
		Final acpl__Account_Planning__c ap = TestFactory.createAccountPlanning(acc.Id, mapUsers.get('EJECUTIVO').Id, null, true);
		insert ap;
		Final bupl__AP_Team__c apt = new bupl__AP_Team__c(acpl__gf_account_planning_id__c = ap.Id, Name = 'APT MEMBER', bupl__gf_ap_team_role_user_name__c = 'Gestor del Plan',
		                                                  bupl__gf_ap_team_user_id__c = mapUsers.get('MANAGER').Id);
		insert apt;
		Final bupl__AP_Team__c aptAux = [SELECT Id FROM bupl__AP_Team__c WHERE acpl__gf_account_planning_id__c =: ap.Id LIMIT 1];
		Test.startTest();
		System.runAs(mapUsers.get('MANAGER')) {
			try {
				delete aptAux;
			} catch(Exception e) {
				System.debug(e.getMessage());
			}
		}
		Test.stopTest();
		Final bupl__AP_Team__c[] apts = [SELECT Id FROM bupl__AP_Team__c where acpl__gf_account_planning_id__c =:ap.Id ];
		Final Integer aptSize = apts.size();
		System.assertEquals(aptSize, 2, fail);
	}

	/**
	 * @Description Test method
	 */
	public static testmethod void deleteBPAndAPTSharing() {
		Final Account acc = [SELECT Id FROM Account LIMIT 1];
		Final acpl__Account_Planning__c ap = TestFactory.createAccountPlanning(acc.Id, mapUsers.get('EJECUTIVO').Id, null, true);
		insert ap;
		Final bupl__AP_Team__c apt = new bupl__AP_Team__c(acpl__gf_account_planning_id__c = ap.Id, Name = 'APT MEMBER', bupl__gf_ap_team_role_user_name__c = 'Acompanante',
		                                                  bupl__gf_ap_team_user_id__c = mapUsers.get('MANAGER').Id);
		insert apt;
		Test.startTest();
		System.runAs(mapUsers.get('EJECUTIVO')) {
			try {
				delete apt;
			} catch(Exception e) {
				System.debug(e.getMessage());
			}
		}
		Test.stopTest();
		Final bupl__BusinessPlan__c bp = [SELECT Id FROM bupl__BusinessPlan__c WHERE acpl__gf_account_planning_id__c =:ap.Id LIMIT 1];
		Final acpl__Account_Planning__Share[] sharingAP = [SELECT Id, UserOrGroup.Name FROM acpl__Account_Planning__Share WHERE parentId =:ap.Id];
		Final bupl__BusinessPlan__Share[] sharingBP = [SELECT Id, UserOrGroup.Name FROM bupl__BusinessPlan__Share WHERE parentId =:bp.Id];
		Final Integer sharingAPSize = sharingAP.size();
		Final Integer sharingBPSize = sharingBP.size();
		System.assertEquals(sharingAPSize, 2, fail);
		System.assertEquals(sharingBPSize, 2, fail);
	}
}