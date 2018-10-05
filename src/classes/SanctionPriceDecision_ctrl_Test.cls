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
        Map<String,Object> mapReturnSave2 = SanctionPriceDecision_ctrl.saveDecisionAnalist(lstOpp[0].Id,'09','04',true,'asd','nameAudit','comments',lstOLI[0].Id, new List<String>(), new List<Object>(),'01', '<div>Hola</div>','COTIZADOR',null);
        System.assertEquals(true, (Boolean)mapReturnSave2.get('isOk'));

        lstOLI[0].price_quote_id__c = '111';
        lstOLI[0].price_operation_id__c = '222';
        update lstOLI[0];

        insert new iaso__GBL_Rest_Services_Url__c(Name = 'GrantingTickets', iaso__Url__c = 'https://validation/ok', iaso__Cache_Partition__c = 'local.CredentialsPeru');
        insert new iaso__GBL_Rest_Services_Url__c(Name = 'ModifyQuotationRequest', iaso__Url__c = 'https://ModifyQuotationRequestRecover/OK', iaso__Cache_Partition__c = 'local.CredentialsPeru');
        Test.setMock(HttpCalloutMock.class, new Integration_MockGenerator());
        iaso.GBL_Mock.setMock(new Integration_MockGenerator());

        Test.startTest();
		List<Object> lstData = new List<Object>();
        lstData.add(23);
        Map<String,Object> mapReturnSave3 = SanctionPriceDecision_ctrl.saveDecisionAnalist(lstOpp[0].Id,'09','04',true,'asd','nameAudit','comments',lstOLI[0].Id, new List<String>(), lstData,'01', '<div>Hola</div>','Web','APPROVE');
        System.assertEquals(true, (Boolean)mapReturnSave3.get('isOk'));

        Test.stopTest();

        List<dwp_cvad__Action_Audit__c> lstAudit = [SELECT Id FROM dwp_cvad__Action_Audit__c];
        SanctionPriceDecision_ctrl.saveAuditWeb(lstAudit[0].Id, '<div>Hola</div>');
    }
}