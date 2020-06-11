@isTest
public class DisburseQuotation_Test {
	@isTest static void formalizeOppWithPriceQuotationSuccess_test() {
		// Create test data
		Account acctest = TestFactory.createAccount();
		Opportunity opptest = TestFactory.createOpportunity(acctest.Id, UserInfo.getUserId());
		Product2 prodtest = TestFactory.createProduct();
		OpportunityLineItem olitest = TestFactory.createOLI(opptest.Id, prodtest.Id);
		String contractNumber = '1234-1234-1234567890';

		// Prepare opportunity
		List<OpportunityLineItem> oppLineItemToUpdateList = [SELECT Id, price_quote_id__c, price_operation_id__c FROM OpportunityLineItem WHERE Id = : olitest.Id];

		if(!oppLineItemToUpdateList.isEmpty()) {
			oppLineItemToUpdateList[0].price_quote_id__c = '1475650';
			oppLineItemToUpdateList[0].price_operation_id__c = '1469800';
			update oppLineItemToUpdateList[0];
		}

		// Prepare ws mocks
		insert new iaso__GBL_Rest_Services_Url__c(Name = 'GrantingTickets', iaso__Url__c = 'https://validation/ok', iaso__Cache_Partition__c = 'local.CredentialsPeru');
		insert new iaso__GBL_Rest_Services_Url__c(Name = 'ModifyQuotationRequest', iaso__Url__c = 'https://ModifyQuotationRequestDisburse/OK', iaso__Cache_Partition__c = 'local.CredentialsPeru');
		Test.setMock(HttpCalloutMock.class, new Integration_MockGenerator());
		iaso.GBL_Mock.setMock(new Integration_MockGenerator());

		Map<String, Object> resultMap = new Map<String, Object>();

		Test.startTest();
		resultMap = Product_cls.disburseQuotation(opptest.Id, contractNumber);
		Test.stopTest();

		System.assertEquals(true, (Boolean)resultMap.get('success'));
	}

	@isTest static void formalizeOppWithPriceQuotationKnownError_test() {
		// Create test data
		Account acctest = TestFactory.createAccount();
		Opportunity opptest = TestFactory.createOpportunity(acctest.Id, UserInfo.getUserId());
		Product2 prodtest = TestFactory.createProduct();
		OpportunityLineItem olitest = TestFactory.createOLI(opptest.Id, prodtest.Id);
		String contractNumber = '1234-1234-1234567890';

		// Prepare opportunity
		List<OpportunityLineItem> oppLineItemToUpdateList = [SELECT Id, price_quote_id__c, price_operation_id__c FROM OpportunityLineItem WHERE Id = : olitest.Id];

		if(!oppLineItemToUpdateList.isEmpty()) {
			oppLineItemToUpdateList[0].price_quote_id__c = '1475650';
			oppLineItemToUpdateList[0].price_operation_id__c = '1469800';
			update oppLineItemToUpdateList[0];
		}

		// Prepare ws mocks
		insert new iaso__GBL_Rest_Services_Url__c(Name = 'GrantingTickets', iaso__Url__c = 'https://validation/ok', iaso__Cache_Partition__c = 'local.CredentialsPeru');
		insert new iaso__GBL_Rest_Services_Url__c(Name = 'ModifyQuotationRequest', iaso__Url__c = 'https://ModifyQuotationRequestDisburse/KO_409', iaso__Cache_Partition__c = 'local.CredentialsPeru');
		Test.setMock(HttpCalloutMock.class, new Integration_MockGenerator());
		iaso.GBL_Mock.setMock(new Integration_MockGenerator());

		Map<String, Object> resultMap = new Map<String, Object>();

		Test.startTest();
		resultMap = Product_cls.disburseQuotation(opptest.Id, contractNumber);
		Test.stopTest();

		System.assertEquals(false, (Boolean)resultMap.get('success'));
		System.assert (String.valueOf(resultMap.get('errorMessage')).contains(Label.PriceDisburseQuotationKnowError));
	}

	@isTest static void formalizeOppWithPriceQuotationUnknownError_test() {
		// Create test data
		Account acctest = TestFactory.createAccount();
		Opportunity opptest = TestFactory.createOpportunity(acctest.Id, UserInfo.getUserId());
		Product2 prodtest = TestFactory.createProduct();
		OpportunityLineItem olitest = TestFactory.createOLI(opptest.Id, prodtest.Id);
		String contractNumber = '1234-1234-1234567890';

		// Prepare opportunity
		List<OpportunityLineItem> oppLineItemToUpdateList = [SELECT Id, price_quote_id__c, price_operation_id__c FROM OpportunityLineItem WHERE Id = : olitest.Id];

		if(!oppLineItemToUpdateList.isEmpty()) {
			oppLineItemToUpdateList[0].price_quote_id__c = '1475650';
			oppLineItemToUpdateList[0].price_operation_id__c = '1469800';
			update oppLineItemToUpdateList[0];
		}

		// Prepare ws mocks
		insert new iaso__GBL_Rest_Services_Url__c(Name = 'GrantingTickets', iaso__Url__c = 'https://validation/ok', iaso__Cache_Partition__c = 'local.CredentialsPeru');
		insert new iaso__GBL_Rest_Services_Url__c(Name = 'ModifyQuotationRequest', iaso__Url__c = 'https://ModifyQuotationRequestDisburse/KO_500', iaso__Cache_Partition__c = 'local.CredentialsPeru');
		Test.setMock(HttpCalloutMock.class, new Integration_MockGenerator());
		iaso.GBL_Mock.setMock(new Integration_MockGenerator());

		Map<String, Object> resultMap = new Map<String, Object>();

		Test.startTest();
		resultMap = Product_cls.disburseQuotation(opptest.Id, contractNumber);
		Test.stopTest();

		System.assertEquals(false, (Boolean)resultMap.get('success'));
		System.assertEquals(Label.PriceDisburseQuotationUnknowError, String.valueOf(resultMap.get('errorMessage')));
	}
}
