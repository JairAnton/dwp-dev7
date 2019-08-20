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
        Case c = new Case(opportunity_id__c=opp.Id, Status='01');
        insert c;
        Final fprd__GBL_Product_Configuration__c newPd = new fprd__GBL_Product_Configuration__c(fprd__LoV_labels__c = 'Valor Label 1', fprd__LoV_values__c = '01', 
                                                                                       fprd__Map_field__c='PE_List_Product_mode__c', fprd__Product__c=prod.Id);
        insert newPd;
    }
    
    static String createJson(Id oppId, Id oliId, String method, String phase, String status) {
        return '{'+
            '"recordId" : "'+oppId+'",'+
            '"statusOpp" : "'+status+'",'+
            '"stageName" : "'+etapa4+'",'+
            '"styleAudit" : "'+asd+'",'+
            '"nameAudit" : "'+nameAudit+'",'+
            '"strComments" : "'+comments+'",'+
            '"recordOli" : "'+oliId+'",'+
            '"statusCase" : "01",'+
            '"storeHtml" : "'+html+'",'+
            '"approvalMethod" : "'+method+'",'+
            '"wsPhase" : "'+phase+'",'+
            '"validDate" : "2000-11-11"'+
            '}';
    }

    @isTest
    static void testMethodOne() {
        Final List<OpportunityLineItem> lstOLI = [SELECT Id FROM OpportunityLineItem LIMIT 1];
        SanctionPriceDecision_ctrl.getInfo(lstOLI[0].Id);
        SanctionPriceDecision_ctrl.getInfoAnalist(lstOLI[0].Id);
        Final List<Opportunity> lstOpp = [SELECT Id FROM Opportunity LIMIT 1];
        SanctionPriceDecision_ctrl.saveDecision(lstOpp[0].Id, status9, etapa4, true, asd,nameAudit,comments,html);
        String json = createJson(lstOpp[0].Id, lstOLI[0].Id, 'COTIZADOR', null, status9);
        SanctionPriceDecision_ctrl.saveDecisionAnalist(json, true, new List<String>(), new List<Object>());
        
        lstOLI[0].price_quote_id__c = quoteid;
        lstOLI[0].price_operation_id__c = operationid;
        update lstOLI[0];

        insert new iaso__GBL_Rest_Services_Url__c(Name = grantTK, iaso__Url__c = urlGrantTK, iaso__Cache_Partition__c = credential);
        insert new iaso__GBL_Rest_Services_Url__c(Name = ModifQuote, iaso__Url__c = urlModifQuote, iaso__Cache_Partition__c = credential);
        Test.setMock(HttpCalloutMock.class, new Integration_MockGenerator());
        iaso.GBL_Mock.setMock(new Integration_MockGenerator());

        Test.startTest();
		List<String> lstFields = new List<String>();
        List<Object> lstData = new List<Object>();
        lstFields.add('price_quote_id__c');
        lstData.add('eeee');
        lstFields.add('minimun_fee_per__c');
        lstData.add(34.5);
        lstFields.add('gipr_Plazo__c');
        lstData.add(435.56);
        lstFields.add('fprd__GBL_Sample_Checkbox__c');
        lstData.add(true);
        lstFields.add('price_quote_date__c');
        lstData.add('2018-12-12');
        json = createJson(lstOpp[0].Id, lstOLI[0].Id, 'web', 'APPROVE', status9);
        Final Map<String,Object> mapReturnSave3 = SanctionPriceDecision_ctrl.saveDecisionAnalist(json, true,lstFields, lstData);
        System.assert((Boolean)mapReturnSave3.get('isOk'), 'resultado correcto');

        Test.stopTest();

        Final List<dwp_cvad__Action_Audit__c> lstAudit = [SELECT Id FROM dwp_cvad__Action_Audit__c LIMIT 1];
        SanctionPriceDecision_ctrl.saveAuditWeb(lstAudit[0].Id, html);
    }
    
    @isTest
    static void testMethodTwo() {
        Final List<OpportunityLineItem> lstOLI = [SELECT Id, OpportunityId FROM OpportunityLineItem LIMIT 1];
        lstOLI[0].price_quote_id__c = quoteid;
        lstOLI[0].price_operation_id__c = operationid;
        update lstOLI[0];
        
        Final Opportunity opp = new Opportunity(Id=lstOLI[0].OpportunityId, opportunity_status_type__c='08', StageName=etapa4);
        update opp;
        
        insert new iaso__GBL_Rest_Services_Url__c(Name = grantTK, iaso__Url__c = urlGrantTK, iaso__Cache_Partition__c = credential);
        insert new iaso__GBL_Rest_Services_Url__c(Name = 'GetQuotationRequest', iaso__Url__c = 'https://GetQuotationRequest/OK/1111?expand=quotations', iaso__Cache_Partition__c = credential);
        Test.setMock(HttpCalloutMock.class, new Integration_MockGenerator());
        iaso.GBL_Mock.setMock(new Integration_MockGenerator());
        
        Test.startTest();
        Final Map<String,Object> mapReturn = SanctionPriceDecision_ctrl.getInfo(lstOLI[0].Id);
        System.assert(mapReturn.containsKey('lstOppLineItem'), 'resultado correcto');
        Test.stopTest();
    }
    
    @isTest
    static void testRedirect() {
        Test.startTest();
        Final Map<String, Object> mapRes = SanctionPriceDecision_ctrl.redirect();
        Test.stopTest();
        System.assert(!(Boolean)mapRes.get('isError'), 'Error en resultado esperado.');
    }
}