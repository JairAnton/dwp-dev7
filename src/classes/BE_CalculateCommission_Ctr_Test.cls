@istest
public class  BE_CalculateCommission_Ctr_Test {
	@testSetup
    static void setup() {
		Account acc = TestFactory.createAccount();
		Opportunity opp = TestFactory.createOpportunity(acc.Id, UserInfo.getUserId());
		Product2 prod = TestFactory.createProduct();
		OpportunityLineItem oli = TestFactory.createOLI(opp.Id, prod.Id);
		oli.PE_List_Product_mode__c = '01';
		update oli;        
    }
    @isTest
    static void testMethodGetCommissions() {
        OpportunityLineItem oli = [select id from OpportunityLineItem limit 1];
		Test.startTest();
        List<Product_Commission__c> commisions = BE_CalculateCommission_Ctr.getCommissions(oli.Id,true);
        Test.stopTest();
        System.assertEquals(4, commisions.size());
    }
    
    @isTest
    static void testMethodGetOlis() {
        Opportunity opp = [select id from Opportunity limit 1];
		Test.startTest();
        Map<String, Object> olis = BE_CalculateCommission_Ctr.getOlis(opp.Id);
        Test.stopTest();
        system.assert(olis!=null);
    }
}