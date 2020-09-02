/**
   -------------------------------------------------------------------------------------------------
   @Name <BE_AnalyzeRate_Tst>
   @Author Martin Alejandro Mori Chavez (martin.mori.contractor@bbva.com)
   @Date 2020-08-10
   @Description Test class from BE_AnalyzeRate_Ctrl and BE_AnalyzeRate_Rest
   @Changes
   Date        Author   Email                  				Type		Description
   2020-08-10  MAMC     martin.mori.contractor@bbva.com    	Creation
   -------------------------------------------------------------------------------------------------
 */
@istest
public class BE_AnalyzeRate_Tst {
	/* string cache */
    final static String STRCACHE = 'iaso.ServicesPartition';
    /* string endpoint analyze rate ok */
    final static String URLOK = 'https://AnalyzeRate/OK';
    /* string endpoint analyze rate ko */
    final static String URLKO = 'https://AnalyzeRate/KO';
    /* string endpoint grantingticket */
    final static String URLGT = 'https://validation/ok';
    /* string grantingtickets */
    final static String STRGT = 'grantingtickets';
    /* string AnalyzeRate */
    final static String STRAR = 'AnalyzeRate';
    /* string isOk */
    final static String STROK = 'isOk';
    /* string error */
    final static String STRERROR = 'error!!!';
	/**@Description TestSetup for generated data to use in the test methods*/
	@TestSetup
	static void setupData() {
		Final Account acc = TestFactory.createAccount();
		Final Opportunity opp = TestFactory.createOpportunity(acc.Id, UserInfo.getUserId());
		Final Product2 prod = TestFactory.createProduct();
		prod.Type_of_quote__c = 'Web';
		update prod;
		Final OpportunityLineItem oli = TestFactory.createOLI(opp.Id, prod.Id);
		oli.price_quote_id__c = '1111';
        oli.price_rates_calculation_Id__c = '123456';
        update oli;
	}

	/**@Description method used to success scenary for AnalyzeRateRest class*/
    @isTest
	static void testAnalyzeRateRestOK() {
        Final Account acc = TestFactory.createAccount();
		Final Opportunity opp = TestFactory.createOpportunity(acc.Id, UserInfo.getUserId());
		Final Product2 prod = TestFactory.createProduct();
		prod.Type_of_quote__c = 'Web';
		update prod;
		Final OpportunityLineItem oli = TestFactory.createOLI(opp.Id, prod.Id);
		oli.price_quote_id__c = '11111';
        oli.price_rates_calculation_Id__c = '123466';
        update oli;
        
		insert new iaso__GBL_Rest_Services_Url__c(Name = STRAR, iaso__Url__c = URLOK, iaso__Cache_Partition__c = STRCACHE);
		Test.setMock(HttpCalloutMock.class, new Integration_MockGenerator());
		iaso.GBL_Mock.setMock(new Integration_MockGenerator());
		Final List<OpportunityLineItem> olis = new List<OpportunityLineItem>();
        olis.add(oli);
        Test.startTest();
        Final Map<String, Object> mapReturnAR = BE_AnalyzeRate_Rest.invokeWS(opp.Id, olis, 0.07, false);
        System.assert((Boolean)mapReturnAR.get(STROK), 'correct!!!');
		Test.stopTest();
	}
    
    /**@Description method used to error scenary for AnalyzeRateRest class*/
    @isTest
	static void testAnalyzeRateRestKO() {
		insert new iaso__GBL_Rest_Services_Url__c(Name = STRAR, iaso__Url__c = URLKO, iaso__Cache_Partition__c = STRCACHE);
		Test.setMock(HttpCalloutMock.class, new Integration_MockGenerator());
		iaso.GBL_Mock.setMock(new Integration_MockGenerator());
		Final List<OpportunityLineItem> olis = [SELECT Id, OpportunityId, price_quote_id__c, price_rates_calculation_Id__c FROM OpportunityLineItem LIMIT 1];
        Test.startTest();
        Final Map<String, Object> mapReturnAR = BE_AnalyzeRate_Rest.invokeWS(olis[0].OpportunityId, olis, 0.15, false);
        System.assert(!(Boolean)mapReturnAR.get(STROK), STRERROR);
		Test.stopTest();
	}
    
