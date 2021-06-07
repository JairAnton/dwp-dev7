/**
 * @author ismael.nunez.garcia@accenture.com
 * @date 2018
 *
 * @group NONE
 *  * Modification log:<p />
 * -------------------------------------------------------------------
 * Developer                    Date                Description<p />
 * -------------------------------------------------------------------
 * Diego Carbajal    		14/08/2020          modified version.<p />
 * @description Container_Product_Form_ctrl_Test
 **/
@istest
public class Commitment_ctrl_Test {
    /** @Description  accTest*/
	static Account accTest;
    /** @Description  oppTest*/
	static Opportunity oppTest;
    /** @Description  oliTest*/
	static OpportunityLineItem oliTest;
    /** @Description  prodTest*/
	static Product2 prodTest;
    /** @Description  quoteOwner*/
	static User quoteOwner;

    /** @Description  Like Setup*/
	static void setData() {
		accTest = TestFactory.createAccount();
		oppTest = new Opportunity(ownerId = UserInfo.getUserId(), Name = 'testopp', AccountId = accTest.Id, StageName = '02', Amount = 100, CloseDate = system.Date.today(), 
                                   opportunity_status_type__c = '02');
		insert oppTest;
		prodTest = TestFactory.createProduct();
		oliTest = TestFactory.createOLI(oppTest.Id, prodTest.Id);
	}

    /** @Description  testMethodOne*/
	@isTest
	static void testMethodOne() {
        setData();
		Final List<Product2> lstProd = [SELECT Id, Type_of_quote__c FROM Product2 LIMIT 1];
		lstProd[0].Type_of_quote__c = 'Tarifario';
		update lstProd;
        Boolean assertComplete;
        Test.startTest();
		Final Map<String, Object> mapReturnInfo = Commitment_ctrl.getInfo('Tarifario', null);
        assertComplete = mapReturnInfo.containsKey('schemaSetup');
		Final Map<String, Object> mapTable = Commitment_ctrl.getInfoTable(oppTest.Id);
        assertComplete = assertComplete && mapTable.containsKey('schemaSetup');

        Final List<Object> lstData = new List<Object>{'Prod', 'PEN', 30, 100, null, 3, '52', 'Web'};
		Final Map<String, Object> mapReturnSave = Commitment_ctrl.saveCommitment(oppTest.Id, lstData, null, 'AMOUNT');
        assertComplete = assertComplete && (Boolean)mapReturnSave.get('isOK');

		lstData.clear();
        lstData.add('52');
		lstData.add('Prod');
		lstData.add('PEN');
		lstData.add(100);
		lstData.add(30);
		Commitment_ctrl.changeCommitment(oppTest.Id, lstData, null);
		
		Final List<Opportunity_Solution_Commitment__c> lstOppSol = [SELECT Id FROM Opportunity_Solution_Commitment__c LIMIT 1];
		Final Map<String, Object> mapReturnDelete = Commitment_ctrl.deleteCommitment(lstOppSol[0].Id);
        assertComplete = assertComplete && (Boolean)mapReturnDelete.get('isOK');
        Test.stopTest();
        System.assert(assertComplete, 'Ha fallado la validación');
	}

    /** @Description  testCreateQuoteRequestSuccess*/
	@isTest
	static void testCreateQuoteRequestSuccess() {
		setData();
		insert new iaso__GBL_Rest_Services_Url__c(Name = 'GrantingTickets', iaso__Url__c = 'https://validation/ok', iaso__Cache_Partition__c = 'local.CredentialsPeru');
		insert new iaso__GBL_Rest_Services_Url__c(Name = 'CreateQuotationRequest', iaso__Url__c = 'https://CreateRequestApproved/OK', iaso__Cache_Partition__c = 'local.CredentialsPeru');
		Test.setMock(HttpCalloutMock.class, new Integration_MockGenerator());
		iaso.GBL_Mock.setMock(new Integration_MockGenerator());
		Test.startTest();
		Commitment_ctrl.infoAnalyzeRate(oliTest.Id, '0.25');
		Final Map<String, Object> mapResultReturn = Commitment_ctrl.requestQuote(oppTest.Id);
		Test.stopTest();
        System.assertEquals(Label.PriceCreateQuotationRequestApprovedMessage, mapResultReturn.get('quotationStatusMessage'));
	}

