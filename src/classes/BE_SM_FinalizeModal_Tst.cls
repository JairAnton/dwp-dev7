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
    /*   @Variable: ERROR
	 */
	public static Final String ERROR = 'error!!!';
    /*   @Variable: ISSUCCESS
	 */
	public static Final String ISSUCCESS = 'isSuccess';
    
    /*
	 * @Description  method setUp
	 */
    @TestSetup
    static void setUp() {
        Final User ejecutivo = TestFactory.getUser(true, new Map<Schema.SObjectField, Object>{User.ProfileId => BE_SM_Factory_tst.ID_EJE, User.prof_position_id__c => 'E03'});
        System.runAs(ejecutivo) {
            BE_SM_Factory_tst.createSalesMeeting(Date.newInstance(2020, 11, 04), ejecutivo.Id, 'Planning', true);
        }
    }
    
    /*
	 * @Description method test getStatusMeeting success
	 */
    @isTest
    static void getStatusMeetingTest() {
        Final slmt__Sales_Meeting__c salesMeeting = [SELECT Id, Collaborator__c FROM slmt__Sales_Meeting__c LIMIT 1];
        Test.startTest();
        Boolean resBoolean = false;
        System.runAs(new User(Id=salesMeeting.Collaborator__c)) {
            Final Map<String, Object> mapResult = BE_SM_FinalizeModal_Ctr.getStatusMeeting(salesMeeting.Id);
            resBoolean = (Boolean)mapResult.get(ISSUCCESS);
        }
        Test.stopTest();
        System.assert(resBoolean, 'success!!!');
    }
    
    /*
	 * @Description method test getStatusMeeting error
	 */
    @isTest
    static void getStatusMeetingNullErrorTest() {
        Final slmt__Sales_Meeting__c salesMeeting = [SELECT Id, Collaborator__c FROM slmt__Sales_Meeting__c LIMIT 1];
        Test.startTest();
        Boolean resBoolean = false;
        System.runAs(new User(Id=salesMeeting.Collaborator__c)) {
            Final Map<String, Object> mapResult = BE_SM_FinalizeModal_Ctr.getStatusMeeting(null);
            resBoolean = (Boolean)mapResult.get(ISSUCCESS);
        }
        Test.stopTest();
        System.assert(!resBoolean, ERROR);
    }
    
    /*
	 * @Description method test getStatusMeeting error
	 */
    @isTest
    static void getStatusMeetingIdErrorTest() {
        Final slmt__Sales_Meeting__c salesMeeting = [SELECT Id, Collaborator__c FROM slmt__Sales_Meeting__c LIMIT 1];
        Test.startTest();
        Boolean resBoolean = false;
        System.runAs(new User(Id=salesMeeting.Collaborator__c)) {
            Final Map<String, Object> mapResult = BE_SM_FinalizeModal_Ctr.getStatusMeeting('0010m0000');
            resBoolean = (Boolean)mapResult.get(ISSUCCESS);
        }
        Test.stopTest();
        System.assert(!resBoolean, ERROR);
    }
    
    /*
	 * @Description method test getStatusMeeting error
	 */
    @isTest
    static void getStatusMeetingStatusErrorTest() {
        Final slmt__Sales_Meeting__c salesMeeting = [SELECT Id, Collaborator__c FROM slmt__Sales_Meeting__c LIMIT 1];
        Test.startTest();
        Boolean resBoolean = false;
        System.runAs(new User(Id=salesMeeting.Collaborator__c)) {
            Final slmt__Sales_Meeting__c updateSM = new slmt__Sales_Meeting__c(Id=salesMeeting.Id, slmt__mngmt_plan_meeting_status_name__c='Finalized');
            update updateSM;
            Final Map<String, Object> mapResult = BE_SM_FinalizeModal_Ctr.getStatusMeeting(updateSM.Id);
            resBoolean = (Boolean)mapResult.get(ISSUCCESS);
        }
        Test.stopTest();
        System.assert(!resBoolean, ERROR);
    }
    
    /*
	 * @Description method finalizeMeeting success
	 */
    @isTest
    static void finalizeMeetingTest() {
        Final slmt__Sales_Meeting__c salesMeeting = [SELECT Id, Collaborator__c FROM slmt__Sales_Meeting__c LIMIT 1];
        Test.startTest();
        Boolean resBoolean = false;
        System.runAs(new User(Id=salesMeeting.Collaborator__c)) {
            Final Map<String, Object> mapResult = BE_SM_FinalizeModal_Ctr.finalizeMeeting(salesMeeting.Id, 'test summary');
            resBoolean = (Boolean)mapResult.get(ISSUCCESS);
        }
        Test.stopTest();
        System.assert(resBoolean, 'success!!!');
    }
    
    /*
	 * @Description method finalizeMeeting success
	 */
    @isTest
    static void finalizeMeetingNullErrorTest() {
        Final slmt__Sales_Meeting__c salesMeeting = [SELECT Id, Collaborator__c FROM slmt__Sales_Meeting__c LIMIT 1];
        Test.startTest();
        Boolean resBoolean = false;
        System.runAs(new User(Id=salesMeeting.Collaborator__c)) {
            Final Map<String, Object> mapResult = BE_SM_FinalizeModal_Ctr.finalizeMeeting(null, 'test summary');
            resBoolean = (Boolean)mapResult.get(ISSUCCESS);
        }
        Test.stopTest();
        System.assert(!resBoolean, ERROR);
    }
    
    /*
	 * @Description method finalizeMeeting success
	 */
    @isTest
    static void finalizeMeetingIdErrorTest() {
        Final slmt__Sales_Meeting__c salesMeeting = [SELECT Id, Collaborator__c FROM slmt__Sales_Meeting__c LIMIT 1];
        Test.startTest();
        Boolean resBoolean = false;
        System.runAs(new User(Id=salesMeeting.Collaborator__c)) {
            Final Map<String, Object> mapResult = BE_SM_FinalizeModal_Ctr.finalizeMeeting('0010m0000', 'test summary');
            resBoolean = (Boolean)mapResult.get(ISSUCCESS);
        }
        Test.stopTest();
        System.assert(!resBoolean, ERROR);
    }
}