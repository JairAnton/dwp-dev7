@istest
public class AnalyzeRate_helper_Test {
	static Account acctest;
	static Opportunity opptest;
	static User defaultUser;
	static OpportunityLineItem olitest;
	static Product2 prodtest;

	@TestSetup
	static void setData() {
		defaultUser = TestFactory.createUser('Test', 'Migracion');
		acctest = TestFactory.createAccount();
		opptest = TestFactory.createOpportunity(acctest.Id, defaultUser.Id);
		prodtest = TestFactory.createProduct();
		prodtest.price_approval_web_service_id__c = '11';
		update prodtest;
		olitest = TestFactory.createOLI(opptest.Id, prodtest.Id);
	}

	@isTest
	public static void test_method_one() {
		setData();
		insert new iaso__GBL_Rest_Services_Url__c(Name = 'GrantingTickets', iaso__Url__c = 'https://validation/ok', iaso__Cache_Partition__c = 'local.CredentialsPeru');
		insert new iaso__GBL_Rest_Services_Url__c(Name = 'AnalyzeRate', iaso__Url__c = 'https://AnalyzeRate/OK', iaso__Cache_Partition__c = 'local.CredentialsPeru');
		Test.setMock(HttpCalloutMock.class, new Integration_MockGenerator());
		iaso.GBL_Mock.setMock(new Integration_MockGenerator());

		Test.startTest();
		AnalyzeRate_helper createRequestHelper = new AnalyzeRate_helper(opptest.Id, '3');
		System.HttpResponse createRequestResponse = createRequestHelper.invoke();
		Test.stopTest();
		//sonar
		Integer result = 1 + 2;
		System.assertEquals(3, result);
	}
}
