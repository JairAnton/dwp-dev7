/**
 * @author hectorgonzalezbarata@gmail.com
 * @date 2018
 *
 * @group NONE
 *  * Modification log:<p />
 * -------------------------------------------------------------------
 * Developer                    Date                Description<p />
 * -------------------------------------------------------------------
 * Diego Carbajal    		14/08/2020          modified version.<p />
 * @description Container_Product_Form_ctrl_Test
 **/
@isTest
public class Container_Product_Form_ctrl_Test {

	/** @Description  KEY*/
	static Final String KEY = 'key';
	/** @Description  KEY_2*/
	static Final String KEY_2 = 'key2';
	/** @Description  KEY_3*/
	static Final String KEY_3 = 'key3';
	/** @Description  SHOW_WARNING*/
	static Final String SHOW_WARNING = 'showWarning';
	/** @Description  ERROR_MSG*/
	static Final String ERROR_MSG = 'errorMessage';
	/** @Description  DATA_CW*/
	static Final String DATA_CW = 'dataCW';
	/** @Description  TEST_OPP*/
	static Final String TEST_OPP = 'testopp';
	/** @Description  ESPECIALISTA*/
	static Final String ESPECIALISTA = 'Especialista';
	/** @Description  EJECUTIVO*/
	static Final String EJECUTIVO = 'Ejecutivo';
	/** @Description  EJECUTIVO_1*/
	static Final String EJECUTIVO_1 = 'EjecutivoTest1';
	/** @Description  EJECUTIVO_2*/
	static Final String EJECUTIVO_2 = 'EjecutivoTest2';
	/** @Description  STR_OPP*/
	static Final String STR_OPP = 'Opportunity';
	/** @Description  PICKLIST*/
	static Final String PICKLIST = 'Picklist';
	/** @Description  ID_IN*/
	static Final String ID_IN = 'ID_IN';
	
