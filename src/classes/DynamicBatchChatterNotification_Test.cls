@isTest(SeeAllData = true)
public class DynamicBatchChatterNotification_Test {
	static Account acctest;
	static Opportunity opptest;
	static User usertest;
	@isTest
	static void setData() {
		acctest = TestFactory.createAccount();
		usertest = TestFactory.createUser('usernameTestBatch', Label.profAdministrator);
		acctest.OwnerId = usertest.Id;
		update acctest;
		opptest = TestFactory.createOpportunity(acctest.Id, usertest.Id);
		System.assertNotEquals(null, opptest); // Yulino 13/12/2018 : Se agrego el Assets
	}
	@isTest
	static void  dynamicBatch() {
		setData();
		Test.startTest();
		List<String> lstopp = new List<String>();
		lstopp.add(String.valueOf(opptest.Id));
		DynamicBatchChatterNotification.getDynamicBatchChatterNotification(lstopp, 'Opportunity', 'REJECT');

		Test.stopTest();
		System.assertEquals(opptest.Id, lstopp[0]);
	}
}
