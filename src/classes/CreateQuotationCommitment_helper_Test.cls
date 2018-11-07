@isTest
public class CreateQuotationCommitment_helper_Test {
    @isTest
    public static void test_method_one(){
        insert new iaso__GBL_Rest_Services_Url__c(Name = 'GrantingTickets', iaso__Url__c = 'https://validation/ok', iaso__Cache_Partition__c = 'local.CredentialsPeru');
        insert new iaso__GBL_Rest_Services_Url__c(Name = 'CreateQuotationCommitment', iaso__Url__c = 'https://CreateQuotationCommitment/ok', iaso__Cache_Partition__c = 'local.CredentialsPeru');
        Account acc = TestFactory.createAccount();
        acc.main_code_id__c = '123567';
        update acc;
        Opportunity opp = TestFactory.createOpportunity(acc.Id, UserInfo.getUserId());
        Product2 prod = TestFactory.createProduct();
        OpportunityLineItem oli = TestFactory.createOLI(opp.Id, prod.Id);
        oli.price_quote_id__c = '111';
        oli.price_operation_id__c = '111';
        update oli;

        Opportunity_Solution_Commitment__c osc = new Opportunity_Solution_Commitment__c(opp_solution_commitment_amount__c = 34,
                                                                            opp_solution_commitment_id__c = '34',
                                                                            opp_soln_comt_expiry_days_number__c = 23,
                                                                            opp_solution_id__c = oli.Id,
                                                                            opportunity_id__c = opp.Id,
                                                                            CurrencyIsoCode = 'PEN');
        insert osc;
        Test.startTest();

        Test.setMock(HttpCalloutMock.class, new Integration_MockGenerator());
        iaso.GBL_Mock.setMock(new Integration_MockGenerator());
        CreateQuotationCommitment_helper createCommitment = new CreateQuotationCommitment_helper(osc.Id);
        System.HttpResponse commitmentResponse = createCommitment.invoke();
        System.assertEquals(200,commitmentResponse.getStatusCode());

        Test.stopTest();
    }
}