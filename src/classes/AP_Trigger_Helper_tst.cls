/** @Name AP_Trigger_Helper_tst
* @Author Jair Anton jair.anton.contractor@bbva.com
* @Date Created: 2021-08-19
* Jair Anton 		19/08/2021		Cobertura clase AP_ConvertCPE_cls
*/
@isTest
public class AP_Trigger_Helper_tst {
    /** @Description MAP_USERS*/
	Final static Map<String, User> MAP_USERS = AP_FactoryTest_tst.obtainUsers();
    /**@Description IN_PLACE */
    Final static String IN_PLACE = 'In place';
    /** @Description EJECUTIVO*/
	Final static String EJECUTIVO = 'EJECUTIVO';
    /** @Description IN_PROGRESS*/
    Final static String IN_PROGRESS = 'In Progress';
    /**@Description VALIDATED*/
    Final static String VALIDATED = 'Validated';
    /**@Description SUCCESS*/
    Final static String SUCCESS = 'Success';
    /**@Description RECORD_NNAME*/
    Final static String RECORD_NAME = 'AP_RECORD_102 - 2020-05-31';

    /* setUp */
    @TestSetup
    static void setUp() {
		AP_FactoryTest_tst.forSetUp();
		AP_FactoryTest_tst.generateProduct();
        
        Final User usr1 = [SELECT Id, Name FROM User WHERE LastName = 'GERENTE'];
        Final String perfil=[SELECT Id FROM Profile WHERE name='Ejecutivo'].Id;
        Final Id ejecutivoRole = [SELECT Id FROM UserRole WHERE DeveloperName = 'EJECUTIVO_BANCA_EMPRESAS_MIRAFLORES' LIMIT 1].Id;
        Map<Schema.SObjectField, Object> mapFields = new Map<Schema.SObjectField, Object>{User.LastName => 'EJECUTIVO 2', User.ProfileId => perfil, 
            User.user_position_equivalence__c => 'User Test', User.ManagerId => usr1.Id, User.UserRoleId => ejecutivoRole};
		TestFactory.getUser(true, mapFields);
        mapFields = new Map<Schema.SObjectField, Object>{User.LastName => 'EJECUTIVO 3', User.ProfileId => perfil, 
            User.user_position_equivalence__c => 'User Test', User.ManagerId => usr1.Id, User.UserRoleId => ejecutivoRole};
		TestFactory.getUser(true, mapFields);

        Final User admin = [SELECT Id FROM User WHERE Id=:UserInfo.getUserId()];
        Final Account acc = [SELECT Id FROM Account LIMIT 1];
        Final User usr2 = [SELECT Id, LastName FROM User WHERE LastName = 'EJECUTIVO'];
        System.runAs(admin) {
            createAP(acc.Id, usr2.Id, true);
            
            final Product2 prod = TestFactory.createProduct();
            prod.IsActive = true;
            prod.ProductCode = 'PC00012';
            prod.Unique_id__c = '0292230_NEW';
            update prod;
            insert new PriceBookEntry(Product2Id=prod.Id, Pricebook2Id=Test.getStandardPricebookId(), UnitPrice=0, IsActive=true, CurrencyIsoCode='USD');
            final fprd__GBL_Product_version__c prodVersion = new fprd__GBL_Product_version__c(fprd__Active__c = true, fprd__Product__c = prod.Id, fprd__Version_number__c = 1);
            prodVersion.CurrencyIsoCode = 'USD';
            insert prodVersion;
        }
    }
    
