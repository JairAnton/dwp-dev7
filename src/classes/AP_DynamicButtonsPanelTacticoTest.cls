/**
   -------------------------------------------------------------------------------------------------
   @Name AP_DynamicButtonsPanelTacticoTest
   @Author Lolo Bravo
   @Date 2020-11-04
   @Description
   @Changes
   Date        Author       Email                  Type
   2021-03-04  LMBR     	lolo.bravo@bbva.com    Creation
   -------------------------------------------------------------------------------------------------
 */
@isTest
public class AP_DynamicButtonsPanelTacticoTest {
    /** TestSetup */
    @testSetup 
    static void setup() {
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
        apSettings.acpl__Member_Role__c = 'Role';
        insert apSettings;
        
    }
    /** TestMethod */
	static testmethod void test() { 
        Test.startTest();
        final Id devRecordTypeId = Schema.SObjectType.acpl__Account_Planning__c.getRecordTypeInfosByDeveloperName().get('Question_Catalog').getRecordTypeId();
        final acpl__Account_Planning__c accountPlanning = [SELECT Id FROM acpl__Account_Planning__c WHERE RecordType.Id =:devRecordTypeId LIMIT 1];
        final Set<String> buttonsStatusSet = APDynamicButtonsStatusHandlerTactico.getDynamicButtonStatus(accountPlanning.Id, 'acpl__Account_Planning__c');
        final List<String> lstErrorMessage = APButtonsValidationMessagesTactico.getErrorMessagesList(accountPlanning.Id, '', '');
        Test.stopTest();
        System.assert(!buttonsStatusSet.isEmpty());
    }
}