    /**@Description method used to success scenary for BE_AnalyzeRate_Ctrl class*/
    @isTest
	static void testMethodSuccess() {
		insert new iaso__GBL_Rest_Services_Url__c(Name = STRGT, iaso__Url__c = URLGT, iaso__Cache_Partition__c = STRCACHE);
		insert new iaso__GBL_Rest_Services_Url__c(Name = STRAR, iaso__Url__c = URLOK, iaso__Cache_Partition__c = STRCACHE);
		Test.setMock(HttpCalloutMock.class, new Integration_MockGenerator());
		iaso.GBL_Mock.setMock(new Integration_MockGenerator());
		Final List<OpportunityLineItem> olis = [SELECT Id, OpportunityId, price_quote_id__c, price_rates_calculation_Id__c FROM OpportunityLineItem LIMIT 1];
        Test.startTest();
        Final Map<String, Object> mapReturnSP = SanctionPrice_Ctrl.getInfo(olis[0].OpportunityId);
		Final Map<String, Object> mapReturnAR = BE_AnalyzeRate_Ctrl.getInfoRORC(olis[0].Id, '0.05', (String)mapReturnSP.get('fields'));
		System.assert((Boolean)mapReturnAR.get(STROK), 'correct!!!');
		Test.stopTest();
	}
    
    /**@Description method used to error scenary for BE_AnalyzeRate_Ctrl class*/
    @isTest
	static void testMethodResponseError() {
		insert new iaso__GBL_Rest_Services_Url__c(Name = STRGT, iaso__Url__c = URLGT, iaso__Cache_Partition__c = STRCACHE);
		insert new iaso__GBL_Rest_Services_Url__c(Name = STRAR, iaso__Url__c = URLKO, iaso__Cache_Partition__c = STRCACHE);
		Test.setMock(HttpCalloutMock.class, new Integration_MockGenerator());
		iaso.GBL_Mock.setMock(new Integration_MockGenerator());
		Final List<OpportunityLineItem> olis = [SELECT Id, OpportunityId, price_quote_id__c, price_rates_calculation_Id__c FROM OpportunityLineItem LIMIT 1];
        Test.startTest();
        Final Map<String, Object> mapReturnSP = SanctionPrice_Ctrl.getInfo(olis[0].OpportunityId);
		Final Map<String, Object> mapReturnAR = BE_AnalyzeRate_Ctrl.getInfoRORC(olis[0].Id, '0.06', (String)mapReturnSP.get('fields'));
		System.assert(!(Boolean)mapReturnAR.get(STROK), STRERROR);
		Test.stopTest();
	}
    
    /**@Description method used to tea error scenary for BE_AnalyzeRate_Ctrl class*/
    @isTest
	static void testMethodTeaError() {
		insert new iaso__GBL_Rest_Services_Url__c(Name = STRGT, iaso__Url__c = URLGT, iaso__Cache_Partition__c = STRCACHE);
		insert new iaso__GBL_Rest_Services_Url__c(Name = STRAR, iaso__Url__c = URLKO, iaso__Cache_Partition__c = STRCACHE);
		Test.setMock(HttpCalloutMock.class, new Integration_MockGenerator());
		iaso.GBL_Mock.setMock(new Integration_MockGenerator());
        Final List<OpportunityLineItem> olis = [SELECT Id, OpportunityId, price_quote_id__c, price_rates_calculation_Id__c FROM OpportunityLineItem LIMIT 1];
        Test.startTest();
        Final Map<String, Object> mapReturnAR = BE_AnalyzeRate_Ctrl.getInfoRORC(olis[0].Id, null, null);
		System.assert(!(Boolean)mapReturnAR.get(STROK), STRERROR);
		Test.stopTest();
	}
    
    /**@Description method used to generic error scenary for BE_AnalyzeRate_Ctrl class*/
    @isTest
	static void testMethodGenericError() {
		insert new iaso__GBL_Rest_Services_Url__c(Name = STRGT, iaso__Url__c = URLGT, iaso__Cache_Partition__c = STRCACHE);
		insert new iaso__GBL_Rest_Services_Url__c(Name = STRAR, iaso__Url__c = URLKO, iaso__Cache_Partition__c = STRCACHE);
		Test.setMock(HttpCalloutMock.class, new Integration_MockGenerator());
		iaso.GBL_Mock.setMock(new Integration_MockGenerator());
		
        Test.startTest();
        Final Map<String, Object> mapReturnAR = BE_AnalyzeRate_Ctrl.getInfoRORC(null, '0.065', null);
		System.assert(!(Boolean)mapReturnAR.get(STROK), STRERROR);
		Test.stopTest();
	}
}
