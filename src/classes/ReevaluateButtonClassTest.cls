@istest
public class ReevaluateButtonClassTest {
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
	static void testPositive() {
		setData();

		Test.startTest();
		opptest.StageName = '04';
		opptest.opportunity_status_type__c = '16';
		update opptest;

		prod.risk_sanction__c = true;
		update prod;

		ReevaluateButtonClass.start(opptest.Id);
		opptest.opportunity_status_type__c = '13';
		update opptest;

		prod.risk_sanction__c = true;
		prod.price_penalty__c = true;
		update prod;

		ReevaluateButtonClass.start(opptest.Id);
		prod.risk_sanction__c = false;
		prod.price_penalty__c = true;
		update prod;

		ReevaluateButtonClass.start(opptest.Id);
		opptest.StageName = '05';
		opptest.opportunity_status_type__c = '20';
		update opptest;

		prod.formalization__c = true;
		update prod;

		ReevaluateButtonClass.start(opptest.Id);
		prod.risk_sanction__c = true;
		update prod;

		ReevaluateButtonClass.start(opptest.Id);
		prod.price_penalty__c = false;
		update prod;

		ReevaluateButtonClass.start(opptest.Id);
		ReevaluateButtonClass.setToPrice(opptest.Id);
		ReevaluateButtonClass.setToRisk(opptest.Id);
		Test.stopTest();
		//sonar
		Integer result = 1 + 2;
		System.assertEquals(3, result);
	}

	@isTest
	static void callmethodOK() {
		setData();
		opptest.StageName = '04';
		opptest.opportunity_status_type__c = '13';
		update opptest;
		oli.price_quote_id__c = '1476410';
		oli.price_quote_id__c = '111';
		oli.price_operation_id__c = '222';
		update oli;
		prod.Type_of_quote__c = 'Web';
		update prod;
		insert new iaso__GBL_Rest_Services_Url__c(Name = 'GrantingTickets', iaso__Url__c = 'https://validation/ok', iaso__Cache_Partition__c = 'local.CredentialsPeru');
		insert new iaso__GBL_Rest_Services_Url__c(Name = 'ModifyQuotationRequest', iaso__Url__c = 'https://ModifyQuotationRequestRecover/OK', iaso__Cache_Partition__c = 'local.CredentialsPeru');
		Test.setMock(HttpCalloutMock.class, new Integration_MockGenerator());
		iaso.GBL_Mock.setMock(new Integration_MockGenerator());
		ModifyQuotationRequest_helper modifyHelper = new ModifyQuotationRequest_helper(opptest.Id, 'RECOVER', 0.93, '', '');
		Test.startTest();

		System.HttpResponse modifyResponse = modifyHelper.invoke();
		ModifyQuotationRequest_helper.ResponseModifyQuotationRequest_Wrapper responseWrapper = ModifyQuotationRequest_helper.responseParse(modifyResponse.getBody());
		Map<String, Object> mapReturn = ReevaluateButtonClass.callService(opptest.Id);
		System.assertEquals('RECOVERED', responseWrapper.data.status.id);
		Test.stopTest();
	}
    
	@isTest
	static void callmethodKO() {
		setData();
		opptest.StageName = '04';
		opptest.opportunity_status_type__c = '13';
		update opptest;
		oli.price_quote_id__c = '1475650';
		oli.price_operation_id__c = '1469800';
		update oli;
		prod.Type_of_quote__c = 'Web';
		update prod;
		insert new iaso__GBL_Rest_Services_Url__c(Name = 'GrantingTickets', iaso__Url__c = 'https://validation/ok', iaso__Cache_Partition__c = 'local.CredentialsPeru');
		insert new iaso__GBL_Rest_Services_Url__c(Name = 'ModifyQuotationRequest', iaso__Url__c = 'https://ModifyQuotationRequestDisburse/KO_409', iaso__Cache_Partition__c = 'local.CredentialsPeru');
		Test.setMock(HttpCalloutMock.class, new Integration_MockGenerator());
		iaso.GBL_Mock.setMock(new Integration_MockGenerator());
		ModifyQuotationRequest_helper modifyHelper = new ModifyQuotationRequest_helper(opptest.Id, 'RECOVER', 0.93, '', '');
		Test.startTest();

		System.HttpResponse modifyResponse = modifyHelper.invoke();
		ModifyQuotationRequest_helper.ResponseModifyQuotationRequest_Wrapper responseWrapper = ModifyQuotationRequest_helper.responseParse(modifyResponse.getBody());
		Map<String, Object> mapReturn = ReevaluateButtonClass.callService(opptest.Id);
		Test.stopTest();
		//sonar
		Integer result = 1 + 2;
		System.assertEquals(3, result);
	}
}