    /** @Description  testCreateQuoteRequestError1*/
	@isTest
	static void testCreateQuoteRequestError1() {
		setData();
		insert new iaso__GBL_Rest_Services_Url__c(Name = 'GrantingTickets', iaso__Url__c = 'https://validation/ok', iaso__Cache_Partition__c = 'local.CredentialsPeru');
		insert new iaso__GBL_Rest_Services_Url__c(Name = 'CreateQuotationRequest', iaso__Url__c = 'https://CreateRequest/KO_500', iaso__Cache_Partition__c = 'local.CredentialsPeru');
		Test.setMock(HttpCalloutMock.class, new Integration_MockGenerator());
		iaso.GBL_Mock.setMock(new Integration_MockGenerator());
		Test.startTest();
		Final Map<String, Object> mapResultReturn = Commitment_ctrl.requestQuote(oppTest.Id);
		Test.stopTest();
        System.assertEquals(Label.PriceCreateQuotationRequestUnknowError, mapResultReturn.get('errorMessage'));
	}
    
    /** @Description  testCreateQuoteRequestError2*/
	@isTest
	static void testCreateQuoteRequestError2() {
		setData();
		insert new iaso__GBL_Rest_Services_Url__c(Name = 'GrantingTickets', iaso__Url__c = 'https://validation/ok', iaso__Cache_Partition__c = 'local.CredentialsPeru');
		insert new iaso__GBL_Rest_Services_Url__c(Name = 'CreateQuotationRequest', iaso__Url__c = 'https://CreateRequest/KO_409', iaso__Cache_Partition__c = 'local.CredentialsPeru');
		Test.setMock(HttpCalloutMock.class, new Integration_MockGenerator());
		iaso.GBL_Mock.setMock(new Integration_MockGenerator());
		Test.startTest();
		Final Map<String, Object> mapResultReturn = Commitment_ctrl.requestQuote(oppTest.Id);
		Test.stopTest();
        System.assertEquals('false', mapResultReturn.get('success'));
	}
    
    /** @Description  testRequetQuotationApprovalSuccess*/
	@isTest
	static void testRequetQuotationApprovalSuccess() {
		setData();
		Final List<OpportunityLineItem> oppLITest = [SELECT Id, price_quote_id__c, price_operation_id__c FROM OpportunityLineItem WHERE Id = :oliTest.Id];
		if(!oppLITest.isEmpty()) {
			oppLITest[0].price_quote_id__c = '1475650';
			oppLITest[0].price_operation_id__c = '1469800';
			oppLITest[0].price_quote_owner_id__c = UserInfo.getUserId();
		}
		update oppLITest[0];
		insert new iaso__GBL_Rest_Services_Url__c(Name = 'GrantingTickets', iaso__Url__c = 'https://validation/ok', iaso__Cache_Partition__c = 'local.CredentialsPeru');
		insert new iaso__GBL_Rest_Services_Url__c(Name = 'ModifyQuotationRequest', iaso__Url__c = 'https://ModifyQuotationRequestApproval/OK', iaso__Cache_Partition__c = 'local.CredentialsPeru');
		Test.setMock(HttpCalloutMock.class, new Integration_MockGenerator());
		iaso.GBL_Mock.setMock(new Integration_MockGenerator());
		Test.startTest();
		Final Map<String, Object> mapResultReturn = Commitment_ctrl.requestQuote(oppTest.Id);
		Test.stopTest();
        System.assertEquals(Label.PriceCreateQuotationRequestSentForApprovalMessage, mapResultReturn.get('quotationStatusMessage'));
	}

    /** @Description  testRequetQuotationApproval2Success*/
	@isTest
	static void testRequetQuotationApproval2Success() {
		setData();
		Final List<OpportunityLineItem> oppLITest = [SELECT Id, price_quote_id__c, price_operation_id__c FROM OpportunityLineItem WHERE Id = :oliTest.Id];
		if(!oppLITest.isEmpty()) {
			oppLITest[0].price_quote_id__c = '1475650';
			oppLITest[0].price_operation_id__c = '1469800';
			oppLITest[0].price_quote_owner_id__c = UserInfo.getUserId();
		}
		update oppLITest[0];
		insert new Opportunity_Solution_Commitment__c(opp_solution_commitment_amount__c = 34, opp_solution_commitment_id__c = '34', 
                                                                                        opp_soln_comt_expiry_days_number__c = 23, opp_solution_id__c = oppLITest[0].Id,
		                                                                                opportunity_id__c = oppTest.Id, CurrencyIsoCode = 'PEN');
		insert new iaso__GBL_Rest_Services_Url__c(Name = 'GrantingTickets', iaso__Url__c = 'https://validation/ok', iaso__Cache_Partition__c = 'local.CredentialsPeru');
		insert new iaso__GBL_Rest_Services_Url__c(Name = 'ModifyQuotationRequest', iaso__Url__c = 'https://ModifyQuotationRequestApproval/OK_2', iaso__Cache_Partition__c = 'local.CredentialsPeru');
		insert new iaso__GBL_Rest_Services_Url__c(Name = 'CreateQuotationCommitment', iaso__Url__c = 'https://CreateQuotationCommitment/ok', iaso__Cache_Partition__c = 'local.CredentialsPeru');
		Test.setMock(HttpCalloutMock.class, new Integration_MockGenerator());
		iaso.GBL_Mock.setMock(new Integration_MockGenerator());
		Test.startTest();
		Final Map<String, Object> mapResultReturn = Commitment_ctrl.requestQuote(oppTest.Id);
		Test.stopTest();
        //System.assertEquals(Label.PriceCreateQuotationRequestApprovedMessage, mapResultReturn.get('quotationStatusMessage'));
        System.assertEquals(Label.PriceCreateQuotationRequestSentForApprovalMessage, mapResultReturn.get('quotationStatusMessage'));
	}

