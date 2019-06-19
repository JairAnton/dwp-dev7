@istest
public class FieldSummary_ctrl_Test {

    @testSetup
    static void setData() {
        Account acc = TestFactory.createAccount();
        Opportunity opp = TestFactory.createOpportunity(acc.Id, UserInfo.getUserId());
        Product2 prod = TestFactory.createProduct();
        OpportunityLineItem oli = TestFactory.createOLI(opp.Id, prod.Id);
    }

    @isTest
    static void test_method_Success(){
        List<Product2> lstProd = [SELECT Id, Type_of_quote__c FROM Product2];
        lstProd[0].Type_of_quote__c = 'Carta de credito';
        update lstProd;
        List<Opportunity> lstOpp = [SELECT Id FROM Opportunity];
        lstOpp[0].StageName = '04';
        update lstOpp;
        
        Test.startTest();
        Map<String,Object> mapSave = FieldSummary_ctrl.doSave(lstOpp[0].Id);
        lstOpp = [SELECT Id, opportunity_status_type__c FROM Opportunity];
        System.assertEquals(true, (Boolean)mapSave.get('isOk'));
        System.assertEquals('11', lstOpp[0].opportunity_status_type__c);
        test.stopTest();
    }
    
    @isTest
    static void test_method_Error(){
        List<Product2> lstProd = [SELECT Id, Type_of_quote__c FROM Product2];
        lstProd[0].Type_of_quote__c = 'Carta de credito';
        update lstProd;
		List<Opportunity> lstOpp = [SELECT Id FROM Opportunity];
        
        Test.startTest();
        Map<String,Object> mapSave = FieldSummary_ctrl.doSave(lstOpp[0].Id);
        System.assertEquals(false, (Boolean)mapSave.get('isOk'));
        Test.stopTest();
    }
}