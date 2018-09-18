@isTest
public class Container_Product_Form_ctrl_Test {
    
    @TestSetup
    public static void setup(){
        
        dwp_dace__Rules_Set__c rule_set = new dwp_dace__Rules_Set__c(dwp_dace__rules_set_unique_id__c='PRODUCT_FORM_RULE_SET_02');
        insert rule_set;
        
        List<dwp_dace__Rule__c> rules = new List<dwp_dace__Rule__c>();
        dwp_dace__Rule__c rule1 = new dwp_dace__Rule__c(dwp_dace__rule_unique_id__c='rule1');
        rules.add(rule1);
        dwp_dace__Rule__c rule2 = new dwp_dace__Rule__c(dwp_dace__rule_unique_id__c='rule2');
        rules.add(rule2);
        dwp_dace__Rule__c rule3 = new dwp_dace__Rule__c(dwp_dace__rule_unique_id__c='rule3');
        rules.add(rule3);
        insert rules;
        
        List<dwp_dace__Action__c> actions = new List<dwp_dace__Action__c>();
        dwp_dace__Action__c action1 = new dwp_dace__Action__c(dwp_dace__action_unique_id__c='editProduct');
        actions.add(action1);
        dwp_dace__Action__c action2 = new dwp_dace__Action__c(dwp_dace__action_unique_id__c='addProduct');
        actions.add(action2);
        dwp_dace__Action__c action3 = new dwp_dace__Action__c(dwp_dace__action_unique_id__c='deleteProduct');
        actions.add(action3);
        insert actions;
        
        List<dwp_dace__Condition__c> conditions = new List<dwp_dace__Condition__c>();
        dwp_dace__Condition__c condition1 = new dwp_dace__Condition__c(
            dwp_dace__condition_unique_id__c='condition1',
        	dwp_dace__field_api_name__c='Profile.Name',
        	dwp_dace__field_type__c='Text',
        	dwp_dace__field_value_1__c='Especialista,Ejecutivo,Administrador del sistema,System Administrator',
        	dwp_dace__object_api_name__c='User',
        	dwp_dace__operator_type__c='ID_IN');
        conditions.add(condition1);
        dwp_dace__Condition__c condition2 = new dwp_dace__Condition__c(
        	dwp_dace__condition_unique_id__c='condition2',
        	dwp_dace__field_api_name__c='StageName',
        	dwp_dace__field_type__c='Picklist',
        	dwp_dace__field_value_1__c='01,02,03',
        	dwp_dace__object_api_name__c='Opportunity',
        	dwp_dace__operator_type__c='ID_IN');
        conditions.add(condition2);
        dwp_dace__Condition__c condition3 = new dwp_dace__Condition__c(
        	dwp_dace__condition_unique_id__c='condition3',
        	dwp_dace__field_api_name__c='Type',
        	dwp_dace__field_type__c='Picklist',
        	dwp_dace__field_value_1__c='01',
        	dwp_dace__object_api_name__c='Opportunity',
        	dwp_dace__operator_type__c='ID_IN');
        conditions.add(condition3);
        dwp_dace__Condition__c condition4 = new dwp_dace__Condition__c(
        	dwp_dace__condition_unique_id__c='condition4',
        	dwp_dace__field_api_name__c='Type',
        	dwp_dace__field_type__c='Picklist',
        	dwp_dace__field_value_1__c='02',
        	dwp_dace__object_api_name__c='Opportunity',
        	dwp_dace__operator_type__c='ID_IN');
        conditions.add(condition4);
        dwp_dace__Condition__c condition5 = new dwp_dace__Condition__c(
        	dwp_dace__condition_unique_id__c='condition5',
        	dwp_dace__field_api_name__c='opportunity_status_type__c',
        	dwp_dace__field_type__c='Picklist',
        	dwp_dace__field_value_1__c='24,12',
        	dwp_dace__object_api_name__c='Opportunity',
        	dwp_dace__operator_type__c='ID_IN');
        conditions.add(condition5);
        dwp_dace__Condition__c condition6 = new dwp_dace__Condition__c(
            dwp_dace__condition_unique_id__c='condition6',
        	dwp_dace__field_api_name__c='Profile.Name',
        	dwp_dace__field_type__c='Text',
        	dwp_dace__field_value_1__c='Ejecutivo,Administrador del sistema,System Administrator',
        	dwp_dace__object_api_name__c='User',
        	dwp_dace__operator_type__c='ID_IN');
        conditions.add(condition6);
        dwp_dace__Condition__c condition7 = new dwp_dace__Condition__c(
        	dwp_dace__condition_unique_id__c='condition7',
        	dwp_dace__field_api_name__c='StageName',
        	dwp_dace__field_type__c='Picklist',
        	dwp_dace__field_value_1__c='04',
        	dwp_dace__object_api_name__c='Opportunity',
        	dwp_dace__operator_type__c='ID_IN');
        conditions.add(condition7);
        insert conditions;
        
        List<dwp_dace__Rule_Action__c> rule_actions = new List<dwp_dace__Rule_Action__c>();
        dwp_dace__Rule_Action__c rule_action1 = new dwp_dace__Rule_Action__c(
            dwp_dace__rule_id__c=rule1.Id,
            dwp_dace__action_id__c=action1.Id);
        rule_actions.add(rule_action1);
        dwp_dace__Rule_Action__c rule_action2 = new dwp_dace__Rule_Action__c(
        	dwp_dace__rule_id__c=rule1.Id,
            dwp_dace__action_id__c=action2.Id);
        rule_actions.add(rule_action2);
        dwp_dace__Rule_Action__c rule_action3 = new dwp_dace__Rule_Action__c(
        	dwp_dace__rule_id__c=rule1.Id,
            dwp_dace__action_id__c=action3.Id);
        rule_actions.add(rule_action3);
        dwp_dace__Rule_Action__c rule_action4 = new dwp_dace__Rule_Action__c(
        	dwp_dace__rule_id__c=rule2.Id,
            dwp_dace__action_id__c=action1.Id);
        rule_actions.add(rule_action4);
        dwp_dace__Rule_Action__c rule_action5 = new dwp_dace__Rule_Action__c(
        	dwp_dace__rule_id__c=rule3.Id,
            dwp_dace__action_id__c=action1.Id);
        rule_actions.add(rule_action5);
        insert rule_actions;
        
        List<dwp_dace__Rule_Condition__c> rule_conditions = new List<dwp_dace__Rule_Condition__c>();
        dwp_dace__Rule_Condition__c rule_condition1 = new dwp_dace__Rule_Condition__c(
        	dwp_dace__rule_id__c=rule1.Id,
        	dwp_dace__condition_id__c=condition1.Id);
        rule_conditions.add(rule_condition1);
        dwp_dace__Rule_Condition__c rule_condition2 = new dwp_dace__Rule_Condition__c(
        	dwp_dace__rule_id__c=rule1.Id,
        	dwp_dace__condition_id__c=condition2.Id);
        rule_conditions.add(rule_condition2);
        dwp_dace__Rule_Condition__c rule_condition3 = new dwp_dace__Rule_Condition__c(
        	dwp_dace__rule_id__c=rule1.Id,
        	dwp_dace__condition_id__c=condition3.Id);
        rule_conditions.add(rule_condition3);
        dwp_dace__Rule_Condition__c rule_condition4 = new dwp_dace__Rule_Condition__c(
        	dwp_dace__rule_id__c=rule2.Id,
        	dwp_dace__condition_id__c=condition1.Id);
        rule_conditions.add(rule_condition4);
        dwp_dace__Rule_Condition__c rule_condition5 = new dwp_dace__Rule_Condition__c(
        	dwp_dace__rule_id__c=rule2.Id,
        	dwp_dace__condition_id__c=condition2.Id);
        rule_conditions.add(rule_condition5);
        dwp_dace__Rule_Condition__c rule_condition6 = new dwp_dace__Rule_Condition__c(
        	dwp_dace__rule_id__c=rule2.Id,
        	dwp_dace__condition_id__c=condition4.Id);
        rule_conditions.add(rule_condition6);
        dwp_dace__Rule_Condition__c rule_condition7 = new dwp_dace__Rule_Condition__c(
        	dwp_dace__rule_id__c=rule3.Id,
        	dwp_dace__condition_id__c=condition5.Id);
        rule_conditions.add(rule_condition7);
        dwp_dace__Rule_Condition__c rule_condition8 = new dwp_dace__Rule_Condition__c(
        	dwp_dace__rule_id__c=rule3.Id,
        	dwp_dace__condition_id__c=condition6.Id);
        rule_conditions.add(rule_condition8);
        dwp_dace__Rule_Condition__c rule_condition9 = new dwp_dace__Rule_Condition__c(
        	dwp_dace__rule_id__c=rule3.Id,
        	dwp_dace__condition_id__c=condition7.Id);
        rule_conditions.add(rule_condition9);
        insert rule_conditions;
        
        List<dwp_dace__Rules_Set_Rule__c> rule_set_rules = new List<dwp_dace__Rules_Set_Rule__c>();
        dwp_dace__Rules_Set_Rule__c rule_set_rule1 = new dwp_dace__Rules_Set_Rule__c(
        	dwp_dace__rules_set_id__c=rule_set.Id,
        	dwp_dace__rule_id__c=rule1.Id,
        	dwp_dace__rule_order_num__c=1,
        	dwp_dace__rules_set_rule_active_type__c=true);
        rule_set_rules.add(rule_set_rule1);
        dwp_dace__Rules_Set_Rule__c rule_set_rule2 = new dwp_dace__Rules_Set_Rule__c(
        	dwp_dace__rules_set_id__c=rule_set.Id,
        	dwp_dace__rule_id__c=rule2.Id,
        	dwp_dace__rule_order_num__c=2,
        	dwp_dace__rules_set_rule_active_type__c=true);
        rule_set_rules.add(rule_set_rule2);
        dwp_dace__Rules_Set_Rule__c rule_set_rule3 = new dwp_dace__Rules_Set_Rule__c(
        	dwp_dace__rules_set_id__c=rule_set.Id,
        	dwp_dace__rule_id__c=rule3.Id,
        	dwp_dace__rule_order_num__c=3,
        	dwp_dace__rules_set_rule_active_type__c=true);
        rule_set_rules.add(rule_set_rule3);
        insert rule_set_rules;
        
    }
	
