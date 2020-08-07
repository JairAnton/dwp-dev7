@istest
public class BE_AnalyzeRate_Tst {
	static Account acc;
	static Opportunity opp;
	static Product2 prod;
	static OpportunityLineItem oli;

	static void setData() {
		acc = TestFactory.createAccount();
		opp = TestFactory.createOpportunity(acc.Id, UserInfo.getUserId());
		prod = TestFactory.createProduct();
		prod.Type_of_quote__c = 'Web';
		update prod;
		oli = TestFactory.createOLI(opp.Id, prod.Id);
		oli.price_quote_id__c = '1111';
        oli.price_rates_calculation_Id__c = '123456';
        update oli;
	}

	@isTest
	static void testAnalyzeRateRestOK() {
		setData();
		//insert new iaso__GBL_Rest_Services_Url__c(Name = 'GrantingTickets', iaso__Url__c = 'https://validation/ok', iaso__Cache_Partition__c = 'local.CredentialsPeru');
		insert new iaso__GBL_Rest_Services_Url__c(Name = 'AnalyzeRate', iaso__Url__c = 'https://AnalyzeRate/OK', iaso__Cache_Partition__c = 'local.CredentialsPeru');
		Test.setMock(HttpCalloutMock.class, new Integration_MockGenerator());
		iaso.GBL_Mock.setMock(new Integration_MockGenerator());
		
        Test.startTest();
        Final List<OpportunityLineItem> olis = new List<OpportunityLineItem>();
        olis.add(oli);
        Final Map<String, Object> mapReturnAR = BE_AnalyzeRate_Rest.invokeWS(opp.Id, olis, 0.05, false);
        System.assert((Boolean)mapReturnAR.get('isOk'), 'correct!!!');
		Test.stopTest();
	}
    
    @isTest
	static void testAnalyzeRateRestKO() {
		setData();
		//insert new iaso__GBL_Rest_Services_Url__c(Name = 'GrantingTickets', iaso__Url__c = 'https://validation/ok', iaso__Cache_Partition__c = 'local.CredentialsPeru');
		insert new iaso__GBL_Rest_Services_Url__c(Name = 'AnalyzeRate', iaso__Url__c = 'https://AnalyzeRate/KO', iaso__Cache_Partition__c = 'local.CredentialsPeru');
		Test.setMock(HttpCalloutMock.class, new Integration_MockGenerator());
		iaso.GBL_Mock.setMock(new Integration_MockGenerator());
		
        Test.startTest();
        Final List<OpportunityLineItem> olis = new List<OpportunityLineItem>();
        olis.add(oli);
        Final Map<String, Object> mapReturnAR = BE_AnalyzeRate_Rest.invokeWS(opp.Id, olis, 0.05, false);
        System.assert(!(Boolean)mapReturnAR.get('isOk'), 'error!!!');
		Test.stopTest();
	}
    
    @isTest
	static void testMethodSuccess() {
		setData();
		insert new iaso__GBL_Rest_Services_Url__c(Name = 'GrantingTickets', iaso__Url__c = 'https://validation/ok', iaso__Cache_Partition__c = 'local.CredentialsPeru');
		insert new iaso__GBL_Rest_Services_Url__c(Name = 'AnalyzeRate', iaso__Url__c = 'https://AnalyzeRate/OK', iaso__Cache_Partition__c = 'local.CredentialsPeru');
		Test.setMock(HttpCalloutMock.class, new Integration_MockGenerator());
		iaso.GBL_Mock.setMock(new Integration_MockGenerator());
		
        Test.startTest();
        Final List<OpportunityLineItem> olis = new List<OpportunityLineItem>();
        olis.add(oli);
        Final Map<String, Object> mapReturnSP = SanctionPrice_Ctrl.getInfo(opp.Id);
		Final Map<String, Object> mapReturnAR = BE_AnalyzeRate_Ctrl.getInfoRORC(oli.Id, '0.05', (String)mapReturnSP.get('fields'));
		System.assert((Boolean)mapReturnAR.get('isOk'), 'correct!!!');
		Test.stopTest();
	}
    
    @isTest
	static void testMethodResponseError() {
		setData();
		insert new iaso__GBL_Rest_Services_Url__c(Name = 'GrantingTickets', iaso__Url__c = 'https://validation/ok', iaso__Cache_Partition__c = 'local.CredentialsPeru');
		insert new iaso__GBL_Rest_Services_Url__c(Name = 'AnalyzeRate', iaso__Url__c = 'https://AnalyzeRate/KO', iaso__Cache_Partition__c = 'local.CredentialsPeru');
		Test.setMock(HttpCalloutMock.class, new Integration_MockGenerator());
		iaso.GBL_Mock.setMock(new Integration_MockGenerator());
		
        Test.startTest();
        Final Map<String, Object> mapReturnSP = SanctionPrice_Ctrl.getInfo(opp.Id);
		Final Map<String, Object> mapReturnAR = BE_AnalyzeRate_Ctrl.getInfoRORC(oli.Id, '0.05', (String)mapReturnSP.get('fields'));
		System.assert(!(Boolean)mapReturnAR.get('isOk'), 'error!!!');
		Test.stopTest();
	}
    
    @isTest
	static void testMethodTeaError() {
		setData();
		insert new iaso__GBL_Rest_Services_Url__c(Name = 'GrantingTickets', iaso__Url__c = 'https://validation/ok', iaso__Cache_Partition__c = 'local.CredentialsPeru');
		insert new iaso__GBL_Rest_Services_Url__c(Name = 'AnalyzeRate', iaso__Url__c = 'https://AnalyzeRate/KO', iaso__Cache_Partition__c = 'local.CredentialsPeru');
		Test.setMock(HttpCalloutMock.class, new Integration_MockGenerator());
		iaso.GBL_Mock.setMock(new Integration_MockGenerator());
		
        Test.startTest();
        Final Map<String, Object> mapReturnAR = BE_AnalyzeRate_Ctrl.getInfoRORC(oli.Id, null, null);
		System.assert(!(Boolean)mapReturnAR.get('isOk'), 'error!!!');
		Test.stopTest();
	}
    
    @isTest
	static void testMethodGenericError() {
		setData();
        oli.price_rates_calculation_Id__c = null;
		update oli;
		insert new iaso__GBL_Rest_Services_Url__c(Name = 'GrantingTickets', iaso__Url__c = 'https://validation/ok', iaso__Cache_Partition__c = 'local.CredentialsPeru');
		insert new iaso__GBL_Rest_Services_Url__c(Name = 'AnalyzeRate', iaso__Url__c = 'https://AnalyzeRate/KO', iaso__Cache_Partition__c = 'local.CredentialsPeru');
		Test.setMock(HttpCalloutMock.class, new Integration_MockGenerator());
		iaso.GBL_Mock.setMock(new Integration_MockGenerator());
		
        Test.startTest();
        Final Map<String, Object> mapReturnAR = BE_AnalyzeRate_Ctrl.getInfoRORC(oli.Id, '0.065', null);
		System.assert(!(Boolean)mapReturnAR.get('isOk'), 'error!!!');
		Test.stopTest();
	}
}