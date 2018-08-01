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

        System.assertEquals(true, (Boolean)mapReturnInfo.get('hasOLI'));


        delete  [SELECT Id FROM OpportunityLineItem];
        Map<String,Object> mapReturnInfo2 = SanctionPrice_ctrl.getInfo(lstOpp[0].Id);
        System.assertEquals(false, (Boolean)mapReturnInfo2.get('hasOLI'));
    }
}