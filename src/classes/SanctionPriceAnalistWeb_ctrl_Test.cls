@istest
public class SanctionPriceAnalistWeb_ctrl_Test {
    @testSetup
    static void setData() {
        Account acc = TestFactory.createAccount();
        Opportunity opp = TestFactory.createOpportunity(acc.Id, UserInfo.getUserId());
        Product2 prod = TestFactory.createProduct();
        OpportunityLineItem oli = TestFactory.createOLI(opp.Id, prod.Id);
    }
    
    @isTest
    static void test_method_one(){
        List<Product2> lstProd = [SELECT Id, Type_of_quote__c FROM Product2];
        lstProd[0].Type_of_quote__c = 'Web';
        update lstProd;
        List<Opportunity> lstOpp = [SELECT Id FROM Opportunity];
        insert new iaso__GBL_Rest_Services_Url__c(Name = 'GrantingTickets', iaso__Url__c = 'https://validation/ok', iaso__Cache_Partition__c = 'local.CredentialsPeru');
        insert new iaso__GBL_Rest_Services_Url__c(Name = 'GetQuotationRequest', iaso__Url__c = 'https://GetQuotationRequest/OK', iaso__Cache_Partition__c = 'local.CredentialsPeru');
        Test.setMock(HttpCalloutMock.class, new Integration_MockGenerator());
        iaso.GBL_Mock.setMock(new Integration_MockGenerator());
        GetQuotationRequest_helper quotationhelper = new GetQuotationRequest_helper(lstOpp[0].Id);
        Test.startTest();
        
        System.HttpResponse priceResponse = quotationhelper.invoke();
        //PriceRate_helper.ResponseSimulateRate_Wrapper responseWrapper = pricehHelper.parse(priceResponse.getBody());
        Map<String,Object> mapReturn = SanctionPriceAnalistWeb_ctrl.getInfo(lstOpp[0].Id);
        Test.stopTest();
    }
    @isTest
    static void test_method_two(){
        List<Product2> lstProd = [SELECT Id, Type_of_quote__c FROM Product2];
        lstProd[0].Type_of_quote__c = 'Web';
        update lstProd;
        List<Opportunity> lstOpp = [SELECT Id FROM Opportunity];
        insert new iaso__GBL_Rest_Services_Url__c(Name = 'GrantingTickets', iaso__Url__c = 'https://validation/ok', iaso__Cache_Partition__c = 'local.CredentialsPeru');
        insert new iaso__GBL_Rest_Services_Url__c(Name = 'AnalyzeRate', iaso__Url__c = 'https://AnalyzeRate/OK', iaso__Cache_Partition__c = 'local.CredentialsPeru');
        Test.setMock(HttpCalloutMock.class, new Integration_MockGenerator());
        iaso.GBL_Mock.setMock(new Integration_MockGenerator());
        AnalyzeRate_helper analyzehelper = new AnalyzeRate_helper(lstOpp[0].Id, '0.43');
        Test.startTest();
        
        System.HttpResponse priceResponse = analyzehelper.invoke();
        Map<String,Object> mapReturn = SanctionPriceAnalistWeb_ctrl.calculate(lstOpp[0].Id, 0.43);
        Test.stopTest();
    }
}