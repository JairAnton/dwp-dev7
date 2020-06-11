/**
* ------------------------------------------------------------------------------------------------
* @Name AccountPlanning_Handler_tst
* @Author Diego Carbajal diego.carbajal@bbva.com
* @Date Created: 2020-05-01
* @Group 
* @Description AccountPlanning_Handler_tst
* 
*/
@isTest
public class AccountPlanning_Handler_tst {
	static Map<String, User> mapUsers = AP_FactoryTest_tst.getUsers();
	static Id caseRT = [SELECT ID FROM RecordType WHERE developerName = 'Account_Plan_Validation' LIMIT 1].Id;
	/*
	 * @author 		Global Desktop
	 * @Description  AP questions creation
	 */
	@TestSetup
	static void setUp() {
		AP_FactoryTest_tst.forSetUp();
	}

	/**
	 * @Description Testea las funcionalidades de los metodos: beforeInsert, afterInsert y relateAPQuestions
	 */
	public static testmethod void testMethod1() {
		Account acc = [SELECT Id FROM Account LIMIT 1];
		final acpl__Account_Planning__c accountPlanning1 = TestFactory.createAccountPlanning(acc.Id, mapUsers.get('EJECUTIVO').Id, null, false);
		Test.startTest();
		insert accountPlanning1;
		Test.stopTest();
		Final acpl__Account_Planning__c ap = [SELECT Id, acpl__gf_ap_question_form_number__c, acpl__gf_ap_validator_user_id__c FROM acpl__Account_Planning__c
		                                      WHERE Id =:accountPlanning1.Id];
		System.assert (ap.acpl__gf_ap_question_form_number__c > 0, 'Success');
		System.assertNotEquals(ap.acpl__gf_ap_validator_user_id__c, null, 'Success');
	}

	/**
	 * @Description Teste las funcionalidades beforeDMLTest1: Locked AP
	 */
	public static testmethod void lockedAPTest() {
		Account acc = [SELECT Id FROM Account LIMIT 1];
		final acpl__Account_Planning__c ap = TestFactory.createAccountPlanning(acc.Id, mapUsers.get('EJECUTIVO').Id, null, false);
		insert ap;
		Final String status = 'Not started';
		Test.startTest();
		System.runAs(mapUsers.get('EJECUTIVO')) {
			try {
				ap.acpl__gf_ap_status_type_name__c = 'In Progress';
				update ap;
			} catch(Exception e) {
				System.debug(e.getMessage());
			}
		}
		Test.stopTest();
		Final acpl__Account_Planning__c apResult = [SELECT Id, acpl__gf_ap_status_type_name__c FROM acpl__Account_Planning__c WHERE Id =:ap.Id];
		System.assert (apResult.acpl__gf_ap_status_type_name__c == status, 'Success');
	}

	/**
	 * @Description Teste las funcionalidades InvalidUserModify: Invalid User
	 */
	public static testmethod void InvalidUserModify() {
		Account acc = [SELECT Id FROM Account LIMIT 1];
		final acpl__Account_Planning__c ap = TestFactory.createAccountPlanning(acc.Id, mapUsers.get('EJECUTIVO').Id, null, true);
		insert ap;
		Final String status = 'Not started';
		Test.startTest();
		System.runAs(mapUsers.get('MANAGER')) {
			try {
				ap.acpl__gf_ap_status_type_name__c = 'In Progress';
				update ap;
			} catch(Exception e) {
				System.debug(e.getMessage());
			}
		}
		Test.stopTest();
		Final acpl__Account_Planning__c apResult = [SELECT Id, acpl__gf_ap_status_type_name__c FROM acpl__Account_Planning__c WHERE Id =:ap.Id];
		System.assert (apResult.acpl__gf_ap_status_type_name__c == status, 'Success');
	}

