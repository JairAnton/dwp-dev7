/**
   -------------------------------------------------------------------------------------------------
   @Name SalesMeeting_trigger_tst
   @Author Diego Carbajal Pastor (diego.carbajal@bbva.com)
   @Date 2020-11-11
   @Description
   @Changes
   Date        Author   Email                  Type
   2020-16-11  DCP     diego.carbajal@bbva.com    Creation
   -------------------------------------------------------------------------------------------------
 */
@isTest
public class SalesMeeting_trigger_tst {

    /**
     * @Description setUp
     */
    @TestSetup
    public static void setUp() {
        Final Id ejeProfileId = BE_SM_Factory_tst.ID_EJE;
        Final Id jpnURId = [SELECT Id FROM UserRole WHERE DeveloperName = 'JEFE_PROMOCION_DE_NEGOCIO_BE_1' LIMIT 1].Id;
        Final User userGR = TestFactory.getUser(true, new Map<Schema.SObjectField, Object>{User.ProfileId => ejeProfileId, User.prof_position_id__c => 'OS8'});
        Final User userGOF = TestFactory.getUser(true, new Map<Schema.SObjectField, Object>{User.ProfileId => ejeProfileId, User.prof_position_id__c => 'E01', 
                                                                                            User.ManagerId => userGR.Id});
        //JPN's
        TestFactory.getUser(true, new Map<Schema.SObjectField, Object>{User.ProfileId => ejeProfileId, User.prof_position_id__c => 'OS9', 
            																				User.ManagerId => userGR.Id, User.UserRoleId => jpnURId });
        TestFactory.getUser(true, new Map<Schema.SObjectField, Object>{User.ProfileId => ejeProfileId, User.prof_position_id__c => 'OS9', 
                                                                    User.ManagerId => userGR.Id, User.UserRoleId => jpnURId, User.isActive => false });
        //EJECUTIVO
        TestFactory.getUser(true, new Map<Schema.SObjectField, Object>{User.ProfileId => ejeProfileId, User.prof_position_id__c => 'E03', 
                                                                                            User.ManagerId => userGOF.Id});
        //ASISTENTE
        TestFactory.getUser(true, new Map<Schema.SObjectField, Object>{User.ProfileId => ejeProfileId, User.prof_position_id__c => 'E0B', 
            																				User.ManagerId => userGOF.Id});
    }
    
    /**
     * @Description salesMeetingColOwnerTest
     */
    @isTest
    public static void salesMeetingColOwnerTest() {
        Final Id ejeId = [SELECT Id FROM User WHERE prof_position_id__c = 'E03' AND CreatedDate = TODAY  AND isActive = True LIMIT 1].Id;
        Final slmt__Sales_Meeting__c[] lstSM = new slmt__Sales_Meeting__c[]{};
		for(Integer i = 0; i < 11; i++) {
            lstSM.add(BE_SM_Factory_tst.createSalesMeeting(DateTime.newInstance(System.today().addMonths(1).year(), System.today().addMonths(1).month(), 2), ejeId, 'Planning', false));
        }
        Test.startTest();
        System.runAs(new User(Id=ejeId)) {
            insert lstSM;
        }
        Test.stopTest();
        Final slmt__Sales_Meeting__c[] slmt = [SELECT Id FROM slmt__Sales_Meeting__c WHERE OwnerId =: ejeId];
        System.assertEquals(11, slmt.size(), 'Assertion Error');
    }
    
    /**
     * @Description addRecordAccessTest
     */
    @isTest
    public static void addRecordAccessTest() {
        Final Id ejeId = [SELECT Id FROM User WHERE prof_position_id__c = 'E03' AND CreatedDate = TODAY AND isActive = True LIMIT 1].Id;
        Final Id gofId = [SELECT Id FROM User WHERE prof_position_id__c = 'E01' AND CreatedDate = TODAY AND isActive = True LIMIT 1].Id;
        Final Id jpnId = [SELECT Id FROM User WHERE prof_position_id__c = 'OS9' AND CreatedDate = TODAY AND isActive = True LIMIT 1].Id;
        Final Id assistId = [SELECT Id FROM User WHERE prof_position_id__c = 'E0B' AND CreatedDate = TODAY AND isActive = True LIMIT 1].Id;
        insert new User_Assistant_Team__c(user_id__c = ejeId, assistant_id__c = assistId);
        Final slmt__Sales_Meeting__c[] lstSM = new slmt__Sales_Meeting__c[]{};
		for(Integer i = 0; i < 11; i++) {
            lstSM.add(BE_SM_Factory_tst.createSalesMeeting(DateTime.newInstance(System.today().addMonths(1).year(), System.today().addMonths(1).month(), 2), ejeId, 'Planning', false));
            lstSM.add(BE_SM_Factory_tst.createSalesMeeting(DateTime.newInstance(System.today().addMonths(1).year(), System.today().addMonths(1).month(), 2), gofId, 'Planning', false));
        }
        Test.startTest();
        System.runAs(new User(Id=gofId)) {
        	insert lstSM;
        }
        Test.stopTest();
        Final slmt__Sales_Meeting__Share[] lstSMAssist = [SELECT Id FROM slmt__Sales_Meeting__Share WHERE UserOrGroupId =: assistId];
        Final slmt__Sales_Meeting__Share[] lstSMAJPN = [SELECT Id FROM slmt__Sales_Meeting__Share WHERE UserOrGroupId =: jpnId];
        Final Boolean validation = lstSMAssist.size() == 11 && lstSMAJPN.size() == 22;
        System.assert(validation, 'Assertion Error');
    }
    
    /**
     * @Description addRecordAccessTest
     */
    @isTest
    public static void updateEventTest() {
        Final Id ejeId = [SELECT Id FROM User WHERE prof_position_id__c = 'E03' AND CreatedDate = TODAY AND isActive = True LIMIT 1].Id;
        System.runAs(new User(Id=ejeId)) {
            BE_SM_Factory_tst.createSalesMeeting(DateTime.newInstance(System.today().addMonths(1).year(), System.today().addMonths(1).month(), 4), ejeId, 'Planning', true);
            Final slmt__Sales_Meeting__c slmt = [SELECT Id, DateTime__c FROM slmt__Sales_Meeting__c LIMIT 1];
            update new slmt__Sales_Meeting__c(Id = slmt.Id, DateTime__c = slmt.DateTime__c.addDays(1));
            Final Event evt = [SELECT Id, StartDateTime FROM Event WHERE slmt__management_plan_meeting_id__c = :slmt.Id];
            System.assertEquals(slmt.DateTime__c.addDays(1), evt.StartDateTime, 'Assertion success!!!');
        }
    }
}