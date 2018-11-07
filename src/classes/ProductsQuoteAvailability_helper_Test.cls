@istest
public class ProductsQuoteAvailability_helper_Test {
    @isTest
    public static void test_method_one(){
        insert new iaso__GBL_Rest_Services_Url__c(Name = 'GrantingTickets', iaso__Url__c = 'https://validation/ok', iaso__Cache_Partition__c = 'local.CredentialsPeru');
        insert new iaso__GBL_Rest_Services_Url__c(Name = 'ProductsQuoteAvailability', iaso__Url__c = 'https://ProductsQuote/ok', iaso__Cache_Partition__c = 'local.CredentialsPeru');
        Account acc = TestFactory.createAccount();
        acc.main_code_id__c = '123567';
        update acc;
        Opportunity opp = TestFactory.createOpportunity(acc.Id, UserInfo.getUserId());
        Test.startTest();

        Test.setMock(HttpCalloutMock.class, new Integration_MockGenerator());
        iaso.GBL_Mock.setMock(new Integration_MockGenerator());
        ProductsQuoteAvailability_helper compromiseHelper = new ProductsQuoteAvailability_helper(opp.Id);
        System.HttpResponse compromiseResponse = compromiseHelper.invoke();

        Test.stopTest();
    }
}