    @isTest
    public static void case1(){
        User testUser1 = TestFactory.createUser('EjecutivoTest1', 'Ejecutivo');
        User testUser2 = TestFactory.createUser('EjecutivoTest2', 'Especialista');
        Account testAccount = TestFactory.createAccount();
        Opportunity opp = new Opportunity(
            ownerId=testUser1.Id,
            Name='testopp',
            AccountId=testAccount.Id,
            StageName='01',
            Amount=100,
            CloseDate=system.Date.today(),
            opportunity_status_type__c='01',
        	Type = '01');
        insert opp;
        
        System.runAs(testUser1){
            Map<String,Object> actual = Container_Product_Form_ctrl.getActions(opp.Id);
            Map<String,Object> expected = new Map<String,Object>();
            expected.put('key', true);
            expected.put('key2', true);
            expected.put('key3', true);
            Map<String,Object> mapCW = new Map<String,Object>();
            mapCW.put('showWarning',false);
            expected.put('dataCW',mapCW);
            System.assertEquals(expected, actual);
        }
             
    }
    
    @isTest
    public static void case2(){
        User testUser1 = TestFactory.createUser('EjecutivoTest1', 'Ejecutivo');
        User testUser2 = TestFactory.createUser('EjecutivoTest2', 'Especialista');
        Account testAccount = TestFactory.createAccount();
        Opportunity opp = new Opportunity(
            ownerId=testUser1.Id,
            Name='testopp',
            AccountId=testAccount.Id,
            StageName='01',
            Amount=100,
            CloseDate=system.Date.today(),
            opportunity_status_type__c='01',
        	Type = '01');
        insert opp;
        
        System.runAs(testUser2){
            Map<String,Object> actual = Container_Product_Form_ctrl.getActions(opp.Id);
            Map<String,Object> expected = new Map<String,Object>();
            expected.put('key', true);
            expected.put('key2', true);
            expected.put('key3', true);
            Map<String,Object> mapCW = new Map<String,Object>();
            mapCW.put('showWarning',false);
            expected.put('dataCW',mapCW);
            System.assertEquals(expected, actual);
        }
    }
    
