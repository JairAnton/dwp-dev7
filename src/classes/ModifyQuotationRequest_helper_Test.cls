@istest
global class ModifyQuotationRequest_helper_Test {
	static Account acctest;
	static Opportunity opptest;
	static User defaultUser;
	static OpportunityLineItem olitest;
	static Product2 prodtest;

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
		olitest.price_quote_id__c = '111';
		olitest.price_operation_id__c = '222';
		update olitest;
		insert new iaso__GBL_Rest_Services_Url__c(Name = 'GrantingTickets', iaso__Url__c = 'https://validation/ok', iaso__Cache_Partition__c = 'local.CredentialsPeru');
		insert new iaso__GBL_Rest_Services_Url__c(Name = 'ModifyQuotationRequest', iaso__Url__c = 'https://ModifyQuotationRequestRecover/OK', iaso__Cache_Partition__c = 'local.CredentialsPeru');
		Test.setMock(HttpCalloutMock.class, new Integration_MockGenerator());
		iaso.GBL_Mock.setMock(new Integration_MockGenerator());
		ModifyQuotationRequest_helper modifyHelper = new ModifyQuotationRequest_helper(opptest.Id, 'RECOVER', 0.93, '', null);
		ModifyQuotationRequest_helper modifyHelper2 = new ModifyQuotationRequest_helper(opptest.Id, 'GENERATE_QUOTATION_SHEET', 0.93, '', null);
		ModifyQuotationRequest_helper modifyHelper3 = new ModifyQuotationRequest_helper(opptest.Id, 'RETURN', 0.93, '', null);
		ModifyQuotationRequest_helper modifyHelper4 = new ModifyQuotationRequest_helper(opptest.Id, 'APPROVE', 0.93, '', null);
		ModifyQuotationRequest_helper modifyHelper5 = new ModifyQuotationRequest_helper(opptest.Id, 'RAISE', 0.93, '', null);
		ModifyQuotationRequest_helper modifyHelper6 = new ModifyQuotationRequest_helper(opptest.Id, 'REASSIGN', 0.93, '', '2sdf34');
		ModifyQuotationRequest_helper modifyHelper7 = new ModifyQuotationRequest_helper(opptest.Id, 'REQUEST_APPROVAL', 0.93, '', null);
		ModifyQuotationRequest_helper modifyHelper8 = new ModifyQuotationRequest_helper(opptest.Id, 'REGISTER_LOSS', 0.93, '34;34', null);
		ModifyQuotationRequest_helper modifyHelper9 = new ModifyQuotationRequest_helper(opptest.Id, 'DISBURSE', 0.93, '', null);
		ModifyQuotationRequest_helper modifyHelper10 = new ModifyQuotationRequest_helper(opptest.Id, '', 0.93, '', null);

		Test.startTest();

		System.HttpResponse modifyResponse = modifyHelper.invoke();
		ModifyQuotationRequest_helper.ResponseModifyQuotationRequest_Wrapper responseWrapper = ModifyQuotationRequest_helper.responseParse(modifyResponse.getBody());
		System.assertEquals('RECOVERED', responseWrapper.data.status.id);
		Test.stopTest();
	}
}
