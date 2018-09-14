@istest
global class PriceRate_helper_Test {
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
    global static void test_method_one(){
        setData();
        insert new iaso__GBL_Rest_Services_Url__c(Name = 'GrantingTickets', iaso__Url__c = 'https://validation/ok', iaso__Cache_Partition__c = 'ServicesPartition');
        insert new iaso__GBL_Rest_Services_Url__c(Name = 'SimulateRate', iaso__Url__c = 'https://SimulateRate/ok', iaso__Cache_Partition__c = 'ServicesPartition');
        Test.setMock(HttpCalloutMock.class, new Integration_MockGenerator());
        iaso.GBL_Mock.setMock(new Integration_MockGenerator());
        PriceRate_helper pricehHelper = new PriceRate_helper(opptest.Id, true);
        Test.startTest();
        
        System.HttpResponse priceResponse = pricehHelper.invoke();
        PriceRate_helper.ResponseSimulateRate_Wrapper responseWrapper = pricehHelper.parse(priceResponse.getBody());
        
        Test.stopTest();
    }
    
}