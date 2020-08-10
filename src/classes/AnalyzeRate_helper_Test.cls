@istest
public class AnalyzeRate_helper_Test {
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
		prodtest.price_approval_web_service_id__c = '11';
		update prodtest;
        Final Opportunity_Solution_Commitment__c comm = new Opportunity_Solution_Commitment__c();
        comm.opp_solution_commitment_id__c='10';
        comm.opp_solution_commitment_amount__c=200;
        comm.opp_soln_comt_expiry_days_number__c=30;
        comm.opp_solution_comt_product_name__c='INCR. SM VISTA + AHORRO';
        comm.CurrencyIsoCode='PEN';
        comm.opportunity_id__c=opptest.Id;
        insert comm;
	}

	@isTest
	public static void test_method_one() {
		setData();
		insert new iaso__GBL_Rest_Services_Url__c(Name = 'GrantingTickets', iaso__Url__c = 'https://validation/ok', iaso__Cache_Partition__c = 'local.CredentialsPeru');
		insert new iaso__GBL_Rest_Services_Url__c(Name = 'AnalyzeRate', iaso__Url__c = 'https://AnalyzeRate/OK', iaso__Cache_Partition__c = 'local.CredentialsPeru');
		Test.setMock(HttpCalloutMock.class, new Integration_MockGenerator());
		iaso.GBL_Mock.setMock(new Integration_MockGenerator());

		Test.startTest();
        Final AnalyzeRate_helper analyzeRate = new AnalyzeRate_helper(opptest.Id, '123456', 3, false);
		Final System.HttpResponse httpResp = analyzeRate.invoke();
        Final AnalyzeRate_helper.ResponseAnalyzeRate_Wrapper resp = analyzeRate.parse(httpResp.getBody());
        Final String strResp = resp.data.interestRates.effectiveRates[0].id +
            resp.data.interestRates.effectiveRates[0].percentage +
            resp.data.isCoveredMinimunEvaluated +
            resp.data.financialIndicators[0].id +
            resp.data.financialIndicators[0].value +
            resp.data.liquidityIndicators[0].id +
            resp.data.liquidityIndicators[0].detail.percentage +
            resp.data.liquidityIndicators[0].detail.amount +
            resp.data.liquidityIndicators[0].detail.currencyType +
            resp.data.fees[0].feeType.id +
            resp.data.fees[0].detail.percentage +
            resp.data.products[0].id +
            resp.data.products[0].name +
            resp.data.products[0].committedData.description +
            resp.data.products[0].committedData.classification +
            resp.data.products[0].committedData.unitValue.amount +
            resp.data.products[0].committedData.unitValue.currencyType +
            resp.data.products[0].committedData.unitValue.unitValueDetailType +
            resp.data.products[0].committedData.effectiveTime.unit +
            resp.data.products[0].committedData.effectiveTime.numberValue +
            resp.data.indicators[0].id +
            resp.data.indicators[0].value;
		Test.stopTest();
		System.assert(!String.isBlank(strResp), 'success!!!');
	}
}