	/**
	 * @Description Teste las funcionalidades returnAPWithoutCase:
	 *  Validator return AP without case process
	 */
	public static testmethod void returnAPWithoutCase() {
		Account acc = [SELECT Id FROM Account LIMIT 1];
		final acpl__Account_Planning__c ap = TestFactory.createAccountPlanning(acc.Id, mapUsers.get('EJECUTIVO').Id, null, false);
		insert ap;
		ap.acpl__gf_ap_status_type_name__c = 'Pending Validation';
		ap.acpl__gf_ap_substatus_type_name__c = 'Pending validation';
		ap.acpl__gf_ap_req_validation_ind_type__c = 'Yes';
		update ap;
		Final String status = 'Pending validation';
		Test.startTest();
		System.runAs(mapUsers.get('GERENTE')) {
			try {
				ap.acpl__gf_ap_status_type_name__c = 'In Progress';
				ap.acpl__gf_ap_substatus_type_name__c = 'Pending review';
				update ap;
			} catch(Exception e) {
				System.debug(e.getMessage());
			}
		}
		Test.stopTest();
		Final acpl__Account_Planning__c apResult = [SELECT Id, acpl__gf_ap_status_type_name__c FROM acpl__Account_Planning__c WHERE Id =:ap.Id];
		System.assert (apResult.acpl__gf_ap_status_type_name__c == status, 'Success');
	}

	/**
	 * @Description Teste las funcionalidades returnAPInvalidUser:
	 * 	Invalid User return AP
	 */
	public static testmethod void returnAPInvalidUser() {
		Account acc = [SELECT Id FROM Account LIMIT 1];
		final acpl__Account_Planning__c ap = TestFactory.createAccountPlanning(acc.Id, mapUsers.get('EJECUTIVO').Id, null, false);
		insert ap;
		ap.acpl__gf_ap_status_type_name__c = 'Pending Validation';
		ap.acpl__gf_ap_substatus_type_name__c = 'Pending validation';
		ap.acpl__gf_ap_req_validation_ind_type__c = 'Yes';
		update ap;
		Final String status = 'Pending validation';
		Test.startTest();
		System.runAs(mapUsers.get('MANAGER')) {
			try {
				ap.acpl__gf_ap_status_type_name__c = 'In Progress';
				ap.acpl__gf_ap_substatus_type_name__c = 'Pending review';
				update ap;
			} catch(Exception e) {
				System.debug(e.getMessage());
			}
		}
		Test.stopTest();
		Final acpl__Account_Planning__c apResult = [SELECT Id, acpl__gf_ap_status_type_name__c FROM acpl__Account_Planning__c WHERE Id =:ap.Id];
		System.assert (apResult.acpl__gf_ap_status_type_name__c == status, 'Success');
	}

	/**
	 * @Description Teste las funcionalidades returnAP:
	 * 	Invalid User return AP with case
	 */
	public static testmethod void returnAPWithCase() {
		Account acc = [SELECT Id FROM Account LIMIT 1];
		final acpl__Account_Planning__c ap = TestFactory.createAccountPlanning(acc.Id, mapUsers.get('EJECUTIVO').Id, null, false);
		insert ap;
		ap.acpl__gf_ap_status_type_name__c = 'Pending Validation';
		ap.acpl__gf_ap_substatus_type_name__c = 'Pending validation';
		ap.acpl__gf_ap_req_validation_ind_type__c = 'Yes';
		update ap;
		insert new Case(acpl__Account_plan_id__c = ap.Id, recordTypeId = caseRT, Status = 'Request Sent For Review', OwnerId = mapUsers.get('GERENTE').Id);
		Final String status = 'Pending validation';
		Test.startTest();
		System.runAs(mapUsers.get('MANAGER')) {
			try {
				ap.acpl__gf_ap_status_type_name__c = 'In Progress';
				ap.acpl__gf_ap_substatus_type_name__c = 'Pending review';
				update ap;
			} catch(Exception e) {
				System.debug(e.getMessage());
			}
		}
		Test.stopTest();
		Final acpl__Account_Planning__c apResult = [SELECT Id, acpl__gf_ap_status_type_name__c FROM acpl__Account_Planning__c WHERE Id =:ap.Id];
		System.assert (apResult.acpl__gf_ap_status_type_name__c == status, 'Success');
	}

