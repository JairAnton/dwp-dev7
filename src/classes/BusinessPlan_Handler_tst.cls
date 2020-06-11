/**
 * Test class for BusinessPlan_Handler_cls and subclass
 * <p /><p />
 * Modification log:<p />
 * -------------------------------------------------------------------
 * Developer                    Date                Description<p />
 * -------------------------------------------------------------------
 * Diego Carbajal    		04/06/2020          Original version.<p />
 *
 * @author Diego Carbajal
 */
@isTest
public class BusinessPlan_Handler_tst {
	/**
	   @Description mapUsers
	 */
	Final static Map<String, User> mapUsers = AP_FactoryTest_tst.getUsers();

	/**
	   @Description setUp
	 */
	@TestSetup
	public static void setUp() {
		AP_FactoryTest_tst.forSetUp();
	}

	/**
	 * @Description Test method afterUpdate => ValidatedBP
	 */
	public static testmethod void afterUpdateValidatedBP() {
		Final Account acc = [SELECT Id FROM Account LIMIT 1];
		Final acpl__Account_Planning__c ap = TestFactory.createAccountPlanning(acc.Id, mapUsers.get('EJECUTIVO').Id, null, true);
		insert ap;
		Final bupl__BusinessPlan__c bpAux = [SELECT Id, acpl__gf_account_planning_id__c, bupl__status_type__c FROM bupl__BusinessPlan__c WHERE acpl__gf_account_planning_id__c =:ap.Id LIMIT 1];
		Final String assert = 'Validated';
		Test.startTest();
		System.runAs(mapUsers.get('EJECUTIVO')) {
			bpAux.bupl__status_type__c = 'Validated';
			update bpAux;
		}
		Test.stopTest();
		Final acpl__Account_Planning__c apAux = [SELECT Id, acpl__gf_ap_status_type_name__c FROM acpl__Account_Planning__c WHERE Id =:ap.Id LIMIT 1];
		System.assert (apAux.acpl__gf_ap_status_type_name__c == assert, 'Fail Assertion');
	}

	/**
	 * @Description Test method afterUpdate => InProgressBP
	 */
	public static testmethod void afterUpdateInProgressBP() {
		Final Account acc = [SELECT Id FROM Account LIMIT 1];
		Final acpl__Account_Planning__c ap = TestFactory.createAccountPlanning(acc.Id, mapUsers.get('EJECUTIVO').Id, null, true);
		insert ap;
		Final bupl__BusinessPlan__c bpAux = [SELECT Id, acpl__gf_account_planning_id__c, bupl__status_type__c FROM bupl__BusinessPlan__c WHERE acpl__gf_account_planning_id__c =:ap.Id LIMIT 1];
		Final String assert = 'In Progress';
		Test.startTest();
		System.runAs(mapUsers.get('EJECUTIVO')) {
			bpAux.bupl__status_type__c = 'In Progress';
			update bpAux;
		}
		Test.stopTest();
		Final acpl__Account_Planning__c apAux = [SELECT Id, acpl__gf_ap_status_type_name__c FROM acpl__Account_Planning__c WHERE Id =:ap.Id LIMIT 1];
		System.assert (apAux.acpl__gf_ap_status_type_name__c == assert, 'Fail Assertion');
	}
}
