@istest
public class Commitment_ctrl_Test {
    
    static Account acctest;
    static Opportunity opptest;
    static OpportunityLineItem olitest;
    static Product2 prodtest;
    static User quoteOwner;
    
    @testSetup
    static void setData() {
            
            acctest = TestFactory.createAccount();
            opptest = new Opportunity(ownerId=UserInfo.getUserId(),Name='testopp', AccountId=acctest.Id,StageName='02',Amount=100 ,CloseDate=system.Date.today(),opportunity_status_type__c='02');
    		insert opptest;
            prodtest = TestFactory.createProduct();
            olitest = TestFactory.createOLI(opptest.Id, prodtest.Id);
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
    
    @isTest
    static void test_createQuoteRequest_Success(){
        
        
        setData();

        insert new iaso__GBL_Rest_Services_Url__c(Name = 'GrantingTickets', iaso__Url__c = 'https://validation/ok', iaso__Cache_Partition__c = 'local.CredentialsPeru');
        insert new iaso__GBL_Rest_Services_Url__c(Name = 'CreateQuotationRequest', iaso__Url__c = 'https://CreateRequestApproved/OK', iaso__Cache_Partition__c = 'local.CredentialsPeru');
        Test.setMock(HttpCalloutMock.class, new Integration_MockGenerator());
        iaso.GBL_Mock.setMock(new Integration_MockGenerator());
        
        Test.startTest();

        Map<String,Object> mapResultReturn = Commitment_ctrl.requestQuote(opptest.Id);
        System.assertEquals('true', mapResultReturn.get('success'));
        System.assertEquals(Label.PriceCreateQuotationRequestApprovedMessage, mapResultReturn.get('quotationStatusMessage'));

        Test.stopTest();
                
    }
    
    @isTest
    static void test_createQuoteRequest_Error_1(){
        
        setData();
        
        insert new iaso__GBL_Rest_Services_Url__c(Name = 'GrantingTickets', iaso__Url__c = 'https://validation/ok', iaso__Cache_Partition__c = 'local.CredentialsPeru');
        insert new iaso__GBL_Rest_Services_Url__c(Name = 'CreateQuotationRequest', iaso__Url__c = 'https://CreateRequest/KO_500', iaso__Cache_Partition__c = 'local.CredentialsPeru');
        Test.setMock(HttpCalloutMock.class, new Integration_MockGenerator());
        iaso.GBL_Mock.setMock(new Integration_MockGenerator());
        
        Test.startTest();
        
        Map<String,Object> mapResultReturn = Commitment_ctrl.requestQuote(opptest.Id);
        
        System.assertEquals('false', mapResultReturn.get('success'));
        System.assertEquals(Label.PriceCreateQuotationRequestUnknowError, mapResultReturn.get('errorMessage'));
            
        Test.stopTest();
        
    }
    @isTest
    static void test_createQuoteRequest_Error_2(){
        
        setData();
        
        insert new iaso__GBL_Rest_Services_Url__c(Name = 'GrantingTickets', iaso__Url__c = 'https://validation/ok', iaso__Cache_Partition__c = 'local.CredentialsPeru');
        insert new iaso__GBL_Rest_Services_Url__c(Name = 'CreateQuotationRequest', iaso__Url__c = 'https://CreateRequest/KO_409', iaso__Cache_Partition__c = 'local.CredentialsPeru');
        Test.setMock(HttpCalloutMock.class, new Integration_MockGenerator());
        iaso.GBL_Mock.setMock(new Integration_MockGenerator());
        
        Test.startTest();
        
        Map<String,Object> mapResultReturn = Commitment_ctrl.requestQuote(opptest.Id);
        
        System.assertEquals('false', mapResultReturn.get('success'));
            
        Test.stopTest();
        
    }
    @isTest
    static void test_requetQuotationApproval_Success(){
        
        
        setData();
		
		List<OpportunityLineItem> oppLineItemTestList = [SELECT Id, price_quote_id__c, price_operation_id__c 
														FROM OpportunityLineItem WHERE Id = :olitest.Id];
		
		if(!oppLineItemTestList.isEmpty()){
			oppLineItemTestList[0].price_quote_id__c = '1475650';
			oppLineItemTestList[0].price_operation_id__c = '1469800';
			oppLineItemTestList[0].price_quote_owner_id__c = UserInfo.getUserId();
		}
		
		update oppLineItemTestList[0];

        insert new iaso__GBL_Rest_Services_Url__c(Name = 'GrantingTickets', iaso__Url__c = 'https://validation/ok', iaso__Cache_Partition__c = 'local.CredentialsPeru');
        insert new iaso__GBL_Rest_Services_Url__c(Name = 'ModifyQuotationRequest', iaso__Url__c = 'https://ModifyQuotationRequestApproval/OK', iaso__Cache_Partition__c = 'local.CredentialsPeru');
        Test.setMock(HttpCalloutMock.class, new Integration_MockGenerator());
        iaso.GBL_Mock.setMock(new Integration_MockGenerator());
        
        Test.startTest();

        Map<String,Object> mapResultReturn = Commitment_ctrl.requestQuote(opptest.Id);
        System.assertEquals('true', mapResultReturn.get('success'));
        System.assertEquals(Label.PriceCreateQuotationRequestSentForApprovalMessage, mapResultReturn.get('quotationStatusMessage'));

        Test.stopTest();
                
    }
    
    @isTest
    static void test_requetQuotationApproval_2_Success(){
        
        
        setData();
		
		List<OpportunityLineItem> oppLineItemTestList = [SELECT Id, price_quote_id__c, price_operation_id__c 
														FROM OpportunityLineItem WHERE Id = :olitest.Id];
		
		if(!oppLineItemTestList.isEmpty()){
			oppLineItemTestList[0].price_quote_id__c = '1475650';
			oppLineItemTestList[0].price_operation_id__c = '1469800';
			oppLineItemTestList[0].price_quote_owner_id__c = UserInfo.getUserId();
		}
		
		update oppLineItemTestList[0];

        insert new iaso__GBL_Rest_Services_Url__c(Name = 'GrantingTickets', iaso__Url__c = 'https://validation/ok', iaso__Cache_Partition__c = 'local.CredentialsPeru');
        insert new iaso__GBL_Rest_Services_Url__c(Name = 'ModifyQuotationRequest', iaso__Url__c = 'https://ModifyQuotationRequestApproval/OK_2', iaso__Cache_Partition__c = 'local.CredentialsPeru');
        Test.setMock(HttpCalloutMock.class, new Integration_MockGenerator());
        iaso.GBL_Mock.setMock(new Integration_MockGenerator());
        
        Test.startTest();

        Map<String,Object> mapResultReturn = Commitment_ctrl.requestQuote(opptest.Id);
        System.assertEquals('true', mapResultReturn.get('success'));
        System.assertEquals(Label.PriceCreateQuotationRequestApprovedMessage, mapResultReturn.get('quotationStatusMessage'));

        Test.stopTest();
                
    }
    
    @isTest
    static void test_requetQuotationApprovalDifferentUser_Success(){
        
        
        setData();
		
		List<OpportunityLineItem> oppLineItemTestList = [SELECT Id, price_quote_id__c, price_operation_id__c 
														FROM OpportunityLineItem WHERE Id = :olitest.Id];
		
		if(!oppLineItemTestList.isEmpty()){
			oppLineItemTestList[0].price_quote_id__c = '1475650';
			oppLineItemTestList[0].price_operation_id__c = '1469800';
		}
		
		update oppLineItemTestList[0];

        insert new iaso__GBL_Rest_Services_Url__c(Name = 'GrantingTickets', iaso__Url__c = 'https://validation/ok', iaso__Cache_Partition__c = 'local.CredentialsPeru');
        insert new iaso__GBL_Rest_Services_Url__c(Name = 'ModifyQuotationRequest', iaso__Url__c = 'https://ModifyQuotationRequestApproval/OK', iaso__Cache_Partition__c = 'local.CredentialsPeru');
  
        Test.setMock(HttpCalloutMock.class, new Integration_MockGenerator());
        iaso.GBL_Mock.setMock(new Integration_MockGenerator());
        
        Test.startTest();

        Map<String,Object> mapResultReturn = Commitment_ctrl.requestQuote(opptest.Id);
        System.assertEquals('true', mapResultReturn.get('success')); 

        Test.stopTest();
                
    }
    
    @isTest
    static void test_requetQuotationApproval_Error_1(){
        
        
        setData();
		
		List<OpportunityLineItem> oppLineItemTestList = [SELECT Id, price_quote_id__c, price_operation_id__c 
														FROM OpportunityLineItem WHERE Id = :olitest.Id];
		
		if(!oppLineItemTestList.isEmpty()){
			oppLineItemTestList[0].price_quote_id__c = '1475650';
			oppLineItemTestList[0].price_operation_id__c = '1469800';
			oppLineItemTestList[0].price_quote_owner_id__c = UserInfo.getUserId();
		}
		
		update oppLineItemTestList[0];

        insert new iaso__GBL_Rest_Services_Url__c(Name = 'GrantingTickets', iaso__Url__c = 'https://validation/ok', iaso__Cache_Partition__c = 'local.CredentialsPeru');
        insert new iaso__GBL_Rest_Services_Url__c(Name = 'ModifyQuotationRequest', iaso__Url__c = 'https://ModifyQuotationRequestApproval/KO_409', iaso__Cache_Partition__c = 'local.CredentialsPeru');
        Test.setMock(HttpCalloutMock.class, new Integration_MockGenerator());
        iaso.GBL_Mock.setMock(new Integration_MockGenerator());
        
        Test.startTest();

        Map<String,Object> mapResultReturn = Commitment_ctrl.requestQuote(opptest.Id);
        System.assertEquals('false', mapResultReturn.get('success'));
        System.assert(String.valueOf(mapResultReturn.get('errorMessage')).contains(Label.PriceRequestQuotationApprovalKnownError));
        Test.stopTest();
                
    }
	
	@isTest
    static void test_requetQuotationApproval_Error_2(){
        
        
        setData();
		
		List<OpportunityLineItem> oppLineItemTestList = [SELECT Id, price_quote_id__c, price_operation_id__c 
														FROM OpportunityLineItem WHERE Id = :olitest.Id];
		
		if(!oppLineItemTestList.isEmpty()){
			oppLineItemTestList[0].price_quote_id__c = '1475650';
			oppLineItemTestList[0].price_operation_id__c = '1469800';
			oppLineItemTestList[0].price_quote_owner_id__c = UserInfo.getUserId();
		}
		
		update oppLineItemTestList[0];

        insert new iaso__GBL_Rest_Services_Url__c(Name = 'GrantingTickets', iaso__Url__c = 'https://validation/ok', iaso__Cache_Partition__c = 'local.CredentialsPeru');
        insert new iaso__GBL_Rest_Services_Url__c(Name = 'ModifyQuotationRequest', iaso__Url__c = 'https://ModifyQuotationRequestApproval/KO_500', iaso__Cache_Partition__c = 'local.CredentialsPeru');
        Test.setMock(HttpCalloutMock.class, new Integration_MockGenerator());
        iaso.GBL_Mock.setMock(new Integration_MockGenerator());
        
        Test.startTest();

        Map<String,Object> mapResultReturn = Commitment_ctrl.requestQuote(opptest.Id);
        System.assertEquals('false', mapResultReturn.get('success'));
        System.assertEquals(Label.PriceRequestQuotationApprovalUnKnownError, mapResultReturn.get('errorMessage'));
        Test.stopTest();
                
    }
    
    @isTest
    static void test_requetQuotationApprovalDifferentUser_Error_1(){
        
        
        setData();
		
		List<OpportunityLineItem> oppLineItemTestList = [SELECT Id, price_quote_id__c, price_operation_id__c 
														FROM OpportunityLineItem WHERE Id = :olitest.Id];
		
		if(!oppLineItemTestList.isEmpty()){
			oppLineItemTestList[0].price_quote_id__c = '1475650';
			oppLineItemTestList[0].price_operation_id__c = '1469800';
		}
		
		update oppLineItemTestList[0];

        insert new iaso__GBL_Rest_Services_Url__c(Name = 'GrantingTickets', iaso__Url__c = 'https://validation/ok', iaso__Cache_Partition__c = 'local.CredentialsPeru');
        insert new iaso__GBL_Rest_Services_Url__c(Name = 'ModifyQuotationRequest', iaso__Url__c = 'https://ModifyQuotationRequestApproval/KO_409', iaso__Cache_Partition__c = 'local.CredentialsPeru');
        Test.setMock(HttpCalloutMock.class, new Integration_MockGenerator());
        iaso.GBL_Mock.setMock(new Integration_MockGenerator());
        
        Test.startTest();

        Map<String,Object> mapResultReturn = Commitment_ctrl.requestQuote(opptest.Id);
        System.assertEquals('false', mapResultReturn.get('success'));
        System.assert(String.valueOf(mapResultReturn.get('errorMessage')).contains(Label.PriceRecoverRequestKnownError));
        Test.stopTest();
                
    }
    
    @isTest
    static void test_requetQuotationApprovalDifferentUser_Error_2(){
        
        
        setData();
		
		List<OpportunityLineItem> oppLineItemTestList = [SELECT Id, price_quote_id__c, price_operation_id__c 
														FROM OpportunityLineItem WHERE Id = :olitest.Id];
		
		if(!oppLineItemTestList.isEmpty()){
			oppLineItemTestList[0].price_quote_id__c = '1475650';
			oppLineItemTestList[0].price_operation_id__c = '1469800';

		}
		
		update oppLineItemTestList[0];

        insert new iaso__GBL_Rest_Services_Url__c(Name = 'GrantingTickets', iaso__Url__c = 'https://validation/ok', iaso__Cache_Partition__c = 'local.CredentialsPeru');
        insert new iaso__GBL_Rest_Services_Url__c(Name = 'ModifyQuotationRequest', iaso__Url__c = 'https://ModifyQuotationRequestApproval/KO_500', iaso__Cache_Partition__c = 'local.CredentialsPeru');
        Test.setMock(HttpCalloutMock.class, new Integration_MockGenerator());
        iaso.GBL_Mock.setMock(new Integration_MockGenerator());
        
        Test.startTest();

        Map<String,Object> mapResultReturn = Commitment_ctrl.requestQuote(opptest.Id);
        System.assertEquals('false', mapResultReturn.get('success'));
        System.assertEquals(Label.PriceRecoverRequestUnknownError, mapResultReturn.get('errorMessage'));
        Test.stopTest();
                
    }
}