    @isTest
    public static void case3(){
        User testUser1 = TestFactory.createUser('EjecutivoTest1', 'Ejecutivo');
        User testUser2 = TestFactory.createUser('EjecutivoTest2', 'Especialista');
        Account testAccount = TestFactory.createAccount();
        Opportunity opp = new Opportunity(
            ownerId=testUser1.Id,
            Name='testopp',
            AccountId=testAccount.Id,
            StageName='01',
            Amount=100,
            CloseDate=system.Date.today(),
            opportunity_status_type__c='01',
        	Type = '02');
        insert opp;
        
        System.runAs(testUser1){
            Map<String,Object> actual = Container_Product_Form_ctrl.getActions(opp.Id);
            Map<String,Object> expected = new Map<String,Object>();
            expected.put('key', true);
            expected.put('key2', false);
            expected.put('key3', false);
            Map<String,Object> mapCW = new Map<String,Object>();
            mapCW.put('showWarning',false);
            expected.put('dataCW',mapCW);
            System.assertEquals(expected, actual);
        }
    }
    
    @isTest
    public static void case4(){
        User testUser1 = TestFactory.createUser('EjecutivoTest1', 'Ejecutivo');
        User testUser2 = TestFactory.createUser('EjecutivoTest2', 'Especialista');
        Account testAccount = TestFactory.createAccount();
        Opportunity opp = new Opportunity(
            ownerId=testUser1.Id,
            Name='testopp',
            AccountId=testAccount.Id,
            StageName='01',
            Amount=100,
            CloseDate=system.Date.today(),
            opportunity_status_type__c='01',
        	Type = '02');
        insert opp;
        
        System.runAs(testUser2){
            Map<String,Object> actual = Container_Product_Form_ctrl.getActions(opp.Id);
            Map<String,Object> expected = new Map<String,Object>();
            expected.put('key', true);
            expected.put('key2', false);
            expected.put('key3', false);
            Map<String,Object> mapCW = new Map<String,Object>();
            mapCW.put('showWarning',false);
            expected.put('dataCW',mapCW);
            System.assertEquals(expected, actual);
        }
    }
    
