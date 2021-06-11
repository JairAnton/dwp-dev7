/**
 * AP_Team_Helper_tst
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
public class AP_Team_Helper_tst {

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
	/**
	 * @Description method setUp
	 */
	@TestSetup
	static void setUp() {
		AP_FactoryTest_tst.forSetUp();
	}
    
    /**
	 * @Description Test method putErrorMemberInAPT() in CheckAPT()
	 */
	public static testmethod void checkAPTInvalidMember() {
		Final Account acc = [SELECT Id FROM Account LIMIT 1];
		Final acpl__Account_Planning__c accPlan = AP_FactoryTest_tst.createAccountPlanning(acc.Id, MAPUSERS.get(EJECUTIVO).Id, null, true);
		insert accPlan;
		Test.startTest();
		System.runAs(MAPUSERS.get(EJECUTIVO)) {
			try {
				Final bupl__AP_Team__c apt = new bupl__AP_Team__c(acpl__gf_account_planning_id__c = accPlan.Id, Name = APT_MEMBER, bupl__gf_ap_team_role_user_name__c = GESTOR,
				                                                  bupl__gf_ap_team_user_id__c = MAPUSERS.get(EJECUTIVO).Id);
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

	/**
	 * @Description Test method validateUserPermission() in update
	 */
	public static testmethod void updateValidateUserPermission() {
		Final Account acc = [SELECT Id FROM Account LIMIT 1];
		Final acpl__Account_Planning__c accPlan = AP_FactoryTest_tst.createAccountPlanning(acc.Id, MAPUSERS.get(EJECUTIVO).Id, null, true);
		insert accPlan;
		Final bupl__AP_Team__c apt = [SELECT Id, bupl__gf_ap_team_new_member_date__c FROM bupl__AP_Team__c WHERE acpl__gf_account_planning_id__c =:accPlan.Id LIMIT 1];
		Final Date fecha = apt.bupl__gf_ap_team_new_member_date__c;
		Test.startTest();
		System.runAs(MAPUSERS.get(MANAGER)) {
			try {
                accPlan.ACPL__GF_AP_INDVI_LOCK_EDIT_IND_TYPE__C = false;
                update accPlan;
				apt.bupl__gf_ap_team_new_member_date__c = System.today();
				update apt;
			} catch(Exception e) {
				System.debug(e.getMessage());
			}
		}
		Test.stopTest();
		Final bupl__AP_Team__c aptAux = [SELECT Id, bupl__gf_ap_team_new_member_date__c FROM bupl__AP_Team__c WHERE acpl__gf_account_planning_id__c =:accPlan.Id LIMIT 1];
		System.assertEquals(fecha, aptAux.bupl__gf_ap_team_new_member_date__c, FAIL);
	}

	/**
	 * @Description Test method deleteOwnAPT() in CheckAPT()
	 */
	public static testmethod void deleteOwnAPT() {
		Final Account acc = [SELECT Id FROM Account LIMIT 1];
		Final acpl__Account_Planning__c accPlan = AP_FactoryTest_tst.createAccountPlanning(acc.Id, MAPUSERS.get(EJECUTIVO).Id, null, true);
		insert accPlan;
		Final bupl__AP_Team__c aptAux = [SELECT Id FROM bupl__AP_Team__c WHERE acpl__gf_account_planning_id__c =: accPlan.Id LIMIT 1];
		Test.startTest();
		System.runAs(MAPUSERS.get(EJECUTIVO)) {
			try {
				delete aptAux;
			} catch(Exception e) {
				System.debug(e.getMessage());
			}
		}
		Test.stopTest();
		Final bupl__AP_Team__c[] apts = [SELECT Id FROM bupl__AP_Team__c where acpl__gf_account_planning_id__c =:accPlan.Id];
		Final Integer aptSize = apts.size();
		System.assertEquals(aptSize, 1, FAIL);
	}

	/**
	 * @Description Test method deleteOwnAPT() in CheckAPT()
	 */
	public static testmethod void deleteAPTInvalidUser() {
		Final Account acc = [SELECT Id FROM Account LIMIT 1];
		Final acpl__Account_Planning__c accPlan = AP_FactoryTest_tst.createAccountPlanning(acc.Id, MAPUSERS.get(EJECUTIVO).Id, null, true);
		insert accPlan;
        Test.startTest();
		Final bupl__AP_Team__c apt = new bupl__AP_Team__c(acpl__gf_account_planning_id__c = accPlan.Id, Name = APT_MEMBER, bupl__gf_ap_team_role_user_name__c = Acompanante,
		                                                  bupl__gf_ap_team_user_id__c = MAPUSERS.get(MANAGER).Id);
		insert apt;
		Final bupl__AP_Team__c aptAux = [SELECT Id FROM bupl__AP_Team__c WHERE acpl__gf_account_planning_id__c =: accPlan.Id LIMIT 1];
		
		System.runAs(MAPUSERS.get(MANAGER)) {
			try {
				delete aptAux;
			} catch(Exception e) {
				System.debug(e.getMessage());
			}
		}
		Test.stopTest();
		Final bupl__AP_Team__c[] apts = [SELECT Id FROM bupl__AP_Team__c where acpl__gf_account_planning_id__c =:accPlan.Id ];
		Final Integer aptSize = apts.size();
		System.assertEquals(aptSize, 2, FAIL);
	}

	/**
	 * @Description Test method putErrorDeleteGestor() in CheckAPT()
	 */
	public static testmethod void deleteMainGestor() {
		Final Account acc = [SELECT Id FROM Account LIMIT 1];
		Final acpl__Account_Planning__c accPlan = AP_FactoryTest_tst.createAccountPlanning(acc.Id, MAPUSERS.get(EJECUTIVO).Id, null, true);
		insert accPlan;
        Test.startTest();
		Final bupl__AP_Team__c apt = new bupl__AP_Team__c(acpl__gf_account_planning_id__c = accPlan.Id, Name = APT_MEMBER, bupl__gf_ap_team_role_user_name__c = GESTOR,
		                                                  bupl__gf_ap_team_user_id__c = MAPUSERS.get(MANAGER).Id);
		insert apt;
		Final bupl__AP_Team__c aptAux = [SELECT Id FROM bupl__AP_Team__c WHERE acpl__gf_account_planning_id__c =: accPlan.Id LIMIT 1];
		
		System.runAs(MAPUSERS.get(MANAGER)) {
			try {
				delete aptAux;
			} catch(Exception e) {
				System.debug(e.getMessage());
			}
		}
		Test.stopTest();
		Final bupl__AP_Team__c[] apts = [SELECT Id FROM bupl__AP_Team__c where acpl__gf_account_planning_id__c =:accPlan.Id ];
		Final Integer aptSize = apts.size();
		System.assertEquals(aptSize, 2, FAIL);
	}

	/**
	 * @Description Test method
	 */
	public static testmethod void deleteBPAndAPTSharing() {
		Final Account acc = [SELECT Id FROM Account LIMIT 1];
		Final acpl__Account_Planning__c accPlan = AP_FactoryTest_tst.createAccountPlanning(acc.Id, MAPUSERS.get(EJECUTIVO).Id, null, true);
		insert accPlan;
        Test.startTest();
		Final bupl__AP_Team__c apt = new bupl__AP_Team__c(acpl__gf_account_planning_id__c = accPlan.Id, Name = APT_MEMBER, bupl__gf_ap_team_role_user_name__c = Acompanante,
		                                                  bupl__gf_ap_team_user_id__c = MAPUSERS.get(MANAGER).Id);
		insert apt;
		
		System.runAs(MAPUSERS.get(EJECUTIVO)) {
			try {
				delete apt;
			} catch(Exception e) {
				System.debug(e.getMessage());
			}
		}
		Test.stopTest();
		Final acpl__Account_Planning__Share[] sharingAP = [SELECT Id, UserOrGroup.Name FROM acpl__Account_Planning__Share WHERE parentId =:accPlan.Id];
		Final Integer sharingAPSize = sharingAP.size();
        System.assertEquals(sharingAPSize, 3, FAIL);
	}
}