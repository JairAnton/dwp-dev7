@isTest
public class SalesMeeting_trigger_tst {

    @testSetup
    public static void setUp() {
        Final Id ejeProfileId = BE_SM_Factory_tst.getEjecutivoProfile();
        Final Id jpnUR = [SELECT Id FROM UserRole WHERE DeveloperName = 'JEFE_PROMOCION_DE_NEGOCIO_BE_1' LIMIT 1].Id;
        Final User userGR = TestFactory.getUser(true, new Map<Schema.SObjectField, Object>{User.ProfileId => ejeProfileId, User.prof_position_id__c => 'OS8'});
        Final User userGOF = TestFactory.getUser(true, new Map<Schema.SObjectField, Object>{User.ProfileId => ejeProfileId, User.prof_position_id__c => 'E01', 
            																				User.ManagerId => userGR.Id});
        Final User userJPN = TestFactory.getUser(true, new Map<Schema.SObjectField, Object>{User.ProfileId => ejeProfileId, User.prof_position_id__c => 'OS9', 
            																				User.ManagerId => userGR.Id, User.UserRoleId => jpnUR });
        Final User userJPN2 = TestFactory.getUser(true, new Map<Schema.SObjectField, Object>{User.ProfileId => ejeProfileId, User.prof_position_id__c => 'OS9', 
            																				User.ManagerId => userGR.Id, User.UserRoleId => jpnUR, User.isActive => false });
        Final User userEJE = TestFactory.getUser(true, new Map<Schema.SObjectField, Object>{User.ProfileId => ejeProfileId, User.prof_position_id__c => 'E03', 
            																				User.ManagerId => userGOF.Id});
        Final User userAssist = TestFactory.getUser(true, new Map<Schema.SObjectField, Object>{User.ProfileId => ejeProfileId, User.prof_position_id__c => 'E0B', 
            																				User.ManagerId => userGOF.Id});
    }
    
    @isTest
    public static void salesMeetingColOwnerTest() {
        Final Id ejeId = [SELECT Id FROM User WHERE prof_position_id__c = 'E03' LIMIT 1].Id;
        Final slmt__Sales_Meeting__c[] lstSM = new slmt__Sales_Meeting__c[]{};
		for(Integer i = 0; i < 201; i++) {
            lstSM.add(BE_SM_Factory_tst.createSalesMeeting(DateTime.newInstance(2020, 11, 1), ejeId, 'Planning', false));
        }
        Test.startTest();
        insert lstSM;
        Test.stopTest();
        Final slmt__Sales_Meeting__c[] slmt = [SELECT Id FROM slmt__Sales_Meeting__c WHERE OwnerId =: ejeId];
        System.assertEquals(201, slmt.size(), 'Assertion Error');
    }
    
    @isTest
    public static void addRecordAccessTest() {
        Final Id ejeId = [SELECT Id FROM User WHERE prof_position_id__c = 'E03' LIMIT 1].Id;
        Final Id gofId = [SELECT Id FROM User WHERE prof_position_id__c = 'E01' LIMIT 1].Id;
        Final Id jpnId = [SELECT Id FROM User WHERE prof_position_id__c = 'OS9' LIMIT 1].Id;
        Final Id assistId = [SELECT Id FROM User WHERE prof_position_id__c = 'E0B' LIMIT 1].Id;
        insert new User_Assistant_Team__c(user_id__c = ejeId, assistant_id__c = assistId);
        Final slmt__Sales_Meeting__c[] lstSM = new slmt__Sales_Meeting__c[]{};
		for(Integer i = 0; i < 101; i++) {
            lstSM.add(BE_SM_Factory_tst.createSalesMeeting(DateTime.newInstance(2020, 11, 1), ejeId, 'Planning', false));
            lstSM.add(BE_SM_Factory_tst.createSalesMeeting(DateTime.newInstance(2020, 11, 1), gofId, 'Planning', false));
        }
        Test.startTest();
        insert lstSM;
        Test.stopTest();
        Final slmt__Sales_Meeting__Share[] lstSMAssist = [SELECT Id FROM slmt__Sales_Meeting__Share WHERE UserOrGroupId =: assistId];
        Final slmt__Sales_Meeting__Share[] lstSMAJPN = [SELECT Id FROM slmt__Sales_Meeting__Share WHERE UserOrGroupId =: jpnId];
        Final Boolean validation = (lstSMAssist.size() == 101 && lstSMAJPN.size() == 202);
        System.assert(validation, 'Assertion Error');
    }
    
}