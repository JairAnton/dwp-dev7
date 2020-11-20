/**
   -------------------------------------------------------------------------------------------------
   @Name BE_SM_SyncAttendees_Tst
   @Author Martin Alejandro Mori Chavez (martin.mori.contractor@bbva.com)
   @Date 2020-11-11
   @Description
   @Changes
   Date        Author   Email                  				Type
   2020-11-11  MAMCH    martin.mori.contractor@bbva.com    	Creation
   -------------------------------------------------------------------------------------------------
 */
@isTest
public with sharing class BE_SM_SyncAttendees_Tst {
    
    /*
	 * @Description  method setUp
	 */
    @TestSetup
    static void setUp(){
        Final Id ejeProfileId = BE_SM_Factory_tst.getEjecutivoProfile();
        Final User userGOF = TestFactory.getUser(true, new Map<Schema.SObjectField, Object>{User.ProfileId => ejeProfileId, User.prof_position_id__c => 'E01'});
        Final User ejecutivo = TestFactory.getUser(true, new Map<Schema.SObjectField, Object>{User.ProfileId => ejeProfileId, User.prof_position_id__c => 'E03', User.ManagerId => userGOF.Id});
        Final Account acc = TestFactory.getAccount(true, new Map<Schema.SObjectField, Object>{Account.OwnerId => ejecutivo.Id});
        
        Final List<slmt__Sales_Meeting__c> lstSM = new List<slmt__Sales_Meeting__c>();
        for(Integer aux = 0; aux <= 3; aux++) {
            Final slmt__Sales_Meeting__c smRecord = new slmt__Sales_Meeting__c();
            smRecord.DateTime__c = DateTime.newInstance(2020, 11, 9+aux*7);
            smRecord.Collaborator__c = ejecutivo.Id;
            smRecord.Type_of_meeting__c = 'Tracing';
            lstSM.add(smRecord);
        }
        insert lstSM;
    }
    
    /*
	 * @Description method getSMPlanningVisits
	 */
    @isTest
    static void unitTest() {
        Test.startTest();
        final Set<String> setSMIds = new Set<String>();
        final Set<Id> evtIds = new Set<Id>();
        for(slmt__Sales_Meeting__c slmt : [SELECT Id FROM slmt__Sales_Meeting__c LIMIT 4]) {
            setSMIds.add(slmt.Id);
        }
        if(setSMIds.size()>0) {
            for(Event evt : [SELECT Id FROM Event WHERE slmt__management_plan_meeting_id__c IN :setSMIds AND IsChild = FALSE]) {
                evtIds.add(evt.Id);
            }
            Database.executeBatch(new BE_SyncEventAttendees_Batch(evtIds));
        }
        Test.stopTest();
        final List<gcal__Event_Attendees__c> attends = [SELECT Id FROM gcal__Event_Attendees__c LIMIT 10];
        System.assertEquals(attends.size(), 4, 'success!!!');
    }
}