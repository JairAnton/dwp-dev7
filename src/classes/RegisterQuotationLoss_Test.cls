@isTest
public class RegisterQuotationLoss_Test {

    @isTest static void rejectOppWithPriceQuotation_test() {
    	
        // Create test data
        Account acctest = TestFactory.createAccount();
        Opportunity opptest = TestFactory.createOpportunity(acctest.Id, UserInfo.getUserId());
        Product2 prodtest = TestFactory.createProduct();
        OpportunityLineItem olitest = TestFactory.createOLI(opptest.Id, prodtest.Id);
        
        List<Product2> prodTestListToUpdate = [SELECT Type_of_quote__c FROM Product2 WHERE Id = :prodtest.Id];
        if(!prodTestListToUpdate.isEmpty()){
            prodTestListToUpdate[0].Type_of_quote__c = 'Web';
            update prodTestListToUpdate[0];
        }
        
        List<Web_Service_Value_Mapping__c> webServiceMappintList = new List<Web_Service_Value_Mapping__c>();
		Web_Service_Value_Mapping__c wsMappingRecord = new Web_Service_Value_Mapping__c();
        wsMappingRecord.label__c = 'Por condiciones de riesgos';
        wsMappingRecord.value__c = '02';
        wsMappingRecord.web_service_parameter_id__c = 'REJECTION_REASON'; 
        wsMappingRecord.web_service_value__c = '2';
        webServiceMappintList.add(wsMappingRecord);
        
        Web_Service_Value_Mapping__c wsMappingRecord2 = new Web_Service_Value_Mapping__c();
        wsMappingRecord2.label__c = 'BCP';
        wsMappingRecord2.value__c = '01';
        wsMappingRecord2.web_service_parameter_id__c = 'REJECTION_WINNER_ENTITY'; 
        wsMappingRecord2.web_service_value__c = '1';
        webServiceMappintList.add(wsMappingRecord2);
        
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
        Product_cls.registerQuotationLoss(opptest.Id,'02','01');
        Test.stopTest();
        
        // Check result
        List<OpportunityLineItem> oppLineItemToCheckList = [SELECT Id, price_quote_status_id__c FROM OpportunityLineItem WHERE Id = : olitest.Id];
        
        String quotationStatus = '';
        
        if(!oppLineItemToCheckList.isEmpty()){
            quotationStatus = oppLineItemToCheckList[0].price_quote_status_id__c;
        }
        System.assertEquals('REGISTER_LOST', quotationStatus);
        
    }
    
    @isTest static void rejectOppWithPriceQuotation_Error1_test() {
    	
        // Create test data
        Account acctest = TestFactory.createAccount();
        Opportunity opptest = TestFactory.createOpportunity(acctest.Id, UserInfo.getUserId());
        Product2 prodtest = TestFactory.createProduct();
        OpportunityLineItem olitest = TestFactory.createOLI(opptest.Id, prodtest.Id);
        
        List<Product2> prodTestListToUpdate = [SELECT Type_of_quote__c FROM Product2 WHERE Id = :prodtest.Id];
        if(!prodTestListToUpdate.isEmpty()){
            prodTestListToUpdate[0].Type_of_quote__c = 'Web';
            update prodTestListToUpdate[0];
        }
        
        List<Web_Service_Value_Mapping__c> webServiceMappintList = new List<Web_Service_Value_Mapping__c>();
		Web_Service_Value_Mapping__c wsMappingRecord = new Web_Service_Value_Mapping__c();
        wsMappingRecord.label__c = 'Por condiciones de riesgos';
        wsMappingRecord.value__c = '02';
        wsMappingRecord.web_service_parameter_id__c = 'REJECTION_REASON'; 
        wsMappingRecord.web_service_value__c = '2';
        webServiceMappintList.add(wsMappingRecord);
        
        Web_Service_Value_Mapping__c wsMappingRecord2 = new Web_Service_Value_Mapping__c();
        wsMappingRecord2.label__c = 'BCP';
        wsMappingRecord2.value__c = '01';
        wsMappingRecord2.web_service_parameter_id__c = 'REJECTION_WINNER_ENTITY'; 
        wsMappingRecord2.web_service_value__c = '1';
        webServiceMappintList.add(wsMappingRecord2);
        
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
        insert new iaso__GBL_Rest_Services_Url__c(Name = 'ModifyQuotationRequest', iaso__Url__c = 'https://ModifyQuotationRequestDisburse/KO_409', iaso__Cache_Partition__c = 'local.CredentialsPeru');
        Test.setMock(HttpCalloutMock.class, new Integration_MockGenerator());
        iaso.GBL_Mock.setMock(new Integration_MockGenerator());
		
		Map<String,Object> resultMap = new Map<String,Object>();
        
        Test.startTest();
        resultMap = Product_cls.registerQuotationLoss(opptest.Id,'02','01');
        Test.stopTest();
        
        System.assertEquals('false',resultMap.get('success'));
        System.assert(String.valueOf(resultMap.get('errorMessage')).contains(Label.PriceRegisterLossKnownError));
    }
    
