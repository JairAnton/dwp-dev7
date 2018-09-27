@isTest
public class RegisterQuotationLoss_Test {

    @isTest static void rejectOppWithPriceQuotation_test() {
    	
        // Create test data
        Account acctest = TestFactory.createAccount();
        Opportunity opptest = TestFactory.createOpportunity(acctest.Id, UserInfo.getUserId());
        Product2 prodtest = TestFactory.createProduct();
        OpportunityLineItem olitest = TestFactory.createOLI(opptest.Id, prodtest.Id);
        List<Web_Service_Value_Mapping__c> webServiceMappintList = new List<Web_Service_Value_Mapping__c>();
		Web_Service_Value_Mapping__c wsMappingRecord = new Web_Service_Value_Mapping__c();
        wsMappingRecord.label__c = 'Por condiciones de riesgos';
        wsMappingRecord.value__c = '02';
        wsMappingRecord.web_service_parameter_id__c = 'REJECTION_REASON'; 
        wsMappingRecord.web_service_value__c = '2';
        insert wsMappingRecord;
            
        // Prepare opportunity
        List<OpportunityLineItem> oppLineItemToUpdateList = [SELECT Id, price_quote_id__c, price_operation_id__c FROM OpportunityLineItem WHERE Id = : olitest.Id];
        
        if(!oppLineItemToUpdateList.isEmpty()){
            oppLineItemToUpdateList[0].price_quote_id__c = '1475650';
            oppLineItemToUpdateList[0].price_operation_id__c = '1469800';
            update oppLineItemToUpdateList[0];
        }
        
        // Prepare ws mocks
        insert new iaso__GBL_Rest_Services_Url__c(Name = 'GrantingTickets', iaso__Url__c = 'https://validation/ok', iaso__Cache_Partition__c = 'local.CredentialsPeru');
        insert new iaso__GBL_Rest_Services_Url__c(Name = 'ModifyQuotationRequest', iaso__Url__c = 'https://ModifyQuotationRequestRejection/OK', iaso__Cache_Partition__c = 'local.CredentialsPeru');
        Test.setMock(HttpCalloutMock.class, new Integration_MockGenerator());
        iaso.GBL_Mock.setMock(new Integration_MockGenerator());
        
        Test.startTest();
        Product_cls.registerQuotationLoss(opptest.Id,'02');
        Test.stopTest();
        
        // Check result
        List<OpportunityLineItem> oppLineItemToCheckList = [SELECT Id, price_quote_status_id__c FROM OpportunityLineItem WHERE Id = : olitest.Id];
        
        String quotationStatus = '';
        
        if(!oppLineItemToCheckList.isEmpty()){
            quotationStatus = oppLineItemToCheckList[0].price_quote_status_id__c;
        }
        System.assertEquals('REGISTER_LOST', quotationStatus);
        
    }
}