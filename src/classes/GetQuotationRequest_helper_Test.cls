@istest
global class GetQuotationRequest_helper_Test {
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

		olitest.price_quote_id__c = '1111';
		update olitest;

		insert new iaso__GBL_Rest_Services_Url__c(Name = 'GrantingTickets', iaso__Url__c = 'https://validation/ok', iaso__Cache_Partition__c = 'local.CredentialsPeru');
		insert new iaso__GBL_Rest_Services_Url__c(Name = 'GetQuotationRequest', iaso__Url__c = 'https://GetQuotationRequest/OK', iaso__Cache_Partition__c = 'local.CredentialsPeru');
		Test.setMock(HttpCalloutMock.class, new Integration_MockGenerator());
		iaso.GBL_Mock.setMock(new Integration_MockGenerator());

		GetQuotationRequest_helper getRequestHelper = new GetQuotationRequest_helper(opptest.Id);
		Test.startTest();

		System.HttpResponse getRequestResponse = getRequestHelper.invoke();
		GetQuotationRequest_helper.ResponseGetQuotationRequest_Wrapper responseWrapper = GetQuotationRequest_helper.parse(getRequestResponse.getBody());
		Test.stopTest();
	}
}