	/**
	 * @Description Teste las funcionalidades validationAPWithoutCase:
	 *  Validator validate without case process
	 */
	public static testmethod void validationAPWithoutCase() {
		Account acc = [SELECT Id FROM Account LIMIT 1];
		Id apRT = [SELECT Id FROM RecordType WHERE DeveloperName = 'Account_Planning' LIMIT 1].Id;
		final acpl__Account_Planning__c ap = TestFactory.createAccountPlanning(acc.Id, mapUsers.get('EJECUTIVO').Id, apRT, false);
		insert ap;
		ap.acpl__gf_ap_status_type_name__c = 'Pending Validation';
		ap.acpl__gf_ap_substatus_type_name__c = 'Pending validation';
		ap.acpl__gf_ap_req_validation_ind_type__c = 'Yes';
		update ap;
		Final String status = 'Pending Validation';
		Test.startTest();
		System.runAs(mapUsers.get('GERENTE')) {
			try {
				ap.acpl__gf_ap_status_type_name__c = 'Validated';
				ap.acpl__gf_ap_substatus_type_name__c = 'In place';
				update ap;
			} catch(Exception e) {
				System.debug(e.getMessage());
			}
		}
		Test.stopTest();
		Final acpl__Account_Planning__c apResult = [SELECT Id, acpl__gf_ap_status_type_name__c FROM acpl__Account_Planning__c WHERE Id =:ap.Id];
		System.assert (apResult.acpl__gf_ap_status_type_name__c == status, 'Success');
	}

	/**
	 * @Description Teste las funcionalidades validationAPInvalidUser:
	 * 	Invalid User validate
	 */
	public static testmethod void validationAPInvalidUser() {
		Account acc = [SELECT Id FROM Account LIMIT 1];
		final acpl__Account_Planning__c ap = TestFactory.createAccountPlanning(acc.Id, mapUsers.get('EJECUTIVO').Id, null, false);
		insert ap;
		ap.acpl__gf_ap_status_type_name__c = 'Pending Validation';
		ap.acpl__gf_ap_substatus_type_name__c = 'Pending validation';
		ap.acpl__gf_ap_req_validation_ind_type__c = 'Yes';
		update ap;
		Final String status = 'Pending validation';
		Test.startTest();
		System.runAs(mapUsers.get('MANAGER')) {
			try {
				ap.acpl__gf_ap_status_type_name__c = 'Validated';
				ap.acpl__gf_ap_substatus_type_name__c = 'In place';
				update ap;
			} catch(Exception e) {
				System.debug(e.getMessage());
			}
		}
		Test.stopTest();
		Final acpl__Account_Planning__c apResult = [SELECT Id, acpl__gf_ap_status_type_name__c FROM acpl__Account_Planning__c WHERE Id =:ap.Id];
		System.assert (apResult.acpl__gf_ap_status_type_name__c == status, 'Success');
	}

	/**
	 * @Description Teste las funcionalidades validationAPWithCase:
	 * 	Invalid User validate wiht case
	 */
	public static testmethod void validationAPWithCase() {
		Account acc = [SELECT Id FROM Account LIMIT 1];
		final acpl__Account_Planning__c ap = TestFactory.createAccountPlanning(acc.Id, mapUsers.get('EJECUTIVO').Id, null, false);
		insert ap;
		insert new Case(acpl__Account_plan_id__c = ap.Id, recordTypeId = caseRT, Status = 'Request Sent For Review', OwnerId = mapUsers.get('GERENTE').Id);
		insert new Case(acpl__Account_plan_id__c = ap.Id, recordTypeId = caseRT, Status = 'Request Approved', OwnerId = mapUsers.get('GERENTE').Id);
		ap.acpl__gf_ap_status_type_name__c = 'Pending Validation';
		ap.acpl__gf_ap_substatus_type_name__c = 'Pending validation';
		ap.acpl__gf_ap_req_validation_ind_type__c = 'Yes';
		update ap;
		Final String status = 'Pending validation';
		Test.startTest();
		System.runAs(mapUsers.get('MANAGER')) {
			try {
				ap.acpl__gf_ap_status_type_name__c = 'Validated';
				ap.acpl__gf_ap_substatus_type_name__c = 'In place';
				update ap;
			} catch(Exception e) {
				System.debug(e.getMessage());
			}
		}
		Test.stopTest();
		Final acpl__Account_Planning__c apResult = [SELECT Id, acpl__gf_ap_status_type_name__c FROM acpl__Account_Planning__c WHERE Id =:ap.Id];
		System.assert (apResult.acpl__gf_ap_status_type_name__c == status, 'Success');
	}

