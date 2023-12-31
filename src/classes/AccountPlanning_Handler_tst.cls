/** @Name AccountPlanning_Handler_tst
* @Author Diego Carbajal diego.carbajal@bbva.com
* @Date Created: 2020-05-01
* @Description AccountPlanning_Handler_tst
* 				Methods in companion class AP_Handler_Helper_tst
* Jair Anton 		07/06/2021		 	Modificación Cobertura de Test AP
* Jair Anton 		11/08/2021		 	Add batch for related questions
*/
@isTest
public class AccountPlanning_Handler_tst {
    /** @Description MAP_USERS*/
	Final static Map<String, User> MAP_USERS = AP_FactoryTest_tst.obtainUsers();
    /** @Description CASE_RT*/
	Final static Id CASE_RT = [SELECT ID FROM RecordType WHERE developerName = 'Account_Plan_Validation' LIMIT 1].Id;
    /** @Description EJECUTIVO*/
	Final static String EJECUTIVO = 'EJECUTIVO';
    /** @Description FAIL*/
    Final static String FAIL = 'FAIL';
    /** @Description IN_PROGRESS*/
    Final static String IN_PROGRESS = 'In Progress';
    /** @Description MANAGER*/
    Final static String MANAGER = 'MANAGER';
    /**@Description PENDING_VALID */
    Final static String PENDING_VALID = 'Pending Validation';
    /**@Description PEND_VAL*/
    Final static String PEND_VAL = 'Pending validation';
    /**@Description YES*/
    Final static String YES = 'Yes';
    /**@Description GERENTE*/
    Final static String GERENTE = 'GERENTE';
    /**@Description VALIDATED*/
    Final static String VALIDATED = 'Validated';
    /**@Description NOT_STARTED*/
    Final static String NOT_STARTED = 'Not started';
	/**@Description variable handler*/
    private static Final acpl.AccountPlanningHandler AP_HANDLER = acpl.AccountPlanningHandler.getInstance();
    
	/*
	 * @author 		Global Desktop
	 * @Description  AP questions creation
	 */
	@TestSetup
	static void setUp() {
		AP_FactoryTest_tst.forSetUp();
	}

	/** @Description Test the functionalities of the methods: beforeInsert, afterInsert and relateAPQuestions*/
	public static testmethod void testMethod1() {
		Final Account acc = [SELECT Id FROM Account LIMIT 1];
		final acpl__Account_Planning__c accountPlanning1 = AP_FactoryTest_tst.createAccountPlanning(acc.Id, MAP_USERS.get(EJECUTIVO).Id, null, true);
		Test.startTest();
			insert accountPlanning1;
			Final List<acpl__Account_Planning__c> apList = [SELECT Id, Name, acpl__Account_Planning_Type__c, CreatedDate, acpl__gf_mandatory_type__c FROM acpl__Account_Planning__c 
                                                  WHERE CreatedDate = TODAY AND Name = 'Account Planning'];
        	AP_HANDLER.relateAPQuestions(apList);
		Test.stopTest();
		Final acpl__Account_Planning__c apR = [SELECT Id, acpl__gf_ap_question_form_number__c, acpl__gf_ap_validator_user_id__c FROM acpl__Account_Planning__c
		                                      WHERE Id =:accountPlanning1.Id];
		System.assertEquals(apR.acpl__gf_ap_question_form_number__c, 1, FAIL);
		System.assertNotEquals(apR.acpl__gf_ap_validator_user_id__c, null, FAIL);
	}

	/**
	 * @Description Teste las funcionalidades beforeDMLTest1: Locked AP
	 */
	public static testmethod void lockedAPTest() {
		Final Account acc = [SELECT Id FROM Account LIMIT 1];
		final acpl__Account_Planning__c apR = AP_FactoryTest_tst.createAccountPlanning(acc.Id, MAP_USERS.get(EJECUTIVO).Id, null, true);
		insert apR;
        Test.startTest();
        apR.ACPL__GF_AP_INDVI_LOCK_EDIT_IND_TYPE__C = false;
        update apR;
		
		System.runAs(MAP_USERS.get(EJECUTIVO)) {
			try {
				apR.acpl__gf_ap_status_type_name__c = IN_PROGRESS;
				update apR;
			} catch(Exception e) {
				System.debug(e.getMessage());
			}
		}
		Test.stopTest();
		Final acpl__Account_Planning__c apResult = [SELECT Id, acpl__gf_ap_status_type_name__c FROM acpl__Account_Planning__c WHERE Id =:apR.Id];
		System.assertEquals(apResult.acpl__gf_ap_status_type_name__c, NOT_STARTED, FAIL);
	}

