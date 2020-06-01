@isTest
private without sharing class Hangout_ctrl_TEST {
	@isTest static void test_getHangoutId() {
		Test.startTest();
		Map<String, String> mapAttributes = new Map<String, String>();
		mapAttributes = Hangout_ctrl.getHangoutId();

		//First, get the user's email
		String userEmail = userinfo.getUserEmail();
		//Then find the '@' and put the domain away
		String userIdTag = userEmail.substring(0, userEmail.indexOf('@'));
		//After that, replace '.' with '_'
		userIdTag = userIdTag.replace('.', '_');

		System.assertEquals(userIdTag.left(15), mapAttributes.get('HangoutId'));
		Test.stopTest();
	}
}
