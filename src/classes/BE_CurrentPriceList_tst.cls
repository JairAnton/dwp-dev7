/**
 * BE_CurrentPriceList_tst
 * <p /><p />
 * Modification log:<p />
 * -------------------------------------------------------------------
 * Developer                    Date                Description<p />
 * -------------------------------------------------------------------
 *  Diego Carbajal 04/11/2020          Original version.<p />
 *
 * @author  Diego Carbajal
 */
@isTest
public class BE_CurrentPriceList_tst {

    @testSetup
    public static void setUp() {
        Final User ejecutivo = TestFactory.createUser('Ejecutivo', 'Ejecutivo');
        Final Account acc = TestFactory.getAccount(true, new Map<Schema.SObjectField, Object>{Account.OwnerId => ejecutivo.Id});
        Final Product2 product = TestFactory.createProduct();
        //Primera oportunidad con precio vigente
        Final Opportunity opp1 = TestFactory.createOpportunity(acc.Id, ejecutivo.Id);
        opp1.BE_HasApprovedQuote__c = true;
        update opp1;
        Final OpportunityLineItem oli1 = TestFactory.createOLI(opp1.Id, product.Id);
        oli1.price_quote_id__c = 'UNIQUE_ID';
        oli1.validityDate__c = Date.today()+50;
        update oli1;
        insert new ContentVersion(ContentLocation = 'S', PathOnClient = 'Document.pdf', VersionData = EncodingUtil.base64Decode('GENERATE DOCUMENT'), 
                                                         Title = acc.Name + ' - cotización Nro. ' + oli1.price_quote_id__c);
        Final Id conDoc = [SELECT ContentDocumentId FROM ContentVersion LIMIT 1].ContentDocumentId;
        insert new ContentDocumentLink(LinkedEntityId = opp1.Id, ContentDocumentId = conDoc, shareType = 'V');
        //Segunda oportunidad con precio vigente a elegir
        Final Opportunity opp2 = TestFactory.createOpportunity(acc.Id, ejecutivo.Id);
        Final Id priceBookId = [SELECT Id FROM PricebookEntry WHERE Pricebook2.Name = 'PriceBook' LIMIT 1].Id;
        insert new OpportunityLineItem(OpportunityId = opp2.Id, Quantity = 1, TotalPrice = 10.00, PricebookEntryId = priceBookId, Product2Id = product.Id);
    }
    
    @isTest
    public static void getCurrentPriceSuccess() {
        Final Opportunity[] lstOpp =[SELECT Id, CreatedDate FROM Opportunity ORDER BY CreatedDate ASC LIMIT 2];
        Final BE_SingleRelatedList_Setting__mdt config = [SELECT sObjectApiName__c, Settings__c, Filter__c, FieldsQuery__c FROM BE_SingleRelatedList_Setting__mdt 
                                                          WHERE DeveloperName = 'List_Read_OppCurrentPrice' LIMIT 1];
        Final BE_SingleRelatedList_Ctr.Params params = new BE_SingleRelatedList_Ctr.Params();
        params.sObjName = config.sObjectApiName__c;
        params.settings = (Map<String, Object>) JSON.deserializeUntyped(config.Settings__c);
        params.sObjFields = config.FieldsQuery__c;
        params.filterSQOL = config.Filter__c;
        Test.startTest();
        Final Object response = BE_SingleRelatedList_Ctr.getDynamicResponse(lstOpp[1].Id, params);
        Map<String, Object> mapResponse = (Map<String, Object>) JSON.deserializeUntyped(JSON.serialize(response));
        Test.stopTest();
        System.assert((Boolean) mapResponse.get('isSuccess'), 'Failed Assertion');
    }
    
    @isTest
    public static void getCurrentPriceError() {
        Final Opportunity[] lstOpp =[SELECT Id, CreatedDate FROM Opportunity ORDER BY CreatedDate ASC LIMIT 2];
        Final BE_SingleRelatedList_Setting__mdt config = [SELECT sObjectApiName__c, Settings__c, Filter__c, FieldsQuery__c FROM BE_SingleRelatedList_Setting__mdt 
                                                          WHERE DeveloperName = 'List_Read_OppCurrentPrice' LIMIT 1];
        Final BE_SingleRelatedList_Ctr.Params params = new BE_SingleRelatedList_Ctr.Params();
        params.sObjName = null;
        params.settings = (Map<String, Object>) JSON.deserializeUntyped(config.Settings__c);
        params.sObjFields = null;
        params.filterSQOL = null;
        Test.startTest();
        Final Object response = BE_SingleRelatedList_Ctr.getDynamicResponse(lstOpp[1].Id, params);
        Map<String, Object> mapResponse = (Map<String, Object>) JSON.deserializeUntyped(JSON.serialize(response));
        Test.stopTest();
        System.assert(!(Boolean)mapResponse.get('isSuccess'), 'Failed Assertion');
    }
}