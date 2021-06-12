/**
* ------------------------------------------------------------------------------------------------
* @Name AP_Handler_Helper_tst
* @Author Diego Carbajal diego.carbajal@bbva.com
* @Date Created: 2020-05-01
* @Group 
* @Description AP_Handler_Helper_tst
* Jair Anton		07/06/2021			Modificación cobertura de test AP
*/
@isTest
public class AP_Handler_Helper_tst {

    /**
	 * @Description MAP_USERS
	 */
	static Final Map<String, User> MAP_USERS = AP_FactoryTest_tst.obtainUsers();
    /** @Description EJECUTIVO*/
	static Final String EJECUTIVO = 'EJECUTIVO';
    /** @Description MANAGER*/
    static Final String MANAGER = 'MANAGER';
    /**@Description GERENTE*/
    static Final String GERENTE = 'GERENTE';
    /**@Description PENDING_VALID */
    static Final String PENDING_VALID = 'Pending Validation';
    /**@Description VALIDATED*/
    static Final String VALIDATED = 'Validated';
    /** @Description FAIL*/
    static Final String FAIL = 'FAIL';
    /** @Description FAIL*/
    static Final String COMENTARIOS = 'Comentarios';
    /**
	 * @Description CASE_RT
	 */
	Final static Id CASE_RT = [SELECT ID FROM RecordType WHERE developerName = 'Account_Plan_Validation' LIMIT 1].Id;
	/*
	 * @author 		Global Desktop
	 * @Description  AP questions creation
	 */
	@TestSetup
	static void setUp() {
		AP_FactoryTest_tst.forSetUp();
	}

	/**
	 * @Description Teste las funcionalidades changeValidatorAPInvalidUser:
	 * 	Invalid User change Validator
	 */
	public static testmethod void changeValidatorAPInvalidUser() {
		Final Account acc = [SELECT Id FROM Account LIMIT 1];
		final acpl__Account_Planning__c apR = AP_FactoryTest_tst.createAccountPlanning(acc.Id, MAP_USERS.get(EJECUTIVO).Id, null, true);
		insert apR;
        Test.startTest();
		Final acpl__Account_Planning__c apAux = [SELECT Id, acpl__gf_ap_validator_user_id__c, acpl__gf_ap_status_type_name__c, acpl__gf_ap_substatus_type_name__c
		                                         FROM acpl__Account_Planning__c WHERE Id =:apR.Id];
		apAux.acpl__gf_ap_status_type_name__c = PENDING_VALID;
		apAux.acpl__gf_ap_req_validation_ind_type__c = 'Yes';
		update apAux;
		Final String validator = apAux.acpl__gf_ap_validator_user_id__c;
		
		System.runAs(MAP_USERS.get(MANAGER)) {
			try {
                apR.ACPL__GF_AP_INDVI_LOCK_EDIT_IND_TYPE__C = false;
                update apR;
				apAux.acpl__gf_ap_validator_user_id__c = MAP_USERS.get(MANAGER).Id;
				update apAux;
			} catch(Exception e) {
				System.debug(e.getMessage());
			}
		}
		Test.stopTest();
		Final acpl__Account_Planning__c apResult = [SELECT Id, acpl__gf_ap_validator_user_id__c FROM acpl__Account_Planning__c WHERE Id =:apR.Id];
		System.assertEquals(apResult.acpl__gf_ap_validator_user_id__c, validator, FAIL);
	}