	/**
	 * @Description Teste las funcionalidades invalidUserModify: Invalid User
	 */
	public static testmethod void invalidUserModify() {
		Final Account acc = [SELECT Id FROM Account LIMIT 1];
		final acpl__Account_Planning__c apR = AP_FactoryTest_tst.createAccountPlanning(acc.Id, MAP_USERS.get(EJECUTIVO).Id, null, true);
		insert apR;
		Test.startTest();
		System.runAs(MAP_USERS.get(MANAGER)) {
			try {
				apR.acpl__gf_ap_status_type_name__c = IN_PROGRESS;
				update apR;
			} catch(Exception e) {
				System.debug(e.getMessage());
			}
		}
		Test.stopTest();
		Final acpl__Account_Planning__c apResult = [SELECT Id, acpl__gf_ap_status_type_name__c FROM acpl__Account_Planning__c WHERE Id =:apR.Id];
		System.assertEquals (apResult.acpl__gf_ap_status_type_name__c, NOT_STARTED, FAIL);
	}

	/**
	 * @Description Teste las funcionalidades returnAPWithoutCase:
	 *  Validator return AP without case process
	 */
	public static testmethod void returnAPWithoutCase() {
		Final Account acc = [SELECT Id FROM Account LIMIT 1];
		final acpl__Account_Planning__c apR = AP_FactoryTest_tst.createAccountPlanning(acc.Id, MAP_USERS.get(EJECUTIVO).Id, null, true);
		insert apR;
        Test.startTest();
		apR.acpl__gf_ap_status_type_name__c = PENDING_VALID;
		apR.acpl__gf_ap_substatus_type_name__c = PEND_VAL;
		apR.acpl__gf_ap_req_validation_ind_type__c = YES;
		update apR;
		
		System.runAs(MAP_USERS.get(GERENTE)) {
			try {
				apR.acpl__gf_ap_status_type_name__c = IN_PROGRESS;
				apR.acpl__gf_ap_substatus_type_name__c = 'Pending review';
				update apR;
			} catch(Exception e) {
				System.debug(e.getMessage());
			}
		}
		Test.stopTest();
		Final acpl__Account_Planning__c apResult = [SELECT Id, acpl__gf_ap_status_type_name__c FROM acpl__Account_Planning__c WHERE Id =:apR.Id];
		System.assertEquals (apResult.acpl__gf_ap_status_type_name__c, PENDING_VALID, FAIL);
	}

	/**
	 * @Description Teste las funcionalidades returnAPInvalidUser:
	 * 	Invalid User return AP
	 */
	public static testmethod void returnAPInvalidUser() {
		Final Account acc = [SELECT Id FROM Account LIMIT 1];
		final acpl__Account_Planning__c apR = AP_FactoryTest_tst.createAccountPlanning(acc.Id, MAP_USERS.get(EJECUTIVO).Id, null, true);
		insert apR;
		Test.startTest();
        apR.acpl__gf_ap_status_type_name__c = PENDING_VALID;
		apR.acpl__gf_ap_substatus_type_name__c = PEND_VAL;
		apR.acpl__gf_ap_req_validation_ind_type__c = YES;
		update apR;
		
		System.runAs(MAP_USERS.get(MANAGER)) {
			try {
				apR.acpl__gf_ap_status_type_name__c = IN_PROGRESS;
				apR.acpl__gf_ap_substatus_type_name__c = 'Pending review';
				update apR;
			} catch(Exception e) {
				System.debug(e.getMessage());
			}
		}
		Test.stopTest();
		Final acpl__Account_Planning__c apResult = [SELECT Id, acpl__gf_ap_status_type_name__c FROM acpl__Account_Planning__c WHERE Id =:apR.Id];
		System.assertEquals (apResult.acpl__gf_ap_status_type_name__c, PENDING_VALID, FAIL);
	}

	/**
	 * @Description Teste las funcionalidades returnAP:
	 * 	Invalid User return AP with case
	 */
	public static testmethod void returnAPWithCase() {
		Final Account acc = [SELECT Id FROM Account LIMIT 1];
		final acpl__Account_Planning__c apR = AP_FactoryTest_tst.createAccountPlanning(acc.Id, MAP_USERS.get(EJECUTIVO).Id, null, true);
		insert apR;
        Test.startTest();
		apR.acpl__gf_ap_status_type_name__c = PENDING_VALID;
		apR.acpl__gf_ap_substatus_type_name__c = PEND_VAL;
		apR.acpl__gf_ap_req_validation_ind_type__c = YES;
		update apR;
		insert new Case(acpl__Account_plan_id__c = apR.Id, recordTypeId = CASE_RT, Status = 'Request Sent For Review', OwnerId = MAP_USERS.get(GERENTE).Id);
		
		System.runAs(MAP_USERS.get(MANAGER)) {
			try {
				apR.acpl__gf_ap_status_type_name__c = IN_PROGRESS;
				apR.acpl__gf_ap_substatus_type_name__c = 'Pending review';
				update apR;
			} catch(Exception e) {
				System.debug(e.getMessage());
			}
		}
		Test.stopTest();
		Final acpl__Account_Planning__c apResult = [SELECT Id, acpl__gf_ap_status_type_name__c FROM acpl__Account_Planning__c WHERE Id =:apR.Id];
		System.assertEquals (apResult.acpl__gf_ap_status_type_name__c, PENDING_VALID, FAIL);
	}