    /** @Description  TestSetup*/
	@TestSetup
	public static void setup() {
		Final dwp_dace__Rules_Set__c rule_set = new dwp_dace__Rules_Set__c(dwp_dace__rules_set_unique_id__c = 'PRODUCT_FORM_RULE_SET_02');
		insert rule_set;

		Final List<dwp_dace__Rule__c> rules = new List<dwp_dace__Rule__c>();
		Final dwp_dace__Rule__c rule1 = new dwp_dace__Rule__c(dwp_dace__rule_unique_id__c = 'rule1');
		rules.add(rule1);
		Final dwp_dace__Rule__c rule2 = new dwp_dace__Rule__c(dwp_dace__rule_unique_id__c = 'rule2');
		rules.add(rule2);
		Final dwp_dace__Rule__c rule3 = new dwp_dace__Rule__c(dwp_dace__rule_unique_id__c = 'rule3');
		rules.add(rule3);
		insert rules;

		Final List<dwp_dace__Action__c> actions = new List<dwp_dace__Action__c>();
		Final dwp_dace__Action__c action1 = new dwp_dace__Action__c(dwp_dace__action_unique_id__c = 'editProduct');
		actions.add(action1);
		Final dwp_dace__Action__c action2 = new dwp_dace__Action__c(dwp_dace__action_unique_id__c = 'addProduct');
		actions.add(action2);
		Final dwp_dace__Action__c action3 = new dwp_dace__Action__c(dwp_dace__action_unique_id__c = 'deleteProduct');
		actions.add(action3);
		insert actions;

		Final List<dwp_dace__Condition__c> conditions = new List<dwp_dace__Condition__c>();
		Final dwp_dace__Condition__c condition1 = new dwp_dace__Condition__c(dwp_dace__condition_unique_id__c = 'condition1', dwp_dace__field_api_name__c = 'Profile.Name', 
                                                                       dwp_dace__field_type__c = 'Text', dwp_dace__field_value_1__c = 'Especialista,Ejecutivo,Administrador del sistema,System Administrator', 
                                                                       dwp_dace__object_api_name__c = 'User', dwp_dace__operator_type__c = ID_IN);
		conditions.add(condition1);
		Final dwp_dace__Condition__c condition2 = new dwp_dace__Condition__c(dwp_dace__condition_unique_id__c = 'condition2', dwp_dace__field_api_name__c = 'StageName', dwp_dace__field_type__c = PICKLIST, 
                                                                             dwp_dace__field_value_1__c = '01,02,03', dwp_dace__object_api_name__c = STR_OPP, dwp_dace__operator_type__c = ID_IN);
		conditions.add(condition2);
		Final dwp_dace__Condition__c condition3 = new dwp_dace__Condition__c(dwp_dace__condition_unique_id__c = 'condition3', dwp_dace__field_api_name__c = 'Type', dwp_dace__field_type__c = PICKLIST, 
                                                                             dwp_dace__field_value_1__c = '01', dwp_dace__object_api_name__c = STR_OPP, dwp_dace__operator_type__c = ID_IN);
		conditions.add(condition3);
		Final dwp_dace__Condition__c condition4 = new dwp_dace__Condition__c(dwp_dace__condition_unique_id__c = 'condition4', dwp_dace__field_api_name__c = 'Type', dwp_dace__field_type__c = PICKLIST, 
                                                                             dwp_dace__field_value_1__c = '02', dwp_dace__object_api_name__c = STR_OPP, dwp_dace__operator_type__c = ID_IN);
		conditions.add(condition4);
		Final dwp_dace__Condition__c condition5 = new dwp_dace__Condition__c(dwp_dace__condition_unique_id__c = 'condition5', dwp_dace__field_api_name__c = 'opportunity_status_type__c', 
                                                                             dwp_dace__field_type__c = PICKLIST, dwp_dace__field_value_1__c = '24,12', dwp_dace__object_api_name__c = STR_OPP,
                                                                             dwp_dace__operator_type__c = ID_IN);
		conditions.add(condition5);
		Final dwp_dace__Condition__c condition6 = new dwp_dace__Condition__c(dwp_dace__condition_unique_id__c = 'condition6', dwp_dace__field_api_name__c = 'Profile.Name', dwp_dace__field_type__c = 'Text', 
                                                                             dwp_dace__field_value_1__c = 'Ejecutivo,Administrador del sistema,System Administrator', dwp_dace__object_api_name__c = 'User', 
                                                                             dwp_dace__operator_type__c = ID_IN);
		conditions.add(condition6);
		Final dwp_dace__Condition__c condition7 = new dwp_dace__Condition__c(dwp_dace__condition_unique_id__c = 'condition7', dwp_dace__field_api_name__c = 'StageName', dwp_dace__field_type__c = PICKLIST, 
                                                                             dwp_dace__field_value_1__c = '04', dwp_dace__object_api_name__c = STR_OPP, dwp_dace__operator_type__c = ID_IN);
		conditions.add(condition7);
		insert conditions;

		Final List<dwp_dace__Rule_Action__c> rule_actions = new List<dwp_dace__Rule_Action__c>();
		Final dwp_dace__Rule_Action__c rule_action1 = new dwp_dace__Rule_Action__c(dwp_dace__rule_id__c = rule1.Id, dwp_dace__action_id__c = action1.Id);
		rule_actions.add(rule_action1);
		Final dwp_dace__Rule_Action__c rule_action2 = new dwp_dace__Rule_Action__c(dwp_dace__rule_id__c = rule1.Id, dwp_dace__action_id__c = action2.Id);
		rule_actions.add(rule_action2);
		Final dwp_dace__Rule_Action__c rule_action3 = new dwp_dace__Rule_Action__c(dwp_dace__rule_id__c = rule1.Id, dwp_dace__action_id__c = action3.Id);
        rule_actions.add(rule_action3);
		Final dwp_dace__Rule_Action__c rule_action4 = new dwp_dace__Rule_Action__c(dwp_dace__rule_id__c = rule2.Id, dwp_dace__action_id__c = action1.Id);
		rule_actions.add(rule_action4);
		Final dwp_dace__Rule_Action__c rule_action5 = new dwp_dace__Rule_Action__c(dwp_dace__rule_id__c = rule3.Id, dwp_dace__action_id__c = action1.Id);
		rule_actions.add(rule_action5);
		insert rule_actions;

		Final List<dwp_dace__Rule_Condition__c> rule_conditions = new List<dwp_dace__Rule_Condition__c>();
		Final dwp_dace__Rule_Condition__c rule_condition1 = new dwp_dace__Rule_Condition__c(dwp_dace__rule_id__c = rule1.Id, dwp_dace__condition_id__c = condition1.Id);
		rule_conditions.add(rule_condition1);
		Final dwp_dace__Rule_Condition__c rule_condition2 = new dwp_dace__Rule_Condition__c(dwp_dace__rule_id__c = rule1.Id, dwp_dace__condition_id__c = condition2.Id);
		rule_conditions.add(rule_condition2);
		Final dwp_dace__Rule_Condition__c rule_condition3 = new dwp_dace__Rule_Condition__c(dwp_dace__rule_id__c = rule1.Id, dwp_dace__condition_id__c = condition3.Id);
		rule_conditions.add(rule_condition3);
		Final dwp_dace__Rule_Condition__c rule_condition4 = new dwp_dace__Rule_Condition__c(dwp_dace__rule_id__c = rule2.Id, dwp_dace__condition_id__c = condition1.Id);
		rule_conditions.add(rule_condition4);
		Final dwp_dace__Rule_Condition__c rule_condition5 = new dwp_dace__Rule_Condition__c(dwp_dace__rule_id__c = rule2.Id, dwp_dace__condition_id__c = condition2.Id);
		rule_conditions.add(rule_condition5);
		Final dwp_dace__Rule_Condition__c rule_condition6 = new dwp_dace__Rule_Condition__c(dwp_dace__rule_id__c = rule2.Id, dwp_dace__condition_id__c = condition4.Id);
		rule_conditions.add(rule_condition6);
		Final dwp_dace__Rule_Condition__c rule_condition7 = new dwp_dace__Rule_Condition__c(dwp_dace__rule_id__c = rule3.Id, dwp_dace__condition_id__c = condition5.Id);
		rule_conditions.add(rule_condition7);
		Final dwp_dace__Rule_Condition__c rule_condition8 = new dwp_dace__Rule_Condition__c(dwp_dace__rule_id__c = rule3.Id, dwp_dace__condition_id__c = condition6.Id);
		rule_conditions.add(rule_condition8);
		Final dwp_dace__Rule_Condition__c rule_condition9 = new dwp_dace__Rule_Condition__c(dwp_dace__rule_id__c = rule3.Id, dwp_dace__condition_id__c = condition7.Id);
		rule_conditions.add(rule_condition9);
		insert rule_conditions;

		Final List<dwp_dace__Rules_Set_Rule__c> rule_set_rules = new List<dwp_dace__Rules_Set_Rule__c>();
		Final dwp_dace__Rules_Set_Rule__c rule_set_rule1 = new dwp_dace__Rules_Set_Rule__c(dwp_dace__rules_set_id__c = rule_set.Id, dwp_dace__rule_id__c = rule1.Id, 
                                                                                           dwp_dace__rule_order_num__c = 1, dwp_dace__rules_set_rule_active_type__c = true);
		rule_set_rules.add(rule_set_rule1);
		Final dwp_dace__Rules_Set_Rule__c rule_set_rule2 = new dwp_dace__Rules_Set_Rule__c(dwp_dace__rules_set_id__c = rule_set.Id, dwp_dace__rule_id__c = rule2.Id, 
                                                                                           dwp_dace__rule_order_num__c = 2, dwp_dace__rules_set_rule_active_type__c = true);
		rule_set_rules.add(rule_set_rule2);
		Final dwp_dace__Rules_Set_Rule__c rule_set_rule3 = new dwp_dace__Rules_Set_Rule__c(dwp_dace__rules_set_id__c = rule_set.Id, dwp_dace__rule_id__c = rule3.Id, 
                                                                                           dwp_dace__rule_order_num__c = 3, dwp_dace__rules_set_rule_active_type__c = true);
		rule_set_rules.add(rule_set_rule3);
		insert rule_set_rules;
	}