	/**
	 * @Description Teste las funcionalidades changeValidatorAPInvalidUser:
	 * 	Validator change new validator without case
	 */
	public static testmethod void changeValidatorAPWithoutCase() {
		Final Account acc = [SELECT Id FROM Account LIMIT 1];
		final acpl__Account_Planning__c apR = AP_FactoryTest_tst.createAccountPlanning(acc.Id, MAP_USERS.get(EJECUTIVO).Id, null, true);
		insert apR;
        Test.startTest();
		Final acpl__Account_Planning__c apAux = [SELECT Id, acpl__gf_ap_validator_user_id__c, acpl__gf_ap_status_type_name__c, acpl__gf_ap_substatus_type_name__c
		                                         FROM acpl__Account_Planning__c WHERE Id =:apR.Id];
		apAux.acpl__gf_ap_status_type_name__c = PENDING_VALID;
		apAux.acpl__gf_ap_req_validation_ind_type__c = 'Yes';
		update apAux;
		Final String validator = apAux.acpl__gf_ap_validator_user_id__c;
		
		System.runAs(MAP_USERS.get(GERENTE)) {
			try {
				apR.ACPL__GF_AP_INDVI_LOCK_EDIT_IND_TYPE__C = false;
                update apR;
				apAux.acpl__gf_ap_validator_user_id__c = MAP_USERS.get(EJECUTIVO).Id;
				update apAux;
			} catch(Exception e) {
				System.debug(e.getMessage());
			}
		}
		Test.stopTest();
		Final acpl__Account_Planning__c apResult = [SELECT Id, acpl__gf_ap_validator_user_id__c FROM acpl__Account_Planning__c WHERE Id =:apR.Id];
		System.assertEquals(apResult.acpl__gf_ap_validator_user_id__c, validator, FAIL);
	}

	/**
	 * @Description Teste las funcionalidades changeValidatorAPNotStarted:
	 * 	Validator change in status Not started
	 */
	public static testmethod void changeValidatorAPNotStarted() {
		Final Account acc = [SELECT Id FROM Account LIMIT 1];
		final acpl__Account_Planning__c apR = AP_FactoryTest_tst.createAccountPlanning(acc.Id, MAP_USERS.get(EJECUTIVO).Id, null, true);
		insert apR;
        Test.startTest();
		Final acpl__Account_Planning__c apAux = [SELECT Id, acpl__gf_ap_validator_user_id__c FROM acpl__Account_Planning__c WHERE Id =:apR.Id LIMIT 1];
		Final String validator = apAux.acpl__gf_ap_validator_user_id__c;
		
		System.runAs(MAP_USERS.get(MANAGER)) {
			try {
				apAux.acpl__gf_ap_validator_user_id__c = MAP_USERS.get(MANAGER).Id;
				update apAux;
			} catch(Exception e) {
				System.debug(e.getMessage());
			}
		}
		Test.stopTest();
		Final acpl__Account_Planning__c apResult = [SELECT Id, acpl__gf_ap_validator_user_id__c FROM acpl__Account_Planning__c WHERE Id =:apR.Id];
		System.assertEquals(apResult.acpl__gf_ap_validator_user_id__c, validator, FAIL);
	}

	/**
	 * @Description Teste las funcionalidades changeValidatorAPInvalidUser:
	 * 	Invalid validator change new validator with case
	 */
	public static testmethod void changeValidatorAPWithCase() {
		Final Account acc = [SELECT Id FROM Account LIMIT 1];
		final acpl__Account_Planning__c apR = AP_FactoryTest_tst.createAccountPlanning(acc.Id, MAP_USERS.get(EJECUTIVO).Id, null, true);
		insert apR;
        Test.startTest();
		Final acpl__Account_Planning__c apAux = [SELECT Id, acpl__gf_ap_validator_user_id__c, acpl__gf_ap_status_type_name__c, acpl__gf_ap_substatus_type_name__c
		                                         FROM acpl__Account_Planning__c WHERE Id =:apR.Id];
		insert new Case(acpl__Account_plan_id__c = apAux.Id, recordTypeId = CASE_RT, Status = 'Request Sent For Review', OwnerId = MAP_USERS.get(GERENTE).Id);
		insert new Case(acpl__Account_plan_id__c = apAux.Id, recordTypeId = CASE_RT, Status = 'Request Re-Assigned', OwnerId = MAP_USERS.get(GERENTE).Id);
		Final String validator = apAux.acpl__gf_ap_validator_user_id__c;
		
		System.runAs(MAP_USERS.get(MANAGER)) {
			try {
                apAux.acpl__gf_ap_status_type_name__c = PENDING_VALID;
                apAux.acpl__gf_ap_req_validation_ind_type__c = 'Yes';
                apAux.ACPL__GF_AP_INDVI_LOCK_EDIT_IND_TYPE__C = false;
                update apAux;
				apAux.acpl__gf_ap_validator_user_id__c = MAP_USERS.get(EJECUTIVO).Id;
				update apAux;
			} catch(Exception e) {
				System.debug(e.getMessage());
			}
		}
		Test.stopTest();
		Final acpl__Account_Planning__c apResult = [SELECT Id, acpl__gf_ap_validator_user_id__c FROM acpl__Account_Planning__c WHERE Id =:apR.Id];
		System.assertEquals(apResult.acpl__gf_ap_validator_user_id__c, validator, FAIL);
	}

