/**
 * @author Global_HUB developers
 * @date 12-06-2019
 *
 * @group Global_HUB
 *
 * @description test class from SanctionPriceDecision_ctrl
 **/
@istest
public class SanctionPriceDecision_ctrl_Test {
	/**
	 * Label of GrantingTickets
	 */
	static String grantTK = 'GrantingTickets';
	/**
	 * Label of url GrantingTickets
	 */
	static String urlGrantTK = 'https://validation/ok';
	/**
	 * Label of ModifyQuotationRequest
	 */
	static String modifQuote = 'ModifyQuotationRequest';
	/**
	 * Label of url ModifyQuotationRequest
	 */
	static String urlModifQuote = 'https://ModifyQuotationRequestRecover/OK';
	/**
	 * Label of opportunity status
	 */
	static String status9 = '09';
	/**
	 * Label of opportunity stage
	 */
	static String etapa4 = '04';
	/**
	 * Label of asd string
	 */
	static String asd = 'asd';
	/**
	 * Label of name audit
	 */
	static String nameAudit = 'nameAudit';
	/**
	 * Label of comments
	 */
	static String comments = 'comments';
	/**
	 * Label of store html
	 */
	static String html = '<div>Hola</div>';
	/**
	 * Label of credential login
	 */
	static String credential = 'local.CredentialsPeru';
	/**
	 * Label of quote id
	 */
	static String quoteid = '111';
	/**
	 * Label of operation id
	 */
	static String operationid = '222';
    
	@testSetup
	static void setData() {
		Account acc = TestFactory.createAccount();
		Opportunity opp = TestFactory.createOpportunity(acc.Id, UserInfo.getUserId());
		Product2 prod = TestFactory.createProduct();
		OpportunityLineItem oli = TestFactory.createOLI(opp.Id, prod.Id);
		oli.PE_List_Product_mode__c = '01';
		update oli;
		Final Case newCase = new Case(opportunity_id__c = opp.Id, Status = '01');
		insert newCase;
        Final List<fprd__GBL_Product_Configuration__c> ltsPC = new List<fprd__GBL_Product_Configuration__c>();
		Final fprd__GBL_Product_Configuration__c newPd1 = new fprd__GBL_Product_Configuration__c();
        newPd1.fprd__LoV_labels__c = 'Valor Label 1';
        newPd1.fprd__LoV_values__c = '01';
        newPd1.fprd__Map_field__c = 'PE_List_Product_mode__c';
        newPd1.fprd__Product__c = prod.Id;
        ltsPC.add(newPd1);
        Final fprd__GBL_Product_Configuration__c newPd2 = new fprd__GBL_Product_Configuration__c();
        newPd1.fprd__LoV_labels__c = 'Dias,Meses';
        newPd1.fprd__LoV_values__c = '01,02';
        newPd1.fprd__Map_field__c = 'gipr_Periodicidad__c';
        newPd1.fprd__Product__c = prod.Id;
        ltsPC.add(newPd2);
		insert ltsPC;
	}

	static String createJson(Id oppId, Id oliId, String status) {
		return '{' +
		       '"recordId" : "' + oppId + '",' +
		       '"statusOpp" : "' + status + '",' +
		       '"stageName" : "' + etapa4 + '",' +
		       '"styleAudit" : "' + asd + '",' +
		       '"nameAudit" : "' + nameAudit + '",' +
		       '"strComments" : "' + comments + '",' +
		       '"recordOli" : "' + oliId + '",' +
		       '"statusCase" : "01",' +
		       '"storeHtml" : "' + html + '",' +
		       '"approvalMethod" : "web",' +
		       '"wsPhase" : "approve",' +
		       '"validDate" : "2000-11-11"' +
		       '}';
	}
    
    static List<String> createFields() {
		Final List<String> lstFields = new List<String>();
        lstFields.add('price_quote_id__c');
		lstFields.add('minimun_fee_per__c');
		lstFields.add('gipr_Plazo__c');
		lstFields.add('fprd__GBL_Sample_Checkbox__c');
		lstFields.add('price_quote_date__c');
        return lstFields;
    }
    
    static List<Object> createData() {
        Final List<Object> lstData = new List<Object>();
        lstData.add('eeee');
		lstData.add(34.5);
		lstData.add(435.56);
		lstData.add(true);
		lstData.add('2018-12-10');
        return lstData;
    }

    @isTest
	static void testMethodSent() {
		Final List<OpportunityLineItem> lstOLI = [SELECT Id FROM OpportunityLineItem LIMIT 1];
		SanctionPriceDecision_ctrl.getInfo(lstOLI[0].Id, 'Web_Proposal_Summarize');
		SanctionPriceDecision_ctrl.getInfoAnalist(lstOLI[0].Id, 'Web_Proposal_Summarize');
		Final List<Opportunity> lstOpp = [SELECT Id FROM Opportunity LIMIT 1];
		SanctionPriceDecision_ctrl.saveDecision(lstOpp[0].Id, status9, etapa4, true, asd, nameAudit, comments, html);
		String json = createJson(lstOpp[0].Id, lstOLI[0].Id, status9);
		SanctionPriceDecision_ctrl.saveDecisionAnalist(json.replace('web',  'COTIZADOR'), true, new List<String>(), new List<Object>());

		lstOLI[0].price_quote_id__c = quoteid;
		lstOLI[0].price_operation_id__c = operationid;
		update lstOLI[0];

		insert new iaso__GBL_Rest_Services_Url__c(Name = grantTK, iaso__Url__c = urlGrantTK, iaso__Cache_Partition__c = credential);
		insert new iaso__GBL_Rest_Services_Url__c(Name = ModifQuote, iaso__Url__c = urlModifQuote, iaso__Cache_Partition__c = credential);
        Test.setMock(HttpCalloutMock.class, new Integration_MockGenerator());
		iaso.GBL_Mock.setMock(new Integration_MockGenerator());

		Test.startTest();
		Final List<String> lstFields = createFields();
		Final List<Object> lstData = createData();
		json = createJson(lstOpp[0].Id, lstOLI[0].Id, status9);
		Final Map<String, Object> mapReturnSave3 = SanctionPriceDecision_ctrl.saveDecisionAnalist(json, true, lstFields, lstData);
		System.assert ((Boolean)mapReturnSave3.get('isOk'), 'resultado correcto');
        Test.stopTest();

		Final List<dwp_cvad__Action_Audit__c> lstAudit = [SELECT Id FROM dwp_cvad__Action_Audit__c LIMIT 1];
		SanctionPriceDecision_ctrl.saveAuditWeb(lstAudit[0].Id, html);
	}

