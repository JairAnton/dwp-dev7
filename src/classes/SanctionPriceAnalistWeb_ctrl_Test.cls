@istest
public class SanctionPriceAnalistWeb_ctrl_Test {
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
        oli.price_quote_id__c ='1111';
        update oli;
    }
    
    @isTest
    static void test_method_one(){
        setData();
        insert new iaso__GBL_Rest_Services_Url__c(Name = 'GrantingTickets', iaso__Url__c = 'https://validation/ok', iaso__Cache_Partition__c = 'local.CredentialsPeru');
        insert new iaso__GBL_Rest_Services_Url__c(Name = 'GetQuotationRequest', iaso__Url__c = 'https://GetQuotationRequest/OK', iaso__Cache_Partition__c = 'local.CredentialsPeru');
        Test.setMock(HttpCalloutMock.class, new Integration_MockGenerator());
        iaso.GBL_Mock.setMock(new Integration_MockGenerator());
        GetQuotationRequest_helper getRequestHelper = new GetQuotationRequest_helper(opp.Id);
        Test.startTest();
        
        System.HttpResponse getRequestResponse = getRequestHelper.invoke();
        GetQuotationRequest_helper.ResponseGetQuotationRequest_Wrapper responseWrapper = GetQuotationRequest_helper.parse(getRequestResponse.getBody());
        Map<String,Object> mapReturn = SanctionPriceAnalistWeb_ctrl.getInfo(opp.Id);
        Test.stopTest();
    }
    @isTest
    static void test_method_two(){
        setData();
        insert new iaso__GBL_Rest_Services_Url__c(Name = 'GrantingTickets', iaso__Url__c = 'https://validation/ok', iaso__Cache_Partition__c = 'local.CredentialsPeru');
        insert new iaso__GBL_Rest_Services_Url__c(Name = 'AnalyzeRate', iaso__Url__c = 'https://AnalyzeRate/OK', iaso__Cache_Partition__c = 'local.CredentialsPeru');
        Test.setMock(HttpCalloutMock.class, new Integration_MockGenerator());
        iaso.GBL_Mock.setMock(new Integration_MockGenerator());
        AnalyzeRate_helper analyzehelper = new AnalyzeRate_helper(opp.Id, '0.43');
        Test.startTest();
        
        Map<String,Object> mapReturn = SanctionPriceAnalistWeb_ctrl.calculate(opp.Id, 0.43);
        Test.stopTest();
    }
    @isTest
    static void test_method_three(){
        setData();
        insert new iaso__GBL_Rest_Services_Url__c(Name = 'GrantingTickets', iaso__Url__c = 'https://validation/ok', iaso__Cache_Partition__c = 'local.CredentialsPeru');
        insert new iaso__GBL_Rest_Services_Url__c(Name = 'GetQuotationRequest', iaso__Url__c = 'https://GetQuotationRequest/KO_500', iaso__Cache_Partition__c = 'local.CredentialsPeru');
        Test.setMock(HttpCalloutMock.class, new Integration_MockGenerator());
        iaso.GBL_Mock.setMock(new Integration_MockGenerator());
        GetQuotationRequest_helper getRequestHelper = new GetQuotationRequest_helper(opp.Id);
        Test.startTest();
        
        System.HttpResponse getRequestResponse = getRequestHelper.invoke();
        GetQuotationRequest_helper.ResponseGetQuotationRequest_Wrapper responseWrapper = GetQuotationRequest_helper.parse(getRequestResponse.getBody());
        Map<String,Object> mapReturn = SanctionPriceAnalistWeb_ctrl.getInfo(opp.Id);
        Test.stopTest();
    }
}