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
    
    /** @Description  variable RECORD_ID*/
    private static Final String RECORD_ID = 'recordId';
    /** @Description  variable SOBJECT_NAME*/
    private static Final String SOBJECT_NAME = 'sObjName';
    /** @Description  variable SOBJECT_FIELDS*/
    private static Final String SOBJECT_FIELDS = 'sObjFields';
    /** @Description  variable ASSERT_ERROR*/
    private static Final String ASSERT_ERROR = 'Assertion Error';
    /*
	 * @Description  method setUp
	 */
    @TestSetup
    static void setUp() {
        BE_SM_Factory_tst.generalSetUp();
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
        salesMeeting.slmt__management_plan_meeting_date__c = Date.newInstance(2020, 11, 2);
        System.runAs(new User(Id=salesMeeting.Collaborator__c)) {
            update salesMeeting;
        }
        Test.startTest();
        response = new BE_SM_Pipeline_Pending_cls().readRecords(new Map<String, Object>{RECORD_ID => salesMeeting.Id, SOBJECT_NAME => srl.sObjectApiName__c, SOBJECT_FIELDS => srl.FieldsQuery__c});
        Test.stopTest();
        System.assertEquals(response.data.size(), 1, ASSERT_ERROR);
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
        salesMeeting.slmt__management_plan_meeting_date__c = Date.newInstance(2020, 11, 2);
        System.runAs(new User(Id=salesMeeting.Collaborator__c)) {
            update salesMeeting;
        }
        Test.startTest();
        response = new BE_SM_Pipeline_Negotiaton_cls().readRecords(new Map<String, Object>{RECORD_ID => salesMeeting.Id, SOBJECT_NAME => srl.sObjectApiName__c, SOBJECT_FIELDS => srl.FieldsQuery__c});
        Test.stopTest();
        System.assertEquals(response.data.size(), 1, ASSERT_ERROR);
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
        salesMeeting.slmt__management_plan_meeting_date__c = Date.newInstance(2020, 11, 2);
        System.runAs(new User(Id=salesMeeting.Collaborator__c)) {
            update salesMeeting;
        }
        Test.startTest();
        response = new BE_SM_Pipeline_Sanction_cls().readRecords(new Map<String, Object>{RECORD_ID => salesMeeting.Id, SOBJECT_NAME => srl.sObjectApiName__c, SOBJECT_FIELDS => srl.FieldsQuery__c});
        Test.stopTest();
        System.assertEquals(response.data.size(), 1, ASSERT_ERROR);
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
        salesMeeting.slmt__management_plan_meeting_date__c = Date.newInstance(2020, 11, 2);
        System.runAs(new User(Id=salesMeeting.Collaborator__c)) {
            update salesMeeting;
        }
        Test.startTest();
        response = new BE_SM_Pipeline_Formalization_cls().readRecords(new Map<String, Object>{RECORD_ID => salesMeeting.Id, SOBJECT_NAME => srl.sObjectApiName__c, SOBJECT_FIELDS => srl.FieldsQuery__c});
        Test.stopTest();
        System.assertEquals(response.data.size(), 1, ASSERT_ERROR);
    }
    
    /*
	 * @Description  method getOppDismissed
	 */
    @isTest
    static void getOppDismissed() {
        Final slmt__Sales_Meeting__c salesMeeting = [SELECT Id, slmt__management_plan_meeting_date__c, Collaborator__c FROM slmt__Sales_Meeting__c LIMIT 1];
        Final BE_SingleRelatedList_Setting__mdt srl = [SELECT Id, FieldsQuery__c, sObjectApiName__c FROM BE_SingleRelatedList_Setting__mdt 
                                                       WHERE DeveloperName = 'BE_SM_DismissedOpportunities'];
        BE_SingleRelatedListCRUD_Cls.Response response;
        Test.startTest();
        response = new BE_SM_Opportunity_Dismissed_cls().readRecords(new Map<String, Object>{RECORD_ID => salesMeeting.Id, SOBJECT_NAME => srl.sObjectApiName__c, SOBJECT_FIELDS => srl.FieldsQuery__c});
        Test.stopTest();
        System.assertEquals(1, response.data.size(), ASSERT_ERROR);
    }
    
    /*
	 * @Description  method getOppExpired
	 */
    @isTest
    static void getOppExpired() {
        Final slmt__Sales_Meeting__c salesMeeting = [SELECT Id, slmt__management_plan_meeting_date__c, Collaborator__c FROM slmt__Sales_Meeting__c LIMIT 1];
        salesMeeting.DateTime__c = DateTime.newInstance(2020, 12, 2);
        System.runAs(new User(Id=salesMeeting.Collaborator__c)) {
            update salesMeeting;
        }
        Final BE_SingleRelatedList_Setting__mdt srl = [SELECT Id, FieldsQuery__c, sObjectApiName__c FROM BE_SingleRelatedList_Setting__mdt 
                                                       WHERE DeveloperName = 'BE_SM_ExpiredOpportunities'];
        BE_SingleRelatedListCRUD_Cls.Response response;
        Test.startTest();
        response = new BE_SM_Opportunity_Expired_cls().readRecords(new Map<String, Object>{RECORD_ID => salesMeeting.Id, SOBJECT_NAME => srl.sObjectApiName__c, SOBJECT_FIELDS => srl.FieldsQuery__c});
        Test.stopTest();
        System.assertEquals(4, response.data.size(), ASSERT_ERROR);
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
        salesMeeting.slmt__management_plan_meeting_date__c = Date.newInstance(2020, 11, 2);
        System.runAs(new User(Id=salesMeeting.Collaborator__c)) {
            update salesMeeting;
        }
        Final Opportunity opp = [SELECT Id FROM Opportunity WHERE StageName = '06' LIMIT 1];
        opp.Formalization_Date__c = Date.newInstance(2020, 10, 15);
        update opp;
        Test.startTest();
        response = new BE_SM_Opportunity_Formalized_cls().readRecords(new Map<String, Object>{RECORD_ID => salesMeeting.Id, SOBJECT_NAME => srl.sObjectApiName__c, SOBJECT_FIELDS => srl.FieldsQuery__c});
        Test.stopTest();
        System.assertEquals(response.data.size(), 1, ASSERT_ERROR);
    }
}