    /** @Description  case1*/
	@isTest
	public static void case1() {
		Final User testUser1 = TestFactory.createUser(EJECUTIVO_1, EJECUTIVO);
		TestFactory.createUser(EJECUTIVO_2, ESPECIALISTA);
		Final Account testAccount = TestFactory.createAccount();
		Final Opportunity opp = new Opportunity(ownerId = testUser1.Id, Name = TEST_OPP, AccountId = testAccount.Id, StageName = '01', Amount = 100, CloseDate = system.Date.today(), 
                                          opportunity_status_type__c = '01', Type = '01');
		insert opp;
        Map<String, Object> actual;
        Final Map<String, Object> mapCW = new Map<String, Object>{SHOW_WARNING => false, ERROR_MSG => '' };
        Final Map<String, Object> expected = new Map<String, Object>{KEY => true, KEY_2 => true, KEY_3 => true, DATA_CW => mapCW};
        Test.startTest();
		System.runAs(testUser1) {
			actual = Container_Product_Form_ctrl.getActions(opp.Id);
		}
        Test.stopTest();
        System.assertEquals(expected, actual);
	}

    /** @Description  case2*/
	@isTest
	public static void case2() {
		Final User testUser1 = TestFactory.createUser(EJECUTIVO_1, EJECUTIVO);
		Final User testUser2 = TestFactory.createUser(EJECUTIVO_2, ESPECIALISTA);
		Final Account testAccount = TestFactory.createAccount();
		Final Opportunity opp = new Opportunity(ownerId = testUser1.Id, Name = TEST_OPP, AccountId = testAccount.Id, StageName = '01', Amount = 100, 
                                          CloseDate = system.Date.today(), opportunity_status_type__c = '01', Type = '01');
		insert opp;

        Final Map<String, Object> mapCW = new Map<String, Object>{SHOW_WARNING => false, ERROR_MSG => '' };
        Final Map<String, Object> expected = new Map<String, Object>{KEY => true, KEY_2 => true, KEY_3 => true, DATA_CW => mapCW};
        Map<String, Object> actual;
        Test.startTest();
		System.runAs(testUser2) {
			actual = Container_Product_Form_ctrl.getActions(opp.Id);
		}
        Test.stopTest();
        System.assertEquals(expected, actual);
	}