	/**
	 * @Description Teste las funcionalidades changeValidatorAPInvalidUser:
	 * 	Invalid User change Validator
	 */
	public static testmethod void changeValidatorAPInvalidUser() {
		Account acc = [SELECT Id FROM Account LIMIT 1];
		final acpl__Account_Planning__c ap = TestFactory.createAccountPlanning(acc.Id, mapUsers.get('EJECUTIVO').Id, null, false);
		insert ap;
		Final acpl__Account_Planning__c apAux = [SELECT Id, acpl__gf_ap_validator_user_id__c, acpl__gf_ap_status_type_name__c, acpl__gf_ap_substatus_type_name__c
		                                         FROM acpl__Account_Planning__c WHERE Id =:ap.Id];
		apAux.acpl__gf_ap_status_type_name__c = 'Pending Validation';
		apAux.acpl__gf_ap_req_validation_ind_type__c = 'Yes';
		update apAux;
		Final String validator = apAux.acpl__gf_ap_validator_user_id__c;
		Test.startTest();
		System.runAs(mapUsers.get('MANAGER')) {
			try {
				apAux.acpl__gf_ap_validator_user_id__c = mapUsers.get('MANAGER').Id;
				update apAux;
			} catch(Exception e) {
				System.debug(e.getMessage());
			}
		}
		Test.stopTest();
		Final acpl__Account_Planning__c apResult = [SELECT Id, acpl__gf_ap_validator_user_id__c FROM acpl__Account_Planning__c WHERE Id =:ap.Id];
		System.assertEquals(apResult.acpl__gf_ap_validator_user_id__c, validator, 'Success');
	}

	/**
	 * @Description Teste las funcionalidades changeValidatorAPInvalidUser:
	 * 	Validator change new validator without case
	 */
	public static testmethod void changeValidatorAPWithoutCase() {
		Account acc = [SELECT Id FROM Account LIMIT 1];
		final acpl__Account_Planning__c ap = TestFactory.createAccountPlanning(acc.Id, mapUsers.get('EJECUTIVO').Id, null, false);
		insert ap;
		Final acpl__Account_Planning__c apAux = [SELECT Id, acpl__gf_ap_validator_user_id__c, acpl__gf_ap_status_type_name__c, acpl__gf_ap_substatus_type_name__c
		                                         FROM acpl__Account_Planning__c WHERE Id =:ap.Id];
		apAux.acpl__gf_ap_status_type_name__c = 'Pending Validation';
		apAux.acpl__gf_ap_req_validation_ind_type__c = 'Yes';
		update apAux;
		Final String validator = apAux.acpl__gf_ap_validator_user_id__c;
		Test.startTest();
		System.runAs(mapUsers.get('GERENTE')) {
			try {
				apAux.acpl__gf_ap_validator_user_id__c = mapUsers.get('EJECUTIVO').Id;
				update apAux;
			} catch(Exception e) {
				System.debug(e.getMessage());
			}
		}
		Test.stopTest();
		Final acpl__Account_Planning__c apResult = [SELECT Id, acpl__gf_ap_validator_user_id__c FROM acpl__Account_Planning__c WHERE Id =:ap.Id];
		System.assertEquals(apResult.acpl__gf_ap_validator_user_id__c, validator, 'Success');
	}

