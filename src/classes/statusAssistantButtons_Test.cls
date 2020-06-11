@IsTest
public class statusAssistantButtons_Test {
	@isTest
	static void test_method_one() {
		User usr1 = TestFactory.createUser('TestUser1', 'Ejecutivo');
		System.runAs(usr1) {
			Set<String> setIds = statusAssistantButtons.getDynamicButtonStatus(usr1.Id, '');
			System.assert (setIds.contains('btnAssistant'));
		}
	}
}
