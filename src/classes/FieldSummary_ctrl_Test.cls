/**
* @author Global_HUB developers
* @date 12-06-2019
*
* @group Global_HUB
*
* @description test class from FieldSummary_ctrl_Test
**/
@istest
public class FieldSummary_ctrl_Test {

    @testSetup
    static void setData() {
        Final Account acc = TestFactory.createAccount();
        Final Opportunity opp = TestFactory.createOpportunity(acc.Id, UserInfo.getUserId());
        Final Product2 prod = TestFactory.createProduct();
        TestFactory.createOLI(opp.Id, prod.Id);
    }

    @isTest
    static void testMethodSuccess() {
        Final List<Product2> lstProd = [SELECT Id, Type_of_quote__c FROM Product2 LIMIT 1];
        lstProd[0].Type_of_quote__c = 'Carta de credito';
        update lstProd;
        Final List<Opportunity> lstOpp = [SELECT Id FROM Opportunity LIMIT 1];
        lstOpp[0].StageName = '04';
        update lstOpp;
        
        Test.startTest();
        FieldSummary_ctrl.doSave(lstOpp[0].Id);
        Final List<Opportunity> lstOppResult = [SELECT Id, opportunity_status_type__c FROM Opportunity LIMIT 1];
        Final String statusType = lstOppResult[0].opportunity_status_type__c;
        System.assertEquals('11', statusType, 'the status type must be equal to 11');
        test.stopTest();
    }
    
    @isTest
    static void testMethodError() {
        Final List<Product2> lstProd = [SELECT Id, Type_of_quote__c FROM Product2 LIMIT 1];
        lstProd[0].Type_of_quote__c = 'Carta de credito';
        update lstProd;
		Final List<Opportunity> lstOpp = [SELECT Id FROM Opportunity LIMIT 1];
        
        Test.startTest();
        Boolean error = false;
        try {
            FieldSummary_ctrl.doSave(lstOpp[0].Id);
            error = false;
        } catch(Exception e) {
            error = true;
            System.debug(e);
        }
        System.assert(error, 'ERRORS');
        Test.stopTest();
    }
}