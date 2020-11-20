/**
   -------------------------------------------------------------------------------------------------
   @Name BE_SM_Pipeline_tst
   @Author Diego Carbajal Pastor (diego.carbajal@bbva.com)
   @Date 2020-11-10
   @Description
   @Changes
   Date        Author   Email                  Type
   2020-11-10  DCP     diego.carbajal@bbva.com    Creation
   -------------------------------------------------------------------------------------------------
 */
@isTest
public with sharing class BE_SM_Pipeline_tst {
    
    /*
	 * @Description  method setUp
	 */
    @TestSetup
    static void setUp(){
        Final Id ejeProfileId = BE_SM_Factory_tst.getEjecutivoProfile();
        Final User userGOF = TestFactory.getUser(true, new Map<Schema.SObjectField, Object>{User.ProfileId => ejeProfileId, User.prof_position_id__c => 'E01'});
        Final User ejecutivo = TestFactory.getUser(true, new Map<Schema.SObjectField, Object>{User.ProfileId => ejeProfileId, User.prof_position_id__c => 'E03', 
            																					User.ManagerId => userGOF.Id});
        Final Account acc = TestFactory.getAccount(true, new Map<Schema.SObjectField, Object>{Account.OwnerId => ejecutivo.Id});
        Final Date initDate = Date.newInstance(2020, 11, 11);
        System.runAs(ejecutivo) {
            BE_SM_Factory_tst.createSalesMeeting(DateTime.newInstance(2020, 11, 11), ejecutivo.Id, 'Planning', true);
        }
        Final Opportunity[] lstOpp = new Opportunity[]{};
        for(Integer i = 2; i <= 7; i++) {
            lstOpp.add(new Opportunity(ownerId = ejecutivo.Id, Name = 'testopp '+i, AccountId = acc.Id, StageName = '0'+i, Amount = 100, 
                                       CloseDate = initDate, Field_Sup_Closing_Date__c = initDate));
        }
        insert lstOpp;
        lstOpp[0].closeDate = initDate.addMonths(1);
        update lstOpp[0];
        Test.setCreatedDate(lstOpp[0].Id, initDate.addDays(-10));
        Final List<String> lstProducts = System.Label.Opp_LP_Products.split(',');
        Final Product2 product = BE_SM_Factory_tst.createProduct(lstProducts[0]);
        Final PricebookEntry standardPrice = BE_SM_Factory_tst.createPriceBookEntry(Test.getStandardPricebookId(), product.Id, 10000);
        Final OpportunityLineItem[] lstOli = new OpportunityLineItem[]{};
        for(Opportunity opp:lstOpp) {
            lstOli.add(new OpportunityLineItem(OpportunityId = opp.Id, Quantity = 1, TotalPrice = 10.00, PricebookEntryId = standardPrice.Id, Product2Id = product.Id));
        }
        insert lstOli;
    }
    
    /*
	 * @Description  method getPendingPipeline
	 */
    @isTest
    static void getPendingPipeline() {
        Final slmt__Sales_Meeting__c salesMeeting = [SELECT Id, slmt__management_plan_meeting_date__c, Collaborator__c FROM slmt__Sales_Meeting__c LIMIT 1];
        Final BE_SingleRelatedList_Setting__mdt srl = [SELECT Id, FieldsQuery__c, sObjectApiName__c FROM BE_SingleRelatedList_Setting__mdt 
                                                       WHERE DeveloperName = 'BE_SM_Pipeline_Pending'];
        BE_SingleRelatedListCRUD_Cls.Response response;
        salesMeeting.slmt__management_plan_meeting_date__c = Date.newInstance(2020, 11, 11);
        update salesMeeting;
        Test.startTest();
        response = new BE_SM_Pipeline_Pending_cls().readRecords(new Map<String, Object>{'recordId' => salesMeeting.Id, 'sObjName' => srl.sObjectApiName__c, 'sObjFields' => srl.FieldsQuery__c});
        Test.stopTest();
        System.assertEquals(response.data.size(), 1, 'Assertion Error');
    }

    /*
	 * @Description  method getNegotiatonPipeline
	 */
    @isTest
    static void getNegotiatonPipeline() {
        Final slmt__Sales_Meeting__c salesMeeting = [SELECT Id, slmt__management_plan_meeting_date__c, Collaborator__c FROM slmt__Sales_Meeting__c LIMIT 1];
        Final BE_SingleRelatedList_Setting__mdt srl = [SELECT Id, FieldsQuery__c, sObjectApiName__c FROM BE_SingleRelatedList_Setting__mdt 
                                                       WHERE DeveloperName = 'BE_SM_Pipeline_Negotiaton'];
        BE_SingleRelatedListCRUD_Cls.Response response;
        salesMeeting.slmt__management_plan_meeting_date__c = Date.newInstance(2020, 11, 11);
        update salesMeeting;
        Test.startTest();
        response = new BE_SM_Pipeline_Negotiaton_cls().readRecords(new Map<String, Object>{'recordId' => salesMeeting.Id, 'sObjName' => srl.sObjectApiName__c, 'sObjFields' => srl.FieldsQuery__c});
        Test.stopTest();
        System.assertEquals(response.data.size(), 1, 'Assertion Error');
    }
    
    /*
	 * @Description  method getSanctionPipeline
	 */
    @isTest
    static void getSanctionPipeline() {
        Final slmt__Sales_Meeting__c salesMeeting = [SELECT Id, slmt__management_plan_meeting_date__c, Collaborator__c FROM slmt__Sales_Meeting__c LIMIT 1];
        Final BE_SingleRelatedList_Setting__mdt srl = [SELECT Id, FieldsQuery__c, sObjectApiName__c FROM BE_SingleRelatedList_Setting__mdt 
                                                       WHERE DeveloperName = 'BE_SM_Pipeline_Sanction'];
        BE_SingleRelatedListCRUD_Cls.Response response;
        salesMeeting.slmt__management_plan_meeting_date__c = Date.newInstance(2020, 11, 11);
        update salesMeeting;
        Test.startTest();
        response = new BE_SM_Pipeline_Sanction_cls().readRecords(new Map<String, Object>{'recordId' => salesMeeting.Id, 'sObjName' => srl.sObjectApiName__c, 'sObjFields' => srl.FieldsQuery__c});
        Test.stopTest();
        System.assertEquals(response.data.size(), 1, 'Assertion Error');
    }
    
    /*
	 * @Description  method getFormalizationPipeline
	 */
    @isTest
    static void getFormalizationPipeline() {
        Final slmt__Sales_Meeting__c salesMeeting = [SELECT Id, slmt__management_plan_meeting_date__c, Collaborator__c FROM slmt__Sales_Meeting__c LIMIT 1];
        Final BE_SingleRelatedList_Setting__mdt srl = [SELECT Id, FieldsQuery__c, sObjectApiName__c FROM BE_SingleRelatedList_Setting__mdt 
                                                       WHERE DeveloperName = 'BE_SM_Pipeline_Formalization'];
        BE_SingleRelatedListCRUD_Cls.Response response;
        salesMeeting.slmt__management_plan_meeting_date__c = Date.newInstance(2020, 11, 11);
        update salesMeeting;
        Test.startTest();
        response = new BE_SM_Pipeline_Formalization_cls().readRecords(new Map<String, Object>{'recordId' => salesMeeting.Id, 'sObjName' => srl.sObjectApiName__c, 'sObjFields' => srl.FieldsQuery__c});
        Test.stopTest();
        System.assertEquals(response.data.size(), 1, 'Assertion Error');
    }
    
    /*
	 * @Description  method getOppDismissed
	 */
    @isTest
    static void getOppDismissed() {
        Final slmt__Sales_Meeting__c salesMeeting = [SELECT Id, slmt__management_plan_meeting_date__c, Collaborator__c FROM slmt__Sales_Meeting__c LIMIT 1];
        salesMeeting.DateTime__c = DateTime.newInstance(2020, 11, 15);
        update salesMeeting;
        Final BE_SingleRelatedList_Setting__mdt srl = [SELECT Id, FieldsQuery__c, sObjectApiName__c FROM BE_SingleRelatedList_Setting__mdt 
                                                       WHERE DeveloperName = 'BE_SM_DismissedOpportunities'];
        BE_SingleRelatedListCRUD_Cls.Response response;
        Test.startTest();
        response = new BE_SM_Opportunity_Dismissed_cls().readRecords(new Map<String, Object>{'recordId' => salesMeeting.Id, 'sObjName' => srl.sObjectApiName__c, 'sObjFields' => srl.FieldsQuery__c});
        Test.stopTest();
        System.assertEquals(response.data.size(), 1, 'Assertion Error');
    }
    
    /*
	 * @Description  method getOppExpired
	 */
    @isTest
    static void getOppExpired() {
        Final slmt__Sales_Meeting__c salesMeeting = [SELECT Id, slmt__management_plan_meeting_date__c, Collaborator__c FROM slmt__Sales_Meeting__c LIMIT 1];
        salesMeeting.DateTime__c = DateTime.newInstance(2020, 12, 15);
        update salesMeeting;
        Final BE_SingleRelatedList_Setting__mdt srl = [SELECT Id, FieldsQuery__c, sObjectApiName__c FROM BE_SingleRelatedList_Setting__mdt 
                                                       WHERE DeveloperName = 'BE_SM_ExpiredOpportunities'];
        BE_SingleRelatedListCRUD_Cls.Response response;
        Test.startTest();
        response = new BE_SM_Opportunity_Expired_cls().readRecords(new Map<String, Object>{'recordId' => salesMeeting.Id, 'sObjName' => srl.sObjectApiName__c, 'sObjFields' => srl.FieldsQuery__c});
        Test.stopTest();
        System.assertEquals(response.data.size(), 4, 'Assertion Error');
    }
    
    /*
	 * @Description  method getOppFomalized
	 */
    @isTest
    static void getOppFomalized() {
        Final slmt__Sales_Meeting__c salesMeeting = [SELECT Id, slmt__management_plan_meeting_date__c, Collaborator__c FROM slmt__Sales_Meeting__c LIMIT 1];
        Final BE_SingleRelatedList_Setting__mdt srl = [SELECT Id, FieldsQuery__c, sObjectApiName__c FROM BE_SingleRelatedList_Setting__mdt 
                                                       WHERE DeveloperName = 'BE_SM_FormalizedOpportunities'];
        BE_SingleRelatedListCRUD_Cls.Response response;
        salesMeeting.slmt__management_plan_meeting_date__c = Date.newInstance(2020, 11, 15);
        update salesMeeting;
        Final Opportunity opp = [SELECT Id FROM Opportunity WHERE StageName = '06' LIMIT 1];
        opp.Formalization_Date__c = Date.newInstance(2020, 11, 1);
        update opp;
        Test.startTest();
        response = new BE_SM_Opportunity_Formalized_cls().readRecords(new Map<String, Object>{'recordId' => salesMeeting.Id, 'sObjName' => srl.sObjectApiName__c, 'sObjFields' => srl.FieldsQuery__c});
        Test.stopTest();
        System.assertEquals(response.data.size(), 1, 'Assertion Error');
    }
    
    /*
	 * @Description  method getCardDetails
	 */
    @isTest
    static void getCardDetails() {
        Final slmt__Sales_Meeting__c salesMeeting = [SELECT Id, slmt__management_plan_meeting_date__c, Collaborator__c FROM slmt__Sales_Meeting__c LIMIT 1];
        Test.startTest();
        List<Map<String,String>> lstCard = new BE_SM_PipelineLPQVC_Cls().getCardDetails(salesMeeting, 'cardId');
        Test.stopTest();
        System.assertEquals(4, lstCard.size(), 'Assertion Failed');
    }
    
    /*
	 * @Description  method updateRecordsSuccessTest
	 */
    @isTest
    static void updateRecordsSuccessTest() {
        Final Opportunity opp = [SELECT Id FROM Opportunity WHERE StageName = '02' LIMIT 1];
        opp.Amount = 9999;
        Test.startTest();
        Final BE_SingleRelatedListCRUD_Cls.Response response = new BE_SM_Pipeline_Update_cls().updateRecords(new SObject[]{opp});
        Test.stopTest();
        Final SObject obj = response.data[0];
        System.assertEquals(opp.Amount, obj.get('Amount'), 'Assertion Failed');
    }
    
    /*
	 * @Description  method updateRecordsErrorTest
	 */
    @isTest
    static void updateRecordsErrorTest() {
        Final Opportunity opp;
        Test.startTest();
        Final BE_SingleRelatedListCRUD_Cls.Response response = new BE_SM_Pipeline_Update_cls().updateRecords(new SObject[]{opp});
        Test.stopTest();
        System.assertEquals(false, response.isSuccess, 'Assertion Failed');
    }
}