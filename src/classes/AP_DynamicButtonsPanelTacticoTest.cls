/** @Name AP_DynamicButtonsPanelTacticoTest
   @Author Lolo Bravo
   @Date 2020-11-04
   Date        Author       Email                           Type
   2021-03-04  LMBR     	lolo.bravo@bbva.com             Creation
   2021-08-18   JAAA        jair.anton.contractor@bbva.com  Valida acceso de boton reabrir
 */
@isTest
public class AP_DynamicButtonsPanelTacticoTest {
    /** @Description MAP_USERS*/
	Final static Map<String, User> MAP_USERS = AP_FactoryTest_tst.obtainUsers();
    /** @Description VALIDATED*/
    Final static String VALIDATED = 'Validated';
    /**@Description IN_PLACE */
    Final static String IN_PLACE = 'In place';
    /**@Description GERENTE*/
    Final static String GERENTE = 'GERENTE';
    /** @Description EJECUTIVO*/
	Final static String EJECUTIVO = 'EJECUTIVO';
    /** @Description IN_PROGRESS*/
    Final static String IN_PROGRESS = 'In Progress';
    /** @Description AP_TEAM*/
    Final static String AP_TEAM = 'AP team not invited';

    /** TestSetup */
    @testSetup 
    static void setup() {
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

        Final User admin = [SELECT Id FROM User WHERE Id=:UserInfo.getUserId() LIMIT 1];
        System.runAs(admin) {
            final acpl__Account_Planning_Type__c apType = new acpl__Account_Planning_Type__c(Name = 'name',acpl__Default_Type__c = false);
            insert apType;
            
            final Account client = new Account(Name = 'Test Client');
            insert client;
            
            final dyfr__Template__c template = new dyfr__Template__c(acpl__Account_Planning_Type__c = apType.Id);
            insert template;

            final dyfr__Tab__c tab = new dyfr__Tab__c(dyfr__Template__c = template.Id);
            insert tab;
            
            final Id devRecordTypeId = Schema.SObjectType.acpl__Account_Planning__c.getRecordTypeInfosByDeveloperName().get('Question_Catalog').getRecordTypeId();
            final acpl__Account_Planning__c accountPlanning = [SELECT Id FROM acpl__Account_Planning__c WHERE RecordType.Id =:devRecordTypeId LIMIT 1];
            final dyfr__Field_Config__c fieldConfig = new dyfr__Field_Config__c();
            fieldConfig.dyfr__Tab__c = tab.Id;
            fieldConfig.dyfr__DeveloperName__c = accountPlanning.Id +'_Q1';
            fieldConfig.dyfr__Relationship_Query_Content__c = accountPlanning.Id +'_Q1';
            fieldConfig.dyfr__Important__c = true;
            fieldConfig.dyfr__Map_field__c = 'acpl__AA_answer_text__c';
            insert fieldConfig;
            final acpl__AP_Question__c apQuestion = new acpl__AP_Question__c();
            apQuestion.Name = accountPlanning.Id + '_Q1';
            apQuestion.acpl__gf_account_planning_id__c = accountPlanning.Id;
            apQuestion.acpl__gf_ap_question_form_desc__c = 'question';
            insert apQuestion;
            final acpl__Account_Plan_Settings__c apSettings = new acpl__Account_Plan_Settings__c();
            apSettings.acpl__Member_Role__c = 'Gestor del Plan';
            insert apSettings;
        }   
    }

    /** TestMethod */
	static testmethod void test() {
        Test.startTest();
        final Id devRecordTypeId = Schema.SObjectType.acpl__Account_Planning__c.getRecordTypeInfosByDeveloperName().get('Question_Catalog').getRecordTypeId();
        final acpl__Account_Planning__c accountPlanning = [SELECT Id FROM acpl__Account_Planning__c WHERE RecordType.Id =:devRecordTypeId LIMIT 1];
        final Set<String> buttonsStatusSet = APDynamicButtonsStatusHandlerTactico.getDynamicButtonStatus(accountPlanning.Id, 'acpl__Account_Planning__c');
       	APButtonsValidationMessagesTactico.getErrorMessagesList(accountPlanning.Id, '', '');
        Test.stopTest();
        System.assert(!buttonsStatusSet.isEmpty(),'Success');
    }
    
    /* test reopen */
    static testMethod void testReopen() {
        Final Set<String> buttonsStatusSet = new Set<String>();
        
        Final Account acc = [SELECT Id FROM Account LIMIT 1];
		final acpl__Account_Planning__c apR = AP_FactoryTest_tst.createAccountPlanning(acc.Id, MAP_USERS.get(EJECUTIVO).Id, null, true);
		insert apR;
		apR.acpl__gf_ap_status_type_name__c = VALIDATED;
        apR.acpl__gf_ap_substatus_type_name__c = IN_PLACE;
        apR.acpl__gf_ap_indvi_lock_edit_ind_type__c = false;
        update apR;
        
        Test.startTest();        
            System.runAs(MAP_USERS.get(GERENTE)) {
                try {
                    buttonsStatusSet.addAll(APDynamicButtonsStatusHandlerTactico.getDynamicButtonStatus(apR.Id, 'acpl__Account_Planning__c'));
                    AP_Reopen_Validation.getErrorMessagesList(apR.Id, '', '');
                } catch(Exception e) {
                    System.debug(e.getMessage());
                }
            }

        Test.stopTest();
        System.assert(!buttonsStatusSet.isEmpty(),'Success');
    }

    /* test elevar */
    static testMethod void testToInProgress() {
        Final Set<String> buttonsStatusSet = new Set<String>();
        Final Account acc = [SELECT Id FROM Account LIMIT 1];

        final acpl__Account_Planning__c apR = AP_FactoryTest_tst.createAccountPlanning(acc.Id, MAP_USERS.get(EJECUTIVO).Id, null, true);
        insert apR;

        apR.acpl__gf_ap_status_type_name__c = IN_PROGRESS;
        apR.acpl__gf_ap_substatus_type_name__c = AP_TEAM;
        apR.acpl__gf_ap_indvi_lock_edit_ind_type__c = true;
        update apR;

        Test.startTest();        
            System.runAs(MAP_USERS.get(EJECUTIVO)) {
                try {
                    buttonsStatusSet.addAll(APDynamicButtonsStatusHandlerTactico.getDynamicButtonStatus(apR.Id, 'acpl__Account_Planning__c'));
                } catch(Exception e) {
                    System.debug(e.getMessage());
                }
            }

        Test.stopTest();
        System.assert(!buttonsStatusSet.isEmpty(),'Success');
    }
}