    private static void createAP(String account, String usuario, Boolean unlock) {
        final List<acpl__Account_Planning_Type__c> apTypes = [SELECT Id FROM acpl__Account_Planning_Type__c WHERE acpl__external_reference_id__c = 'TypeTest1' LIMIT 1];
        acpl__Account_Planning_Type__c apType;
        if(apTypes.isEmpty()) {
            apType = new acpl__Account_Planning_Type__c(Name = 'Question Catalog',acpl__Default_Type__c = false, acpl__external_reference_id__c = 'TypeTest1');
            insert apType;
        } else {
            apType = apTypes[0];
        }
		final acpl__Account_Planning__c accountPlanning = new acpl__Account_Planning__c(NAME = 'Account Planning', ACPL__GF_ACCOUNT_PLANNING_NAME__C = 'Full', 
                                                                                        ACPL__GF_AP_INDVI_LOCK_EDIT_IND_TYPE__C = unlock, ACPL__GF_AP_LAUNCH_NAME__C = 'General period', 
                                                                                        ACPL__GF_AP_LAUNCH_PERIOD_DESC__C = '20/20', ACPL__GF_AP_LIMIT_DATE__C = System.today()+31, 
                                                                                        ACPL__GF_AP_REQ_VALIDATION_IND_TYPE__C = 'Yes', ACPL__GF_AP_STATUS_TYPE_NAME__C = 'Not started', 
                                                                                        ACPL__GF_AP_SUBSTATUS_TYPE_NAME__C = 'Not started', ACPL__GF_MANDATORY_TYPE__C = 'Mandatory', 
                                                                                        acpl__participant_id__c = account, acpl__proposal_manager_id__c = usuario,
                                                                                        acpl__gf_ap_priority_type_name__c = 'High', acpl__gf_ap_validator_user_id__c = null, 
                                                                                        acpl__Account_Planning_Type__c = apType.Id, acpl__gf_ap_validation_date__c = Date.today());
        
        insert accountPlanning;
        
        
        final bupl__BusinessPlan__c bussPlan = new bupl__BusinessPlan__c(Name = 'Plan de Negocio AP_RECORD_102', bupl__gf_ap_public_ind_type__c = false, 
                                                                        bupl__gf_business_growth_rec_number__c = 1, bupl__status_type__c = 'Not started', 
                                                                        acpl__gf_account_planning_id__c = accountPlanning.id);
        insert bussPlan;
    }

	   /**
	 * @Description Test update record
	 */
	@isTest
	static void updateAPActionsTest() {
        Final Map<Id, acpl__Account_Planning__c> apMap = new Map<Id, acpl__Account_Planning__c>();
        final acpl__Account_Planning__c accPlan = [SELECT Id, NAME, ACPL__GF_ACCOUNT_PLANNING_NAME__C, ACPL__GF_AP_INDVI_LOCK_EDIT_IND_TYPE__C, ACPL__GF_AP_LAUNCH_NAME__C, ACPL__GF_AP_LAUNCH_PERIOD_DESC__C, ACPL__GF_AP_LIMIT_DATE__C, 
                                                    ACPL__GF_AP_REQ_VALIDATION_IND_TYPE__C, ACPL__GF_AP_STATUS_TYPE_NAME__C, ACPL__GF_AP_SUBSTATUS_TYPE_NAME__C, ACPL__GF_MANDATORY_TYPE__C, acpl__participant_id__c, 
                                                    acpl__proposal_manager_id__c, acpl__gf_ap_priority_type_name__c, acpl__gf_ap_validator_user_id__c, acpl__Account_Planning_Type__c, acpl__gf_ap_validation_date__c 
                                                   FROM acpl__Account_Planning__c WHERE Name = 'Account Planning' LIMIT 1];
		
		Test.startTest();
			System.runAs(MAP_USERS.get(EJECUTIVO)) {
				try {	
					createActions(accPlan);
					accPlan.acpl__gf_ap_status_type_name__c = VALIDATED;
					accPlan.acpl__gf_ap_substatus_type_name__c = IN_PLACE;
					accPlan.acpl__gf_ap_indvi_lock_edit_ind_type__c = false;
                    
        			apMap.put(accPlan.Id, accPlan);
					AP_Trigger_Helper.postValidated(apMap);
					updateActions(accPlan);

					accPlan.acpl__gf_ap_status_type_name__c = VALIDATED;
					accPlan.acpl__gf_ap_substatus_type_name__c = IN_PLACE;
					accPlan.acpl__gf_ap_indvi_lock_edit_ind_type__c = false;
					update accPlan;
				} catch(Exception e) {
					System.debug(e.getMessage());
				}
			}
		Test.stopTest();
        Final List<acpl__Commercial_Plan_Event__c> cpeList = [SELECT Id, Name, acpl__gf_account_planning_id__c FROM acpl__Commercial_Plan_Event__c WHERE acpl__gf_account_planning_id__c =: accPlan.Id];
        System.assert(cpeList.size() == 3, SUCCESS);
	}