	@isTest
	static void testMethodAuthorized() {
		Final List<OpportunityLineItem> lstOLI = [SELECT Id FROM OpportunityLineItem LIMIT 1];
		Final List<Opportunity> lstOpp = [SELECT Id FROM Opportunity LIMIT 1];
		
		lstOLI[0].price_quote_id__c = quoteid;
		lstOLI[0].price_operation_id__c = operationid;
		update lstOLI[0];

		insert new iaso__GBL_Rest_Services_Url__c(Name = grantTK, iaso__Url__c = urlGrantTK, iaso__Cache_Partition__c = credential);
		insert new iaso__GBL_Rest_Services_Url__c(Name = ModifQuote, iaso__Url__c = urlModifQuote, iaso__Cache_Partition__c = credential);
        Test.setMock(HttpCalloutMock.class, new Integration_MockGenerator());
		iaso.GBL_Mock.setMock(new Integration_MockGenerator());

		Test.startTest();
		Final List<String> lstFields = createFields();
		Final List<Object> lstData = createData();
		Final String json = createJson(lstOpp[0].Id, lstOLI[0].Id, '10');
		Final Map<String, Object> mapReturnSave3 = SanctionPriceDecision_ctrl.saveDecisionAnalist(json, true, lstFields, lstData);
		System.assert ((Boolean)mapReturnSave3.get('isOk'), 'success!!!');
        Test.stopTest();
	}

	@isTest
	static void testMethodDenied() {
		Final List<OpportunityLineItem> lstOLI = [SELECT Id FROM OpportunityLineItem LIMIT 1];
		Final List<Opportunity> lstOpp = [SELECT Id FROM Opportunity LIMIT 1];
		
        lstOLI[0].price_quote_id__c = quoteid;
		lstOLI[0].price_operation_id__c = operationid;
		update lstOLI[0];

		insert new iaso__GBL_Rest_Services_Url__c(Name = grantTK, iaso__Url__c = urlGrantTK, iaso__Cache_Partition__c = credential);
		insert new iaso__GBL_Rest_Services_Url__c(Name = ModifQuote, iaso__Url__c = urlModifQuote, iaso__Cache_Partition__c = credential);
        Test.setMock(HttpCalloutMock.class, new Integration_MockGenerator());
		iaso.GBL_Mock.setMock(new Integration_MockGenerator());

		Test.startTest();
		Final List<String> lstFields = createFields();
		Final List<Object> lstData = createData();
		Final String json = createJson(lstOpp[0].Id, lstOLI[0].Id, '13');
		Final Map<String, Object> mapReturnSave3 = SanctionPriceDecision_ctrl.saveDecisionAnalist(json, true, lstFields, lstData);
		System.assert ((Boolean)mapReturnSave3.get('isOk'), 'success');
        Test.stopTest();
	}

	@isTest
	static void testMethodTwo() {
		Final List<OpportunityLineItem> lstOLI = [SELECT Id, OpportunityId FROM OpportunityLineItem LIMIT 1];
		lstOLI[0].price_quote_id__c = '1111';
		lstOLI[0].price_operation_id__c = operationid;
		update lstOLI[0];

		Final Opportunity opp = new Opportunity(Id = lstOLI[0].OpportunityId, opportunity_status_type__c = '08', StageName = etapa4);
		update opp;

		insert new iaso__GBL_Rest_Services_Url__c(Name = grantTK, iaso__Url__c = urlGrantTK, iaso__Cache_Partition__c = credential);
		insert new iaso__GBL_Rest_Services_Url__c(Name = 'GetQuotationRequest', iaso__Url__c = 'https://GetQuotationRequest/OK', iaso__Cache_Partition__c = credential);
		Test.setMock(HttpCalloutMock.class, new Integration_MockGenerator());
		iaso.GBL_Mock.setMock(new Integration_MockGenerator());

		Test.startTest();
		Final Map<String, Object> mapReturn = SanctionPriceDecision_ctrl.getInfo(lstOLI[0].Id, 'Web_Proposal_Summarize');
		System.assert (mapReturn.containsKey('lstOppLineItem'), 'resultado exitoso');
		Test.stopTest();
	}

	@isTest
	static void testRedirect() {
		Test.startTest();
		Final Map<String, Object> mapRes = SanctionPriceDecision_ctrl.redirect();
		Test.stopTest();
		System.assert (!(Boolean)mapRes.get('isError'), 'Error en resultado esperado.');
	}
}
