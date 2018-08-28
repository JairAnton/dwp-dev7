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
        Map<String,Object> mapReturn2 = SanctionPriceDecision_ctrl.getInfoAnalist(lstOLI[0].Id);
        System.assert(mapReturn2.containsKey('lstOppLineItem')); 
        
        List<Opportunity> lstOpp = [SELECT Id FROM Opportunity];
        Map<String,Object> mapReturnSave = SanctionPriceDecision_ctrl.saveDecision(lstOpp[0].Id,'09','04',true,'asd','nameAudit','comments','<div>Hola</div>');
        System.assertEquals(true, (Boolean)mapReturnSave.get('isOk'));
        Map<String,Object> mapReturnSave2 = SanctionPriceDecision_ctrl.saveDecisionAnalist(lstOpp[0].Id,'09','04',true,'asd','nameAudit','comments',lstOLI[0].Id, new List<String>(), new List<Object>(),'01', '<div>Hola</div>');
        System.assertEquals(true, (Boolean)mapReturnSave2.get('isOk'));
    }
}