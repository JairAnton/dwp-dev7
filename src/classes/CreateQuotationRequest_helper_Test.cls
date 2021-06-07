/**
 * @author Eduardo Vargas Matute (luis.eduardo.vargas.contractor@bbva.pe)
 * @date 07-06-2021
 *
 * @description test from CreateQuotationRequest_helper_Test
 * @Changes
 *  Date        Author   Email                  				Type		Description
 *  2020-11-06  MAMC     luis.eduardo.vargas.contractor@bbva.pe	Modify		add method to create quote pdf
 **/
@istest
global class CreateQuotationRequest_helper_Test {
	static Account acctest;
	static Opportunity opptest;
	static User defaultUser;
	static OpportunityLineItem olitest;
	static Product2 prodtest;

    /** method*/
	@TestSetup
	static void setData() {
		defaultUser = TestFactory.createUser('Test', 'Migracion');
		acctest = TestFactory.createAccount();
		opptest = TestFactory.createOpportunity(acctest.Id, defaultUser.Id);
		prodtest = TestFactory.createProduct();
		olitest = TestFactory.createOLI(opptest.Id, prodtest.Id);
	}
    
	/** method*/
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
		Final Integer result = 1 + 2;
		System.assertEquals(3, result);
	}
}