/**
   -------------------------------------------------------------------------------------------------
   @Name BE_SM_ReasignTopics_Tst
   @Author Martin Alejandro Mori Chavez (martin.mori.contractor@bbva.com)
   @Date 2020-11-11
   @Description
   @Changes
   Date        Author   Email                  				Type
   2020-11-30  MAMCH    martin.mori.contractor@bbva.com    	Creation
   -------------------------------------------------------------------------------------------------
 */
@isTest
public class BE_SM_ReasignTopics_Tst {
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
        Final User userGOF = TestFactory.getUser(true, new Map<Schema.SObjectField, Object>{User.ProfileId => BE_SM_Factory_tst.ID_EJE, User.prof_position_id__c => 'E01'});
        Final User ejecutivo = TestFactory.getUser(true, new Map<Schema.SObjectField, Object>{User.ProfileId => BE_SM_Factory_tst.ID_EJE, User.prof_position_id__c => 'E03', User.ManagerId => userGOF.Id});
        System.runAs(ejecutivo) {
            Final slmt__Sales_Meeting__c slmt = BE_SM_Factory_tst.createSalesMeeting(Date.newInstance(2020, 11, 04), ejecutivo.Id, 'Planning', true);
            final Map<String, Schema.RecordTypeInfo> recordType = BE_General_Utils.getRecordTypeInfo(new List<String> {'Task'});
        	final String taskRTSlmt =  recordType.get('Sales_Meeting').getRecordTypeId();
        	insert new List<Task>{
                new Task(RecordTypeId=taskRTSlmt,Subject='TASK01',slmt__management_plan_meeting_id__c=slmt.Id,Status='Open',OwnerId=ejecutivo.Id,ActivityDate=Date.newInstance(2020, 11, 04)),
                new Task(RecordTypeId=taskRTSlmt,Subject='TASK02',slmt__management_plan_meeting_id__c=slmt.Id,Status='Open',OwnerId=ejecutivo.Id,ActivityDate=Date.newInstance(2020, 11, 04)),
                new Task(RecordTypeId=taskRTSlmt,Subject='TASK03',slmt__management_plan_meeting_id__c=slmt.Id,Status='Open',OwnerId=userGOF.Id,ActivityDate=Date.newInstance(2020, 11, 04))
            };
        }
    }
    
    /*
	 * @Description method test reasingTopics success
	 */
    @isTest
    static void returnUsersTest() {
        Final slmt__Sales_Meeting__c salesMeeting = [SELECT Id FROM slmt__Sales_Meeting__c LIMIT 1];
        Test.startTest();
        Final Map<String, String> mapResult = BE_SM_ReasignTopics_Ctr.returnUsers(salesMeeting.Id);
        Test.stopTest();
        System.assertEquals(mapResult.size(), 2, 'success!!!');
    }
    
    /*
	 * @Description method test reasingTopics error
	 */
    @isTest
    static void reasingTopicsNullErrorTest() {
        Test.startTest();
        Final Map<String, Object> mapResult = BE_SM_ReasignTopics_Ctr.reasingTopics(null, null);
        Test.stopTest();
        System.assert(!(Boolean)mapResult.get(ISSUCCESS), ERROR);
    }
    
    /*
	 * @Description method test reasingTopics error
	 */
    @isTest
    static void reasingTopicsIdErrorTest() {
        Test.startTest();
        Final Map<String, Object> mapResult = BE_SM_ReasignTopics_Ctr.reasingTopics('0010m0000', null);
        Test.stopTest();
        System.assert(!(Boolean)mapResult.get(ISSUCCESS), ERROR);
    }
    
    /*
	 * @Description method test reasingTopics error
	 */
    @isTest
    static void reasingTopicsUserErrorTest() {
        Final slmt__Sales_Meeting__c salesMeeting = [SELECT Id, Collaborator__c, slmt__mngmt_plan_meeting_user_id__c FROM slmt__Sales_Meeting__c LIMIT 1];
        Test.startTest();
        Final Map<String, Object> mapResult = BE_SM_ReasignTopics_Ctr.reasingTopics(salesMeeting.Id, salesMeeting.Collaborator__c);
        Test.stopTest();
        System.assert(!(Boolean)mapResult.get(ISSUCCESS), 'error usuario!!!');
    }
    
    /*
	 * @Description method reasingTopics success
	 */
    @isTest
    static void reasingTopicsCollaboTest() {
        Final slmt__Sales_Meeting__c salesMeeting = [SELECT Id, Collaborator__c, slmt__mngmt_plan_meeting_user_id__c FROM slmt__Sales_Meeting__c LIMIT 1];
        Final User assistant = [SELECT Id FROM User WHERE User.prof_position_id__c = 'E0B' AND CreatedDate = TODAY ORDER BY CreatedDate DESC LIMIT 1];
        Test.startTest();
        Boolean resBoolean = false;
        System.runAs(assistant) {
            Final Map<String, Object> mapResult = BE_SM_ReasignTopics_Ctr.reasingTopics(salesMeeting.Id, salesMeeting.Collaborator__c);
            resBoolean = (Boolean)mapResult.get(ISSUCCESS);
        }
        Test.stopTest();
        System.assert(resBoolean, 'success!!!');
    }
    
    /*
	 * @Description method reasingTopics success
	 */
    @isTest
    static void reasingTopicsManagerTest() {
        Final slmt__Sales_Meeting__c salesMeeting = [SELECT Id, Collaborator__c, slmt__mngmt_plan_meeting_user_id__c FROM slmt__Sales_Meeting__c LIMIT 1];
        Final User assistant = [SELECT Id FROM User WHERE User.prof_position_id__c = 'E0B' AND CreatedDate = TODAY ORDER BY CreatedDate DESC LIMIT 1];
        Test.startTest();
        Boolean resBoolean = false;
        System.runAs(assistant) {
            Final Map<String, Object> mapResult = BE_SM_ReasignTopics_Ctr.reasingTopics(salesMeeting.Id, salesMeeting.slmt__mngmt_plan_meeting_user_id__c);
            resBoolean = (Boolean)mapResult.get(ISSUCCESS);
        }
        Test.stopTest();
        System.assert(resBoolean, 'success!!!');
    }
}