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
	/**
     * This is label of map
     */
    Static Final String ISOKLABEL = 'isOk';
    /**
     * This is type of quote
     */
    Static Final String PRODUCTTYPE = 'Carta de credito';
    /**
     * This is default value of opportunity
     */
    Static Final String DEFAULTSTATUS = '01';
    /**
     * This is default message for assertEquals
     */
    Static Final String DEFAULTMSG = 'the status type must be equal to 01';
    
    @testSetup
    static void setData() {
        Final Account acc = TestFactory.createAccount();
        Final Opportunity opp = TestFactory.createOpportunity(acc.Id, UserInfo.getUserId());
        Final Product2 prod = TestFactory.createProduct();
        TestFactory.createOLI(opp.Id, prod.Id);
    }

    @isTest
    static void testMethodGetInfoIngr() {
        Final List<Product2> lstProd = [SELECT Id, Type_of_quote__c FROM Product2 LIMIT 1];
        lstProd[0].Type_of_quote__c = PRODUCTTYPE;
        update lstProd;
        Final List<Opportunity> lstOpp = [SELECT Id FROM Opportunity LIMIT 1];
        lstOpp[0].StageName = '18';
        update lstOpp;
		Final List<OpportunityLineItem> lstOLI = [SELECT Id FROM OpportunityLineItem LIMIT 1];
        lstOLI[0].cpliq_Commission__c='02';
        lstOLI[0].cpliq_Vcto_tarifa__c=System.today().addDays(4);
        update lstOLI;
        FieldSummary_ctrl.getInfo(lstOLI[0].Id, ISOKLABEL);
        Final List<Opportunity> lstOppResult = [SELECT Id, opportunity_status_type__c FROM Opportunity LIMIT 1];
        Final String statusType = lstOppResult[0].opportunity_status_type__c;
        System.assertEquals(DEFAULTSTATUS, statusType, DEFAULTMSG);
    }
    
    @isTest
    static void testMethodGetInfoPunt() {
        Final List<Product2> lstProd = [SELECT Id, Type_of_quote__c FROM Product2 LIMIT 1];
        lstProd[0].Type_of_quote__c = PRODUCTTYPE;
        update lstProd;
        Final List<Opportunity> lstOpp = [SELECT Id FROM Opportunity LIMIT 1];
        lstOpp[0].StageName = '04';
        update lstOpp;
		Final List<OpportunityLineItem> lstOLI = [SELECT Id FROM OpportunityLineItem LIMIT 1];
        lstOLI[0].cpliq_Commission__c='03';
        lstOLI[0].cpliq_Emission__c=1;
        lstOLI[0].cpliq_Negotiation__c=2;
        lstOLI[0].cpliq_Payment_Dif__c=3;
        lstOLI[0].cpliq_Extension__c=4;
        lstOLI[0].cpliq_Increase__c=5;
        update lstOLI;
        FieldSummary_ctrl.getInfo(lstOLI[0].Id, ISOKLABEL);
        Final List<Opportunity> lstOppResult = [SELECT Id, opportunity_status_type__c FROM Opportunity LIMIT 1];
        Final String statusType = lstOppResult[0].opportunity_status_type__c;
        System.assertEquals(DEFAULTSTATUS, statusType, DEFAULTMSG);
    }
    
    @isTest
    static void testMethodGetInfoFlat() {
        Final List<Product2> lstProd = [SELECT Id, Type_of_quote__c FROM Product2 LIMIT 1];
        lstProd[0].Type_of_quote__c = PRODUCTTYPE;
        update lstProd;
        Final List<Opportunity> lstOpp = [SELECT Id FROM Opportunity LIMIT 1];
        lstOpp[0].StageName = '04';
        update lstOpp;
		Final List<OpportunityLineItem> lstOLI = [SELECT Id FROM OpportunityLineItem LIMIT 1];
        lstOLI[0].cpliq_Commission__c='04';
        lstOLI[0].cpliq_BBVA__c=1;
        lstOLI[0].cpliq_Bco_Correspondent__c=2;
        update lstOLI;
        FieldSummary_ctrl.getInfo(lstOLI[0].Id, ISOKLABEL);
        Final List<Opportunity> lstOppResult = [SELECT Id, opportunity_status_type__c FROM Opportunity LIMIT 1];
        Final String statusType = lstOppResult[0].opportunity_status_type__c;
        System.assertEquals(DEFAULTSTATUS, statusType, DEFAULTMSG);
    }
    
    @isTest
    static void testMethodGetInfoAllIn() {
        Final List<Product2> lstProd = [SELECT Id, Type_of_quote__c FROM Product2 LIMIT 1];
        lstProd[0].Type_of_quote__c = PRODUCTTYPE;
        update lstProd;
        Final List<Opportunity> lstOpp = [SELECT Id FROM Opportunity LIMIT 1];
        lstOpp[0].StageName = '04';
        update lstOpp;
		Final List<OpportunityLineItem> lstOLI = [SELECT Id FROM OpportunityLineItem LIMIT 1];
        lstOLI[0].cpliq_Commission__c='05';
        lstOLI[0].cpliq_BBVA__c=1;
        lstOLI[0].cpliq_Bco_Correspondent__c=2;
        update lstOLI;
        FieldSummary_ctrl.getInfo(lstOLI[0].Id, ISOKLABEL);
        Final List<Opportunity> lstOppResult = [SELECT Id, opportunity_status_type__c FROM Opportunity LIMIT 1];
        Final String statusType = lstOppResult[0].opportunity_status_type__c;
        System.assertEquals(DEFAULTSTATUS, statusType, DEFAULTMSG);
    }
    
    @isTest
    static void testMethodGetInfoError() {
        Final List<Product2> lstProd = [SELECT Id, Type_of_quote__c FROM Product2 LIMIT 1];
        lstProd[0].Type_of_quote__c = PRODUCTTYPE;
        update lstProd;
        Final List<Opportunity> lstOpp = [SELECT Id FROM Opportunity LIMIT 1];
        lstOpp[0].StageName = '04';
        update lstOpp;
        
		Test.startTest();
        Final Map<String,Object> mapReturn = FieldSummary_ctrl.getInfo(lstOpp[0].Id, ISOKLABEL);
        Final Boolean returnValue = !(Boolean)mapReturn.get(ISOKLABEL);
        System.assert(returnValue, 'ERROR');
        Test.stopTest();
    }
    
    @isTest
    static void testMethodSuccess() {
        Final List<Product2> lstProd = [SELECT Id, Type_of_quote__c FROM Product2 LIMIT 1];
        lstProd[0].Type_of_quote__c = PRODUCTTYPE;
        update lstProd;
        Final List<Opportunity> lstOpp = [SELECT Id FROM Opportunity LIMIT 1];
        lstOpp[0].StageName = '04';
        update lstOpp;
        
        Test.startTest();
        FieldSummary_ctrl.doSave(lstOpp[0].Id, '<div>Hola</div>', ISOKLABEL);
        Final List<Opportunity> lstOppResult = [SELECT Id, opportunity_status_type__c FROM Opportunity LIMIT 1];
        Final String statusType = lstOppResult[0].opportunity_status_type__c;
        System.assertEquals('11', statusType, 'the status type must be equal to 11');
        test.stopTest();
    }

}