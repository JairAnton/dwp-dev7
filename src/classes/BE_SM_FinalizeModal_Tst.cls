/**
   -------------------------------------------------------------------------------------------------
   @Name BE_SM_FinalizeModal_Tst
   @Author Martin Alejandro Mori Chavez (martin.mori.contractor@bbva.com)
   @Date 2020-11-11
   @Description
   @Changes
   Date        Author   Email                  				Type
   2020-11-11  MAMCH    martin.mori.contractor@bbva.com    	Creation
   -------------------------------------------------------------------------------------------------
 */
@isTest
public class BE_SM_FinalizeModal_Tst {
    /*
	 * @Description  method setUp
	 */
    @TestSetup
    static void setUp() {
        Final User ejecutivo = TestFactory.getUser(true, new Map<Schema.SObjectField, Object>{User.ProfileId => BE_SM_Factory_tst.getEjecutivoProfile(), User.prof_position_id__c => 'E03'});
        Final Account acc = TestFactory.getAccount(true, new Map<Schema.SObjectField, Object>{Account.OwnerId => ejecutivo.Id});
        Final Date initDate = Date.newInstance(2020, 11, 11);
        BE_SM_Factory_tst.createSalesMeeting(initDate, ejecutivo.Id, 'Planning', true);
    }
    
    /*
	 * @Description method test getStatusMeeting success
	 */
    @isTest
    static void getStatusMeetingTest() {
        Final slmt__Sales_Meeting__c salesMeeting = [SELECT Id FROM slmt__Sales_Meeting__c LIMIT 1];
        Test.startTest();
        Final Map<String, Object> mapResult = BE_SM_FinalizeModal_Ctr.getStatusMeeting(salesMeeting.Id);
        Test.stopTest();
        System.assert((Boolean)mapResult.get('isSuccess'), 'success!!!');
    }
    
    /*
	 * @Description method test getStatusMeeting error
	 */
    @isTest
    static void getStatusMeetingNullErrorTest() {
        Test.startTest();
        Final Map<String, Object> mapResult = BE_SM_FinalizeModal_Ctr.getStatusMeeting(null);
        Test.stopTest();
        System.assert(!(Boolean)mapResult.get('isSuccess'), 'error!!!');
    }
    
    /*
	 * @Description method test getStatusMeeting error
	 */
    @isTest
    static void getStatusMeetingIdErrorTest() {
        Test.startTest();
        Final Map<String, Object> mapResult = BE_SM_FinalizeModal_Ctr.getStatusMeeting('0010m0000');
        Test.stopTest();
        System.assert(!(Boolean)mapResult.get('isSuccess'), 'error!!!');
    }
    
    /*
	 * @Description method test getStatusMeeting error
	 */
    @isTest
    static void getStatusMeetingStatusErrorTest() {
        Final slmt__Sales_Meeting__c salesMeeting = [SELECT Id FROM slmt__Sales_Meeting__c LIMIT 1];
        Final slmt__Sales_Meeting__c updateSM = new slmt__Sales_Meeting__c(Id=salesMeeting.Id, slmt__mngmt_plan_meeting_status_name__c='Finalized');
        update updateSM;
        Test.startTest();
        Final Map<String, Object> mapResult = BE_SM_FinalizeModal_Ctr.getStatusMeeting(updateSM.Id);
        Test.stopTest();
        System.assert(!(Boolean)mapResult.get('isSuccess'), 'error!!!');
    }
    
    /*
	 * @Description method finalizeMeeting success
	 */
    @isTest
    static void finalizeMeetingTest() {
        Final slmt__Sales_Meeting__c salesMeeting = [SELECT Id FROM slmt__Sales_Meeting__c LIMIT 1];
        Test.startTest();
        Final Map<String, Object> mapResult = BE_SM_FinalizeModal_Ctr.finalizeMeeting(salesMeeting.Id, 'test summary');
        Test.stopTest();
        System.assert((Boolean)mapResult.get('isSuccess'), 'success!!!');
    }
    
    /*
	 * @Description method finalizeMeeting success
	 */
    @isTest
    static void finalizeMeetingNullErrorTest() {
        Test.startTest();
        Final Map<String, Object> mapResult = BE_SM_FinalizeModal_Ctr.finalizeMeeting(null, 'test summary');
        Test.stopTest();
        System.assert(!(Boolean)mapResult.get('isSuccess'), 'error!!!');
    }
    
    /*
	 * @Description method finalizeMeeting success
	 */
    @isTest
    static void finalizeMeetingIdErrorTest() {
        Test.startTest();
        Final Map<String, Object> mapResult = BE_SM_FinalizeModal_Ctr.finalizeMeeting('0010m0000', 'test summary');
        Test.stopTest();
        System.assert(!(Boolean)mapResult.get('isSuccess'), 'error!!!');
    }
}