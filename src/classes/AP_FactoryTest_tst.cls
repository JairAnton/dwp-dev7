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
            Final Id questionRT = [SELECT Id FROM RecordType WHERE DeveloperName = 'Question_Catalog' LIMIT 1].Id;
            //Creación cuenta
            TestFactory.createAccount();

            insert new acpl__AP_PeriodConfiguration__c(Name = 'Configuration', acpl__gf_ap_bus_pl_guide_desc__c = 'BP', acpl__gf_ap_comm_plan_guide_desc__c = 'CP', 
                                                       acpl__gf_ap_strat_anlys_guide_desc__c = 'AE');
            
            final acpl__Account_Planning__c accountPlanning = createAccountPlanning(null, null, questionRT, false);
            accountPlanning.Name = 'Question Catalog';
            insert accountPlanning;
    
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
        final acpl__Account_Planning__c accountPlanning = new acpl__Account_Planning__c(Name = 'Account Planning', acpl__gf_ap_status_type_name__c = 'Not started', 
                                                                                       acpl__gf_ap_substatus_type_name__c = 'Not started', acpl__gf_ap_priority_type_name__c = 'High',
                                                                                       acpl__participant_id__c = account, acpl__gf_mandatory_type__c = 'Mandatory', 
                                                                                       acpl__gf_ap_limit_date__c = System.today()+31, acpl__proposal_manager_id__c = usuario, 
                                                                                       acpl__gf_ap_indvi_lock_edit_ind_type__c = unlock, acpl__gf_ap_validator_user_id__c = null);
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
}