/**
 * AP_Question_Handler_tst
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
public class AP_Question_Handler_tst {
	/**
	 * @Description variable MAP_USERS
	 */
	static Map<String, User> MAP_USERS = AP_FactoryTest_tst.getUsers();

	/**
	 * @Description method setUp
	 */
	@TestSetup
	public static void setUp() {
		AP_FactoryTest_tst.forSetUp();
	}

	/**
	 * @Description Test method beforeUpdate
	 */
	public static testmethod void beforeUpdate() {
		Final Account acc = [SELECT Id FROM Account LIMIT 1];
		Final acpl__Account_Planning__c apR = TestFactory.createAccountPlanning(acc.Id, MAP_USERS.get('EJECUTIVO').Id, null, false);
		insert apR;
		Final acpl__AP_Question__c question = [SELECT Id, acpl__AA_answer_text__c FROM acpl__AP_Question__c WHERE acpl__gf_account_planning_id__c =:apR.Id LIMIT 1];
		Final String assert = question.acpl__AA_answer_text__c;
		Test.startTest();
		System.runAs(MAP_USERS.get('EJECUTIVO')) {
			try {
				question.acpl__AA_answer_text__c = 'new values';
				update question;
			} catch(Exception e) {
				System.debug(e.getMessage());
			}
		}
		Test.stopTest();
		Final acpl__AP_Question__c qValue = [SELECT Id, acpl__AA_answer_text__c FROM acpl__AP_Question__c WHERE acpl__gf_account_planning_id__c =:apR.Id LIMIT 1];
		System.assertEquals (qValue.acpl__AA_answer_text__c , assert, 'Fail Assertion');
	}

	/**
	 * @Description Test method beforeDelete
	 */
	public static testmethod void beforeDelete() {
		Final Account acc = [SELECT Id FROM Account LIMIT 1];
		Final acpl__Account_Planning__c apR = TestFactory.createAccountPlanning(acc.Id, MAP_USERS.get('EJECUTIVO').Id, null, false);
		insert apR;
		Final acpl__AP_Question__c question = [SELECT Id, acpl__AA_answer_text__c FROM acpl__AP_Question__c WHERE acpl__gf_account_planning_id__c =:apR.Id LIMIT 1];
		Test.startTest();
		System.runAs(MAP_USERS.get('EJECUTIVO')) {
			try {
				delete question;
			} catch(Exception e) {
				System.debug(e.getMessage());
			}
		}
		Test.stopTest();
		Final List<acpl__AP_Question__c> qValue = [SELECT Id, acpl__AA_answer_text__c FROM acpl__AP_Question__c WHERE acpl__gf_account_planning_id__c =:apR.Id LIMIT 1];
		Final Integer qValueSize = qValue.size();
		System.assertEquals (qValueSize, 1, 'Fail Assertion');
	}

	/**
	 * @Description Test method afterUpdate
	 */
	public static testmethod void afterUpdate() {
		Final Account acc = [SELECT Id FROM Account LIMIT 1];
		Final acpl__Account_Planning__c apR = TestFactory.createAccountPlanning(acc.Id, MAP_USERS.get('EJECUTIVO').Id, null, true);
		insert apR;
		Final acpl__AP_Question__c question = [SELECT Id, acpl__AA_answer_text__c FROM acpl__AP_Question__c WHERE acpl__gf_account_planning_id__c =:apR.Id LIMIT 1];
		Test.startTest();
		System.runAs(MAP_USERS.get('EJECUTIVO')) {
			try {
				question.acpl__AA_answer_text__c = 'new values';
				update question;
			} catch(Exception e) {
				System.debug(e.getMessage());
			}
		}
		Test.stopTest();
		Final acpl__Account_Planning__c qValue = [SELECT Id, acpl__gf_ap_status_type_name__c, acpl__gf_ap_substatus_type_name__c FROM acpl__Account_Planning__c
		                                          WHERE Id =:apR.Id LIMIT 1];
		System.assertEquals (qValue.acpl__gf_ap_status_type_name__c, 'In Progress', 'Fail Assertion');
	}
}