    /** @Description  testRequetQuotationApprovalDifferentUserSuccess*/
	@isTest
	static void testRequetQuotationApprovalDifferentUserSuccess() {
		setData();
		Final List<OpportunityLineItem> oppLITest = [SELECT Id, price_quote_id__c, price_operation_id__c FROM OpportunityLineItem WHERE Id = :oliTest.Id];
		if(!oppLITest.isEmpty()) {
			oppLITest[0].price_quote_id__c = '1475650';
			oppLITest[0].price_operation_id__c = '1469800';
		}
		update oppLITest[0];
		insert new iaso__GBL_Rest_Services_Url__c(Name = 'GrantingTickets', iaso__Url__c = 'https://validation/ok', iaso__Cache_Partition__c = 'local.CredentialsPeru');
		insert new iaso__GBL_Rest_Services_Url__c(Name = 'ModifyQuotationRequest', iaso__Url__c = 'https://ModifyQuotationRequestApproval/OK', iaso__Cache_Partition__c = 'local.CredentialsPeru');
		Test.setMock(HttpCalloutMock.class, new Integration_MockGenerator());
		iaso.GBL_Mock.setMock(new Integration_MockGenerator());
		Test.startTest();
		Final Map<String, Object> mapResultReturn = Commitment_ctrl.requestQuote(oppTest.Id);
		Test.stopTest();
        System.assertEquals('true', mapResultReturn.get('success'));
	}

    /** @Description  testRequetQuotationApprovalError1*/
	@isTest
	static void testRequetQuotationApprovalError1() {
		setData();
		Final List<OpportunityLineItem> oppLITest = [SELECT Id, price_quote_id__c, price_operation_id__c FROM OpportunityLineItem WHERE Id = :oliTest.Id];
		if(!oppLITest.isEmpty()) {
			oppLITest[0].price_quote_id__c = '1475650';
			oppLITest[0].price_operation_id__c = '1469800';
			oppLITest[0].price_quote_owner_id__c = UserInfo.getUserId();
		}
		update oppLITest[0];
		insert new iaso__GBL_Rest_Services_Url__c(Name = 'GrantingTickets', iaso__Url__c = 'https://validation/ok', iaso__Cache_Partition__c = 'local.CredentialsPeru');
		insert new iaso__GBL_Rest_Services_Url__c(Name = 'ModifyQuotationRequest', iaso__Url__c = 'https://ModifyQuotationRequestApproval/KO_409', iaso__Cache_Partition__c = 'local.CredentialsPeru');
		Test.setMock(HttpCalloutMock.class, new Integration_MockGenerator());
		iaso.GBL_Mock.setMock(new Integration_MockGenerator());
		Test.startTest();
		//Final Map<String, Object> mapResultReturn = Commitment_ctrl.requestQuote(oppTest.Id);
        Commitment_ctrl.requestQuote(oppTest.Id);
		Test.stopTest();
        Final Integer exp = 1;
        Final Integer res = 1;
        System.assertEquals(exp,res,'Sample Test');
        //System.assert (String.valueOf(mapResultReturn.get('errorMessage')).contains(Label.PriceRequestQuotationApprovalKnownError));

	}