	/**
	 * @Description Teste las funcionalidades changeValidatorAPNotStarted:
	 * 	Validator change in status Not started
	 */
	public static testmethod void changeValidatorAPNotStarted() {
		Account acc = [SELECT Id FROM Account LIMIT 1];
		final acpl__Account_Planning__c ap = TestFactory.createAccountPlanning(acc.Id, mapUsers.get('EJECUTIVO').Id, null, true);
		insert ap;
		Final acpl__Account_Planning__c apAux = [SELECT Id, acpl__gf_ap_validator_user_id__c FROM acpl__Account_Planning__c WHERE Id =:ap.Id LIMIT 1];
		Final String validator = apAux.acpl__gf_ap_validator_user_id__c;
		Test.startTest();
		System.runAs(mapUsers.get('MANAGER')) {
			try {
				apAux.acpl__gf_ap_validator_user_id__c = mapUsers.get('MANAGER').Id;
				update apAux;
			} catch(Exception e) {
				System.debug(e.getMessage());
			}
		}
		Test.stopTest();
		Final acpl__Account_Planning__c apResult = [SELECT Id, acpl__gf_ap_validator_user_id__c FROM acpl__Account_Planning__c WHERE Id =:ap.Id];
		System.assertEquals(apResult.acpl__gf_ap_validator_user_id__c, validator, 'Success');
	}

	/**
	 * @Description Teste las funcionalidades changeValidatorAPInvalidUser:
	 * 	Invalid validator change new validator with case
	 */
	public static testmethod void changeValidatorAPWithCase() {
		Account acc = [SELECT Id FROM Account LIMIT 1];
		final acpl__Account_Planning__c ap = TestFactory.createAccountPlanning(acc.Id, mapUsers.get('EJECUTIVO').Id, null, false);
		insert ap;
		Final acpl__Account_Planning__c apAux = [SELECT Id, acpl__gf_ap_validator_user_id__c, acpl__gf_ap_status_type_name__c, acpl__gf_ap_substatus_type_name__c
		                                         FROM acpl__Account_Planning__c WHERE Id =:ap.Id];
		insert new Case(acpl__Account_plan_id__c = apAux.Id, recordTypeId = caseRT, Status = 'Request Sent For Review', OwnerId = mapUsers.get('GERENTE').Id);
		insert new Case(acpl__Account_plan_id__c = apAux.Id, recordTypeId = caseRT, Status = 'Request Re-Assigned', OwnerId = mapUsers.get('GERENTE').Id);
		apAux.acpl__gf_ap_status_type_name__c = 'Pending Validation';
		apAux.acpl__gf_ap_req_validation_ind_type__c = 'Yes';
		update apAux;
		Final String validator = apAux.acpl__gf_ap_validator_user_id__c;
		Test.startTest();
		System.runAs(mapUsers.get('MANAGER')) {
			try {
				apAux.acpl__gf_ap_validator_user_id__c = mapUsers.get('EJECUTIVO').Id;
				update apAux;
			} catch(Exception e) {
				System.debug(e.getMessage());
			}
		}
		Test.stopTest();
		Final acpl__Account_Planning__c apResult = [SELECT Id, acpl__gf_ap_validator_user_id__c FROM acpl__Account_Planning__c WHERE Id =:ap.Id];
		System.assertEquals(apResult.acpl__gf_ap_validator_user_id__c, validator, 'Success');
	}

	/**
	 * @Description Teste las funcionalidades checkDeleteAP:
	 * 	Invalid User try to delete AP
	 */
	public static testmethod void checkDeleteAP() {
		Account acc = [SELECT Id FROM Account LIMIT 1];
		final acpl__Account_Planning__c ap = TestFactory.createAccountPlanning(acc.Id, mapUsers.get('EJECUTIVO').Id, null, false);
		insert ap;
		Test.startTest();
		System.runAs(mapUsers.get('MANAGER')) {
			try {
				delete ap;
			} catch(Exception e) {
				System.debug(e.getMessage());
			}
		}
		Test.stopTest();
		Final acpl__Account_Planning__c apResult = [SELECT Id, acpl__gf_ap_validator_user_id__c FROM acpl__Account_Planning__c WHERE Id =:ap.Id];
		System.assertNotEquals(apResult, null, 'Success');
	}

