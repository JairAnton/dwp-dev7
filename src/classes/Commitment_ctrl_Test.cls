@istest
public class Commitment_ctrl_Test {
    @testSetup
    static void setData() {
        Account acc = TestFactory.createAccount();
        Opportunity opp = TestFactory.createOpportunity(acc.Id, UserInfo.getUserId());
        Product2 prod = TestFactory.createProduct();
        OpportunityLineItem oli = TestFactory.createOLI(opp.Id, prod.Id);
    }

    @isTest
    static void test_method_one(){

        List<Product2> lstProd = [SELECT Id, Type_of_quote__c FROM Product2];
        lstProd[0].Type_of_quote__c = 'Tarifario';
        update lstProd;
        Map<String,Object> mapReturnInfo = Commitment_ctrl.getInfo('Tarifario');
        System.assert(mapReturnInfo.containsKey('schemaSetup'));

        List<Opportunity> lstOpp = [SELECT Id FROM Opportunity];
        Map<String,Object> mapReturnInfoTable = Commitment_ctrl.getInfoTable(lstOpp[0].Id);
        System.assert(mapReturnInfoTable.containsKey('schemaSetup'));

        List<Object> lstData = new List<Object>();
        lstData.add('Prod');
        lstData.add('PEN');
        lstData.add(34);
        lstData.add(12);
        lstData.add(3);
        lstData.add(null);
        lstData.add(null);
        Map<String,Object> mapReturnSave = Commitment_ctrl.saveCommitment(lstOpp[0].Id,lstData,null);
        System.assertEquals(true, (Boolean)mapReturnSave.get('isOK'));

        List<Opportunity_Solution_Commitment__c> lstOppSol = [SELECT Id FROM Opportunity_Solution_Commitment__c];
        Map<String,Object> mapReturnDelete = Commitment_ctrl.deleteCommitment(lstOppSol[0].Id);
        System.assertEquals(true, (Boolean)mapReturnDelete.get('isOK'));
        
    }
}