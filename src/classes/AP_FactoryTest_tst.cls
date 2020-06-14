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
            
            final acpl__Account_Planning__c accountPlanning = TestFactory.createAccountPlanning(null, null, questionRT, false);
            accountPlanning.Name = 'Question Catalog';
            insert accountPlanning;
    
            final acpl__AP_Question__c apQuestion = TestFactory.createAPQuestion(accountPlanning);
            insert apQuestion;
    
            final dyfr__Template__c dfTemplate = TestFactory.createDfTemplate();
            insert dfTemplate;
    
            final dyfr__Tab__c dfTab = TestFactory.createDfTab(dfTemplate);
            insert dfTab;
    
            // crear field configs
            final dyfr__Field_Config__c fieldConfig = TestFactory.createDfFieldConfig(dfTab);
            fieldConfig.dyfr__DeveloperName__c = apQuestion.Name + '_' + Datetime.now();
            insert fieldConfig;
    
            final dyfr__Dependent_value__c depValue = TestFactory.createDfFieldConfig(fieldConfig);
            insert depValue;
        }
    }

	/*
	 * @Description  getUsers
	 */    
    public static Map<String, User> getUsers() {
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
        Final Integer result = getUsers().size();
        Test.stopTest();
        System.assertEquals(3, result, 'FAIL');
    }
}