    @isTest static void rejectOppWithPriceQuotation_Error2_test() {
    	
        // Create test data
        Account acctest = TestFactory.createAccount();
        Opportunity opptest = TestFactory.createOpportunity(acctest.Id, UserInfo.getUserId());
        Product2 prodtest = TestFactory.createProduct();
        OpportunityLineItem olitest = TestFactory.createOLI(opptest.Id, prodtest.Id);
        
        List<Product2> prodTestListToUpdate = [SELECT Type_of_quote__c FROM Product2 WHERE Id = :prodtest.Id];
        if(!prodTestListToUpdate.isEmpty()){
            prodTestListToUpdate[0].Type_of_quote__c = 'Web';
            update prodTestListToUpdate[0];
        }
        
        List<Web_Service_Value_Mapping__c> webServiceMappintList = new List<Web_Service_Value_Mapping__c>();
		Web_Service_Value_Mapping__c wsMappingRecord = new Web_Service_Value_Mapping__c();
        wsMappingRecord.label__c = 'Por condiciones de riesgos';
        wsMappingRecord.value__c = '02';
        wsMappingRecord.web_service_parameter_id__c = 'REJECTION_REASON'; 
        wsMappingRecord.web_service_value__c = '2';
        webServiceMappintList.add(wsMappingRecord);
        
        Web_Service_Value_Mapping__c wsMappingRecord2 = new Web_Service_Value_Mapping__c();
        wsMappingRecord2.label__c = 'BCP';
        wsMappingRecord2.value__c = '01';
        wsMappingRecord2.web_service_parameter_id__c = 'REJECTION_WINNER_ENTITY'; 
        wsMappingRecord2.web_service_value__c = '1';
        webServiceMappintList.add(wsMappingRecord2);
        
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
        insert new iaso__GBL_Rest_Services_Url__c(Name = 'ModifyQuotationRequest', iaso__Url__c = 'https://ModifyQuotationRequestDisburse/KO_500', iaso__Cache_Partition__c = 'local.CredentialsPeru');
        Test.setMock(HttpCalloutMock.class, new Integration_MockGenerator());
        iaso.GBL_Mock.setMock(new Integration_MockGenerator());
		
		Map<String,Object> resultMap = new Map<String,Object>();
        
        Test.startTest();
        resultMap = Product_cls.registerQuotationLoss(opptest.Id,'02','01');
        Test.stopTest();
        
        System.assertEquals('false',resultMap.get('success'));
        System.assertEquals(String.valueOf(resultMap.get('errorMessage')),Label.PriceRegisterLossUnknownError);

    }
    
    @isTest static void rejectOppWithoutPriceQuotation_test() {
    	
        // Create test data
        Account acctest = TestFactory.createAccount();
        Opportunity opptest = TestFactory.createOpportunity(acctest.Id, UserInfo.getUserId());
        Product2 prodtest = TestFactory.createProduct();
        OpportunityLineItem olitest = TestFactory.createOLI(opptest.Id, prodtest.Id);
		
        //Reject the opp
        Map<String,Object> resultMap = new Map<String,Object>();
        resultMap = Product_cls.setRejectOpportunity(opptest.Id,'02','01','',100000,1,12,'');
        
        List<Opportunity> oppList = [SELECT StageName FROM Opportunity WHERE Id = :opptest.Id];
        
        if(!oppList.isEmpty()){
            System.assertEquals('07',oppList[0].StageName);
        }
	}
    
    @isTest static void recoverOppWithPriceQuotation_test() {
    	
        // Create test data
        Account acctest = TestFactory.createAccount();
        Opportunity opptest = TestFactory.createOpportunity(acctest.Id, UserInfo.getUserId());
        Product2 prodtest = TestFactory.createProduct();
        OpportunityLineItem olitest = TestFactory.createOLI(opptest.Id, prodtest.Id);
        
        List<Product2> prodTestListToUpdate = [SELECT Type_of_quote__c 
                                               FROM Product2 
                                               WHERE Id = :prodtest.Id];
        if(!prodTestListToUpdate.isEmpty()){
            prodTestListToUpdate[0].Type_of_quote__c = 'Web';
            update prodTestListToUpdate[0];
        }
        
        List<OpportunityLineItem> oppLineItemToUpdateList = [SELECT price_quote_owner_id__c
                                                            FROM OpportunityLineItem 
                                                            WHERE Id = : olitest.Id];
        if(!oppLineItemToUpdateList.isEmpty()){
            oppLineItemToUpdateList[0].price_quote_owner_id__c = UserInfo.getUserId();
        }
       
        Map<String,Object> resultMap = new Map<String,Object>();
        
        Test.startTest();
        resultMap = Product_cls.recoverQuotation(opptest.Id);
        Test.stopTest();
        
       System.assertEquals('true', String.valueOf(resultMap.get('nextAction')));
	   
        
    }
}