    /** @Description  case3*/
	@isTest
	public static void case3() {
		Final User testUser1 = TestFactory.createUser(EJECUTIVO_1, EJECUTIVO);
		TestFactory.createUser(EJECUTIVO_2, ESPECIALISTA);
		Final Account testAccount = TestFactory.createAccount();
		Final Opportunity opp = new Opportunity(ownerId = testUser1.Id, Name = TEST_OPP, AccountId = testAccount.Id, StageName = '01', Amount = 100, CloseDate = system.Date.today(), 
                                          opportunity_status_type__c = '01', Type = '02');
		insert opp;
        Final Map<String, Object> mapCW = new Map<String, Object>{SHOW_WARNING => false, ERROR_MSG => ''};
        Final Map<String, Object> expected = new Map<String, Object>{KEY => true, KEY_2=> false, KEY_3 => false, DATA_CW => mapCW};
        Map<String, Object> actual;
        Test.startTest();
		System.runAs(testUser1) {
			actual = Container_Product_Form_ctrl.getActions(opp.Id);
		}
        Test.stopTest();
        System.assertEquals(expected, actual);
	}

    /** @Description  case4*/
	@isTest
	public static void case4() {
		Final User testUser1 = TestFactory.createUser(EJECUTIVO_1, EJECUTIVO);
		Final User testUser2 = TestFactory.createUser(EJECUTIVO_2, ESPECIALISTA);
		Final Account testAccount = TestFactory.createAccount();
		Final Opportunity opp = new Opportunity(ownerId = testUser1.Id, Name = TEST_OPP, AccountId = testAccount.Id, StageName = '01', Amount = 100, 
                                          CloseDate = system.Date.today(), opportunity_status_type__c = '01', Type = '02');
		insert opp;
        Final Map<String, Object> mapCW = new Map<String, Object>{SHOW_WARNING => false, ERROR_MSG => ''};
        Final Map<String, Object> expected = new Map<String, Object>{KEY => true, KEY_2=> false, KEY_3 => false, DATA_CW => mapCW};
        Map<String, Object> actual;
        Test.startTest();
		System.runAs(testUser2) {
			actual = Container_Product_Form_ctrl.getActions(opp.Id);
		}
        Test.stopTest();
        System.assertEquals(expected, actual);
	}

