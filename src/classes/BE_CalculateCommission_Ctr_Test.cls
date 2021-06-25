/**
   -------------------------------------------------------------------------------------------------
   @Name <BE_CalculateCommission_Ctr_Test>
   @Author Eduardo Vargas (luis.eduardo.vargas.contractor@bbva.pe)
   @Date 2021-03-12
   @Description Test class of BE_CalculateCommission_Ctr
   @Changes
   Date        Author   Email                  				    Type		Description
   2021-03-12  MAMC    luis.vargas.matute.contractor@bbva.com   Creation
   -------------------------------------------------------------------------------------------------
 */
@istest
public class  BE_CalculateCommission_Ctr_Test {
    /** setup method*/
	@testSetup
    static void setup() {
		Final Account acc = TestFactory.createAccount();
		Final Opportunity opp = TestFactory.createOpportunity(acc.Id, UserInfo.getUserId());
		Product2 prod = TestFactory.createProduct();
		Final OpportunityLineItem oli = TestFactory.createOLI(opp.Id, prod.Id);
		oli.PE_List_Product_mode__c = '01';
		update oli;        
    }
    
    /** testMethodGetCommissions method*/
    /*@isTest
    static void testMethodGetCommissions() {
        Final OpportunityLineItem oli = [select id from OpportunityLineItem limit 1];
		Test.startTest();
        Final List<Product_Commission__c> commisions = BE_CalculateCommission_Ctr.getCommissions(oli.Id,true,true);
        Test.stopTest();
        System.assertEquals(4, commisions.size());
    }*/
    
    /** testMethodGetOlis method*/
    @isTest
    static void testMethodGetOlis() {
        Final Opportunity opp = [select id from Opportunity limit 1];
		Test.startTest();
        Final Map<String, Object> olis = BE_CalculateCommission_Ctr.getOlis(opp.Id);
        Test.stopTest();
        system.assert(olis!=null);
    }
}