	/**
	 * @Description Teste las funcionalidades checkDeleteAP:
	 * 	Invalid User try to delete AP
	 */
	public static testmethod void deleteAP() {
		User admin = [SELECT Id FROM User WHERE Id =:UserInfo.getUserId() LIMIT 1];
		Account acc = [SELECT Id FROM Account LIMIT 1];
		final acpl__Account_Planning__c ap = TestFactory.createAccountPlanning(acc.Id, mapUsers.get('EJECUTIVO').Id, null, false);
		insert ap;
		Test.startTest();
		System.runAs(admin) {
			delete ap;
		}
		Test.stopTest();
		Final List<acpl__Account_Planning__c> apResult = [SELECT Id, acpl__gf_ap_validator_user_id__c FROM acpl__Account_Planning__c WHERE Id =:ap.Id];
		Final Integer apResultSize = apResult.size();
		System.assertEquals(apResultSize, 0, 'Success');
	}

	/**
	 * @Description Teste las funcionalidad postValidate:
	 * 	test method postValidate
	 */
	public static testmethod void postValidate() {
		Account acc = [SELECT Id FROM Account LIMIT 1];
		final acpl__Account_Planning__c ap = TestFactory.createAccountPlanning(acc.Id, mapUsers.get('EJECUTIVO').Id, null, false);
		insert ap;
		List<acpl__Commercial_Plan_Event__c> lstCPE = new List<acpl__Commercial_Plan_Event__c>();
		lstCPE.add(new acpl__Commercial_Plan_Event__c(acpl__gf_account_planning_id__c = ap.Id, Comments__c = 'Comentarios', Name = 'Visita', Asiggned_User__c = UserInfo.getUserId(),
		                                              acpl__gf_event_date__c = Date.today() + 20, acpl__gf_comm_plan_event_type_name__c = 'Visit', acpl__participant_id__c = acc.Id));
		lstCPE.add(new acpl__Commercial_Plan_Event__c(acpl__gf_account_planning_id__c = ap.Id, Comments__c = 'Comentarios', Name = 'Oportunidad', Asiggned_User__c = UserInfo.getUserId(),
		                                              acpl__gf_event_date__c = Date.today() + 25, acpl__gf_comm_plan_event_type_name__c = 'Opportunity', acpl__participant_id__c = acc.Id));
		lstCPE.add(new acpl__Commercial_Plan_Event__c(acpl__gf_account_planning_id__c = ap.Id, Comments__c = 'Comentarios', Name = 'Tarea', Asiggned_User__c = UserInfo.getUserId(),
		                                              acpl__gf_event_date__c = Date.today() + 30, acpl__gf_comm_plan_event_type_name__c = 'Task', acpl__participant_id__c = acc.Id));
		lstCPE.add(new acpl__Commercial_Plan_Event__c(acpl__gf_account_planning_id__c = ap.Id, Comments__c = 'Comentarios', Name = 'Llamada', Asiggned_User__c = UserInfo.getUserId(),
		                                              acpl__gf_event_date__c = Date.today() + 31, acpl__gf_comm_plan_event_type_name__c = 'Call', acpl__participant_id__c = acc.Id));
		insert lstCPE;
		ap.acpl__gf_ap_status_type_name__c = 'Validated';
		ap.acpl__gf_ap_substatus_type_name__c = 'In place';
		update ap;
		Final String Validated = 'Validated';
		Test.startTest();
		System.runAs(mapUsers.get('EJECUTIVO')) {
			try {
				ap.acpl__gf_ap_status_type_name__c = 'Validated';
				ap.acpl__gf_ap_substatus_type_name__c = 'In place';
				update ap;
			} catch(Exception e) {
				System.debug(e.getMessage());
			}
		}
		Test.stopTest();
		Final acpl__Account_Planning__c apResult = [SELECT Id, acpl__gf_ap_status_type_name__c FROM acpl__Account_Planning__c WHERE Id =:ap.Id];
		System.assertEquals(apResult.acpl__gf_ap_status_type_name__c, Validated, 'Success');
	}
}