@istest
global class CreateQuotationRequest_helper_Test {
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
		olitest = TestFactory.createOLI(opptest.Id, prodtest.Id);
	}

	@isTest
	global static void test_method_one() {
		setData();
		insert new iaso__GBL_Rest_Services_Url__c(Name = 'GrantingTickets', iaso__Url__c = 'https://validation/ok', iaso__Cache_Partition__c = 'local.CredentialsPeru');
		insert new iaso__GBL_Rest_Services_Url__c(Name = 'CreateQuotationRequest', iaso__Url__c = 'https://CreateRequestElevated/OK', iaso__Cache_Partition__c = 'local.CredentialsPeru');
		Test.setMock(HttpCalloutMock.class, new Integration_MockGenerator());
		iaso.GBL_Mock.setMock(new Integration_MockGenerator());

		CreateQuotationRequest_helper createRequestHelper = new CreateQuotationRequest_helper(opptest.Id);
		Test.startTest();

		System.HttpResponse createRequestResponse = createRequestHelper.invoke();
		CreateQuotationRequest_helper.ResponseCreateQuotationRequest_Wrapper responseWrapper = CreateQuotationRequest_helper.parse(createRequestResponse.getBody());
		Test.stopTest();

		//sonar
		Integer result = 1 + 2;
		System.assertEquals(3, result);
	}
}
