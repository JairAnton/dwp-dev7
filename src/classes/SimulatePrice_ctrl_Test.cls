@istest
public class SimulatePrice_ctrl_Test {
    static Account acctest;
    static Opportunity opptest;
    static User defaultUser;
    static OpportunityLineItem olitest;
    static Product2 prodtest;
    
    static void setData() {
        defaultUser = TestFactory.createUser('Test','Migracion');
        acctest = TestFactory.createAccount();
        opptest = TestFactory.createOpportunity(acctest.Id, defaultUser.Id);
        prodtest = TestFactory.createProduct();
        olitest = TestFactory.createOLI(opptest.Id, prodtest.Id);
    }
    
    @isTest
    static void test_method_one(){
        setData();
        insert new iaso__GBL_Rest_Services_Url__c(Name = 'GrantingTickets', iaso__Url__c = 'https://validation/ok', iaso__Cache_Partition__c = 'local.CredentialsPeru');
        insert new iaso__GBL_Rest_Services_Url__c(Name = 'SimulateRate', iaso__Url__c = 'https://SimulateRate/ok', iaso__Cache_Partition__c = 'local.CredentialsPeru');
        Test.setMock(HttpCalloutMock.class, new Integration_MockGenerator());
        iaso.GBL_Mock.setMock(new Integration_MockGenerator());
        PriceRate_helper pricehHelper = new PriceRate_helper(opptest.Id, true);
        Test.startTest();
        
        System.HttpResponse priceResponse = pricehHelper.invoke();
        PriceRate_helper.ResponseSimulateRate_Wrapper responseWrapper = pricehHelper.parse(priceResponse.getBody());
        Map<String,Object> mapReturn = SimulatePrice_ctrl.getInfo(opptest.Id);
        System.assert(mapReturn.containsKey('oli'));
        Test.stopTest();
    }
    @isTest
    static void test_method_two(){
        setData();
        insert new iaso__GBL_Rest_Services_Url__c(Name = 'GrantingTickets', iaso__Url__c = 'https://validation/ok', iaso__Cache_Partition__c = 'local.CredentialsPeru');
        insert new iaso__GBL_Rest_Services_Url__c(Name = 'SimulateRate', iaso__Url__c = 'https://SimulateRate/ko', iaso__Cache_Partition__c = 'local.CredentialsPeru');
        Test.setMock(HttpCalloutMock.class, new Integration_MockGenerator());
        iaso.GBL_Mock.setMock(new Integration_MockGenerator());
        PriceRate_helper pricehHelper = new PriceRate_helper(opptest.Id, true);
        Test.startTest();
        
        System.HttpResponse priceResponse = pricehHelper.invoke();
        PriceRate_helper.ResponseSimulateRate_Wrapper responseWrapper = pricehHelper.parse(priceResponse.getBody());
        Map<String,Object> mapReturn = SimulatePrice_ctrl.getInfo(opptest.Id);
        System.assert(mapReturn.containsKey('oli'));
        Test.stopTest();
    }
}