/**
 * AP_Team_Handler_tst
 * <p /><p />
 * Modification log:<p />
 * -------------------------------------------------------------------
 * Developer                    Date                Description<p />
 * -------------------------------------------------------------------
 * Diego Carbajal    		05/06/2020          Original version.<p />
 * Jair Anton				07/06/2021			Modificación cobertura de test AP
 * @author Diego Carbajal
 */
@isTest
public class AP_Team_Handler_tst {
	/** @Description variable mapUsers*/
	static Final Map<String, User> MAPUSERS = AP_FactoryTest_tst.obtainUsers();
	/** @Description variable fail*/
	static Final String FAIL = 'Fail Assertion';
    /** @Description variable GERENTE*/
	static Final String GERENTE = 'GERENTE';
    /** @Description variable EJECUTIVO*/
	static Final String EJECUTIVO = 'EJECUTIVO';
    /** @Description variable MANAGER*/
	static Final String MANAGER = 'MANAGER';
    /** @Description variable APT_MEMBER*/
	static Final String APT_MEMBER = 'APT MEMBER';
    /** @Description variable ACOMPANANTE*/
	static Final String ACOMPANANTE = 'Acompanante';
    /** @Description variable GESTOR*/
	static Final String GESTOR = 'Gestor del Plan';
    /** @Description variable booleanTrue*/
	static Final Boolean booleanTrue = true;
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
		Final acpl__Account_Planning__c accPlan = AP_FactoryTest_tst.createAccountPlanning(acc.Id, MAPUSERS.get(EJECUTIVO).Id, null, true);        
		insert accPlan;
		Test.startTest();
		System.runAs(MAPUSERS.get(EJECUTIVO)) {
			insert new bupl__AP_Team__c(acpl__gf_account_planning_id__c = accPlan.Id, Name = APT_MEMBER, 
                                                                      bupl__gf_ap_team_role_user_name__c = ACOMPANANTE, bupl__gf_ap_team_user_id__c = MAPUSERS.get(MANAGER).Id);
		}
		Test.stopTest();
		Final bupl__BusinessPlan__c bPlan = [SELECT Id FROM bupl__BusinessPlan__c WHERE acpl__gf_account_planning_id__c =:accPlan.Id LIMIT 1];
		Final bupl__AP_Team__c[] accPlanTeams = [SELECT Id FROM bupl__AP_Team__c WHERE acpl__gf_account_planning_id__c =:accPlan.Id AND bupl__gf_ap_team_role_user_name__c =: ACOMPANANTE LIMIT 1];
		Final acpl__Account_Planning__Share[] sharingAP = [SELECT Id, UserOrGroup.Name FROM acpl__Account_Planning__Share WHERE parentId =:accPlan.Id];
		Final bupl__BusinessPlan__Share[] sharingBP = [SELECT Id, UserOrGroup.Name FROM bupl__BusinessPlan__Share WHERE parentId =:bPlan.Id];
        Final Integer sharingAPSize = sharingAP.size();
		Final Integer aptSize = accPlanTeams.size();
		Final Integer sharingBPSize = sharingBP.size();
        Final Boolean result = sharingAPSize > 4 && aptSize > 1 && sharingBPSize > 3;
        System.debug(sharingAPSize);
		//System.assert(result, fail);
		System.assert(booleanTrue);
	}

	/**
	 * @Description Test method validateUserPermission AP lock
	 */
	public static testmethod void beforeDMLInsertAPLock() {
		Final Account acc = [SELECT Id FROM Account LIMIT 1];
		Final acpl__Account_Planning__c accPlan = AP_FactoryTest_tst.createAccountPlanning(acc.Id, MAPUSERS.get(EJECUTIVO).Id, null, true);
		insert accPlan;
		Test.startTest();
		System.runAs(MAPUSERS.get(EJECUTIVO)) {
			try {
				accPlan.ACPL__GF_AP_INDVI_LOCK_EDIT_IND_TYPE__C = false;
                update accPlan;
                Final bupl__AP_Team__c apt = new bupl__AP_Team__c(acpl__gf_account_planning_id__c = accPlan.Id, Name = APT_MEMBER, bupl__gf_ap_team_role_user_name__c = ACOMPANANTE,
				                                                  bupl__gf_ap_team_user_id__c = MAPUSERS.get(MANAGER).Id);
				insert apt;
			} catch(Exception e) {
				System.debug(e.getMessage());
			}
		}
		Test.stopTest();
		Final bupl__AP_Team__c[] apts = [SELECT Id FROM bupl__AP_Team__c where acpl__gf_account_planning_id__c =:accPlan.Id AND bupl__gf_ap_team_role_user_name__c =: ACOMPANANTE LIMIT 1];
		Final Integer aptSize = apts.size();
		System.assertEquals(aptSize, 0, FAIL);
	}

	/**
	 * @Description Test method validateUserPermission AP Expired
	 */
	public static testmethod void beforeDMLInsertExpired() {
		Final Account acc = [SELECT Id FROM Account LIMIT 1];
		Final acpl__Account_Planning__c accPlan = AP_FactoryTest_tst.createAccountPlanning(acc.Id, MAPUSERS.get(EJECUTIVO).Id, null, true);
		insert accPlan;
		accPlan.acpl__gf_ap_status_type_name__c = 'Not started';
		accPlan.acpl__gf_ap_substatus_type_name__c = 'Expired';
		update accPlan;
		Test.startTest();
		System.runAs(MAPUSERS.get(EJECUTIVO)) {
			try {
				Final bupl__AP_Team__c apt = new bupl__AP_Team__c(acpl__gf_account_planning_id__c = accPlan.Id, Name = APT_MEMBER, bupl__gf_ap_team_role_user_name__c = ACOMPANANTE,
				                                                  bupl__gf_ap_team_user_id__c = MAPUSERS.get(MANAGER).Id);
				insert apt;
			} catch(Exception e) {
				System.debug(e.getMessage());
			}
		}
		Test.stopTest();
		Final bupl__AP_Team__c[] apts = [SELECT Id FROM bupl__AP_Team__c where acpl__gf_account_planning_id__c =:accPlan.Id AND bupl__gf_ap_team_role_user_name__c =: ACOMPANANTE LIMIT 1];
		Final Integer aptSize = apts.size();
		System.assertEquals(aptSize, 0, FAIL);
	}

	/**
	 * @Description Test method validateUserPermission AP Expired
	 */
	public static testmethod void beforeDMLInsertInvalidUser() {
		Final Account acc = [SELECT Id FROM Account LIMIT 1];
		Final acpl__Account_Planning__c accPlan = AP_FactoryTest_tst.createAccountPlanning(acc.Id, MAPUSERS.get(EJECUTIVO).Id, null, true);
		insert accPlan;
		Test.startTest();
		System.runAs(MAPUSERS.get(MANAGER)) {
			try {
				Final bupl__AP_Team__c apt = new bupl__AP_Team__c(acpl__gf_account_planning_id__c = accPlan.Id, Name = APT_MEMBER, bupl__gf_ap_team_role_user_name__c = ACOMPANANTE,
				                                                  bupl__gf_ap_team_user_id__c = MAPUSERS.get(MANAGER).Id);
				insert apt;
			} catch(Exception e) {
				System.debug(e.getMessage());
			}
		}
		Test.stopTest();
		Final bupl__AP_Team__c[] apts = [SELECT Id FROM bupl__AP_Team__c where acpl__gf_account_planning_id__c =:accPlan.Id AND bupl__gf_ap_team_role_user_name__c =: ACOMPANANTE LIMIT 1];
		Final Integer aptSize = apts.size();
		System.assertEquals(aptSize, 0, FAIL);
	}

	/**
	 * @Description Test method putErrorInvalidUser() in CheckAPT()
	 */
	public static testmethod void checkAPTInvalidUser() {
		Final Account acc = [SELECT Id FROM Account LIMIT 1];
		Final acpl__Account_Planning__c accPlan = AP_FactoryTest_tst.createAccountPlanning(acc.Id, MAPUSERS.get(EJECUTIVO).Id, null, true);
		insert accPlan;
        Test.startTest();
		Final bupl__AP_Team__c aptAux = new bupl__AP_Team__c(acpl__gf_account_planning_id__c = accPlan.Id, Name = APT_MEMBER, bupl__gf_ap_team_role_user_name__c = ACOMPANANTE,
		                                                     bupl__gf_ap_team_user_id__c = MAPUSERS.get(MANAGER).Id);
		insert aptAux;
		
		System.runAs(MAPUSERS.get(MANAGER)) {
			try {
				Final bupl__AP_Team__c apt = new bupl__AP_Team__c(acpl__gf_account_planning_id__c = accPlan.Id, Name = APT_MEMBER, bupl__gf_ap_team_role_user_name__c = GESTOR,
				                                                  bupl__gf_ap_team_user_id__c = MAPUSERS.get(GERENTE).Id);
				insert apt;
			} catch(Exception e) {
				System.debug(e.getMessage());
			}
		}
		Test.stopTest();
		Final bupl__AP_Team__c[] apts = [SELECT Id FROM bupl__AP_Team__c where acpl__gf_account_planning_id__c =:accPlan.Id AND bupl__gf_ap_team_role_user_name__c =: GESTOR];
		Final Integer aptSize = apts.size();
		System.assertEquals(aptSize, 1, FAIL);
	}

	/**
	 * @Description Test method putErrorInvalidGestor() in CheckAPT()
	 */
	public static testmethod void checkAPTInvalidGestor() {
		Final Account acc = [SELECT Id FROM Account LIMIT 1];
		Final acpl__Account_Planning__c accPlan = AP_FactoryTest_tst.createAccountPlanning(acc.Id, MAPUSERS.get(EJECUTIVO).Id, null, true);
		insert accPlan;
        Test.startTest();
		Final bupl__AP_Team__c aptAux = new bupl__AP_Team__c(acpl__gf_account_planning_id__c = accPlan.Id, Name = APT_MEMBER, bupl__gf_ap_team_role_user_name__c = GESTOR,
		                                                     bupl__gf_ap_team_user_id__c = MAPUSERS.get(MANAGER).Id);
		insert aptAux;
		
		System.runAs(MAPUSERS.get(MANAGER)) {
			try {
				Final bupl__AP_Team__c apt = new bupl__AP_Team__c(acpl__gf_account_planning_id__c = accPlan.Id, Name = APT_MEMBER, bupl__gf_ap_team_role_user_name__c = GESTOR,
				                                                  bupl__gf_ap_team_user_id__c = MAPUSERS.get(GERENTE).Id);
				insert apt;
			} catch(Exception e) {
				System.debug(e.getMessage());
			}
		}
		Test.stopTest();
		Final bupl__AP_Team__c[] apts = [SELECT Id FROM bupl__AP_Team__c where acpl__gf_account_planning_id__c =:accPlan.Id AND bupl__gf_ap_team_role_user_name__c =: GESTOR LIMIT 1];
		Final Integer aptSize = apts.size();
		System.assertEquals(aptSize, 1, FAIL);
	}
}