/**
 * Test class for BP_Need_Handler_cls and subclass
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
public class BP_Need_Handler_tst {
	/**
	   @Description mapUsers
	 */
	Final static Map<String, User> mapUsers = AP_FactoryTest_tst.getUsers();
	/**
	   @Description ejecutivo
	 */
	Final static String ejecutivo = 'EJECUTIVO';

	/**
	   @Description setUp
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
		Final acpl__Account_Planning__c ap = TestFactory.createAccountPlanning(acc.Id, mapUsers.get(ejecutivo).Id, null, false);
		insert ap;
		Final bupl__BusinessPlan__c bp = [SELECT Id FROM bupl__BusinessPlan__c WHERE acpl__gf_account_planning_id__c =:AP.Id LIMIT 1];
		Test.startTest();
		System.runAs(mapUsers.get(ejecutivo)) {
			try {
				Final bupl__BP_Need__c[] auxNeed = new bupl__BP_Need__c[] {};
				auxNeed.add(new bupl__BP_Need__c(acpl__gf_account_planning_id__c = ap.Id, bupl__gf_business_plan_id__c = bp.Id,
				                                 bupl__gf_bus_pl_unlk_revenue_amount__c = 12345678.24, bupl__gf_bus_pl_unlk_risk_lim_amount__c = 43643.23));
				auxNeed.add(new bupl__BP_Need__c(acpl__gf_account_planning_id__c = ap.Id, bupl__gf_business_plan_id__c = bp.Id,
				                                 bupl__gf_bus_pl_unlk_revenue_amount__c = 1536.78, bupl__gf_bus_pl_unlk_risk_lim_amount__c = 1454.26));
				insert auxNeed;
			} catch(Exception e) {
				System.debug(e.getMessage());
			}
		}
		Test.stopTest();
		Final bupl__BP_Need__c[] lstNeed = [SELECT Id FROM bupl__BP_Need__c WHERE acpl__gf_account_planning_id__c =:ap.Id];
		Final Integer size = lstNeed.size();
		System.assert (size == 0, 'Fail Assertion');
	}

	/**
	 * @Description Test method beforeUpdate
	 */
	public static testmethod void beforeUpdate() {
		Final Account acc = [SELECT Id FROM Account LIMIT 1];
		Final acpl__Account_Planning__c ap = TestFactory.createAccountPlanning(acc.Id, mapUsers.get(ejecutivo).Id, null, false);
		insert ap;
		Final bupl__BusinessPlan__c bp = [SELECT Id FROM bupl__BusinessPlan__c WHERE acpl__gf_account_planning_id__c =:AP.Id LIMIT 1];
		Final bupl__BP_Need__c vNeed = new bupl__BP_Need__c(acpl__gf_account_planning_id__c = ap.Id, bupl__gf_business_plan_id__c = bp.Id,
		                                                    bupl__gf_bus_pl_unlk_revenue_amount__c = 12345678.24, bupl__gf_bus_pl_unlk_risk_lim_amount__c = 43643.23);
		insert vNeed;
		Final Decimal product = 12345678.24;
		Test.startTest();
		System.runAs(mapUsers.get(ejecutivo)) {
			try {
				vNeed.bupl__gf_bus_pl_unlk_revenue_amount__c = 123.54;
				update vNeed;
			} catch(Exception e) {
				System.debug(e.getMessage());
			}
		}
		Test.stopTest();
		Final bupl__BP_Need__c[] lstNeed = [SELECT Id, bupl__gf_bus_pl_unlk_revenue_amount__c FROM bupl__BP_Need__c WHERE acpl__gf_account_planning_id__c =:ap.Id];
		System.assertEquals(product, lstNeed[0].bupl__gf_bus_pl_unlk_revenue_amount__c, 'Fail Assertion');
	}

	/**
	 * @Description Test method beforeDelete
	 */
	public static testmethod void beforeDelete() {
		Final Account acc = [SELECT Id FROM Account LIMIT 1];
		Final acpl__Account_Planning__c ap = TestFactory.createAccountPlanning(acc.Id, mapUsers.get(ejecutivo).Id, null, false);
		insert ap;
		bupl__BusinessPlan__c bp = [SELECT Id FROM bupl__BusinessPlan__c WHERE acpl__gf_account_planning_id__c =:AP.Id LIMIT 1];
		Final bupl__BP_Need__c vNeed = new bupl__BP_Need__c(acpl__gf_account_planning_id__c = ap.Id, bupl__gf_business_plan_id__c = bp.Id,
		                                                    bupl__gf_bus_pl_unlk_revenue_amount__c = 12345678.24, bupl__gf_bus_pl_unlk_risk_lim_amount__c = 43643.23);
		insert vNeed;
		Test.startTest();
		System.runAs(mapUsers.get(ejecutivo)) {
			try {
				delete vNeed;
			} catch(Exception e) {
				System.debug(e.getMessage());
			}
		}
		Test.stopTest();
		Final bupl__BP_Need__c[] lstNeed = [SELECT Id, bupl__gf_bus_pl_unlk_revenue_amount__c FROM bupl__BP_Need__c WHERE acpl__gf_account_planning_id__c =:ap.Id];
		Final Integer size = lstNeed.size();
		System.assert (size > 0, 'Fail Assertion');
	}

	/**
	 * @Description Test method afterInsert
	 */
	public static testmethod void afterInsert() {
		Final Account acc = [SELECT Id FROM Account LIMIT 1];
		Final acpl__Account_Planning__c ap = TestFactory.createAccountPlanning(acc.Id, mapUsers.get(ejecutivo).Id, null, true);
		insert ap;
		bupl__BusinessPlan__c bp = [SELECT Id FROM bupl__BusinessPlan__c WHERE acpl__gf_account_planning_id__c =:AP.Id LIMIT 1];
		Test.startTest();
		System.runAs(mapUsers.get(ejecutivo)) {
			insert new bupl__BP_Need__c(acpl__gf_account_planning_id__c = ap.Id, bupl__gf_business_plan_id__c = bp.Id,
			                            bupl__gf_bus_pl_unlk_revenue_amount__c = 12345678.24, bupl__gf_bus_pl_unlk_risk_lim_amount__c = 43643.23);
		}
		Test.stopTest();
		Final acpl__Account_Planning__c apAux = [SELECT Id, acpl__gf_ap_status_type_name__c FROM acpl__Account_Planning__c WHERE Id =:ap.Id LIMIT 1];
		System.assertEquals('In Progress', apAux.acpl__gf_ap_status_type_name__c, 'Fail Assertion');
	}
}