       /**
	 * @Description Test update record with GD
	 */
	@isTest
	static void updateAPGDTest() {
        Final Map<Id, acpl__Account_Planning__c> apMap = new Map<Id, acpl__Account_Planning__c>();
        final acpl__Account_Planning__c accPlan = [SELECT Id, NAME, ACPL__GF_ACCOUNT_PLANNING_NAME__C, ACPL__GF_AP_INDVI_LOCK_EDIT_IND_TYPE__C, ACPL__GF_AP_LAUNCH_NAME__C, ACPL__GF_AP_LAUNCH_PERIOD_DESC__C, ACPL__GF_AP_LIMIT_DATE__C, 
                                                    ACPL__GF_AP_REQ_VALIDATION_IND_TYPE__C, ACPL__GF_AP_STATUS_TYPE_NAME__C, ACPL__GF_AP_SUBSTATUS_TYPE_NAME__C, ACPL__GF_MANDATORY_TYPE__C, acpl__participant_id__c, 
                                                    acpl__proposal_manager_id__c, acpl__gf_ap_priority_type_name__c, acpl__gf_ap_validator_user_id__c, acpl__Account_Planning_Type__c, acpl__gf_ap_validation_date__c 
                                                   FROM acpl__Account_Planning__c WHERE Name = 'Account Planning' LIMIT 1];
		
        Final bupl__BusinessPlan__c bpAux = [SELECT Id, acpl__gf_account_planning_id__c FROM bupl__BusinessPlan__c LIMIT 1];

		Test.startTest();
			System.runAs(MAP_USERS.get(EJECUTIVO)) {
				try {	
                    createGrowthDriver(accPlan, bpAux);
					accPlan.acpl__gf_ap_status_type_name__c = VALIDATED;
					accPlan.acpl__gf_ap_substatus_type_name__c = IN_PLACE;
					accPlan.acpl__gf_ap_indvi_lock_edit_ind_type__c = false;
                    accPlan.acpl__gf_ap_validation_date__c = Date.today();
                    
        			apMap.put(accPlan.Id, accPlan);
					AP_Trigger_Helper.postValidated(apMap);
					updateGrowthDriver(accPlan);
                    
					AP_Trigger_Helper.postValidated(apMap);
				} catch(Exception e) {
					System.debug(e.getMessage());
				}
			}
		Test.stopTest();

		Final bupl__BP_GrowthDriver__c gdItem = [SELECT Id, bupl__solution_category_desc__c, acpl__gf_account_planning_id__c FROM bupl__BP_GrowthDriver__c WHERE acpl__gf_account_planning_id__c =: accPlan.Id LIMIT 1];
        System.assert(gdItem.bupl__solution_category_desc__c == '0292230_NEW', SUCCESS);
	}

