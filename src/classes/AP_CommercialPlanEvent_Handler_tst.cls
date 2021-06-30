/**
 * Test class for AP_CommercialPlanEvent_Handler_cls and subclass
 * <p /><p />
 * Modification log:<p />
 * -------------------------------------------------------------------
 * Developer                    Date                Description<p />
 * -------------------------------------------------------------------
 * Diego Carbajal    		04/06/2020          Original version.<p />
 * Jair Anton				07/06/2021			Modificación cobertura de test AP
 * @author Diego Carbajal
 */
@isTest
public class AP_CommercialPlanEvent_Handler_tst {
	/**
	 * @Description variable mapUsers
	 */
	static Map<String, User> mapUsers = AP_FactoryTest_tst.obtainUsers();
	/**
	 * @Description variable EJECUTIVO
	 */
	static Final String EJECUTIVO = 'EJECUTIVO';
	/**
	 * @Description variable FAIL
	 */
	static Final String FAIL = 'FAIL Assertion';
    /**
	 * @Description variable VISIT
	 */
	static Final String VISIT = 'Visit';
	/**
	 * @Description method setUp
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
		Final acpl__Account_Planning__c apRecord = AP_FactoryTest_tst.createAccountPlanning(acc.Id, mapUsers.get(EJECUTIVO).Id, null, true);
		insert apRecord;
		Test.startTest();
        apRecord.ACPL__GF_AP_INDVI_LOCK_EDIT_IND_TYPE__C = false;
        update apRecord;
		System.runAs(mapUsers.get(EJECUTIVO)) {
			try {
				Final acpl__Commercial_Plan_Event__c[] cpeAux = new acpl__Commercial_Plan_Event__c[] {};
				cpeAux.add(new acpl__Commercial_Plan_Event__c(acpl__gf_account_planning_id__c = apRecord.Id, acpl__participant_id__c = acc.Id,
				                                              acpl__gf_event_date__c = System.today() + 31, acpl__gf_comm_plan_event_type_name__c = VISIT));
				cpeAux.add(new acpl__Commercial_Plan_Event__c(acpl__gf_account_planning_id__c = apRecord.Id, acpl__participant_id__c = acc.Id,
				                                              acpl__gf_event_date__c = System.today() + 31, acpl__gf_comm_plan_event_type_name__c = 'Opportunity'));
				insert cpeAux;
			} catch(Exception e) {
				System.debug(e.getMessage());
			}
		}
		Test.stopTest();
		Final acpl__Commercial_Plan_Event__c[] lstCPE = [SELECT Id FROM acpl__Commercial_Plan_Event__c WHERE acpl__gf_account_planning_id__c =:apRecord.Id];
		Final Integer size = lstCPE.size();
		System.assertEquals(size, 0, FAIL);
	}

	/**
	 * @Description Test method beforeUpdate
	 */
	public static testmethod void beforeUpdate() {
		Final Account acc = [SELECT Id FROM Account LIMIT 1];
		Final acpl__Account_Planning__c apRecord = AP_FactoryTest_tst.createAccountPlanning(acc.Id, mapUsers.get(EJECUTIVO).Id, null, true);
		insert apRecord;
        Test.startTest();
		Final acpl__Commercial_Plan_Event__c cpe = new acpl__Commercial_Plan_Event__c(acpl__gf_account_planning_id__c = apRecord.Id, acpl__participant_id__c = acc.Id,
		                                                                              acpl__gf_event_date__c = System.today() + 31, acpl__gf_comm_plan_event_type_name__c = VISIT);
		insert cpe;
		Final Date eventDate = cpe.acpl__gf_event_date__c;
		
		System.runAs(mapUsers.get(EJECUTIVO)) {
			try {
                apRecord.ACPL__GF_AP_INDVI_LOCK_EDIT_IND_TYPE__C = false;
                update apRecord;
				cpe.acpl__gf_event_date__c = System.today() + 15;
				update cpe;
			} catch(Exception e) {
				System.debug(e.getMessage());
			}
		}
		Test.stopTest();
		Final acpl__Commercial_Plan_Event__c[] lstCPE = [SELECT Id, acpl__gf_event_date__c FROM acpl__Commercial_Plan_Event__c WHERE acpl__gf_account_planning_id__c =:apRecord.Id];
		System.assertEquals(eventDate, lstCPE[0].acpl__gf_event_date__c, FAIL);
	}

	/**
	 * @Description Test method beforeDelete
	 */
	public static testmethod void beforeDelete() {
		Final Account acc = [SELECT Id FROM Account LIMIT 1];
		Final acpl__Account_Planning__c apRecord = AP_FactoryTest_tst.createAccountPlanning(acc.Id, mapUsers.get(EJECUTIVO).Id, null, true);
		insert apRecord;
        Test.startTest();
		Final acpl__Commercial_Plan_Event__c cpe = new acpl__Commercial_Plan_Event__c(acpl__gf_account_planning_id__c = apRecord.Id, acpl__participant_id__c = acc.Id,
		                                                                              acpl__gf_event_date__c = System.today() + 31, acpl__gf_comm_plan_event_type_name__c = VISIT);
		insert cpe;
		
		System.runAs(mapUsers.get(EJECUTIVO)) {
			try {
				apRecord.ACPL__GF_AP_INDVI_LOCK_EDIT_IND_TYPE__C = false;
                update apRecord;
				delete cpe;
			} catch(Exception e) {
				System.debug(e.getMessage());
			}
		}
		Test.stopTest();
		Final acpl__Commercial_Plan_Event__c[] lstCPE = [SELECT Id, acpl__gf_event_date__c FROM acpl__Commercial_Plan_Event__c WHERE acpl__gf_account_planning_id__c =:apRecord.Id];
		Final Integer size = lstCPE.size();
		System.assertEquals(size, 1, FAIL);
	}

	/**
	 * @Description Test method afterInsert
	 */
	public static testmethod void afterInsert() {
		Final Account acc = [SELECT Id FROM Account LIMIT 1];
		Final acpl__Account_Planning__c apRecord = AP_FactoryTest_tst.createAccountPlanning(acc.Id, mapUsers.get(EJECUTIVO).Id, null, true);
		insert apRecord;
		Test.startTest();
		System.runAs(mapUsers.get(EJECUTIVO)) {
			insert new acpl__Commercial_Plan_Event__c(acpl__gf_account_planning_id__c = apRecord.Id, acpl__participant_id__c = acc.Id,
			                                          acpl__gf_event_date__c = System.today() + 31, acpl__gf_comm_plan_event_type_name__c = VISIT);
		}
		Test.stopTest();
		Final acpl__Account_Planning__c apAux = [SELECT Id, acpl__gf_ap_status_type_name__c FROM acpl__Account_Planning__c WHERE Id =:apRecord.Id LIMIT 1];
		System.assertEquals('In Progress', apAux.acpl__gf_ap_status_type_name__c, FAIL);
	}
}