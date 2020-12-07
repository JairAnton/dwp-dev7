/**
   -------------------------------------------------------------------------------------------------
   @Name BE_SM_Visit_Tst
   @Author Martin Alejandro Mori Chavez (martin.mori.contractor@bbva.com)
   @Date 2020-11-11
   @Description
   @Changes
   Date        Author   Email                  				Type
   2020-11-11  MAMCH    martin.mori.contractor@bbva.com    	Creation
   -------------------------------------------------------------------------------------------------
 */
@isTest
public with sharing class BE_SM_Visit_Tst {
    
    /*
	 * @Description  method setUp
	 */
    @TestSetup
    static void setUp() {
        Final Id ejeProfileId = BE_SM_Factory_tst.ID_EJE;
        Final User userGOF = TestFactory.getUser(true, new Map<Schema.SObjectField, Object>{User.ProfileId => ejeProfileId, User.prof_position_id__c => 'E01'});
        Final User ejecutivo = TestFactory.getUser(true, new Map<Schema.SObjectField, Object>{User.ProfileId => ejeProfileId, User.prof_position_id__c => 'E03', 
            																					User.ManagerId => userGOF.Id});
        Final Account acc = TestFactory.getAccount(true, new Map<Schema.SObjectField, Object>{Account.OwnerId => ejecutivo.Id});
        Final Date initDate = Date.newInstance(System.today().addMonths(1).year(), System.today().addMonths(1).month(), 04);
        System.runAs(ejecutivo) {
        	BE_SM_Factory_tst.createSalesMeeting(DateTime.newInstance(System.today().addMonths(1).year(), System.today().addMonths(1).month(), 4), ejecutivo.Id, 'Planning', true);
        }
        
        Final dwp_kitv__Visit__c [] lstVisitas = new dwp_kitv__Visit__c[] {};
		for(Integer i = 0; i < 30; i++) {
			lstVisitas.add(new dwp_kitv__Visit__c(dwp_kitv__account_id__c = acc.Id, dwp_kitv__visit_duration_number__c = '15', dwp_kitv__visit_start_date__c = initDate.addDays(5)));
		}
        for(Integer i = 0; i < 10; i++) {
			lstVisitas.add(new dwp_kitv__Visit__c(dwp_kitv__account_id__c = acc.Id, dwp_kitv__visit_status_type__c = '04', dwp_kitv__visit_duration_number__c = '15', dwp_kitv__visit_start_date__c = initDate.addDays(-5)));
		}
        insert lstVisitas;
    }
    
    /*
	 * @Description method getSMPlanningVisits
	 */
    @isTest
    static void getSMPlanningVisits() {
        Final slmt__Sales_Meeting__c salesMeeting = [SELECT Id, slmt__management_plan_meeting_date__c, Collaborator__c FROM slmt__Sales_Meeting__c LIMIT 1];
        Final BE_SingleRelatedList_Setting__mdt srl = [SELECT Id, FieldsQuery__c, sObjectApiName__c FROM BE_SingleRelatedList_Setting__mdt WHERE DeveloperName = 'BE_SM_PlanningVisit'];
        Test.startTest();
        Final BE_SingleRelatedListCRUD_Cls.Response response = new BE_SM_PlanningVisit_cls().readRecords(new Map<String, Object>{'recordId' => salesMeeting.Id, 'sObjName' => srl.sObjectApiName__c, 'sObjFields' => srl.FieldsQuery__c});
        Test.stopTest();
        System.assertEquals(response.data.size(), 30, 'success getSMPlanningVisits!!!');
    }

    /*
	 * @Description method getSMRealizedVisits
	 */
    @isTest
    static void getSMRealizedVisits() {
        Final slmt__Sales_Meeting__c salesMeeting = [SELECT Id, slmt__management_plan_meeting_date__c, Collaborator__c FROM slmt__Sales_Meeting__c LIMIT 1];
        Final BE_SingleRelatedList_Setting__mdt srl = [SELECT Id, FieldsQuery__c, sObjectApiName__c FROM BE_SingleRelatedList_Setting__mdt WHERE DeveloperName = 'BE_SM_RealizedVisit'];
        Test.startTest();
        Final BE_SingleRelatedListCRUD_Cls.Response response = new BE_SM_RealizedVisit_cls().readRecords(new Map<String, Object>{'recordId' => salesMeeting.Id, 'sObjName' => srl.sObjectApiName__c, 'sObjFields' => srl.FieldsQuery__c});
        Test.stopTest();
        System.assertEquals(response.data.size(), 10, 'success getSMRealizedVisits!!!');
    }
    
    /*
	 * @Description method getCardDetails
	 */
    @isTest
    static void getCardDetails() {
        Final slmt__Sales_Meeting__c salesMeeting = [SELECT Id, slmt__management_plan_meeting_date__c, Collaborator__c FROM slmt__Sales_Meeting__c LIMIT 1];
        Test.startTest();
        Final List<Map<String,String>> lstCard = new BE_SM_VisitQVC_Cls().getCardDetails(salesMeeting, 'cardId');
        Test.stopTest();
        System.assertEquals(4, lstCard.size(), 'success getCardDetails!!!');
    }
    
    /*
	 * @Description method getRecordType
	 */
    @isTest
    static void getRecordTypeTask() {
        Test.startTest();
        Final String rtId = BE_SM_Utils.getRecordTypeId('Sales_Meeting');
        Test.stopTest();
        System.assert(!String.isEmpty(rtId), 'success getRecordTypeTask!!!');
    }
}