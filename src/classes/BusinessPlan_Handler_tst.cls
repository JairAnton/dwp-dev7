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
	/**@Description MAP_USERS*/
	private static Final Map<String, User> MAP_USERS = AP_FactoryTest_tst.obtainUsers();
    /**@Description EJECUTIVO*/
    private static Final String EJECUTIVO = 'EJECUTIVO';

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
		Final acpl__Account_Planning__c apR = AP_FactoryTest_tst.createAccountPlanning(acc.Id, MAP_USERS.get(EJECUTIVO).Id, null, true);
		insert apR;
		Final bupl__BusinessPlan__c bpAux = [SELECT Id, acpl__gf_account_planning_id__c, bupl__status_type__c FROM bupl__BusinessPlan__c WHERE acpl__gf_account_planning_id__c =:apR.Id LIMIT 1];
		Test.startTest();
		System.runAs(MAP_USERS.get(EJECUTIVO)) {
			bpAux.bupl__status_type__c = 'Validated';
			update bpAux;
		}
		Test.stopTest();
		Final acpl__Account_Planning__c apAux = [SELECT Id, acpl__gf_ap_status_type_name__c FROM acpl__Account_Planning__c WHERE Id =:apR.Id LIMIT 1];
		System.assertEquals ('Validated', apAux.acpl__gf_ap_status_type_name__c, 'Fail Assertion');
	}

	/**
	 * @Description Test method afterUpdate => InProgressBP
	 */
	public static testmethod void afterUpdateInProgressBP() {
		Final Account acc = [SELECT Id FROM Account LIMIT 1];
		Final acpl__Account_Planning__c apR = AP_FactoryTest_tst.createAccountPlanning(acc.Id, MAP_USERS.get(EJECUTIVO).Id, null, true);
		insert apR;
		Final bupl__BusinessPlan__c bpAux = [SELECT Id, acpl__gf_account_planning_id__c, bupl__status_type__c FROM bupl__BusinessPlan__c WHERE 
                                             acpl__gf_account_planning_id__c =:apR.Id LIMIT 1];
		Test.startTest();
		System.runAs(MAP_USERS.get(EJECUTIVO)) {
			bpAux.bupl__status_type__c = 'In Progress';
			update bpAux;
		}
		Test.stopTest();
		Final acpl__Account_Planning__c apAux = [SELECT Id, acpl__gf_ap_status_type_name__c FROM acpl__Account_Planning__c WHERE Id =:apR.Id LIMIT 1];
		System.assertEquals ('In Progress', apAux.acpl__gf_ap_status_type_name__c, 'Fail Assertion');
	}
}