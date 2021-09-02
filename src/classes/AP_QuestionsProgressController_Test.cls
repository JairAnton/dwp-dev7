@isTest
public class AP_QuestionsProgressController_Test {
    /**
	 * @Description variable MAP_USERS
	 */
	private static Final Map<String, User> MAP_USERS = AP_FactoryTest_tst.obtainUsers();
    /**
	 * @Description variable EJECUTIVO
	 */
    private static Final String EJECUTIVO = 'EJECUTIVO';
    /**
	 * @Description variable handler
	 */
    private static Final acpl.AccountPlanningHandler AP_HANDLER = acpl.AccountPlanningHandler.getInstance();
    
    @TestSetup
    static void makeData(){
        AP_FactoryTest_tst.forSetUp();
    }

    @isTest
    public static void calculateQuestionsTest() {
        Final Account acc = [SELECT Id FROM Account LIMIT 1];
		Final acpl__Account_Planning__c apR = AP_FactoryTest_tst.createAccountPlanning(acc.Id, MAP_USERS.get(EJECUTIVO).Id, null, true);
		insert apR;
        
        Final List<acpl__Account_Planning__c> apList = [SELECT Id, Name, acpl__Account_Planning_Type__c, CreatedDate, acpl__gf_mandatory_type__c FROM acpl__Account_Planning__c 
                                                  WHERE CreatedDate = TODAY AND Name = 'Account Planning'];
        AP_HANDLER.relateAPQuestions(apList);
        
        Final dyfr__Tab__c dfTab = [SELECT Id FROM dyfr__Tab__c LIMIT 1];
        Final List<dyfr__Field_Config__c> fconfigList = new List<dyfr__Field_Config__c>();
        fconfigList.add(new dyfr__Field_Config__c(dyfr__Tab__c = dfTab.Id, dyfr__DeveloperName__c = apR.acpl__Account_Planning_Type__c + '_Q1'));
        fconfigList.add(new dyfr__Field_Config__c(dyfr__Tab__c = dfTab.Id, dyfr__DeveloperName__c = apR.acpl__Account_Planning_Type__c + '_Q2', dyfr__Important__c = true));
        insert fconfigList;

        Final List<acpl__AP_Question__c> questionList = new List<acpl__AP_Question__c>();
        questionList.add(new acpl__AP_Question__c(Name = apR.acpl__Account_Planning_Type__c + '_Q1', acpl__gf_account_planning_id__c = apR.Id, acpl__gf_ap_question_form_desc__c = 'question', acpl__AA_answer_text__c = ''));
        questionList.add(new acpl__AP_Question__c(Name = apR.acpl__Account_Planning_Type__c + '_Q2', acpl__gf_account_planning_id__c = apR.Id, acpl__gf_ap_question_form_desc__c = 'question', acpl__AA_answer_text__c = ''));
        insert questionList;

		Test.startTest();
		System.runAs(MAP_USERS.get(EJECUTIVO)) {
			try {
				questionList[0].acpl__AA_answer_text__c = 'new values';
				update questionList;

                AP_QuestionsProgressController.calculateQuestions(apR.Id);
			} catch(Exception e) {
				System.debug(e.getMessage());
			}
		}
		Test.stopTest();

    }
}