    @isTest
    public static void case5(){
        User testUser1 = TestFactory.createUser('EjecutivoTest1', 'Ejecutivo');
        User testUser2 = TestFactory.createUser('EjecutivoTest2', 'Especialista');
        Account testAccount = TestFactory.createAccount();
        Opportunity opp = new Opportunity(
            ownerId=testUser1.Id,
            Name='testopp',
            AccountId=testAccount.Id,
            StageName='04',
            Amount=100,
            CloseDate=system.Date.today(),
            opportunity_status_type__c='12');
        insert opp;
        
        System.runAs(testUser1){
            Map<String,Object> actual = Container_Product_Form_ctrl.getActions(opp.Id);
            Map<String,Object> expected = new Map<String,Object>();
            expected.put('key', true);
            expected.put('key2', false);
            expected.put('key3', false);
            Map<String,Object> mapCW = new Map<String,Object>();
            mapCW.put('showWarning',false);
            expected.put('dataCW',mapCW);
            System.assertEquals(expected, actual);
        }
    }
    
    @isTest
    public static void case6(){
        User testUser1 = TestFactory.createUser('EjecutivoTest1', 'Ejecutivo');
        User testUser2 = TestFactory.createUser('EjecutivoTest2', 'Especialista');
        Account testAccount = TestFactory.createAccount();
        Opportunity opp = new Opportunity(
            ownerId=testUser1.Id,
            Name='testopp',
            AccountId=testAccount.Id,
            StageName='04',
            Amount=100,
            CloseDate=system.Date.today(),
            opportunity_status_type__c='24');
        insert opp;
        
        System.runAs(testUser1){
            Map<String,Object> actual = Container_Product_Form_ctrl.getActions(opp.Id);
            Map<String,Object> expected = new Map<String,Object>();
            expected.put('key', true);
            expected.put('key2', false);
            expected.put('key3', false);
            Map<String,Object> mapCW = new Map<String,Object>();
            mapCW.put('showWarning',false);
            expected.put('dataCW',mapCW);
            System.assertEquals(expected, actual);
        }
    }

