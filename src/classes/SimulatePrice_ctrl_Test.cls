@istest
public class SimulatePrice_ctrl_Test {
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
        final BE_BailLetterCombination__c bailLetter = new BE_BailLetterCombination__c(UniqueId__c='USD020101', Currency__c='USD', Beneficiary__c = '02', BailObject__c='01', Period__c='01');
        insert bailLetter;
	}

	@isTest
	static void test_method_one() {
		setData();
		insert new iaso__GBL_Rest_Services_Url__c(Name = 'GrantingTickets', iaso__Url__c = 'https://validation/ok', iaso__Cache_Partition__c = 'local.CredentialsPeru');
		insert new iaso__GBL_Rest_Services_Url__c(Name = 'SimulateRate', iaso__Url__c = 'https://SimulateRate/ok', iaso__Cache_Partition__c = 'local.CredentialsPeru');
		Test.setMock(HttpCalloutMock.class, new Integration_MockGenerator());
		iaso.GBL_Mock.setMock(new Integration_MockGenerator());
		PriceRate_helper pricehHelper = new PriceRate_helper(opptest.Id, true);
		Test.startTest();

		System.HttpResponse priceResponse = pricehHelper.invoke();
		PriceRate_helper.ResponseSimulateRate_Wrapper responseWrapper = pricehHelper.parse(priceResponse.getBody());
		Map<String, Object> mapReturn = SimulatePrice_ctrl.getInfo(opptest.Id);
		System.assert (mapReturn.containsKey('oli'));
		Test.stopTest();
	}
    
	@isTest
	static void test_method_two() {
		setData();
		insert new iaso__GBL_Rest_Services_Url__c(Name = 'GrantingTickets', iaso__Url__c = 'https://validation/ok', iaso__Cache_Partition__c = 'local.CredentialsPeru');
		insert new iaso__GBL_Rest_Services_Url__c(Name = 'SimulateRate', iaso__Url__c = 'https://SimulateRate/ko', iaso__Cache_Partition__c = 'local.CredentialsPeru');
		Test.setMock(HttpCalloutMock.class, new Integration_MockGenerator());
		iaso.GBL_Mock.setMock(new Integration_MockGenerator());
		PriceRate_helper pricehHelper = new PriceRate_helper(opptest.Id, true);
		Test.startTest();

		System.HttpResponse priceResponse = pricehHelper.invoke();
		PriceRate_helper.ResponseSimulateRate_Wrapper responseWrapper = pricehHelper.parse(priceResponse.getBody());
		Map<String, Object> mapReturn = SimulatePrice_ctrl.getInfo(opptest.Id);
		System.assert (mapReturn.containsKey('oli'));
		Test.stopTest();
	}
    
    @isTest
	static void test_method_fail() {
		setData();
        final List<Product2> lstProd = [SELECT Id, Type_of_quote__c FROM Product2];
		lstProd[0].Type_of_quote__c = 'Web';
		update lstProd;
        final List<OpportunityLineItem> lstOli = [SELECT Id, OpportunityId FROM OpportunityLineItem LIMIT 1];
        lstOli[0].pricing_model_id__c = '11';
        update lstOli;
        SimulatePrice_ctrl.getInfo(null);
		final String result = (String)SimulatePrice_ctrl.getInfo(lstOli[0].OpportunityId).get('genericError');
        System.assert(!String.isBlank(result), 'Error!!!');
	}
}