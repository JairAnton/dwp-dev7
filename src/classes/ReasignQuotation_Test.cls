@istest
public class ReasignQuotation_Test {
    static User user;
    static Case casetest;
    static Opportunity opp;
    static Product2 prod;
    static OpportunityLineItem oli;
    @isTest
    static void setData() {
        user=TestFactory.createUser('reasignuser', Label.lblAnalistaProf);
        casetest=TestFactory.createCase(UserInfo.getUserId());
        Account acc = TestFactory.createAccount();
        opp = TestFactory.createOpportunity(acc.Id, UserInfo.getUserId());
        prod = TestFactory.createProduct();
        oli = TestFactory.createOLI(opp.Id, prod.Id);
    }
    @isTest
    static void testreasign(){
        
        setData();
        casetest.opportunity_id__c = opp.Id;
        update casetest;
        oli.price_quote_id__c = '111';
        oli.price_operation_id__c = '222';
        update oli;
        prod.Type_of_quote__c = 'Web';
        update prod;
        insert new iaso__GBL_Rest_Services_Url__c(Name = 'GrantingTickets', iaso__Url__c = 'https://validation/ok', iaso__Cache_Partition__c = 'local.CredentialsPeru');
        insert new iaso__GBL_Rest_Services_Url__c(Name = 'ModifyQuotationRequest', iaso__Url__c = 'https://ModifyQuotationRequestRecover/OK', iaso__Cache_Partition__c = 'local.CredentialsPeru');
        Test.setMock(HttpCalloutMock.class, new Integration_MockGenerator());
        iaso.GBL_Mock.setMock(new Integration_MockGenerator());
        ModifyQuotationRequest_helper modifyHelper = new ModifyQuotationRequest_helper(opp.Id, 'REASSIGN',0.93,'','');        
        Test.startTest();
        
        System.HttpResponse modifyResponse = modifyHelper.invoke();
        User usertest = [Select Id from User where Id =:UserInfo.getUserId()];
        Map<String,Object> mapReturn = ReasignButtonClass.reasignown(casetest.Id, usertest);
        ModifyQuotationRequest_helper.ResponseModifyQuotationRequest_Wrapper responseWrapper = ModifyQuotationRequest_helper.responseParse(modifyResponse.getBody());        
        System.assertEquals('RECOVERED', responseWrapper.data.status.id);
        Test.stopTest();
    }
}