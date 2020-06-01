@isTest
private without sharing class OverrideButtonMessage_ctrl_TEST {
	@isTest static void test_OverrideButtonMessage() {
		Test.startTest();
		Map<String, Object> mapReturn = OverrideButtonMessage_ctrl.getInfo('Test');

		System.assertNotEquals(mapReturn.get('data'), null);
		Test.stopTest();
	}
}