    @isTest
    public static void case7(){

        insert new iaso__GBL_Rest_Services_Url__c(Name = 'GrantingTickets', iaso__Url__c = 'https://validation/ok', iaso__Cache_Partition__c = 'ServicesPartition');
        insert new iaso__GBL_Rest_Services_Url__c(Name = 'ProductsQuoteAvailability', iaso__Url__c = 'https://ProductsQuote/ok', iaso__Cache_Partition__c = 'ServicesPartition');
        Account acc = TestFactory.createAccount();
        acc.main_code_id__c = '123567';
        update acc;
        Opportunity opp = TestFactory.createOpportunity(acc.Id, UserInfo.getUserId());
        Product2 prod = TestFactory.createProduct();
        prod.Type_of_quote__c = 'Web';
        update prod;
        OpportunityLineItem oli = TestFactory.createOLI(opp.Id, prod.Id);
        Test.startTest();

        Test.setMock(HttpCalloutMock.class, new Integration_MockGenerator());
        iaso.GBL_Mock.setMock(new Integration_MockGenerator());
        
        Map<String,Object> actual = Container_Product_Form_ctrl.getActions(opp.Id);
        Map<String,Object> expected = new Map<String,Object>();
        expected.put('key', true);
        expected.put('key2', true);
        expected.put('key3', true);
        Map<String,Object> mapCW = new Map<String,Object>(); 
        mapCW.put('showWarning',false);
        expected.put('dataCW',mapCW);
        System.assertEquals(expected, actual);

        Test.stopTest();

    }

    @isTest
    public static void case8(){

        insert new iaso__GBL_Rest_Services_Url__c(Name = 'GrantingTickets', iaso__Url__c = 'https://validation/ok', iaso__Cache_Partition__c = 'ServicesPartition');
        insert new iaso__GBL_Rest_Services_Url__c(Name = 'ProductsQuoteAvailability', iaso__Url__c = 'https://ProductsQuote/ko', iaso__Cache_Partition__c = 'ServicesPartition');
        Account acc = TestFactory.createAccount();
        acc.main_code_id__c = '123567';
        update acc;
        Opportunity opp = TestFactory.createOpportunity(acc.Id, UserInfo.getUserId());
        Product2 prod = TestFactory.createProduct();
        prod.Type_of_quote__c = 'Web';
        update prod;
        OpportunityLineItem oli = TestFactory.createOLI(opp.Id, prod.Id);
        Test.startTest();

        Test.setMock(HttpCalloutMock.class, new Integration_MockGenerator());
        iaso.GBL_Mock.setMock(new Integration_MockGenerator());
        
        Map<String,Object> actual = Container_Product_Form_ctrl.getActions(opp.Id);
        Map<String,Object> expected = new Map<String,Object>();
        expected.put('key', true);
        expected.put('key2', true);
        expected.put('key3', true);
        Map<String,Object> mapCW = new Map<String,Object>(); 
        mapCW.put('showWarning',true);
        expected.put('dataCW',mapCW);
        System.assertEquals(expected, actual);

        Test.stopTest();

    }

    @isTest
    public static void case9(){

        insert new iaso__GBL_Rest_Services_Url__c(Name = 'GrantingTickets', iaso__Url__c = 'https://validation/ok', iaso__Cache_Partition__c = 'ServicesPartition');
        insert new iaso__GBL_Rest_Services_Url__c(Name = 'ProductsQuoteAvailability', iaso__Url__c = 'https://ProductsQuote/ko409', iaso__Cache_Partition__c = 'ServicesPartition');
        Account acc = TestFactory.createAccount();
        acc.main_code_id__c = '123567';
        update acc;
        Opportunity opp = TestFactory.createOpportunity(acc.Id, UserInfo.getUserId());
        Product2 prod = TestFactory.createProduct();
        prod.Type_of_quote__c = 'Web';
        update prod;
        OpportunityLineItem oli = TestFactory.createOLI(opp.Id, prod.Id);
        Test.startTest();

        Test.setMock(HttpCalloutMock.class, new Integration_MockGenerator());
        iaso.GBL_Mock.setMock(new Integration_MockGenerator());
        
        Map<String,Object> actual = Container_Product_Form_ctrl.getActions(opp.Id);
        Map<String,Object> expected = new Map<String,Object>();
        expected.put('key', true);
        expected.put('key2', true);
        expected.put('key3', true);
        Map<String,Object> mapCW = new Map<String,Object>(); 
        mapCW.put('showWarning',true);
        expected.put('dataCW',mapCW);
        System.assertEquals(expected, actual);

        Test.stopTest();

    }
}