	/**
	 * @Description Teste las funcionalidades checkDeleteAP:
	 * 	Invalid User try to delete AP
	 */
	public static testmethod void checkDeleteAP() {
		Final Account acc = [SELECT Id FROM Account LIMIT 1];
		final acpl__Account_Planning__c apR = AP_FactoryTest_tst.createAccountPlanning(acc.Id, MAP_USERS.get(EJECUTIVO).Id, null, true);
		insert apR;
		Test.startTest();
		System.runAs(MAP_USERS.get(MANAGER)) {
			try {
				apR.ACPL__GF_AP_INDVI_LOCK_EDIT_IND_TYPE__C = false;
                update apR;
				delete apR;
			} catch(Exception e) {
				System.debug(e.getMessage());
			}
		}
		Test.stopTest();
		Final acpl__Account_Planning__c apResult = [SELECT Id, acpl__gf_ap_validator_user_id__c FROM acpl__Account_Planning__c WHERE Id =:apR.Id];
		System.assertNotEquals(apResult, null, FAIL);
	}

	/**
	 * @Description Teste las funcionalidades checkDeleteAP:
	 * 	Invalid User try to delete AP
	 */
	public static testmethod void deleteAP() {
		Final User admin = [SELECT Id FROM User WHERE Id =:UserInfo.getUserId() LIMIT 1];
		Final Account acc = [SELECT Id FROM Account LIMIT 1];
		final acpl__Account_Planning__c apR = AP_FactoryTest_tst.createAccountPlanning(acc.Id, MAP_USERS.get(EJECUTIVO).Id, null, true);
		insert apR;
		Test.startTest();
		System.runAs(admin) {
			apR.ACPL__GF_AP_INDVI_LOCK_EDIT_IND_TYPE__C = false;
            update apR;
            delete apR;
		}
		Test.stopTest();
		Final List<acpl__Account_Planning__c> apResult = [SELECT Id, acpl__gf_ap_validator_user_id__c FROM acpl__Account_Planning__c WHERE Id =:apR.Id];
		Final Integer apResultSize = apResult.size();
		System.assertEquals(apResultSize, 0, FAIL);
	}

	/**
	 * @Description Teste las funcionalidad postValidate:
	 * 	test method postValidate
	 */
	public static testmethod void postValidate() {
		Final Account acc = [SELECT Id FROM Account LIMIT 1];
		final acpl__Account_Planning__c apR = AP_FactoryTest_tst.createAccountPlanning(acc.Id, MAP_USERS.get(EJECUTIVO).Id, null, true);
		insert apR;
        Test.startTest();
		apR.acpl__gf_ap_status_type_name__c = VALIDATED;
		apR.acpl__gf_ap_substatus_type_name__c = 'In place';
		update apR;
		
		System.runAs(MAP_USERS.get(EJECUTIVO)) {
			try {
				apR.ACPL__GF_AP_INDVI_LOCK_EDIT_IND_TYPE__C = false;
                update apR;
				apR.acpl__gf_ap_status_type_name__c = VALIDATED;
				apR.acpl__gf_ap_substatus_type_name__c = 'In place';
				update apR;
			} catch(Exception e) {
				System.debug(e.getMessage());
			}
		}
		Test.stopTest();
		Final acpl__Account_Planning__c apResult = [SELECT Id, acpl__gf_ap_status_type_name__c FROM acpl__Account_Planning__c WHERE Id =:apR.Id];
		System.assertEquals(apResult.acpl__gf_ap_status_type_name__c, VALIDATED, FAIL);
	}
}