@istest
public class SanctionPriceDecision_ctrl_Test {
    @testSetup
    static void setData() {
        Account acc = TestFactory.createAccount();
        Opportunity opp = TestFactory.createOpportunity(acc.Id, UserInfo.getUserId());
        Product2 prod = TestFactory.createProduct();
        OpportunityLineItem oli = TestFactory.createOLI(opp.Id, prod.Id);
    }

    @isTest
    static void test_method_one(){
        List<OpportunityLineItem> lstOLI = [SELECT Id FROM OpportunityLineItem];
        Map<String,Object> mapReturn = SanctionPriceDecision_ctrl.getInfo(lstOLI[0].Id);
        System.assert(mapReturn.containsKey('lstOppLineItem')); 
        
        List<Opportunity> lstOpp = [SELECT Id FROM Opportunity];
        Map<String,Object> mapReturnSave = SanctionPriceDecision_ctrl.saveDecision(lstOpp[0].Id,'09','04',true,'asd','nameAudit','comments');
        System.assertEquals(true, (Boolean)mapReturnSave.get('isOk'));
    }
}