       /**
	 * @Description Test update record with GD
	 */
	@isTest
	static void updateAPAmountTest() {
        Final Map<Id, acpl__Account_Planning__c> apMap = new Map<Id, acpl__Account_Planning__c>();
        final acpl__Account_Planning__c accPlan = [SELECT Id, NAME, ACPL__GF_ACCOUNT_PLANNING_NAME__C, ACPL__GF_AP_INDVI_LOCK_EDIT_IND_TYPE__C, ACPL__GF_AP_LAUNCH_NAME__C, ACPL__GF_AP_LAUNCH_PERIOD_DESC__C, ACPL__GF_AP_LIMIT_DATE__C, 
                                                    ACPL__GF_AP_REQ_VALIDATION_IND_TYPE__C, ACPL__GF_AP_STATUS_TYPE_NAME__C, ACPL__GF_AP_SUBSTATUS_TYPE_NAME__C, ACPL__GF_MANDATORY_TYPE__C, acpl__participant_id__c, 
                                                    acpl__proposal_manager_id__c, acpl__gf_ap_priority_type_name__c, acpl__gf_ap_validator_user_id__c, acpl__Account_Planning_Type__c, acpl__gf_ap_validation_date__c 
                                                   FROM acpl__Account_Planning__c WHERE Name = 'Account Planning' LIMIT 1];
		
        Final bupl__BusinessPlan__c bpAux = [SELECT Id, acpl__gf_account_planning_id__c FROM bupl__BusinessPlan__c LIMIT 1];

		Test.startTest();
			System.runAs(MAP_USERS.get(EJECUTIVO)) {
				try {	
                    createGrowthDriver(accPlan, bpAux);
					accPlan.acpl__gf_ap_status_type_name__c = VALIDATED;
					accPlan.acpl__gf_ap_substatus_type_name__c = IN_PLACE;
					accPlan.acpl__gf_ap_indvi_lock_edit_ind_type__c = false;
                    accPlan.acpl__gf_ap_validation_date__c = Date.today();
                    
        			apMap.put(accPlan.Id, accPlan);
					AP_Trigger_Helper.postValidated(apMap);
					updateAmountGD(accPlan);
                    
					AP_Trigger_Helper.postValidated(apMap);
				} catch(Exception e) {
					System.debug(e.getMessage());
				}
			}
		Test.stopTest();
        Final bupl__BP_GrowthDriver__c gdItem = [SELECT Id, bupl__solution_category_desc__c, acpl__gf_account_planning_id__c, Amount__c FROM bupl__BP_GrowthDriver__c WHERE acpl__gf_account_planning_id__c =: accPlan.Id LIMIT 1];
        System.assert(gdItem.Amount__c == 100300, SUCCESS);

	}

	private static void createActions(acpl__Account_Planning__c accPlan) {	
        Final User usr1 = [SELECT Id, Name FROM User WHERE LastName = 'EJECUTIVO 2'];
        Final List<acpl__Commercial_Plan_Event__c> cpeList = new List<acpl__Commercial_Plan_Event__c>();
		cpeList.add(new acpl__Commercial_Plan_Event__c(Name = RECORD_NAME, acpl__gf_account_planning_id__c = accPlan.Id, acpl__gf_comm_plan_event_type_name__c = 'Task', 
														acpl__gf_event_date__c = System.today(), acpl__participant_id__c = accPlan.acpl__participant_id__c));
    	cpeList.add(new acpl__Commercial_Plan_Event__c(Name = RECORD_NAME, acpl__gf_account_planning_id__c = accPlan.Id, acpl__gf_comm_plan_event_type_name__c = 'Opportunity', 
					acpl__gf_event_date__c = System.today(), acpl__participant_id__c = accPlan.acpl__participant_id__c));
		cpeList.add(new acpl__Commercial_Plan_Event__c(Name = RECORD_NAME, acpl__gf_account_planning_id__c = accPlan.Id, acpl__gf_comm_plan_event_type_name__c = 'Visit', 
					acpl__gf_event_date__c = System.today(), acpl__participant_id__c = accPlan.acpl__participant_id__c, Asiggned_User__c = usr1.Id));
        
        insert cpeList;
	}

	private static void updateActions(acpl__Account_Planning__c accPlan) {
		Final List<acpl__Commercial_Plan_Event__c> cpeList = [SELECT Id, Name, acpl__gf_account_planning_id__c, acpl__gf_comm_plan_event_type_name__c, acpl__gf_event_date__c, acpl__participant_id__c 
																FROM acpl__Commercial_Plan_Event__c WHERE acpl__gf_account_planning_id__c =: accPlan.Id];

		for(acpl__Commercial_Plan_Event__c item : cpeList) {
			item.acpl__gf_event_date__c = System.today().addDays(30);
		}
        
        update cpeList;
	}