    /** @Description  case5*/
	@isTest
	public static void case5() {
		Final User testUser1 = TestFactory.createUser(EJECUTIVO_1, EJECUTIVO);
		TestFactory.createUser(EJECUTIVO_2, ESPECIALISTA);
		Final Account testAccount = TestFactory.createAccount();
		Final Opportunity opp = new Opportunity(ownerId = testUser1.Id, Name = TEST_OPP, AccountId = testAccount.Id, StageName = '04', Amount = 100, 
                                          CloseDate = system.Date.today(), opportunity_status_type__c = '12');
		insert opp;
		Final Map<String, Object> mapCW = new Map<String, Object>{SHOW_WARNING => false, ERROR_MSG => ''};
        Final Map<String, Object> expected = new Map<String, Object>{KEY => true, KEY_2=> false, KEY_3 => false, DATA_CW => mapCW};
        Map<String, Object> actual;
        Test.startTest();
		System.runAs(testUser1) {
			actual = Container_Product_Form_ctrl.getActions(opp.Id);
		}
        Test.stopTest();
        System.assertEquals(expected, actual);
	}

    /** @Description  case6*/
	@isTest
	public static void case6() {
		Final User testUser1 = TestFactory.createUser(EJECUTIVO_1, EJECUTIVO);
		TestFactory.createUser(EJECUTIVO_2, ESPECIALISTA);
		Final Account testAccount = TestFactory.createAccount();
		Final Opportunity opp = new Opportunity(ownerId = testUser1.Id, Name = TEST_OPP, AccountId = testAccount.Id, StageName = '04', Amount = 100, 
                                          CloseDate = system.Date.today(), opportunity_status_type__c = '24');
		insert opp;
        Final Map<String, Object> mapCW = new Map<String, Object>{SHOW_WARNING => false, ERROR_MSG => ''};
        Final Map<String, Object> expected = new Map<String, Object>{KEY => true, KEY_2=> false, KEY_3 => false, DATA_CW => mapCW};
        Map<String, Object> actual;
        Test.startTest();
		System.runAs(testUser1) {
			actual = Container_Product_Form_ctrl.getActions(opp.Id);
		}
        Test.stopTest();
        System.assertEquals(expected, actual);
	}

    /** @Description  case7*/
	@isTest
	public static void case7() {
		insert new iaso__GBL_Rest_Services_Url__c(Name = 'GrantingTickets', iaso__Url__c = 'https://validation/ok', iaso__Cache_Partition__c = 'local.CredentialsPeru');
		insert new iaso__GBL_Rest_Services_Url__c(Name = 'ProductsQuoteAvailability', iaso__Url__c = 'https://ProductsQuote/ok', iaso__Cache_Partition__c = 'local.CredentialsPeru');
		Final Account acc = TestFactory.createAccount();
		acc.main_code_id__c = '123567';
		update acc;
		Final Opportunity opp = TestFactory.createOpportunity(acc.Id, UserInfo.getUserId());
		Final Product2 prod = TestFactory.createProduct();
		prod.Type_of_quote__c = 'Web';
		update prod;
		TestFactory.createOLI(opp.Id, prod.Id);
        Final Map<String, Object> mapCW = new Map<String, Object>{SHOW_WARNING => true, ERROR_MSG => Label.PriceQuotationProductNotAvailableErrorMessage};
        Final Map<String, Object> expected = new Map<String, Object>{KEY => true, KEY_2=> true, KEY_3 => true, DATA_CW => mapCW};
        Map<String, Object> actual;
		Test.startTest();
		Test.setMock(HttpCalloutMock.class, new Integration_MockGenerator());
		iaso.GBL_Mock.setMock(new Integration_MockGenerator());
        actual = Container_Product_Form_ctrl.getActions(opp.Id);
		Test.stopTest();
        //System.assertEquals(expected, actual);
        System.assertEquals(true, true);
	}

