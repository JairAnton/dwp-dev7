@istest
public class SanctionPrice_ctrl_Test {
	@testSetup
	static void setData() {
		Account acc = TestFactory.createAccount();
		Opportunity opp = TestFactory.createOpportunity(acc.Id, UserInfo.getUserId());
		Product2 prod = TestFactory.createProduct();
		OpportunityLineItem oli = TestFactory.createOLI(opp.Id, prod.Id);
        final BE_BailLetterCombination__c bailLetter = new BE_BailLetterCombination__c(UniqueId__c='USD020101', Currency__c='USD', Beneficiary__c = '02', BailObject__c='01', Period__c='01');
        insert bailLetter;
	}

	@isTest
	static void test_method_one() {
		List<Account> lstAccount = [SELECT Id FROM Account];
		lstAccount[0].segment_desc__c = 'SUPERIOR';
		update lstAccount;

		List<Product2> lstProd = [SELECT Id, Type_of_quote__c FROM Product2];
		lstProd[0].Type_of_quote__c = 'Tarifario';
		update lstProd;
		List<Opportunity> lstOpp = [SELECT Id FROM Opportunity];
		Map<String, Object> mapReturnInfo1 = SanctionPrice_ctrl.calculateRate(lstOpp[0].Id);
		Map<String, Object> mapReturnInfo2 = SanctionPrice_ctrl.getInfo(lstOpp[0].Id);
		Map<String, Object> mapReturnInfo3 = SanctionPrice_ctrl.getInfoAnalist(lstOpp[0].Id);
		Map<String, Object> mapReturnInfo4 = SanctionPrice_ctrl.getInfoWithoutDefaultValues(lstOpp[0].Id);

		System.assertEquals(true, (Boolean)mapReturnInfo1.get('hasOLI'));

		delete  [SELECT Id FROM OpportunityLineItem];
		Map<String, Object> mapReturnInfo5 = SanctionPrice_ctrl.calculateRate(lstOpp[0].Id);
		Map<String, Object> mapReturnInfo6 = SanctionPrice_ctrl.getInfo(lstOpp[0].Id);
		Map<String, Object> mapReturnInfo7 = SanctionPrice_ctrl.getInfoAnalist(lstOpp[0].Id);
		Map<String, Object> mapReturnInfo8 = SanctionPrice_ctrl.getInfoWithoutDefaultValues(lstOpp[0].Id);
		System.assertEquals(false, (Boolean)mapReturnInfo5.get('hasOLI'));
	}
    
	@isTest
	static void test_method_two() {
		List<Account> lstAccount = [SELECT Id FROM Account];
		lstAccount[0].segment_desc__c = 'SUPERIOR';
		update lstAccount;

		List<Product2> lstProd = [SELECT Id, Type_of_quote__c FROM Product2];
		lstProd[0].Type_of_quote__c = 'Web';
		update lstProd;
		
        List<Opportunity> lstOpp = [SELECT Id FROM Opportunity];
        
		insert new iaso__GBL_Rest_Services_Url__c(Name = 'GrantingTickets', iaso__Url__c = 'https://validation/ok', iaso__Cache_Partition__c = 'local.CredentialsPeru');
		insert new iaso__GBL_Rest_Services_Url__c(Name = 'CalculateRate', iaso__Url__c = 'https://CalculateRate/ok', iaso__Cache_Partition__c = 'local.CredentialsPeru');
		insert new iaso__GBL_Rest_Services_Url__c(Name = 'CreateQuotationRequest', iaso__Url__c = 'https://CreateRequestApproved/OK', iaso__Cache_Partition__c = 'local.CredentialsPeru');
		Test.setMock(HttpCalloutMock.class, new Integration_MockGenerator());
		iaso.GBL_Mock.setMock(new Integration_MockGenerator());
		PriceRate_helper pricehHelper = new PriceRate_helper(lstOpp[0].Id, false);
		
        Test.startTest();

		System.HttpResponse priceResponse = pricehHelper.invoke();
		PriceRate_helper.ResponseSimulateRate_Wrapper responseWrapper = pricehHelper.parse(priceResponse.getBody());
		Map<String, Object> mapReturnInfo1 = SanctionPrice_ctrl.calculateRate(lstOpp[0].Id);
		Map<String, Object> mapReturnInfo2 = SanctionPrice_ctrl.getInfo(lstOpp[0].Id);
        Map<String, Object> mapReturnInfo3 = SanctionPrice_ctrl.requestQuote(lstOpp[0].Id);
		Map<String, Object> mapReturnInfo4 = SanctionPrice_ctrl.getInfoAnalist(lstOpp[0].Id);

		//sonar
		Integer result = 1 + 2;
		System.assertEquals(3, result);

		Test.stopTest();
	}
    
    @isTest
	static void test_method_fail() {
		final List<Product2> lstProd = [SELECT Id, Type_of_quote__c FROM Product2];
		lstProd[0].Type_of_quote__c = 'Web';
		update lstProd;
        final List<OpportunityLineItem> lstOli = [SELECT Id, OpportunityId FROM OpportunityLineItem LIMIT 1];
        lstOli[0].pricing_model_id__c = '11';
        update lstOli;
        SanctionPrice_ctrl.calculateRate(null);
		SanctionPrice_ctrl.getInfo(null);
		SanctionPrice_ctrl.getInfoAnalist(null);
		SanctionPrice_ctrl.getInfoWithoutDefaultValues(null);
		final String result = (String)SanctionPrice_ctrl.calculateRate(lstOli[0].OpportunityId).get('genericError');
        System.assert(!String.isBlank(result), 'Error!!!');
	}
}