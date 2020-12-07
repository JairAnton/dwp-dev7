/**
   -------------------------------------------------------------------------------------------------
   @Name BE_SM_Minute_Tst
   @Author Martin Alejandro Mori Chavez (martin.mori.contractor@bbva.com)
   @Date 2020-11-11
   @Description
   @Changes
   Date        Author   Email                  				Type
   2020-11-11  MAMCH    martin.mori.contractor@bbva.com    	Creation
   -------------------------------------------------------------------------------------------------
 */
@isTest
public with sharing class BE_SM_Minute_Tst {
    
    /*
	 * @Description  method setUp
	 */
    @TestSetup
    static void setUp() {
        Final Id ejeProfileId = BE_SM_Factory_tst.ID_EJE;
        Final User userGOF = TestFactory.getUser(true, new Map<Schema.SObjectField, Object>{User.ProfileId => ejeProfileId, User.prof_position_id__c => 'E01'});
        Final User ejecutivo = TestFactory.getUser(true, new Map<Schema.SObjectField, Object>{User.ProfileId => ejeProfileId, User.prof_position_id__c => 'E03', User.ManagerId => userGOF.Id});
        System.runAs(ejecutivo) {
            BE_SM_Factory_tst.createSalesMeeting(DateTime.newInstance(System.today().addMonths(1).year(), System.today().addMonths(1).month(), 4), ejecutivo.Id, 'Planning', true);
        }
    }
    
    /*
	 * @Description method unitTest
	 */
    @isTest
    static void unitTest() {
        Final slmt__Sales_Meeting__c salesMeeting = [SELECT Id, slmt__management_plan_meeting_date__c, Collaborator__c FROM slmt__Sales_Meeting__c LIMIT 1];
        Test.startTest();
		Final ApexPages.StandardController stndCtr = new ApexPages.standardController(salesMeeting);
		Final BE_SM_Minute_Ctr ctrl = new BE_SM_Minute_Ctr(stndCtr);
        Final Map<String, String> mapTopic = ctrl.mapTopic;
		Final Map<String, String> mapVisit = ctrl.mapVisit;
		Final Map<String, String> mapPipeline = ctrl.mapPipeline;
		Final Map<String, String> mapPC = ctrl.mapPC;
        Final Integer numItems = mapTopic.size()+mapVisit.size()+mapPipeline.size()+mapPC.size();
        ctrl.sendMail();
		Test.stopTest();
        System.assertEquals(numItems, 24, 'success!!!');
    }
}