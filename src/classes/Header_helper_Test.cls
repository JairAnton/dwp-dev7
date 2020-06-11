@istest
public class Header_helper_Test {
	@isTest
	public static void test_method_one() {
		User userTest = TestFactory.createUser('UserOwnerTest01', 'Ejecutivo');
		userTest.user_id__c = 'P02345';
		update userTest;
		System.runAs(userTest) {
			Test.startTest();
			System.HttpRequest req = new System.HttpRequest();
			Header_helper.modifyRequest(req);
			System.assertEquals(req.getHeader('back-clientdocument'), 'P02345');
			Test.stopTest();
		}
	}
}
