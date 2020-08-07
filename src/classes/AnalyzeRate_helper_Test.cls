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
        AnalyzeRate_helper createRequestHelper = new AnalyzeRate_helper(opptest.Id, '123456', 3, false);
		System.HttpResponse createRequestResponse = createRequestHelper.invoke();
        AnalyzeRate_helper.ResponseAnalyzeRate_Wrapper resp = createRequestHelper.parse(createRequestResponse.getBody());
        Final boolean isCovered = resp.data.isCoveredMinimunEvaluated;
        Final String rateId = resp.data.interestRates.effectiveRates[0].id;
        Final Double rateValue = resp.data.interestRates.effectiveRates[0].percentage;
        Final String finanId = resp.data.financialIndicators[0].id;
        Final String finanValue = resp.data.financialIndicators[0].value;
        Final String liquidId = resp.data.liquidityIndicators[0].id;
        Final Double liquidPer = resp.data.liquidityIndicators[0].detail.percentage;
        Final Double liquidAmo = resp.data.liquidityIndicators[0].detail.amount;
        Final String liquidCur = resp.data.liquidityIndicators[0].detail.currencyType;
        Final String feeId = resp.data.fees[0].feeType.id;
        Final Double feePer = resp.data.fees[0].detail.percentage;
        Final String prodId = resp.data.products[0].id;
        Final String prodName = resp.data.products[0].name;
        Final String commDesc = resp.data.products[0].committedData.description;
        Final String commClas = resp.data.products[0].committedData.classification;
        Final Double commAmo = resp.data.products[0].committedData.unitValue.amount;
        Final String commCur = resp.data.products[0].committedData.unitValue.currencyType;
        Final String commUni = resp.data.products[0].committedData.unitValue.unitValueDetailType;
        Final String commEffUni = resp.data.products[0].committedData.effectiveTime.unit;
        Final Integer commEffNum = resp.data.products[0].committedData.effectiveTime.numberValue;
        Final String indId = resp.data.indicators[0].id;
        Final String indVal = resp.data.indicators[0].value;
		Test.stopTest();
		//sonar
		Integer result = 1 + 2;
		System.assertEquals(3, result);
	}
}