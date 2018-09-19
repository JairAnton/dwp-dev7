@istest
global class CompromiseProducts_helper_Test {
    @isTest
    global static void test_method_one(){
        insert new iaso__GBL_Rest_Services_Url__c(Name = 'GrantingTickets', iaso__Url__c = 'https://validation/ok', iaso__Cache_Partition__c = 'local.CredentialsPeru');
        insert new iaso__GBL_Rest_Services_Url__c(Name = 'CompromiseProducts', iaso__Url__c = 'https://CompromiseProducts/ok', iaso__Cache_Partition__c = 'local.CredentialsPeru');
        Test.setMock(HttpCalloutMock.class, new Integration_MockGenerator());
        iaso.GBL_Mock.setMock(new Integration_MockGenerator());
        
        CompromiseProducts_helper compromiseHelper = new CompromiseProducts_helper('3');
        Test.startTest();
        
        System.HttpResponse compromiseResponse = compromiseHelper.invoke();
        CompromiseProducts_helper.ResponseCompromiseProducts_Wrapper responseWrapper = compromiseHelper.parse(compromiseResponse.getBody());
        System.assertEquals(5, responseWrapper.data.size());

        Test.stopTest();

    }
}