    private static void createGrowthDriver(acpl__Account_Planning__c accPlan, bupl__BusinessPlan__c bpAux) {
        Final User usr1 = [SELECT Id, Name FROM User WHERE LastName = 'EJECUTIVO 2'];
        Final bupl__BP_GrowthDriver__c growthDriver = new bupl__BP_GrowthDriver__c(bupl__gf_business_plan_id__c = bpAux.Id, bupl__gf_business_growth_rec_number__c = 1, ExpectedDate__c = System.today(), 
                                     bupl__solution_category_desc__c = '0292235_NEW', CurrencyIsoCode = 'PEN', bupl__solution_category_id__c = 'Riesgo de firma', 
                                     acpl__gf_account_planning_id__c = accPlan.Id);
		
		insert growthDriver;
        
        Final acpl__Commercial_Plan_Event__c cpeItem = new acpl__Commercial_Plan_Event__c(Name = RECORD_NAME, acpl__gf_account_planning_id__c = accPlan.Id, acpl__gf_comm_plan_event_type_name__c = 'Opportunity', 
					acpl__gf_event_date__c = System.today(), acpl__participant_id__c = accPlan.acpl__participant_id__c, GrowthDriver__c = growthDriver.Id, Asiggned_User__c = usr1.Id);
        insert cpeItem;
    }

    private static void updateGrowthDriver(acpl__Account_Planning__c accPlan) {
        Final User usr1 = [SELECT Id, Name FROM User WHERE LastName = 'EJECUTIVO 3'];    
		Final List<bupl__BP_GrowthDriver__c> growthList = [SELECT Id, bupl__gf_business_plan_id__c, bupl__gf_business_growth_rec_number__c, ExpectedDate__c, bupl__solution_category_desc__c, 
							CurrencyIsoCode, bupl__solution_category_id__c, acpl__gf_account_planning_id__c FROM bupl__BP_GrowthDriver__c WHERE acpl__gf_account_planning_id__c =: accPlan.Id LIMIT 1];
    
		growthList[0].CurrencyIsoCode = 'USD';
        growthList[0].bupl__solution_category_desc__c = '0292230_NEW';
		update growthList;
        
        Final List<acpl__Commercial_Plan_Event__c> cpeList = [SELECT Id, Name, acpl__gf_account_planning_id__c, acpl__gf_comm_plan_event_type_name__c, acpl__gf_event_date__c, acpl__participant_id__c, Asiggned_User__c,
														GrowthDriver__c FROM acpl__Commercial_Plan_Event__c WHERE acpl__gf_account_planning_id__c =: accPlan.Id];

        cpeList[0].Asiggned_User__c = usr1.Id;
        update cpeList;
    }

    private static void updateAmountGD(acpl__Account_Planning__c accPlan) {
        Final User usr1 = [SELECT Id, Name FROM User WHERE LastName = 'EJECUTIVO 3'];    
		Final List<bupl__BP_GrowthDriver__c> growthList = [SELECT Id, bupl__gf_business_plan_id__c, bupl__gf_business_growth_rec_number__c, ExpectedDate__c, bupl__solution_category_desc__c, 
							CurrencyIsoCode, bupl__solution_category_id__c, acpl__gf_account_planning_id__c FROM bupl__BP_GrowthDriver__c WHERE acpl__gf_account_planning_id__c =: accPlan.Id LIMIT 1];
    
		growthList[0].Amount__c = 100300;
		update growthList;
        
        Final List<acpl__Commercial_Plan_Event__c> cpeList = [SELECT Id, Name, acpl__gf_account_planning_id__c, acpl__gf_comm_plan_event_type_name__c, acpl__gf_event_date__c, acpl__participant_id__c, Asiggned_User__c,
														GrowthDriver__c FROM acpl__Commercial_Plan_Event__c WHERE acpl__gf_account_planning_id__c =: accPlan.Id];

        cpeList[0].Asiggned_User__c = usr1.Id;
        update cpeList;
    }
}