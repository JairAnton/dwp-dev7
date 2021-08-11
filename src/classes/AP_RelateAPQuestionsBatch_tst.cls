/** Test AP_RelateAPQuestionsBatch
 * Developer                    		Date                Description<p />
 * Jair Anton							11/08/2021			test batch for insert questions to AP
 * @author jair.anton.contractor@bbva.com
 */
@isTest
public class AP_RelateAPQuestionsBatch_tst {
    /**
	 * @Description variable MAP_USERS
	*/
    private static Final Map<String, User> MAP_USERS = AP_FactoryTest_tst.obtainUsers();

    /**
	 * @Description variable EJECUTIVO
	 */
    private static Final String EJECUTIVO = 'EJECUTIVO';

	/**
	 * @Description method setUp
	 */
    @TestSetup
    static void setUp() {
        AP_FactoryTest_tst.forSetUp();
    }

    /**
	 * @Description method loadQuestionsBatch
	 */
    static testMethod void loadQuestionsBatch() {
        Final Account acc = [SELECT Id FROM Account LIMIT 1];
		Final List<acpl__Account_Planning__c> apList = new List<acpl__Account_Planning__c>();
        apList.add(AP_FactoryTest_tst.createAccountPlanning(acc.Id, MAP_USERS.get(EJECUTIVO).Id, null, true));
        apList.add(AP_FactoryTest_tst.createAccountPlanning(acc.Id, MAP_USERS.get(EJECUTIVO).Id, null, true));
        apList.add(AP_FactoryTest_tst.createAccountPlanning(acc.Id, MAP_USERS.get(EJECUTIVO).Id, null, true));
        apList.add(AP_FactoryTest_tst.createAccountPlanning(acc.Id, MAP_USERS.get(EJECUTIVO).Id, null, true));
        apList.add(AP_FactoryTest_tst.createAccountPlanning(acc.Id, MAP_USERS.get(EJECUTIVO).Id, null, true));
		insert apList;

        Final User admin = [SELECT Id FROM User WHERE Id=:UserInfo.getUserId() LIMIT 1];
        System.runas(admin){
            Test.startTest();
                AP_RelateAPQuestionsBatch apBatch = new AP_RelateAPQuestionsBatch();
                DataBase.executeBatch(apBatch);
            Test.stopTest();
            Final List<acpl__AP_Question__c> questionList = [SELECT Id, Name, acpl__gf_account_planning_id__c FROM acpl__AP_Question__c 
                                                                WHERE acpl__gf_account_planning_id__c =: apList[0].Id];
            System.assertEquals(1, questionList.size(), 'success');
        }
    }
}