/**
 * Test class for BP_GrowthDriver_Handler_cls and subclass
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
public class BP_GrowthDriver_Handler_tst {
	/**
	   @Description mapUsers
	 */
	Final static Map<String, User> mapUsers = AP_FactoryTest_tst.getUsers();

	/**
	   @Description afterInsert
	 */
	@TestSetup
	public static void setUp() {
		AP_FactoryTest_tst.forSetUp();
	}

	/**
	 * @Description Test method beforeInsert
	 */
	public static testmethod void beforeInsert() {
		Final Account acc = [SELECT Id FROM Account LIMIT 1];
		Final acpl__Account_Planning__c apR = TestFactory.createAccountPlanning(acc.Id, mapUsers.get('EJECUTIVO').Id, null, false);
		insert apR;
		Final bupl__BusinessPlan__c bpR = [SELECT Id FROM bupl__BusinessPlan__c WHERE acpl__gf_account_planning_id__c =:apR.Id LIMIT 1];
		Test.startTest();
		System.runAs(mapUsers.get('EJECUTIVO')) {
			try {
				Final bupl__BP_GrowthDriver__c[] auxGD = new bupl__BP_GrowthDriver__c[] {};
				auxGD.add(new bupl__BP_GrowthDriver__c(acpl__gf_account_planning_id__c = apR.Id, bupl__gf_business_plan_id__c = bpR.Id,
				                                       bupl__solution_category_id__c = 'Riesgo de firma', bupl__solution_category_desc__c = 'Stand by'));
				auxGD.add(new bupl__BP_GrowthDriver__c(acpl__gf_account_planning_id__c = apR.Id, bupl__gf_business_plan_id__c = bpR.Id,
				                                       bupl__solution_category_id__c = 'Riesgo de firma', bupl__solution_category_desc__c = 'Stand by'));
				insert auxGD;
			} catch(Exception e) {
				System.debug(e.getMessage());
			}
		}
		Test.stopTest();
		Final bupl__BP_GrowthDriver__c[] lstGD = [SELECT Id FROM bupl__BP_GrowthDriver__c WHERE acpl__gf_account_planning_id__c =:apR.Id];
		Final Integer size = lstGD.size();
		System.assertEquals(size, 0, 'Fail Assertion');
	}

	/**
	 * @Description Test method beforeUpdate
	 */
	public static testmethod void beforeUpdate() {
		Final Account acc = [SELECT Id FROM Account LIMIT 1];
		Final acpl__Account_Planning__c apR = TestFactory.createAccountPlanning(acc.Id, mapUsers.get('EJECUTIVO').Id, null, false);
		insert apR;
		Final bupl__BusinessPlan__c bpR = [SELECT Id FROM bupl__BusinessPlan__c WHERE acpl__gf_account_planning_id__c =:apR.Id LIMIT 1];
		Final bupl__BP_GrowthDriver__c vGD = new bupl__BP_GrowthDriver__c(acpl__gf_account_planning_id__c = apR.Id, bupl__gf_business_plan_id__c = bpR.Id,
		                                                                  bupl__solution_category_id__c = 'Riesgo de firma', bupl__solution_category_desc__c = 'Stand by');
		insert vGD;
		Final String product = 'Stand by';
		Test.startTest();
		System.runAs(mapUsers.get('EJECUTIVO')) {
			try {
				vGD.bupl__solution_category_desc__c = 'Carta fianza económica';
				update vGD;
			} catch(Exception e) {
				System.debug(e.getMessage());
			}
		}
		Test.stopTest();
		Final bupl__BP_GrowthDriver__c[] lstGD = [SELECT Id, bupl__solution_category_desc__c FROM bupl__BP_GrowthDriver__c WHERE acpl__gf_account_planning_id__c =:apR.Id];
		System.assertEquals(product, lstGD[0].bupl__solution_category_desc__c, 'Fail Assertion');
	}

	/**
	 * @Description Test method beforeDelete
	 */
	public static testmethod void beforeDelete() {
		Final Account acc = [SELECT Id FROM Account LIMIT 1];
		Final acpl__Account_Planning__c apR = TestFactory.createAccountPlanning(acc.Id, mapUsers.get('EJECUTIVO').Id, null, false);
		insert apR;
		Final bupl__BusinessPlan__c bpR = [SELECT Id FROM bupl__BusinessPlan__c WHERE acpl__gf_account_planning_id__c =:apR.Id LIMIT 1];
		Final bupl__BP_GrowthDriver__c vGD = new bupl__BP_GrowthDriver__c(acpl__gf_account_planning_id__c = apR.Id, bupl__gf_business_plan_id__c = bpR.Id,
		                                                                  bupl__solution_category_id__c = 'Riesgo de firma', bupl__solution_category_desc__c = 'Stand by');
		insert vGD;
		Test.startTest();
		System.runAs(mapUsers.get('EJECUTIVO')) {
			try {
				delete vGD;
			} catch(Exception e) {
				System.debug(e.getMessage());
			}
		}
		Test.stopTest();
		Final bupl__BP_GrowthDriver__c[] lstGD = [SELECT Id FROM bupl__BP_GrowthDriver__c WHERE acpl__gf_account_planning_id__c =:apR.Id];
		Final Integer size = lstGD.size();
		System.assert (size > 0, 'Fail Assertion');
	}

	/**
	 * @Description Test method afterInsert
	 */
	public static testmethod void afterInsert() {
		Final Account acc = [SELECT Id FROM Account LIMIT 1];
		Final acpl__Account_Planning__c apR = TestFactory.createAccountPlanning(acc.Id, mapUsers.get('EJECUTIVO').Id, null, true);
		insert apR;
		Final bupl__BusinessPlan__c bpR = [SELECT Id FROM bupl__BusinessPlan__c WHERE acpl__gf_account_planning_id__c =:apR.Id LIMIT 1];
		Test.startTest();
		System.runAs(mapUsers.get('EJECUTIVO')) {
			insert new bupl__BP_GrowthDriver__c(acpl__gf_account_planning_id__c = apR.Id, bupl__gf_business_plan_id__c = bpR.Id,
			                                    bupl__solution_category_id__c = 'Riesgo de firma', bupl__solution_category_desc__c = 'Stand by');
		}
		Test.stopTest();
		Final acpl__Account_Planning__c apAux = [SELECT Id, acpl__gf_ap_status_type_name__c FROM acpl__Account_Planning__c WHERE Id =:apR.Id LIMIT 1];
		System.assertEquals('In Progress', apAux.acpl__gf_ap_status_type_name__c, 'Fail Assertion');
	}
}