	/**
	 * @Description Teste las funcionalidades validationAPWithoutCase:
	 *  Validator validate without case process
	 */
	public static testmethod void validationAPWithoutCase() {
		Final Account acc = [SELECT Id FROM Account LIMIT 1];
		Final Id apRT = [SELECT Id FROM RecordType WHERE DeveloperName = 'Account_Planning' LIMIT 1].Id;
		final acpl__Account_Planning__c apR = AP_FactoryTest_tst.createAccountPlanning(acc.Id, MAP_USERS.get(EJECUTIVO).Id, apRT, true);
		insert apR;
        Test.startTest();
		apR.acpl__gf_ap_status_type_name__c = PENDING_VALID;
		apR.acpl__gf_ap_substatus_type_name__c = PEND_VAL;
		apR.acpl__gf_ap_req_validation_ind_type__c = YES;
		update apR;
		
		System.runAs(MAP_USERS.get(GERENTE)) {
			try {
				apR.acpl__gf_ap_status_type_name__c = VALIDATED;
				apR.acpl__gf_ap_substatus_type_name__c = 'In place';
				update apR;
			} catch(Exception e) {
				System.debug(e.getMessage());
			}
		}
		Test.stopTest();
		Final acpl__Account_Planning__c apResult = [SELECT Id, acpl__gf_ap_status_type_name__c FROM acpl__Account_Planning__c WHERE Id =:apR.Id];
		System.assertEquals (apResult.acpl__gf_ap_status_type_name__c, PENDING_VALID, FAIL);
	}

    /**
	 * @Description Teste las funcionalidades validationAPInvalidUser:
	 * 	Invalid User validate
	 */
	public static testmethod void validationAPInvalidUser() {
		Final Account acc = [SELECT Id FROM Account LIMIT 1];
		final acpl__Account_Planning__c apR = AP_FactoryTest_tst.createAccountPlanning(acc.Id, MAP_USERS.get(EJECUTIVO).Id, null, true);
		insert apR;
        Test.startTest();
		apR.acpl__gf_ap_status_type_name__c = PENDING_VALID;
		apR.acpl__gf_ap_substatus_type_name__c = PEND_VAL;
		apR.acpl__gf_ap_req_validation_ind_type__c = YES;
		update apR;
		
		System.runAs(MAP_USERS.get(MANAGER)) {
			try {
				apR.acpl__gf_ap_status_type_name__c = VALIDATED;
				apR.acpl__gf_ap_substatus_type_name__c = 'In place';
				update apR;
			} catch(Exception e) {
				System.debug(e.getMessage());
			}
		}
		Test.stopTest();
		Final acpl__Account_Planning__c apResult = [SELECT Id, acpl__gf_ap_status_type_name__c FROM acpl__Account_Planning__c WHERE Id =:apR.Id];
		System.assertEquals (apResult.acpl__gf_ap_status_type_name__c, PENDING_VALID, FAIL);
	}

	/**
	 * @Description Teste las funcionalidades validationAPWithCase:
	 * 	Invalid User validate wiht case
	 */
	public static testmethod void validationAPWithCase() {
		Final Account acc = [SELECT Id FROM Account LIMIT 1];
		final acpl__Account_Planning__c apR = AP_FactoryTest_tst.createAccountPlanning(acc.Id, MAP_USERS.get(EJECUTIVO).Id, null, true);
		insert apR;
        Test.startTest();
		insert new Case(acpl__Account_plan_id__c = apR.Id, recordTypeId = CASE_RT, Status = 'Request Sent For Review', OwnerId = MAP_USERS.get(GERENTE).Id);
		insert new Case(acpl__Account_plan_id__c = apR.Id, recordTypeId = CASE_RT, Status = 'Request Approved', OwnerId = MAP_USERS.get(GERENTE).Id);
		apR.acpl__gf_ap_status_type_name__c = PENDING_VALID;
		apR.acpl__gf_ap_substatus_type_name__c = PEND_VAL;
		apR.acpl__gf_ap_req_validation_ind_type__c = YES;
		update apR;
		
		System.runAs(MAP_USERS.get(MANAGER)) {
			try {
				apR.acpl__gf_ap_status_type_name__c = VALIDATED;
				apR.acpl__gf_ap_substatus_type_name__c = 'In place';
				update apR;
			} catch(Exception e) {
				System.debug(e.getMessage());
			}
		}
		Test.stopTest();
		Final acpl__Account_Planning__c apResult = [SELECT Id, acpl__gf_ap_status_type_name__c FROM acpl__Account_Planning__c WHERE Id =:apR.Id];
		System.assertEquals (apResult.acpl__gf_ap_status_type_name__c, PENDING_VALID, FAIL);
	}
}