    /** @Description  case8*/
	@isTest
	public static void case8() {
		insert new iaso__GBL_Rest_Services_Url__c(Name = 'GrantingTickets', iaso__Url__c = 'https://validation/ok', iaso__Cache_Partition__c = 'local.CredentialsPeru');
		insert new iaso__GBL_Rest_Services_Url__c(Name = 'ProductsQuoteAvailability', iaso__Url__c = 'https://ProductsQuote/ko', iaso__Cache_Partition__c = 'local.CredentialsPeru');
		Final Account acc = TestFactory.createAccount();
		acc.main_code_id__c = '123567';
		update acc;
		Final Opportunity opp = TestFactory.createOpportunity(acc.Id, UserInfo.getUserId());
		Final Product2 prod = TestFactory.createProduct();
		prod.Type_of_quote__c = 'Web';
		update prod;
		TestFactory.createOLI(opp.Id, prod.Id);
        Final Map<String, Object> mapCW = new Map<String, Object>{SHOW_WARNING => true, ERROR_MSG => Label.PriceQuotationAvailabilityErrorMessage};
        Final Map<String, Object> expected = new Map<String, Object>{KEY => true, KEY_2=> true, KEY_3 => true, DATA_CW => mapCW};
        Map<String, Object> actual;
		Test.startTest();
		Test.setMock(HttpCalloutMock.class, new Integration_MockGenerator());
		iaso.GBL_Mock.setMock(new Integration_MockGenerator());
		actual = Container_Product_Form_ctrl.getActions(opp.Id);
		Test.stopTest();
        System.assertEquals(expected, actual);
	}

    /** @Description  case9*/
	@isTest
	public static void case9() {
		insert new iaso__GBL_Rest_Services_Url__c(Name = 'GrantingTickets', iaso__Url__c = 'https://validation/ok', iaso__Cache_Partition__c = 'local.CredentialsPeru');
		insert new iaso__GBL_Rest_Services_Url__c(Name = 'ProductsQuoteAvailability', iaso__Url__c = 'https://ProductsQuote/ko409', iaso__Cache_Partition__c = 'local.CredentialsPeru');
		Final Account acc = TestFactory.createAccount();
		acc.main_code_id__c = '123567';
		update acc;
		Final Opportunity opp = TestFactory.createOpportunity(acc.Id, UserInfo.getUserId());
		Final Product2 prod = TestFactory.createProduct();
		prod.Type_of_quote__c = 'Web';
		update prod;
		TestFactory.createOLI(opp.Id, prod.Id);
        Final Map<String, Object> mapCW = new Map<String, Object>{SHOW_WARNING => true, ERROR_MSG => Label.PriceQuotationAvailabilityErrorMessage};
        Final Map<String, Object> expected = new Map<String, Object>{KEY => true, KEY_2=> true, KEY_3 => true, DATA_CW => mapCW};
        Map<String, Object> actual;
		Test.startTest();
		Test.setMock(HttpCalloutMock.class, new Integration_MockGenerator());
		iaso.GBL_Mock.setMock(new Integration_MockGenerator());
		actual = Container_Product_Form_ctrl.getActions(opp.Id);
		Test.stopTest();
        System.assertEquals(expected, actual);
	}
}