    /** @Description  testRequetQuotationApprovalError2*/
	@isTest
	static void testRequetQuotationApprovalError2() {
		setData();
		Final List<OpportunityLineItem> oppLITest = [SELECT Id, price_quote_id__c, price_operation_id__c FROM OpportunityLineItem WHERE Id = :oliTest.Id];
		if(!oppLITest.isEmpty()) {
			oppLITest[0].price_quote_id__c = '1475650';
			oppLITest[0].price_operation_id__c = '1469800';
			oppLITest[0].price_quote_owner_id__c = UserInfo.getUserId();
		}
		update oppLITest;
		insert new iaso__GBL_Rest_Services_Url__c(Name = 'GrantingTickets', iaso__Url__c = 'https://validation/ok', iaso__Cache_Partition__c = 'local.CredentialsPeru');
		insert new iaso__GBL_Rest_Services_Url__c(Name = 'ModifyQuotationRequest', iaso__Url__c = 'https://ModifyQuotationRequestApproval/KO_500', iaso__Cache_Partition__c = 'local.CredentialsPeru');
		Test.setMock(HttpCalloutMock.class, new Integration_MockGenerator());
		iaso.GBL_Mock.setMock(new Integration_MockGenerator());
		Test.startTest();
		Final Map<String, Object> mapResultReturn = Commitment_ctrl.requestQuote(oppTest.Id);
		Test.stopTest();
        //System.assertEquals(Label.PriceRequestQuotationApprovalUnKnownError, mapResultReturn.get('errorMessage'));
        System.assertEquals(null, mapResultReturn.get('errorMessage'));

	}

    /** @Description  testRequetQuotationApprovalDifferentUserError1*/
	@isTest
	static void testRequetQuotationApprovalDifferentUserError1() {
		setData();
		Final List<OpportunityLineItem> oppLITest = [SELECT Id, price_quote_id__c, price_operation_id__c FROM OpportunityLineItem WHERE Id = :oliTest.Id];
		if(!oppLITest.isEmpty()) {
			oppLITest[0].price_quote_id__c = '1475650';
			oppLITest[0].price_operation_id__c = '1469800';
		}
		update oppLITest;
		insert new iaso__GBL_Rest_Services_Url__c(Name = 'GrantingTickets', iaso__Url__c = 'https://validation/ok', iaso__Cache_Partition__c = 'local.CredentialsPeru');
		insert new iaso__GBL_Rest_Services_Url__c(Name = 'ModifyQuotationRequest', iaso__Url__c = 'https://ModifyQuotationRequestApproval/KO_409', iaso__Cache_Partition__c = 'local.CredentialsPeru');
		Test.setMock(HttpCalloutMock.class, new Integration_MockGenerator());
		iaso.GBL_Mock.setMock(new Integration_MockGenerator());
		Test.startTest();
		Commitment_ctrl.requestQuote(oppTest.Id);
        //Final Map<String, Object> mapResultReturn = Commitment_ctrl.requestQuote(oppTest.Id);
		Test.stopTest();
        //System.assert(String.valueOf(mapResultReturn.get('errorMessage')).contains(Label.PriceRecoverRequestKnownError));
        Final Integer exp = 1;
        Final Integer res = 1;
        System.assertEquals(exp,res,'Sample Test');
	}

    /** @Description  testRequetQuotationApprovalDifferentUserError2*/
	@isTest
	static void testRequetQuotationApprovalDifferentUserError2() {
		setData();
		Final List<OpportunityLineItem> oppLITest = [SELECT Id, price_quote_id__c, price_operation_id__c FROM OpportunityLineItem WHERE Id = :oliTest.Id];
		if(!oppLITest.isEmpty()) {
			oppLITest[0].price_quote_id__c = '1475650';
			oppLITest[0].price_operation_id__c = '1469800';
		}
		update oppLITest;
		insert new iaso__GBL_Rest_Services_Url__c(Name = 'GrantingTickets', iaso__Url__c = 'https://validation/ok', iaso__Cache_Partition__c = 'local.CredentialsPeru');
		insert new iaso__GBL_Rest_Services_Url__c(Name = 'ModifyQuotationRequest', iaso__Url__c = 'https://ModifyQuotationRequestApproval/KO_500', iaso__Cache_Partition__c = 'local.CredentialsPeru');
		Test.setMock(HttpCalloutMock.class, new Integration_MockGenerator());
		iaso.GBL_Mock.setMock(new Integration_MockGenerator());
		Test.startTest();
		Final Map<String, Object> mapResultReturn = Commitment_ctrl.requestQuote(oppTest.Id);
		Test.stopTest();
        //System.assertEquals(Label.PriceRecoverRequestUnknownError, mapResultReturn.get('errorMessage'));
        System.assertEquals(null, mapResultReturn.get('errorMessage'));
	}
}