/**
 * AP_FactoryTest_tst
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
public class AP_FactoryTest_tst {

    /*
	 * @Description  forSetUp
	 */
    @TestSetup
    public static void forSetUp() {
        Final String perfil=[SELECT Id FROM Profile WHERE name='Ejecutivo'].Id;
        //Creación de GOF
        Final Id gerenteRole = [SELECT Id FROM UserRole WHERE DeveloperName = 'GERENTE_BANCA_EMPRESAS_MIRAFLORES' LIMIT 1].Id;
        Map<Schema.SObjectField, Object> mapFields = new Map<Schema.SObjectField, Object>{User.LastName => 'GERENTE', User.ProfileId => perfil, 
           User.prof_position_id__c => 'E01', User.user_position_equivalence__c => 'User Test', User.UserRoleId => gerenteRole};
		Final User gof = TestFactory.getUser(true, mapFields);
        //Creación de ejecutivo
        Final Id ejecutivoRole = [SELECT Id FROM UserRole WHERE DeveloperName = 'EJECUTIVO_BANCA_EMPRESAS_MIRAFLORES' LIMIT 1].Id;
        mapFields = new Map<Schema.SObjectField, Object>{User.LastName => 'EJECUTIVO', User.ProfileId => perfil, 
            User.user_position_equivalence__c => 'User Test', User.ManagerId => gof.Id, User.UserRoleId => ejecutivoRole};
		TestFactory.getUser(true, mapFields);
        //Creación de usuario fuera de AP
        Final Id superiorRole = [SELECT Id FROM UserRole WHERE DeveloperName = 'SUB_GERENTE_PROGRAM_MANAGEMENT' LIMIT 1].Id;
        mapFields = new Map<Schema.SObjectField, Object>{User.LastName => 'MANAGER', User.ProfileId => perfil, 
            User.user_position_equivalence__c => 'User Test', User.UserRoleId => superiorRole};
		TestFactory.getUser(true, mapFields);
        //Obtain admin
        Final User admin = [SELECT Id FROM User WHERE Id=:UserInfo.getUserId() LIMIT 1];
        System.runAs(admin) {
            //Creación cuenta
            TestFactory.createAccount();
            
            insert new acpl__Account_Planning_Type__c(Name = 'Question Catalog',acpl__Default_Type__c = false, acpl__external_reference_id__c = 'TypeTest1');
            
            insert new acpl__AP_PeriodConfiguration__c(Name = 'Configuration', acpl__gf_ap_bus_pl_guide_desc__c = 'BP', acpl__gf_ap_comm_plan_guide_desc__c = 'CP', 
                                                       acpl__gf_ap_strat_anlys_guide_desc__c = 'AE');
            
            final acpl__Account_Planning__c accountPlanning = [SELECT Id FROM acpl__Account_Planning__c WHERE acpl__Account_Planning_Type__r.acpl__external_reference_id__c = 'TypeTest1' LIMIT 1];
            
            final acpl__AP_Question__c apQuestion = createAPQuestion(accountPlanning);
            insert apQuestion;
    
            final dyfr__Template__c dfTemplate = createDfTemplate();
            insert dfTemplate;
    
            final dyfr__Tab__c dfTab = createDfTab(dfTemplate);
            insert dfTab;
    
            // crear field configs
            final dyfr__Field_Config__c fieldConfig = createDfFieldConfig(dfTab);
            fieldConfig.dyfr__DeveloperName__c = apQuestion.Name + '_' + Datetime.now();
            insert fieldConfig;
    
            final dyfr__Dependent_value__c depValue = createDfFieldConfig(fieldConfig);
            insert depValue;
        }
    }
    
    /**
  * Account planning record
  */
    public static acpl__Account_Planning__c createAccountPlanning(String account, String usuario, Id rtId, Boolean unlock) {
        final List<acpl__Account_Planning_Type__c> apTypes = [SELECT Id FROM acpl__Account_Planning_Type__c WHERE acpl__external_reference_id__c = 'TypeTest1' LIMIT 1];
        acpl__Account_Planning_Type__c apType;
        if(apTypes.isEmpty()) {
            apType = new acpl__Account_Planning_Type__c(Name = 'Question Catalog',acpl__Default_Type__c = false, acpl__external_reference_id__c = 'TypeTest1');
            insert apType;
        } else {
            apType = apTypes[0];
        }
		final acpl__Account_Planning__c accountPlanning = new acpl__Account_Planning__c(NAME = 'Account Planning', ACPL__GF_ACCOUNT_PLANNING_NAME__C = 'Full', 
                                                                                        ACPL__GF_AP_INDVI_LOCK_EDIT_IND_TYPE__C = !unlock, ACPL__GF_AP_LAUNCH_NAME__C = 'General period', 
                                                                                        ACPL__GF_AP_LAUNCH_PERIOD_DESC__C = '20/20', ACPL__GF_AP_LIMIT_DATE__C = System.today()+31, 
                                                                                        ACPL__GF_AP_REQ_VALIDATION_IND_TYPE__C = 'Yes', ACPL__GF_AP_STATUS_TYPE_NAME__C = 'Not started', 
                                                                                        ACPL__GF_AP_SUBSTATUS_TYPE_NAME__C = 'Not started', ACPL__GF_MANDATORY_TYPE__C = 'Mandatory', 
                                                                                        acpl__participant_id__c = account, acpl__proposal_manager_id__c = usuario, 
                                                                                        acpl__gf_ap_priority_type_name__c = 'High', acpl__gf_ap_validator_user_id__c = null, 
                                                                                        acpl__Account_Planning_Type__c = apType.Id);
        
        if(String.isNotBlank(rtId)) {
            accountPlanning.recordTypeId = rtId;
        }
        return accountPlanning;
    }
    
    /**
  * Account Planning Question record
  */
    public static acpl__AP_Question__c createAPQuestion(acpl__Account_Planning__c accountPlanning) {
        return new acpl__AP_Question__c(Name = accountPlanning.Id + '_Q' + DateTime.now().getTime()*Math.abs(Math.random()*10), 
                                        acpl__gf_account_planning_id__c = accountPlanning.Id, acpl__gf_ap_question_form_desc__c = 'question');
	}

  /**
  * Dynamic form template record
  */
	public static dyfr__Template__c createDfTemplate() {
        Final dyfr__Template__c dfTemplate = new dyfr__Template__c(dyfr__Template_Code__c = 'dfTemplate_' + DateTime.now().getTime()*Math.abs(Math.random()*10)); 
		dfTemplate.Name = dfTemplate.dyfr__Template_Code__c;
        return dfTemplate;
	}

  /**
  * Dynamic form tab record
  */
	public static dyfr__Tab__c createDfTab(dyfr__Template__c dfTemplate) {
        Final dyfr__Tab__c dfTab = new dyfr__Tab__c(dyfr__Tab_Code__c = 'dfTab_' + DateTime.now().getTime()*Math.abs(Math.random()*10),  
                                                   dyfr__Column_Number__c = 1, dyfr__Template__c = dfTemplate.Id);
        dfTab.Name = dfTab.dyfr__Tab_Code__c;
        return dfTab;
    }

  /**
  * Dynamic form field config record
  */
	public static dyfr__Field_Config__c createDfFieldConfig(dyfr__Tab__c dfTab) {
        return new dyfr__Field_Config__c(dyfr__Tab__c = dfTab.Id);
	}

  /**
  * Dynamic form dependent value record
  */
	public static dyfr__Dependent_value__c createDfFieldConfig(dyfr__Field_Config__c fieldConfig) {
        return new dyfr__Dependent_value__c(dyfr__Field_Config__c = fieldConfig.Id, dyfr__LoV_labels__c = 'value 1,value 2,value 3', 
                                            dyfr__LoV_values__c = 'value 1,value 2,value 3');
	}

	/*
	 * @Description  getUsers
	 */    
    public static Map<String, User> obtainUsers() {
        Final Map<String, User> mapUsers = new Map<String, User>();
        for(User usuario: [SELECT Id, LastName FROM User WHERE user_position_equivalence__c LIKE 'User Test' LIMIT 3]) {
            mapUsers.put(usuario.LastName, usuario);
        }
        return mapUsers;
    }
    
    /*
	 * @Description  SuppresedSonar
	 */
    @isTest
    public static void testForSonar() {
        Test.startTest();
        Final Integer result = obtainUsers().size();
        Test.stopTest();
        System.assertEquals(result, 3, 'FAIL');
    }
    
    /*
	 * @Description  generateProduct
	 */
    public static void generateProduct() {
        Final User admin = [SELECT Id FROM User WHERE Id=:UserInfo.getUserId()];
        System.runAs(admin) {
            final Product2 prod = TestFactory.createProduct();
            prod.IsActive = true;
            prod.ProductCode = 'PC00011';
            prod.Unique_id__c = '0292235_NEW';
            update prod;
            insert new PriceBookEntry(Product2Id=prod.Id, Pricebook2Id=Test.getStandardPricebookId(), UnitPrice=0, IsActive=true, CurrencyIsoCode='PEN');
            final fprd__GBL_Product_version__c prodVersion = new fprd__GBL_Product_version__c(fprd__Active__c = true, fprd__Product__c = prod.Id, fprd__Version_number__c = 1);
            prodVersion.CurrencyIsoCode = 'PEN';
            insert prodVersion;
        }
    }
    
}