@istest
public class SanctionPrice_ctrl_Test {
    @testSetup
    static void setData() {
        Account acc = TestFactory.createAccount();
        Opportunity opp = TestFactory.createOpportunity(acc.Id, UserInfo.getUserId());
        Product2 prod = TestFactory.createProduct();
        OpportunityLineItem oli = TestFactory.createOLI(opp.Id, prod.Id);
    }

    @isTest
    static void test_method_one(){
        List<Account> lstAccount = [SELECT Id FROM Account];
        lstAccount[0].segment_desc__c = 'SUPERIOR';
        update lstAccount;

        List<Product2> lstProd = [SELECT Id, Type_of_quote__c FROM Product2];
        lstProd[0].Type_of_quote__c = 'Tarifario';
        update lstProd;
        List<Opportunity> lstOpp = [SELECT Id FROM Opportunity];
        Map<String,Object> mapReturnInfo = SanctionPrice_ctrl.getInfo(lstOpp[0].Id);
        Map<String,Object> mapReturnInfo3 = SanctionPrice_ctrl.getInfoWithoutDefaultValues(lstOpp[0].Id);

        System.assertEquals(true, (Boolean)mapReturnInfo.get('hasOLI'));


        delete  [SELECT Id FROM OpportunityLineItem];
        Map<String,Object> mapReturnInfo2 = SanctionPrice_ctrl.getInfo(lstOpp[0].Id);
        Map<String,Object> mapReturnInfo4 = SanctionPrice_ctrl.getInfoWithoutDefaultValues(lstOpp[0].Id);
        System.assertEquals(false, (Boolean)mapReturnInfo2.get('hasOLI'));       
        
    }
    @isTest
    static void test_method_two(){
        List<Account> lstAccount = [SELECT Id FROM Account];
        lstAccount[0].segment_desc__c = 'SUPERIOR';
        update lstAccount;

        List<Product2> lstProd = [SELECT Id, Type_of_quote__c FROM Product2];
        lstProd[0].Type_of_quote__c = 'Web';
        update lstProd;
        List<Opportunity> lstOpp = [SELECT Id FROM Opportunity];
        Map<String,Object> mapReturnInfo = SanctionPrice_ctrl.getInfo(lstOpp[0].Id);
        
        insert new iaso__GBL_Rest_Services_Url__c(Name = 'GrantingTickets', iaso__Url__c = 'https://validation/ok', iaso__Cache_Partition__c = 'local.CredentialsPeru');
        insert new iaso__GBL_Rest_Services_Url__c(Name = 'CalculateRate', iaso__Url__c = 'https://CalculateRate/ok', iaso__Cache_Partition__c = 'local.CredentialsPeru');
        Test.setMock(HttpCalloutMock.class, new Integration_MockGenerator());
        iaso.GBL_Mock.setMock(new Integration_MockGenerator());
        PriceRate_helper pricehHelper = new PriceRate_helper(lstOpp[0].Id, false);
        Test.startTest();
        
        System.HttpResponse priceResponse = pricehHelper.invoke();
        PriceRate_helper.ResponseSimulateRate_Wrapper responseWrapper = pricehHelper.parse(priceResponse.getBody());
        Map<String,Object> mapReturn = SanctionPrice_ctrl.getInfo(lstOpp[0].Id);
        Test.stopTest();
    }
}