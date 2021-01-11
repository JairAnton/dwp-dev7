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
	/**@Description MAP_USERS */
	Final static Map<String, User> MAP_USERS = AP_FactoryTest_tst.obtainUsers();
	/**@Description EJECUTIVO */
    Final static String EJECUTIVO = 'EJECUTIVO';
    /**@Description RIESGO */
    Final static String RIESGO = 'Riesgo de firma';
    /**@Description PRODUCT */
    Final static String PRODUCT = '0292235_NEW';
    /**@Description FAIL*/
    private static Final String FAIL = 'Fail Assertion';
	/**
	   @Description afterInsert
	 */
	@TestSetup
	public static void setUp() {
		AP_FactoryTest_tst.forSetUp();
        AP_FactoryTest_tst.generateProduct();
	}

	/**
	 * @Description Test method beforeInsert
	 */
	public static testmethod void beforeInsert() {
		Final Account acc = [SELECT Id FROM Account LIMIT 1];
		Final acpl__Account_Planning__c apR = AP_FactoryTest_tst.createAccountPlanning(acc.Id, MAP_USERS.get(EJECUTIVO).Id, null, false);
		insert apR;
		Final bupl__BusinessPlan__c bpR = [SELECT Id FROM bupl__BusinessPlan__c WHERE acpl__gf_account_planning_id__c =:apR.Id LIMIT 1];
		Test.startTest();
		System.runAs(MAP_USERS.get(EJECUTIVO)) {
            Final bupl__BP_GrowthDriver__c[] auxGD = new bupl__BP_GrowthDriver__c[] {
                new bupl__BP_GrowthDriver__c(acpl__gf_account_planning_id__c = apR.Id, bupl__gf_business_plan_id__c = bpR.Id,
                                             bupl__solution_category_id__c = RIESGO, bupl__solution_category_desc__c = PRODUCT),
				new bupl__BP_GrowthDriver__c(acpl__gf_account_planning_id__c = apR.Id, bupl__gf_business_plan_id__c = bpR.Id,
                                             bupl__solution_category_id__c = RIESGO, bupl__solution_category_desc__c = PRODUCT)};
			try {
				insert auxGD;
			} catch(DMLException e) {
				System.debug(e.getMessage());
			}
		}
		Test.stopTest();
		Final bupl__BP_GrowthDriver__c[] lstGD = [SELECT Id FROM bupl__BP_GrowthDriver__c WHERE acpl__gf_account_planning_id__c =:apR.Id];
		Final Integer size = lstGD.size();
		System.assertEquals(size, 0, FAIL);
	}

	/**
	 * @Description Test method beforeUpdate
	 */
	public static testmethod void beforeUpdate() {
		Final Account acc = [SELECT Id FROM Account LIMIT 1];
		Final acpl__Account_Planning__c apR = AP_FactoryTest_tst.createAccountPlanning(acc.Id, MAP_USERS.get(EJECUTIVO).Id, null, false);
		insert apR;
		Final bupl__BusinessPlan__c bpR = [SELECT Id FROM bupl__BusinessPlan__c WHERE acpl__gf_account_planning_id__c =:apR.Id LIMIT 1];
		Final bupl__BP_GrowthDriver__c vGD = new bupl__BP_GrowthDriver__c(acpl__gf_account_planning_id__c = apR.Id, bupl__gf_business_plan_id__c = bpR.Id,
		                                                                  bupl__solution_category_id__c = RIESGO, bupl__solution_category_desc__c = PRODUCT);
		insert vGD;
		Test.startTest();
		System.runAs(MAP_USERS.get(EJECUTIVO)) {
			try {
				vGD.bupl__solution_category_desc__c = '0292235';
				update vGD;
			} catch(Exception e) {
				System.debug(e.getMessage());
			}
		}
		Test.stopTest();
		Final bupl__BP_GrowthDriver__c[] lstGD = [SELECT Id, bupl__solution_category_desc__c FROM bupl__BP_GrowthDriver__c WHERE acpl__gf_account_planning_id__c =:apR.Id];
		System.assertEquals(PRODUCT, lstGD[0].bupl__solution_category_desc__c, FAIL);
	}

	/**
	 * @Description Test method beforeDelete
	 */
	public static testmethod void beforeDelete() {
		Final Account acc = [SELECT Id FROM Account LIMIT 1];
		Final acpl__Account_Planning__c apR = AP_FactoryTest_tst.createAccountPlanning(acc.Id, MAP_USERS.get(EJECUTIVO).Id, null, false);
		insert apR;
		Final bupl__BusinessPlan__c bpR = [SELECT Id FROM bupl__BusinessPlan__c WHERE acpl__gf_account_planning_id__c =:apR.Id LIMIT 1];
		Final bupl__BP_GrowthDriver__c vGD = new bupl__BP_GrowthDriver__c(acpl__gf_account_planning_id__c = apR.Id, bupl__gf_business_plan_id__c = bpR.Id,
		                                                                  bupl__solution_category_id__c = RIESGO, bupl__solution_category_desc__c = PRODUCT);
		insert vGD;
		Test.startTest();
		System.runAs(MAP_USERS.get(EJECUTIVO)) {
			try {
				delete vGD;
			} catch(Exception e) {
				System.debug(e.getMessage());
			}
		}
		Test.stopTest();
		Final bupl__BP_GrowthDriver__c[] lstGD = [SELECT Id FROM bupl__BP_GrowthDriver__c WHERE acpl__gf_account_planning_id__c =:apR.Id];
		Final Integer size = lstGD.size();
		System.assertEquals (size, 1, FAIL);
	}

	/**
	 * @Description Test method afterInsert
	 */
	public static testmethod void afterInsert() {
		Final Account acc = [SELECT Id FROM Account LIMIT 1];
		Final acpl__Account_Planning__c apR = AP_FactoryTest_tst.createAccountPlanning(acc.Id, MAP_USERS.get(EJECUTIVO).Id, null, true);
		insert apR;
		Final bupl__BusinessPlan__c bpR = [SELECT Id FROM bupl__BusinessPlan__c WHERE acpl__gf_account_planning_id__c =:apR.Id LIMIT 1];
		Test.startTest();
		System.runAs(MAP_USERS.get(EJECUTIVO)) {
			insert new bupl__BP_GrowthDriver__c(acpl__gf_account_planning_id__c = apR.Id, bupl__gf_business_plan_id__c = bpR.Id,
			                                    bupl__solution_category_id__c = RIESGO, bupl__solution_category_desc__c = PRODUCT);
		}
		Test.stopTest();
		Final acpl__Account_Planning__c apAux = [SELECT Id, acpl__gf_ap_status_type_name__c FROM acpl__Account_Planning__c WHERE Id =:apR.Id LIMIT 1];
		System.assertEquals('In Progress', apAux.acpl__gf_ap_status_type_name__c, FAIL);
	}
}