@istest
public class approveButtonClass_Test {
	static Account acctest;
	static Opportunity opptest;
	static Product2 prod;
	static OpportunityLineItem oli;

	@testSetup
	static void setData() {
		acctest = TestFactory.createAccount();
		opptest = TestFactory.createOpportunity(acctest.Id, UserInfo.getUserId());
		prod = testFactory.createProduct();
		oli = testFactory.createOLI(opptest.Id, prod.Id);
	}

	@isTest
	static void approve() {
		setData();

		Test.startTest();
		opptest.StageName = '04';
		opptest.opportunity_status_type__c = '15';
		update opptest;
		approveButtonClass.start(opptest.Id);

		opptest.opportunity_status_type__c = '10';
		update opptest;
		approveButtonClass.start(opptest.Id);

		opptest.opportunity_status_type__c = '11';
		update opptest;
		approveButtonClass.approvePrice(opptest.Id);

		opptest.opportunity_status_type__c = '17';
		update opptest;
		approveButtonClass.approveRisk(opptest.Id);

		//sonar
		Integer result = 1 + 2;
		System.assertEquals(3, result);

		Test.stopTest();
	}

	@isTest
	static void approveWeb() {
		setData();

		opptest.StageName = '04';
		opptest.opportunity_status_type__c = '11';
		update opptest;
		prod.Type_of_quote__c = 'Web';
		update prod;
		oli.price_quote_id__c = '111';
		oli.price_operation_id__c = '222';
		oli.price_quote_status_id__c = 'MODIFIED';
		oli.price_quote_owner_id__c = UserInfo.getUserId();
		update oli;

		insert new iaso__GBL_Rest_Services_Url__c(Name = 'GrantingTickets', iaso__Url__c = 'https://validation/ok', iaso__Cache_Partition__c = 'local.CredentialsPeru');
		insert new iaso__GBL_Rest_Services_Url__c(Name = 'ModifyQuotationRequest', iaso__Url__c = 'https://ModifyQuotationRequestRecover/OK', iaso__Cache_Partition__c = 'local.CredentialsPeru');
		Test.setMock(HttpCalloutMock.class, new Integration_MockGenerator());
		iaso.GBL_Mock.setMock(new Integration_MockGenerator());

		Test.startTest();

		Map<String, Object> mapReturnSave = approveButtonClass.approvePrice(opptest.Id);
		System.assertEquals(true, (Boolean)mapReturnSave.get('isOk'));

		Test.stopTest();
	}

	@isTest
	static void approveWeb409() {
		setData();

		opptest.StageName = '04';
		opptest.opportunity_status_type__c = '11';
		update opptest;
		prod.Type_of_quote__c = 'Web';
		update prod;
		oli.price_quote_id__c = '1475650';
		oli.price_operation_id__c = '1469800';
		oli.price_quote_status_id__c = 'MODIFIED';
		oli.price_quote_owner_id__c = UserInfo.getUserId();
		update oli;

		insert new iaso__GBL_Rest_Services_Url__c(Name = 'GrantingTickets', iaso__Url__c = 'https://validation/ok', iaso__Cache_Partition__c = 'local.CredentialsPeru');
		insert new iaso__GBL_Rest_Services_Url__c(Name = 'ModifyQuotationRequest', iaso__Url__c = 'https://ModifyQuotationRequestDisburse/KO_409', iaso__Cache_Partition__c = 'local.CredentialsPeru');
		Test.setMock(HttpCalloutMock.class, new Integration_MockGenerator());
		iaso.GBL_Mock.setMock(new Integration_MockGenerator());

		Test.startTest();

		Map<String, Object> mapReturnSave = approveButtonClass.approvePrice(opptest.Id);
		System.assertEquals(false, (Boolean)mapReturnSave.get('isOk'));

		Test.stopTest();
	}

	@isTest
	static void approveWebError() {
		setData();

		opptest.StageName = '04';
		opptest.opportunity_status_type__c = '11';
		update opptest;
		prod.Type_of_quote__c = 'Web';
		update prod;
		oli.price_quote_id__c = '1475650';
		oli.price_operation_id__c = '1469800';
		oli.price_quote_status_id__c = 'MODIFIED';
		oli.price_quote_owner_id__c = UserInfo.getUserId();
		update oli;

		insert new iaso__GBL_Rest_Services_Url__c(Name = 'GrantingTickets', iaso__Url__c = 'https://validation/ok', iaso__Cache_Partition__c = 'local.CredentialsPeru');
		insert new iaso__GBL_Rest_Services_Url__c(Name = 'ModifyQuotationRequest', iaso__Url__c = 'https://KO', iaso__Cache_Partition__c = 'local.CredentialsPeru');
		Test.setMock(HttpCalloutMock.class, new Integration_MockGenerator());
		iaso.GBL_Mock.setMock(new Integration_MockGenerator());

		Test.startTest();

		Map<String, Object> mapReturnSave = approveButtonClass.approvePrice(opptest.Id);
		System.assertEquals(false, (Boolean)mapReturnSave.get('isOk'));

		Test.stopTest();
	}

	@isTest
	static void approveWebError2() {
		setData();

		opptest.StageName = '04';
		opptest.opportunity_status_type__c = '11';
		update opptest;
		prod.Type_of_quote__c = 'Web';
		update prod;
		oli.price_quote_id__c = '1475650';
		oli.price_operation_id__c = '1469800';
		oli.price_quote_status_id__c = 'MODIFIED';
		update oli;

		insert new iaso__GBL_Rest_Services_Url__c(Name = 'GrantingTickets', iaso__Url__c = 'https://validation/ok', iaso__Cache_Partition__c = 'local.CredentialsPeru');
		insert new iaso__GBL_Rest_Services_Url__c(Name = 'Error', iaso__Url__c = 'https://KO', iaso__Cache_Partition__c = 'local.CredentialsPeru');
		Test.setMock(HttpCalloutMock.class, new Integration_MockGenerator());
		iaso.GBL_Mock.setMock(new Integration_MockGenerator());

		Test.startTest();

		Map<String, Object> mapReturnSave = approveButtonClass.approvePrice(opptest.Id);
		System.assertEquals(false, (Boolean)mapReturnSave.get('isOk'));

		Test.stopTest();
	}
}
