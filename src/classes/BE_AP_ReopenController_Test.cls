@isTest
public class BE_AP_ReopenController_Test {
    /** @Description IN_PROGRESS*/
    Final static String IN_PROGRESS = 'In Progress';
    /** @Description AP_TEAM*/
    Final static String AP_TEAM = 'AP team not invited';
    /** @Description MAP_USERS*/
    Final static Map<String, User> MAP_USERS = AP_FactoryTest_tst.obtainUsers();
    /** @Description EJECUTIVO*/
	Final static String EJECUTIVO = 'EJECUTIVO';

    /* testSetUp */
    @TestSetup
    static void setUp(){
        AP_FactoryTest_tst.forSetUp();   
    }

    /* test reopen */
    static testMethod void testReopen() {
        Final Boolean result;
        Final Account acc = [SELECT Id FROM Account LIMIT 1];
		final acpl__Account_Planning__c apR = AP_FactoryTest_tst.createAccountPlanning(acc.Id, MAP_USERS.get(EJECUTIVO).Id, null, true);
		insert apR;

        apR.acpl__gf_ap_status_type_name__c = IN_PROGRESS;
        apR.acpl__gf_ap_substatus_type_name__c = AP_TEAM;
        apR.acpl__gf_ap_indvi_lock_edit_ind_type__c = true;
        update apR;
        
        Test.startTest();
            result = BE_AP_ReopenController.reopenAPValidated(apR.Id);
        Test.stopTest();
        System.assertEquals(true, result);
    }
}