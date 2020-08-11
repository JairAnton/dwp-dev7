@istest
public class SanctionPrice_ctrl_Test {
	@testSetup
	static void setData() {
		Final Account acc = TestFactory.createAccount();
		Final Opportunity opp = TestFactory.createOpportunity(acc.Id, UserInfo.getUserId());
		Final Product2 prod = TestFactory.createProduct();
		Final OpportunityLineItem oli = TestFactory.createOLI(opp.Id, prod.Id);
        Final BE_BailLetterCombination__c bailLetter = new BE_BailLetterCombination__c(UniqueId__c='USD020101', Currency__c='USD', Beneficiary__c = '02', BailObject__c='01', Period__c='01');
        insert bailLetter;
	}

	@isTest
	static void test_method_one() {
		Final List<Account> lstAccount = [SELECT Id FROM Account];
		lstAccount[0].segment_desc__c = 'SUPERIOR';
		update lstAccount;

		Final List<Product2> lstProd = [SELECT Id, Type_of_quote__c FROM Product2];
		lstProd[0].Type_of_quote__c = 'Tarifario';
		update lstProd;
		
        Final List<Opportunity> lstOpp = [SELECT Id FROM Opportunity];
		Final Map<String, Object> mapReturnInfo1 = SanctionPrice_ctrl.calculateRate(lstOpp[0].Id);
		SanctionPrice_ctrl.getInfo(lstOpp[0].Id);
		SanctionPrice_ctrl.getInfoAnalist(lstOpp[0].Id);
		SanctionPrice_ctrl.getInfoWithoutDefaultValues(lstOpp[0].Id);

		System.assert((Boolean)mapReturnInfo1.get('hasOLI'), 'success!!!');

		delete  [SELECT Id FROM OpportunityLineItem];
		Final Map<String, Object> mapReturnInfo5 = SanctionPrice_ctrl.calculateRate(lstOpp[0].Id);
		SanctionPrice_ctrl.getInfo(lstOpp[0].Id);
		SanctionPrice_ctrl.getInfoAnalist(lstOpp[0].Id);
		SanctionPrice_ctrl.getInfoWithoutDefaultValues(lstOpp[0].Id);
	}
    
	@isTest
	static void test_method_two() {
		Final List<Account> lstAccount = [SELECT Id FROM Account];
		lstAccount[0].segment_desc__c = 'SUPERIOR';
		update lstAccount;

		Final List<Product2> lstProd = [SELECT Id, Type_of_quote__c FROM Product2];
		lstProd[0].Type_of_quote__c = 'Web';
		update lstProd;
		
        Final List<Opportunity> lstOpp = [SELECT Id FROM Opportunity];
        
		insert new iaso__GBL_Rest_Services_Url__c(Name = 'GrantingTickets', iaso__Url__c = 'https://validation/ok', iaso__Cache_Partition__c = 'local.CredentialsPeru');
		insert new iaso__GBL_Rest_Services_Url__c(Name = 'CalculateRate', iaso__Url__c = 'https://CalculateRate/ok', iaso__Cache_Partition__c = 'local.CredentialsPeru');
		insert new iaso__GBL_Rest_Services_Url__c(Name = 'CreateQuotationRequest', iaso__Url__c = 'https://CreateRequestApproved/OK', iaso__Cache_Partition__c = 'local.CredentialsPeru');
		Test.setMock(HttpCalloutMock.class, new Integration_MockGenerator());
		iaso.GBL_Mock.setMock(new Integration_MockGenerator());
		Final PriceRate_helper pricehHelper = new PriceRate_helper(lstOpp[0].Id, false);
		
        Test.startTest();

		System.HttpResponse priceResponse = pricehHelper.invoke();
		Final PriceRate_helper.ResponseSimulateRate_Wrapper responseWrapper = pricehHelper.parse(priceResponse.getBody());
		SanctionPrice_ctrl.calculateRate(lstOpp[0].Id);
		SanctionPrice_ctrl.getInfo(lstOpp[0].Id);
        SanctionPrice_ctrl.requestQuote(lstOpp[0].Id);
		Final Map<String, Object> mapReturnInfo1 = SanctionPrice_ctrl.getInfoAnalist(lstOpp[0].Id);
		System.assert((Boolean)mapReturnInfo1.get('hasOLI'), 'success!!!');

		Test.stopTest();
	}
    
    @isTest
	static void test_method_fail() {
		Final List<Product2> lstProd = [SELECT Id, Type_of_quote__c FROM Product2];
		lstProd[0].Type_of_quote__c = 'Web';
		update lstProd;
        Final List<OpportunityLineItem> lstOli = [SELECT Id, OpportunityId FROM OpportunityLineItem LIMIT 1];
        lstOli[0].pricing_model_id__c = '11';
        update lstOli;
        SanctionPrice_ctrl.calculateRate(null);
		SanctionPrice_ctrl.getInfo(null);
		SanctionPrice_ctrl.getInfoAnalist(null);
		SanctionPrice_ctrl.getInfoWithoutDefaultValues(null);
		Final String result = (String)SanctionPrice_ctrl.calculateRate(lstOli[0].OpportunityId).get('genericError');
        System.assert(!String.isBlank(result), 'Error!!!');
	}
}
